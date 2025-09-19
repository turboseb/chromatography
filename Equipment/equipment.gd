extends Node

@export var program: Program = Program.new()
@export var sample: Sample
@export var chart: Chart
@export var calculation: Calculation

func _ready() -> void:
	update_analysis()
	#chart.clear_dataset()
	#chart.add_dataset(sample.resource_name, calculation.analyse_sample(sample, program))


func update_analysis() -> void:
	chart.clear_dataset()
	chart.add_dataset(sample.resource_name, calculation.analyse_sample(sample, program))


func _on_button_pressed() -> void:
	update_analysis()
