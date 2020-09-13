extends TileMap

var Crop = preload("res://crop/Crop.tscn")
var Bacteria = preload("res://Disease/Bacteria.tscn")
var Substract = preload("res://Substract.gd")
onready var Crops = $Crops
var stats = Stats

var crops = {}

var soil_substracts = {}


# Called when the node enters the scene tree for the first time.
func _ready():
	# var _err = Crop.connect("crop_died", self, "on_crop_died")
	pass


var pressed = false


func on_crop_died(index: Vector2):
	crops[index.x].erase(index.y)


func _input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		pressed = event.is_pressed()
		if pressed:
			match stats.mouse_state:
				stats.mouse_states.ADD_DISEASE:
					add_disease()
				stats.mouse_states.SPREAD:
					spread_diseases()

	if event is InputEventKey and stats.mouse_state == stats.mouse_states.CYCLE:
		cycle()

	if click_to_add_crop(event):
		add_crop()


func click_to_add_crop(event):
	return (
		event is InputEventMouseMotion
		and pressed
		and stats.mouse_state == stats.mouse_states.ADD_CROP
	)


func cycle():
	cycle_crops()


func cycle_crops():
	for crop_x in crops:
		for crop_y in crops[crop_x]:
			crops[crop_x][crop_y].cycle()


func add_crop():
	var newCrop = create_new_crop_at(get_global_mouse_position())

	if not newCrop.index.x in crops:
		crops[newCrop.index.x] = {}

	if not newCrop.index.y in crops[newCrop.index.x]:
		Crops.add_child(newCrop)
		crops[newCrop.index.x][newCrop.index.y] = newCrop


func create_new_crop_at(global_position):
	var newCrop = Crop.instance()
	newCrop._init(self)
	newCrop.needs = {"Na": 10}
	var mapPos = world_to_map(global_position)
	newCrop.position = map_to_world(mapPos)
	newCrop.index = mapPos
	return newCrop


func remove_crop(_crop):
	pass


func add_disease():
	var crop_index = world_to_map(get_global_mouse_position())
	var crop = crops[crop_index.x][crop_index.y]
	if crop:
		crop.inffect(Bacteria.instance())


func spread_diseases():
	var indexes_to_inffect = get_indexes_to_inffect()

	for index in indexes_to_inffect:
		if index.x in crops and index.y in crops[index.x]:
			for disease in indexes_to_inffect[index]:
				crops[index.x][index.y].inffect(disease.copy())


func get_indexes_to_inffect():
#	TODO: consider contamination radius
	var indexes_to_inffect = {}

	for crop_row in crops.values():
		for crop in crop_row.values():
			var index = crop.index
			var up = Vector2(index.x, index.y - 1)
			var down = Vector2(index.x, index.y + 1)
			var left = Vector2(index.x - 1, index.y)
			var right = Vector2(index.x + 1, index.y)

			if not up in indexes_to_inffect:
				indexes_to_inffect[up] = []
			if not down in indexes_to_inffect:
				indexes_to_inffect[down] = []
			if not left in indexes_to_inffect:
				indexes_to_inffect[left] = []
			if not right in indexes_to_inffect:
				indexes_to_inffect[right] = []

			for disease in crop.diseases.values():
				indexes_to_inffect[up].append(disease)
				indexes_to_inffect[down].append(disease)
				indexes_to_inffect[left].append(disease)
				indexes_to_inffect[right].append(disease)

	return indexes_to_inffect


func get_soil_nutrients(index: Vector2):
	if not soil_has_substract(index):
		create_substract_at(index)

	return soil_substracts[index.x][index.y]


func soil_has_substract(index: Vector2):
	return index.x in soil_substracts and index.y in soil_substracts[index.x]


func create_substract_at(index: Vector2):
	if not index.x in soil_substracts:
		soil_substracts[index.x] = {}
	soil_substracts[index.x][index.y] = Substract.new(true)
