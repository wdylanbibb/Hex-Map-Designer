extends MapTool

export(NodePath) var camera_path
export(NodePath) var counties_map_path
export(NodePath) var holding_selector_path
export(NodePath) var county_border_path

var selector_valid := preload("res://assets/sprites/icons/kingdom_selector.png")
var selector_invalid := preload("res://assets/sprites/icons/kingdom_selector_invalid.png")

var _pressed : bool
var _button : int


onready var camera : Camera2D = get_node(camera_path)
onready var counties_map : TileMap = get_node(counties_map_path)
onready var county_border = get_node(county_border_path)
onready var holding_selector : Node2D = get_node(holding_selector_path)

onready var holding_select := $VBoxContainer/HoldingSelect

func _ready() -> void:
	camera.connect("zoom_changed", self, "_on_Camera_zoom_changed")
	
#	_on_HoldingSelect_item_selected(holding_select.selected)


func _unhandled_input(event: InputEvent) -> void:
	var hex_position = HexGrid.get_closest_hex(counties_map.get_global_mouse_position())
	var cell = counties_map.world_to_map(hex_position)
	cell += Vector2(-1, -fmod(cell.x, 2))
	
	var valid = counties_map.check_valid(cell)
	
	if event is InputEventMouseMotion:
		holding_selector.position = hex_position
		if valid:
			holding_selector.change_texture(selector_valid)
		else:
			holding_selector.change_texture(selector_invalid)
		
		if _pressed:
			if valid:
				_action(cell)
	
	if event is InputEventMouseButton:
		_pressed = event.pressed
		_button = event.button_index
		if _pressed:
			if valid:
				_action(cell)


func _action(cell: Vector2):
	match _button:
		BUTTON_LEFT:
			counties_map.set_cellv(cell, holding_select.selected)
			counties_map.update_bitmask_area(cell)
			
			county_border.set_cellv(cell, holding_select.selected)
			county_border.update_bitmask_area(cell)
		BUTTON_RIGHT:
			counties_map.set_cellv(cell, -1)
			counties_map.update_bitmask_area(cell)
			
			county_border.set_cellv(cell, -1)
			county_border.update_bitmask_area(cell)


func _on_Camera_zoom_changed():
	holding_selector.sprite.scale = camera.zoom


func set_disabled(d: bool) -> void:
	
	set_process_unhandled_input(d)
	holding_selector.visible = d
	
	.set_disabled(d)


func _on_HoldingSelect_item_selected(index: int) -> void:
	holding_selector.change_border_color(HoldingsUnpacker.Holdings[index].color)
