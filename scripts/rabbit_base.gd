extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var saved_rabbits = 0
var rabbits_with_carrots = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func start():
	saved_rabbits = 0
	rabbits_with_carrots = 0
	$label.set_text(str(saved_rabbits))

func save_rabbit(rabbit):
	saved_rabbits += 1
	$label.set_text(str(saved_rabbits))
	if rabbit.num_carrots > 0:
		rabbits_with_carrots += 1
