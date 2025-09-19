extends GraphEdit



func _on_connection_request(from_node: StringName, from_port: int, to_node: StringName, to_port: int) -> void:
	if from_node == to_node: return
	var current_connections: Array[Dictionary] = get_connection_list()
	
	## Check if the ports are already connected
	for connection in current_connections:
		if connection.get("from_node") == from_node or connection.get("to_node") == to_node:
			disconnect_node(connection.get("from_node"), connection.get("from_port"), connection.get("to_node"), connection.get("to_port"))
			
			## reset old right slot icon
			var old_from_node: GraphNode = get_node(str(connection.get("from_node")))
			old_from_node.set_slot_custom_icon_right(0, old_from_node.get_meta("right_slot_image", ImageTexture.new()))
			
			## reset old left slot icon
			var old_to_node: GraphNode = get_node(str(connection.get("to_node")))
			old_to_node.set_slot_custom_icon_left(0, old_to_node.get_meta("left_slot_image", ImageTexture.new()))
			
	connect_node(from_node, from_port, to_node, to_port)
	get_node(str(from_node)).set_slot_custom_icon_right(0, ImageTexture.new())
	get_node(str(to_node)).set_slot_custom_icon_left(0, ImageTexture.new())
	


func _on_disconnection_request(from_node: StringName, from_port: int, to_node: StringName, to_port: int) -> void:
	disconnect_node(from_node, from_port, to_node, to_port)
	var old_from_node: GraphNode = get_node(str(from_node))
	old_from_node.set_slot_custom_icon_right(0, old_from_node.get_meta("right_slot_image", ImageTexture.new()))
	var old_to_node: GraphNode = get_node(str(to_node))
	old_to_node.set_slot_custom_icon_left(0, old_to_node.get_meta("left_slot_image", ImageTexture.new()))
