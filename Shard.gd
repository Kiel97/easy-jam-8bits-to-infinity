extends RigidBody2D

export var red: bool = true setget set_red
export var green: bool = true setget set_green
export var blue: bool = true setget set_blue

var dormant_velocity: Vector2 = Vector2(10, 10)
var dormant = true

func _integrate_forces(_state):
	if(dormant):
		self.linear_velocity = dormant_velocity

func _on_Shard_body_entered(body: Node2D):
	if body.is_in_group("player") and dormant:
		dormant = false

func set_red(value):
	red = value
	call_deferred("update_color")

func set_green(value):
	green = value
	call_deferred("update_color")

func set_blue(value):
	blue = value
	call_deferred("update_color")

func update_color():
	$Polygon2D.modulate = Color(float(red), float(green), float(blue))

func _on_VisibilityNotifier2D_screen_exited():
	if dormant:
		print("Untouched")
	self.queue_free()

func get_color() -> Color:
	return Color(float(red), float(green), float(blue))
