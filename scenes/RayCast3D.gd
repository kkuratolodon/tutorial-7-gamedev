extends RayCast3D

@export var player: Node3D
var current_collider = null
var interactable_objects = []

func _ready():
    find_all_interactables(get_tree().root)
    for collider in interactable_objects:
        # Use get_node_or_null to safely check for the AnimationPlayer
        var anim_player = collider.get_node_or_null("AnimationPlayer")
        if anim_player:
            anim_player.play("Not Interactable")
    
func find_all_interactables(node):
    for child in node.get_children():
        if child is Interactable:
            interactable_objects.append(child)
        
        if child.get_child_count() > 0:
            find_all_interactables(child)

func _process(_delta):
    var collider = get_collider()
    if current_collider != null and (current_collider != collider or !is_colliding()):
        if current_collider.get("anim"): 
            current_collider.anim.play("Not Interactable")
        current_collider = null
    
    if is_colliding() and collider is Interactable:
        if current_collider != collider:
            current_collider = collider
            if current_collider.get("anim"):
                current_collider.anim.play("Interactable")
        
        if Input.is_action_just_pressed("interact"):
            current_collider.interact()

        if Input.is_action_just_pressed("pick") and current_collider.can_pickup():
            if current_collider.pickup(player):
                current_collider = null
