extends ColorRect

signal datasets_changed
@export var plot:ColorRect

## Dictionary of String: PackedVector2Array
@export var datasets: Dictionary:
	set(value):
		datasets = value
		if plot:
			datasets_changed.emit()

@export var line_color: PackedColorArray
