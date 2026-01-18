extends Resource
class_name CharacterData

@export var name: String = ""
@export var mass: float = 0.0        # 重量
@export var friction: float = 0.0    # 摩擦力
@export var bounce: float = 0.0      # 彈性
@export var character_image: Texture2D       # 角色外觀
@export var body_height: float = 0.0
@export var lock_rotation: bool = false  # 是否防止滾動
@export var freeze_position: bool = false # 是否固定在原地
