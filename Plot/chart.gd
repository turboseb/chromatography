extends ColorRect

@export var plot:ColorRect

## Dictionary of String: PackedVector2Array
@export var dataset: Dictionary:
	set(value):
		dataset = value
		plot.queue_redraw()
