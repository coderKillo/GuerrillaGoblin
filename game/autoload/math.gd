class_name Math

static var _gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


static func to_2d(vector: Vector3) -> Dictionary:
	return {
		position =
		Vector2(
			vector.x * Globals.SCALE * Globals.BASE_VECTOR.x,
			vector.z * Globals.SCALE * Globals.BASE_VECTOR.z
		),
		offset = vector.y * Globals.SCALE * Globals.BASE_VECTOR.y
	}


static func to_2d_vector(vector: Vector3) -> Vector2:
	var result = to_2d(vector)
	return Vector2(result.position.x, result.position.y - result.offset)


static func to_3d(vector: Vector2, offset: float) -> Vector3:
	return Vector3(
		vector.x / Globals.SCALE / Globals.BASE_VECTOR.x,
		offset / Globals.SCALE / Globals.BASE_VECTOR.y,
		vector.y / Globals.SCALE / Globals.BASE_VECTOR.z
	)


static func arc_start_velocity(start: Vector3, end: Vector3, time: float) -> Vector3:
	return Vector3(
		(end.x - start.x) / time,
		(end.y - start.y) / time + _gravity * time * 0.5,
		(end.z - start.z) / time
	)


static func arc_end_velocity(start: Vector3, end: Vector3, time: float) -> Vector3:
	return Vector3(
		(end.x - start.x) / time,
		(end.y - start.y) / time - _gravity * time * 0.5,
		(end.z - start.z) / time
	)


static func set_arc(curve: Curve2D, start: Vector3, end: Vector3, time: float):
	var start_velocity = arc_start_velocity(start, end, time)
	var end_velocity = arc_end_velocity(start, end, time)

	curve.set_point_position(0, to_2d_vector(start))
	curve.set_point_position(1, to_2d_vector(end))
	curve.set_point_out(0, to_2d_vector(start_velocity) / 3.0)
	curve.set_point_in(1, -to_2d_vector(end_velocity) / 3.0)
