extends MarginContainer

onready var fps_counter = $VBoxContainer/FPSCounter
onready var h_scroll = $"../Canvas/VBoxContainer/HBoxContainer/HScrollBar"
onready var v_scroll = $"../Canvas/VBoxContainer/VScrollBar"


onready var MainCamera = get_tree().get_nodes_in_group("camera")[0]

func _ready() -> void:
	
	h_scroll.max_value = MainCamera.limit_right
	v_scroll.max_value = MainCamera.limit_bottom

	MainCamera.connect("position_changed", self, "_on_MainCamera_translation_changed")
	MainCamera.connect("zoom_changed", self, "_on_MainCamera_translation_changed")
	_on_MainCamera_translation_changed()

# warning-ignore:unused_argument
func _physics_process(delta: float) -> void:
	fps_counter.set_text("FPS: " + str(Engine.get_frames_per_second()))


func _on_MainCamera_translation_changed():
	h_scroll.page = MainCamera.get_viewport_rect().size.x * MainCamera.zoom.x
	v_scroll.page = MainCamera.get_viewport_rect().size.y * MainCamera.zoom.y

	h_scroll.value = MainCamera.position.x - (MainCamera.get_viewport_rect().size.x/2) * MainCamera.zoom.x
	v_scroll.value = MainCamera.position.y - (MainCamera.get_viewport_rect().size.y/2) * MainCamera.zoom.y


func _on_HScrollBar_scrolling() -> void:
	MainCamera.position.x = h_scroll.value + (MainCamera.get_viewport_rect().size.x/2) * MainCamera.zoom.x


func _on_VScrollBar_scrolling() -> void:
	MainCamera.position.y = v_scroll.value + (MainCamera.get_viewport_rect().size.y/2) * MainCamera.zoom.y

