extends "res://tools/MapTool.gd"


export(NodePath) var land_map_path
export(NodePath) var land_preview_path

var _pressed : bool
var _button : int


onready var land_map = get_node(land_map_path)
onready var land_preview = get_node(land_preview_path)
onready var tile_select = $VBoxContainer/TileSelect
onready var brush_size = $VBoxContainer/BrushSize
onready var cell_position = $VBoxContainer/PanelContainer/CellPosition

func _ready() -> void:
	for id in land_map.tile_set.get_tiles_ids():
		tile_select.add_icon_item(
			get_texture_region(
				land_map.tile_set.tile_get_texture(id),
				Rect2(Vector2.ZERO, land_map.tile_set.autotile_get_size(id))),
			land_map.tile_set.tile_get_name(id),
			id
		)


func set_disabled(d: bool) -> void:
	
	set_process_unhandled_input(d)
	land_preview.visible = d
	
	.set_disabled(d)


func _unhandled_input(event: InputEvent) -> void:
	var hex_position = HexGrid.get_closest_hex(land_map.get_global_mouse_position())
	var cell = land_map.world_to_map(hex_position)
	cell += Vector2(-1, -fmod(cell.x, 2))
	var cell_offset : Vector2
	if land_map.get_cellv(cell) > -1:
		cell_offset = land_map.tile_set.tile_get_texture_offset(land_map.get_cellv(cell))
	
	if event is InputEventMouseMotion:
		land_preview.position = hex_position + cell_offset
		cell_position.set_text("Cell: " + str(cell))
		
		if _pressed:
			if int(brush_size.get_line_edit().text)-1 > 0:
				for h in HexGrid.pixel_to_hex(hex_position).get_all_within(int(brush_size.get_line_edit().text)-1):
					var c = land_map.world_to_map(HexGrid.hex_to_pixel(h))
					c += Vector2(-1, -fmod(c.x, 2))
					_action(c)
			_action(cell)
	
	if event is InputEventMouseButton:
		_pressed = event.pressed
		_button = event.button_index
		if _pressed:
			if int(brush_size.get_line_edit().text)-1 > 0:
				for h in HexGrid.pixel_to_hex(hex_position).get_all_within(int(brush_size.get_line_edit().text)-1):
					var c = land_map.world_to_map(HexGrid.hex_to_pixel(h))
					c += Vector2(-1, -fmod(c.x, 2))
					_action(c)
			_action(cell)


func _action(cell: Vector2):
	match _button:
		BUTTON_LEFT:
			land_map.set_cellv(cell, tile_select.selected)
			land_map.update_bitmask_area(cell)
		BUTTON_RIGHT:
			land_map.set_cellv(cell, -1)
			land_map.update_bitmask_area(cell)


func get_texture_region(texture: Texture, rect: Rect2):
	var atlas = AtlasTexture.new()
	atlas.set_atlas(texture)
	atlas.set_region(rect)
	return atlas
