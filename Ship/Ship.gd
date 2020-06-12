extends KinematicBody2D

export var speed = 500
var last_direction = Vector2(0, 1)
var direction : Vector2
var target : Vector2
var tools
var cargo = {}

func _ready():
	tools = get_tree().root.get_node("Main/Tools")

func _physics_process(delta):
	if abs(direction.x) == 1 and abs(direction.y) == 1:
		direction = direction.normalized()
	if target != null and position.distance_to(target) > 5:
		var movement = speed * direction * delta
		move_and_collide(movement)
	animates_ship(direction)

func randomize_start(cities):
	var r_city = tools.r_choice(cities.get_children())
	var neighbor_tiles = tools.get_neighbor_tiles(
		Vector2(r_city.tile_x,
				r_city.tile_y))
	# filter tiles around a random start city for water only
	var f_neighbor_tiles = tools.filter_tiles(neighbor_tiles, true)
	var r_start = tools.r_choice(neighbor_tiles)
	position = get_tree().root.get_node("Main/WorldGen/BiomeMap").map_to_world(r_start)

func zero_target():
	target = position

func get_animation_direction(direction: Vector2):
	var norm_direction = direction.normalized()
	if norm_direction.y >= 0.707:
		if norm_direction.x >= 0.3:
			return "downright"
		elif norm_direction.x <= -0.3:
			return "downleft"
		else:
			return "down"
	elif norm_direction.y <= -0.707:
		if norm_direction.x >= 0.3:
			return "upright"
		elif norm_direction.x <= -0.3:
			return "upleft"
		else:
			return "up"
	elif norm_direction.x <= -0.707:
		if norm_direction.y >= 0.3:
			return "downleft"
		elif norm_direction.y <= -0.3:
			return "upleft"
		else:
			return "left"
	elif norm_direction.x >= 0.707:
		if norm_direction.y >= 0.3:
			return "downright"
		elif norm_direction.y <= -0.3:
			return "upright"
		else:
			return "right"
	return "downright"

func animates_ship(direction: Vector2):
	if direction != Vector2.ZERO:
		# update last_direction
		last_direction = direction
		
		# Choose walk animation based on movement direction
		var animation = "sail_" + get_animation_direction(last_direction)
		
		# Play the walk animation
		$AnimatedSprite.play(animation)
	else:
		# Choose idle animation based on last movement direction and play it
		var animation = "sail_" + get_animation_direction(last_direction)
		$AnimatedSprite.play(animation)
