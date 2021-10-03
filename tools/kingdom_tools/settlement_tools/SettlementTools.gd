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
	Renderer.call_deferred("add_child", holding_preview)
	
	MainCamera.connect("zoom_changed", self, "_on_Camera_zoom_changed")


func _renderer_input(event: InputEvent) -> void:
	var previous_cell = _cell
	var hex_position = HexGrid.get_closest_hex(Renderer.get_global_mouse_position())
	_cell = Renderer.faction.world_to_map(hex_position)
	_cell += Vector2(-1, -fmod(_cell.x, 2))
	
	var valid = Renderer.faction.check_valid(_cell)
	
	if event is InputEventMouseMotion:
		if not previous_cell == _cell:
			if not Renderer.get_cell(Renderer.FACTION, previous_cell.x, previous_cell.y) == -1:
				Renderer.faction.set_highlight(Renderer.get_cell(Renderer.FACTION, previous_cell.x, previous_cell.y), 0)
			if not Renderer.get_cell(Renderer.FACTION, _cell.x, _cell.y) == -1:
				Renderer.faction.set_highlight(Renderer.get_cell(Renderer.FACTION, _cell.x, _cell.y), highlight_amount)
		
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
			Renderer.set_cell(Renderer.DECOR, cell.x, cell.y, 3)
			Renderer.update_area(Renderer.DECOR, cell)
		BUTTON_RIGHT:
			Renderer.set_cell(Renderer.DECOR, cell.x, cell.y, -1)
			Renderer.update_area(Renderer.LAND, cell)


func on_disabled(d: bool) -> void:
	
	holding_preview.visible = not d
	
	.on_disabled(d)


func _on_Camera_zoom_changed():
	holding_preview.sprite.scale = MainCamera.zoom
