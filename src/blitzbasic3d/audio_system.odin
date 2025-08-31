#+private
package blitzbasic3d

import ray "vendor:raylib"
import "core:strings"
import "core:log"
import "core:fmt"

SoundResource :: struct {
	sound: ray.Sound,
	path: string,
	use_3d: bool,
}

loaded_sounds: [dynamic]^SoundResource


init_audio_system :: proc() {
	loaded_sounds = make([dynamic]^SoundResource, 0, 10)
}


destroy_audio_system :: proc() {
	for &ls in loaded_sounds {
		if ls == nil do continue
		ray.UnloadSound(ls.sound)
		delete(ls.path)
		free(ls)
		ls = nil
	}
	delete(loaded_sounds)
}


load_sound :: proc(filename: string, use_3d: bool) -> SoundHandle {
	path, err := strings.concatenate({"assets/", filename}); assert(err==nil)

	// Check if path is already loaded
	for ls, index in loaded_sounds {
		if ls == nil do continue
		if ls.path == path {
			log.warnf("Sound: '%s' is already loaded", path)
			return SoundHandle(index)
		}
	}

	cstring_path := strings.clone_to_cstring(path)
	defer delete(cstring_path)

	sound := new(SoundResource)
	sound.sound = ray.LoadSound(cstring_path)
	sound.path = path
	sound.use_3d = use_3d
	error_string := fmt.aprintf("Failed to load sound: %s", path)
	assert(ray.IsSoundValid(sound.sound), error_string)
	delete(error_string)
	
	// Find an empty slot
	found_empty_slot := false
	slot_used := -1
	for i in 0..<len(loaded_sounds) {
		if loaded_sounds[i] == nil {
			loaded_sounds[i] = sound
			slot_used = i
			found_empty_slot = true
			break
		}
	}

	if !found_empty_slot {
		append(&loaded_sounds, sound)
		slot_used = len(loaded_sounds) - 1
	}

	return SoundHandle(slot_used)
}


is_sound_handle_valid :: proc(handle: SoundHandle) -> bool {
	if handle == -1 do return false
	if cast(int)handle >= len(loaded_sounds) do return false
	if loaded_sounds[handle] == nil do return false
	return true
}