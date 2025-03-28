extends Panel

var item_name: String
var item_description: String
var item_instance = null
var item_index: int = -1
var player = null

func setup(name: String, description: String, instance, index: int = -1, player_ref = null):
    item_name = name
    item_description = description
    item_instance = instance
    item_index = index
    player = player_ref
    
    $MarginContainer/VBoxContainer/NameLabel.text = name
    $MarginContainer/VBoxContainer/DescriptionLabel.text = description
    
    var min_height = $MarginContainer/VBoxContainer.get_minimum_size().y + 5
    custom_minimum_size.y = min_height

func _on_use_button_pressed():
    if item_instance:
        item_instance.interact()
        
        if player and item_instance.get("one_time_use") == true:
            player.remove_inventory_item(item_index)
            var inventory_ui = get_parent().get_parent().get_parent().get_parent().get_parent()
            inventory_ui.update_inventory()