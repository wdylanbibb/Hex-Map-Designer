extends "res://tools/hex/HexTilemap.gd"

var holding_texture = preload("res://assets/sprites/tiles/tilesets/holding_base.png")
var highlight_shader = preload("res://assets/shaders/highlight.shader")


#onready var county_borders = $CountyBorders

func _init() -> void:
	for holding in HoldingsUnpacker.Holdings:
		var id = tile_set.get_last_unused_tile_id()
		tile_set.create_tile(id)
		tile_set.tile_set_tile_mode(id, TileSet.ATLAS_TILE)
		tile_set.autotile_set_size(id, Vector2(64, 32))
		tile_set.tile_set_name(id, holding.name if holding.has("name") else "[NEW_HOLDING]")
		tile_set.tile_set_z_index(id, 1)
		tile_set.tile_set_texture(id, holding_texture)
		tile_set.tile_set_region(id, Rect2(Vector2.ZERO, Vector2(64, 32) * 8))
		
		var mat = ShaderMaterial.new()
		mat.shader = highlight_shader
		tile_set.tile_set_material(id, mat)
		tile_set.tile_get_material(id).set_shader_param("highlight", 0)
		tile_set.tile_get_material(id).set_shader_param("modulate", Color(holding.color) if holding.has("color") else Color(rand_range(0, 1), rand_range(0, 1), rand_range(0, 1)))


onready var land_map = get_parent()

func _ready() -> void:
	for cell in get_used_cells():
		update_bitmask_area(cell)


func set_cell(x: int, y: int, tile: int, flip_x: bool = false, flip_y: bool = false, transpose: bool = false, autotile_coord: Vector2 = Vector2( 0, 0 )):
	.set_cell(x, y, tile, flip_x, flip_y, transpose, autotile_coord)
#	if not county_borders:
#		county_borders = $CountyBorders
#	county_borders.set_cell(x, y, tile, flip_x, flip_y, transpose, autotile_coord)


func update_bitmask_area(position: Vector2):
	.update_bitmask_area(position)
#	county_borders.update_bitmask_area(position)


func set_highlight(tile, highlight: float):
	tile_set.tile_get_material(tile).set_shader_param("highlight", highlight)


func check_valid(cell: Vector2) -> bool:
	match land_map.get_cellv(cell):
		0: # Grass
			return true
		1: # Desert
			return true
		2: # Forest
			return true
		3: # Water
			return false
		4: #Mountain
			return false
		_:
			return false
