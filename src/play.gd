class_name Play
extends Control


# play_timeout is the number of seconds, we gonna play.
export(int) var timeout = 45

onready var _timer: Timer = $Timer

# UI
onready var _timer_label: Label = $CanvasLayer/TimerContainer/TimerLabel
onready var _score_label: Label = $CanvasLayer/ScoreContainer/ScoreLabel
onready var _control: HBoxContainer = $CanvasLayer/ControlContainer

# Merged scenes
onready var _city: City = $City
onready var _auto: Auto = $Auto


func _ready():
    _control.visible = OS.has_touchscreen_ui_hint()
    
    _auto.map_to_world = funcref(_city, "map_to_world")
    _auto.can_move = funcref(_city, "has_tile")
    _auto.position = _city.map_to_world(Vector2.ZERO)
    Global.play_score = 0
    _score_label.text = str(Global.play_score)
    _timer_label.text = str(timeout)
    _timer.start(-1)


func _input(event: InputEvent):
    if (not event is InputEventKey) or (not event.is_pressed()):
        return
    if event.is_action_pressed('ui_left'):
        _auto.turn_left()
    elif event.is_action_pressed('ui_right'):
        _auto.turn_right()
    elif event.is_action_pressed('ui_down'):
        _auto.turn_u()
    elif event.is_action_pressed('ui_up'):
        pass
    elif event.is_action_pressed('ui_cancel'):
        _auto.stop()
        return
    _auto.start()


func _on_LeftButton_pressed():
    _auto.turn_left()
    _auto.start()

func _on_RightButton_pressed():
    _auto.turn_right()
    _auto.start()

func _on_DownButton_pressed():
    _auto.turn_u()
    _auto.start()

func _on_UpButton_pressed():
    _auto.start()


func _on_City_tile_set(_pos: Vector2, _idx: int):
    Global.play_score += 1
    _score_label.text = str(Global.play_score)


func _on_Timer_timeout():
    var t := int(_timer_label.text) - 1
    _timer_label.text = str(t)
    if t == 0:
        stop_and_quit()


func stop_and_quit() -> void:
    _timer.stop()
    _auto.stop()
    queue_free()
    assert(get_tree().change_scene("res://src/main.tscn") == OK)
