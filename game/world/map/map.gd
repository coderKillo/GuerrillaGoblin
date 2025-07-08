@tool
class_name Map
extends Node2D

const BASE_Y_ORIGIN = -32
const BASE_Z_INDEX = -1

@export_group("Grid")
@export_tool_button("Generate Grid") var generate_gridmap := _generate_gridmap
@export var grid: GridMap

@export_group("Layer")
@export_tool_button("Add Water Level") var add_water := _add_water_level
@export var current_level := 0
@export_tool_button("Add Ground Level") var add_ground := _add_ground_level


func _generate_gridmap():
	grid.clear()
	for child in get_children():
		var layer := child as TileMapLayer
		if not layer:
			continue

		var height = layer.z_index - BASE_Z_INDEX

		for cell in layer.get_used_cells():
			if layer.get_cell_tile_data(cell).get_custom_data("Ground"):
				var pos := Vector3(cell.x, height, cell.y + height)
				grid.set_cell_item(pos, 0)

	grid.get_parent().bake_navigation_mesh()


func _add_water_level():
	if get_child_count() > 0 and get_child(0).name == "Water":
		return

	_create_layer("Water", BASE_Y_ORIGIN, BASE_Z_INDEX)
	_create_layer("Foam", BASE_Y_ORIGIN, BASE_Z_INDEX)


func _add_ground_level():
	var z_index_layer = BASE_Z_INDEX + current_level
	var y_sort_origin_ground = BASE_Y_ORIGIN + Globals.SCALE * (current_level + 1)
	_create_layer("Ground%s" % current_level, y_sort_origin_ground, z_index_layer)
	_create_layer("Ground%s_Decorator1" % current_level, y_sort_origin_ground, z_index_layer)
	_create_layer("Ground%s_Decorator2" % current_level, y_sort_origin_ground, z_index_layer)

	if current_level > 0:
		var y_sort_origin_wall = BASE_Y_ORIGIN + Globals.SCALE * current_level
		_create_layer("Wall%s" % current_level, y_sort_origin_wall, z_index_layer)
		_create_layer("Wall%s_Decorator" % current_level, y_sort_origin_wall, z_index_layer)

	current_level += 1


func _create_layer(
	layer_name: String, layer_y_sort_origin: int, layer_z_index: int
) -> TileMapLayer:
	var layer = TileMapLayer.new()
	layer.name = layer_name
	layer.y_sort_origin = layer_y_sort_origin
	layer.z_index = layer_z_index
	layer.y_sort_enabled = true
	layer.tile_set = load("res://game/world/map/map_tileset.tres")

	add_child(layer)
	layer.owner = get_tree().edited_scene_root

	return layer
