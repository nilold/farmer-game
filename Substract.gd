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
export var water_saturation = 1000  # can be changed with soil inputs
export var water = 0


func _init(randomize_qnty: bool = false):
	if randomize_qnty:
		randomize()
		for mineral in MINERALS:
			minerals[mineral] = int(rand_range(MIN_RANDON_MINERAL, MAX_RANDOM_MINERAL))

		water = int(rand_range(MIN_RANDON_WATER, MAX_RANDOM_WATER))


func add_mineral(mineral: String, quantity: float):
	if not mineral in minerals:
		minerals[mineral] = 0
	minerals[mineral] += quantity
	minerals[mineral] = clamp(minerals[mineral], 0, MINERAL_SATURATION)


func add_water(quantity: float):
	water += quantity
	water = clamp(water, 0, water_saturation)


func consume_mineral(mineral: String, quantity: float):
	var acquired = 0
	if has_mineral(mineral):
		acquired = clamp(quantity, 0, minerals[mineral])
		minerals[mineral] -= acquired

	return acquired


func consume_water(quantity: float):
	var acquired = clamp(quantity, 0, water)
	water -= acquired
	return acquired


func has_mineral(mineral: String):
	return mineral in minerals


func get_minerals():
	return self.minerals
