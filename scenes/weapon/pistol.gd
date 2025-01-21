extends Node3D

var bullet = load("res://scenes/weapon/bullet.tscn")
var instance

@onready var gun_anim = $Pistol/DEAGLE/GunAnimation
#@onready var gun_barrel = $DEAGLE/CSGSphere3D
@onready var gun_barrel = $Pistol/DEAGLE/RayCast3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# TODO: Handle the shot logic
func shot():
	var main_root = get_node("/root/TestMap")
	if Input.is_action_pressed("shot"):
		if !gun_anim.is_playing():
			gun_anim.play("Shoot")
			instance = bullet.instantiate()
			instance.position = gun_barrel.global_position
			instance.transform.basis = gun_barrel.global_transform.basis
			get_tree().get_root().add_child(instance)
			main_root.add_child(instance)

# TODO: Handle the reload logic
func reload():
	var pistol := $DEAGLE
	pistol.rotate_z(-20.0)
