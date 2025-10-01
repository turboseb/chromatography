class_name LineChart
extends ColorRect
##
##The [LineChart] allows diplaying given [member datasets] into a [Plot].[br]


## line_chart's datasets updated, used by [LabelContainer] and [Plot].
signal datasets_changed

## resolution of the plot, points per x-axis unit
@export var resolution: float = 20.0

## A dictionary of Datasets to plot. Each entry defines a dataset name and it's points values.
@export var datasets: Dictionary[String, PackedVector2Array]:
	set(value):
		datasets = value
		if !_plot:
			await get_tree().process_frame
			datasets_changed.emit()
		else:
			datasets_changed.emit()

## Color for each plot of [member datasets], defaults to [constant Color.WHITE] if left unassigned
@export var line_color: PackedColorArray = [Color.RED, Color.BLUE, Color.GREEN]



@onready var _plot: Plot = %Plot


## Add new or update existing dataset from [member datasets].
func add_dataset(data_name: String, dataset: PackedVector2Array) ->void:
	var corr_dataset: PackedVector2Array
	for data: Vector2 in dataset:
		corr_dataset.append(data * 100.0)
	if datasets.has(data_name):
		datasets.set(data_name, corr_dataset)
		print_rich("[color=light_blue]Updated Dataset: ", data_name, "[/color]")
	else:
		datasets.get_or_add(data_name, corr_dataset)
		print_rich("[color=light_blue]Added Dataset: ", data_name, "[/color]")
	datasets_changed.emit()

## Remove an existing dataset from [member datasets].
func remove_dataset(data_name: String) -> void:
	if datasets.has(data_name):
		datasets.erase(data_name)
		

## Clear all data from [member datasets].
func clear_dataset() -> void:
	datasets = {}
