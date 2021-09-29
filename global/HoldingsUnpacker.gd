extends Node


var Holdings

func _init() -> void:
	var file = File.new()
	file.open("objects/holdings/holdings.json", File.READ)
	var content = file.get_as_text()
	Holdings = JSON.parse(content).result
	if typeof(Holdings)==TYPE_DICTIONARY:
		pass
	else:
		print("Unexpected results found in holdings.json.")
		Holdings = null
		return
	file.close()
	
	Holdings = Holdings.holdings
