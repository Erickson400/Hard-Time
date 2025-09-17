package blitzbasic3d
/*
	Here goes all the public functions and types exposed
	by the blitz package to be used outside the package.

	If the function name is not PascalCase, then its used by main.odin
*/

import ray "vendor:raylib"
import "core:os"
import "core:math/rand"


// ------Graphics-------
Cls :: proc() { cls() }
Flip :: proc() { flip() }
Color :: proc(r, g, b: i32) {}
SetFont :: proc(font: i32) {}
Text :: proc(x, y: i32, text: string, centerx, centery: i32) {}
Line :: proc(p1x, p1y, p2x, p2y: i32) {}
GraphicsWidth :: proc() -> i32 { return 1}
GraphicsHeight :: proc() -> i32 { return 1}

// ------Audio-----
LoadSound :: proc(filename: string) -> i32 { return load_sound(filename, false) }
Load3DSound :: proc(filename: string) -> i32 { return load_sound(filename, true) }
SoundPitch :: proc(sound: i32, pitch: i32) {}
SoundVolume :: proc(sound: i32, volume: f32) {}
EmitSound :: proc(sound: i32, entity: i32) {}

// ------Images/Textures-----
LoadImage :: proc(filename: string) -> i32 { return load_image(filename) }
MaskImage :: proc(image: i32, r: u8, g: u8, b: u8) { mask_image(image, r, g, b) }
LoadTexture :: proc(filename: string, flags: i32 = 1) -> i32 { return load_texture(filename, flags) }
LoadAnimTexture :: proc(filenames: string, flags: i32, frame_width, frame_height: i32, first_frame, frame_count: i32) -> i32 { 
	return load_anim_texture(filenames, flags, frame_width, frame_height, first_frame, frame_count)
}
SaveImage :: proc(image_handle: i32, path: string) -> i32 { return save_image(image_handle, path) }

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



// -------Entity-------


// -------Models--------


// -------Input--------


// -------Collision--------


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




