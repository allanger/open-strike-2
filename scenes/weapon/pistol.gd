extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# TODO: Handle the shot logic
func shot():
	var pistol := $DEAGLE
	pistol.rotate_z(20.0)


# TODO: Handle the reload logic
func reload():
	var pistol := $DEAGLE
	pistol.rotate_z(-20.0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
