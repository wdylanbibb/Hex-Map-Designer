extends Control

onready var fps_counter = $FPSCounter


# warning-ignore:unused_argument
func _physics_process(delta: float) -> void:
	fps_counter.set_text("FPS: " + str(Engine.get_frames_per_second()))
