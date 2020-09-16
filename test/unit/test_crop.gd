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
	stub(crop, 'get_minerals').to_return({})
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


func test_mineral_absorption():
	var pos = Vector2(5, 5)
	var mineral = "Na"
	crop.index = pos
	crop.needs = {mineral: 10}

	var substract = autofree(field.get_soil_minerals(pos))
	substract.add_mineral(mineral, 100)
	var original_amount = substract.minerals[mineral]

	crop.absorve_minerals_from_soil()
	assert_eq(substract.minerals[mineral], original_amount - 10)


func test_crop_dies_if_no_minerals():
	var pos = Vector2(5, 5)
	var mineral = "Na"
	crop.index = pos
	crop.needs = {mineral: 10}
	var substract = autofree(field.get_soil_minerals(pos))
	substract.minerals[mineral] = 0

	stub(crop, '_die').to_do_nothing()
	stub(crop, '_update_frame').to_do_nothing()
	for _i in range(20):
		crop.cycle()

	assert_called(crop, "_die")
	
	
