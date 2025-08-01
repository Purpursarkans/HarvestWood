extends Node3D


@onready
var player = %Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var target_position = Vector3(player.global_transform.origin.x, global_transform.origin.y, player.global_transform.origin.z)
	look_at(target_position)
