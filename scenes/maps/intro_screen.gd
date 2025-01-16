extends Node3D

var target_node_name: String = "TargetNode" # Name of the Node3D to detect

@onready var raycast : RayCast3D =  $CameraMount/Camera3D/RayCast3D
@onready var camera : Camera3D = $CameraMount/Camera3D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var blue := $ChooseTeam/Blue
	var red := $ChooseTeam/Read
	if 
	if raycast.is_colliding():
		var collider = raycast.get_collider()
		if collider and collider.name == target_node_name:
			print("Mouse is pointing at:", collider.name)
		else:
			print("Mouse is not pointing at the target node.")
	else:
		print("Mouse is not pointing at anything.")
