extends KinematicBody

const GRAVITY: float = 0.60
const MAX_FALL_SPEED: int = 27
const H_LOOK_SENS: float = 0.1
#const V_LOOK_SENS: float = 0.1

var jump_force = 13
var move_speed = 6
var y_velo = 0

onready var cam : Camera = get_node("Spatial/Camera")
onready var anim: AnimationPlayer = get_node("Graphics/AnimationPlayer")


func _ready():
	anim.get_animation("walk").set_loop(true)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	pass

func _input(event):
	
	
	if event is InputEventMouseMotion:
		#cam.rotation_degrees.x -= event.relative.y * V_LOOK_SENS
		cam.rotation_degrees.x = clamp(cam.rotation_degrees.x, -90, 90)
		rotation_degrees.y -= event.relative.x * H_LOOK_SENS
	pass


func _move_player():
	if Input.is_action_pressed("MOVE_RUN"):
		move_speed = 8
		jump_force = 14
	else:
		move_speed = 6
		jump_force = 13
	
	var move_vec = Vector3()
	if Input.is_action_pressed("MOVE_FORWARDS"):
		move_vec.z -= 1
	if Input.is_action_pressed("MOVE_BACKWARDS"):
		move_vec.z += 1
	if Input.is_action_pressed("MOVE_RIGHT"):
		move_vec.x += 1
	if Input.is_action_pressed("MOVE_LEFT"):
		move_vec.x -= 1
	move_vec = move_vec.normalized()
	move_vec = move_vec.rotated(Vector3(0, 1, 0), rotation.y)
	move_vec *= move_speed
	move_vec.y = y_velo
	move_and_slide(move_vec, Vector3(0, 1, 0))
	
	var grounded = is_on_floor()
	y_velo -= GRAVITY
	var just_jumped = false
	if grounded and Input.is_action_just_pressed("MOVE_JUMP"):
		just_jumped = true
		y_velo = jump_force
	if grounded and y_velo <= 0:
		y_velo = -0.1
	if y_velo < -MAX_FALL_SPEED:
		y_velo = -MAX_FALL_SPEED
	
	if just_jumped:
		play_anim("jump")
	elif grounded:
		if move_vec.x == 0 and move_vec.z == 0:
			play_anim("idle")
		else:
			play_anim("walk")




func _physics_process(delta):
	_move_player()




func play_anim(name):
	if anim.current_animation == name:
		return
	anim.play(name)


######connections


func _on_Jumper_body_entered(body):
	if body is KinematicBody:
		y_velo = jump_force * 4




func _on_trangle_body_entered(body):
	if body is KinematicBody:
		get_node("../pseudodia").show()



func _on_trangle_body_exited(body):
	if body is KinematicBody:
		get_node("../pseudodia").hide()

