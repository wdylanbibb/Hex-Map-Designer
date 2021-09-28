extends "res://tools/hex/HexTilemap.gd"

var holding_texture = preload("res://assets/sprites/tiles/tilesets/holding_base.png")
export(int, FLAGS, "NW", "N", "NE", "SE", "S", "SW") var match_override

func _init() -> void:
	
	var file = File.new()
	file.open("objects/holdings/holdings.json", File.READ)
	var content = file.get_as_text()
	var holdings = JSON.parse(content).result
	if typeof(holdings)==TYPE_DICTIONARY:
		pass
	else:
		print("Unexpected results found in holdings.json.")
		return
	file.close()
	
	for holding in holdings.holdings:
		var id = tile_set.get_last_unused_tile_id()
		tile_set.create_tile(id)
		tile_set.tile_set_tile_mode(id, TileSet.ATLAS_TILE)
		tile_set.autotile_set_size(id, Vector2(64, 32))
		tile_set.tile_set_modulate(id, Color(holding.color) if holding.has("color") else Color(rand_range(0, 1), rand_range(0, 1), rand_range(0, 1)))
		tile_set.tile_set_name(id, holding.name if holding.has("name") else "[NEW_HOLDING]")
		tile_set.tile_set_z_index(id, 1)
		tile_set.tile_set_texture(id, holding_texture)
		tile_set.tile_set_region(id, Rect2(Vector2.ZERO, Vector2(64, 32) * 8))


onready var land_map = get_parent()

func _ready() -> void:
	for cell in get_used_cells():
		update_bitmask_area(cell)


func check_on(current_cell, check_cell) -> bool:
	if only_match_with_same_tile:
		if not get_cellv(check_cell) == get_cellv(current_cell) and not get_cellv(check_cell) == -1 and match_override & (1 << (tilemap_to_direction(check_cell-current_cell))):
			return true
	return .check_on(current_cell, check_cell)


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
