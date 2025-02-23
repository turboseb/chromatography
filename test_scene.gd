extends Node

@onready var chart: ColorRect = $Chart


@export var amplitude: float
@export var retention_time: float
@export var peak_width: float
@export var asymmetry: float
##add noise

func _ready() -> void:
	var dataset: PackedVector2Array
	var t: PackedFloat32Array = range(0, 2 * (retention_time + 6 * peak_width * asymmetry)*100)
	for ti: float in t:
		ti *= 0.01
		var intensity: float = amplitude * exp(-pow(abs((ti - retention_time) / peak_width), asymmetry))
		dataset.append(Vector2(ti, intensity))
	
	chart.add_dataset("data", dataset)
