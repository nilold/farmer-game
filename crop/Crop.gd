extends "res://crop/Inffectable.gd"

var index: Vector2

####################################################################
# Minerals absorption
#
export var needs = {}  #setget set_needs
export var tolerates = {}  # the less, the worse, but 0 = full tolerance
export var mineral_absorption_flow: float = 1.8
export var water_absorption_flow: float = 0.1
export var water_saturation = 1
var root_health = 1.0
####################################################################
# Development
#
var leaves = 0
export var leaves_setpoint = 100  # Value in which happens 100% of sun energy conversion
export var leaf_growth_energy_consumption: float = 70
export var leaf_growth_mineral_consumption: float = 1.8
export var min_leaves_to_grow_sprouts: float = 70
export var leaf_growth_speed: float = 50
export var natural_leaf_drop_per_cycle: float = 0.002
####################################################################
# Energy
#
export var water_per_energy: float = 0.02
export var max_sun_energy_conversion = 1000
var total_energy_produced = 0
var total_energy_used = 0

####################################################################
# Productity
#
export var fruits_setpoint = 100

export var sprouts_growth_energy_consumption = 70
export var sprouts_growth_mineral_consumption: float = 2.0
export var sprout_growth_speed: float = 50

export var flowers_growth_energy_consumption = 70
export var flowers_growth_mineral_consumption: float = 1.2
export var flower_growth_speed: float = 20

export var fruits_growth_energy_consumption = 120
export var fruits_growth_mineral_consumption: float = 4.0
export var fruit_growth_speed: float = 50

var flowers = 0
var sprouts = 0
var total_fruits = 0
var mature_fruits = 0
var green_fruits = 0
var rot_fruits = 0
var avg_fruit_size = 0
var avg_fruit_quality = 0
####################################################################
# Health control
#
export var damage_amortization = 0.5
var is_dead = false

#################################################################################
# Status Watcher
var status_watcher = null
var watcher_container = null

onready var field = get_parent().get_parent()

enum stages { INITIAL, DEVELOPMNENT, FLOWERY, PRODUCTION, LAST }
export var stages_cycles = {
	stages.INITIAL: 30, stages.DEVELOPMNENT: 50, stages.FLOWERY: 10, stages.PRODUCTION: 40
}
export var current_stage = stages.INITIAL setget _set_current_stage
export var MINIMUM_HEALTH_TO_GROW = 20
var stage_maturity = 0
# export var MINERAL_CONSUMPTION_PER_GROWING_CYCLE = 5

export var MAX_YIELD = 100
var YIELD_PER_CYCLE = MAX_YIELD / stages_cycles[stages.PRODUCTION]
export var MINIMUN_HEALTH_TO_MAX_YIELD = 70
export var current_yield = 0
export var current_yield_limit = 100

#################################################################################
##############################		Functions		#############################
#################################################################################

#################################################################################
# Lifecycle and Node control


func cycle():
	_absorve_nutrients_from_soil()
	_activate_diseases()
	_update_health()
	_grow()
	_mature()

	_update_dynamic_statuses()

	if self.health < 0.01:
		_die()


func _mature():
	stage_maturity += 1
	if stage_maturity >= stages_cycles[current_stage]:
		stage_maturity = 0
		current_stage += 1
	if current_stage == stages.LAST:
		current_stage = stages.DEVELOPMNENT
		reset_yield()  # TODO: review this

	_lose_leaves()


func _lose_leaves():
	self.leaves *= self.health * (1 - natural_leaf_drop_per_cycle)


func reset_yield():
	sprouts = 0
	total_fruits = 0
	rot_fruits = mature_fruits
	mature_fruits = 0
	green_fruits = 0
	avg_fruit_size = 0
	avg_fruit_quality = 0


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


func get_water():
	return self.substract.get_water()


#################################################################################
# Energy


# Convert Energy
# Use sun and water and maybe some nutrient to convert into usable energy
# WARNING: all consumables must be also present on the _return_energy_resources function
func _convert_energy(required):
	#TODO: consume any nutrients?
	var acquired = _convert_sun_to_energy(required)
	total_energy_produced += acquired
	acquired = _convert_water_to_energy(acquired)
	total_energy_used += acquired

	notify("total_energy_produced", total_energy_produced)
	notify("total_energy_used", total_energy_used)

	return acquired


# Returns everything consumed by the _convert_energy function proportionally to the quantity
func _return_energy_resources(quantity):
	_add_water(water_per_energy * quantity)


func _convert_water_to_energy(required):
	var water = _consume_water(water_per_energy * required)
	return clamp(required, 0, water / water_per_energy)


func _convert_sun_to_energy(required):
	var sun_energy = _sun() * float(leaves) / leaves_setpoint
	var available_sun = clamp(sun_energy, 0, max_sun_energy_conversion)
	return required * (available_sun / max_sun_energy_conversion)


func _set_current_stage(new_stage):
	current_stage = new_stage
	_update_frame()


#################################################################################
# Nutrition


func _get_soil_substract():
	return field.get_soil_substract(self.index)


func _consume_soil_water(quantity: float) -> float:
	return _get_soil_substract().consume_water(quantity)


func _add_water_to_soil(quantity: float) -> void:
	_get_soil_substract().add_water(quantity)


func _consume_water(quantity: float) -> float:
	return self.substract.consume_water(quantity)


func _add_water(quantity: float) -> void:
	substract.add_water(quantity)


func _absorve_nutrients_from_soil():
	if not field:
		printerr("Crop has no field")
		field = get_field()

	var soil_substract = _get_soil_substract()
	var minerals = self.get_minerals()

	for m in soil_substract.minerals:
		if not m in minerals:
			minerals[m] = 0
		minerals[m] += soil_substract.consume_mineral(m, mineral_absorption_flow * root_health)

	if get_water() < water_saturation:
		_add_water(soil_substract.consume_water(water_absorption_flow * root_health))


#################################################################################
# Health
func _update_health():
	var damage = _get_damage_by_lacking_minerals()
	notify("last damage by lacking mineral", damage)
	_damage_health(damage)
	damage = _get_damage_by_rejected_minerals()
	notify("last damage by rejected mineral", damage)
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
	self.health *= (1 - damage * damage_amortization)
	self.health = clamp(self.health, 0, 1)


func _recover():
	#TODO
	pass


func _get_present_amount(mineral) -> float:
	var minerals = self.get_minerals()
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
	match current_stage:
		stages.INITIAL:
			_develop_initial()
		stages.DEVELOPMNENT:
			_develop()
		stages.FLOWERY:
			_flower()
		stages.PRODUCTION:
			_produce()

	# notify("stage", stages.keys()[current_stage])


func _develop_initial():
	_grow_leaves()


func _develop():
	if leaves >= min_leaves_to_grow_sprouts:
		_grow_sprouts()  # higher priority
	_grow_leaves()


func _flower():
	sprouts -= _grow_flowers()


func _produce():
	flowers -= _grow_fruits()


func _grow_leaves():
	if leaves < 1:
		leaves = 1

	var growth_pressure = float(leaves_setpoint - leaves) / leaves_setpoint
	if growth_pressure == 0:
		return

	var growth_force = _grow_by_energy_and_mineral(
		growth_pressure, leaf_growth_energy_consumption, leaf_growth_mineral_consumption
	)

	var growth = growth_force * leaf_growth_speed
	leaves = clamp(leaves + growth, leaves, leaves_setpoint)


func _grow_sprouts():  # TODO: add tests
	var growth_pressure = float(fruits_setpoint - sprouts) / fruits_setpoint
	if growth_pressure == 0:
		return

	var growth_force = _grow_by_energy_and_mineral(
		growth_pressure, sprouts_growth_energy_consumption, sprouts_growth_mineral_consumption
	)
	var growth = growth_force * sprout_growth_speed
	sprouts = clamp(sprouts + growth, sprouts, fruits_setpoint)


func _grow_flowers() -> float:  # TODO: add tests
	if sprouts == 0:
		return 0.0

	var growth_pressure = float(sprouts) / (sprouts + flowers)

	var growth_force = _grow_by_energy_and_mineral(
		growth_pressure, flowers_growth_energy_consumption, flowers_growth_mineral_consumption
	)

	var growth = growth_force * flower_growth_speed
	flowers += growth

	return growth


func _grow_fruits() -> float:
	if flowers == 0:
		return 0.0

	var growth_pressure = float(flowers) / (flowers + total_fruits)

	var growth_force = _grow_by_energy_and_mineral(
		growth_pressure, fruits_growth_energy_consumption, fruits_growth_mineral_consumption
	)

	var growth = growth_force * fruit_growth_speed
	total_fruits += growth

	return growth


func _grow_by_energy_and_mineral(pressure, energy_consumption, mineral_consumption):
	var required_energy = pressure * energy_consumption  # 0 to leaf_growth_energy_consumption
	var required_mineral = pressure * mineral_consumption  # 0 to leaf_growth_mineral_consumption
	var acquired_energy = _convert_energy(required_energy)  # 0 to leaf_growth_energy_consumption

	if acquired_energy == 0:
		return 0

	var energy_consumption_ratio = acquired_energy / required_energy
	required_mineral *= energy_consumption_ratio
	var consumed_minerals = _consume_self_minerals(required_mineral)

	# Growth consumption paradox: we have to return unsued energy in the case that consume_minerals dont succeeds
	var mineral_consumption_ratio = consumed_minerals / required_mineral
	var energy_to_return = acquired_energy * (1 - mineral_consumption_ratio)
	_return_energy_resources(energy_to_return)

	return (
		pressure
		* pressure
		* (acquired_energy / required_energy)
		* (consumed_minerals / required_mineral)
	)  # 0 to 1  # 0 to 1 sqrd


func _consume_self_minerals(amount):
	if len(needs) == 0:
		return 0

	var avg_consumed = 0
	var need_n = 0

	for n in needs:
		need_n += 1
		avg_consumed += self.substract.consume_mineral(n, amount)

	avg_consumed /= need_n
	return avg_consumed


#################################################################################
# Status Watcher


func set_watcher(watcher, container):
	self.status_watcher = watcher
	self.watcher_container = container
	_update_static_statuses()
	_update_dynamic_statuses()


func _update_static_statuses():
	notify("type", "crop")
	notify("index", self.index)
	notify("needs", needs)
	notify("tolerates", tolerates)


func _update_dynamic_statuses():
	if status_watcher:
		notify("-----------development--------------", "")
		notify("minerals", get_minerals())
		notify("water", get_water())
		notify("health", health)
		notify("stage", stages.keys()[current_stage])
		notify("stage_maturity", stage_maturity)
		notify("------------production------------------", "")
		notify("leaves", leaves)
		notify("sprouts", sprouts)
		notify("flowers", flowers)
		notify("total_fruits", total_fruits)
		notify("mature_fruits", mature_fruits)
		notify("green_fruits", green_fruits)
		notify("rot_fruits", rot_fruits)
		notify("avg_fruit_size", avg_fruit_size)
		notify("avg_fruit_quality", avg_fruit_quality)
		notify("-------------------------------", "")


func remove_watcher():
	self.status_watcher = null
	self.watcher_container = null


func notify(key: String, value):
	if status_watcher:
		status_watcher.set_item(key, value, watcher_container)
