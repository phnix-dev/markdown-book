@tool
extends EditorPlugin


const ADDON_PATH := "addons/markdown_book/"
const ADDON_NAME := "Docs"
const PANEL_DOCS = preload("res://addons/markdown_book/markdown_book.tscn")
const PANEL_ICON = preload("res://addons/markdown_book/icon.svg")

var plugin_path_docs := ADDON_PATH.path_join("docs_folder")
var main_panel_instance


func _enter_tree() -> void:
	# return
	if not ProjectSettings.has_setting(plugin_path_docs):
		ProjectSettings.set_setting(plugin_path_docs, "")
		
		var property_info := {
			"name": plugin_path_docs,
			"type": TYPE_STRING,
			"hint": PROPERTY_HINT_DIR,
		}
		
		ProjectSettings.add_property_info(property_info)
		print("[Markdown Viewer] Set the path of the documentation folder in the Advanced Project Settings: \"%s\" and restart the plugin" % plugin_path_docs)
		return
	
	var path_docs_folder = ProjectSettings.get_setting(plugin_path_docs)
	
	if path_docs_folder.is_empty():
		print("[Markdown Viewer] Set the path of the documentation folder is empty please set it in the Advanced Project Settings: \"%s\" and restart the plugin" % plugin_path_docs)
	
	main_panel_instance = PANEL_DOCS.instantiate()
	main_panel_instance.get_node("%MarkdownViewer").path_docs_folder = path_docs_folder
	
	EditorInterface.get_editor_main_screen().add_child.call_deferred(main_panel_instance)
	_make_visible(false)


func _exit_tree() -> void:
	if main_panel_instance:
		main_panel_instance.queue_free()


func _has_main_screen():
	return true


func _make_visible(visible):
	if main_panel_instance:
		main_panel_instance.visible = visible


func _get_plugin_name():
	return ADDON_NAME


func _get_plugin_icon():
	return PANEL_ICON
