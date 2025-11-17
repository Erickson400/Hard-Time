package blitzbasic3d
/*
	Here goes all the public functions and types exposed
	by the blitz package to be used in the ported source code.

	If the function name is not PascalCase, then its used by main.odin
*/

import ray "vendor:raylib"
import "core:os"
import "core:strings"


// ------Internals-------
GfxMode3DExists :: proc(width, height, color: i32) -> bool { return true }
Graphics3DWidth :: proc(width, height, color, thingy: i32) {}

// ------Graphics-------
Cls :: proc() { cls() }
Flip :: proc() { flip() }
Color :: proc(r, g, b: i32) {}
SetFont :: proc(font: i32) {}
Text :: proc(x, y: i32, text: string, centerx, centery: i32) {}
Line :: proc(p1x, p1y, p2x, p2y: i32) {}
GraphicsWidth :: proc() -> i32 { return 1}
GraphicsHeight :: proc() -> i32 { return 1}
TileImage :: proc(image: i32) {}
DrawImage :: proc(image: i32, x, y: i32) {}
Rect :: proc(x, y, width, height, color: i32) {}
GrabImage :: proc(image: i32, x, y: i32, frame: i32 = 0) -> i32 { return 1}
Locate :: proc(x, y: i32) {}
Graphics3D :: proc(width, height, color, fullscreen: i32) {}

// ------Audio-----
LoadSound :: proc(filename: string) -> i32 { return load_sound(filename, false) }
Load3DSound :: proc(filename: string) -> i32 { return load_sound(filename, true) }
SoundPitch :: proc(sound: i32, pitch: i32) {}
SoundVolume :: proc(sound: i32, volume: f32) {}
EmitSound :: proc(sound: i32, entity: i32) {}
PlaySound :: proc(sound: i32) {}
CreateListener :: proc(entity: i32, roll, dopp, dist: f32) -> i32{ return 1}

// ------Images/Textures-----
CreateImage :: proc(width, height: i32) -> i32 { return 1}
LoadImage :: proc(filename: string) -> i32 { return load_image(filename) }
MaskImage :: proc(image: i32, r: u8, g: u8, b: u8) { mask_image(image, r, g, b) }
LoadTexture :: proc(filename: string, flags: i32 = 1) -> i32 { return load_texture(filename, flags) }
LoadAnimTexture :: proc(filenames: string, flags: i32, frame_width, frame_height: i32, first_frame, frame_count: i32) -> i32 { 
	return load_anim_texture(filenames, flags, frame_width, frame_height, first_frame, frame_count)
}
SaveImage :: proc(image_handle: i32, path: string) -> i32 { return save_image(image_handle, path) }
ResizeImage :: proc(image: i32, new_width, new_height: i32) {}

// -------Sprite---------
LoadSprite :: proc(filename: string, flags: i32) -> i32 { return 1}
ScaleSprite :: proc(sprite: i32, scalex, scaley: f32) {}
SpriteViewMode :: proc(mode, other: i32) {}

// -------Text--------
LoadFont :: proc(filename: string, height: i32, bold: bool, italic: bool, underline: bool) -> i32 { return load_font(filename, height, bold, italic, underline) }

// -------File--------
WriteFile :: proc(path: string, loc := #caller_location) -> os.Handle { return open_file(path, false, loc) }
ReadFile :: proc(path: string, loc := #caller_location) -> os.Handle { return open_file(path, true, loc) }
CloseFile :: proc(file: os.Handle) { os.close(file) }
WriteInt :: proc(file: os.Handle, value: i32, loc := #caller_location) { write_int(file, value, loc) }
WriteFloat :: proc(file: os.Handle, value: f32, loc := #caller_location)  { write_float(file, value, loc) }
WriteString :: proc(file: os.Handle, text: string, loc := #caller_location) { write_string(file, text, loc) }
ReadInt :: proc(file: os.Handle, loc := #caller_location) -> i32 { return read_int(file, loc) }
ReadString :: proc(file: os.Handle, loc := #caller_location) -> string { return read_string(file, loc) }
ReadFloat :: proc(file: os.Handle, loc := #caller_location) -> f32 { return read_float(file, loc) }

// -------Math-------
Rnd :: proc{ rnd_float, rnd_int}

// -------String-------
StringWidth :: proc(text: string) -> i32 { return 1 }
Left :: proc(text: string, count: i32) -> string {
	result, ok := strings.substring_to(text, int(count))
	if ok do return result
	return text
}
Right :: proc(text: string, count: i32) -> string {
	result, ok := strings.substring_from(text, int(count))
	if ok do return result
	return text
}

// -------Time----------
CreateTimer :: proc(fps: i32) -> i32 { return 1}
WaitTimer :: proc(timer: i32) -> i32 { return 1}
FreeTimer :: proc(timer: i32) {}
MilliSecs :: proc() -> i32 { return 1}

// -------Entity-------
EntityType :: proc(entity, type_id: i32, other: i32 = 0) -> i32 { return 1}
DeleteEntity :: proc(entity: i32) {}
PositionEntity :: proc(entity: i32, x, y, z: f32) {}
RotateEntity :: proc(entity: i32, x, y, z: f32) {}
ScaleEntity :: proc(entity: i32, x, y, z: f32) {}
EntityAlpha :: proc(entity: i32, alpha: f32) {}
EntityColor :: proc(entity: i32, r, g, b: i32) {}
EntityYaw :: proc(entity: i32, global: i32 = 0) -> f32 { return 0}
EntityPitch :: proc(entity: i32, global: i32 = 0) -> f32 { return 0}
EntityRoll :: proc(entity: i32, global: i32 = 0) -> f32 { return 0}
PointEntity :: proc(entity: i32, global: i32 = 0) -> f32 { return 0}
CountCollisions :: proc(entity: i32) -> i32 { return 1}
CollisionEntity :: proc(entity: i32, index: i32) -> i32 { return 1}

EntityX :: proc(entity: i32, x: f32 = 0) -> f32 { return 0}
EntityY :: proc(entity: i32, y: f32 = 0) -> f32 { return 0}
EntityZ :: proc(entity: i32, z: f32 = 0) -> f32 { return 0}
ResetEntity :: proc(entity: i32) {}
MoveEntity :: proc(entity: i32, x, y, z: f32) {}
EntityTexture :: proc(entity: i32, texture: i32, sus: i32 = 0, sos: i32 = 0) {}
FindChild :: proc(parent: i32, name: string) -> i32 { return 1}
HideEntity :: proc(entity: i32) {}
ShowEntity :: proc(entity: i32) {}
Animate :: proc(entity: i32, sequence: i32, speed: f32, loop: i32 = 0, other: i32 = 0) {}
FreeEntity :: proc(entity: i32) {}
EntityShininess :: proc(entity: i32, shininess: f32) {}
EntityFX :: proc(entity: i32, fx_type: i32) {}
CountChildren :: proc(entity: i32) -> i32 { return 1}
GetChild :: proc(entity: i32, index: i32) -> i32 { return 1}
EntityRadius :: proc(entity: i32, x_radius: f32, y_radious: f32 = 0) {}
CreatePivot :: proc() -> i32 { return 1}
CameraRange :: proc(camera: i32, near, far: f32) {}
CameraFogColor :: proc(camera: i32, r, g, b: f32) {}


// -------Models--------
LoadAnimMesh :: proc(filename: string) -> i32 { return 1}
LoadAnimSeq :: proc(entity: i32, filename: string) -> i32 { return 1}
ExtractAnimSeq :: proc(entity: i32, seq: i32, start_frame, end_frame: i32) -> i32 {return 1}

// -------Camera--------
CreateCamera :: proc() -> i32 { return 1}
CameraViewport :: proc(camera: i32, x, y, width, height: i32) {}
CameraFogMode :: proc(camera: i32, mode: i32) {}
CameraFogRange :: proc(camera: i32, start, end: f32) {}

// --------World-------
UpdateWorld :: proc() {}
RenderWorld :: proc(mode: i32) {}

// -------Lights--------
AmbientLight :: proc(r, g, b: f32) {}
CreateLight :: proc(type: i32) -> i32 { return 1}
LightRange :: proc(light: i32, range: f32) {}
LightConeAngles :: proc(light: i32, inner_angle, outer_angle: f32) {}
LightColor :: proc(light: i32, r, g, b: f32) {}

// -------Input--------
KeyDown :: proc(key: i32) -> bool { return false}
ButtonPressed :: proc() -> bool { return false}
JoyYDir :: proc() -> i32 { return 0}
JoyXDir :: proc() -> i32 { return 0}
JoyDown :: proc(something: i32) -> bool { return false}
KeyHit :: proc(key: i32) -> i32 { return 1}
MoveMouse :: proc(x, y: i32) {}
MouseDown :: proc(button: i32) -> bool { return false}
MouseXSpeed :: proc() -> i32 { return 0}
MouseYSpeed :: proc() -> i32 { return 0}
MouseX :: proc() -> i32 { return 0}
MouseY :: proc() -> i32 { return 0}
FlushKeys :: proc() {}
Input :: proc(prompt: string) -> string { return ""}

// -------Collision--------
Collisions :: proc(mode, entity1, entity2, response: i32) {}

// -------Animation--------


//------Initialization---------
init :: proc() {
	ray.InitWindow(1280, 720, "Hard Time")
	ray.InitAudioDevice(); 
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




