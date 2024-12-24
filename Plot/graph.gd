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
	if panning:
		return
	graph_container_size = graph_container.size
	set_panning_limit()
	
	var scale_limit_x =  graph_container_size.x / size.x
	var scale_limit_y =  graph_container_size.y / size.y
	scale_limit = Vector2(scale_limit_x, scale_limit_y)
	print(scale_limit)

## called on zoom
func clamp_position(new_position_x: float = , new_position_y: float = ) ->void:
	set_panning_limit()
	if new_position_x:
		position.x = clamp(new_position_x, panning_limit.x, 0)
	if new_position_y:
		position.y = clamp(new_position_y, panning_limit.y, 0)
	
	

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
		if Input.is_action_just_released("y_zoom_in"):
			if !panning:
				zoom_in_y()
				return
		if Input.is_action_just_released("y_zoom_out"):
			if !panning:
				zoom_out_y()
				return
		
		if Input.is_action_just_released("x_zoom_in"):
			if !panning:
				zoom_in_x()
				return
		if Input.is_action_just_released("x_zoom_out"):
			if !panning:
				zoom_out_x()
				return
		
		
		if Input.is_action_just_released("zoom_in"):
			if !panning:
				zoom_in_x()
				zoom_in_y()
				#var new_scale = scale + zoom_step_vector
				#var scale_ratio = Vector2(new_scale.x/scale.x - 1, new_scale.y/scale.y - 1)
				#
				#var new_position = position + (global_position - get_viewport().get_mouse_position()) * scale_ratio
				#scale = new_scale
				#clamp_position(new_position.x, new_position.y)
				#graduation.recalculate()
				
		if Input.is_action_just_released("zoom_out"):
			if !panning:
				zoom_out_x()
				zoom_out_y()
				#var new_scale =  Vector2(max(scale.x - zoom_step, scale_limit.x), max(scale.y - zoom_step, scale_limit.y))
				#var scale_ratio = new_scale/scale - Vector2(1, 1)
				#var new_position = position + (global_position - get_viewport().get_mouse_position()) * scale_ratio
				#scale = new_scale
				#clamp_position(new_position.x, new_position.y)
				#graduation.recalculate()

func zoom_in_x():
	var new_scale_x = scale.x + zoom_step
	var scale_ratio_x = new_scale_x/scale.x - 1
				
	var new_position_x = position.x + (global_position.x - get_viewport().get_mouse_position().x) * scale_ratio_x
	scale.x = new_scale_x
	clamp_position(new_position_x, position.y)
	graduation.recalculate()

func zoom_out_x():
	var new_scale_x = max(scale.x - zoom_step, scale_limit.x)
	var scale_ratio_x = new_scale_x/scale.x - 1
				
	var new_position_x = position.x + (global_position.x - get_viewport().get_mouse_position().x) * scale_ratio_x
	scale.x = new_scale_x
	clamp_position(new_position_x, position.y)
	graduation.recalculate()

func zoom_in_y():
	var new_scale_y = scale.y + zoom_step
	var scale_ratio_y = new_scale_y/scale.y - 1
				
	var new_position_y = position.y + (global_position.y - get_viewport().get_mouse_position().y) * scale_ratio_y
	scale.y = new_scale_y
	clamp_position(position.x, new_position_y)
	graduation.recalculate()

func zoom_out_y():
	var new_scale_y = max(scale.y - zoom_step, scale_limit.y)
	var scale_ratio_y = new_scale_y/scale.y - 1
				
	var new_position_y = position.y + (global_position.y - get_viewport().get_mouse_position().y) * scale_ratio_y
	scale.y = new_scale_y
	clamp_position(position.x, new_position_y)
	graduation.recalculate()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if panning:
			var new_position = position + event.relative
			clamp_position(new_position.x, new_position.y)
			$"../Label".text = "X: " + str(position.x) + "\nY: " + str(position.y)
			graduation.recalculate()


func activate_panning() ->void:
	panning = true
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	panning_position = get_viewport().get_mouse_position()


func deactivate_panning() ->void:
	panning = false
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	get_viewport().warp_mouse(panning_position)
