# This script determines the behaviours of the fusion pistol weapon (not the item laying on the ground)
extends JOYWeapon
export(PackedScene) var Fusion_Bolt = preload("fusion_bolt.tscn")
export(PackedScene) var Charged_Fusion_Bolt = preload("charged_fusion_bolt.tscn")
export(AudioStream) var sd
var charged = false
var charging = false
func _process(delta):
	#print(charged, charging)
	pass

func _ready():
	identity = "Zeus Class Fusion Pistol"
	primary_uses = 100
	primary_initial_ammo = 100
	primary_ammo_id = 3
	id = 3
# when primary fire is called
func primary_use(_times = 0):
	
	# check to see if we have ammo.

		# if the can_shoot variable is true
		if can_shoot:
			if ammo_check_primary(5):
				# load a bolt as an instance
				var bolt = Fusion_Bolt.instance()
				bolt.setup(wielder)
				# add the bolt to the aperture of the fusion pistol
				#$aperture.add_child(bolt)
				bolt.set_global_transform($gun/RHand_Pos/Model/aperture.get_global_transform())
				get_node("/root/World/AI_SH_SYSTEM").add_child(bolt)
				wielder.add_child(AutoSound3D.new(sd, translation))
#				$AudioStreamPlayer3D.stream = sd
#				$AudioStreamPlayer3D.play()
				# toggle can shoot (to avoid spawning a bolt per cycle)
				can_shoot=false

				# trigger the cool down timer.
				$Timer.start()

func secondary_use(_times = 0):
	if charging == false:
		$charge.start()
		charging = true

func secondary_release():
	if charged:
		if can_shoot:
			if ammo_check_primary(25):
				# load a bolt as an instance
				var bolt = Charged_Fusion_Bolt.instance()

				# add the bolt to the aperture of the fusion pistol
				bolt.set_global_transform($gun/aperture.get_global_transform())
				get_node("/root").add_child(bolt)

				# toggle can shoot (to avoid spawning a bolt per cycle)
				can_shoot=false

				# trigger the cool down timer.
				$Timer.start()
				charged = false
				charging = false
	else:
		charging = false
		charged = false
		$charge.stop()



# when the cooldown timer has elapsed
func _on_Timer_timeout():
	# reset the canshoot variable.
	can_shoot = true


func _on_charge_timeout():
	charged = true
	$overload.start()



func _on_overload_timeout():
	pass # replace with function body
