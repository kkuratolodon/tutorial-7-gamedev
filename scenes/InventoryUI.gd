extends Control

var item_scene = preload("res://scenes/InventoryItem.tscn")
var player = null

func _ready():
    hide()

func set_player(p):
    player = p
    
func update_inventory():
    var item_container = $Panel/VBoxContainer/ScrollContainer/ItemList
    for child in item_container.get_children():
        child.queue_free()
    
    if player and player.inventory:
        for i in range(player.inventory.size()):
            var item_data = player.inventory[i]
            var item_ui = item_scene.instantiate()
            item_container.add_child(item_ui)
            
            item_ui.setup(
                item_data["name"], 
                item_data["description"], 
                item_data["instance"],
                i,
                player
            )
            item_ui.custom_minimum_size.y = 85 

func toggle():
    if visible:
        hide()
        Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
    else:
        Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
        update_inventory()
        show()

func _on_close_button_pressed():
    player.toggle_inventory()