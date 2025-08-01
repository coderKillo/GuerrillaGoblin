class_name Globals

const SCALE = 64
const BASE_VECTOR = Vector3(1.0, sqrt(2.0) / 2.0, sqrt(2.0) / 2.0)
const CAMERA_3D_NORMAL = Vector3(0, -1, -1)

enum COLLISION_LAYER {
	PLAYER = 1 << 0,
	ENEMY = 1 << 1,
	INTERACTIBLE = 1 << 2,
	MOVEABLE = 1 << 3,
	STATIC = 1 << 4,
	GROUND = 1 << 8,
	WALL = 1 << 9,
	FORCE = 1 << 12,
	FIRE = 1 << 13,
	FLAMABLE = 1 << 14,
}

const BUTTON_GROUP = "button"

const IGNITION_CHARGE_INTERVAL = 0.5
