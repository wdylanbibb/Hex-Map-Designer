extends "res://tools/hex/HexTilemap.gd"


var _ready : bool

onready var decor = $Decor
onready var counties = $Counties
#onready var river = $River

# warning-ignore:function_conflicts_variable
func _ready() -> void:
	
	for cell in get_used_cells():
		update_bitmask_area(cell)
	
	randomize()
	for cell in get_used_cells():
		_set_decor(cell.x, cell.y, get_cellv(cell))
	
#	for cell in river.get_used_cells():
#		river.update_bitmask_area(cell)
	
	_ready = true


func update_bitmask_area(position: Vector2):
	.update_bitmask_area(position)
	decor.update_bitmask_area(position)


func update_bitmask_region(start: Vector2 = Vector2.ZERO, end: Vector2 = Vector2.ZERO):
	.update_bitmask_region(start, end)
	decor.update_bitmask_region(start, end)


func set_cell(x: int, y: int, tile: int, flip_x: bool = false, flip_y: bool = false, transpose: bool = false, autotile_coord: Vector2 = Vector2( 0, 0 )):
	.set_cell(x, y, tile, flip_x, flip_y, transpose, autotile_coord)
	if _ready:
		if not decor:
			decor = $Decor
		else:
			_set_decor(x, y, tile)
	if tile == -1:
		if not counties.get_cell(x, y) == -1:
			counties.set_cell(x, y, -1)
			counties.update_bitmask_area(Vector2(x, y))

func set_cellv(position: Vector2, tile: int, flip_x: bool = false, flip_y: bool = false, transpose: bool = false):
	.set_cellv(position, tile, flip_x, flip_y, transpose)


func _set_decor(x: int, y: int, tile: int):
	match tile:
#		0: # Grass
#			pass
		1: # Desert
			if round(rand_range(1, 10)) == 5:
# warning-ignore:narrowing_conversion
				decor.set_cell(x, y, 1, bool(round(rand_range(0, 1))), false, false, Vector2(round(rand_range(0, 1)), 0))
			else:
				decor.set_cell(x, y, -1)
		2: # Forest
			decor.set_cell(x, y, 0)
#		3: # Water
#			pass
		4: #Mountain
			decor.set_cell(x, y, 2)
		_:
			decor.set_cell(x, y, -1)
	decor.update_bitmask_area(Vector2(x, y))
	
