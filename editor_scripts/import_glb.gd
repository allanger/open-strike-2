@tool
extends EditorScript


# Called when the script is executed (using File -> Run in Script Editor).
func _run() -> void:
	print("running")
	# Path to the folder containing the .glb files (adjust as needed)
	var glb_folder = "res://assets/models/kenney/RetroUrban/"  # Change to your folder path
	var files = []
	
	# Get a list of all .glb files in the folder
	var dir = DirAccess.open(glb_folder)
	if dir:
		dir.list_dir_begin()
		while true:
			var file_name = dir.get_next()
			if file_name == "":
				break
			if file_name.ends_with(".glb"):
				files.append(file_name)
		dir.list_dir_end()
	else:
		print("Failed to open directory: " + glb_folder)
		return
	
	# Process each .glb file
	for file_name in files:
		var file_path = glb_folder + file_name
		print("Processing: ", file_path)
		
		# Load the .glb file
		var scene: PackedScene = ResourceLoader.load(file_path)
		if scene:
			# Instance the scene and generate physics
			var root = scene.instantiate()
			if root:
				generate_physics(root)
				
				# Save the new scene
				var save_path = file_path.replace(".glb", ".tscn")
				ResourceSaver.save(save_path, root)
				print("Saved: ", save_path)
		else:
			print("Failed to load: " + file_path)
			
# Generate static body physics for the mesh
func generate_physics(node):
	for child in node.get_children():
		if child is MeshInstance3D:
			var static_body = StaticBody3D.new()
			var collision_shape = CollisionShape3D.new()
			
			# Generate collision shape from mesh
			var shape = child.mesh.create_convex_shape()
			if shape:
				collision_shape.shape = shape
				static_body.add_child(collision_shape)
				static_body.global_transform = child.global_transform
				node.add_child(static_body)
				print("Added physics for: ", child.name)
				
		# Recursively process child nodes
		generate_physics(child)
