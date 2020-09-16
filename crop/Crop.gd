extends "res://crop/Inffectable.gd"

var index: Vector2

export var needs = {} #setget set_needs
export var rejects = {}  # TODO
var total_needs = 0
var is_dead = false
onready var field = get_parent().get_parent()

enum stages { SEED, GROWING, VEGETATIVE, REPRODUCTIVE, LAST }
var stages_cycles = {
	stages.SEED: 1, stages.GROWING: 10, stages.VEGETATIVE: 3, stages.REPRODUCTIVE: 3
}
export var current_stage = stages.SEED
export var MINIMUM_HEALTH_TO_GROW = 20
var stage_maturity = 0

export var MAX_YIELD = 100
var YIELD_PER_CYCLE = MAX_YIELD / stages_cycles[stages.REPRODUCTIVE]
export var MINIMUN_HEALTH_TO_MAX_YIELD = 70
export var current_yield = 0
export var current_yield_limit = 100

# func _init(parent_field = null):
# 	self.field = parent_field


func _ready():
	print_debug("new Node at " + str(index))
	update_total_needs()


# func set_needs(new_needs):
# 	needs = new_needs
# 	update_total_needs()


func update_total_needs():
	total_needs = 0
	for need in self.needs:
		total_needs += needs[need]


func cycle():
	# current_cycle += 1
	absorve_minerals_from_soil()
	activate_diseases()
	update_health()
	_grow()
	_update_yield()
	if self.health < 1:
		_die()


func left_clicked_on_tile():
	print("Clicked on crop at" + str(index))


func _on_Crop_mouse_entered():
	pass  # Replace with function body.


func _on_Crop_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == BUTTON_LEFT:
			left_clicked_on_tile()


func absorve_minerals_from_soil():
	if not field:
		printerr("Crop has no field")
		field = get_field()

	var soil_substract = field.get_soil_minerals(self.index)
	var minerals = self.get_minerals()

	for n in needs:
		var lacking = get_lacking_amount(n)
		if lacking > 0:
			minerals[n] += soil_substract.consume_mineral(n, lacking)  #TODO: all at once?


# need for testinig stubs
func get_field():
	return get_parent().get_parent()


func update_health():
	#TODO[1]
	if total_needs <= 0:
		return

	var total_lacking = 0

	for n in needs:
		total_lacking += get_lacking_amount(n)

	var damage = float(total_lacking) / total_needs  # 0 to 1
	self.health -= damage * self.health * 0.5  # amortization
	self.health = int(clamp(self.health, 0, MAX_HEALTH))


func get_lacking_amount(mineral) -> int:
	var minerals = get_minerals()
	if not mineral in minerals:
		minerals[mineral] = 0
	return needs[mineral] - minerals[mineral]


func _die():
	is_dead = true
	field.on_crop_died(index)  #TODO: use signal?
	queue_free()


func _grow():
	# TODO consume self minerals
	# There should be info about water/minerals consumption per unit of mass

	if self.health > MINIMUM_HEALTH_TO_GROW:  #TODO: smarter condition(s)
		self.stage_maturity += 1

	if self.stage_maturity >= stages_cycles[current_stage]:
		current_stage += 1
		if current_stage == stages.LAST:
			current_stage = stages.VEGETATIVE

		_update_frame()
		self.stage_maturity = 0

func _update_frame():
	sprite.frame = current_stage

func _update_yield():
	# TODO add tests
	_update_yield_limit()
	if current_stage == stages.REPRODUCTIVE:
		current_yield += YIELD_PER_CYCLE * health / MAX_HEALTH #TODO[1]: update health to be a 0 to 1 ratio so this calcuation is performed onyl once per cycle 


func _update_yield_limit():
	if current_stage == stages.VEGETATIVE and health < MINIMUN_HEALTH_TO_MAX_YIELD:
		current_yield_limit = MAX_YIELD * health / MAX_HEALTH #TODO[1]
