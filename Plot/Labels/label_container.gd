extends MarginContainer

@export var chart: ColorRect
@export var box_container: BoxContainer

@export var dataset_label: PackedScene

func _ready() -> void:
	chart.datasets_changed.connect(datasets_changed)
	update_labels()

func datasets_changed():
	update_labels()


func update_labels() ->void:
	for label in box_container.get_children():
		label.queue_free()
	
	for dataset in chart.datasets.size():
		var data_color:Color = chart.line_color[dataset]
		var dataset_name = chart.datasets.keys()[dataset]
		var label = dataset_label.instantiate()
		box_container.add_child(label)
		label.text = "[color=" + str(data_color.to_html()) + "]―[/color] " + dataset_name
		print(label.text)
