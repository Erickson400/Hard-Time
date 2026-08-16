package blitzbasic3d


// ------Graphics-------
// Cls :: proc() {}
Flip :: proc() {}
SetFont :: proc(font: uintptr) {}
Text :: proc(x, y: i32, text: string, centerx, centery: i32) {}
// Line :: proc(p1x, p1y, p2x, p2y: i32) {}
// TileImage :: proc(image: ^Image) {}
// DrawImage :: proc(image: ^Image, x, y: i32) {}
// Rect :: proc(x, y, width, height, color: i32) {}
// GrabImage :: proc(image: ^Image, x, y: i32, frame: i32 = 0) {}
Locate :: proc(x, y: i32) {}
// SetBuffer :: proc(buffer: uintptr) {}
// BackBuffer :: proc() -> uintptr { return 1}
// FrontBuffer :: proc() -> uintptr { return 1}

// -------Audio---------
EmitSound :: proc(sound: ^Sound, entity: uintptr) -> ^Channel { return nil}
CreateListener :: proc(entity: uintptr, rolloff: f32 = 1, doppler_scale: f32 = 1, distance_scale: f32 = 1) -> uintptr { return 1}

// -------Sprite---------
LoadSprite :: proc(filename: string, flags: i32) -> uintptr { return 1}
ScaleSprite :: proc(sprite: uintptr, scalex, scaley: f32) {}
SpriteViewMode :: proc(mode, other: uintptr) {}
CreateSprite :: proc(parent: uintptr = 0) -> uintptr { return 1}

// -------Text--------
LoadFont :: proc(filename: string, height, bold, italic, underline: i32) -> uintptr { return 0}
StringWidth :: proc(text: string) -> i32 { return 1 }

// -------Entity-------
EntityType :: proc(entity: uintptr, collision_type: i32, recursive: i32 = 0) -> i32 { return 1}
DeleteEntity :: proc(entity: uintptr) {}
PositionEntity :: proc(entity: uintptr, x, y, z: f32) {}
RotateEntity :: proc(entity: uintptr, x, y, z: f32) {}
ScaleEntity :: proc(entity: uintptr, x, y, z: f32) {}
EntityAlpha :: proc(entity: uintptr, alpha: f32) {}
EntityColor :: proc(entity: uintptr, r, g, b: i32) {}
EntityYaw :: proc(entity: uintptr, global: i32 = 0) -> f32 { return 0}
EntityPitch :: proc(entity: uintptr, global: i32 = 0) -> f32 { return 0}
EntityRoll :: proc(entity: uintptr, global: i32 = 0) -> f32 { return 0}
PointEntity :: proc(entity, entity_t: uintptr, roll: f32 = 0) -> f32 { return 0}
CountCollisions :: proc(entity: uintptr) -> i32 { return 1}
CollisionEntity :: proc(entity: uintptr, index: i32) -> uintptr { return 1}
EntityX :: proc(entity: uintptr, x: f32 = 0) -> f32 { return 0}
EntityY :: proc(entity: uintptr, y: f32 = 0) -> f32 { return 0}
EntityZ :: proc(entity: uintptr, z: f32 = 0) -> f32 { return 0}
ResetEntity :: proc(entity: uintptr) {}
MoveEntity :: proc(entity: uintptr, x, y, z: f32) {}
EntityTexture :: proc(entity: uintptr, texture: ^Texture, frame: i32 = 0, index: i32 = 0) {}
FindChild :: proc(parent: uintptr, name: string) -> uintptr { return 1}
HideEntity :: proc(entity: uintptr) {}
ShowEntity :: proc(entity: uintptr) {}
Animate :: proc(entity: uintptr, sequence: uintptr, speed: f32, loop: i32 = 0, other: i32 = 0) {}
FreeEntity :: proc(entity: uintptr) {}
EntityShininess :: proc(entity: uintptr, shininess: f32) {}
EntityFX :: proc(entity: uintptr, fx_type: i32) {}
CountChildren :: proc(entity: uintptr) -> i32 { return 1}
GetChild :: proc(entity: uintptr, index: i32) -> uintptr { return 1}
EntityRadius :: proc(entity: uintptr, x_radius: f32, y_radious: f32 = 0) {}
CreatePivot :: proc() -> uintptr { return 1}
CameraRange :: proc(camera: uintptr, near, far: f32) {}
CameraFogColor :: proc(camera: uintptr, r, g, b: f32) {}
CameraClsMode :: proc(camera: uintptr, cls_color, cls_zbuffer: i32) {}

// -------Models--------
LoadAnimMesh :: proc(filename: string) -> uintptr { return 1}
LoadAnimSeq :: proc(entity: uintptr, filename: string) -> i32 { return 1}
ExtractAnimSeq :: proc(entity: uintptr, seq, start_frame, end_frame: i32) -> i32 {return 1}

// -------Camera--------
CreateCamera :: proc() -> uintptr { return 1}
CameraViewport :: proc(camera: uintptr, x, y, width, height: i32) {}
CameraFogMode :: proc(camera: uintptr, mode: i32) {}
CameraFogRange :: proc(camera: uintptr, start, end: f32) {}

// --------World-------
UpdateWorld :: proc() {}
RenderWorld :: proc(mode: uintptr) {}

// -------Lights--------
AmbientLight :: proc(r, g, b: f32) {}
CreateLight :: proc(type: i32) -> uintptr { return 1}
LightRange :: proc(light: uintptr, range: f32) {}
LightConeAngles :: proc(light: uintptr, inner_angle, outer_angle: f32) {}
LightColor :: proc(light: uintptr, r, g, b: f32) {}

// -------Collision--------
Collisions :: proc(src_type, dest_type, method, response: i32) {}
ClearCollisions :: proc() {}
