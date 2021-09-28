#warning-ignore-all:narrowing_conversion
#warning-ignore-all:integer_division
extends TileMap

# Marks different tile ids as invalid connections (used for decor so mountains and forests do not connect)
export(bool) var only_match_with_same_tile = false


func update_bitmask_area(position: Vector2):
	var position_cell = HexGrid.pixel_to_hex(map_to_world(position))
	
	for cell in position_cell.get_all_adjacent():
		var edge_bit = HexGrid.vector_to_edge_bit(cell.cube - position_cell.cube)
		var next_cell_position = hex_to_cell(cell)
		set_edge_bit(position.x, position.y, edge_bit, check_on(position, next_cell_position))
		set_edge_bit(next_cell_position.x, next_cell_position.y, HexGrid.get_opposite_edge(edge_bit), check_on(next_cell_position, position))

func check_on(current_cell: Vector2, check_cell: Vector2):
	if get_cellv(check_cell) == -1:
		return false
	else:
		return get_cellv(check_cell) == get_cellv(current_cell) if only_match_with_same_tile else true


func set_edge_bit(x: int, y: int, edge: int, on: bool, tile_id_override = -1, print_stuff = false):
	var id = int(get_cell_id(Vector2(x, y)))
	id ^= ((-(int(on))^id) & edge)
#	if print_stuff:
#		print(get_cell_coord_from_id(id))
	set_cell(x, y, get_cell(x, y) if tile_id_override == -1 else tile_id_override, false, false, false, get_cell_coord_from_id(id))


func get_cell_id(position: Vector2):
	var autotile_coord = get_cell_autotile_coord(position.x, position.y)
	return autotile_coord.x + 8 * autotile_coord.y


func get_cell_coord_from_id(id: int):
	return Vector2(id%8, id/8)


func update_bitmask_region(start: Vector2 = Vector2.ZERO, end: Vector2 = Vector2.ZERO):
	.update_bitmask_region(start, end)


func hex_to_cell(cell) -> Vector2:
	var c = world_to_map(HexGrid.hex_to_pixel(cell))
#	c.y += fmod(c.x, 2)
	return c


func tilemap_to_direction(current_cell, check_cell):
	var tile_direction = check_cell - current_cell
	if fmod(current_cell.x, 2)==0:
		if tile_direction == Vector2(-1, 0):
			return 1
		elif tile_direction == Vector2(0, -1):
			return 2
		elif tile_direction == Vector2(1, 0):
			return 4
		elif tile_direction == Vector2(1, 1):
			return 8
		elif tile_direction == Vector2(0, 1):
			return 16
		elif tile_direction == Vector2(-1, 1):
			return 32
		else:
			return 0
	else:
		if tile_direction == Vector2(-1, -1):
			return 1
		elif tile_direction == Vector2(0, -1):
			return 2
		elif tile_direction == Vector2(1, -1):
			return 4
		elif tile_direction == Vector2(1, 0):
			return 8
		elif tile_direction == Vector2(0, 1):
			return 16
		elif tile_direction == Vector2(-1, 0):
			return 32
		else:
			return 0
