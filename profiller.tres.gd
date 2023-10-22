extends Node

var test_script := 1000000
var test2_script := 0
@onready var textedit = $TextEdit
@onready var silly_text = $RichTextLabel
var delta_array := []
var prev_times:={
	"script" : [],
	"function" : [],
	"autoload" : [],
	"project" : [],
	"staticvar" : []
}
@onready var list = $ItemList

var which_technique := 0

func average():
	var sum := 0.0
	for n in delta_array:
		sum += n
	return sum / delta_array.size()

func average_averages(which):
	var sum := 0.0
	for n in which:
		sum += n
	return sum / which.size()

func _ready():
	silly_text.hide()
	list.select(0,true)

func profile():
	var profile_init = Time.get_ticks_usec()
	match which_technique:
		0:
			for n in test_script:
				test2_script += 1
		1:
			var test_function := test_script
			var test2_function := 0
			for n in test_function:
				test2_function += 1
		2:
			for n in auto.test_auto:
				auto.test2_auto += 1
		3:
			for n in ProjectSettings.get_setting("global/test_project"):
				ProjectSettings.set_setting("global/test2_project",ProjectSettings.get_setting("global/test2_project")+1)
		4:
			for n in stat.test_static:
				stat.test2_static += 1
	var profile_end = Time.get_ticks_usec()
	var delta_wait = profile_end - profile_init
	delta_array.append(delta_wait)
	textedit.insert_line_at (textedit.get_line_count()-1,str(delta_wait))


func _on_link_button_button_down():
	textedit.clear()
	silly_text.show()
	await get_tree().process_frame
	await get_tree().process_frame 
	for n in 10:
		profile()
	textedit.insert_line_at (textedit.get_line_count()-1,"TEST END, AVERAGE TIME:")
	textedit.insert_line_at (textedit.get_line_count()-1,str(average()))
	match which_technique:
		0:
			prev_times["script"].append(average())
			get_node("%script_average").text = str(average_averages(prev_times["script"]))
		1:
			prev_times["function"].append(average())
			get_node("%function_average").text = str(average_averages(prev_times["function"]))
		2:
			prev_times["autoload"].append(average())
			get_node("%autoload_average").text = str(average_averages(prev_times["autoload"]))
		3:
			prev_times["project"].append(average())
			get_node("%project_average").text = str(average_averages(prev_times["project"]))
		4:
			prev_times["staticvar"].append(average())
			get_node("%staticvar_average").text = str(average_averages(prev_times["staticvar"]))
	delta_array.clear()
	silly_text.hide()


func _on_h_slider_value_changed(value):
	test_script = value
	ProjectSettings.set_setting("global/test_project",value)
	auto.test_auto = value

func _on_item_list_item_selected(index):
	which_technique = index

func save(content):
	var file = FileAccess.open("res://benchmarks_for_people.txt",FileAccess.WRITE)
#	file.store_string(JSON.stringify(content))
	file.store_string(content)
	file = null


func _on_export_button_down():
	var to_save = str(
		"Elvisish's Dumb Benchmarker", "\n",
		"###########################", "\n",
		"Script Average:", "\n",
		"\t", str(average_averages(prev_times["script"])), "\n",
		"Function Average:", "\n",
		 "\t", str(average_averages(prev_times["function"])), "\n",
		"Project Average:", "\n",
		"\t", str(average_averages(prev_times["autoload"])), "\n",
		"Autoload Average:", "\n",
		 "\t", str(average_averages(prev_times["autoload"])), "\n",
		"Static Var Average:", "\n",
		 "\t", str(average_averages(prev_times["staticvar"])),
		)
	save(to_save)
