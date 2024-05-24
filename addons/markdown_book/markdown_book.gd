@tool
extends HBoxContainer


const SummaryLines = preload("res://addons/markdown_book/summary_line_resource.gd")
const MarkdownTree = preload("res://addons/markdown_book/markdown_tree.gd")

@export var tree: MarkdownTree

var path_docs_folder: String


func _ready() -> void:
	var path_summary := path_docs_folder.path_join("SUMMARY.md")
	
	if not FileAccess.file_exists(path_summary):
		print("[Markdown Viewer] SUMMARY.md file does not exists, please use the same structure as mdBook (https://rust-lang.github.io/mdBook/index.html)")
		return
	
	var lines_resource := _parse_summary_file(path_summary)
	
	tree.create_from_summary(lines_resource)


func _parse_summary_file(path_summary: String) -> Array[SummaryLines]:
	const LINE_PREFIX := "- ["
	
	var summary_content := FileAccess.get_file_as_string(path_summary)
	var summary_lines := summary_content.split("\n")
	var lines_resource: Array[SummaryLines] = []
	var regex_name := RegEx.new()
	var regex_path := RegEx.new()
	
	regex_name.compile("(?<=\\[).*?(?=\\])")
	regex_path.compile("(?<=\\().*?(?=\\))")
	
	for line in summary_lines:
		var line_ressource := SummaryLines.new()
		
		if line.is_empty():
			continue
		
		if line.begins_with("#"):
			line_ressource.is_title = true
			line_ressource.name = line.trim_prefix("#").strip_edges()
		else:
			var page_idx := line.find(LINE_PREFIX) / 2
			
			if page_idx == -1:
				continue
			
			var line_name = regex_name.search(line)
			var line_path = regex_path.search(line)
			
			if not line_name or not line_path:
				continue
			
			line_ressource.is_title = false
			line_ressource.name = line_name.get_string()
			line_ressource.path = path_docs_folder.path_join(line_path.get_string())
			line_ressource.tab = page_idx
		
		lines_resource.append(line_ressource)
	
	return lines_resource














	# lines_resource.resize(summary_lines.count())
	
	# var idx = 0
	# tree.create_item() # create root
	
	# for line in summary_content.split("\n"):
	# 	if line.is_empty():
	# 		continue
	# 	elif line.begins_with("#"):
	# 		_create_tree_title(line)
	# 	else:
	# 		_create_tree_button(line, idx)
		
	# 	idx += 1


# func _create_tree_title(line: String) -> void:
# 	line = line.trim_prefix("#").strip_edges()
# 	current_title = tree.create_item()
# 	current_title.set_text(0, line)
# 	print(line)


# func _create_tree_button(line: String, idx: int) -> void:
# 	# if line.find("<!--") != -1:
# 	# 	print("[Markdown Viewer] Please do not use comments in the SUMMARY.md file \"<!-- --->\"")
	
# 	var start_char = line.find(LINE_PREFIX)
# 	var start_idx = start_char + LINE_PREFIX.length()
# 	var end_idx = line.find("]")
	
# 	if start_idx == -1 or end_idx == -1 or start_idx > end_idx:
# 		return
	
# 	line = line.substr(start_idx, end_idx - start_idx)
	
# 	if current_button == null:
# 		current_button = current_title
	
# 	var parent: TreeItem
	
# 	if start_char / 2 > 0 and idx > 0:
		
# 	else:
# 		parent = current_title
		
# 	# current_button if start_idx > current_button_idx else current_title
	
	
	
# 	current_button = tree.create_item(parent)
# 	current_button.set_text(0, line)
# 	current_button_idx = start_idx
