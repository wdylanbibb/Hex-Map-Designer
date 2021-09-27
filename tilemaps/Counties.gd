extends "res://tools/hex/HexTilemap.gd"

func _ready() -> void:
	for cell in get_used_cells():
		update_bitmask_area(cell)
