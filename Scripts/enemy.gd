extends RigidBody2D


const SPEED := 40.0

var player : RigidBody2D

var can_jump := false
@export var health := 40

func _ready():
	player = get_parent().get_parent().get_node("Player")
	
func _physics_process(delta):
	if player:
		var direction := (player.global_position - global_position).normalized()
		
		apply_central_force(direction * SPEED)
		
		if player.global_position.y - global_position.y > 1 and abs(linear_velocity.y) < 5 and can_jump:
			jump()

func jump():
	apply_central_impulse(Vector2(0, -20))
	can_jump = false

func _on_body_entered(body : RigidBody2D):
	if body.collision_layer == 1:
		can_jump = true
	
	if body.collision_layer == 2:
		body.take_damage(20)
		body.apply_central_impulse((player.global_position - global_position).normalized() * 20)
func take_damage(amount : int):
	if health > amount:
		health -= amount
	else:
		health = 0
		print("ENEMY KILLED")
		queue_free()
