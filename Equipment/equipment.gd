extends Node

@export var analyses: Array[Analysis]
@export var line_chart: LineChart
@export var calculation: Calculation

func _ready() -> void:
	call_deferred("update_analysis")

func update_analysis() -> void:
	for analysis in analyses:
		line_chart.add_dataset(analysis.sample.resource_name, calculation.analyse_sample(analysis.sample, analysis.program))


func _on_button_pressed() -> void:
	update_analysis()
