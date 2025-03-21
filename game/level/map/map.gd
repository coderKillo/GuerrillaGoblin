@tool
extends TileMap

const LAYER = 0
const CUSTOM_DATA_LAYER = 0
const DEADZONE = "Deadzone"

var _character_death_damage := Settings.base_health * 5.0

@export_group("World Boundary")
@export var world_top_left := Vector2(0, 0):
	set(value):
		world_top_left = value
		queue_redraw()

@export var world_size := Vector2(1024, 768):
	set(value):
		world_size = value
		queue_redraw()

@export var boundary_color := Color(0, 1, 0, 0.3):
	set(value):
		boundary_color = value
		queue_redraw()


func _ready():
	queue_redraw()

	if not Engine.is_editor_hint():
		_set_camera_limits()


func _draw():
	if Engine.is_editor_hint():
		draw_rect(Rect2(world_top_left, world_size), boundary_color, false, 64.0)


func _process(_delta):
	if Engine.is_editor_hint():
		return

	for player in get_tree().get_nodes_in_group("player"):
		if _is_in_deadzone(player):
			player.hit(_character_death_damage)
		if _is_out_of_boundary(player):
			player.hit(_character_death_damage)

	for enemy in get_tree().get_nodes_in_group("enemy"):
		if _is_in_deadzone(enemy):
			enemy.hit(_character_death_damage)
		if _is_out_of_boundary(enemy):
			enemy.hit(_character_death_damage)


func _is_in_deadzone(entity: Node2D) -> bool:
	var air_component = entity.get_node_or_null("AirComponent") as AirComponent
	if not air_component:
		return false
	if air_component.is_in_air():
		return false

	var coords := local_to_map(entity.position)
	var tile_data := get_cell_tile_data(LAYER, coords)

	if not tile_data:
		return false

	return tile_data.get_custom_data_by_layer_id(CUSTOM_DATA_LAYER)


func _is_out_of_boundary(entity: Node2D) -> bool:
	var rect = Rect2(world_top_left, world_size)
	return not rect.has_point(entity.global_position)


func _set_camera_limits():
	var camera := get_viewport().get_camera_2d()
	camera.limit_left = int(world_top_left.x)
	camera.limit_top = int(world_top_left.y)
	camera.limit_right = int(world_top_left.x + world_size.x)
	camera.limit_bottom = int(world_top_left.y + world_size.y)
