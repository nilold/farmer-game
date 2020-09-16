extends Node

export var MINERALS = ["K", "Na", "Fe"]
export var MIN_MINERAL = 10
export var MAX_MINERAL = 70

var minerals = {}


func _init(randomize_minerals: bool = false):
	if randomize_minerals:
		for mineral in MINERALS:
			minerals[mineral] = int(rand_range(MIN_MINERAL, MAX_MINERAL))


func add_mineral(mineral: String, quantity: int):
	minerals[mineral] += quantity  #TODO: saturation


func consume_mineral(mineral: String, quantity: int):
	var acquired = 0
	if has_mineral(mineral):
		var present = minerals[mineral]
		if present >= quantity:
			minerals[mineral] -= quantity
			acquired = quantity
		else:
			minerals[mineral] = 0
			acquired = present

	return acquired


func has_mineral(mineral: String):
	return mineral in minerals


func get_minerals():
	return self.minerals
