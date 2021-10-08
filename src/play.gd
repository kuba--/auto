class_name Play
extends Control


# play_timeout is the number of seconds, we gonna play.
export(int) var timeout = 45

onready var _timer: Timer = $Timer

# UI
onready var _timer_label: Label = $CanvasLayer/TimerContainer/TimerLabel
onready var _score_label: Label = $CanvasLayer/ScoreContainer/ScoreLabel
onready var _control: HBoxContainer = $CanvasLayer/Control

# Merged scenes
onready var _city: City = $City
onready var _auto: Auto = $Auto


func _ready():
    _auto.map_to_world = funcref(_city, "map_to_world")
    _auto.can_move = funcref(_city, "has_tile")
    _auto.position = _city.map_to_world(Vector2.ZERO)
    Global.play_score = 0
    _score_label.text = str(Global.play_score)
    _timer_label.text = str(timeout)
    _timer.start(-1)


func _on_Control_left():
    _auto.turn_left()
    _auto.start()

func _on_Control_right():
    _auto.turn_right()
    _auto.start()

func _on_Control_down():
    _auto.turn_u()
    _auto.start()

func _on_Control_up():
    _auto.start()

func _on_Control_cancel():
    _auto.stop()


func _on_City_tile_set(_pos: Vector2, _idx: int):
    Global.play_score += 1
    _score_label.text = str(Global.play_score)


func _on_Timer_timeout():
    var t := int(_timer_label.text) - 1
    _timer_label.text = str(t)
    if t == 0:
        stop()
        _timer_label.set("custom_colors/font_color",Color.lightcoral)
        _score_label.set("custom_colors/font_color",Color.lightsteelblue)
        if Global.play_best_score < Global.play_score:
            Global.play_best_score = Global.play_score
            Global.play_best_auto_icon = Global.auto_icon


func stop() -> void:
    _auto.stop()
    _control.stop()
    _timer.stop()


func quit() -> void:
    queue_free()
    var err := get_tree().change_scene("res://src/main.tscn")
    if err != OK:
        printerr("change_scene", "res://src/main.tscn", err)
