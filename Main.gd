extends Node2D

var colours = [Color(0,1,0),Color(0,0,1),Color(0,1,1),Color(1,1,0),Color(1,0,0.5),Color(0.5,0,1),Color(1,0.5,0)]

var square_amount_x = 10 # +2
var square_amount_y = square_amount_x * 2
var square_size = 90
var dimensions
var dead = false

func _ready():
	dimensions = get_viewport().size
	randomize()
	colours.shuffle()
	next()

		
func _draw():
	#Draw border
	draw_rect( Rect2( Vector2.ZERO+Vector2(square_size,square_size), Vector2(dimensions.x,dimensions.y)-Vector2(square_size*2,square_size*2)), Color(0.1, 0.1, 0.1) )	
	
	#Draw grid
	var x
	var y = dimensions.y
	for sqaure in range(1,(square_amount_x+2)):
		x = sqaure * square_size
		draw_line(Vector2(x,0), Vector2(x, y), Color(0,0,0), 2)
	x = dimensions.x
	for sqaure in range(1,(square_amount_y+2)):
		y = sqaure * square_size
		draw_line(Vector2(0,y), Vector2(x, y), Color(0,0,0), 2)


var shape_scene = preload("res://Shape.tscn")
func next():
	$score.text = str(int($score.text) + 5)
	var line_count = []
	for _i in range(0, square_amount_y):
		line_count.append(0)
	var childeren = get_children()
	childeren.remove(0)
	childeren.remove(0)
	childeren.remove(0)
	for shape in childeren:
		for square in range(1,shape.get_child_count()):
			var Square = shape.get_child(square)
			#for s in range(1,5):
			line_count[(square_amount_y) - ((Square.global_position.y - (0.5*square_size)) / square_size)] += 1
			
	if line_count[(square_amount_y-3)-1] != 0:
		dead = true
		get_tree().paused = true
		$play.pressed = true
	#	print("Dead!")
				
	if not dead:
		var line_num = []
		for l in range(0,len(line_count)-1):
			if line_count[l] >= square_amount_x:
				line_num.append(l)
				for shape in childeren:
					for square in range(1,shape.get_child_count()):
						var Square = shape.get_child(square)
						if square_amount_y - ((Square.global_position.y - (0.5*square_size)) / square_size) == l:
							Square.queue_free()
		childeren = get_children()
		childeren.remove(0)
		childeren.remove(0)
		childeren.remove(0)
		if line_num:
			for shape in childeren:
				for square in range(1,shape.get_child_count()):
					var Square = shape.get_child(square)
					var count = 0
					for l in range(0,len(line_num)):
						if square_amount_y - ((Square.global_position.y - (0.5*square_size)) / square_size) >= line_num[l]:
							count += 1
					Square.global_position.y += (square_size * count)

		var nl = len(line_num)
		if nl == 1:
			$score.text = str(int($score.text) + 10)
		elif nl == 2:
			$score.text = str(int($score.text) + 20)
		elif nl == 3:
			$score.text = str(int($score.text) + 40)
		elif nl == 4:
			$score.text = str(int($score.text) + 80)
		elif nl == 5:
			$score.text = str(int($score.text) + 160)
		elif nl >= 6:
			$score.text = str(int($score.text) + 300)
			
		var new_shape = shape_scene.instance()
		self.add_child(new_shape)

	else:
		for shape in childeren:
			for square in range(1,shape.get_child_count()):
				var Square = shape.get_child(square)
				Square.set_modulate(Color(1,0,0))


func _on_retry_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_play_toggled(button_pressed):
	if dead and button_pressed == false:
		_on_retry_pressed()
	else:
		get_tree().paused = button_pressed
