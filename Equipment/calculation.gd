class_name Calculation
extends Node

##HACK resolution of the graph (points per unit)
@export var line_chart: LineChart

func analyse_sample(sample: Sample, program: Program) -> PackedVector2Array:
	var dataset: PackedVector2Array
	var t: PackedFloat32Array = range(0, program.max_domain * line_chart.resolution)
	for ti in t:
		ti /= line_chart.resolution
		var intensity: float = sample_intensity(ti * program.flow_speed, sample)
		dataset.append(Vector2(ti, intensity))
	return dataset

func sample_intensity(ti: float, sample: Sample) -> float:
	var intensity: float = 0.0
	for analyte: ContainedAnalyte in sample.analytes:
		intensity += asymmetric_gaussian(ti, analyte.amount * 1000, analyte.analyte.retention_time)
		
	return intensity

##HACK using area, peak_width, std_dev_left, std_dev_right isn't logical as amount (overall and specific) and program should define it
func asymmetric_gaussian(x: float, area: float, mean: float, sigma_left: float = 0.1, sigma_right: float = 0.1) -> float:
	## Calculate the effective standard deviation for normalization
	var sigma_effective: float = (sigma_left + sigma_right) / 2.0
	
	# Calculate the amplitude based on the desired area and effective standard deviation
	var amplitude: float = area / (sigma_effective * sqrt(2 * PI))
	
	var y:float
	if x <= mean:
		y = amplitude * exp(-(x - mean)**2 / (2 * sigma_left**2))
	elif x > mean:
		y = amplitude * exp(-(x - mean)**2 / (2 * sigma_right**2))
		
	return y
