class_name Play
extends Control

# Play timeout stands for number of seconds, we gonna play.
export(int) var timeout    = 45
export(int) var interval   = 10
export(int) var extra_time = 5

var _heart_interval: int = interval

onready var _timer: Timer = $Timer

# UI
onready var _timer_label: Label = $CanvasLayer/TimerContainer/TimerLabel
onready var _score_label: Label = $CanvasLayer/ScoreContainer/ScoreLabel
onready var _control: HBoxContainer = $CanvasLayer/Control

# Merged scenes
onready var _city: City = $City
onready var _auto: Auto = $Auto

func _ready():
    Global.play_score = 0
    _score_label.text = str(Global.play_score)
    _timer_label.text = str(timeout)
    _timer.set_paused(true)
    _timer.start(-1.0)
    _auto.map_to_world = funcref(_city, "map_to_world")
    _auto.can_move = funcref(_city, "has_road")
    _auto.position = _city.map_to_world(Vector2.ZERO, _auto.OFFSET)

func _on_Control_left():
    _timer.set_paused(false)
    _auto.turn_left()
    _auto.start()

func _on_Control_right():
    _timer.set_paused(false)
    _auto.turn_right()
    _auto.start()

func _on_Control_down():
    _timer.set_paused(false)
    _auto.turn_u()
    _auto.start()

func _on_Control_up():
    _timer.set_paused(false)
    _auto.start()

func _on_Control_cancel():
    _auto.stop()
    _timer.set_paused(true)

func _on_Control_quit():
    queue_free()
    var err := get_tree().change_scene("res://src/main.tscn")
    if err != OK:
        printerr("change_scene", "res://src/main.tscn", err)

func _on_City_tile_set(_pos: Vector2, _idx: int):
    Global.play_score += 1
    _score_label.text = str(Global.play_score)

func _on_Auto_move(map_pos: Vector2):
    if _city.delete_heart(map_pos):
        var t: int = int(_timer_label.text) + extra_time
        _timer_label.text = str(t)

func _on_Timer_timeout():
    var t: int = int(_timer_label.text) - 1
    _timer_label.text = str(t)
    if (t == 0) or (not _city.has_exits()):
        stop()
        return
    _heart_interval -= 1
    if _heart_interval == 0:
        _heart_interval = interval
        _city.add_heart([_auto.map_position()])

func stop():
    _auto.stop()
    _auto.disconnect("on_move", self, "_on_Auto_move")
    _control.stop()
    _timer.stop()
    _city.disconnect("tile_set", self, "_on_City_tile_set")
    _timer_label.set("custom_colors/font_color",Color.lightcoral)
    _score_label.set("custom_colors/font_color",Color.lightsteelblue)
    if Global.play_best_score < Global.play_score:
        Global.play_best_score = Global.play_score
        Global.play_best_auto_icon = Global.auto_icon
