package blitzbasic3d

import sdl "vendor:sdl3"
import mix "vendor:sdl3/mixer"
import "core:fmt"
import "core:strings"

Sound :: struct {
	name: string,
	audio: ^mix.Audio,
	volume: f32,
	pitch: i32,
	loop: bool,
}

Channel :: mix.Track

mixer_device: ^mix.Mixer

init_audio :: proc() {
	ok := mix.Init(); assert(ok)
	mixer_device = mix.CreateMixerDevice(sdl.AUDIO_DEVICE_DEFAULT_PLAYBACK, nil)
	assert(mixer_device != nil)
}

destroy_audio :: proc() {
	mix.DestroyMixer(mixer_device)
}

LoadSound :: proc(filename: string) -> ^Sound {
	path, err := strings.concatenate({"assets/", filename}); assert(err==nil)
	defer delete(path)
	audio := mix.LoadAudio(mixer_device, strings.unsafe_string_to_cstring(path), true)
	if audio == nil {
		fmt.panicf("Could not load audio file for: %s", path)
	}
	sound := new(Sound)
	sound.audio = audio
	sound.volume = 1
	sound.pitch = 22050
	sound.loop = false
	sound.name = filename
	return sound
}

Load3DSound :: LoadSound

SoundVolume :: proc(sound: ^Sound, volume: f32) {
	sound.volume = volume
}

SoundPitch :: proc(sound: ^Sound, pitch: i32) {
	sound.pitch = pitch
}

LoopSound :: proc(sound: ^Sound) {
	sound.loop = true
}

PlaySound :: proc(sound: ^Sound) -> ^Channel {
	fmt.printf("Playing Sound %s %d %f \n", sound.name, sound.pitch, sound.volume)
	channel := mix.CreateTrack(mixer_device)
	ok := mix.SetTrackAudio(channel, sound.audio); assert(ok)
	// ok = mix.SetTrackGain(channel, sound.volume); assert(ok)
	loops: i32 = -1 if sound.loop else 0
	ok = mix.SetTrackLoops(channel, loops); assert(ok)
	// ok = mix.SetTrackFrequencyRatio(channel, 1); assert(ok)
	ok = mix.SetTrackFrequencyRatio(channel, f32(sound.pitch)/22050.0); assert(ok)
	ok = mix.PlayTrack(channel, 0); assert(ok)
	return channel
}

ChannelPlaying :: proc(channel: ^Channel) -> i32 {
	return i32(mix.TrackPlaying(channel))
}

ChannelVolume :: proc(channel: ^Channel, volume: f32) {
	ok := mix.SetTrackGain(channel, volume); assert(ok)
}

StopChannel :: proc(channel: ^Channel) {
	ok := mix.StopTrack(channel, 0); assert(ok)
}

