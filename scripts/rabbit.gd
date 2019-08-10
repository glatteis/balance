extends KinematicBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var normal_speed = 0
var flee_speed = 0

# the rabbit flees from the same fox up to fear_lingering seconds after the fox is out of reach
var paranoid = 0
var paranoid_fox = null

var fear_lingering = 0

var target_carrot = null

var num_carrots = 0
var max_carrots = 1

var curfew = 0

var clock = 0

onready var rabbit_base = get_parent().get_node("rabbit_base")

func _ready():
	pass

func _physics_process(delta):
	normal_speed = get_parent().rabbit_speed
	flee_speed = normal_speed * 1.5
	curfew = get_parent().rabbit_curfew
	fear_lingering = get_parent().rabbit_fear
	
	clock += delta
	# Find the nearest fox
	var world = get_parent()
	var nearest_fox = null
	var nearest_fox_distance = 0
	for node in world.get_children():
		if node.has_method("i_am_fox"):
			var distance_to_fox = node.get_position().distance_to(get_position())
			if nearest_fox == null or distance_to_fox < nearest_fox_distance:
				nearest_fox = node
				nearest_fox_distance = distance_to_fox
	
	# Run away from the fox
	if paranoid_fox == null or (nearest_fox_distance < 100 and paranoid <= 0):
		paranoid_fox = nearest_fox
	
	if paranoid_fox != null and (nearest_fox_distance < 100 or paranoid > 0):
		if nearest_fox_distance < 100:
			paranoid = fear_lingering
		paranoid -= delta
		var angle = get_position().angle_to_point(paranoid_fox.get_position()) + 0.1 * randf()
		set_rotation(angle + PI)
		eat(move_and_collide(Vector2(flee_speed, 0).rotated(angle)))
		return
	
	if num_carrots >= max_carrots or get_parent().get_time_hours() > curfew:
		# go back to base
		var angle = get_position().angle_to_point(rabbit_base.get_position())
		set_rotation(angle)
		eat(move_and_collide(Vector2(-normal_speed, 0).rotated(angle)))
		if get_position().distance_to(rabbit_base.get_position()) < 30:
			rabbit_base.save_rabbit(self)
			get_parent().remove_child(self)
		return
	
	# Find a near carrot
	if target_carrot == null or get_parent().get_children().find(target_carrot) == -1:
		var carrots = {}
		var distances = []
		for node in world.get_children():
			if node.has_method("i_am_carrot"):
				var distance_to_carrot = node.get_position().distance_to(get_position())
				carrots[node] = distance_to_carrot
				distances.append(distance_to_carrot)
		if distances.size() > 0:
			distances.sort()
			var mean = distances[distances.size() / 5]
			var near_carrots = []
			for carrot in carrots:
				if carrots[carrot] > mean:
					near_carrots.append(carrot)
			if near_carrots.size() != 0:
				target_carrot = near_carrots[randi() % near_carrots.size()]
	
	if target_carrot != null:
		# Go to the next carrot
		var angle = get_position().angle_to_point(target_carrot.get_position())
		set_rotation(angle)
		eat(move_and_collide(Vector2(-normal_speed, 0).rotated(angle)))

func eat(collision):
	if collision and collision.collider.has_method("i_am_carrot"):
		# Eat carrot
		get_parent().remove_child(collision.collider)
		num_carrots += 1

func i_am_rabbit():
	pass

func get_killed():
	get_parent().spawn_gravestone(self.get_position())
	get_parent().remove_child(self)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
