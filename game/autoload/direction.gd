extends Node2D

enum { LEFT, LEFT_UP, LEFT_DOWN, RIGHT, RIGHT_UP, RIGHT_DOWN }


func from_angle(rad: float) -> int:
	var angle := rad_to_deg(rad)

	if angle > -45 && angle <= 45:
		return RIGHT
	elif angle > 45 && angle <= 90:
		return RIGHT_DOWN
	elif angle > 90 && angle <= 135:
		return LEFT_DOWN
	elif angle > 135 && angle <= 180:
		return LEFT
	elif angle > -90 && angle <= -45:
		return RIGHT_UP
	elif angle > -135 && angle <= -90:
		return LEFT_UP
	elif angle > -180 && angle <= -135:
		return LEFT

	return LEFT
