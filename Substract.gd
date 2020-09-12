extends Node

var nutrients = {}
var water = 0

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
