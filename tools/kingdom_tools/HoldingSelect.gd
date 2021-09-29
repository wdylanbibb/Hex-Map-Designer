extends OptionButton

var HoldingPanel := preload("res://tools/kingdom_tools/HoldingPanel.tscn")


func _ready() -> void:
	for h in range(HoldingsUnpacker.Holdings.size()):
		add_holding(HoldingsUnpacker.Holdings[h], h)
	show_correct_children(0)


func add_holding(holding, id):
	add_icon_item(
		Global.get_color_texture(
			16, 16, holding.color
		),
		holding.name,
		id
	)
	
	var holding_panel = HoldingPanel.instance()
	holding_panel.Holding = holding
	add_child(holding_panel, true)
	
#	_on_HoldingSelect_item_selected(selected)


func show_correct_children(index):
	for child in get_child_count():
		if get_child(child) is PanelContainer:
			get_child(child).visible = child == index
		else:
			index+=1


func _on_HoldingSelect_item_selected(index: int) -> void:
	show_correct_children(index)
