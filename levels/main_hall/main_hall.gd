extends Node2D


func _ready() -> void:
	$Mhaf.is_player = true
	$Mhaf/Camera2D.enabled = true

	var cm = CanvasModulate.new()
	cm.color = Color.BLACK
	# add_child(cm)
	
	
