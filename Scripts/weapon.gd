extends StaticBody2D


const BULLET = preload("res://Scenes/bullet.tscn")


func shoot():
	print("SHOT!")
	var bullet = BULLET.instantiate() # creating an instance of the bullet scene
	bullet.position = $Muzzle.global_position # positioning the bullet on the muzzle
	
	# bullet direction is the direction the muzzle is pointing
	bullet.direction = Vector2(cos($Muzzle.global_rotation), sin($Muzzle.global_rotation))
	get_tree().root.add_child(bullet) # adding the bullet to the scene tree
