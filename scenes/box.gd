extends Interactable

@export var sceneName := "Level1"
@export var text : String

@onready var anim = get_node("AnimationPlayer")
@onready var label : Label3D = get_node("Label3D")

func _ready() -> void:
    label.text = text

func interact():
    get_tree().change_scene_to_file(str("res://scenes/" + sceneName + ".tscn"))
