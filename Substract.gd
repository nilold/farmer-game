extends Node

# #############################################################################
# Minerals
export var MINERALS = ["N", "P", "K", "Fe"]
export var MINERAL_SATURATION = 600
export var MIN_RANDON_MINERAL = 200
export var MAX_RANDOM_MINERAL = 500
var minerals = {}
# #############################################################################
# Water
export var MIN_RANDON_WATER = 50
export var MAX_RANDOM_WATER = 100
export var water_saturation = 1000  # can be changed with soil inputs
export var water = 0

#################################################################################
# Status Watcher
var status_watcher = null
var watcher_container = null


func _init(randomize_qnty: bool = false):
	if randomize_qnty:
		for mineral in MINERALS:
			randomize()
			minerals[mineral] = int(rand_range(MIN_RANDON_MINERAL, MAX_RANDOM_MINERAL))

		water = int(rand_range(MIN_RANDON_WATER, MAX_RANDOM_WATER))

	update_watcher()


func add_mineral(mineral: String, quantity: float):
	if not mineral in minerals:
		minerals[mineral] = 0
	minerals[mineral] += quantity
	minerals[mineral] = clamp(minerals[mineral], 0, MINERAL_SATURATION)
	update_watcher()


func add_water(quantity: float):
	water += quantity
	water = clamp(water, 0, water_saturation)
	update_watcher()


func consume_mineral(mineral: String, quantity: float):
	var acquired = 0
	if has_mineral(mineral):
		acquired = clamp(quantity, 0, minerals[mineral])
		minerals[mineral] -= acquired

	update_watcher()
	return acquired


func consume_water(quantity: float):
	var acquired = clamp(quantity, 0, water)
	water -= acquired

	update_watcher()
	return acquired


func has_mineral(mineral: String) -> bool:
	return mineral in minerals


func get_minerals():
	return self.minerals


func has_water() -> bool:
	return water > 0


func get_water() -> float:
	return water


func set_watcher(watcher, container):
	self.status_watcher = watcher
	self.watcher_container = container
	notify("type", "soil")
	update_watcher()


func remove_watcher():
	self.status_watcher = null
	self.watcher_container = null


func update_watcher():
	notify("minerals", minerals)
	notify("water", water)


func notify(key: String, value):
	if status_watcher:
		status_watcher.set_item(key, value, watcher_container)
