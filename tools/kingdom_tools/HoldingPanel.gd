extends PanelContainer

var Holding : Dictionary setget set_holding

onready var name_label = $HBoxContainer/VBoxContainer/NameLabel
onready var crest_texture = $HBoxContainer/VBoxContainer2/CrestTexture


func set_holding(h: Dictionary):
	if not name_label:
		name_label = $HBoxContainer/VBoxContainer/NameLabel
	if not crest_texture:
		crest_texture = $HBoxContainer/VBoxContainer2/CrestTexture
	Holding = h
	name_label.set_text(Holding.name)
	crest_texture.texture = Global.get_color_texture(64, 72, Color(Holding.color))
