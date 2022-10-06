extends KinematicBody2D

var frame_count = 0
var frame_count2 = 0
var frame_speed = 60

var square_size = 90
var square_size_scaled = square_size / scale.x
var square_amount_x
var square_amount_y
var dimensions

var active_d = true	#down
var active_l = true
var active_r = true

var space_left
var space_right
var space_down 
var space_up


var colour

func _ready():
	square_amount_x = get_parent().square_amount_x
	square_amount_y = get_parent().square_amount_y
	dimensions = get_viewport().size
	
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	position.x = ( dimensions.x / 2 )
	var random = rng.randi_range(0,6)
	if get_parent().difficulty > 0:
		rng.randomize()
		colour = get_parent().colours[rng.randi_range(0,6)]
	else:
		colour = get_parent().colours[random]
	if random == 0:
		L(false)
	elif random == 1:
		I()
	elif random == 2:
		X()
	elif random == 3:
		Z(false)
	elif random == 4:
		T()
	elif random == 5:
		L(true)
		scale.x = scale.x*-1
	elif random == 6:
		Z(true)
		scale.x = scale.x*-1
	
var next = false
func _physics_process(_delta):
	frame_count += 1
	frame_count2 += 1
	if frame_count >= frame_speed and active_d:
		position.y += square_size
		frame_count = 0
	if not active_d and not next:
		get_parent().next()
		next = true
		
	if frame_count2 >= 7 and active_d:
		frame_count2 = 0
		if Input.get_action_strength("left") == 1 and (position.x-space_left) > square_size and active_l:
			position.x -= square_size
		elif Input.get_action_strength("right") == 1 and (position.x+space_right) < dimensions.x - square_size and active_r:
			position.x += square_size

	
	
func _process(_delta):
	if active_d:
	#	if Input.get_action_strength("left") == 1 and (position.x-space_left) > square_size and active_l:
	#		position.x -= square_size
			
		if Input.is_action_just_pressed("rotate"):
			rotation_degrees += 90
			var temp = space_left
			space_left = space_down
			space_down = space_right
			space_right = space_up
			space_up = temp
			
		if Input.get_action_strength("fast") == 1:
			frame_speed = 3
		else:
			frame_speed = 60
		
		var new_frame = true
		#active_l = false
		#active_r = false
		var childeren = get_parent().get_children()
		childeren.remove(0)
		childeren.remove(0)
		childeren.remove(0)
		childeren.remove(0)
		childeren.remove(0)
		for shape in childeren:
			if shape != self:
				for square in range(1,shape.get_child_count()):
					var Square = shape.get_child(square)
					for s in range(1,get_child_count()):
						if Square.global_position.x == get_child(s).global_position.x and Square.global_position.y <= get_child(s).global_position.y+square_size and Square.global_position.y > get_child(s).global_position.y:
							active_d = false
						if Square.global_position.y == get_child(s).global_position.y and Square.global_position.x <= get_child(s).global_position.x-square_size:
							active_l = false
							new_frame = false
						elif new_frame:
							active_l = true
						if Square.global_position.y == get_child(s).global_position.y and Square.global_position.x <= get_child(s).global_position.x+square_size:
							active_r = false
							new_frame = false
						elif new_frame:
							active_r = true
							
		for sq in get_children():
			if sq.global_position.x > dimensions.x - square_size:
				position.x -= square_size
			elif sq.global_position.x < square_size:
				position.x += square_size
						
	if get_child_count() <= 1:
		queue_free()


func X():
	position.y += 2*square_size
	$square1.position += 0.5*Vector2(square_size_scaled, square_size_scaled)
	$square2.position += 0.5*Vector2(-square_size_scaled, -square_size_scaled)
	$square3.position += 0.5*Vector2(square_size_scaled, -square_size_scaled)
	$square4.position += 0.5*Vector2(-square_size_scaled, square_size_scaled)
	space_left = square_size
	space_right = square_size
	space_down = square_size
	space_up = square_size
	
func I():
	position.x += 0.5*square_size
	position.y += 2.5*square_size
	$square2.position.y -=  square_size_scaled
	$square3.position.y +=  square_size_scaled
	$square4.position.y +=  square_size_scaled*2
	space_left = 0.5*square_size
	space_right = 0.5*square_size
	space_down = 2.5*square_size
	space_up = 1.5*square_size

func T():
	position.x += 0.5*square_size
	position.y += 2.5*square_size
	$square2.position.x += square_size_scaled 
	$square3.position.x -= square_size_scaled 
	$square4.position.y += square_size_scaled 
	space_left = 1.5*square_size
	space_right = 1.5*square_size
	space_down = 1.5*square_size
	space_up = 0.5*square_size
	
func L(flip):
	position.x -= 0.5*square_size
	position.y += 2.5*square_size
	$square2.position.y -= square_size_scaled
	$square3.position.y += square_size_scaled
	$square4.position += Vector2(square_size_scaled, square_size_scaled)
	if flip:
		space_left = 1.5*square_size
		space_right = 0.5*square_size
	else:
		space_left = 0.5*square_size
		space_right = 1.5*square_size
	space_down = 1.5*square_size
	space_up = 1.5*square_size
	
func Z(flip):
	position.x -= 0.5*square_size
	position.y += 2.5*square_size
	$square2.position.y -= square_size_scaled
	$square3.position.x += square_size_scaled
	$square4.position += Vector2(square_size_scaled, square_size_scaled)
	if flip:
		space_left = 1.5*square_size
		space_right = 0.5*square_size
	else:
		space_left = 0.5*square_size
		space_right = 1.5*square_size
	space_down = 1.5*square_size
	space_up = 1.5*square_size

