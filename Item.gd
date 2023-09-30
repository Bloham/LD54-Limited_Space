extends Node2D

@onready var IconRect_path = $Icon

var item_ID : int
var item_grids := []
var selected = false
var grid_ancor = null



# Called when the node enters the scene tree for the first time.
func _ready():
	load_item(1)
	selected = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if selected:
		global_position = lerp(global_position, get_global_mouse_position(), 25 * delta)


func load_item(a_ItemID : int) -> void:
	var Icon_path = "res://Asset/Items/" + DataHandler.item_data[str(a_ItemID)]["Name"] + ".png"
	IconRect_path.texture = load(Icon_path)
	for grid in DataHandler.item_grid_data[str(a_ItemID)]:
		var converter_array := []
		for i in grid:
			converter_array.push_back(int(i))
		item_grids.push_back(converter_array)
