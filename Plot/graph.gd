extends Control

@export_category("Chart Data")
@export var chart: PackedVector2Array
@export var line_color: Color
## if the value is positive, it will scale with the zoom; if the vale is negative, the line width will be viewport based and it won't be affected by zoom
@export var line_width: float

@export_category("Tree Nodes")
## ScrollContainer, used to get the graph visible size
@export var graph_container: ScrollContainer
var graph_container_size: Vector2: 
	set(value):
		graph_container_size = value
		graduation.graph_container_size = value

## Node for the calculation of the graduations
@export var graduation: Node

@export_category("User Experience")
## amount of zoom for each scroll input
@export var zoom_step: float
var zoom_step_vector: Vector2

## is the graph being panned
var panning: bool
## mouse position taken at the start of panning
var panning_position: Vector2


## defines the limit to which the plot can be moved
var panning_limit: Vector2

##define the maximum scale to avoid exiting the graph
var scale_limit: Vector2

## Connected to the graph_container resized() signal, called a little after ready on startup
func graph_container_resized() -> void:
	graph_container_size = graph_container.size
	set_panning_limit()
	
	var axis_scale_limit =  max(graph_container_size.x / size.x, graph_container_size.y / size.x)
	print(axis_scale_limit)
	scale_limit = Vector2(axis_scale_limit, axis_scale_limit)

## called on zoom
func clamp_position() ->void:
	set_panning_limit()
	position.x = clamp(position.x, panning_limit.x, 0)
	position.y = clamp(position.y, panning_limit.y, 0)
	

func set_panning_limit() ->void:
	panning_limit = graph_container_size - size * scale

func _ready() -> void:
	## transfer the export zoom step value to the vector2
	zoom_step_vector = Vector2(zoom_step, zoom_step)
	##draw the line on init
	#queue_redraw()

func _draw() -> void:
	draw_polyline(chart, line_color, line_width)

## Called when the input is done as the graph is moused over, also works when releasing outside of the graph
func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if Input.is_action_just_pressed("panning"):
			activate_panning()
			print("panning")
		if Input.is_action_just_released("panning"):
			deactivate_panning()
			print("no panning")
		if Input.is_action_just_released("zoom_in"):
			if !panning:
				scale = scale + zoom_step_vector
				clamp_position()
				graduation.recalculate()
		if Input.is_action_just_released("zoom_out"):
			if !panning:
				var new_scale =  max(scale.x - zoom_step, scale_limit.x)
				scale = Vector2(new_scale, new_scale)
				clamp_position()
				graduation.recalculate()


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if panning:
			var new_position = position + event.relative
			position.x = clamp(new_position.x, panning_limit.x, 0)
			position.y = clamp(new_position.y, panning_limit.y, 0)
			graduation.recalculate()


func activate_panning() ->void:
	panning = true
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	panning_position = get_viewport().get_mouse_position()


func deactivate_panning() ->void:
	panning = false
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	get_viewport().warp_mouse(panning_position)
