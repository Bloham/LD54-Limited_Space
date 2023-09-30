extends Node2D

@onready var ship0 = $"Path2D4-24/PathFollow2D4-24/Ship4-24"
@onready var ship1 = $"Path2D2-8/PathFollow2D2-8/Ship2-8"
@onready var item_scene = preload("res://item.tscn")
@onready var pathShip0 = $"Path2D4-24/PathFollow2D4-24"


# Called when the node enters the scene tree for the first time.
func _ready():
	#spawnShip(ship0)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if GameManager.item_held:
		if Input.is_action_just_pressed("mouse_rightclick"):
			if ship0.rotateContainer.get_global_rect().has_point(get_global_mouse_position()) or ship1.rotateContainer.get_global_rect().has_point(get_global_mouse_position()):
				rotate_item()
		
		if Input.is_action_just_pressed("mouse_leftclick"):
			if ship0.rotateContainer.get_global_rect().has_point(get_global_mouse_position()):
				ship0.place_item()
			
			if ship1.rotateContainer.get_global_rect().has_point(get_global_mouse_position()):
				ship1.place_item()


func _on_button_spawn_pressed() -> void:
	var new_item = item_scene.instantiate()
	add_child(new_item)
	# randi_range is for the amount of items we have.
	new_item.load_item(randi_range(1,4))
	new_item.selected = true
	GameManager.item_held = new_item

func rotate_item():
	GameManager.item_held.rotate_item()
	ship0.clear_grid()
	ship1.clear_grid()

func spawnShip(shipType):
	pathShip0.progress_ratio = 0
	var new_ship = shipType.instantiate()
	pathShip0.add_child(new_ship)
