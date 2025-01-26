extends ColorRect

@export var inner_plot: Control
@export var tick_step: float
@export var grid_color: Color
@export var text_margin: int
@export var chart_theme: Theme

var labels: Array[Label]

func _ready() -> void:
	call_deferred("axis_setup")



func axis_setup()->void:
	size.x = inner_plot.size.x
	size.y = size.y
	labels = []
	for child in get_children():
		child.queue_free()
	#add labels to the grid tick_marks
	for point in range(0, size.x/tick_step / 100 + 1):
		var new_label: Label = Label.new()
		add_child(new_label)
		labels.append(new_label)
		new_label.theme = chart_theme
		new_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		new_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		new_label.position = Vector2(point * tick_step * 100 - 2, size.y - text_margin)
		new_label.text = str(point)
	_on_inner_plot_item_rect_changed()

func _draw() -> void:
	#get each tick_mark point based on the tick step
	for point in range(0, size.x/tick_step / 100):
		#draw the grid line
		draw_line(Vector2(point * tick_step * 100, 0), Vector2(point * tick_step * 100, size.y - text_margin), grid_color)


func _on_inner_plot_item_rect_changed() -> void:
	#scale the grid according to the plot
	scale.x = inner_plot.scale.x
	
	#position the grid accordingly to the plot
	position.x = inner_plot.position.x
	
	#correct scaling on the axis labels (corrects the stretching caused by anisotropic scaling)
	for label in labels:
		label.scale.x = 1.0 / scale.x


func _on_plot_container_resized() -> void:
	call_deferred("axis_setup")
