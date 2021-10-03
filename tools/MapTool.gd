extends PanelContainer
class_name MapTool


var disabled : bool setget on_disabled


onready var Renderer = get_tree().get_nodes_in_group("renderer")[0]
onready var MainCamera = get_tree().get_nodes_in_group("camera")[0]
onready var RendererContainer = Renderer.get_viewport().get_parent()

func _ready() -> void:
	RendererContainer.connect("gui_input", self, "_renderer_input")
#	RendererContainer.connect("mouse_entered", self, "_on_RendererContainer_mouse_entered")
#	RendererContainer.connect("mouse_exited", self, "_on_RendererContainer_mouse_exited")
#
#
#func _on_RendererContainer_mouse_entered():
#	# Get if tool was disabled on enter, and set disabled back to original state without calling on_disabled()
#
#	var previous_state = disabled
#	on_disabled(false if previous_state else true)
#	disabled = previous_state
#
#
#func _on_RendererContainer_mouse_exited():
#	var previous_state = disabled
#	on_disabled(true)
#	disabled = previous_state


func _renderer_input(event):
	pass


func on_disabled(d: bool) -> void:
	var connected : bool
	for connection in RendererContainer.get_signal_connection_list("gui_input"):
		if self == connection.target:
			connected = true
	
	if d: # Tool has been disabled
		if connected:
			RendererContainer.disconnect("gui_input", self, "_renderer_input")
	else:
		if not connected:
			RendererContainer.connect("gui_input", self, "_renderer_input")
	
	disabled = d
