extends MapTool

export(NodePath) var counties_map_path
export(NodePath) var holding_selector_path
export(NodePath) var county_border_path

var selector_valid := preload("res://assets/sprites/icons/kingdom_selector.png")
var selector_invalid := preload("res://assets/sprites/icons/kingdom_selector_invalid.png")

var _pressed : bool
var _button : int
var _cell : Vector2

var highlight_amount = .15

onready var counties_map : TileMap = get_node(counties_map_path)
onready var county_border = get_node(county_border_path)
onready var holding_selector : Node2D = get_node(holding_selector_path)

onready var holding_select := $VBoxContainer/HoldingSelect

func _ready() -> void:
	MainCamera.connect("zoom_changed", self, "_on_Camera_zoom_changed")
	
#	_on_HoldingSelect_item_selected(holding_select.selected)


func _unhandled_input(event: InputEvent) -> void:
	var previous_cell = _cell
	var hex_position = HexGrid.get_closest_hex(counties_map.get_global_mouse_position())
	_cell = counties_map.world_to_map(hex_position)
	_cell += Vector2(-1, -fmod(_cell.x, 2))
	
	var valid = counties_map.check_valid(_cell)
	
	if event is InputEventMouseMotion:
		if not previous_cell == _cell:
			if not counties_map.get_cellv(previous_cell) == -1:
				counties_map.set_highlight(counties_map.get_cellv(previous_cell), 0)
			if not counties_map.get_cellv(_cell) == -1:
				counties_map.set_highlight(counties_map.get_cellv(_cell), highlight_amount)
		
		holding_selector.position = hex_position
		if valid:
			holding_selector.change_texture(selector_valid)
		else:
			holding_selector.change_texture(selector_invalid)
		
		if _pressed:
			if valid:
				_action(_cell)
	
	if event is InputEventMouseButton:
		_pressed = event.pressed
		_button = event.button_index
		if _pressed:
			if valid:
				_action(_cell)


func _action(cell: Vector2):
	match _button:
		BUTTON_LEFT:
			if not counties_map.get_cellv(cell) == -1:
				counties_map.set_highlight(counties_map.get_cellv(cell), 0.0)
			
			counties_map.set_cellv(cell, holding_select.selected)
			counties_map.update_bitmask_area(cell)
			
			county_border.set_cellv(cell, holding_select.selected)
			county_border.update_bitmask_area(cell)
			
			if not counties_map.get_cellv(cell) == -1:
				counties_map.set_highlight(counties_map.get_cellv(cell), highlight_amount)
		BUTTON_RIGHT:
			if not counties_map.get_cellv(cell) == -1:
				counties_map.set_highlight(counties_map.get_cellv(cell), 0.0)
			
			counties_map.set_cellv(cell, -1)
			counties_map.update_bitmask_area(cell)
			
			county_border.set_cellv(cell, -1)
			county_border.update_bitmask_area(cell)


func _on_Camera_zoom_changed():
	holding_selector.sprite.scale = MainCamera.zoom


func set_disabled(d: bool) -> void:
	
	set_process_unhandled_input(d)
	holding_selector.visible = d
	
	.set_disabled(d)


func _on_HoldingSelect_item_selected(index: int) -> void:
	holding_selector.change_border_color(HoldingsUnpacker.Holdings[index].color)
