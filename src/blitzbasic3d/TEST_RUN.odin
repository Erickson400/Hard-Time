package blitzbasic3d

import "core:fmt"
import ray "vendor:raylib"
import rl "vendor:raylib/rlgl"
import "core:os"


SCREEN_WIDTH :: 1270
SCREEN_HEIGHT :: 800

TAU :: cast(f32)ray.PI*2
STANRD_SIZE: f32 : 0.5


camera := ray.Camera3D{
	ray.Vector3{0, 0, 50},
	ray.Vector3{0, 0, 0},
	ray.Vector3{0, 1, 0},
	70,
	ray.CameraProjection.PERSPECTIVE,
}


ah :: proc() {
	ray.InitWindow(SCREEN_WIDTH, SCREEN_HEIGHT, "3ds")
	ray.SetTargetFPS(60)
}

run :: proc() {
	// model, err := load_model_3ds("assets/Block.3DS"); assert(err==nil)
	// model, err := load_model_3ds("assets/Model.3DS"); assert(err==nil)
	// model, err := load_model_3ds("assets/Plank.3DS"); assert(err==nil)


	quat := ray.Quaternion(1)
	angle: f32 = 0

	for !ray.WindowShouldClose() {
		delta := ray.GetFrameTime()
		ray.UpdateCamera(&camera, ray.CameraMode.FREE)
		ray.DisableCursor()
		ray.BeginDrawing()
		ray.ClearBackground(ray.DARKGRAY)
		ray.BeginMode3D(camera)
		angle += delta * 0.7


		ray.EndMode3D()
		ray.EndDrawing()
	}
}

destroy2 :: proc() {
	ray.CloseWindow()
}



is_behind_camera :: proc(point: ray.Vector3) -> bool {
	camera_dir := ray.Vector3Normalize(camera.position - camera.target)
	point_dir := ray.Vector3Normalize(camera.position - point)
	return ray.Vector3DotProduct(camera_dir, point_dir) < 0
}