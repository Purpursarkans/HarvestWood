extends StaticBody3D

@onready var player = %Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func leftClick():
	%CampfireStaticBody3D.process_mode = Node.PROCESS_MODE_INHERIT
	player.global_position = %StartPosition.global_position
	
