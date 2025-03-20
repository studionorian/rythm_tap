class_name DataManager
extends Node

@export var _path:String = 'user://data/'
@export var _extension:String = '.data'
@export var _max_files:int = 3
@export var _group_name:String = 'persist'

signal on_save_data_ends
signal on_load_data_ends


func save_data() -> void:
	_make_folder()
	
	var persist_nodes:Array[Node] = get_tree().get_nodes_in_group(_group_name)
	
	if persist_nodes.is_empty():
		return
	
	var unix_time:String = str(int(round(Time.get_unix_time_from_system())))
	var file:FileAccess = FileAccess.open_encrypted_with_pass(_path + unix_time + _extension, FileAccess.WRITE, OS.get_unique_id())
	var data:Array[Dictionary] = []
	var properties:Dictionary = {}
	
	for node in persist_nodes:
		properties['path'] = node.get_path()
		
		for property in node.get_property_list():
			properties[property.name] = node.get(property.name)
		
		data.append(properties)
	
	file.store_var(data)
	file.close()
	
	on_save_data_ends.emit()


func load_data(file_name:String = '') -> void:
	_make_folder()
	
	if not DirAccess.dir_exists_absolute(_path) or DirAccess.get_files_at(_path).is_empty():
		on_load_data_ends.emit()
		return
	
	if file_name.is_empty():
		file_name = get_save_file()
	
	var file:FileAccess = FileAccess.open_encrypted_with_pass(_path + file_name + _extension, FileAccess.READ, OS.get_unique_id())
	
	for node in file.get_var():
		var object = get_node(node.path)
		
		for key in node.keys():
			if key == 'path':
				continue
			
			object.set(key, node[key])
	
	on_load_data_ends.emit()


func get_save_file(file_position:int = -1) -> String:
	var dir:DirAccess = DirAccess.open(_path)
	var files:Array[int] = []
	
	dir.list_dir_begin()
	
	for file_name:String in dir.get_files():
		files.append(int(file_name.get_basename()))
	
	dir.list_dir_end()
	
	files.sort()
	var final_files = files.slice(-_max_files, files.size())
	
	for file:int in files:
		if file in final_files:
			continue
		
		DirAccess.remove_absolute(_path + str(file) + _extension)
	
	return str(final_files[file_position])


func _make_folder() -> void:
	if DirAccess.dir_exists_absolute(_path):
		return
	
	DirAccess.make_dir_absolute(_path)
