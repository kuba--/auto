class_name Main
extends MarginContainer


onready var _box: HBoxContainer = $VBoxContainer/HBoxContainer
onready var _best_score_label: Label = $VBoxContainer/HBoxContainer/BestScoreContainer/BestScoreLabel
onready var _best_auto_icon: TextureRect = $VBoxContainer/HBoxContainer/BestScoreContainer/BestAutoIcon
onready var _score_label: Label = $VBoxContainer/HBoxContainer/ScoreContainer/ScoreLabel

onready var _taxi_button: TextureButton = $VBoxContainer/ButtonContainer/TaxiButton
onready var _truck_button: TextureButton = $VBoxContainer/ButtonContainer/TruckButton
onready var _police_button: TextureButton = $VBoxContainer/ButtonContainer/PoliceButton
onready var _ambulance_button: TextureButton = $VBoxContainer/ButtonContainer/AmbulanceButton
onready var _civil_button: TextureButton = $VBoxContainer/ButtonContainer/CivilButton
onready var _garbage_button: TextureButton = $VBoxContainer/ButtonContainer/GarbageButton

onready var _touch_button: TextureButton = $VBoxContainer/LogoContainer/TouchButton

func _ready():
    _touch_button.visible = OS.has_touchscreen_ui_hint()
    if !Global.touchscreen_enabled:
        var texture_normal := _touch_button.texture_normal
        _touch_button.texture_normal = _touch_button.texture_pressed
        _touch_button.texture_pressed = texture_normal
    
    _box.visible = Global.play_score != 0
    if _box.visible:
        _score_label.text = str(Global.play_score)
        _best_score_label.text = str(Global.play_best_score)

        _best_auto_icon.visible = Global.play_best_auto_icon != null
        if _best_auto_icon.visible:
            _best_auto_icon.texture = Global.play_best_auto_icon


func play(icon: Texture, res: String):
    Global.auto_icon = icon
    Global.auto_sprite = res
    var err := get_tree().change_scene("res://src/play.tscn")
    if err != OK:
        printerr("change_scene", "res://src/play.tscn", res, err)


func _on_TaxiButton_pressed():
    play(_taxi_button.texture_pressed, "res://src/taxi.tres")

func _on_TruckButton_pressed():
    play(_truck_button.texture_pressed, "res://src/truck.tres")

func _on_PoliceButton_pressed():
    play(_police_button.texture_pressed, "res://src/police.tres")

func _on_AmbulanceButton_pressed():
    play(_ambulance_button.texture_pressed, "res://src/ambulance.tres")

func _on_CivilButton_pressed():
    play(_civil_button.texture_pressed, "res://src/civil.tres")

func _on_GarbageButton_pressed():
    play(_garbage_button.texture_pressed, "res://src/garbage.tres")

func _on_TouchButton_pressed():
    Global.touchscreen_enabled = not Global.touchscreen_enabled
    var texture_normal := _touch_button.texture_normal
    _touch_button.texture_normal = _touch_button.texture_pressed
    _touch_button.texture_pressed = texture_normal

