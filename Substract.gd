extends Node

export var MINERALS = ["K", "Na", "Fe"]
export var SATURATION = 200
export var MIN_RANDON_MINERAL = 10
export var MAX_RANDOM_MINERAL = 70

var minerals = {}


func _init(randomize_minerals: bool = false):
	if randomize_minerals:
		for mineral in MINERALS:
			minerals[mineral] = int(rand_range(MIN_RANDON_MINERAL, MAX_RANDOM_MINERAL))


func add_mineral(mineral: String, quantity: int):
	minerals[mineral] += quantity
	if minerals[mineral] > SATURATION:
		minerals[mineral] = SATURATION


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
