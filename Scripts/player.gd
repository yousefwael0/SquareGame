extends RigidBody2D

const MOVE_FORCE := 200.0
const JUMP_FORCE := -1500.0
const MAX_VELOCITY := 400.0
const JUMP_COOLDOWN := 2.0
const AIR_RESISTANCE := 200.0

@onready var weapon = $Weapon # getting a refrence to the weapon node

var health := 100
var direction := 0.0 # float to hold the direction of move force (-1 left, 1 right)
var is_grounded := false
var jump_timer := Timer.new() # timer for jump cooldown
var jumps_counter := 0 # number of jumps left
@export var allowed_jumps := 1 # amount of jumps the player has when grounded

func _process(delta):
	# Updating direction variable every frame
	direction = Input.get_axis("Left", "Right")
	
	# rotating the weapon towards the mouse
	weapon.look_at(get_global_mouse_position())
	
func _input(event):
	# Handling Jump
	if event.is_action_pressed("Jump") and can_jump():
		jump()
	
	# Handling Shooting
	if event.is_action_pressed("Shoot"):
		weapon.shoot()
		$Camera2D.camera_shake(5, 0.5)

func _physics_process(delta):
	# Adding movment force based on direction variable and capping the velocity
	if direction and linear_velocity.length() < MAX_VELOCITY:
		apply_central_force(Vector2(direction * MOVE_FORCE, 0.0))
		
	# Adding air resistance while airborne
	if not is_grounded and abs(linear_velocity.x) > 400:
		apply_central_force(Vector2(linear_velocity.direction_to(Vector2.ZERO).x * AIR_RESISTANCE, 0))
	

# signal to keep track of collisions with the player
func _on_body_entered(body):
	# if on a platform set grounded and reset jump counter
	if body.collision_layer == 1:
		is_grounded = true
		jumps_counter = allowed_jumps

# function to check the ability to jump
func can_jump() -> bool:
	if jump_timer.is_stopped() and jumps_counter > 0:
		return true
	return false

func jump():
		apply_central_force(Vector2(0, JUMP_FORCE)) # applying the jump force
		$AnimationPlayer.play("Jump")
		$JumpParticle.rotation_degrees = -rotation_degrees
		$JumpParticle.emitting = true
		jumps_counter -= 1
		is_grounded = false
		jump_timer.start(JUMP_COOLDOWN) # starting the jump cooldown

func take_damage(amount : int):
	if health > amount:
		health -= amount
		$AnimationPlayer.play("TakeDamage")
		$Camera2D.camera_shake(10, .5)
		print("Health: " + str(health))
	else:
		health = 0
		die()

func die():
	Engine.time_scale = 0.5
	$DeathTimer.start()
	print("DIED!")

func _on_death_timer_timeout():
	Engine.time_scale = 1
	get_tree().reload_current_scene()
