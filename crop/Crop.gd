extends "res://crop/Inffectable.gd"

var index: Vector2

var needs = {} setget set_needs
var total_needs = 0
var is_dead = false
var field


func _init(parent_field = null):
	self.field = parent_field
	update_total_needs()


func _ready():
	print_debug("new Node at " + str(index))


func set_needs(new_needs):
	needs = new_needs
	update_total_needs()


func update_total_needs():
	total_needs = 0
	for need in needs:
		total_needs += needs[need]


func cycle():
	absorve_nutrients_from_soil()
	activate_diseases()
	update_health()
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


# func activate_diseases():
# 	for disease in diseases:
# 		disease.consume()


func absorve_nutrients_from_soil():
	if not field:
		printerr("Crop has no field. Can not absorve nutrients.")
		return

	var soil_substract = field.get_soil_nutrients(self.index)
	var nutrients = self.substract.nutrients

	for n in needs:
		var lacking = get_lacking_amount(n)
		if lacking > 0:
			nutrients[n] += soil_substract.consume_nutrient(n, lacking)  #TODO: all at once?


func update_health():
	if total_needs <= 0:
		return

	var total_lacking = 0

	for n in needs:
		total_lacking += get_lacking_amount(n)

	var damage = float(total_lacking) / total_needs  # 0 to 1
	self.health -= damage * self.health
	self.health = int(clamp(self.health, 0, MAX_HEALTH))


func get_lacking_amount(nutrient) -> int:
	if not nutrient in self.substract.nutrients:
		self.substract.nutrients[nutrient] = 0
	return needs[nutrient] - self.substract.nutrients[nutrient]


func die():
	print_debug("Crop at " + str(index) + " died.")
	is_dead = true
	field.on_crop_died(index)  #TODO: use signal?
	queue_free()
