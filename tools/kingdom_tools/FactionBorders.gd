extends "res://tools/hex/HexTilemap.gd"

var faction_texture = preload("res://assets/sprites/tiles/tilesets/holding_borders.png")


func _init() -> void:
	create_faction_tiles(HoldingsUnpacker.FactionResources)


func create_faction_tiles(faction_resources: Array):
	for idx in range(faction_resources.size()):
		var faction = faction_resources[idx]
		var id = idx
		tile_set.create_tile(id)
		tile_set.tile_set_tile_mode(id, TileSet.ATLAS_TILE)
		tile_set.autotile_set_size(id, Vector2(64, 32))
		tile_set.tile_set_modulate(id, faction.color)
		tile_set.tile_set_name(id, faction.name)
		tile_set.tile_set_z_index(id, 1)
		tile_set.tile_set_texture(id, faction_texture)
		tile_set.tile_set_region(id, Rect2(Vector2.ZERO, Vector2(64, 32) * 8))
