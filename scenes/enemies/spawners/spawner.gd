extends Node2D

# Entity layer is used define which entity layer to enable and make visible.
# We start with -1 because we change these settings for spawnable objects when layer_time
# runs out after adding 1 to this layer.
var entity_layer: int = -1
# Timer used to trigger the switch to the new entity layer
var layer_timer: Timer = Timer.new()
# When to start showing where enemies will be
@export var show_time: float = 1.5
# How long to wait before enabling enemies
@export var layer_time: float = 5
var show_once: bool = false

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
	# Unhide the entities on the next layer only once ( if shown_yet is false and layer_timer is <= show_time )
	## We do this to show the entity and setup effects for it's intro
	## Most enetities should use shaders for the their effect + the spawner partilces
	if  !layer_timer.is_stopped() and layer_timer.time_left <= show_time and !show_once:
		# We only want to trigger this step once per spawn layer init
		show_once = true
		_config_entity_layer(entity_layer+1,true,Node.PROCESS_MODE_DISABLED,true )

	# Set entity layer up plus 1 when the timer is stopped and enable entities at that layer
	if layer_timer.is_stopped():
		entity_layer += 1
		## Turn on all visibility and inherit process mode for all children nodes on entity_layer
		_config_entity_layer(entity_layer,true,Node.PROCESS_MODE_INHERIT,false)
		layer_timer.start(layer_time)
		show_once = false

# This method will disable all entities under the spawn_container nodes
func _all_layers_off():
	for spawn_container in get_children():
		spawn_container.visible = false
		spawn_container.process_mode = Node.PROCESS_MODE_DISABLED	
# Setter for 
func _config_entity_layer(layer,make_visible,process,init_spawnable=false):
	# Loop through all nodes that are used to contain the spawnable objects.
	## Hint: these are typically just Node2D objects.  To control actual spawnable objects see spawnable_object section
	for spawn_container in get_children():
		if spawn_container is Timer:
			pass		
		else:
			if spawn_container.z_index == layer:
				## Make spawn_container node visible and any objects under that inherit visible state
				spawn_container.visible = make_visible
				## Set process state for spawn_container node
				spawn_container.process_mode = process
				# Loop through the 
				for spawnable_object in spawn_container.get_children():
					if init_spawnable:
						# Fire off spawnable object's effects script
						spawnable_object._spawn_effects(show_time)



