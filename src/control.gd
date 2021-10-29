extends HBoxContainer

signal on_control_left
signal on_control_right
signal on_control_up
signal on_control_down
signal on_control_cancel

const MaxDiag: float = 1.4

var _is_stopped: bool = false
var _touch_pos: Vector2 = Vector2.ZERO

onready var _timer: Timer = $SwipeTimer

func _ready():
    visible = OS.has_touchscreen_ui_hint() and (not Global.touchscreen_enabled)

func _input(event: InputEvent):
    if _is_stopped:
        if (event is InputEventKey) or (event is InputEventScreenTouch) or (event is InputEventMouseButton):
            quit()
        return

    if (event is InputEventKey):
        _input_key(event as InputEventKey)
    elif (Global.touchscreen_enabled and event is InputEventScreenTouch):
        _input_screen_touch(event as InputEventScreenTouch)


func _input_key(event: InputEventKey):
    if not event.is_pressed():
        return
    if event.is_action_pressed('ui_left'):
        emit_signal("on_control_left")
    elif event.is_action_pressed('ui_right'):
        emit_signal("on_control_right")
    elif event.is_action_pressed('ui_down'):
        emit_signal("on_control_down")
    elif event.is_action_pressed('ui_up'):
        emit_signal("on_control_up")
    elif event.is_action_pressed('ui_cancel'):
        emit_signal("on_control_cancel")


func _input_screen_touch(event: InputEventScreenTouch):
    if event.is_pressed():
        _touch_pos = event.position
        _timer.start()
    elif not _timer.is_stopped():
        _timer.stop()
        var dir: Vector2 = (event.position - _touch_pos).normalized()
        var absx := abs(dir.x)
        var absy := abs(dir.y)
        if absx + absy >= MaxDiag:
            return
        if absx > absy:
            if dir.x < 0:
                emit_signal("on_control_left")
            else:
                emit_signal("on_control_right")
        elif absy > absx:
            if dir.y > 0:
                emit_signal("on_control_down")
            else:
                emit_signal("on_control_up")


func stop():
    _is_stopped = true

func quit():
    queue_free()
    var err := get_tree().change_scene("res://src/main.tscn")
    if err != OK:
        printerr("change_scene", "res://src/main.tscn", err)


func _on_LeftButton_pressed():
    emit_signal("on_control_left")


func _on_RightButton_pressed():
    emit_signal("on_control_right")


func _on_DownButton_pressed():
    emit_signal("on_control_down")


func _on_UpButton_pressed():
    emit_signal("on_control_up")

