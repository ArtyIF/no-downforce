extends OptionButton

func _ready() -> void:
	item_selected.connect(on_value_changed)
	select(NoDownforceGlobal.settings_resource.accessibility_regular_font)
	on_value_changed(NoDownforceGlobal.settings_resource.accessibility_regular_font)

func on_value_changed(index: int):
	var new_theme: Theme = ThemeDB.get_project_theme()
	match index:
		0:
			new_theme.set_font("font", "MatrixHugeLabel", load("res://fonts/MatrixTypeDisplay-Adjusted.tres"))
			new_theme.set_font("font", "MatrixLargeLabel", load("res://fonts/MatrixTypeDisplay-Adjusted.tres"))
			new_theme.set_font("font", "MatrixSmallLabel", load("res://fonts/MatrixTypeDisplay-Adjusted.tres"))
		1:
			new_theme.set_font("font", "MatrixHugeLabel", load("res://fonts/Qaz-Regular.otf"))
			new_theme.set_font("font", "MatrixLargeLabel", load("res://fonts/Qaz-Regular.otf"))
			new_theme.set_font("font", "MatrixSmallLabel", load("res://fonts/Qaz-Regular.otf"))
	$"/root".get_window().theme = new_theme
	
	NoDownforceGlobal.settings_resource.accessibility_regular_font = index
