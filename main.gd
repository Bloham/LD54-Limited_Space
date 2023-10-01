extends Node2D

@onready var item_scene = preload("res://item.tscn")

@onready var leftLine = $ShipManager/LeftPort/Path2D/PathFollow2D
@onready var rightLine = $ShipManager/RightPort/Path2D/PathFollow2D

@onready var leftShip = $ShipManager/DummyBoats/LeftShipDummy
@onready var rightShip = $ShipManager/DummyBoats/RightShipDummy

var leftShipTaken = false
var rightShipTaken = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if GameManager.item_held:
		if Input.is_action_just_pressed("mouse_rightclick"):
			if leftShip.rotateContainer.get_global_rect().has_point(get_global_mouse_position()) or rightShip.rotateContainer.get_global_rect().has_point(get_global_mouse_position()):
				rotate_item()
		
		if Input.is_action_just_pressed("mouse_leftclick"):
			if leftShip.rotateContainer.get_global_rect().has_point(get_global_mouse_position()):
				leftShip.place_item()
			
			if rightShip.rotateContainer.get_global_rect().has_point(get_global_mouse_position()):
				rightShip.place_item()


func _on_button_spawn_pressed() -> void:
	var new_item = item_scene.instantiate()
	add_child(new_item)
	# randi_range is for the amount of items we have.
	new_item.load_item(randi_range(1,4))
	new_item.selected = true
	GameManager.item_held = new_item

func rotate_item():
	GameManager.item_held.rotate_item()
	leftShip.clear_grid()
	rightShip.clear_grid()


func _on_ship_manager_new_ship_has_spawned(newShip, shipLane):
	print("New Ship Registered: ", newShip, " on lane: ", shipLane)
	if shipLane == leftLine:
		leftShip = newShip
		leftShipTaken = true
		print("Left Ship Taken: ", leftShipTaken)
	else:
		rightShip = newShip
		rightShipTaken = true
		print("Right Ship Taken: ", rightShipTaken)
	
