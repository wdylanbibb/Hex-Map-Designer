extends Node2D
#class_name HexGrid

const LAYOUT_POINTY := Transform2D(
	Vector2(sqrt(3.0), sqrt(3.0) / 2.0),
	Vector2(0.0, 3.0 / 2.0),
	Vector2(0.0, 0.0)
)

const LAYOUT_FLAT := Transform2D(
	Vector2(3.0 / 2.0, 0.0),
	Vector2(sqrt(3.0) / 2.0, sqrt(3.0)),
	Vector2(0.0, 0.0)
)

#const DIR_NW = Vector3(0, -1, 1)
#const DIR_NE = Vector3(1, -1, 0)
#const DIR_E = Vector3(1, 0, -1)
#const DIR_SE = Vector3(0, 1, -1)
#const DIR_SW = Vector3(-1, 1, 0)
#const DIR_W = Vector3(-1, 0, 1)
#const DIR_ALL = [DIR_NW, DIR_NE, DIR_E, DIR_SE, DIR_SW, DIR_W]

#const DIR_NW = Vector3(1, 0, -1)
#const DIR_N = Vector3(0, 1, -1)
#const DIR_NE = Vector3(-1, 1, 0)
#const DIR_SE = Vector3(-1, 0, 1)
#const DIR_S = Vector3(0, -1, 1)
#const DIR_SW = Vector3(1, -1, 0)
#const DIR_ALL = [DIR_NW, DIR_N, DIR_NE, DIR_SE, DIR_S, DIR_SW]

const DIR_NW = Vector3(-1, 0, 1)
const DIR_N = Vector3(0, -1, 1)
const DIR_NE = Vector3(1, -1, 0)
const DIR_SE = Vector3(1, 0, -1)
const DIR_S = Vector3(0, 1, -1)
const DIR_SW = Vector3(-1, 1, 0)
const DIR_ALL = [DIR_NW, DIR_N, DIR_NE, DIR_SE, DIR_S, DIR_SW]

enum {
	NW = 1
	N = 2
	NE = 4
	SE = 8
	S = 16
	SW = 32
}


var layout : Transform2D = LAYOUT_FLAT
var size = Vector2(32, 30/sqrt(3))
#var size : Vector2

var _hex_transform_inv
var _start_angle

func _init() -> void:
	_hex_transform_inv = layout.affine_inverse()
	_start_angle = 0.0 if layout == LAYOUT_FLAT else 0.5

func hex_to_pixel(hex: HexCell) -> Vector2:
	return (layout.xform_inv(hex.axial) * size) + layout.origin

func pixel_to_hex(point: Vector2) -> HexCell:
	var pt = layout.affine_inverse().xform_inv((point - layout.origin) / size)
	return HexCell.hex_round(Vector3(pt.x, pt.y, -pt.x - pt.y))

func get_closest_hex(point: Vector2) -> Vector2:
	return hex_to_pixel(pixel_to_hex(point))

func get_closest_edge(point: Vector2) -> Vector2:
	return hex_edge_to_pixel(pixel_to_hex_edge(point))

func pixel_to_hex_edge(point: Vector2) -> HexCell:
	var pt = layout.affine_inverse().xform_inv((point - layout.origin) / (size/2))
	return HexCell.hex_round(Vector3(pt.x, pt.y, -pt.x - pt.y))

func hex_edge_to_pixel(hex: HexCell) -> Vector2:
	return (layout.xform_inv(hex.axial) * (size/2)) + layout.origin

func hex_corner_offset(corner: int, size_override := size) -> Vector2:
	var _angle = 2.0 * PI * (_start_angle + corner) / 6
	return Vector2(size_override.x * cos(_angle), size_override.y * sin(_angle))

func polygon_corners(size_override := size) -> PoolVector2Array:
	var corners : PoolVector2Array = []
	var center = Vector2.ZERO
	for i in range(6):
		var offset := hex_corner_offset(i, size_override)
		corners.push_back(center + offset)
	return corners

func vector_to_edge_bit(direction: Vector3) -> int:
	return int(pow(2, DIR_ALL.find(direction)))

func edge_bit_to_vector(edge_bit: int) -> Vector3:
	match edge_bit:
		NW:
			return DIR_NW
		N:
			return DIR_N
		NE:
			return DIR_NE
		SE:
			return DIR_SE
		S:
			return DIR_S
		SW:
			return DIR_SW
		_:
			return Vector3.ZERO

func get_opposite_edge(edge_bit: int) -> int:
	match edge_bit:
		NW:
			return SE
		N:
			return S
		NE:
			return SW
		SE:
			return NW
		S:
			return N
		SW:
			return NE
		_:
			return -1



class HexCell:
	var cube : Vector3 setget set_cube_coords, get_cube_coords
	var axial : Vector2 setget set_axial_coords, get_axial_coords
	
	func get_cube_coords():
		return cube
	
	func set_cube_coords(val):
		cube = obj_to_cube(val)
	
	func set_axial_coords(val):
		axial = obj_to_axial(val)
	
	func get_axial_coords():
		return axial
	
	func _init(coords = Vector3.ZERO) -> void:
		self.cube = obj_to_cube(coords)
		self.axial = cube_to_axial(cube)
	
	func _to_string() -> String:
		return "{" + String(cube.x )+ ", " + String(cube.y) + ", " + String(cube.z) + "}"
	
	#   /   \      /   \
	#  /x    \    /q(x) \
	# |       |  |       |
	# |      z|  |   (y)r|
	#  \y    /    \     /
	#   \   /      \   /
	
	func obj_to_cube(val) -> Vector3:
		match typeof(val):
			TYPE_VECTOR3:
				return val
			TYPE_VECTOR2:
				return axial_to_cube(val)
			_:
				if val.has_method("get_cube_coords"):
					return val.get_cube_coords()
				print("Unknown variable passed to obj_to_cube!")
				return Vector3.ZERO
	
	func obj_to_axial(val) -> Vector2:
		match typeof(val):
			TYPE_VECTOR2:
				return val
			TYPE_VECTOR3:
				return cube_to_axial(val)
			_:
				print("Unknown variable passed to obj_to_axial!")
				return Vector2.ZERO
	
	func cube_to_axial(cube_: Vector3) -> Vector2:
		var q = cube_.x
		var r = cube_.y
		return Vector2(q, r)
	
	func axial_to_cube(axial_: Vector2) -> Vector3:
		var x = axial_.x
		var y = axial_.y
		return Vector3(x, y, -x - y)
	
	func get_adjacent(dir_: Vector3) -> HexCell:
		# Returns a HexCell instance for the given direction from this.
		# Intended for one of the DIR_* consts, but really any Vector2 or x+y+z==0 Vector3 will do.
		return HexCell.new(self.cube + dir_)

	func get_all_adjacent() -> Array:
		# Returns an array of HexCell instances representing adjacent locations
		var cells = []
		for coord in DIR_ALL:
			cells.append(HexCell.new(self.cube + coord))
		return cells

	func get_all_within(distance: int) -> Array:
		# Returns an array of all HexCell instances within the given distance
		var cells = []
		for dx in range(-distance, distance+1):
			for dy in range(max(-distance, -distance - dx), min(distance, distance - dx) + 1):
				cells.append(HexCell.new(self.axial + Vector2(dx, dy)))
		return cells

	func get_ring(distance: int) -> Array:
		# Returns an array of all HexCell instances at the given distance
		if distance < 1:
			return [HexCell.new(self.cube)]
		# Start at the top (+y) and walk in a clockwise circle
		var cells = Array()
		var current = HexCell.new(self.cube + (DIR_NW * distance))
		for dir in [DIR_N, DIR_NE, DIR_SE, DIR_S, DIR_SW]:
			for _step in range(distance):
				cells.append(current)
				current = current.get_adjacent(dir)
		return cells

	func distance_to(target) -> int:
		# Returns the number of hops from this hex to another
		# Can be passed cube or axial coords, or another HexCell instance
		target = obj_to_cube(target)
		return int((
				abs(cube.x - target.x)
				+ abs(cube.y - target.y)
				+ abs(cube.z - target.z)
				) / 2)

	func line_to(target) -> Array:
		# Returns an array of HexCell instances representing
		# a straight path from here to the target, including both ends
		target = obj_to_cube(target)
		# End of our lerp is nudged so it never lands exactly on an edge
		var nudged_target = target + Vector3(1e-6, 2e-6, -3e-6)
		var steps = distance_to(target)
		var path = []
		for dist in range(steps):
			var lerped = cube.linear_interpolate(nudged_target, float(dist) / steps)
			path.append(HexCell.new(hex_round(lerped)))
		path.append(HexCell.new(target))
		return path
	
	static func hex_round(h: Vector3) -> HexCell:
		var rounded = h.round().floor()
		
		var diffs = (rounded - h).abs()
		if diffs.x > diffs.y and diffs.x > diffs.z:
			rounded.x = -rounded.y - rounded.z
		elif diffs.y > diffs.z:
			rounded.y = -rounded.x - rounded.z
		else:
			rounded.z = -rounded.x - rounded.y
		return HexCell.new(rounded)
