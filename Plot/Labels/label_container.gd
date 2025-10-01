class_name LabelContainer
extends MarginContainer

@export var line_chart: LineChart
@export var box_container: BoxContainer

@export var dataset_label: PackedScene

func _ready() -> void:
	line_chart.datasets_changed.connect(datasets_changed)
	update_labels()

func datasets_changed() -> void:
	update_labels()


func update_labels() -> void:
	for label in box_container.get_children():
		label.queue_free()
	
	var dataset_info: String = "[table=1][cell border=white][b]Datasets[/b][/cell]"
	for dataset: int in line_chart.datasets.size():
		var data_color:Color = line_chart.line_color[dataset] if dataset < line_chart.line_color.size() else Color.WHITE
		var dataset_name: String = line_chart.datasets.keys()[dataset]
		var label: RichTextLabel = dataset_label.instantiate()
		box_container.add_child(label)
		label.text = "[color=" + str(data_color.to_html()) + "]―[/color] " + dataset_name
		dataset_info += "[cell border=white]" + label.text + "[/cell]"
	dataset_info += "[/table]"
	print_rich(dataset_info)
