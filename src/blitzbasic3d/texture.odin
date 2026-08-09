package blitzbasic3d

import sdl "vendor:sdl3"
import "core:strings"
import "core:fmt"
import "core:mem"

Texture :: struct {
	textures: []^sdl.GPUTexture,	// Size of 1 if not animated.
	animated: bool,
	position: [2]f32,
}

LoadTexture :: proc(filename: string, flags: i32 = 1, loc := #caller_location) -> ^Texture {
	assert(flags == 1 || flags == 4, "This flag is not supported", loc = loc)
	image := LoadImage(filename, loc)
	if flags == 4 do MaskImage(image, 0, 0, 0)
	texture := new(Texture)
	texture.textures = make([]^sdl.GPUTexture, 1)
	texture.textures[0] = image.texture
	sdl.DestroySurface(image.surface)
	free(image)
	return texture
}

LoadAnimTexture :: proc(filename: string, flags: i32, frame_width, frame_height, first_frame, frame_count: i32, loc := #caller_location) -> ^Texture {
	assert(flags == 1 || flags == 4, "This flag is not supported", loc = loc)

	// Load spritesheet
	path, err := strings.concatenate({"assets/", filename}); assert(err==nil)
	defer delete(path)
	sprite_sheet := sdl.LoadPNG(strings.unsafe_string_to_cstring(path))
	if sprite_sheet == nil {
		fmt.panicf("Failed to load image at: %s", path, loc = loc)
	}
	sprite_sheet = sdl.ConvertSurface(sprite_sheet, .RGBA8888)

	// Mask it
	if flags == 4 {
		color_to_replace := sdl.MapRGB(sdl.GetPixelFormatDetails(sprite_sheet.format), nil, 0, 0, 0)
		sdl.SetSurfaceColorKey(sprite_sheet, true, color_to_replace)
	}

	// Blit into seperate surfaces.
	column_count := (sprite_sheet.w / frame_width)
	row_count := (sprite_sheet.h / frame_height)
	assert(column_count == 0 || row_count == 0, "Frame size is bigger than the spritesheet")
	frames := make([]^sdl.Surface, row_count * column_count)
	for &frame in frames {
		frame = sdl.CreateSurface(frame_width, frame_height, .RGBA8888)
	}
	blited_frame := 0
	for y in 0..<row_count {
		for x in 0..<column_count {
			sdl.BlitSurface(sprite_sheet, &sdl.Rect{x, y, frame_width, frame_height}, frames[blited_frame], nil)
			blited_frame += 1
		}
	}

	// I'm going to ignore the first_frame and frame_count filter since its only used once in the whole game,
	// All frames are used in this case.

	// Upload the surfaces to the GPU as textures
	textures := make([]^sdl.GPUTexture, frame_count)
	for i in 0..<len(textures) {
		// Create the texture and copy it's pixel data to the transfer buffer.
		image_size := frame_width * frame_height * 4
		textures[i] = sdl.CreateGPUTexture(device, {
			format = .R8G8B8A8_UNORM,
			usage = {.SAMPLER},
			width = cast(u32)frame_width,
			height = cast(u32)frame_height,
			layer_count_or_depth = 1,
			num_levels = 1,
		})

		transfer_ptr := sdl.MapGPUTransferBuffer(device, transfer_buffer, false); assert(transfer_ptr != nil)
		mem.copy(transfer_ptr, frames[i].pixels, cast(int)image_size)
		sdl.UnmapGPUTransferBuffer(device, transfer_buffer)

		// Upload the the texture data from the transfer buffer to the GPU.
		command_buffer := sdl.AcquireGPUCommandBuffer(device); assert(command_buffer != nil)
		copy_pass := sdl.BeginGPUCopyPass(command_buffer)
		sdl.UploadToGPUTexture(copy_pass,
			{
				transfer_buffer = transfer_buffer,
			},
			{
				texture = textures[i],
				w = cast(u32)frame_width,
				h = cast(u32)frame_height,
				d = 1,
			},
			false,
		)
		sdl.EndGPUCopyPass(copy_pass)
		fence := sdl.SubmitGPUCommandBufferAndAcquireFence(command_buffer); assert(fence != nil)
		ok := sdl.WaitForGPUFences(device, true,  &fence, 1); assert(ok)
	}

	// Delete the surfaces, dont need them anymore
	for &frame in frames {
		sdl.DestroySurface(frame)
	}
	delete(frames)

	blitz_texture := new(Texture)
	blitz_texture.textures = textures
	blitz_texture.animated = true
	return blitz_texture
}

PositionTexture :: proc(texture: ^Texture, u, v: f32) {
	texture.position = {u, v}
}

