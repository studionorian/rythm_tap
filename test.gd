extends Node

func _ready() -> void:
	var tween:Tween = get_tree().create_tween()
	
	tween.tween_property(self, 'rotation', 360, 30)
