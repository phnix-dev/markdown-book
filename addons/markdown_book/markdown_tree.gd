@tool
extends Tree


const ICON = preload("res://addons/markdown_book/icon.svg")

const MarkdownLabel = preload("res://addons/markdownlabel/markdownlabel.gd")
const SummaryLines = preload("res://addons/markdown_book/summary_line_resource.gd")

@export var rich_text: MarkdownLabel

var lines_resource: Array[SummaryLines]


func _ready() -> void:
	item_selected.connect(_on_item_selected)


func create_from_summary(lines_resource: Array[SummaryLines]) -> void:
	var current_title: TreeItem
	var is_first: bool = true
	
	for i in lines_resource.size():
		var line = lines_resource[i]
		var item: TreeItem
		var parent
		
		if not line.is_title:
			if line.tab == 0:
				parent = current_title
			else:
				for y in range(i, 0, -1):
					var rline = lines_resource[y]
					
					if rline.tab < line.tab:
						parent = rline.instance
						break
		
		item = create_item(parent)
		item.set_text(0, line.name)
		line.instance = item
		
		if line.is_title:
			current_title = item
		elif is_first:
			is_first = false
			item.select(0)
			
			if FileAccess.file_exists(line.path):
				rich_text.markdown_text = FileAccess.get_file_as_string(line.path)
	
	self.lines_resource = lines_resource


func _on_item_selected() -> void:
	for line in lines_resource:
		if line.instance.is_selected(0) and not line.path.is_empty():
			if not FileAccess.file_exists(line.path):
				# print("[Markdown Viewer] %s file \"%s\" does not exists" % [line.name, line.path])
				break
			
			rich_text.markdown_text = FileAccess.get_file_as_string(line.path)
			break
