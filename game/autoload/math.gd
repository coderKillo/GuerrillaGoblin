class_name Math


static func to_2d(vector: Vector3) -> Dictionary:
	return {
		position =
		Vector2(
			vector.x * Globals.SCALE * Globals.BASE_VECTOR.x,
			vector.z * Globals.SCALE * Globals.BASE_VECTOR.z
		),
		offset = vector.y * Globals.SCALE * Globals.BASE_VECTOR.y
	}


static func to_3d(vector: Vector2, offset: float) -> Vector3:
	return Vector3(
		vector.x / Globals.SCALE / Globals.BASE_VECTOR.x,
		offset / Globals.SCALE / Globals.BASE_VECTOR.y,
		vector.y / Globals.SCALE / Globals.BASE_VECTOR.z
	)
