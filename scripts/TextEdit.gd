extends TextEdit

const MAX_LINES = 27
const MAX_COLUMNS = 126

func _init():
	for l in range(MAX_LINES):
		var space_string = ""
		for c in range(MAX_COLUMNS):
			space_string += "0"
		insert_line_at(l, space_string)
	

func _on_text_changed():
	for i in range(get_line_count()):
		print("line " + str(i) + ": " + get_line(i))
		if get_line(i).length() > MAX_COLUMNS:
			set_line(i, get_line(i).substr(0, MAX_COLUMNS))
		
