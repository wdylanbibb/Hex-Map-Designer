extends "res://tools/hex/HexTilemap.gd"

var holding_texture = preload("res://assets/sprites/tiles/tilesets/holding_borders.png")


func _init() -> void:
	
	for holding in HoldingsUnpacker.Holdings:
		var id = tile_set.get_last_unused_tile_id()
		tile_set.create_tile(id)
		tile_set.tile_set_tile_mode(id, TileSet.ATLAS_TILE)
		tile_set.autotile_set_size(id, Vector2(64, 32))
		tile_set.tile_set_modulate(id, Color(holding.color) if holding.has("color") else Color(rand_range(0, 1), rand_range(0, 1), rand_range(0, 1)))
		tile_set.tile_set_name(id, holding.name if holding.has("name") else "[NEW_HOLDING]")
		tile_set.tile_set_z_index(id, 1)
		tile_set.tile_set_texture(id, holding_texture)
		tile_set.tile_set_region(id, Rect2(Vector2.ZERO, Vector2(64, 32) * 8))
