extends StaticBody3D

var startTimer
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	startTimer = Time.get_ticks_msec()
	pass # Replace with function body.
	campfire_progress_bar.play("FuelLoad")

@export var maxFuel : float = 1000
@export var burn : float = 50
@export var grownRate = 0.5
@export var logPercent : float = 10

@onready var campfire_progress_bar: AnimationPlayer = %CampfireProgressBar

var fuel = maxFuel
var onePercent = maxFuel/100
@onready var animLeght = campfire_progress_bar.get_animation("FuelLoad").length
func _process(delta: float) -> void:
	if fuel > 0:
		fuel -= burn * delta
		var fuelPersent = fuel / maxFuel 
		var frame = animLeght * fuelPersent 
		campfire_progress_bar.seek(frame,true)
		burn += grownRate * delta
	if fuel <= 0:
		var endTimer: int = Time.get_ticks_msec()
		var totalTime: int = endTimer - startTimer
		var totalSec : float = float(totalTime) / 1000.0
		var totalMinut: float = totalSec / 60.0
		%Time.text = "you time: " + str(int(totalSec)) + " sec"
		%Time2.text = "you time: " + str(int(totalSec)) + " sec"
		player.global_position = %GameOverPosition.global_position
		player.haveLog = false
		player.get_node("WoodLog").hide()
		process_mode = Node.PROCESS_MODE_DISABLED

@onready var player = %Player

func leftClick():
	if player.haveLog:
		fuel+=onePercent*logPercent
		#print_debug("campfire")
		player.haveLog = false
		player.get_node("WoodLog").hide()
