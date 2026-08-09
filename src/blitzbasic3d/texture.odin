package blitzbasic3d

import sdl "vendor:sdl3"


Texture :: struct {
	texture: ^sdl.GPUTexture,
	position: [2]f32,
}

LoadTexture :: proc(filename: string, flags: i32 = 1) -> ^Texture {
	return nil
}

LoadAnimTexture :: proc(filename: string, flags: i32, frame_width, frame_height, first_frame, frame_count: i32) -> ^Texture {
	return nil
}

PositionTexture :: proc(texture: ^Texture, u, v: f32) {

}

