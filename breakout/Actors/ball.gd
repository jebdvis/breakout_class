extends CharacterBody2D

signal collision_occurred

@export var speed: float = 3.0
@export var max_speed: float = 10.0
@export var score_label:RichTextLabel
@export var start_label:RichTextLabel

var forward: Vector2 = Vector2(1,1).normalized()
const PADDLE_WIDTH: float = 100.0
var current_score: int = 0
var is_running = false

func _ready() -> void:
	#velocity = Vector2(1,1).normalized()
	pass

func _physics_process(delta: float) -> void:
	#end_game: check if all bricks have been hit
	if $"../Bricks".get_child_count() == 0:
		is_running = false
		start_label.text = "[center]You Win!\nClick to Play Again.[/center]"
		start_label.visible = true
		
		
	if Input.is_action_just_pressed("Click_Window") && $"../Bricks".get_child_count() > 0:
		is_running = true
		start_label.visible = false
	elif Input.is_action_just_pressed("Click_Window") && $"../Bricks".get_child_count() == 0:
		get_tree().reload_current_scene()
	if !is_running:
		return
	
	var collision:KinematicCollision2D = move_and_collide(forward * speed)
	if collision:
		forward = forward.bounce(collision.get_normal())
		speed = clamp(speed + .5, 1 , max_speed)

		if collision.get_collider().is_in_group("Bricks"):
			collision.get_collider().queue_free()
			current_score += 10
			score_label.text = "Score: " + str(current_score)
			collision_occurred.emit()
			#print($"../Bricks".get_child_count())
			
		if collision.get_collider().is_in_group("Paddle"):
			var paddle_x = collision.get_collider().position.x -  PADDLE_WIDTH/2
			var pos_on_paddle = (position.x - paddle_x) / PADDLE_WIDTH
			print("Hit the paddle!" + str(pos_on_paddle))
			var bounce_angle = lerp(-PI * .8, -PI * .2, pos_on_paddle)
			forward = Vector2.from_angle(bounce_angle)
			
		if collision.get_collider().is_in_group("game_over"):
			is_running = false
			start_label.visible = true
			start_label.text = "[center]GAME OVER[/center]"
			await get_tree().create_timer(1.0).timeout
			get_tree().reload_current_scene()
			
