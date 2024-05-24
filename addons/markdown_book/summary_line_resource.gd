extends Resource


var is_title: bool
var name: String
var path: String
var tab: int
var instance: TreeItem


func _to_string() -> String:
	return "{ is_title: %s, name: %s, path: %s, tab: %s, instance: %s }" % [is_title, name, path, tab, instance]
