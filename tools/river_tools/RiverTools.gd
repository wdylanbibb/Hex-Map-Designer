extends "res://tools/MapTool.gd"

#export(NodePath) var river_map_path
#export(NodePath) var river_preview_path

var _pressed : bool
var _button : int


#onready var river_map : TileMap = get_node(river_map_path)

#onready var river_preview = get_node(river_preview_path)
#onready var river_center = river_preview.get_node("RiverCenter")
#onready var river_edge = river_preview.get_node("RiverEdge")

onready var river_preview = $RiverPreview
onready var river_center = $RiverPreview/RiverCenter
onready var river_edge = $RiverPreview/RiverEdge

onready var cell_position = $VBoxContainer/CellPosition
onready var river_id = $VBoxContainer/RiverID

func _ready() -> void:
	remove_child(river_preview)
	Renderer.call_deferred("add_child", river_preview)
#	MainCamera.connect("zoom_changed", self, "_on_Camera_zoom_changed")
#
#
#func _on_Camera_zoom_changed():
#	river_preview.scale = MainCamera.zoom
#	var edge = HexGrid.get_closest_edge(river_map.get_global_mouse_position())
#	if not edge == river_preview.position:
#		river_edge.global_position = edge

func on_disabled(d: bool) -> void:
	
	river_preview.visible = not d
	
	.on_disabled(d)


func _renderer_input(event: InputEvent) -> void:
	var hex_position = HexGrid.get_closest_hex(Renderer.get_global_mouse_position())
	var cell = Renderer.river.world_to_map(hex_position)
	cell += Vector2(-1, -fmod(cell.x, 2))
	
	if event is InputEventMouseMotion:
		river_preview.global_position = hex_position
		var edge = HexGrid.get_closest_edge(Renderer.get_global_mouse_position())
		if not edge == river_preview.global_position:
			river_edge.global_position = edge
		cell_position.set_text("Cell: " + str(cell))
		river_id.set_text("River ID: " + str(Renderer.river.get_cell_id(cell)))
		
		if _pressed:
			_action(cell)
	
	if event is InputEventMouseButton:
		_pressed = event.pressed
		_button = event.button_index
		if _pressed:
			_action(cell)


func _action(cell: Vector2):
	var edge = HexGrid.vector_to_edge_bit((HexGrid.pixel_to_hex_edge(river_edge.global_position).cube-HexGrid.pixel_to_hex_edge(river_preview.global_position).cube))
	match _button:
		BUTTON_LEFT:
			Renderer.river.set_river_edge(cell.x, cell.y, edge, true)
		BUTTON_RIGHT:
			Renderer.river.set_river_edge(cell.x, cell.y, edge, false)

