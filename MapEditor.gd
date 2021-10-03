extends Control


onready var Renderer = $CanvasLayer/HBoxContainer/Canvas/CenterContainer/ViewportContainer/Viewport/WorldRenderer
onready var SaveDialog = $CanvasLayer/SaveDialog
onready var LoadDialog = $CanvasLayer/LoadDialog


func _ready() -> void:
	var s = load("res://test_map.tres")

func _on_SaveButton_pressed() -> void:
	SaveDialog.popup_centered()


func _on_LoadButton_pressed() -> void:
	LoadDialog.popup_centered()


func _on_SaveDialog_file_selected(path: String) -> void:
	var s = SaveGame.new()
	s.data = Renderer.get_save_data()
	print(ResourceSaver.save(path, s))


func _on_LoadDialog_file_selected(path: String) -> void:
	var s = load(path)
	
	HoldingsUnpacker.FactionResources = s.data.factions
	
	Renderer.load_save(s)
