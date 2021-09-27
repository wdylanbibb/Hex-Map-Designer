#warning-ignore-all:narrowing_conversion
extends TileMap

export(NodePath) var Hex
export(bool) var only_match_with_same_tile = false


onready var _Hex = get_node(Hex)


func update_bitmask_area(position: Vector2):
	var curr_cell = _Hex.pixel_to_hex(map_to_world(position))

	for cell in curr_cell.get_all_adjacent():
#		if only_match_with_same_tile:
#			_toggle_edge_bit(position.x, position.y, _Hex.vector_to_edge_bit(cell.cube - curr_cell.cube), get_cellv(hex_to_cell(cell)) == get_cellv(position))
#		else:
		_toggle_edge_bit(position.x, position.y, _Hex.vector_to_edge_bit(cell.cube - curr_cell.cube), get_cellv(hex_to_cell(cell)) >= 0)
		var next_pos = hex_to_cell(cell)
		for _cell in cell.get_all_adjacent():
#			if only_match_with_same_tile:
#				_toggle_edge_bit(next_pos.x, next_pos.y, _Hex.vector_to_edge_bit(_cell.cube - cell.cube), get_cellv(hex_to_cell(_cell)) == get_cellv(next_pos))
#			else:
			_toggle_edge_bit(next_pos.x, next_pos.y, _Hex.vector_to_edge_bit(_cell.cube - cell.cube), get_cellv(hex_to_cell(_cell)) >= 0)


func update_bitmask_region(start: Vector2 = Vector2.ZERO, end: Vector2 = Vector2.ZERO):
	for x in range(start.x, end.x):
		for y in range(start.y, end.y):
			update_bitmask_area(Vector2(x, y))


func _toggle_edge_bit(x: int, y: int, edge: int, on: bool) -> void:
	if not edge == 0:
		var id: int = _coord_to_id(x, y)
		if x == 18 and y == 29 and not id == 0:
			print(Vector2(x, y))
			print("Edge: ", edge, ", On: ", on, " AutoTile Coord: ", get_cell_autotile_coord(x, y))
			print("Before Bits: ", id)
		id ^= (-(1 if on else 0)^id) & (edge)
		if x == 18 and y == 29 and not id == 0:
			print("After Bits: ", id)
			print()
		set_cell(x, y, get_cell(x, y), false, false, false, _edge_id_to_coord(id))


func hex_to_cell(cell: HexGrid.HexCell) -> Vector2:
	var c = world_to_map(_Hex.hex_to_pixel(cell))
#	c.y += fmod(c.x, 2)
	return c


func _coord_to_id(x: int, y: int) -> int:
	var coord = get_cell_autotile_coord(x, y)
	return coord.x + 8 * coord.y


func _coord_to_idv(c: Vector2) -> int:
	return _coord_to_id(c.x, c.y)


func _edge_id_to_coord(id: int) -> Vector2:
#	print(id)
	return Vector2(id%8, ceil(id/8.0))
