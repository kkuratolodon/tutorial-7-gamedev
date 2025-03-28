extends Interactable

@onready var anim = get_node("AnimationPlayer")

var level_object : Node3D

func _ready():
    level_object = get_tree().root.get_child(0)
    print(level_object)
    print(anim)

func interact():
    level_object.collect_item()
    queue_free()