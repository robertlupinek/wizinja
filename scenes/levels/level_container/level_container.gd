extends Node2D

@export var read_go_scene: PackedScene
@export var set_scene_as_checkpoint: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	# Load the fun little start text and sounds
	var ready_go = read_go_scene.instantiate()
	add_child(ready_go)
	# Set scene as starting checkpoint
	if set_scene_as_checkpoint:
		GameState.scene = scene_file_path

