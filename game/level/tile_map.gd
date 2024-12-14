@tool
extends TileMap

@export var update := false
@export var grid : GridMap


func _process(_delta):
	if not update:
		return

	update = false

	if grid != null:
		_generate_gridmap()
	else:
		printerr("no gridmap set")

func _generate_gridmap():
	grid.clear()
	for layer_index in get_layers_count():
		var height := _sort_origin_to_height(get_layer_y_sort_origin(layer_index))
		if height < 0:
			printerr("invalid y_sort_origin: %s on layer: %s" % [get_layer_y_sort_origin(layer_index), get_layer_name(layer_index)])
			continue
			
		for cell in get_used_cells(layer_index):
			if get_cell_tile_data(layer_index, cell).get_custom_data("Ground"):
				print(cell)
				var pos := Vector3(cell.x,height,cell.y + height)
				grid.set_cell_item(pos, 0)


func _sort_origin_to_height(sort_origin: int) -> int:
	match sort_origin:
		-32:
			return 0
		32:
			return 1
		96:
			return 2
		96:
			return 2
			
		_:
			return -1
