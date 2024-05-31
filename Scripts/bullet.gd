extends RigidBody2D

const BULLET_SPEED := 400.0

var direction := Vector2.ZERO
@onready var trail_line = $Line2D
var trail_points := []

func _ready():
	apply_central_force(direction * BULLET_SPEED)
	
	trail_points.clear() # Clearing the trail points
	trail_points.append(global_position) # appending the first pos
	trail_line.add_point(global_position) # adding the point


func _process(delta):
	 # Add the current global position to the trail points
	trail_points.append(global_position)

	# Update the trail line with new points
	trail_line.clear_points()
	for point in trail_points:
		trail_line.add_point(to_local(point))

	# remove old points to limit the trail length
	if len(trail_points) > 5:
		trail_points.pop_front()

func _on_body_entered(body):
	# Collide with everything other than the player
	if body.collision_layer != 2:
		if body is RigidBody2D:
			print("BULLSEYE!")
			body.apply_central_impulse(direction * 20)
			if body.collision_layer == 8:
				body.take_damage(20)
		queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
