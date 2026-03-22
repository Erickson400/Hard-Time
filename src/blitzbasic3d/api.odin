package blitzbasic3d
/*
	Here goes all the public functions and types exposed
	by the blitz package to be used in the ported source code.

	If the function name is not PascalCase, then its used by main.odin
*/

import ray "vendor:raylib"
import "core:strings"

// ------Internals-------
GfxMode3DExists :: proc(width, height, color: i32) -> i32 { return 0 }
Graphics3DWidth :: proc(width, height, color, thingy: i32) {}

// ------Graphics-------
Cls :: proc() { cls() }
Flip :: proc() { flip() }
Color :: proc(r, g, b: i32) {}
SetFont :: proc(font: uintptr) {}
Text :: proc(x, y: i32, text: string, centerx, centery: i32) {}
Line :: proc(p1x, p1y, p2x, p2y: i32) {}
GraphicsWidth :: proc() -> i32 { return 1}
GraphicsHeight :: proc() -> i32 { return 1}
TileImage :: proc(image: uintptr) {}
DrawImage :: proc(image: uintptr, x, y: i32) {}
Rect :: proc(x, y, width, height, color: i32) {}
GrabImage :: proc(image: uintptr, x, y: i32, frame: i32 = 0) {}
Locate :: proc(x, y: i32) {}
Graphics3D :: proc(width, height, color, fullscreen: i32) {}

// ------Audio-----
ChannelPlaying :: proc(channel: uintptr) -> i32 { return 0 }
StopChannel :: proc(channel: uintptr) {}
LoadSound :: proc(filename: string) -> uintptr { return 1 }
Load3DSound :: proc(filename: string) -> uintptr { return 1 }
SoundPitch :: proc(sound: uintptr, pitch: i32) {}
SoundVolume :: proc(sound: uintptr, volume: f32) {}
EmitSound :: proc(sound: uintptr, entity: uintptr) -> uintptr { return 0}
PlaySound :: proc(sound: uintptr) -> uintptr { return 1 }
CreateListener :: proc(entity: uintptr, roll, dopp, dist: f32) -> uintptr { return 1}
LoopSound :: proc(sound: uintptr) {}
ChannelVolume :: proc(channel: uintptr, volume: f32) {}

// ------Images/Textures-----
CreateImage :: proc(width, height: i32) -> uintptr { return 1}
LoadImage :: proc(filename: string) -> uintptr { return 1 }
MaskImage :: proc(image: uintptr, r: u8, g: u8, b: u8) {  }
LoadTexture :: proc(filename: string, flags: i32 = 1) -> uintptr { return 1 }
LoadAnimTexture :: proc(filenames: string, flags: i32, frame_width, frame_height: i32, first_frame, frame_count: i32) -> uintptr { 
	return 1
}
SaveImage :: proc(image_handle: uintptr, path: string) -> i32 { return 1}
ResizeImage :: proc(image: uintptr, new_width, new_height: i32) {}

// -------Sprite---------
LoadSprite :: proc(filename: string, flags: i32) -> uintptr { return 1}
ScaleSprite :: proc(sprite: uintptr, scalex, scaley: f32) {}
SpriteViewMode :: proc(mode, other: uintptr) {}

// -------Text--------
LoadFont :: proc(filename: string, height, bold, italic, underline: i32) -> uintptr { return 0}
Upper :: proc(text: string, allocator := context.allocator) -> string { return "" }
Lower :: proc(text: string, allocator := context.allocator) -> string { return "" }

// -------File--------
WriteFile :: proc(path: string, loc := #caller_location) -> i32 { return 0 }
ReadFile :: proc(path: string, loc := #caller_location) -> i32 { return 0 }
CloseFile :: proc(file: i32) {}
WriteInt :: proc(file: i32, value: i32, loc := #caller_location) {}
WriteFloat :: proc(file: i32, value: f32, loc := #caller_location)  {}
WriteString :: proc(file: i32, text: string, loc := #caller_location) {}
ReadInt :: proc(file: i32, loc := #caller_location) -> i32 { return 0 }
ReadString :: proc(file: i32, loc := #caller_location) -> string { return "" }
ReadFloat :: proc(file: i32, loc := #caller_location) -> f32 { return 0 }
ReadDir :: proc(directory: string) -> i32 { return 0 }
CloseDir :: proc(fileHandle: i32) {}
CurrentDir :: proc(allocator := context.allocator) -> string { return "" }
FileType :: proc(filePath: i32) -> i32 { return 0 }
NextFiles :: proc(allocator := context.allocator) -> string { return "" }


// -------Math-------
// Rnd :: proc{rnd_int, rnd_float}
RndI :: proc{rnd_int}
RndF :: proc{rnd_float}
SeedRnd :: proc(seed: i32) {}

// -------String-------
StringWidth :: proc(text: string) -> i32 { return 1 }
Left :: proc(text: string, count: i32, allocator := context.allocator) -> string {
	result, ok := strings.substring_to(text, int(count))
	if ok do return result
	return text
}
Right :: proc(text: string, count: i32, allocator := context.allocator) -> string {
	result, ok := strings.substring_from(text, int(count))
	if ok do return result
	return text
}

// -------Time----------
CreateTimer :: proc(fps: i32) -> uintptr { return 1}
WaitTimer :: proc(timer: uintptr) -> i32 { return 1}
FreeTimer :: proc(timer: uintptr) {}
MilliSecs :: proc() -> i32 { return 1}

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
EntityTexture :: proc(entity, texture: uintptr, sus: i32 = 0, sos: i32 = 0) {}
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

// -------Input--------
KeyDown :: proc(key: i32) -> i32 { return 0}
JoyYDir :: proc() -> i32 { return 0}
JoyXDir :: proc() -> i32 { return 0}
JoyDown :: proc(something: i32) -> i32 { return 0}
KeyHit :: proc(key: i32) -> i32 { return 1}
MoveMouse :: proc(x, y: i32) {}
MouseDown :: proc(button: i32) -> i32 { return 0}
MouseXSpeed :: proc() -> i32 { return 0}
MouseYSpeed :: proc() -> i32 { return 0}
MouseX :: proc() -> i32 { return 0}
MouseY :: proc() -> i32 { return 0}
FlushKeys :: proc() {}
Input :: proc(prompt: string) -> string { return ""}

// -------Collision--------
Collisions :: proc(src_type, dest_type, method, response: i32) {}

// -------Animation--------


//------Initialization---------
init :: proc() {
	ray.InitWindow(1280, 720, "Hard Time")
	ray.InitAudioDevice()
	ray.SetTargetFPS(120)
	init_audio_system()
	init_font_system()
	init_image_system()
	init_rendering_system()
}


destroy :: proc() {
	destroy_rendering_system()
	destroy_image_system()
	destroy_font_system()
	destroy_audio_system()
	ray.CloseAudioDevice()
	ray.CloseWindow()
}




