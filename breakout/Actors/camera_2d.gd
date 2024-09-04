extends Camera2D

@export var decay := .8
@export var max_offset := Vector2(100,75)
@export var max_roll := PI
@export var noise : FastNoiseLite 
var noise_y := 0.0
var trauma := 0.0
var trauma_pwr := 3


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	noise.seed = randi()
	
func add_trauma(amount: float):
	trauma = min(trauma+amount, 1.0)

func shake():
	var amt = pow(trauma, trauma_pwr)
	noise_y += 1
	rotation = max_roll * amt * noise.get_noise_2d(0,noise_y)
	offset.x = max_offset.x * amt * noise.get_noise_2d(1000,noise_y)
	offset.y = max_offset.y * amt * noise.get_noise_2d(2000,noise_y)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if trauma:
		trauma = max(trauma - decay * delta, 0)
		shake()
	elif offset.x != 0 or offset.y != 0 or rotation != 0:
		lerp(offset.x,0.0,1)
		lerp(offset.y,0.0,1)
		lerp(rotation,0.0,1)


func _on_ball_collision_occurred():
	add_trauma(1)
