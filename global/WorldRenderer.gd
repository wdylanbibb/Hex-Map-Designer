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

onready var camera = $Camera2D


func get_save_data() -> Dictionary:
	var data : Dictionary = {
		"map":
			{
			"data":
				{
					"camera_position":camera.position,
					"rect":
							Vector2(
								abs(camera.limit_left) + abs(camera.limit_right), 
								abs(camera.limit_top) + abs(camera.limit_bottom)
								)
				},
			"cells":
				{
				}
			},
		"factions": HoldingsUnpacker.FactionResources
	}
	
	for cell in land.get_used_cells():
		data.map.cells[cell] = {
			"land": {"id":land.get_cellv(cell),"coord":land.get_cell_autotile_coord(cell.x, cell.y)},
			"river": {"id":river.get_cellv(cell),"coord":river.get_cell_autotile_coord(cell.x, cell.y)},
			"faction": faction.get_cellv(cell),
			"city": decor.get_cellv(cell) == 3
		}
		
	
	return data


func load_save(save: SaveGame):
	var save_data = save.data
	
	land.clear()
	river.clear()
	decor.clear()
	faction.clear()
	faction_borders.clear()
	
	faction.tile_set = TileSet.new()
	faction.create_faction_tiles(save_data.factions)
	
	faction_borders.tile_set = TileSet.new()
	faction_borders.create_faction_tiles(save_data.factions)
	
	for cell in save_data.map.cells:
		land.set_cell(cell.x, cell.y, save_data.map.cells[cell].land.id, false, false, false, save_data.map.cells[cell].land.coord)
		river.set_cell(cell.x, cell.y, save_data.map.cells[cell].river.id, false, false, false, save_data.map.cells[cell].river.coord)
		_set_faction_cell(cell.x, cell.y, save_data.map.cells[cell].faction)
		if save_data.map.cells[cell].city:
			decor.set_cellv(cell, 3)
		update_area(LAND, cell)
		update_area(FACTION, cell)


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


func get_global_mouse_position():
	var v = get_viewport().get_parent().rect_size / Vector2(1110, 720)
	var r = Vector2(1280, 720) / get_viewport().get_parent().get_viewport().size
	return get_canvas_transform().affine_inverse().xform(get_viewport().get_mouse_position()*r*v)
