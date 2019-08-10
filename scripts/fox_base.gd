extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var saved_foxes = 0
var foxes_with_rabbits = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	start()

func start():
	saved_foxes = 0
	foxes_with_rabbits = 0
	$label.set_text(str(saved_foxes))

func save_fox(fox):
	saved_foxes += 1
	$label.set_text(str(saved_foxes))
	if fox.killed_rabbits > 0:
		foxes_with_rabbits += 1
