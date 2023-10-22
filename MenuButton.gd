extends MenuButton


# Called when the node enters the scene tree for the first time.
func _ready():
	get_popup().id_pressed.connect(_on_item_menu_pressed)

func _on_item_menu_pressed(id: int):
	match id:
		1:
			OS.shell_open("http://www.brilliancegames.com")
		3:
			OS.shell_open("http://www.spyonthewall.net")
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
