package blitzbasic3d

import sdl "vendor:sdl3"
import "core:strings"
import "core:fmt"
import "core:mem"
import "core:log"

Image :: struct {
	surface: ^sdl.Surface,
	texture: ^sdl.GPUTexture,
}

@(private="file")
mid_handle := false

CreateImage :: proc(width, height: i32) -> ^Image {
	image := new(Image)
	image.surface = sdl.CreateSurface(width, height, .RGBA8888); assert(image.surface != nil)
	load_texture_from_surface(image)
	return image
}

LoadImage :: proc(filename: string, location := #caller_location) -> ^Image {
	path, err := strings.concatenate({"assets/", filename}); assert(err==nil)
	defer delete(path)
	image := new(Image)
	image.surface = sdl.LoadPNG(strings.unsafe_string_to_cstring(path))
	if image.surface == nil {
		fmt.panicf("Failed to load image at: %s", path, loc = location)
	}
	image.surface = sdl.ConvertSurface(image.surface, .RGBA8888)
	load_texture_from_surface(image)
	return image
}

SaveImage :: proc(image: ^Image, filename: string) {
	path, err := strings.concatenate({"assets/", filename}); assert(err==nil)
	defer delete(path)
	ok := sdl.SavePNG(image.surface, strings.unsafe_string_to_cstring(path))
	if !ok {
		fmt.panicf("Failed to save image to: %s", path)
	}
	log.infof("Saved image to: %s", path)
}

MaskImage :: proc(image: ^Image, r, g, b: u8) {
	color_to_replace := sdl.MapRGB(sdl.GetPixelFormatDetails(image.surface.format), nil, r, g, b)
	sdl.SetSurfaceColorKey(image.surface, true, color_to_replace)
	sdl.ReleaseGPUTexture(device, image.texture)
	load_texture_from_surface(image)
}

ResizeImage :: proc(image: ^Image, width, height: i32) {
	resized_surface := sdl.ScaleSurface(image.surface, width, height, .NEAREST); assert(resized_surface != nil)
	sdl.DestroySurface(image.surface)
	image.surface = resized_surface
	load_texture_from_surface(image)
}

AutoMidHandle :: proc(enable: bool) {
	mid_handle = enable
}

@(private)
load_texture_from_surface :: proc(image: ^Image) {
	// Create the texture and copy it's pixel data to the transfer buffer.
	image_size := image.surface.w * image.surface.h * 4
	image.texture = sdl.CreateGPUTexture(device, {
		format = .R8G8B8A8_UNORM,
		usage = {.SAMPLER},
		width = cast(u32)image.surface.w,
		height = cast(u32)image.surface.h,
		layer_count_or_depth = 1,
		num_levels = 1,
	})
	transfer_ptr := sdl.MapGPUTransferBuffer(device, transfer_buffer, false); assert(transfer_ptr != nil)
	mem.copy(transfer_ptr, image.surface.pixels, cast(int)image_size)
	sdl.UnmapGPUTransferBuffer(device, transfer_buffer)

	// Upload the the texture data from the transfer buffer to the GPU.
	command_buffer := sdl.AcquireGPUCommandBuffer(device); assert(command_buffer != nil)
	copy_pass := sdl.BeginGPUCopyPass(command_buffer)
	sdl.UploadToGPUTexture(copy_pass,
		{
			transfer_buffer = transfer_buffer,
		},
		{
			texture = image.texture,
			w = cast(u32)image.surface.w,
			h = cast(u32)image.surface.h,
			d = 1,
		},
		false,
	)
	sdl.EndGPUCopyPass(copy_pass)
	fence := sdl.SubmitGPUCommandBufferAndAcquireFence(command_buffer); assert(fence != nil)
	ok := sdl.WaitForGPUFences(device, true,  &fence, 1); assert(ok)
}




