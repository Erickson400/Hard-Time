package blitzbasic3d

import sdl "vendor:sdl3"
import "core:math"
import "core:mem"

GfxMode3DExists :: proc(width, height, depth: i32) -> i32 {
	return 1 // Legacy feature for old hardware
}

window: ^sdl.Window
device: ^sdl.GPUDevice
TRANSFER_BUFFER_SIZE :: 64 * mem.Megabyte
transfer_buffer: ^sdl.GPUTransferBuffer

init_graphics :: proc() {
	window = sdl.CreateWindow("Hard Time", 800, 600, {.VULKAN}); assert(window != nil)
	device = sdl.CreateGPUDevice({.SPIRV}, true, "vulkan")
	ok := sdl.ClaimWindowForGPUDevice(device, window); assert(ok)
	transfer_buffer = sdl.CreateGPUTransferBuffer(device, {
		usage = .UPLOAD,
		size = TRANSFER_BUFFER_SIZE,
	})
}

destroy_graphics :: proc() {
	sdl.ReleaseGPUTransferBuffer(device, transfer_buffer)
	sdl.ReleaseWindowFromGPUDevice(device, window)
	sdl.DestroyGPUDevice(device)
	sdl.DestroyWindow(window)
}

Graphics3D :: proc(width, height, color, fullscreen: i32) {
	// The screen is suppose to be fullscreen, but for the sake of debugging and
	// resolution compatability, I'll keep it windowed.
	// Color param can be ignored.
	ok := sdl.SetWindowSize(window, width, height); assert(ok)
}

GraphicsWidth :: proc() -> i32 { 
	w: i32
	ok := sdl.GetWindowSizeInPixels(window, &w, nil); assert(ok)
	return w
}

GraphicsHeight :: proc() -> i32 {
	h: i32
	ok := sdl.GetWindowSizeInPixels(window, nil, &h); assert(ok)
	return h
}

drawing_color: [3]i32

Color :: proc(r, g, b: i32) {
	drawing_color = {
		math.clamp(r, 0, 255),
		math.clamp(b, 0, 255),
		math.clamp(b, 0, 255),
	}
}

ColorRed :: proc() -> i32 { return drawing_color.r}

ColorGreen :: proc() -> i32 { return drawing_color.g}

ColorBlue :: proc() -> i32 { return drawing_color.b}

