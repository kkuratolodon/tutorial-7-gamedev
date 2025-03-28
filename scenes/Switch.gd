extends Interactable

@export var light : NodePath
@export var on_by_default = true
@export var energy_when_on = 10
@export var energy_when_off = 3

@onready var light_node : Light3D = get_node(light)
@onready var anim = get_node("AnimationPlayer")
var on = on_by_default

func _ready():
    light_node.light_energy = energy_when_on if on else energy_when_off
    print(anim)

func interact():
    on = !on
    if on:
        anim.play("Pressed")
    else:
        anim.play("Not Pressed")
    light_node.light_energy = energy_when_on if on else energy_when_off
