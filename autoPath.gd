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
	if self.progress_ratio <= hanborStoppingPoint:
		self.progress_ratio += GameManager.speed * delta
	if cargoHasExchanged == true:
		self.progress_ratio += GameManager.speed * delta
	if shipAtHabour == true:
		return
	if shipAtHabour == false:
		shipAtHabour = true
		timer.start()
		print("Schiff im Hafen!")
		

func _on_timer_timeout():
	shipAtHabour = false
	cargoHasExchanged = true
	print("Die reise geht weiter")
