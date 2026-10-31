extends CharacterBody3D

# ....---- Wurzeln ----....

@onready var Main_Player = $"."
@onready var camera = $Camera3D
@onready var Cords = $"../global_position"
@onready var Kugel = $"../Kugel"
@onready var Boden = $"../Floor"

# ....---- Variablen ----....

@onready var speed = 3
@onready var mouse_sensitivity = 0.001
@onready var rotation_x = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	print("Es funktioniert!")

func _physics_process(_delta: float) -> void:
	var input_dir = Vector3.ZERO
	
	if Input.is_key_pressed(KEY_W) or Input.is_action_pressed("ui_up"):
		input_dir -= transform.basis.z
		
	if Input.is_key_pressed(KEY_S) or Input.is_action_pressed("ui_down"):
		input_dir += transform.basis.z
		
	if Input.is_key_pressed(KEY_A) or Input.is_action_pressed("ui_left"):
		input_dir -= transform.basis.x
		
	if Input.is_key_pressed(KEY_D) or Input.is_action_pressed("ui_right"):
		input_dir += transform.basis.x
		
	if Input.is_key_pressed(KEY_SHIFT):
		input_dir -= transform.basis.y
		
	if Input.is_key_pressed(KEY_SPACE):
		input_dir += transform.basis.y
	
	if input_dir != Vector3.ZERO:
		velocity = input_dir.normalized() * speed
	else:
		velocity = Vector3.ZERO
	
	move_and_slide()
	
	
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		# Drehung links/rechts (Y-Achse)
		rotate_y(-event.relative.x * mouse_sensitivity)
		
		# Drehung hoch/runter (X-Achse)
		rotation_x -= event.relative.y * mouse_sensitivity
		rotation_x = clamp(rotation_x, -PI / 2, PI / 2)
		camera.rotation.x = rotation_x

	if event is InputEventKey:
		if event.pressed and not event.echo:
			if event.keycode == KEY_X:
				
#...---*= [DU KANNST HIER DIE VARIABLE Z REIHEN ÄNDERN] =*---...

				var Reihen_Z = 100

#...---*= [DU KANNST HIER DIE VARIABLE Y REIHEN ÄNDERN] =*---...

				var Reihen_Y = 100

#...---*= [DU KANNST HIER DIE VARIABLE Y REIHEN ÄNDERN] =*---...

				var Reihen_X = 100
				
				
				entferne_alte_kugeln() # <----- Ist wichtig damit wir neue Gitteranordungen erschaffen können
				print("X wurde gedrückt!") # <--- Debug 
				gehe_reihe_für_reihe_durch(
					Reihen_Z,
					Reihen_Y,
					Reihen_X
				)
			
		
	
func _process(delta: float) -> void:
	Cords.text = str(Main_Player.global_position)
	
	# cords für äu0ere ecke: -20 , 0, -20 ; 20 , 0, 20
	# Wir haben ein 20x20 Gitter 
	# Das sind 400 mögliche Plätze wo sterne sein könnten
	# Ich werde eine 1:3 chacne benutzen damit im durchschnitt 133 Sterne spawnen
	# Ich werde einige IF statements einbauen die prüfen ob die 1:3 eintrifft
	# Und ich werde auch überprüfen müssen dass wir auf die nächste y-achse gehen müssen

func entferne_alte_kugeln():
	var alte_kugeln = get_tree().get_nodes_in_group("generierte_kugeln")
	for kugel_instanz in alte_kugeln:
		kugel_instanz.queue_free() # Löscht die Kugel aus dem Gitter damit neue enstehen können

func gehe_reihe_für_reihe_durch(max_z, max_y, max_x):
	var x = int(0)
	var y = int(0)
	var z = int(0)
	var Chance = int(0)
	while z < max_z:
		if y < max_y:
			Chance = randi_range(1, 25)
			if x < max_x:
				if Chance == 1:
					var Kugel_Kopie = Kugel.duplicate()
					Boden.add_child(Kugel_Kopie)
					Kugel_Kopie.add_to_group("generierte_kugeln")
					Kugel_Kopie.position = Vector3(x, y, z)
					x += 1
				else:
					x +=1
			else:
				y += 1
				x = 0
		else:
			z += 1
			y = 0
			x = 0
	print("Es ist fertig!")
	x = 0; y = 0; z = 0


	
	
	
	
	
	
	
