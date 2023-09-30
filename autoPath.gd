extends PathFollow2D

@export var habourTime = 10
@export var hanborStoppingPoint = 0.5

@onready var timer = $Timer

var shipAtHabour = false
var cargoHasExchanged = false


# Called when the node enters the scene tree for the first time.
func _ready():
	timer.wait_time = habourTime


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if shipAtHabour == false:
		moveShip(delta)


func moveShip(delta):
	self.progress_ratio += GameManager.speed * delta
	if self.progress_ratio > hanborStoppingPoint && cargoHasExchanged == false:
		shipAtHabour = true
		timer.start()
		print("Habor Timer Ship 4-24 Started")


func _on_timer_timeout():
	shipAtHabour = false
	cargoHasExchanged = true
	timer.stop()
	print("die reise geht weiter")
