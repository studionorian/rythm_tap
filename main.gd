extends Node

@export var black_screen_manager:BlackScreenManager
@export var data_manager:DataManager
@export var scene_manager:SceneManager


func _ready() -> void:
	data_manager.load_data()
	await data_manager.on_load_data_ends
	
	scene_manager.stop_all_nodes()
	scene_manager.load_scene('logo')
	
	black_screen_manager.fade_out()
