extends Node2D


onready var sprite = $Sprite

func change_texture(texture: Texture):
	sprite.texture = texture
