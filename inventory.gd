extends Control

@onready var slot_scene = preload("res://slot.tscn")
@onready var grid_container1 = $Ship1/Sprite2D/MarginContainer/VBoxContainer/MarginContainer/GridContainer
@onready var item_scene = preload("res://item.tscn")
@onready var scroll_container1 = $Ship1/Sprite2D/MarginContainer/VBoxContainer/MarginContainer
@onready var col_count1 = grid_container1.columns

var grid_array := []
var current_slot = null
var can_place := false
var icon_ancor : Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	innantiate_ship1()

func innantiate_ship1():
	for i in range(24):
		create_slots()


func create_slots():
	var new_slot = slot_scene.instantiate()
	new_slot.slot_ID = grid_array.size()
	grid_array.push_back(new_slot)
	grid_container1.add_child(new_slot)
	new_slot.slot_entered.connect(_on_slot_mouse_entered)
	new_slot.slot_exited.connect(_on_slot_mouse_exited)


func _on_slot_mouse_entered(a_Slot):
	icon_ancor = Vector2(0, 0)
	current_slot = a_Slot
	if GameManager.item_held:
		check_slot_availability_left(current_slot)
		set_grids_left.call_deferred(current_slot)
		

	
func _on_slot_mouse_exited(a_Slot):
	clear_grid()


func check_slot_availability_left(a_Slot) -> void:
	for grid in GameManager.item_held.item_grids:
		var grid_to_check = a_Slot.slot_ID + grid[0] + grid[1] * col_count1
		var line_switch_check = a_Slot.slot_ID % col_count1 + grid[0]
		if line_switch_check < 0 or line_switch_check >= col_count1:
			can_place = false
			return
		if grid_to_check < 0  or grid_to_check >= grid_array.size():
			can_place = false
			return
		if grid_array[grid_to_check].state == grid_array[grid_to_check].States.TAKEN:
			can_place = false
			return
	can_place = true

func set_grids_left(a_Slot):
	for grid in GameManager.item_held.item_grids:
		var grid_to_check = a_Slot.slot_ID + grid[0] + grid[1] * col_count1
		var line_switch_check = a_Slot.slot_ID % col_count1 + grid[0]
		if grid_to_check < 0 or grid_to_check >= grid_array.size():
			continue
		if line_switch_check < 0 or line_switch_check >= col_count1:
			continue
		
		if can_place:
			grid_array[grid_to_check].set_color(grid_array[grid_to_check].States.FREE)
			
			if grid[1] < icon_ancor.x: icon_ancor.x = grid[1]
			if grid[0] < icon_ancor.y: icon_ancor.y = grid[0]
		
		else:
			grid_array[grid_to_check].set_color(grid_array[grid_to_check].States.TAKEN)

func clear_grid():
	for grid in grid_array:
		grid.set_color(grid.States.DEFAULT)


func rotate_item():
	GameManager.item_held.rotate_item()
	clear_grid()
	if current_slot:
		_on_slot_mouse_entered(current_slot)


func place_item():
	if not can_place or not current_slot:
		#add visual or audio cues that you cant place the item here
		return
		
	var calculated_grid_id = current_slot.slot_ID + icon_ancor.x * col_count1 + icon_ancor.y
	GameManager.item_held._snap_to(grid_array[calculated_grid_id].global_position)
	
	GameManager.item_held.get_parent().remove_child(GameManager.item_held)
	grid_container1.add_child(GameManager.item_held)
	GameManager.item_held.global_position = get_global_mouse_position()
	
	GameManager.item_held.grid_ancor = current_slot
	for grid in GameManager.item_held.item_grids:
		var grid_to_check = current_slot.slot_ID + grid[0] + grid[1] * col_count1
		grid_array[grid_to_check].state = grid_array[grid_to_check].States.TAKEN
		grid_array[grid_to_check].item_stored = GameManager.item_held
		
	GameManager.item_held = null
	clear_grid()


func pick_item():
	if not current_slot or not current_slot.item_stored:
		return
		
	GameManager.item_held = current_slot.item_stored
	GameManager.item_held.selected = true
	
	GameManager.item_held.get_parent().remove_child(GameManager.item_held)
	add_child(GameManager.item_held)
	GameManager.item_held.global_position = get_global_mouse_position()
	
	for grid in GameManager.item_held.item_grids:
		var grid_to_check = GameManager.item_held.grid_ancor.slot_ID + grid[0] + grid[1] * col_count1
		grid_array[grid_to_check].state = grid_array[grid_to_check].States.FREE
		grid_array[grid_to_check].item_stored = null
		
	check_slot_availability_left(current_slot)
	set_grids_left.call_deferred(current_slot)
	

