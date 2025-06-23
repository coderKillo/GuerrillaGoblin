class_name Utils


static func findByClass(node: Node, className: String, result: Array) -> void:
	if node.is_class(className):
		result.push_back(node)
	for child in node.get_children():
		findByClass(child, className, result)


static func ground_position_3d(position: Vector2, world: World3D) -> Vector3:
	var ground_position = Math.to_3d(position, 0)

	var big_distance = 10000
	var virtual_camera_3d_position = ground_position - (Globals.CAMERA_3D_NORMAL * big_distance)

	var query = PhysicsRayQueryParameters3D.create(virtual_camera_3d_position, ground_position)
	query.collision_mask = Globals.COLLISION_LAYER.GROUND

	var result = world.direct_space_state.intersect_ray(query)
	# DebugDraw3D.draw_line(virtual_camera_3d_position, ground_position, Color(1, 1, 0), 1.0)

	if result:
		return result.position
	else:
		return ground_position


static func get_global_mouse_position_3d(viewport: Viewport) -> Vector3:
	return ground_position_3d(
		viewport.get_camera_2d().get_global_mouse_position(),
		viewport.get_camera_3d().get_world_3d()
	)


static func time_to_string(time_s: int) -> String:
	var hours = int(time_s / 3600.0) % 24
	var minutes = int(time_s / 60.0) % 60
	var seconds = int(time_s) % 60

	if hours > 0:
		return "%02d:%02d:%02d" % [hours, minutes, seconds]
	else:
		return "%02d:%02d" % [minutes, seconds]
