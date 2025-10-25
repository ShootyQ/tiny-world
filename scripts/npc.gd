extends Area2D

@export var npc_id := "npc_mira"
@export var npc_name := "Mira"
@export var personality := {"friendliness": 0.7, "curiosity": 0.5, "confidence": 0.8}
@export var liking := 0.5   # 0..1

var is_player_nearby := false
var talking := false

@onready var dialogue_box := get_tree().get_first_node_in_group("dialogue_box")
@onready var dm: Node = get_node_or_null("/root/DialogueManager")

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))
	connect("body_exited", Callable(self, "_on_body_exited"))

func _on_body_entered(body):
	if body is CharacterBody2D:
		is_player_nearby = true
		print("%s: player entered. Starting convo if idle." % npc_name)
		_start_convo_if_idle()

func _on_body_exited(body):
	if body is CharacterBody2D:
		is_player_nearby = false
		talking = false
		remove_from_group("talking_npc")
		if dialogue_box:
			dialogue_box.call("clear")

func _start_convo_if_idle():
	if talking or not dialogue_box:
		return
	talking = true
	add_to_group("talking_npc")
	print("%s: conversation started." % npc_name)
	var greeting: String = ""
	if dm and dm.has_method("get_reply"):
		greeting = dm.call("get_reply", npc_id, npc_name, personality, liking, "")
	dialogue_box.call("show_exchange", npc_name, greeting)

# Call this when the player submits text input.
func player_spoke(player_msg: String) -> void:
	if not talking or not dialogue_box:
		return
	# Simple liking tweak: kindness raises liking, rudeness lowers.
	if player_msg.matchn("*thank*") or player_msg.matchn("*help*"):
		liking = clamp(liking + 0.05, 0.0, 1.0)
	if player_msg.matchn("*stupid*") or player_msg.matchn("*hate*"):
		liking = clamp(liking - 0.08, 0.0, 1.0)

	var reply: String = ""
	if dm and dm.has_method("get_reply"):
		reply = dm.call("get_reply", npc_id, npc_name, personality, liking, player_msg)
	dialogue_box.call("show_exchange", npc_name, reply)
