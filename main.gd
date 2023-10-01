extends Node2D

@onready var item_scene = preload("res://item.tscn")

@onready var leftLine = $ShipManager/LeftPort/Path2D/PathFollow2D
@onready var rightLine = $ShipManager/RightPort/Path2D/PathFollow2D
@onready var scoreLable = %Score
@onready var uiScreen = %UI
@onready var gameoverScreen = %GameOver


@onready var leftShip = null
@onready var rightShip = null

var leftShipTaken = false
var rightShipTaken = false

var newShip = null

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if GameManager.shipTooEmpty == true:
		gameOver()
	
	if GameManager.item_held:
		var rightShip = get_node("ShipManager/RightPort/Path2D/PathFollow2D/RightShip")
		var leftShip = get_node("ShipManager/LeftPort/Path2D/PathFollow2D/LeftShip")
		#print("Right Ship: ", rightShip, " And left Ship: ", leftShip)
		if Input.is_action_just_pressed("mouse_rightclick"):
			rotate_item()
		
		if Input.is_action_just_pressed("mouse_leftclick"):
			if leftShip != null:
				if leftShip.rotateContainer.get_global_rect().has_point(get_global_mouse_position()):
					leftShip.place_item()
					GameManager.points += 5
					scoreLable.text = str(GameManager.points)
			
			if rightShip != null:
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
	if leftShip != null:
		leftShip.clear_grid()
	if rightShip != null:
		rightShip.clear_grid()

func _on_ship_manager_new_ship_has_spawned(newShip, shipLane):
	print("New Ship Registered: ", newShip, " on lane: ", shipLane)
	if shipLane == leftLine:
		#leftShip = newShip
		newShip.name = "LeftShip"
		var leftShip = get_node("ShipManager/LeftPort/Path2D/PathFollow2D/LeftShip")
		leftShipTaken = true
		print("Left Ship Taken: ", leftShip)
	else:
		#rightShip = newShip
		newShip.name = "RightShip"
		print("New ship name: ", newShip)
		var rightShip = get_node("ShipManager/RightPort/Path2D/PathFollow2D/RightShip")
		rightShipTaken = true
		print("Right Ship Taken: ", rightShip)
	

func gameOver():
	GameManager.item_held = null
	GameManager.ship_container = null
	GameManager.current_slot = null
	GameManager.can_place = false
	GameManager.speed = 0.05
	GameManager.points = 0
	GameManager.shipTooEmpty = false
	get_tree().paused = true
	
	uiScreen.visible = false
	gameoverScreen.visible = true



func _on_restart_button_pressed():
	get_tree().reload_current_scene()
