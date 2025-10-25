extends Node2D

signal talk_requested

var player_in_range := false

func _ready() -> void:
    $Area2D.body_entered.connect(_on_body_entered)
    $Area2D.body_exited.connect(_on_body_exited)

func _on_body_entered(body):
    if body.name == "Player":
        player_in_range = true

func _on_body_exited(body):
    if body.name == "Player":
        player_in_range = false

func _process(delta):
    if player_in_range and Input.is_action_just_pressed("interact"):
        emit_signal("talk_requested")
