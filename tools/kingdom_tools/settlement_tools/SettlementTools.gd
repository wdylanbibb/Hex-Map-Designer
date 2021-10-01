extends MapTool

var selector_valid := preload("res://assets/sprites/icons/kingdom_selector.png")
var selector_invalid := preload("res://assets/sprites/icons/kingdom_selector_invalid.png")

var _pressed : bool
var _button : int
var _cell : Vector2

var highlight_amount := .15


onready var holding_preview = $HoldingPreview

func _ready() -> void:
	remove_child(holding_preview)
	owner.call_deferred("add_child", holding_preview)
	
	MainCamera.connect("zoom_changed", self, "_on_Camera_zoom_changed")


func _unhandled_input(event: InputEvent) -> void:
	var previous_cell = _cell
	var hex_position = HexGrid.get_closest_hex(WorldRenderer.get_global_mouse_position())
	_cell = WorldRenderer.faction.world_to_map(hex_position)
	_cell += Vector2(-1, -fmod(_cell.x, 2))
	
	var valid = WorldRenderer.faction.check_valid(_cell)
	
	if event is InputEventMouseMotion:
		if not previous_cell == _cell:
			if not WorldRenderer.get_cell(WorldRenderer.FACTION, previous_cell.x, previous_cell.y) == -1:
				WorldRenderer.faction.set_highlight(WorldRenderer.get_cell(WorldRenderer.FACTION, previous_cell.x, previous_cell.y), 0)
			if not WorldRenderer.get_cell(WorldRenderer.FACTION, _cell.x, _cell.y) == -1:
				WorldRenderer.faction.set_highlight(WorldRenderer.get_cell(WorldRenderer.FACTION, _cell.x, _cell.y), highlight_amount)
		
		holding_preview.position = hex_position
		if valid:
			holding_preview.change_texture(selector_valid)
		else:
			holding_preview.change_texture(selector_invalid)
		
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
			WorldRenderer.set_cell(WorldRenderer.DECOR, cell.x, cell.y, 3)
			WorldRenderer.update_area(WorldRenderer.DECOR, cell)
		BUTTON_RIGHT:
			WorldRenderer.set_cell(WorldRenderer.DECOR, cell.x, cell.y, -1)
			WorldRenderer.update_area(WorldRenderer.LAND, cell)


func set_disabled(d: bool) -> void:
	
	set_process_unhandled_input(d)
	holding_preview.visible = d
	
	.set_disabled(d)


func _on_Camera_zoom_changed():
	holding_preview.sprite.scale = MainCamera.zoom
