extends Resource
class_name SaveGame


export var data : Dictionary
export var version : String

func _init() -> void:
	data = {}
	version = ProjectSettings.get_setting("application/config/version")
