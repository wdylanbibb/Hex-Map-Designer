extends "res://tools/hex/HexTilemap.gd"




func set_river_edge(x: int, y: int, edge: int, on: bool):
	set_edge_bit(x, y, edge, on, 0, true)
	
	var next_cell = hex_to_cell(HexGrid.pixel_to_hex(map_to_world(Vector2(x, y))).get_adjacent(HexGrid.edge_bit_to_vector(edge)))
	set_edge_bit(next_cell.x, next_cell.y, HexGrid.get_opposite_edge(edge), on, 0, true)
