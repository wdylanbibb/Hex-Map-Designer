extends Node


var Factions

func _init() -> void:
	var file = File.new()
	file.open("objects/holdings/holdings.json", File.READ)
	var content = file.get_as_text()
	Factions = JSON.parse(content).result
	if typeof(Factions)==TYPE_DICTIONARY:
		pass
	else:
		print("Unexpected results found in holdings.json.")
		Factions = null
		return
	file.close()
	
	Factions = Factions.factions
