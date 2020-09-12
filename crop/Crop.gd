extends "res://crop/Inffectable.gd"

export var MAX_HEALTH = 100
var health = MAX_HEALTH
var index: Vector2

var needs = {}
var has = {}

var field

func _init(parent_field=null):
	self.field = parent_field

func _ready():
	print("new Node at " + str(index))


func cycle():
	absorve_nutrients_from_soil()
	activate_diseases()
	update_health()


func left_clicked_on_tile():
	print("Clicked on crop at" + str(index))


func _on_Crop_mouse_entered():
	pass  # Replace with function body.


func _on_Crop_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == BUTTON_LEFT:
			left_clicked_on_tile()


func activate_diseases():
	for disease in diseases:
		pass

func absorve_nutrients_from_soil():
	if not field:
		printerr("Crop has no field. Can not absorve nutrients.")

	var substract = field.get_soil_nutrients(self.index)
	
	for n in needs:
		if not n in has:
			has[n] = 0
		var lacking = needs[n] - has[n]
		if lacking > 0:
			has[n] += substract.consume_nutrient(n, lacking) #TODO: all at once?

func update_health():
	pass
