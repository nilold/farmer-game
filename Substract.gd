extends Node

# #############################################################################
# Minerals
export var MINERALS = ["K", "Na", "Fe"]
export var MINERAL_SATURATION = 600
export var MIN_RANDON_MINERAL = 100
export var MAX_RANDOM_MINERAL = 500
var minerals = {}
# #############################################################################
# Water
export var MIN_RANDON_WATER = 50
export var MAX_RANDOM_WATER = 100
export var water_saturation = 100  # can be changed with soil inputs
export var water = 0


func _init(randomize_qnty: bool = false):
	if randomize_qnty:
		randomize()
		for mineral in MINERALS:
			minerals[mineral] = int(rand_range(MIN_RANDON_MINERAL, MAX_RANDOM_MINERAL))

		water = int(rand_range(MIN_RANDON_WATER, MAX_RANDOM_WATER))


func add_mineral(mineral: String, quantity: int):
	minerals[mineral] += quantity
	minerals[mineral] = clamp(minerals[mineral], 0, MINERAL_SATURATION)


func add_water(quantity: int):
	water += quantity
	water = clamp(water, 0, water_saturation)


func consume_mineral(mineral: String, quantity: int):
	var acquired = 0
	if has_mineral(mineral):
		acquired = clamp(quantity, 0, minerals[mineral])
		minerals[mineral] -= acquired

	return acquired


func consume_water(quantity: int):
	var acquired = clamp(quantity, 0, water)
	water -= acquired
	return acquired


func has_mineral(mineral: String):
	return mineral in minerals


func get_minerals():
	return self.minerals
