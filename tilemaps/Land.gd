extends "res://tools/hex/HexTilemap.gd"


var _ready : bool

# warning-ignore:function_conflicts_variable
func _ready() -> void:
	yield(WorldRenderer, "ready")
	
	for cell in get_used_cells():
		update_bitmask_area(cell)
	
	randomize()
	for cell in get_used_cells():
		_set_decor(cell.x, cell.y, get_cellv(cell))

	for cell in WorldRenderer.river.get_used_cells():
		WorldRenderer.update_area(WorldRenderer.RIVER, cell)
	
	_ready = true


func update_bitmask_area(position: Vector2):
	.update_bitmask_area(position)
	WorldRenderer.update_area(WorldRenderer.DECOR, position)


func set_cell(x: int, y: int, tile: int, flip_x: bool = false, flip_y: bool = false, transpose: bool = false, autotile_coord: Vector2 = Vector2( 0, 0 )):
	.set_cell(x, y, tile, flip_x, flip_y, transpose, autotile_coord)
	if _ready:
		_set_decor(x, y, tile)
	if tile == -1:
		if not WorldRenderer.get_cell(WorldRenderer.FACTION, x, y) == -1:
			WorldRenderer.set_cell(WorldRenderer.FACTION, x, y, -1)
			WorldRenderer.update_bitmask_area(WorldRenderer.FACTION, Vector2(x, y))
	else:
		if not WorldRenderer.get_cell(WorldRenderer.FACTION, x, y) == -1:
			if not WorldRenderer.faction.check_valid(Vector2(x, y)):
				WorldRenderer.set_cell(WorldRenderer.FACTION, x, y, -1)
				WorldRenderer.update_area(WorldRenderer.FACTION, Vector2(x, y))


func _set_decor(x: int, y: int, tile: int):
	match tile:
		0: # Grass
			pass
		1: # Desert
			if round(rand_range(1, 10)) == 5:
				WorldRenderer.set_cell(WorldRenderer.DECOR, x, y, 1)
			else:
				WorldRenderer.set_cell(WorldRenderer.DECOR, x, y, 1)
		2: # Forest
			WorldRenderer.set_cell(WorldRenderer.DECOR, x, y, 0)
		3: # Water
			pass
		4: #Mountain
			WorldRenderer.set_cell(WorldRenderer.DECOR, x, y, 2)
		_:
			WorldRenderer.set_cell(WorldRenderer.DECOR, x, y, WorldRenderer.get_cell(WorldRenderer.DECOR, x, y))
	WorldRenderer.update_area(WorldRenderer.DECOR, Vector2(x, y))
	
