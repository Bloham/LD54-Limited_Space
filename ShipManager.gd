extends Node

var ship0resource = preload("res://Ships/ship2-8.tscn")
var ship1resource = preload("res://Ships/ship4-24.tscn")

@onready var rightPath = $"RightPort/Path2D"
@onready var rightPathFollow = $"RightPort/Path2D/PathFollow2D"
@onready var leftPath = $"LeftPort/Path2D"
@onready var leftPathFollow =  $"LeftPort/Path2D/PathFollow2D"
@onready var leftPortTimer = $LeftPort/Path2D/PathFollow2D/Timer
@onready var rightPortTimer = $RightPort/Path2D/PathFollow2D/Timer

var leftLineTaken = false
var rightLineTaken = false
var ship0counter = 0
var ship1counter = 0 

var newShip = null
var shipLane = null
var leftShip = null
var rightShip = null

var rightShipInPort = false
var leftShipInPort = false
var rightShipDropedCargo = false
var leftShipDropedCargo = false
var leftDestyedShip = false
var rightDestyedShip = false

var rightSpeed = 0.03
var leftSpeed = 0.03

#test
#var children = null

@export var shipSpeedVariableMin = 0.03
@export var shipSpeedVariableMax = 0.15
@export var rightHabourTime = 10
@export var leftHabourTime = 10
@export var rightHanborStoppingPoint = 0.5
@export var leftHanborStoppingPoint = 0.5

signal newShipHasSpawned(newShip, shipLane)

# Called when the node enters the scene tree for the first time.
func _ready():
	leftPortTimer.wait_time = leftHabourTime
	rightPortTimer.wait_time = rightHabourTime


func _process(delta):
	moveShip(delta)


func moveShip(delta):
	if rightPathFollow.progress_ratio <= rightHanborStoppingPoint && rightLineTaken == true:
		rightPathFollow.progress_ratio += rightSpeed * delta
	if rightPathFollow.progress_ratio >= rightHanborStoppingPoint:
		if rightShipInPort == false:
			rightShipInPort = true
			rightPortTimer.start()
			print("Schiff im Hafen!")
			rightShip = get_node("RightPort/Path2D/PathFollow2D/RightShip")
		if rightShipDropedCargo == true:
			rightPathFollow.progress_ratio += rightSpeed * delta
	if rightPathFollow.progress_ratio >= 0.8:
		if get_node("RightPort/Path2D/PathFollow2D/RightShip") != null:
			if rightDestyedShip == false:
				rightShip.selfDestruction()
				print("QUE FREE SHIP left")
				rightDestyedShip = true
	if rightPathFollow.progress_ratio >= 0.9:
		rightPathFollow.progress_ratio = 0
		rightShipInPort = false
		rightLineTaken = false
		rightShipDropedCargo = false
		rightSpeed = randf_range(shipSpeedVariableMin, shipSpeedVariableMax)
		newShipSpawn()
		rightDestyedShip = false
	
	if leftPathFollow.progress_ratio <= leftHanborStoppingPoint && leftLineTaken == true:
		leftPathFollow.progress_ratio += leftSpeed * delta
	if leftPathFollow.progress_ratio >= leftHanborStoppingPoint:
		if leftShipInPort == false:
			leftShipInPort = true
			leftPortTimer.start()
			print("Schiff im Hafen!")
			leftShip = get_node("LeftPort/Path2D/PathFollow2D/LeftShip")
		if leftShipDropedCargo == true:
			leftPathFollow.progress_ratio += leftSpeed * delta
	if leftPathFollow.progress_ratio >= 0.8:
		if get_node("LeftPort/Path2D/PathFollow2D/LeftShip") != null:
			if leftDestyedShip == false:
				leftShip.selfDestruction()
				print("QUE FREE SHIP left")
				leftDestyedShip = true
	if leftPathFollow.progress_ratio >= 0.9:
		leftPathFollow.progress_ratio = 0
		leftShipInPort = false
		leftLineTaken = false
		leftShipDropedCargo = false
		leftSpeed = randf_range(shipSpeedVariableMin, shipSpeedVariableMax)
		newShipSpawn()
		leftDestyedShip = false


func _on_right_port_timer_timeout():
	rightShipDropedCargo = true
	
func _on_left_port_timer_timeout():
	leftShipDropedCargo = true

func move_node(node, new_parent): # node - the node that you want to move, new_parent - where you want to move the node
	node.get_parent().remove_child(node) # Get node's parent and remove node from it    
	new_parent.add_child(node) # Add node to new parent as a child   

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
	
	elif rightLineTaken == false:
		rightLineTaken = true
		shipLane = rightPathFollow
	
	else:
		return
	
	print ("Ship Lane: ", shipLane)
	spawnShip(newShip, shipLane)


func spawnShip(newShip, shipLane):
	var newShipInstance = newShip.instantiate()
	if shipLane == leftPathFollow:
		newShipInstance.name = "LeftShip"
	
	if shipLane == rightPathFollow:
		newShipInstance.name = "RightShip"
	
	shipLane.add_child(newShipInstance)
	emit_signal("newShipHasSpawned", newShipInstance, shipLane)



func _on_inital_spawner_timeout():
	newShipSpawn()
