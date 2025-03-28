extends Node3D

var items_collected := 0
var total_items := 4
var label: Label = null

@export var finish_light: OmniLight3D
@export var finish_trigger: Area3D
@export var light_energy_when_on := 10.0

func _ready() -> void:
    label = $CanvasLayer/Label
    
    if finish_light:
        finish_light.light_energy = 0
    
    if finish_trigger:
        finish_trigger.monitoring = false
        finish_trigger.monitorable = false
    
    label.text = "Items Collected: " + str(items_collected) + "/" + str(total_items)

func collect_item():
    items_collected += 1
    label.text = "Items Collected: " + str(items_collected) + "/" + str(total_items)
    
    if items_collected >= total_items:
        enable_finish()

func enable_finish():
    if finish_light:
        finish_light.light_energy = light_energy_when_on
    
    if finish_trigger:
        finish_trigger.monitoring = true
        finish_trigger.monitorable = true
    
    label.text = "All items collected! Find the exit."