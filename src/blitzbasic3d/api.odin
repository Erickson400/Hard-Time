package blitzbasic3d
/*
	Here goes all the public functions and types exposed
	by the blitz package to be used outside the package.

	If the function name is not PascalCase, then its used by main.odin
*/

import ray "vendor:raylib"


SoundHandle :: int
ImageHandle :: int
TextureHandle :: int
AnimTextureHandle :: int
FontHandle :: int


TextureFlag :: enum {
	COLOR = 1,
	MASKED = 4,
}


// ------Graphics-------
Cls :: proc() { cls() }
Flip :: proc() { flip() }


// ------Audio-----
LoadSound :: proc(filename: string) -> SoundHandle { return load_sound(filename, false) }
Load3DSound :: proc(filename: string) -> SoundHandle { return load_sound(filename, true) }

// ------Images/Textures-----
LoadImage :: proc(filename: string) -> ImageHandle { return load_image(filename) }
MaskImage :: proc(image: ImageHandle, r: u8, g: u8, b: u8) { mask_image(image, r, g, b) }
LoadTexture :: proc(filename: string, flags := TextureFlag.COLOR) -> TextureHandle { return load_texture(filename, flags) }
LoadAnimTexture :: proc(filenames: string, flags: TextureFlag, frame_width, frame_height: i32, first_frame, frame_count: int) -> AnimTextureHandle { 
	return load_anim_texture(filenames, flags, frame_width, frame_height, first_frame, frame_count)
}

// -------Text--------
LoadFont :: proc(filename: string, height: i32, bold: bool, italic: bool, underline: bool) -> FontHandle { return load_font(filename, height, bold, italic, underline) }

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




