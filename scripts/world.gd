extends Node2D


var rabbit_scene = preload("res://scenes/rabbit.tscn")
var fox_scene = preload("res://scenes/fox.tscn")
var carrot_scene = preload("res://scenes/carrot.tscn")
var gravestone_scene = preload("res://scenes/gravestone.tscn")

onready var rabbit_base = get_node("rabbit_base")
onready var fox_base = get_node("fox_base")

var hours_per_second = .8

var clock = 0
var day_running = true

var num_rabbits = 20
var num_foxes = 5


var new_rabbits = 0
var new_foxes = 0

var starved_rabbits = 0
var starved_foxes = 0


# CHANGABLE PARAMETERS

var fox_speed = 1.8
var rabbit_speed = 2
var fox_curfew = 16
var rabbit_curfew = 17
var num_new_carrots = 20
var rabbit_fear = 1

var rabbit_litter = 3
var fox_litter = 2

var game_over = false

var day = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	start_new_day()

func _process(delta):
	clock += delta
	if day_running:
		$light.energy = pow((get_time_hours() - 12) / 17, 2)
		var minutes = str(int(60 * (get_time_hours() - int(get_time_hours()))))
		if len(minutes) == 1:
			minutes = "0" + minutes
		$clock.set_text(str(int(get_time_hours())) + ":" + minutes)
		$day_label.set_text("day " + str(day))
		if get_time_hours() >= 24:
			finish_day()
	elif !game_over:
		if clock > 7:
			$light.energy = 100
			$main_text.set_text("tonight,\n" + str(starved_rabbits) + " rabbits and " + str(starved_foxes) + " foxes starved.\n" + \
				str(new_rabbits) + " rabbits and " + str(new_foxes) + " foxes were born.")
			
		if clock > 14:
			start_new_day()

func finish_day():
	for node in get_children():
		if node.has_method("i_am_rabbit") or node.has_method("i_am_fox") or node.has_method("i_am_carrot"):
			if not node.has_method("i_am_carrot"): # carrots don't get gravestones
				var gravestone = gravestone_scene.instance()
				add_child(gravestone)
				gravestone.set_position(node.get_position())
			remove_child(node)
	day_running = false
	clock = 0
	$clock.set_text("day over")
	
	if $fox_base.saved_foxes == 0:
		$main_text.set_text("there are no more foxes. the rabbits have won.")
		game_over = true
		return
	elif $rabbit_base.saved_rabbits == 0:
		$main_text.set_text("there are still foxes, but not much longer. the rabbits have posthumously won.")
		game_over = true
		return
	
	$main_text.set_text(str($rabbit_base.rabbits_with_carrots) + " rabbits got a carrot today.\n" + \
		str($fox_base.foxes_with_rabbits) + " foxes got a rabbit today.")
		
	starved_foxes = int(randf() * ($fox_base.saved_foxes - $fox_base.foxes_with_rabbits))
	starved_rabbits = int(randf() * ($rabbit_base.saved_rabbits - $rabbit_base.rabbits_with_carrots))
	
	num_foxes = $fox_base.saved_foxes - starved_foxes
	num_rabbits = $rabbit_base.saved_rabbits - starved_rabbits
	
	if $fox_base.foxes_with_rabbits >= 2:
		new_foxes = int(randf() * fox_litter * $fox_base.foxes_with_rabbits)
	else:
		new_foxes = 0
	if $rabbit_base.rabbits_with_carrots >= 2:
		new_rabbits = int(randf() * rabbit_litter * $rabbit_base.rabbits_with_carrots)
	else:
		new_rabbits = 0
	
	num_rabbits += new_rabbits
	num_foxes += new_foxes

func start_new_day():
	day += 1
	$rabbit_base.start()
	$fox_base.start()
	
	for i in range(num_foxes):
		var fox = fox_scene.instance()
		fox.set_position(fox_base.get_position() + Vector2(randf() * 100 - 50, randf() * 100 - 50))
		add_child(fox)
	
	for i in range(num_rabbits):
		var rabbit = rabbit_scene.instance()
		rabbit.set_position(rabbit_base.get_position() + Vector2(randf() * 100 - 50, randf() * 100 - 50))
		add_child(rabbit)
		
	for i in range(num_new_carrots):
		var carrot = carrot_scene.instance()
		carrot.set_position(Vector2(500 + randf() * 900, 250 + randf() * 400))
		add_child(carrot)
		
	for node in get_children():
		if node.has_method("i_am_gravestone"):
			remove_child(node)
			
	day_running = true
	clock = 0
	
	$main_text.set_text("")

func get_time_hours():
	return clock * hours_per_second + 5

func spawn_gravestone(position):
	var gravestone = gravestone_scene.instance()
	gravestone.set_position(position)
	add_child(gravestone)
	
	
	
	
	
	

