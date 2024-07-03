extends Control
var step_timer: Timer = Timer.new()
@export var sound_ready: AudioStream
@export var sound_go: AudioStream
var step: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	step_timer.one_shot = true
	add_child(step_timer)
	step_timer.start(0.5)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if step_timer.is_stopped():
		step += 1
		
		if step == 1:
			AudioManager._play(sound_ready)
			step_timer.start(1)
			
		if step == 2:
			AudioManager._play(sound_go)
			$RichTextLabel.text = "[shake rate=20.0 level=5 connected=1][center]GO!![/center][/shake]"
			step_timer.start(0.25)
			
		if step == 3:
			step_timer.start(1)
			
		if step == 4:
			queue_free()
			
			
	if step >= 3:
		$RichTextLabel.global_position.x += delta * 2300
		$ColorRectTop.global_position.x -= delta * 2300
		$ColorRectCenter.global_position.x += delta * 2300
		$ColorRectBottom.global_position.x -= delta * 2300
		
			
	
		
			
