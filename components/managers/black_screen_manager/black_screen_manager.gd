class_name BlackScreenManager
extends Control

@onready var color_rect:ColorRect = $ColorRect

signal on_fade_in_start
signal on_fade_in_ends
signal on_fade_out_start
signal on_fade_out_ends


func _ready() -> void:
	color_rect.color = Color.BLACK


func fade_in() -> void:
	var tween:Tween = get_tree().create_tween()
	
	on_fade_in_start.emit()
	tween.tween_property(color_rect, 'color:a', 1.0, 0.5)
	tween.finished.connect(func(): on_fade_in_ends.emit())


func fade_out() -> void:
	var tween:Tween = get_tree().create_tween()
	
	on_fade_out_start.emit()
	tween.tween_property(color_rect, 'color:a', 0.0, 0.5)
	tween.finished.connect(func(): on_fade_out_ends.emit())
