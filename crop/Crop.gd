extends "res://crop/Inffectable.gd"

var index: Vector2

####################################################################
# Minerals absorption
#
export var needs = {}  #setget set_needs
export var tolerates = {}  # the less, the worse, but 0 = full tolerance
export var absorption_flow = 5
####################################################################
# Development
#
var leaf_rate = 0
export var leaf_rate_setpoint = 100  # Value in which happens 100% of sun energy conversion
export var leaf_growth_energy_consumption = 50
####################################################################
# Energy
#
export var water_per_energy = 0.1
export var sun_strenght_per_energy = 10

####################################################################
# Productity
#
var total_fruits = 0
var mature_fruits = 0
var green_fruits = 0
var rot_fruits = 0
var avg_fruit_size = 0
var avg_fruit_quality = 0
####################################################################
# Health control
#
export var damage_amortization = 0.8
var is_dead = false
####################################################################

onready var field = get_parent().get_parent()

enum stages { SEED, GROWING, PRODUCTIVE, LAST }
export var stages_cycles = {stages.SEED: 1, stages.GROWING: 10, stages.PRODUCTIVE: 3}
export var current_stage = stages.SEED setget _set_current_stage
export var MINIMUM_HEALTH_TO_GROW = 20
var stage_maturity = 0
export var MINERAL_CONSUMPTION_PER_GROWING_CYCLE = 5

export var MAX_YIELD = 100
var YIELD_PER_CYCLE = MAX_YIELD / stages_cycles[stages.PRODUCTIVE]
export var MINIMUN_HEALTH_TO_MAX_YIELD = 70
export var current_yield = 0
export var current_yield_limit = 100

#################################################################################
##############################		Functions		#############################
#################################################################################

#################################################################################
# Lifecycle and Node control

# func _ready():
# 	print_debug("new Node at " + str(index))


func cycle():
	# current_cycle += 1
	_absorve_minerals_from_soil()
	_activate_diseases()
	_update_health()
	_grow()
	_update_yield()
	if self.health < 1:
		_die()


func _update_frame():
	sprite.frame = current_stage


func left_clicked_on_tile():
	print("Clicked on crop at" + str(index))


func _on_Crop_mouse_entered():
	pass  # Replace with function body.


func _on_Crop_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == BUTTON_LEFT:
			left_clicked_on_tile()


# need for testinig stubs
func get_field():
	return get_parent().get_parent()


#################################################################################
# Environment


func _temperature():
	return field.world.get_temperature()


func _sun():
	return field.world.get_sun_strength()


func get_minerals():
	return self.substract.get_minerals()


#################################################################################
# Energy
func _convert_energy(recquired):
	#TODO: consume any nutrients?
	var acquired = _convert_water_to_energy(recquired)
	acquired = _convert_sun_to_energy(acquired)
	return acquired


func _convert_water_to_energy(recquired):
	var water = _consume_soil_water(water_per_energy * recquired)
	return clamp(recquired, 0, water / water_per_energy)
	
	
func _convert_sun_to_energy(recquired):
	var available_sun = _sun() * leaf_rate / leaf_rate_setpoint
	return clamp(recquired, 0, available_sun / sun_strenght_per_energy)


func _set_current_stage(new_stage):
	current_stage = new_stage
	_update_frame()


#################################################################################
# Nutrition


func _get_soil_substract():
	return field.get_soil_substract(self.index)


func _consume_soil_water(quantity: int) -> int:
	return _get_soil_substract().consume_water(quantity)


func _absorve_minerals_from_soil():
	if not field:
		printerr("Crop has no field")
		field = get_field()

	var soil_substract = _get_soil_substract()
	var minerals = self.get_minerals()

	for m in soil_substract.minerals:
		if not m in minerals:
			minerals[m] = 0
		minerals[m] += soil_substract.consume_mineral(m, absorption_flow)


#################################################################################
# Health
func _update_health():
	var damage = _get_damage_by_lacking_minerals()
	_damage_health(damage)
	damage = _get_damage_by_rejected_minerals()
	_damage_health(damage)
	_recover()


func _get_damage_by_lacking_minerals():
	if len(needs.keys()) == 0:
		return 0

	var total_lacking = 0
	var total_needs = 0

	for n in needs:
		total_needs += needs[n]
		total_lacking += needs[n] - _get_present_amount(n)

	return _get_damage(total_lacking, total_needs)


func _get_damage_by_rejected_minerals():
	if len(tolerates.keys()) == 0:
		return 0

	var total_rejection = 0
	var total_extra = 0

	for r in tolerates:
		total_rejection += tolerates[r]
		total_extra += _get_present_amount(r)

	return _get_damage(total_extra, total_rejection)


func _damage_health(damage):
	self.health -= damage * self.health * damage_amortization
	self.health = int(clamp(self.health, 0, MAX_HEALTH))


func _recover():
	#TODO
	pass


func _get_present_amount(mineral) -> int:
	var minerals = get_minerals()
	if not mineral in minerals:
		minerals[mineral] = 0
	return minerals[mineral]


func _get_damage(bad_amount, good_amount):
	if bad_amount == 0 or good_amount == 0:
		return 0

	return float(bad_amount) / good_amount


func _die():
	is_dead = true
	field.on_crop_died(index)  #TODO: use signal?
	queue_free()


#################################################################################
# Development
func _grow():
	_grow_leafs()
	_grow_fruits()


func _grow_leafs():
	var growth_pressure = (leaf_rate_setpoint - leaf_rate) / leaf_rate_setpoint # 0 to 1
	var recquired_energy = leaf_growth_energy_consumption * growth_pressure # 0 to leaf_growth_energy_consumption
	var acquired_energy = _convert_energy(recquired_energy) # 0 to leaf_growth_energy_consumption
	var growth_force = (acquired_energy/recquired_energy) * growth_pressure
	leaf_rate = clamp(leaf_rate * (1+ growth_force), leaf_rate, leaf_rate_setpoint)


func _grow_fruits():
	pass


func _consume_self_minerals():
	for n in needs:
		var _consumed_mineral = self.substract.consume_mineral(
			n, MINERAL_CONSUMPTION_PER_GROWING_CYCLE
		)


#################################################################################
# Productivity
func _update_yield():
	# TODO add tests
	_update_yield_limit()
	if current_stage == stages.PRODUCTIVE:
		current_yield += YIELD_PER_CYCLE * health / MAX_HEALTH  #TODO[1]: update health to be a 0 to 1 ratio so this calcuation is performed onyl once per cycle 


func _update_yield_limit():
	pass
	# if current_stage == stages.VEGETATIVE and health < MINIMUN_HEALTH_TO_MAX_YIELD:
	# 	current_yield_limit = MAX_YIELD * health / MAX_HEALTH  #TODO[1]
