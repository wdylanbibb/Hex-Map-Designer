extends Node2D


onready var sprite = $Sprite
onready var shadow = $Shadow
onready var shadow_2 = $Shadow2

func change_border_color(color: Color):
	for c in range(shadow.vertex_colors.size()):
		color.a = shadow.vertex_colors[c].a
		shadow.vertex_colors[c] = color
		color.a = shadow_2.vertex_colors[c].a
		shadow_2.vertex_colors[c] = color


func change_texture(texture: Texture):
	sprite.texture = texture
