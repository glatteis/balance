extends KinematicBody2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

var speed = 0
var killed_rabbits = 0
var max_rabbits = 1

var curfew = 0

onready var fox_base = get_parent().get_node("fox_base")

func _physics_process(delta):
	speed = get_parent().fox_speed
	curfew = get_parent().fox_curfew
	
	
	
	# Find the nearest rabbit
	var world = get_parent()
	var nearest_rabbit = null
	var nearest_rabbit_distance = 0
	for node in world.get_children():
		if node.has_method("i_am_rabbit"):
			var distance_to_rabbit = node.get_position().distance_to(get_position())
			if nearest_rabbit == null or distance_to_rabbit < nearest_rabbit_distance:
				nearest_rabbit = node
				nearest_rabbit_distance = distance_to_rabbit
	
	if killed_rabbits >= max_rabbits or get_parent().get_time_hours() > curfew or nearest_rabbit == null:
		# go back to base
		var angle = get_position().angle_to_point(fox_base.get_position())
		set_rotation(angle)
		eat(move_and_collide(Vector2(-speed, 0).rotated(angle)))
		if get_position().distance_to(fox_base.get_position()) < 30:
			fox_base.save_fox(self)
			get_parent().remove_child(self)
		return

	# Walk towards the rabbit
	var angle = get_position().angle_to_point(nearest_rabbit.get_position())
	set_rotation(angle)
	eat(move_and_collide(Vector2(-speed, 0).rotated(angle)))

func eat(collision):
	if collision and collision.collider.has_method("i_am_rabbit"):
		collision.collider.get_killed()
		killed_rabbits += 1

func i_am_fox():
	pass