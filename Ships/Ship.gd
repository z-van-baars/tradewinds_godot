extends KinematicBody2D

signal left_click
signal right_click
signal destination_reached
signal hovered
signal unhovered

var tools
var ship_stats
var selected = false

# constant stats, same for all ships
var cargo = {}
var last_direction = Vector2(0, 1)
var direction : Vector2
var target : Vector2
var destination_city = null
var target_entity = null
var player_ship = false
var captain = null

# variable stats, filled out for different ships
var ship_name
var hull
var speed
var cargo_cap

func _ready():
	tools = get_tree().root.get_node("Main/Tools")
	ship_stats = get_tree().root.get_node("Main/ShipStats")

func initialize_stats(hull_class, import_captain=null):
	ship_name = "The " + get_tree().root.get_node("Main/Ships").get_name()
	hull = hull_class
	speed = ship_stats.speed[hull_class]
	cargo_cap = ship_stats.cargo_cap[hull_class]
	if import_captain != null:
		captain = import_captain

func connect_signals(player_node, info_card, dispatch_node):
	self.connect(
		"left_click",
		player_node,
		"_on_Ship_left_click")
	self.connect(
		"right_click",
		player_node,
		"_on_Ship_right_click")
	self.connect(
		"hovered",
		info_card,
		"_on_Entity_hovered")
	self.connect(
		"unhovered",
		info_card,
		"_on_Entity_unhovered")
	self.connect(
		"target_entity_reached",
		dispatch_node,
		"_on_Ship_target_entity_reached")
	
func _process(delta):
	if target_entity != null:
		if target_entity.position != target:
			set_target(target_entity.position)

func _physics_process(delta):
	if abs(direction.x) == 1 and abs(direction.y) == 1:
		direction = direction.normalized()
	if target != null and position.distance_to(target) > 5:
		var movement = speed * direction * delta
		if destination_city != null:
			if position.distance_to(destination_city.get_center()) < 40:
				emit_signal("destination_reached", destination_city)
				zero_target()
		elif destination_city == null and target_entity != null:
			if position.distance_to(target_entity.get_center()) < 10:
				print("breached the chrysalis")
				emit_signal("target_entity_reached", target_entity)
				zero_target()
		move_and_collide(movement)
	else:
		zero_target()
	animates_ship(direction)
func get_center():
	return Vector2(position.x, position.y + 3)
func zero_target():
	target = position

func clear_destination():
	destination_city = null

func clear_target_entity():
	target_entity = null

func set_target(new_target):
	target = new_target
	direction = (target - position).normalized()

func select():
	selected = true
	$SelectionBox.visible = true

func deselect():
	selected = false
	$SelectionBox.visible = false

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


func _on_BBox_mouse_entered():
	$SelectionBox.visible = true
	emit_signal(
		"hovered",
		1,
		[ship_name,
		 hull,
		 speed])


func _on_BBox_mouse_exited():
	if not selected:
		$SelectionBox.visible = false
	emit_signal("unhovered")


func _on_BBox_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("left_click"):
		emit_signal("left_click", self)
	elif event.is_action_pressed("right_click"):
		emit_signal("right_click", self)
