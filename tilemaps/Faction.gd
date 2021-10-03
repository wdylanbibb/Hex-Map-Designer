extends "res://tools/hex/HexTilemap.gd"

var faction_texture = preload("res://assets/sprites/tiles/tilesets/holding_base.png")
var highlight_shader = preload("res://assets/shaders/highlight.shader")

func _init() -> void:
	create_faction_tiles(HoldingsUnpacker.FactionResources)


func create_faction_tiles(faction_resources : Array):
	for idx in range(faction_resources.size()):
		var faction = faction_resources[idx]
		var id = idx
		tile_set.create_tile(id)
		tile_set.tile_set_tile_mode(id, TileSet.ATLAS_TILE)
		tile_set.autotile_set_size(id, Vector2(64, 32))
		tile_set.tile_set_name(id, faction.name)
		tile_set.tile_set_z_index(id, 1)
		tile_set.tile_set_texture(id, faction_texture)
		tile_set.tile_set_region(id, Rect2(Vector2.ZERO, Vector2(64, 32) * 8))
		
		var mat = ShaderMaterial.new()
		mat.shader = highlight_shader
		tile_set.tile_set_material(id, mat)
		tile_set.tile_get_material(id).set_shader_param("highlight", 0)
		tile_set.tile_get_material(id).set_shader_param("modulate", faction.color)


onready var Renderer = get_parent()

func _ready() -> void:
	yield(Renderer, "ready")
	
	for cell in get_used_cells():
		update_bitmask_area(cell)


func set_cell(x: int, y: int, tile: int, flip_x: bool = false, flip_y: bool = false, transpose: bool = false, autotile_coord: Vector2 = Vector2( 0, 0 )):
	.set_cell(x, y, tile, flip_x, flip_y, transpose, autotile_coord)


func update_bitmask_area(position: Vector2):
	.update_bitmask_area(position)


func set_highlight(tile, highlight: float):
	tile_set.tile_get_material(tile).set_shader_param("highlight", highlight)


func check_valid(cell: Vector2) -> bool:
	match Renderer.get_cell(Renderer.LAND, cell.x, cell.y):
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
