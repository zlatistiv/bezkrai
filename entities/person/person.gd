class_name Person
extends CharacterBody2D

@export var speed = 150
@export_enum('down', 'left', 'right', 'up') var facing_direction: String = 'down'
var is_player = false
var frame_size = Vector2i(24, 48)
var fps = 5.0

const DIRECTIONS := {
	Vector2.LEFT:  'left',
	Vector2.RIGHT: 'right',
	Vector2.UP:    'up',
	Vector2.DOWN:  'down',
}

func _ready() -> void:
	var frames := SpriteFrames.new()
	frames.remove_animation('default')
	var sprites_dir = 'res://%s/%s/' % [Global.people_path, self.name.to_lower()]
	
	for file in DirAccess.get_files_at(sprites_dir):
		if file.get_extension() == 'png':
			var tex := load(sprites_dir.path_join(file)) as Texture2D
			var anim_name = file.get_basename()
			frames.add_animation(anim_name)
			frames.set_animation_speed(anim_name, fps)
			frames.set_animation_loop(anim_name, true)
			
			for col in tex.get_width() / frame_size.x:
				var atlas := AtlasTexture.new()
				atlas.atlas = tex
				atlas.region = Rect2(col * frame_size.x, 0, frame_size.x, frame_size.y)
				frames.add_frame(anim_name, atlas)

	$AnimatedSprite2D.sprite_frames = frames

func polarized_vector(v: Vector2) -> Vector2:
	if abs(v.x) > abs(v.y):
		return Vector2(signf(v.x), 0)
	else:
		return Vector2(0, signf(v.y))

func get_input():
	var input_direction
	
	if is_player:
		input_direction = Input.get_vector('left', 'right', 'up', 'down')
	else:
		input_direction = Vector2(0, 0) # Mockup for NPC logic
	
	velocity = input_direction * speed
	
	if input_direction != Vector2.ZERO:
		facing_direction = DIRECTIONS[polarized_vector(input_direction)]
		$AnimatedSprite2D.play(facing_direction + '_walking')
	else:
		$AnimatedSprite2D.play(facing_direction)

func _physics_process(delta):
	get_input()
	move_and_slide()
