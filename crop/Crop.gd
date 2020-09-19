extends "res://crop/Inffectable.gd"

var index: Vector2

####################################################################
# Minerals absorption
#
# On every cycle, the crop will absorb {absorption_flow} of each
# mineral in the ground.
#
export var needs = {}  #setget set_needs
export var tolerates = {}  # the less, the worse, but 0 = full tolerance
export var absorption_flow = 5
# var total_needs = 0
####################################################################
# Health control
#
export var damage_amortization = 0.8
var is_dead = false
####################################################################

onready var field = get_parent().get_parent()

enum stages { SEED, GROWING, VEGETATIVE, REPRODUCTIVE, LAST }
export var stages_cycles = {
	stages.SEED: 1, stages.GROWING: 10, stages.VEGETATIVE: 6, stages.REPRODUCTIVE: 3
}
export var current_stage = stages.SEED setget _set_current_stage
export var MINIMUM_HEALTH_TO_GROW = 20
var stage_maturity = 0

export var MAX_YIELD = 100
var YIELD_PER_CYCLE = MAX_YIELD / stages_cycles[stages.REPRODUCTIVE]
export var MINIMUN_HEALTH_TO_MAX_YIELD = 70
export var current_yield = 0
export var current_yield_limit = 100


func _ready():
	print_debug("new Node at " + str(index))


func cycle():
	# current_cycle += 1
	_absorve_minerals_from_soil()
	_activate_diseases()
	_update_health()
	_grow()
	_update_yield()
	if self.health < 1:
		_die()


func get_minerals():
	return self.substract.get_minerals()


func _set_current_stage(new_stage):
	current_stage = new_stage
	sprite.frame = current_stage


func left_clicked_on_tile():
	print("Clicked on crop at" + str(index))


func _on_Crop_mouse_entered():
	pass  # Replace with function body.


func _on_Crop_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == BUTTON_LEFT:
			left_clicked_on_tile()


func _absorve_minerals_from_soil():
	if not field:
		printerr("Crop has no field")
		field = get_field()

	var soil_substract = field.get_soil_minerals(self.index)
	var minerals = self.get_minerals()

	for m in soil_substract.minerals:
		if not m in minerals:
			minerals[m] = 0
		minerals[m] += soil_substract.consume_mineral(m, absorption_flow)


# need for testinig stubs
func get_field():
	return get_parent().get_parent()


func _update_health():
	_take_damage_by_lacking_minerals()
	_take_damage_by_rejected_minerals()


func _take_damage_by_lacking_minerals():
	if len(needs.keys()) == 0:
		return

	var total_lacking = 0
	var total_needs = 0

	for n in needs:
		total_needs += needs[n]
		total_lacking += needs[n] - _get_present_amount(n)

	_take_damage(total_lacking, total_needs)


func _take_damage_by_rejected_minerals():
	if len(tolerates.keys()) == 0:
		return

	var total_rejection = 0
	var total_extra = 0

	for r in tolerates:
		total_rejection += tolerates[r]
		total_extra += _get_present_amount(r)

	_take_damage(total_extra, total_rejection)


func _take_damage(bad_amount, good_amount):
	if bad_amount == 0 or good_amount == 0:
		return

	var damage = float(bad_amount) / good_amount
	self.health -= damage * self.health * damage_amortization
	self.health = int(clamp(self.health, 0, MAX_HEALTH))


func _get_present_amount(mineral) -> int:
	var minerals = get_minerals()
	if not mineral in minerals:
		minerals[mineral] = 0
	return minerals[mineral]


func _die():
	is_dead = true
	field.on_crop_died(index)  #TODO: use signal?
	queue_free()


func _grow():
	# TODO consume self minerals
	# There must be info about water/minerals consumption per unit of mass

	if self.health > MINIMUM_HEALTH_TO_GROW:  #TODO: smarter condition(s)
		self.stage_maturity += 1

	if self.stage_maturity >= stages_cycles[current_stage]:
		var new_stage = current_stage + 1
		if new_stage == stages.LAST:
			new_stage = stages.VEGETATIVE

		_set_current_stage(new_stage)

		self.stage_maturity = 0


func _update_yield():
	# TODO add tests
	_update_yield_limit()
	if current_stage == stages.REPRODUCTIVE:
		current_yield += YIELD_PER_CYCLE * health / MAX_HEALTH  #TODO[1]: update health to be a 0 to 1 ratio so this calcuation is performed onyl once per cycle 


func _update_yield_limit():
	if current_stage == stages.VEGETATIVE and health < MINIMUN_HEALTH_TO_MAX_YIELD:
		current_yield_limit = MAX_YIELD * health / MAX_HEALTH  #TODO[1]
