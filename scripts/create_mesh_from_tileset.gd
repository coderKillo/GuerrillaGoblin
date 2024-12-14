@tool
extends EditorScript


# Called when the script is executed (using File -> Run in Script Editor).
func _run():
	# Load the tileset 
	var tileset = load('res://game/level/map.tres') as TileSet

	# Get the first source as an atlas source
	var source = tileset.get_source(0) as TileSetAtlasSource

	# Create the material for the mesh with the texture from the atlas source
	var material = StandardMaterial3D.new()
	material.albedo_texture = source.texture
	material.texture_filter = BaseMaterial3D.TEXTURE_FILTER_NEAREST

	var meshes:Array = []

	for i in source.get_tiles_count():
		# For each tile get its coordinates in the atlas
		var coords = source.get_tile_id(i)
		# Get its texture region
		var rect = source.get_tile_texture_region(coords)

		# Convert that texture region to uv coordinates
		var uv_rect = Rect2()
		uv_rect.position.x = remap(rect.position.x, 0, source.texture.get_size().x, 0.0, 1.0)
		uv_rect.position.y = remap(rect.position.y, 0, source.texture.get_size().y, 0.0, 1.0)
		uv_rect.end.x = remap(rect.end.x, 0, source.texture.get_size().x, 0.0, 1.0)
		uv_rect.end.y = remap(rect.end.y, 0, source.texture.get_size().y, 0.0, 1.0)

		# Create the mesh
		var mesh = create_mesh(uv_rect, material)

		# Save the mesh and coordinates for later
		meshes.push_back({
			"mesh": mesh,
			"coords": coords
		})

	# Generate the mesh previews
	var previews = get_editor_interface().make_mesh_previews(meshes.map(func(data): return data.mesh), 128)

	# Create a new mesh library
	var mesh_library = MeshLibrary.new()

	for i in meshes.size():
		var mesh = meshes[i].mesh
		var coords = meshes[i].coords
		var preview = previews[i]

		# For each mesh get a new id, add the mesh to the mesh library, set the name to the coords and
		# set its preview texture
		var id = mesh_library.get_last_unused_item_id()
		mesh_library.create_item(id)
		mesh_library.set_item_mesh(id, mesh)
		mesh_library.set_item_name(id, 'Tile %s' % coords)
		mesh_library.set_item_preview(id, preview)

		# If you want to save each mesh as a files you can uncomment this and give it an existing path
		# ResourceSaver.save(mesh, 'res://tileset_meshes/tile_%s.res' % i)

	# Finally, save the mesh library
	ResourceSaver.save(mesh_library, "res://game/level/map_meshlibary.res")


func create_mesh(rect:Rect2, material:StandardMaterial3D) -> Mesh:
	# Create a new mesh with the SurfaceTool
	var st = SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	# top-right vertex
	st.set_uv(Vector2(rect.end.x, rect.position.y))
	st.add_vertex(Vector3(1, 0, 1))
	# top-left vertex
	st.set_uv(Vector2(rect.position.x, rect.position.y))
	st.add_vertex(Vector3(0, 0, 1))
	# bottom-left vertex
	st.set_uv(Vector2(rect.position.x, rect.end.y))
	st.add_vertex(Vector3.ZERO)
	# bottom-right vertex
	st.set_uv(Vector2(rect.end.x, rect.end.y))
	st.add_vertex(Vector3(1, 0, 0))
	# top-right vertex
	st.set_uv(Vector2(rect.end.x, rect.position.y))
	st.add_vertex(Vector3(1, 0, 1))
	# bottom-left vertex
	st.set_uv(Vector2(rect.position.x, rect.end.y))
	st.add_vertex(Vector3.ZERO)

	# I don't know if this is needed but it won't hurt
	st.generate_normals()

	# get the mesh from the surface tool
	var mesh = st.commit()

	# set the material we created before
	mesh.surface_set_material(0, material)

	return mesh
