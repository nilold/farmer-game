extends Node

export var NUTRIENTS = ["K", "Na", "Fe", "Water"]

var nutrients = {}


func _init(randomize_nutrients: bool = false):
	if randomize_nutrients:
		for nutrient in NUTRIENTS:
			nutrients[nutrient] = int(rand_range(0, 50))


func add_nutrient(nutrient: String, quantity: int):
	nutrients[nutrient] += quantity  #TODO: saturation


func consume_nutrient(nutrient: String, quantity: int):
	var acquired = 0
	if has_nutrient(nutrient):
		var present = nutrients[nutrient]
		if present >= quantity:
			nutrients[nutrient] -= quantity
			acquired = quantity
		else:
			nutrients[nutrient] = 0
			acquired = present

	return acquired


func has_nutrient(nutrient: String):
	return nutrient in nutrients
