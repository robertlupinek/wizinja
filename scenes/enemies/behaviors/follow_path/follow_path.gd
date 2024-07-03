extends Path2D
# Node you intend to move around with this path
var base_body: EnemyBase
# AnimatedSprite2d child of the base_body
var animation: AnimatedSprite2D
# Directions vector
var direction: Vector2
# Last position
var last_position: Vector2

# Speed to move along the path
@export var speed: float = 50
# Set loop or not for the path follow fella
@export var  loop: bool = false
# If not a looping path then just run the path again from current position
@export var continue_path: bool = true
# If the sprite should rotate with the path
@export var rotates: bool = false
# If sprite should flip scale based on the x direction
@export var flip_x: bool = false
# Signal emitted when path is complete
signal path_complete

# Called when the node enters the scene tree for the first time.
func _ready():
	last_position = $PathFollow2D.global_position
	$PathFollow2D.loop = loop
	$PathFollow2D.rotates = rotates
	base_body = get_node("../EnemyBase")
	animation = base_body.get_node("AnimatedSprite2D")
	$PathFollow2D/RemoteTransform2D.remote_path = base_body.get_path()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	
	$PathFollow2D.progress += speed * delta	
	# Get direction
	_get_direction()
	# Flip the base body is the facing direction is not the same as the path x direction
	if flip_x and base_body.facing != direction.x:
		base_body._flip()
	# When path end
	if $PathFollow2D.progress_ratio == 1:
		emit_signal("path_complete")
		# Restart path from where path ends if continue_path is set
		if continue_path:
			_continue_path()

func _get_direction():
	# Get the relative x and y direction of movement based on previous position
	## X Direction
	if last_position.x > $PathFollow2D.global_position.x:
		direction.x = -1
	if last_position.x < $PathFollow2D.global_position.x:
		direction.x = 1
	if last_position.x == $PathFollow2D.global_position.x:
		direction.x = 0	
	## Y Direction
	if last_position.y > $PathFollow2D.global_position.y:
		direction.y = -1
	if last_position.y < $PathFollow2D.global_position.y:
		direction.y = 1
	if last_position.x == $PathFollow2D.global_position.y:
		direction.y = 0				
	## Reset last_position	
	last_position = $PathFollow2D.global_position

func _continue_path():
	# Keep following that path baby!  That is, if your path doesn't loop.  Cause just loop, right?
	if !$PathFollow2D.loop:
		# Reset the position to the last position of the PathFollow2d.
		global_position = $PathFollow2D.global_position
		# base_body.global_position = global_position
		# Set the path to start again from the beginning 
		$PathFollow2D.progress_ratio = 0
