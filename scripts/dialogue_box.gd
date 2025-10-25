extends Control
@onready var label: Label = %Label
@onready var input: LineEdit = %Input
@onready var send_btn: Button = %Send

func _ready():
	visible = false
	if input:
		input.connect("text_submitted", Callable(self, "_on_input_submitted"))
	if send_btn:
		send_btn.connect("pressed", Callable(self, "_on_send_pressed"))

func say(text: String) -> void:
	if not label:
		return
	label.text = text
	visible = true

func show_exchange(npc_name: String, npc_line: String) -> void:
	say("%s: %s" % [npc_name, npc_line])

func clear() -> void:
	if not label:
		return
	label.text = ""
	visible = false

func _on_input_submitted(text: String) -> void:
	# Forward the player's line to the current talking NPC (if any)
	var npc := get_tree().get_first_node_in_group("talking_npc")
	if npc:
		npc.call("player_spoke", text)
	if input:
		input.clear()
		# Return control back to gameplay after sending
		get_viewport().gui_release_focus()

func _unhandled_input(event: InputEvent) -> void:
	if not visible:
		return
	if event is InputEventKey and event.pressed and not event.echo:
		var key: int = event.keycode
		if input and not input.has_focus() and (key == KEY_ENTER or key == KEY_KP_ENTER):
			input.grab_focus()
			input.caret_column = input.text.length()
			get_viewport().set_input_as_handled()
		elif input and input.has_focus() and key == KEY_ESCAPE:
			get_viewport().gui_release_focus()
			get_viewport().set_input_as_handled()

func _on_send_pressed() -> void:
	if input:
		_on_input_submitted(input.text)
