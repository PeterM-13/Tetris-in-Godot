extends KinematicBody2D

var frame_count = 0
var frame_speed = 60

var square_size = 90
var square_size_scaled = square_size / scale.x
var square_amount_x
var square_amount_y
var dimensions

var move_right
var next_line = Vector2(3, 14)
var colour = Color("2c2c2c")

var active_d #for child squares

func _ready():
	#colour = colours[rand_range(0,len(colours)-1)]
	square_amount_x = get_parent().square_amount_x
	square_amount_y = get_parent().square_amount_y
	dimensions = get_viewport().size
	
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	
	var random = rng.randi_range(0,1)
	reset()
	I()
	if random == 0:
		move_right = true
		position.x =  -(3*square_size )
	else:
		position.x =  dimensions.x + (3*square_size )
		
	var random_line = rng.randi_range(next_line.x, next_line.y)
	position.y = (dimensions.y - random_line*square_size) + (0.5*square_size)
	position.x += 0.5*square_size
		
	

func _physics_process(_delta):
	frame_count += 1

	if frame_count >= frame_speed:
		if move_right:
			position.x += square_size
		else:
			position.x -= square_size
		frame_count = 0
		
		var rng = RandomNumberGenerator.new()
		rng.randomize()
		frame_speed = rng.randi_range(8,60)
		
		var squares = get_parent().line_count
		for i in range(0,len(squares)-1):
			if squares[i] > 0:
				next_line.x = i+3
				#if next_line.x >= next_line.y:
					#next_line.x = next_line.y
		
func _process(_delta):
	if position.x > dimensions.x+(square_size*4) or position.x < -(square_size*4):
		_ready()

func reset():
	$square2.position.x = 0
	$square3.position.x = 0
	$square4.position.x = 0
func I():
	$square2.position.x -=  square_size_scaled
	$square3.position.x +=  square_size_scaled
	$square4.position.x +=  square_size_scaled*2



