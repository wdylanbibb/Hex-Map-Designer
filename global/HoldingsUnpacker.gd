extends Node


var _Factions
var FactionResources : Array setget set_faction_resources

signal faction_resources_changed()

func set_faction_resources(f):
	FactionResources = f
	emit_signal("faction_resources_changed")

func _init() -> void:
	var file = File.new()
	file.open("objects/holdings/holdings.json", File.READ)
	var content = file.get_as_text()
	_Factions = JSON.parse(content).result
	if typeof(_Factions)==TYPE_DICTIONARY:
		pass
	else:
		print("Unexpected results found in holdings.json.")
		_Factions = null
		return
	file.close()
	
	_Factions = _Factions.factions
	for f in _Factions:
		var faction = Faction.new()
		faction.name = f.name
		faction.color = f.color
		FactionResources.append(faction)
