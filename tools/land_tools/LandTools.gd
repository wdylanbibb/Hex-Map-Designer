extends "res://tools/MapTool.gd"


#export(NodePath) var land_map_path
#export(NodePath) var land_preview_path

var _pressed : bool
var _button : int


onready var land_preview = $LandPreview
onready var tile_select = $VBoxContainer/TileSelect
onready var brush_size = $VBoxContainer/BrushSize
onready var cell_position = $VBoxContainer/PanelContainer/CellPosition

func _ready() -> void:
	
	remove_child(land_preview)
	Renderer.call_deferred("add_child", land_preview)
	
	var tile_set = Renderer.land.tile_set
	
	for id in tile_set.get_tiles_ids():
		tile_select.add_icon_item(
			Global.get_texture_region(
				tile_set.tile_get_texture(id),
				Rect2(Vector2.ZERO, tile_set.autotile_get_size(id))),
			tile_set.tile_get_name(id),
			id
		)


func on_disabled(d: bool) -> void:
	
	land_preview.visible = not d
	
	.on_disabled(d)


func _renderer_input(event: InputEvent) -> void:
	var hex_position = HexGrid.get_closest_hex(Renderer.get_global_mouse_position())
	var cell = Renderer.land.world_to_map(hex_position)
	cell += Vector2(-1, -fmod(cell.x, 2))
	var cell_offset : Vector2
	if Renderer.get_cell(Renderer.LAND, cell.x, cell.y) > -1:
		cell_offset = Renderer.land.tile_set.tile_get_texture_offset(Renderer.get_cell(Renderer.LAND, cell.x, cell.y))
	
	if event is InputEventMouseMotion:
		land_preview.position = hex_position + cell_offset
		cell_position.set_text("Cell: " + str(cell))
		
		if _pressed:
			if int(brush_size.get_line_edit().text)-1 > 0:
				for h in HexGrid.pixel_to_hex(hex_position).get_all_within(int(brush_size.get_line_edit().text)-1):
					var c = Renderer.land.world_to_map(HexGrid.hex_to_pixel(h))
					c += Vector2(-1, -fmod(c.x, 2))
					_action(c)
			_action(cell)
	
	if event is InputEventMouseButton:
		_pressed = event.pressed
		_button = event.button_index
		if _pressed:
			if int(brush_size.get_line_edit().text)-1 > 0:
				for h in HexGrid.pixel_to_hex(hex_position).get_all_within(int(brush_size.get_line_edit().text)-1):
					var c = Renderer.land.world_to_map(HexGrid.hex_to_pixel(h))
					c += Vector2(-1, -fmod(c.x, 2))
					_action(c)
			_action(cell)


func _action(cell: Vector2):
	match _button:
		BUTTON_LEFT:
			Renderer.set_cell(Renderer.LAND, cell.x, cell.y, tile_select.selected)
			Renderer.update_area(Renderer.LAND, cell)
		BUTTON_RIGHT:
			Renderer.set_cell(Renderer.LAND, cell.x, cell.y, -1)
			Renderer.update_area(Renderer.LAND, cell)
