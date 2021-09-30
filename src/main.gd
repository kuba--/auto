class_name Main
extends MarginContainer

onready var _box: HBoxContainer = $VBoxContainer/HBoxContainer
onready var _score_label: Label = $VBoxContainer/HBoxContainer/ScoreLabel

func _ready():
    _box.visible = Global.play_score != 0
    if _box.visible:
        _score_label.text = str(Global.play_score)


func play(res: String) -> int:
    Global.auto_sprite = res
    return get_tree().change_scene("res://src/play.tscn")


func _on_TaxiButton_pressed():
    assert(play("res://src/taxi.tres") == OK)


func _on_TruckButton_pressed():
    assert(play("res://src/truck.tres") == OK)


func _on_PoliceButton_pressed():
    assert(play("res://src/police.tres") == OK)


func _on_AmbulanceButton_pressed():
    assert(play("res://src/ambulance.tres") == OK)


func _on_CivilButton_pressed():
    assert(play("res://src/civil.tres") == OK)


func _on_GarbageButton_pressed():
    assert(play("res://src/garbage.tres") == OK)
