extends "res://addons/gut/test.gd"

var Crop = preload("res://crop/Crop.tscn")
var Substract = load("res://Substract.gd")
var Field = preload("res://Field/Field.tscn")
var Bacteria = "res://Disease/Bacteria.gd"

var field
var crop


func before_all():
	pass


func before_each():
	field = partial_double(Field).instance()
	crop = autofree(partial_double(Crop).instance())
	crop.substract = autofree(Substract.new())
	stub(crop, 'get_minerals').to_return({})
	stub(crop, 'get_field').to_return(field)
	stub(crop, '_update_frame').to_do_nothing()
	stub(crop, '_sun').to_return(50)


func after_each():
	pass


func after_all():
	pass


func test_inffecting():
	var bacteria = double(Bacteria).new()
	stub(crop, '_inffection_succeeds').to_return(true)

	crop.inffect(bacteria)
	assert_true(crop.has_disease(bacteria.ID))


func test_mineral_absorption():
	var pos = Vector2(5, 5)
	var mineral = "Na"
	crop.index = pos
	crop.needs = {mineral: 10}

	var substract = autofree(field.get_soil_substract(pos))
	substract.add_mineral(mineral, 100)
	var original_amount = substract.minerals[mineral]

	crop.cycle()
	assert_eq(substract.minerals[mineral], original_amount - crop.absorption_flow)


func test_crop_dies_if_no_minerals():
	var pos = Vector2(5, 5)
	var mineral = "Na"
	crop.index = pos
	crop.needs = {mineral: 10}
	stub(crop, '_die').to_do_nothing()

	var substract = autofree(field.get_soil_substract(pos))
	substract.minerals[mineral] = 0

	# The amount of cycle necessary to die depends on the damage amortization
	crop.damage_amortization = 1
	crop.cycle()

	assert_called(crop, "_die")


func test_crop_dies_if_too_much_reject_minerals():
	var pos = Vector2(5, 5)
	var mineral = "Fe"
	crop.index = pos
	crop.tolerates = {mineral: 5}
	stub(crop, '_die').to_do_nothing()

	var substract = autofree(field.get_soil_substract(pos))
	substract.minerals[mineral] = 10

	# The amount of cycle necessary to die depends on the damage amortization
	# and teh rejection amount
	crop.damage_amortization = 1
	crop.cycle()
	crop.cycle()

	assert_called(crop, "_die")


#####################################################################################
# Energy test


func test_convert_no_energy_without_water():
	stub(crop, '_sun').to_return(10000)
	stub(crop, '_consume_soil_water').to_return(0)
	var energy_converted = crop._convert_energy(100)

	assert_eq(int(energy_converted), 0)


func test_convert_no_energy_without_sun():
	stub(crop, '_sun').to_return(0)
	stub(crop, '_consume_soil_water').to_return(1000)
	var energy_converted = crop._convert_energy(100)

	assert_eq(int(energy_converted), 0)


func test_convert_all_energy_with_plenty_sun_and_water():
	stub(crop, '_sun').to_return(1000)
	stub(crop, '_consume_soil_water').to_return(1000)
	crop.leaf_rate = crop.leaf_rate_setpoint
	var energy_converted = crop._convert_energy(100)

	assert_eq(int(energy_converted), 100)


func test_partial_energy_conversion_with_mid_water_or_sun():
	stub(crop, '_sun').to_return(50)
	stub(crop, '_consume_soil_water').to_return(1000)
	crop.leaf_rate = crop.leaf_rate_setpoint
	var energy_converted = crop._convert_energy(100)

	assert_between(int(energy_converted), 1, 99)

	stub(crop, '_sun').to_return(1000)
	stub(crop, '_consume_soil_water').to_return(1)
	energy_converted = crop._convert_energy(100)
	assert_between(int(energy_converted), 1, 99)

func test_partial_energy_conversion_with_few_leafs():
	stub(crop, '_sun').to_return(1000)
	stub(crop, '_consume_soil_water').to_return(1000)
	crop.leaf_rate = crop.leaf_rate_setpoint / 2
	crop.sun_strenght_per_energy = 10
	var energy_converted = crop._convert_energy(100)

	assert_between(int(energy_converted), 1, 99)

	stub(crop, '_sun').to_return(1000)
	stub(crop, '_consume_soil_water').to_return(1)
	energy_converted = crop._convert_energy(100)
	assert_between(int(energy_converted), 1, 99)

#####################################################################################
# Growth test

func test_leafs_wont_grow_without_sun():
	pass

func test_leafs_wont_grow_without_water():
	pass

func test_leafs_wont_grow_without_nutrients():
	pass

func test_leafs_wont_grow_if_in_setpoint():
	pass

func test_leafs_grow_with_good_conditions():
	pass

func test_leafs_grow_faster_when_less_leafs():
	pass
