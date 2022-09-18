extends Area2D

var square_size = 90
var square_size_scaled = square_size / scale.x
var square_amount_x
var square_amount_y
var dimensions

var color_changed = false

func _process(_delta):
	if global_position.y >= get_parent().dimensions.y - 2*get_parent().square_size:
		get_parent().active_d = false
		
	if global_position.y > get_parent().dimensions.y - (get_parent().square_size):
		queue_free()
		

	if not color_changed:
		color_changed = true
		modulate = get_parent().colour
		if name == "square1":
			modulate = get_parent().colour * 0.9
