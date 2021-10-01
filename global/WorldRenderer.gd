extends Node2D

enum {
	LAND
	RIVER
	DECOR
	FACTION
}


onready var land = $Land
onready var river = $Land/River
onready var decor = $Decor
onready var faction = $Faction
onready var faction_borders = $Faction/FactionBorders


func set_cell(layer, x, y, tile):
	match layer:
		LAND:
			_set_land_cell(x, y, tile)
		RIVER:
			_set_river_cell(x, y, tile)
		DECOR:
			_set_decor_cell(x, y, tile)
		FACTION:
			_set_faction_cell(x, y, tile)


func get_cell(layer, x, y):
	match layer:
		LAND:
			return _get_land_cell(x, y)
		RIVER:
			return _get_river_cell(x, y)
		DECOR:
			return _get_decor_cell(x, y)
		FACTION:
			return _get_faction_cell(x, y)


func update_area(layer, position):
	match layer:
		LAND:
			_update_land_area(position)
		RIVER:
			_update_river_area(position)
		DECOR:
			_update_decor_area(position)
		FACTION:
			_update_faction_area(position)


func _set_land_cell(x, y, tile):
	land.set_cell(x, y, tile)


func _set_river_cell(x, y, tile):
	river.set_cell(x, y, tile)


func _set_decor_cell(x, y, tile):
	decor.set_cell(x, y, tile)


func _set_faction_cell(x, y, tile):
	faction.set_cell(x, y, tile)
	faction_borders.set_cell(x, y, tile)


func _get_land_cell(x, y):
	return land.get_cell(x, y)


func _get_river_cell(x, y):
	return river.get_cell(x, y)


func _get_decor_cell(x, y):
	return decor.get_cell(x, y)


func _get_faction_cell(x, y):
	return faction.get_cell(x, y)


func _update_land_area(position):
	land.update_bitmask_area(position)


func _update_river_area(position):
	river.update_bitmask_area(position)


func _update_decor_area(position):
	decor.update_bitmask_area(position)


func _update_faction_area(position):
	faction.update_bitmask_area(position)
	faction_borders.update_bitmask_area(position)
