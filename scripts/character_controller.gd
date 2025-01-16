# ---------------------------------------------------------------------
# This script is supposed to handle character movement logic
# ---------------------------------------------------------------------
class_name Player extends CharacterBody3D

@export_category("Player")
@export_range(1, 35, 1) var speed: float = 11 # m/s
@export_range(10, 400, 1) var acceleration: float = 90 # m/s^2

@export_range(0.1, 3.0, 0.1) var jump_height: float = 1 # m
@export_range(0.1, 3.0, 0.1, "or_greater") var camera_sens: float = 1

@onready var upper_torso: CSGSphere3D = $UpperTorso
@onready var upper_torso_default_position: Vector3 = upper_torso.position
@export var ANIMATION_PLAYER : AnimationPlayer
@onready var body: Node3D = $RealBody
var jumping: bool = false
var mouse_captured: bool = false

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

var move_dir: Vector2 # Input direction for movement
var look_dir: Vector2 # Input direction for look/aim

var walk_vel: Vector3 # Walking velocity 
var grav_vel: Vector3 # Gravity velocity 
var jump_vel: Vector3 # Jumping velocity

var is_crouch: bool = false

@onready var camera: Node3D = $UpperTorso
@onready var character: Node3D = $"."

func _ready() -> void:
	capture_mouse()
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		look_dir = event.relative * 0.001
		if mouse_captured: _rotate_camera()
	if Input.is_action_just_pressed("jump"): jumping = true
	if Input.is_action_just_pressed("exit"): get_tree().quit()
	if Input.is_action_just_pressed("shot"): $UpperTorso/Pistol.shot()
	if Input.is_action_just_pressed("reload"): $UpperTorso/Pistol.reload()
	if Input.is_action_just_pressed("crouch"): crouch()
	if Input.is_action_just_released("crouch"): uncrouch()
	

func _physics_process(delta: float) -> void:
	if mouse_captured: _handle_joypad_camera_rotation(delta)
	velocity = _walk(delta) + _gravity(delta) + _jump(delta)
	
	move_and_slide()

func capture_mouse() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	mouse_captured = true

func release_mouse() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	mouse_captured = false

func _rotate_camera(sens_mod: float = 1.0) -> void:
	character.rotation.y -= look_dir.x * camera_sens * sens_mod
	camera.rotation.x = clamp(camera.rotation.x - look_dir.y * camera_sens * sens_mod, -1.5, 1.5)

func _handle_joypad_camera_rotation(delta: float, sens_mod: float = 1.0) -> void:
	var joypad_dir: Vector2 = Input.get_vector("look_left","look_right","look_up","look_down")
	if joypad_dir.length() > 0:
		look_dir += joypad_dir * delta
		_rotate_camera(sens_mod)
		look_dir = Vector2.ZERO

func _walk(delta: float) -> Vector3:
	move_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backwards")
	var _forward: Vector3 = camera.global_transform.basis * Vector3(move_dir.x, 0, move_dir.y)
	var walk_dir: Vector3 = Vector3(_forward.x, 0, _forward.z).normalized()
	#_crouch(delta)
	var cur_speed: float
	if is_crouch:
		cur_speed = speed / 3
		#upper_torso.position.y -= 10 
	else:
		cur_speed = speed
	if Input.is_action_pressed("silent_walk"): 
		walk_vel = walk_vel.move_toward(walk_dir * (cur_speed / 1.5) * move_dir.length(), (acceleration / 1.5) * delta)
	else:
		walk_vel = walk_vel.move_toward(walk_dir * cur_speed * move_dir.length(), acceleration * delta)
	var body := $character
	
	return walk_vel

func crouch():
	ANIMATION_PLAYER.play("Crouch", -1, 7.0)
	is_crouch = true
	
func uncrouch():
	ANIMATION_PLAYER.play("Crouch", -1, -7.0)
	is_crouch = false
	

func _gravity(delta: float) -> Vector3:
	grav_vel = Vector3.ZERO if is_on_floor() else grav_vel.move_toward(Vector3(0, velocity.y - gravity, 0), gravity * delta)
	return grav_vel

func _jump(delta: float) -> Vector3:
	if jumping:
		if is_on_floor(): jump_vel = Vector3(0, sqrt(4 * jump_height * gravity), 0)
		jumping = false
		return jump_vel
	jump_vel = Vector3.ZERO if is_on_floor() else jump_vel.move_toward(Vector3.ZERO, gravity * delta)
	return jump_vel
