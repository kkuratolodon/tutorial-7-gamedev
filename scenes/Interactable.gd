extends Node

class_name Interactable

@export var item_name: String = "Item"
@export var item_description: String = "An interactable item"
@export var can_be_picked_up: bool = false

func interact():
    pass

func can_pickup() -> bool:
    return can_be_picked_up

func pickup(player):
    if can_pickup():
        player.add_item(self)
        return true
    return false