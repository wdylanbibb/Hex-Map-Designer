extends MapTool

#export(NodePath) var counties_map_path
export(NodePath) var holding_selector_path
#export(NodePath) var county_border_path

var selector_valid := preload("res://assets/sprites/icons/kingdom_selector.png")
var selector_invalid := preload("res://assets/sprites/icons/kingdom_selector_invalid.png")

var _pressed : bool
var _button : int
var _cell : Vector2

var highlight_amount = .15

#onready var counties_map : TileMap = get_node(counties_map_path)
#onready var county_border = get_node(county_border_path)
onready var holding_selector : Node2D = get_node(holding_selector_path)

onready var holding_select := $VBoxContainer/HoldingSelect

func _ready() -> void:
	MainCamera.connect("zoom_changed", self, "_on_Camera_zoom_changed")
	
#	_on_HoldingSelect_item_selected(holding_select.selected)


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
			if not WorldRenderer.get_cell(WorldRenderer.FACTION, cell.x, cell.y) == -1:
				WorldRenderer.faction.set_highlight(WorldRenderer.get_cell(WorldRenderer.FACTION, cell.x, cell.y), 0)
			
			WorldRenderer.set_cell(WorldRenderer.FACTION, cell.x, cell.y, holding_select.selected)
			WorldRenderer.update_area(WorldRenderer.FACTION, cell)
			
			if not WorldRenderer.get_cell(WorldRenderer.FACTION, cell.x, cell.y) == -1:
				WorldRenderer.faction.set_highlight(WorldRenderer.get_cell(WorldRenderer.FACTION, cell.x, cell.y), highlight_amount)
		BUTTON_RIGHT:
			if not WorldRenderer.get_cell(WorldRenderer.FACTION, cell.x, cell.y) == -1:
				WorldRenderer.faction.set_highlight(WorldRenderer.get_cell(WorldRenderer.FACTION, cell.x, cell.y), 0)
			
			WorldRenderer.set_cell(WorldRenderer.FACTION, cell.x, cell.y, -1)
			WorldRenderer.update_area(WorldRenderer.FACTION, cell)


func _on_Camera_zoom_changed():
	holding_selector.sprite.scale = MainCamera.zoom


func set_disabled(d: bool) -> void:
	
	set_process_unhandled_input(d)
	holding_selector.visible = d
	
	.set_disabled(d)


func _on_HoldingSelect_item_selected(index: int) -> void:
	holding_selector.change_border_color(HoldingsUnpacker.Holdings[index].color)
