package blitzbasic3d

import sdl "vendor:sdl3"
import "core:mem"
import "core:math"
import "core:fmt"
import "core:os"

JOYSTICK_DEADZONE :: 10_000		// -32768 (up/left) to 32767 (down/right).

@(private)
key_buffer: #sparse[sdl.Scancode]i32

@(private, rodata)
joystick_layout := [13]sdl.GamepadButton{
	0 = sdl.GamepadButton.INVALID,
	1 = sdl.GamepadButton.SOUTH,		// Attack
	2 = sdl.GamepadButton.WEST,			// Throw 
	3 = sdl.GamepadButton.EAST, 		// Defend
	4 = sdl.GamepadButton.NORTH,		// Pickup
	5..=12 = sdl.GamepadButton.INVALID,
}

@(private)
blitz_scancode_to_sdl_scancode :: proc(blitz_scancode: i32) -> sdl.Scancode {
	table := [?]sdl.Scancode {
		0 = sdl.Scancode.UNKNOWN,
		1 = sdl.Scancode.ESCAPE,
		2 = sdl.Scancode._1, 	 	 
		3 = sdl.Scancode._2, 	 	 
		4 = sdl.Scancode._3, 	 	 
		5 = sdl.Scancode._4, 	 	 
		6 = sdl.Scancode._5, 	 	 
		7 = sdl.Scancode._6, 	 	 
		8 = sdl.Scancode._7, 	 	 
		9 = sdl.Scancode._8, 	 	 
		10 = sdl.Scancode._9,
		11 = sdl.Scancode._0,
		12 = sdl.Scancode.MINUS,
		13 = sdl.Scancode.EQUALS,
		14 = sdl.Scancode.BACKSPACE,
		15 = sdl.Scancode.TAB,
		16 = sdl.Scancode.Q,
		17 = sdl.Scancode.W,
		18 = sdl.Scancode.E,
		19 = sdl.Scancode.R,
		20 = sdl.Scancode.T,
		21 = sdl.Scancode.Y,
		22 = sdl.Scancode.U,
		23 = sdl.Scancode.I,
		24 = sdl.Scancode.O,
		25 = sdl.Scancode.P,
		26 = sdl.Scancode.LEFTBRACKET,
		27 = sdl.Scancode.RIGHTBRACKET,
		28 = sdl.Scancode.RETURN,
		29 = sdl.Scancode.LCTRL,
		30 = sdl.Scancode.A,
		31 = sdl.Scancode.S,
		32 = sdl.Scancode.D,
		33 = sdl.Scancode.F,
		34 = sdl.Scancode.G,
		35 = sdl.Scancode.H,
		36 = sdl.Scancode.J,
		37 = sdl.Scancode.K,
		38 = sdl.Scancode.L,
		39 = sdl.Scancode.SEMICOLON,
		40 = sdl.Scancode.APOSTROPHE,
		41 = sdl.Scancode.GRAVE,
		42 = sdl.Scancode.LSHIFT,
		43 = sdl.Scancode.BACKSLASH,
		44 = sdl.Scancode.Z,
		45 = sdl.Scancode.X,
		46 = sdl.Scancode.C,
		47 = sdl.Scancode.V,
		48 = sdl.Scancode.B,
		49 = sdl.Scancode.N,
		50 = sdl.Scancode.M,
		51 = sdl.Scancode.COMMA,
		52 = sdl.Scancode.PERIOD,
		53 = sdl.Scancode.SLASH,
		54 = sdl.Scancode.RSHIFT,
		55 = sdl.Scancode.KP_MULTIPLY,
		56 = sdl.Scancode.LALT,
		57 = sdl.Scancode.SPACE,
		58 = sdl.Scancode.CAPSLOCK,
		59 = sdl.Scancode.F1,
		60 = sdl.Scancode.F2,
		61 = sdl.Scancode.F3,
		62 = sdl.Scancode.F4,
		63 = sdl.Scancode.F5,
		64 = sdl.Scancode.F6,
		65 = sdl.Scancode.F7,
		66 = sdl.Scancode.F8,
		67 = sdl.Scancode.F9,
		68 = sdl.Scancode.F10,
		69 = sdl.Scancode.NUMLOCKCLEAR,
		70 = sdl.Scancode.SCROLLLOCK,
		71 = sdl.Scancode.KP_7,
		72 = sdl.Scancode.KP_8,
		73 = sdl.Scancode.KP_9,
		74 = sdl.Scancode.KP_MINUS,
		75 = sdl.Scancode.KP_4,
		76 = sdl.Scancode.KP_5,
		77 = sdl.Scancode.KP_6,
		78 = sdl.Scancode.KP_PLUS,
		79 = sdl.Scancode.KP_1,
		80 = sdl.Scancode.KP_2,
		81 = sdl.Scancode.KP_3,
		82 = sdl.Scancode.KP_0,
		83 = sdl.Scancode.KP_DECIMAL,
		// OEM_102 	86 	On UK/Germany Keyboards
		// F11 	87 	 
		// F12 	88 	 
		// F13 	100 	(NEC PC98)
		// F14 	101 	(NEC PC98)
		// F15 	102 	(NEC PC98)
		// Kana 	112 	Japanese Keyboard
		// ABNT_C1 	115 	/? on Portugese (Brazilian) keyboards
		// Convert 	121 	Japanese Keyboard
		// NoConvert 	123 	Japanese Keyboard
		// Yen 	125 	Japanese Keyboard
		// ABNT_C2 	126 	Numpad . on Portugese (Brazilian) keyboards
		// Equals 	141 	= on numeric keypad (NEC PC98)
		// PrevTrack 	144 	Previous Track (DIK_CIRCUMFLEX on Japanese keyboard)
		// AT 	145 	(NEC PC98)
		// Colon (:) 	146 	(NEC PC98)
		// Underline 	147 	(NEC PC98)
		// Kanji 	148 	Japanese Keyboard
		// Stop 	149 	(NEC PC98)
		// AX 	150 	Japan AX
		// Unlabeled 	151 	(J3100)
		// Next Track 	153 	Next Track
		156 = sdl.Scancode.KP_ENTER,
		157 = sdl.Scancode.RCTRL,
		// Mute 	160 	Mute
		// Calculator 	161 	Calculator
		// Play/Pause 	162 	Play/Pause
		// Media Stop 	164 	Media Stop
		// Volume Down 	174 	Volume -
		// Volume Up 	176 	Volume +
		// Web Home 	178 	Web Home
		179 = sdl.Scancode.KP_COMMA,
		181 = sdl.Scancode.KP_DIVIDE,
		// SysReq 	183 	 
		184 = sdl.Scancode.RALT,
		// Pause 	197 	Pause
		199 = sdl.Scancode.HOME,
		200 = sdl.Scancode.UP,
		201 = sdl.Scancode.PAGEUP,
		203 = sdl.Scancode.LEFT,
		205 = sdl.Scancode.RIGHT,
		207 = sdl.Scancode.END,
		208 = sdl.Scancode.DOWN,
		// Next 	209 	Next Key on Arrow Keypad
		210 = sdl.Scancode.INSERT,
		211 = sdl.Scancode.DELETE,
		/// Left Windows 	219 	Left Windows Key
		/// Right Windows 	220 	Right Windows Key
		/// Apps 	221 	Apps Menu Key
		/// Power 	222 	System Power
		/// Sleep 	223 	System Sleep
		/// Wake 	227 	System Wake
		/// Web Search 	229 	 
		/// Web Favorites 	230 	 
		/// Web Refresh 	231 	 
		/// Web Stop 	232 	 
		/// Web Forward 	233 	 
		/// Web Back 	234 	 
		/// My Computer 	235 	 
		/// Mail 	236 	 
		/// Media Select 	237 	 
	}
	key := table[blitz_scancode]
	assert(key != sdl.Scancode.UNKNOWN, "This blitz scancode is unknown")
	return key
}

// Complicated, I need to create a text box with graphics.
Input :: proc(prompt: string) -> string {
	return "Player Name"
}

FlushKeys :: proc() {
	mem.set(rawptr(&key_buffer), 0, len(key_buffer)*size_of(i32))
}

KeyDown :: proc(scancode: i32) -> i32 {
	key_array := sdl.GetKeyboardState(nil)
	return cast(i32)key_array[blitz_scancode_to_sdl_scancode(scancode)]
}

KeyHit :: proc(scancode: i32) -> i32 {
	// Refresh input buffers
	e: ^sdl.Event
	for sdl.PollEvent(e) {
		if e.type == .KEY_DOWN {
			key_buffer[e.key.scancode] += 1
		}
		if e.type == .QUIT {
			os.exit(0)
		}
	}

	// Reset and return the specified scancode hit amount
	sdl_scancode := blitz_scancode_to_sdl_scancode(scancode)
	hits := key_buffer[sdl_scancode]
	key_buffer[sdl_scancode] = 0
	return hits
}

JoyYDir :: proc() -> i32 {
	gamepad_count: i32
	gamepad_ids := sdl.GetGamepads(&gamepad_count)
	if gamepad_count == 0 do return 0	// No gamepads connected
	y_axis := sdl.GetGamepadAxis(sdl.GetGamepadFromID(gamepad_ids[0]), .LEFTY)
	if math.abs(y_axis) > JOYSTICK_DEADZONE do return cast(i32)math.sign(y_axis)
	return 0
}

JoyXDir :: proc() -> i32 {
	gamepad_count: i32
	gamepad_ids := sdl.GetGamepads(&gamepad_count)
	if gamepad_count == 0 do return 0	// No gamepads connected
	x_axis := sdl.GetGamepadAxis(sdl.GetGamepadFromID(gamepad_ids[0]), .LEFTX)
	if math.abs(x_axis) > JOYSTICK_DEADZONE do return cast(i32)math.sign(x_axis)
	return 0
}

JoyDown :: proc(button: i32) -> i32 {
	gamepad_count: i32
	gamepad_ids := sdl.GetGamepads(&gamepad_count)
	if gamepad_count == 0 do return 0	// No gamepads connected
	gamepad := sdl.GetGamepadFromID(gamepad_ids[0])
	sdl_button := joystick_layout[button]
	if sdl_button == sdl.GamepadButton.INVALID do return 0
	return cast(i32)sdl.GetGamepadButton(gamepad, sdl_button)
}

MoveMouse :: proc(x, y: i32) {
	ok := sdl.WarpMouseGlobal(cast(f32)x, cast(f32)y)
	assert(ok, "Mouse warping is not supported")
}

MouseDown :: proc(button: i32) -> i32 {
	mouse_state := sdl.GetRelativeMouseState(nil, nil)
	if sdl.MouseButtonFlag.LEFT in mouse_state do return 1
	if sdl.MouseButtonFlag.MIDDLE in mouse_state do return 2
	if sdl.MouseButtonFlag.RIGHT in mouse_state do return 3
	fmt.panicf("Mouse button %d is not in the range of 1 - 3", button)
}

MouseXSpeed :: proc() -> i32 {
	x: f32
	_ = sdl.GetRelativeMouseState(&x, nil)
	return cast(i32)x
}

MouseYSpeed :: proc() -> i32 {
	y: f32
	_ = sdl.GetRelativeMouseState(nil, &y)
	return cast(i32)y
}

MouseX :: proc() -> i32 {
	x: f32
	w: i32
	_ = sdl.GetMouseState(&x, nil)
	_ = sdl.GetWindowSizeInPixels(window, &w, nil)
	return math.clamp(cast(i32)x, 0, w)
}

MouseY :: proc() -> i32 {
	y: f32
	h: i32
	_ = sdl.GetMouseState(nil, &y)
	_ = sdl.GetWindowSizeInPixels(window, nil, &h)
	return math.clamp(cast(i32)y, 0, h)
}

