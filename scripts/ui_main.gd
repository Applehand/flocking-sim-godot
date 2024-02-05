extends Control

signal start_game

@onready var label = $ScoreContainer/Label
@onready var start_button_container = $StartButtonContainer
@onready var countdown_label_container = $CountdownLabelContainer
@onready var countdown_label = $CountdownLabelContainer/Label
@onready var audio_stream_player = $AudioStreamPlayer


func change_score(score):
	label.text = 'Boids Bopped: ' + str(score)


func _on_button_pressed():
	start_game.emit()
	audio_stream_player.play()
	start_button_container.visible = false
	countdown_label_container.visible = true

func change_countdown_text(text):
	countdown_label.text = str(text)


