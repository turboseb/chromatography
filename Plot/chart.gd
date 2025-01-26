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

func add_dataset(data_name: String, dataset: PackedVector2Array) ->void:
	var corr_dataset: PackedVector2Array
	for data: Vector2 in dataset:
		corr_dataset.append(data * 100.0)
	datasets.get_or_add(data_name, corr_dataset)
	datasets_changed.emit()
