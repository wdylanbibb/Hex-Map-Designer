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
	print(match_override >> int(log(32)/log(2)) & 1)


func check_on(current_cell, check_cell) -> bool:
	if get_cellv(check_cell) == -1:
		return false
	else:
		if not get_cellv(current_cell) == -1 and not get_cellv(check_cell) == get_cellv(current_cell):
			print(tilemap_to_direction(current_cell, check_cell))
			return bool(match_override >> int(log(tilemap_to_direction(current_cell, check_cell))/log(2)) & 1)
		return get_cellv(check_cell) == get_cellv(current_cell) if only_match_with_same_tile else true


func is_kth_bit_set(n, k):
	if bool(n & (k)):
		print("Set")
	else:
		print("Not set")


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
