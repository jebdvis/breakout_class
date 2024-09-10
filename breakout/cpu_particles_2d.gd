extends CPUParticles2D


func _on_ball_collision_occurred():
	amount += 10
	emission_sphere_radius += .5


func _on_ball_game_ended():
	emission_sphere_radius = 2000
