package blitzbasic3d

import sdl "vendor:sdl3"

Init :: proc() {
	sdl.SetHint(sdl.HINT_VIDEO_DRIVER, "x11")
	ok := sdl.Init(sdl.INIT_VIDEO); assert(ok)
}

Destroy :: proc() {
	sdl.Quit()
}

