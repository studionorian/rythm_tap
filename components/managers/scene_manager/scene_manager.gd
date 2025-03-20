class_name SceneManager
extends Node

@export var _scenes_parent:Node

var scenes:Dictionary[String,Node]
var current_scene:String


func _ready() -> void:
	for node in _scenes_parent.get_children():
		scenes[node.name.to_lower()] = node


func stop_all_nodes() -> void:
	for node in scenes:
		print(node)


func load_scene(scene_name:String) -> void:
	if not current_scene.is_empty():
		_stop_node(scenes[current_scene])
	
	_start_node(scenes[scene_name])
	current_scene = scene_name


func _stop_node(node:Node) -> void:
	node.set_process(false)
	node.set_physics_process(false)
	node.hide()
	_scenes_parent.remove_child(node)


func _start_node(node:Node) -> void:
	_scenes_parent.add_child(node)
	node.set_process(true)
	node.set_physics_process(true)
	node.show()
