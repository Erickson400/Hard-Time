package blitzbasic3d

import sdl "vendor:sdl3"
import "core:math"
import "core:mem"
import "core:container/queue"

GfxMode3DExists :: proc(width, height, depth: i32) -> i32 {
	return 1 // Legacy feature for old hardware
}

window: ^sdl.Window
gpu_device: ^sdl.GPUDevice
TRANSFER_BUFFER_SIZE :: 64 * mem.Megabyte
transfer_buffer: ^sdl.GPUTransferBuffer

init_graphics :: proc() {
	window = sdl.CreateWindow("Hard Time", 800, 600, {.VULKAN}); assert(window != nil)
	gpu_device = sdl.CreateGPUDevice({.SPIRV}, true, "vulkan")
	ok := sdl.ClaimWindowForGPUDevice(gpu_device, window); assert(ok)
	transfer_buffer = sdl.CreateGPUTransferBuffer(gpu_device, {
		usage = .UPLOAD,
		size = TRANSFER_BUFFER_SIZE,
	})
}

destroy_graphics :: proc() {
	sdl.ReleaseGPUTransferBuffer(gpu_device, transfer_buffer)
	sdl.ReleaseWindowFromGPUDevice(gpu_device, window)
	sdl.DestroyGPUDevice(gpu_device)
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

// RenderWorld also flushes the 2D draw queue, but 3D geometry will be rendered on top of it.
canvas: ^sdl.GPUTexture
draw_queue: queue.Queue(DrawCall)

DrawCall :: union {
	RenderCls,
	RenderLine,
	RenderRect,
	RenderTileImage,
	RenderDrawImage,
	RenderGrabImage,
}

RenderCls :: struct {
	color: [3]i32,
}

RenderLine :: struct {
	p1x, p1y, p2x, p2y: i32,
}

RenderRect :: struct {
	x, y, width, height, color: i32,
}

RenderTileImage :: struct {
	image: ^Image,
}

RenderDrawImage :: struct {
	image: ^Image,
	x, y: i32,
}

RenderGrabImage :: struct {
	image: ^Image,
	x, y, frame: i32,
}

Cls :: proc() {
	queue.enqueue(&draw_queue, RenderCls{drawing_color})
}

Line :: proc(p1x, p1y, p2x, p2y: i32) {
	queue.enqueue(&draw_queue, RenderLine{p1x, p1y, p2x, p2y})
}

TileImage :: proc(image: ^Image) {
	queue.enqueue(&draw_queue, RenderTileImage{image})
}

DrawImage :: proc(image: ^Image, x, y: i32) {
	queue.enqueue(&draw_queue, RenderDrawImage{image, x, y})
}

Rect :: proc(x, y, width, height, color: i32) {
	queue.enqueue(&draw_queue, RenderRect{x, y, width, height, color})
}

GrabImage :: proc(image: ^Image, x, y: i32, frame: i32 = 0) {
	queue.enqueue(&draw_queue, RenderGrabImage{image, x, y, frame})
}
