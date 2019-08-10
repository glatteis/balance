extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var action_types = ["fox speed", "rabbit speed", "fox bedtime", "rabbit bedtime", "carrots per day", "rabbit shock time", "fox litter", "rabbit litter"]
var options = [["faster", "slower"], ["faster", "slower"], ["later", "earlier"], ["later", "earlier"],\
	["more", "less"], ["longer", "shorter"], ["more foxes", "less foxes"], ["more rabbits", "less rabbits"]]
var variables = ["fox_speed", "rabbit_speed", "fox_curfew", "rabbit_curfew", "num_new_carrots", "rabbit_fear", "fox_litter", "rabbit_litter"]
var steps = [.2, .2, .5, .5, 2, .2, 1, 1]
var bounds = [[0, 100], [0, 100], [7, 23], [7, 23], [0, 1000], [0, 1000], [0, 1000], [0, 1000]]

var current_action = 0
var current_options = []

enum mode {
	menu,
	action
}

var current_mode = mode.menu

var selected_action = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	change_label()

func change_label():
	if current_mode == mode.menu:
		$top_label.set_text("change parameter")
		$mid_label.set_text(action_types[selected_action])
	elif current_mode == mode.action:
		var value = get_parent().get(variables[current_action])
		$top_label.set_text(action_types[current_action] + ": " + str(value))
		$mid_label.set_text(current_options[selected_action])

func _input(event: InputEvent):
	if event.is_action_released("ui_left"):
		selected_action += 1
		if current_mode == mode.menu:
			selected_action %= len(action_types)
		elif current_mode == mode.action:
			selected_action %= len(current_options)
		change_label()
	elif event.is_action_released("ui_right"):
		if current_mode == mode.menu:
			current_mode = mode.action
			current_action = selected_action
			current_options = options[selected_action].duplicate()
			current_options.append("back")
			selected_action = 0
		elif current_mode == mode.action:
			if current_options[selected_action] == "back":
				current_mode = mode.menu
				selected_action = 0
			else:
				var value = get_parent().get(variables[current_action])
				var step = steps[current_action]
				var desired_value: float
				if selected_action == 0:
					desired_value = value + step
				elif selected_action == 1:
					desired_value = value - step
				if desired_value > bounds[current_action][0] and desired_value < bounds[current_action][1]:
					get_parent().set(variables[current_action], desired_value)
		change_label()
