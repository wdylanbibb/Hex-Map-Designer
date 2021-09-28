extends Node

static func get_texture_region(texture: Texture, rect: Rect2):
	var atlas = AtlasTexture.new()
	atlas.set_atlas(texture)
	atlas.set_region(rect)
	return atlas
