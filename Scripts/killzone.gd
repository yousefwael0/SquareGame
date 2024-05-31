extends Area2D

@export var damage := 100.0

func _on_body_entered(body):
	if body.collision_layer == 2:
		body.take_damage(damage)
		
	if body.collision_layer == 8:
		body.take_damage(damage)
