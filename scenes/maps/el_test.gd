extends Node3D

var player_side: String

@onready var intro_camera = $Intro/CameraMount/IntroCamera
@onready var intro_view_port = $Intro/CameraMount/IntroCamera/SubViewportContainer/SubViewport
@onready var spawns = $Spawns
@onready var root = $'.' 
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var char : Node3D = null
	var red_spawn: Node3D = $Spawns/Blue/SpawnArea
	var position := red_spawn.global_position
	char = ResourceLoader.load("res://scenes/utils/character.tscn").instantiate()
	char.global_position = position
	root.add_child(char)
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
