extends MapTool

export(NodePath) var camera_path
export(NodePath) var counties_map_path
export(NodePath) var holding_selector_path

var selector_valid := preload("res://assets/sprites/icons/kingdom_selector.png")
var selector_invalid := preload("res://assets/sprites/icons/kingdom_selector_invalid.png")

var _pressed : bool
var _button : int


onready var camera : Camera2D = get_node(camera_path)
onready var counties_map : TileMap = get_node(counties_map_path)
onready var holding_selector : Sprite = get_node(holding_selector_path)

onready var holding_select := $VBoxContainer/HoldingSelect

func _ready() -> void:
	camera.connect("zoom_changed", self, "_on_Camera_zoom_changed")
	
	for id in counties_map.tile_set.get_tiles_ids():
		holding_select.add_icon_item(
			Global.get_texture_region(
				counties_map.tile_set.tile_get_texture(id),
				Rect2(Vector2.ZERO, counties_map.tile_set.autotile_get_size(id))),
			counties_map.tile_set.tile_get_name(id),
			id
		)


func _unhandled_input(event: InputEvent) -> void:
	var hex_position = HexGrid.get_closest_hex(counties_map.get_global_mouse_position())
	var cell = counties_map.world_to_map(hex_position)
	cell += Vector2(-1, -fmod(cell.x, 2))
	
	var valid = counties_map.check_valid(cell)
	
	if event is InputEventMouseMotion:
		holding_selector.position = hex_position
		if valid:
			holding_selector.texture = selector_valid
		else:
			holding_selector.texture = selector_invalid
		
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
		BUTTON_RIGHT:
			counties_map.set_cellv(cell, -1)
			counties_map.update_bitmask_area(cell)


func _on_Camera_zoom_changed():
	holding_selector.scale = camera.zoom


func set_disabled(d: bool) -> void:
	
	set_process_unhandled_input(d)
	holding_selector.visible = d
	
	.set_disabled(d)
