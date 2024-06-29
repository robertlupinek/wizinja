extends Node2D

@export var destroy_time: float = 1.5
var timer: Timer = Timer.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	add_child(timer)
	timer.one_shot = true
	timer.start(destroy_time)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if timer.is_stopped():
		queue_free()
