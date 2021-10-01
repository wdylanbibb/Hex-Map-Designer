extends "res://tools/MapTool.gd"

#export(NodePath) var river_map_path
export(NodePath) var river_preview_path

var _pressed : bool
var _button : int


#onready var river_map : TileMap = get_node(river_map_path)

onready var river_preview = get_node(river_preview_path)
onready var river_center = river_preview.get_node("RiverCenter")
onready var river_edge = river_preview.get_node("RiverEdge")

onready var cell_position = $VBoxContainer/CellPosition
onready var river_id = $VBoxContainer/RiverID

#func _ready() -> void:
#	MainCamera.connect("zoom_changed", self, "_on_Camera_zoom_changed")
#
#
#func _on_Camera_zoom_changed():
#	river_preview.scale = MainCamera.zoom
#	var edge = HexGrid.get_closest_edge(river_map.get_global_mouse_position())
#	if not edge == river_preview.position:
#		river_edge.global_position = edge

func set_disabled(d: bool) -> void:
	
	set_process_unhandled_input(d)
	river_preview.visible = d
	
	.set_disabled(d)


func _unhandled_input(event: InputEvent) -> void:
	var hex_position = HexGrid.get_closest_hex(WorldRenderer.get_global_mouse_position())
	var cell = WorldRenderer.river.world_to_map(hex_position)
	cell += Vector2(-1, -fmod(cell.x, 2))
	
	if event is InputEventMouseMotion:
		river_preview.position = hex_position
		var edge = HexGrid.get_closest_edge(WorldRenderer.get_global_mouse_position())
		if not edge == river_preview.position:
			river_edge.global_position = edge
		cell_position.set_text("Cell: " + str(cell))
		river_id.set_text("River ID: " + str(WorldRenderer.river.get_cell_id(cell)))
		
		if _pressed:
			_action(cell)
	
	if event is InputEventMouseButton:
		_pressed = event.pressed
		_button = event.button_index
		if _pressed:
			_action(cell)


func _action(cell: Vector2):
	var edge = HexGrid.vector_to_edge_bit((HexGrid.pixel_to_hex_edge(river_edge.global_position).cube-HexGrid.pixel_to_hex_edge(river_preview.position).cube))
	match _button:
		BUTTON_LEFT:
			WorldRenderer.river.set_river_edge(cell.x, cell.y, edge, true)
		BUTTON_RIGHT:
			WorldRenderer.river.set_river_edge(cell.x, cell.y, edge, false)

