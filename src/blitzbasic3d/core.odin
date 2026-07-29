package blitzbasic3d

import sdl "vendor:sdl3"

Init :: proc() {
	sdl.SetHint(sdl.HINT_VIDEO_DRIVER, "x11")
	ok := sdl.Init({.VIDEO, .AUDIO, .GAMEPAD}); assert(ok)
	init_graphics()
}


Destroy :: proc() {
	destroy_graphics()
	sdl.Quit()
}

