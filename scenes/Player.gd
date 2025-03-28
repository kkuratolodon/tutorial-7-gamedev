extends CharacterBody3D

@export var speed: float = 10.0
@export var sprint_speed: float = 15.0
@export var crouch_speed: float = 5.0
@export var crouch_height: float = 1.0
@export var crouch_transition_speed: float = 10.0
@export var acceleration: float = 5.0
@export var gravity: float = 9.8
@export var jump_power: float = 5.0
@export var mouse_sensitivity: float = 0.3

@onready var head: Node3D = $Head
@onready var camera: Camera3D = $Head/Camera3D
@onready var collision_shape: CollisionShape3D = $CollisionShape3D
@onready var inventory_ui = $CanvasLayer/InventoryUI

var camera_x_rotation: float = 0.0
var normal_head_y: float = 0.0
var normal_collision_height: float = 0.0
var normal_collision_y: float = 0.0
var is_crouching: bool = false
var inventory_open: bool = false

var target_head_y: float = 0.0
var target_collision_height: float = 0.0
var target_collision_y: float = 0.0

var inventory = []

func _ready():
    Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
    normal_head_y = head.position.y
    normal_collision_height = collision_shape.shape.height
    normal_collision_y = collision_shape.position.y
    
    target_head_y = normal_head_y
    target_collision_height = normal_collision_height
    target_collision_y = normal_collision_y
    
    inventory_ui.set_player(self)

func _input(event):
    if event.is_action_pressed("inventory"):
        toggle_inventory()
    
    if inventory_open:
        return
    
    if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
        head.rotate_y(deg_to_rad(-event.relative.x * mouse_sensitivity))

        var x_delta = event.relative.y * mouse_sensitivity
        camera_x_rotation = clamp(camera_x_rotation + x_delta, -90.0, 90.0)
        camera.rotation_degrees.x = -camera_x_rotation

func toggle_inventory():
    print('toggle')
    inventory_open = !inventory_open
    
    if inventory_open:
        Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
        inventory_ui.toggle()
    else:
        Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
        inventory_ui.toggle()

func _physics_process(delta):
    if inventory_open:
        return
    # else:
    #     print("konz")
    handle_crouch_input()
    update_crouch_position(delta)
    var movement_vector = Vector3.ZERO
    var head_basis = head.global_transform.basis

    if Input.is_action_pressed("movement_forward"):
        movement_vector -= head_basis.z
    if Input.is_action_pressed("movement_backward"):
        movement_vector += head_basis.z
    if Input.is_action_pressed("movement_left"):
        movement_vector -= head_basis.x
    if Input.is_action_pressed("movement_right"):
        movement_vector += head_basis.x


    movement_vector = movement_vector.normalized()
    
    var current_speed
    if is_crouching:
        current_speed = crouch_speed
    elif Input.is_action_pressed("sprint"):
        current_speed = sprint_speed
    else:
        current_speed = speed

    velocity.x = lerp(velocity.x, movement_vector.x * current_speed, acceleration * delta)
    velocity.z = lerp(velocity.z, movement_vector.z * current_speed, acceleration * delta)

    if not is_on_floor():
        velocity.y -= gravity * delta

    if Input.is_action_just_pressed("jump") and is_on_floor() and not is_crouching:
        velocity.y = jump_power

    move_and_slide()

func handle_crouch_input():
    if Input.is_action_pressed("crouch"):
        if not is_crouching:
            is_crouching = true
            target_head_y = normal_head_y - crouch_height
            target_collision_height = normal_collision_height - crouch_height
            target_collision_y = normal_collision_y - crouch_height * 0.5
    elif is_crouching:
        if not is_ceiling_above():
            is_crouching = false
            target_head_y = normal_head_y
            target_collision_height = normal_collision_height
            target_collision_y = normal_collision_y

func update_crouch_position(delta):
    head.position.y = lerp(head.position.y, target_head_y, crouch_transition_speed * delta)
    
    collision_shape.shape.height = lerp(collision_shape.shape.height, target_collision_height, crouch_transition_speed * delta)
    collision_shape.position.y = lerp(collision_shape.position.y, target_collision_y, crouch_transition_speed * delta)

func is_ceiling_above() -> bool:
    var space_state = get_world_3d().direct_space_state
    
    var ray_origin = global_position + Vector3(0, head.position.y, 0)
    
    var standing_head_height = normal_head_y
    var ray_end = global_position + Vector3(0, standing_head_height, 0)
    
    var query = PhysicsRayQueryParameters3D.create(ray_origin, ray_end)
    query.exclude = [self]
    var result = space_state.intersect_ray(query)
    
    return not result.is_empty()

func add_item(item):
    var item_data = {
        "name": item.item_name,
        "description": item.item_description,
        "instance": item  # Store the actual item instance
    }
    
    # Remove from scene but don't destroy it
    if item.get_parent():
        item.get_parent().remove_child(item)
    # Keep it as a child of the player but hidden
    add_child(item)
    item.visible = false
    item.collision_layer = 0  # Disable collision
    
    inventory.append(item_data)
    print("Added " + item.item_name + " to inventory")
    print("Inventory now contains: ", inventory.size(), " items")
    
    return item_data

func remove_inventory_item(index):
    if index >= 0 and index < inventory.size():
        var item = inventory[index]
        inventory.remove_at(index)
        