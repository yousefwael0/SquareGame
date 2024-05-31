extends Camera2D

var shake_intensity := 0.0
var shake_decay := 0.1
var original_position := Vector2.ZERO


func _ready():
	original_position = position
	make_current()
	custom_viewport


func _process(delta):
	if shake_intensity > 0:
		# Apply random shake based on the intensity
		var offset = Vector2(randf() - 0.5, randf() - 0.5) * 2 * shake_intensity
		position = original_position + offset
		
		# Decrease the shake intensity over time
		shake_intensity -= shake_decay * delta
		if shake_intensity < 0:
			shake_intensity = 0
	else:
		# Reset the camera position when the shake stops
		position = original_position
		

func camera_shake(intensity : float, duration : float):
	shake_intensity = intensity
	shake_decay = intensity / duration

