extends Node

# Per-NPC rolling history (trimmed)
var history := {}  # { npc_id: [ {role, content}, ... ] }

# Tunables
const MAX_HISTORY := 10

func _ensure(npc_id: String) -> void:
	if not history.has(npc_id):
		history[npc_id] = []

func add_turn(npc_id: String, role: String, content: String) -> void:
	_ensure(npc_id)
	history[npc_id].append({ "role": role, "content": content })
	if history[npc_id].size() > MAX_HISTORY:
		history[npc_id] = history[npc_id].slice(-MAX_HISTORY, MAX_HISTORY)

func clear(npc_id: String) -> void:
	history.erase(npc_id)

func build_system_prompt(npc_name: String, personality: Dictionary, liking: float) -> String:
	return \
"""You are %s, an NPC in a cozy fantasy town.
Speak in short, readable lines (1–2 sentences).
Traits (0–1): friendliness %0.2f, curiosity %0.2f, confidence %0.2f.
Your current liking of the player is %0.2f (0 dislike, 1 adore).
Be consistent with your traits; adjust tone with liking.
Avoid breaking the fourth wall; you are in-world.""" % [
		npc_name,
		personality.get("friendliness", 0.5),
		personality.get("curiosity", 0.5),
		personality.get("confidence", 0.5),
		clamp(liking, 0.0, 1.0)
	]

# ---- RESPONSE HOOK ----
# For now, a local stub that "feels" different by liking/traits.
# Later, replace with an HTTP call to your LLM and return its text.
func generate_reply_stub(_npc_name: String, personality: Dictionary, liking: float, player_msg: String) -> String:
	var friendly := float(personality.get("friendliness", 0.5))
	var curious  := float(personality.get("curiosity", 0.5))
	var conf     := float(personality.get("confidence", 0.5))
	var tone := ""
	if liking > 0.75:
		tone = ["✨","😊","🙂"][int(round((conf*2.0)))]
	elif liking < 0.25:
		tone = ["…","😐","🙄"][int(round((1.0-conf)*2.0))]
	else:
		tone = ""

	var opens := []
	if friendly > 0.6:
		opens = ["Hey there!", "Good to see you.", "Hi again!"]
	elif friendly < 0.3:
		opens = ["What is it?", "Mm.", "You need something?"]
	else:
		opens = ["Hello.", "Hi.", "Yes?"]

	var follow := ""
	if player_msg.strip_edges() == "":
		follow = "What brings you here?" if curious > 0.6 else "Need something?"
	else:
		follow = "Interesting… tell me more." if curious > 0.6 else "Noted."

	return "%s %s %s" % [opens[randi()%opens.size()], follow, tone]

func get_reply(npc_id: String, npc_name: String, personality: Dictionary, liking: float, player_msg: String) -> String:
	_ensure(npc_id)
	# If/when you wire an LLM: compile messages = [system, history..., user], call API, return text.
	var reply := generate_reply_stub(npc_name, personality, liking, player_msg)
	add_turn(npc_id, "user", player_msg)
	add_turn(npc_id, "assistant", reply)
	return reply
