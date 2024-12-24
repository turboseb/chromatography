extends Node


@export var graph: Control
var graph_container_size: Vector2

@export_category("XAxis")
@export var min_x: Label
@export var max_x: Label


@export_category("YAxis")
@export var min_y: Label
@export var max_y: Label


## called whenever the plot is rescaled/repositioned
func recalculate() ->void:
	min_x.text = "%.1f" % (-graph.position.x / graph.size.x / graph.scale.x * 100) + "%"
	max_x.text = "%.1f" % ((-graph.position.x + graph_container_size.x) / graph.size.x / graph.scale.x * 100) + "%"
	
	## these dont even need to use the y scale value, but in case of potential future modifications, they're kept that way
	min_y.text = "%.1f" % (100 - (-graph.position.y / graph.size.y / graph.scale.y * 100)) + "%"
	max_y.text = "%.1f" % (100 - (-graph.position.y + graph_container_size.y) / graph.size.y / graph.scale.y * 100) + "%"
