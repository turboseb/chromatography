extends Button

@export var input_name: String


func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed(input_name):
		disabled = false
		
	if Input.is_action_just_released(input_name):
		disabled = true
