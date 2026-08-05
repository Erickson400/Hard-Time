package blitzbasic3d

import sdl "vendor:sdl3"
import "core:strings"
import "core:fmt"
import "core:mem"
import "core:log"

Image :: struct {
	surface: ^sdl.Surface,
	texture: ^sdl.GPUTexture,
	// I might not need a sampler because most images are rendered in the same way.
}

@(private="file")
mid_handle := false

CreateImage :: proc(width, height: i32) -> ^Image {
	image := new(Image)
	image.surface = sdl.CreateSurface(width, height, .RGBA8888); assert(image.surface != nil)
	image_size := image.surface.w * image.surface.w * 4 // Note that its 4 bytes per pixel in case format changes.
	texture_create_info := sdl.GPUTextureCreateInfo{
		format = sdl.GetGPUTextureFormatFromPixelFormat(image.surface.format),
		width = cast(u32)image.surface.w,
		height = cast(u32)image.surface.h,
		layer_count_or_depth = 1,
		num_levels = 1,
	}
	image.texture = sdl.CreateGPUTexture(device, texture_create_info)
	transfer_ptr := sdl.MapGPUTransferBuffer(device, transfer_buffer, false)
	mem.copy(transfer_ptr, image.surface.pixels, cast(int)image_size)
	sdl.UnmapGPUTransferBuffer(device, transfer_buffer)

	command_buffer := sdl.AcquireGPUCommandBuffer(device); assert(command_buffer != nil)
	copy_pass := sdl.BeginGPUCopyPass(command_buffer)
	source := sdl.GPUTextureTransferInfo{
		transfer_buffer = transfer_buffer,
		// Do I have to put the pixels per row and rows per layer?
	}
	destination := sdl.GPUTextureRegion{
		texture = image.texture,
		w = cast(u32)image.surface.w,
		h = cast(u32)image.surface.h,
	}
	sdl.UploadToGPUTexture(copy_pass, source, destination, false)
	sdl.EndGPUCopyPass(copy_pass)
	fence := sdl.SubmitGPUCommandBufferAndAcquireFence(command_buffer)
	ok := sdl.WaitForGPUFences(device, true, cast([^]^sdl.GPUFence)fence, 1); assert(ok)
	log.infof("Created blank image and texture.")
	return image
}

// TODO: I have to Upload the image to the GPU as a Texture.
LoadImage :: proc(filename: string) -> ^Image {
	path, err := strings.concatenate({"assets/", filename}); assert(err==nil)
	defer delete(path)
	image := new(Image)
	image.surface = sdl.LoadPNG(strings.unsafe_string_to_cstring(path))
	if image.surface == nil {
		fmt.panicf("Failed to load image at: %s", path)
	}
	image.surface = sdl.ConvertSurface(image.surface, .RGBA8888)
	log.infof("Created image and texture for: %s", path)
	return image
}

SaveImage :: proc(image: ^Image, filename: string) {
	path, err := strings.concatenate({"assets/", filename}); assert(err==nil)
	defer delete(path)
	ok := sdl.SavePNG(image.surface, strings.unsafe_string_to_cstring(path))
	if !ok {
		fmt.panicf("Failed to save iamge at: %s", path)
	}
	log.infof("Saved image to: %s", path)
}

MaskImage :: proc(image: ^Image, r, g, b: u8) {
	color_to_replace := sdl.MapRGBA(sdl.GetPixelFormatDetails(image.surface.format), nil, r, g, b, 255)
	sdl.SetSurfaceColorKey(image.surface, true, color_to_replace)
}

ResizeImage :: proc(image: ^Image, width, height: i32) {
	resized_surface := sdl.ScaleSurface(image.surface, width, height, .NEAREST); assert(resized_surface != nil)
	sdl.DestroySurface(image.surface)
	free(image.surface)
	image.surface = resized_surface
}

AutoMidHandle :: proc(enable: bool) {
	mid_handle = enable
}






