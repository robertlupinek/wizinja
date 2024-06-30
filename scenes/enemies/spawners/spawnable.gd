extends Node2D

# This script will can be used to configure spawnable objects.
# This includes effects for spawing in scene and any other object specific scripts.

# Assigned the animation node used for spawning effects ( mostly shaders)
var animation: AnimatedSprite2D
# 
var spawning: bool = false
var enemy_base: CharacterBody2D = null
# How long to show effects for spawning
var show_time: float
# Spawn Particles
@export var spawn_particles: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _spawn_effects(effect_time:float):
	# Get the animation 2d if their an EnemyBase node
	enemy_base = get_node("EnemyBase")
	if enemy_base:
		animation = enemy_base.get_node("AnimatedSprite2D")
	# Tween to scale object up
	var old_scale: Vector2 = scale
	scale = Vector2(0.4,0.4)
	var tween = get_tree().create_tween()
	tween.tween_property(self, "scale", old_scale,effect_time).set_trans(Tween.TRANS_BOUNCE )
	# Setup the spawnable object's AnimatedSprite2D material shader effects for the win
	animation.material.set_shader_parameter("active",true)
	# Create particles
	# Create particles for spawn effect
	var particle = spawn_particles.instantiate()
	var world = get_tree().current_scene 
	particle.global_position = global_position
	world.add_child(particle)	
