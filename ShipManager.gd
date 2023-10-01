extends Node

var ship0resource = preload("res://Ships/ship2-8.tscn")
var ship1resource = preload("res://Ships/ship4-24.tscn")

@onready var rightPath = $"RightPort/Path2D"
@onready var rightPathFollow = $"RightPort/Path2D/PathFollow2D"
@onready var leftPath = $"LeftPort/Path2D"
@onready var leftPathFollow =  $"LeftPort/Path2D/PathFollow2D"
@onready var leftPortTimer = $LeftPort/Timer
@onready var rightPortTimer = $RightPort/Timer

var leftLineTaken = false
var rightLineTaken = false
var ship0counter = 0
var ship1counter = 0 

var newShip = null
var shipLane = null

signal newShipHasSpawned(newShip, shipLane)

# Called when the node enters the scene tree for the first time.
func _ready():
	newShipSpawn()
	pass # Replace with function body.


func newShipSpawn():
	print("Spawning new Ship")
	if ship0counter >= ship1counter:
		newShip = ship1resource
		ship1counter += 1
	else:
		newShip = ship0resource
		ship0counter += 1
	
	print("Ship Counter 0: ", ship0counter, " Ship Counter 1: ", ship1counter)
	
	if leftLineTaken == false:
		leftLineTaken = true
		shipLane = leftPathFollow
	
	if rightLineTaken == false:
		rightLineTaken = true
		shipLane = rightPathFollow
	
	print ("Ship Lane: ", shipLane)
	spawnShip(newShip, shipLane)


func spawnShip(newShip, shipLane):
	var newShipInstance = newShip.instantiate()
	shipLane.add_child(newShipInstance)
	emit_signal("newShipHasSpawned", newShipInstance, shipLane)
