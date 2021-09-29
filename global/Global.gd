extends Node

static func get_texture_region(texture: Texture, rect: Rect2):
	var atlas = AtlasTexture.new()
	atlas.set_atlas(texture)
	atlas.set_region(rect)
	return atlas


func get_color_texture(width: int, height: int, color: Color):
	var image = Image.new()
	image.create(width, height, false, Image.FORMAT_RGBA8)
	image.lock()
	for y in range(height):
		for x in range(width):
			image.set_pixel(x, y, color)
	image.unlock()
	var itex = ImageTexture.new()
	itex.create_from_image(image)
	return itex
