extends Node

export var ID = "BACTERIA"
export var MAX_HEALTH = 100
export var MIN_HEALTH = 10
export var health = 100
export var CONTAMINATION_RADIUS = 1
export var needs = {"K": 10, "Na": 10}

var is_dead = false


func _to_string():
	return self.ID + ", health: " + str(self.health)


func copy():
	# add logic here if copy gives a slightly different object
	return self.duplicate()


func consume(substract):
	for need in needs:
		var needed_quantity = needs[need]
		var acquired = substract.consume_nutrient(need, needed_quantity)
		if acquired < needed_quantity:
			health *= float(acquired) / needed_quantity  # TODO: make a smarter logic
			health = int(health)

		if health <= MIN_HEALTH:
			is_dead = true
