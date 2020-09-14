extends "res://addons/gut/test.gd"

var Crop = preload("res://crop/Crop.tscn")
var Field = "res://Field/Field.tscn"
var Bacteria = "res://Disease/Bacteria.gd"

var field
var crop


func before_all():
	pass


func before_each():
	field = partial_double(Field).instance()
	crop = autofree(partial_double(Crop).instance())
	stub(crop, 'get_nutrients').to_return({})
	stub(crop, 'get_field').to_return(field)


func after_each():
	pass


func after_all():
	pass


func test_inffecting():
	var bacteria = double(Bacteria).new()
	stub(crop, 'inffection_succeeds').to_return(true)

	crop.inffect(bacteria)
	assert_true(crop.has_disease(bacteria.ID))


func test_nutrient_absorption():
	var pos = Vector2(5, 5)
	var nutrient = "Na"
	crop.index = pos
	crop.needs = {nutrient: 10}

	var substract = autofree(field.get_soil_nutrients(pos))
	substract.add_nutrient(nutrient, 100)
	var original_amount = substract.nutrients[nutrient]

	crop.absorve_nutrients_from_soil()
	assert_eq(substract.nutrients[nutrient], original_amount - 10)


func test_crop_dies_if_no_nutrients():
	var pos = Vector2(5, 5)
	var nutrient = "Na"
	crop.index = pos
	crop.needs = {nutrient: 10}
	var substract = autofree(field.get_soil_nutrients(pos))
	substract.nutrients[nutrient] = 0

	stub(crop, 'die').to_do_nothing()
	crop.cycle()
	crop.cycle()
	crop.cycle()
	crop.cycle()
	crop.cycle()
	crop.cycle()
	crop.cycle()
	crop.cycle()
	crop.cycle()
	crop.cycle()

	assert_called(crop, "die")
	
	
