extends "res://crop/Inffectable.gd"

var index: Vector2

var needs = {} setget set_needs
var total_needs = 0
var is_dead = false
onready var field = get_parent().get_parent()

enum growth_stages { SEED, GROWING, GROWN, ROT }
var growth_stage = growth_stages.SEED
# var current_cycle = 0

enum yield_stages { A, B, C }
var yield_stage = yield_stages.A
export var yield_a_rate = 10
export var yield_b_rate = 0
export var yield_c_rate = -20
var current_yield_rate = yield_a_rate
var current_yield = 0

var maturity = 0
export var maturity_levels_to_grow = 5

# func _init(parent_field = null):
# 	self.field = parent_field


func _ready():
	print_debug("new Node at " + str(index))
	update_total_needs()


func set_needs(new_needs):
	needs = new_needs
	update_total_needs()


func update_total_needs():
	total_needs = 0
	for need in needs:
		total_needs += needs[need]


func cycle():
	# current_cycle += 1
	absorve_nutrients_from_soil()
	activate_diseases()
	update_health()
	grow()
	update_yield()
	if self.health < 1:
		die()


func left_clicked_on_tile():
	print("Clicked on crop at" + str(index))


func _on_Crop_mouse_entered():
	pass  # Replace with function body.


func _on_Crop_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == BUTTON_LEFT:
			left_clicked_on_tile()


func absorve_nutrients_from_soil():
	if not field:
		printerr("Crop has no field")
		field = get_field()

	var soil_substract = field.get_soil_nutrients(self.index)
	var nutrients = self.get_nutrients()

	for n in needs:
		var lacking = get_lacking_amount(n)
		if lacking > 0:
			nutrients[n] += soil_substract.consume_nutrient(n, lacking)  #TODO: all at once?


# need for testinig stubs
func get_field():
	return get_parent().get_parent()


func update_health():
	if total_needs <= 0:
		return

	var total_lacking = 0

	for n in needs:
		total_lacking += get_lacking_amount(n)

	var damage = float(total_lacking) / total_needs  # 0 to 1
	self.health -= damage * self.health * 0.5  # amortization
	self.health = int(clamp(self.health, 0, MAX_HEALTH))


func get_lacking_amount(nutrient) -> int:
	var nutrients = get_nutrients()
	if not nutrient in nutrients:
		nutrients[nutrient] = 0
	return needs[nutrient] - nutrients[nutrient]


func die():
	is_dead = true
	field.on_crop_died(index)  #TODO: use signal?
	queue_free()


func grow():
	#TODO consume nutrients
	if growth_stage == growth_stages.ROT:
		return

	if self.health > self.MAX_HEALTH / 2:  #TODO: smarter condition(s)
		self.maturity += 1

	if self.maturity >= self.maturity_levels_to_grow:
		self.maturity = 0
		growth_stage += 1
		sprite.frame = growth_stage


func update_yield():
	#TODO add tests
	var h = health / MAX_HEALTH

	if current_yield_rate >= 0:
		current_yield += h * current_yield_rate
	else:
		current_yield += h / current_yield_rate
	#TODO
