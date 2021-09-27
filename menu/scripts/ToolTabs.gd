extends TabContainer


func _ready() -> void:
	for child_idx in range(get_child_count()):
		var child = get_child(child_idx)
		if child is MapTool:
			child.disabled = child_idx == current_tab


func _on_ToolTabs_tab_changed(tab: int) -> void:
	for child_idx in range(get_child_count()):
		var child = get_child(child_idx)
		if child is MapTool:
			child.disabled = child_idx == tab


func _set_tool_state(tab):
	var child = get_child(tab)
	if child is MapTool:
		child.disabled = tab == current_tab
