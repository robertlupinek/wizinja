extends Node2D

# Entity layer is used define which entity layer to enable and make visible.
# There is a setter method that _layer_change that handles all of the active/visible logic.
var entity_layer: int = -1
# Timer used to trigger the switch to the new entity layer
var layer_timer: Timer = Timer.new()
# When to start showing where enemies will be
@export var show_time: float = 1.5
# How long to wait before enabling enemies
@export var layer_time: float = 5
var show_once: bool = false

# 
# Spawn Particles
@export var spawn_particles: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	## Disable all children regardless of layer 
	_all_layers_off()
	add_child(layer_timer)
	layer_timer.one_shot = true
	layer_timer.start(layer_time)
	## Start on -1 simply because there MOST like won't be any layer -1 children
	entity_layer = -1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	print(layer_timer.time_left)
	# Unhide the entities on the next layer only once ( if shown_yet is false )
	## We do this to show the entity and setup effects for it's intro
	## Most enetities should use shaders for the their effect + the spawner partilces
	if  !layer_timer.is_stopped() and layer_timer.time_left <= show_time and !show_once:
		# We only want to trigger this step once per spawn in
		show_once = true
		_config_entity_layer(entity_layer+1,true,Node.PROCESS_MODE_DISABLED,true )

	
	# Set entity layer up plus 1 when the timer is stopped and enable entities at that layer
	if layer_timer.is_stopped():
		entity_layer += 1
		## Turn on all visibility and inherit process mode for all children nodes on entity_layer
		_config_entity_layer(entity_layer,true,Node.PROCESS_MODE_INHERIT,false)
		print(entity_layer)
		layer_timer.start(layer_time)
		show_once = false
		

		
# This method will disable all entities under the child nodes
func _all_layers_off():
	for child in get_children():
		child.visible = false
		child.process_mode = Node.PROCESS_MODE_DISABLED	
# Setter for 
func _config_entity_layer(layer,is_visible,process,create_particle=false):
	
	for child in get_children():
		if child is Timer:
			pass		
		else:
			if child.z_index == layer:
				## Make child node visible and any objects under that inherit visible state
				child.visible = is_visible
				## Set process state for child node
				child.process_mode = process
				
				for grand_child in child.get_children():
					if create_particle:
						var particle = spawn_particles.instantiate()
						var world = get_tree().current_scene 
						particle.global_position = Vector2(grand_child.global_position.x ,grand_child.global_position.y)
						world.add_child(particle)
					
					
