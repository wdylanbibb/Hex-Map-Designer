extends "res://tools/hex/HexTilemap.gd"



var _ready : bool


onready var Renderer = get_parent()
# warning-ignore:function_conflicts_variable
func _ready() -> void:
	yield(get_parent(), "ready")
	
	for cell in get_used_cells():
		update_bitmask_area(cell)
	
	randomize()
	for cell in get_used_cells():
		_set_decor(cell.x, cell.y, get_cellv(cell))

	for cell in Renderer.river.get_used_cells():
		Renderer.update_area(Renderer.RIVER, cell)
	
	_ready = true


func update_bitmask_area(position: Vector2):
	.update_bitmask_area(position)
	Renderer.update_area(Renderer.DECOR, position)


func set_cell(x: int, y: int, tile: int, flip_x: bool = false, flip_y: bool = false, transpose: bool = false, autotile_coord: Vector2 = Vector2( 0, 0 )):
	.set_cell(x, y, tile, flip_x, flip_y, transpose, autotile_coord)
	if _ready:
		_set_decor(x, y, tile)
	if tile == -1:
		if not Renderer.get_cell(Renderer.FACTION, x, y) == -1:
			Renderer.set_cell(Renderer.FACTION, x, y, -1)
			Renderer.update_area(Renderer.FACTION, Vector2(x, y))
	else:
		if not Renderer.get_cell(Renderer.FACTION, x, y) == -1:
			if not Renderer.faction.check_valid(Vector2(x, y)):
				Renderer.set_cell(Renderer.FACTION, x, y, -1)
				Renderer.update_area(Renderer.FACTION, Vector2(x, y))


func _set_decor(x: int, y: int, tile: int):
	if Renderer.get_cell(Renderer.DECOR, x, y) == 3:
		pass
	else:
		match tile:
			0: #Grass
				Renderer.set_cell(Renderer.DECOR, x, y, -1)
			1: # Desert
				if round(rand_range(1, 10)) == 5:
					Renderer.set_cell(Renderer.DECOR, x, y, 1)
				else:
					Renderer.set_cell(Renderer.DECOR, x, y, 1)
			2: # Forest
				Renderer.set_cell(Renderer.DECOR, x, y, 0)
			3: #Water
				Renderer.set_cell(Renderer.DECOR, x, y, -1)
			4: #Mountain
				Renderer.set_cell(Renderer.DECOR, x, y, 2)
			_:
				Renderer.set_cell(Renderer.DECOR, x, y, -1)
		Renderer.update_area(Renderer.DECOR, Vector2(x, y))
	
