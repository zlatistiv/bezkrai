extends Camera2D

@export var scale_factor = 1.5

func _ready() -> void:
	self.zoom = Vector2(scale_factor, scale_factor)   # 3× in
