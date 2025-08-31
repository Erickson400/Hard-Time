#+ignore
package blitzbasic3d

import ray "vendor:raylib"
import "core:encoding/json"
import "core:strings"
import "core:slice"
import "core:fmt"
import "core:log"
import "core:mem"
import "core:os"
import "core:io"

Error3ds :: enum u8 {
	No_Main,
}

Error :: union #shared_nil {
	os.Error,
	Error3ds,
}

// Note: These enums are ordered by number, not by position
// in the hierarchy, Even thought most of them follow that pattern.
ChunkType :: enum u16 {
	CHUNK_RGBF      				= 0x0010,
	CHUNK_RGBB      				= 0x0011,
	CHUNK_MAIN      				= 0x4D4D,
		CHUNK_SCENE        			= 0x3D3D,
			CHUNK_BKGCOLOR    		= 0x1200,
			CHUNK_AMBCOLOR  		= 0x2100,
			CHUNK_OBJECT  			= 0x4000,
				CHUNK_TRIMESH   	= 0x4100,
					CHUNK_VERTLIST  = 0x4110,
					CHUNK_FACELIST  = 0x4120,
					CHUNK_FACEMAT   = 0x4130,
					CHUNK_MAPLIST   = 0x4140,
					CHUNK_SMOOLIST  = 0x4150,
					CHUNK_TRMATRIX  = 0x4160,
				CHUNK_LIGHT     	= 0x4600,
					CHUNK_SPOTLIGHT = 0x4610,
				CHUNK_CAMERA    	= 0x4700,
		CHUNK_MATERIAL  			= 0xAFFF,
			CHUNK_MATNAME   		= 0xA000,
			CHUNK_AMBIENT   		= 0xA010,
			CHUNK_DIFFUSE   		= 0xA020,
			CHUNK_SPECULAR  		= 0xA030,
			CHUNK_TEXTURE   		= 0xA200,
			CHUNK_BUMPMAP   		= 0xA230,
			CHUNK_MAPFILE   		= 0xA300,
		CHUNK_KEYFRAMER 			= 0xB000,
			CHUNK_MESHINFO			= 0xB002,
				CHUNK_HIERPOS		= 0xB030,
				CHUNK_HIERINFO		= 0xB010,
			CHUNK_FRAMES      		= 0xB008
}

Object3ds :: struct {
	name: string,
	parent: ^Object3ds,
	transform: ray.Matrix,
	mesh: ray.Mesh,
	material_id: int, // Gets the mateiral from the model3ds
}

Model3ds :: struct {
	transform: ray.Matrix,
	objects: [dynamic]Object3ds,
	materials: [dynamic]ray.Material,
}


chunk_end: int = 0
parent_end: [dynamic]int
reader: io.Reader
logger_3ds: log.Logger


load_model_3ds :: proc(path: string, allocator := context.allocator) -> (result: ^Model3ds, err: Error) {
	// Open 3ds model file
	file := os.open(path) or_return
	defer os.close(file)
	reader = os.stream_from_handle(file)
	defer io.close(reader)

	// Setup logger
	file_for_logging := os.open("3ds_logs.txt", os.O_CREATE | os.O_WRONLY | os.O_TRUNC, 0o600) or_return
	defer os.close(file_for_logging)
	logger_3ds = log.create_file_logger(file_for_logging)
	context.logger = logger_3ds
	defer log.destroy_file_logger(logger_3ds)

	parent_end = make([dynamic]int, 0, 10)
	defer delete(parent_end)
	
	main_id: u16
	main_length: u32
	io.read(reader, mem.ptr_to_bytes(&main_id))
	io.read(reader, mem.ptr_to_bytes(&main_length))
	if main_id != cast(u16)ChunkType.CHUNK_MAIN do return nil, Error3ds.No_Main
	chunk_end = cast(int)main_length
	
	// Setup model
	model := new(Model3ds)
	model.materials = make([dynamic]ray.Material, 1, 1)
	model.materials[0] = ray.LoadMaterialDefault()
	model.objects = make([dynamic]Object3ds, 0, 1)

	enter_chunk()
	for id := next_chunk(); id != 0; id = next_chunk(){
		#partial switch cast(ChunkType)id {
			case .CHUNK_SCENE:
				parse_scene(model)
		}
	}
	leave_chunk()
	return model, nil
}


enter_chunk :: proc() {
	append(&parent_end, chunk_end)
	_chunk_end, err := io.seek(reader, 0, io.Seek_From.Current); assert(err==nil)
	chunk_end = int(_chunk_end)
}


leave_chunk :: proc() {
	chunk_end = pop(&parent_end)
}


next_chunk :: proc() -> u16 {
	io.seek(reader, cast(i64)chunk_end, io.Seek_From.Start)
	if chunk_end == parent_end[len(parent_end) - 1] do return 0
	id: u16
	length: u32
	io.read(reader, mem.ptr_to_bytes(&id))
	io.read(reader, mem.ptr_to_bytes(&length))
	current, err := io.seek(reader, 0, io.Seek_From.Current); assert(err==nil)
	chunk_end =  cast(int)current + cast(int)length - 6
	return id
}


parse_scene :: proc(model: ^Model3ds) {
	enter_chunk()
	for id := next_chunk(); id != 0; id = next_chunk(){
		#partial switch cast(ChunkType)id {
			case .CHUNK_OBJECT:
				append(&model.objects, parse_object(model))
				log.log(log.Level.Debug, "Found Object")
		}
	}
	leave_chunk()
}



parse_object :: proc(model: ^Model3ds) -> Object3ds {
	object := Object3ds{
		name = parse_string()
	}

	enter_chunk()
	for id := next_chunk(); id != 0; id = next_chunk() {
		#partial switch cast(ChunkType)id {
			case .CHUNK_TRIMESH:
				// parse_tri_mesh(&meshes[len(meshes) - 1])
				
				log.log(log.Level.Debug, object.name)
			}
	}
	leave_chunk()
	return object
}


parse_string :: proc() -> string {
	bytes := make([dynamic]u8, 0, 10)
	c: u8
	io.read(reader, mem.ptr_to_bytes(&c))
	for c != 0 {
		append(&bytes, c)
		io.read(reader, mem.ptr_to_bytes(&c))
	}
	return string(bytes[:])
}


parse_tri_mesh :: proc(mesh: ^ray.Mesh) {
	enter_chunk()
	for id := next_chunk(); id != 0; id = next_chunk(){
		#partial switch cast(ChunkType)id {
			case .CHUNK_VERTLIST:
				parse_vert_list(mesh)
			case .CHUNK_MAPLIST:
				parse_map_list(mesh)
			case .CHUNK_FACELIST:
				parse_face_list(mesh)
		}
	}
	leave_chunk()
	normals := make([dynamic]f32, 0, 100, ray.MemAllocator())
	for i in 0..<mesh.vertexCount {
		append(&normals, 0, 1, 0)
	}
	mesh.normals = cast([^]f32)raw_data(normals)
}


parse_vert_list :: proc(mesh: ^ray.Mesh) {
	cnt: u16
	_, err := io.read(reader, mem.ptr_to_bytes(&cnt)); assert(err==nil)
	vertices := make([dynamic]f32, 0, 100, ray.MemAllocator())
	for cnt != 0 {
		vertex: [3]f32
		io.read(reader, slice.reinterpret([]u8, vertex[:]))
		append(&vertices, vertex[0], vertex[1], vertex[2])
		// fmt.println(32-cnt, ": ", vertex[0], vertex[1], vertex[2])
		cnt -= 1
	}
	mesh.vertexCount = cast(i32)len(vertices)/3
	mesh.vertices = cast([^]f32)raw_data(vertices)
}


parse_map_list :: proc(mesh: ^ray.Mesh) {
	cnt: u16
	_, err := io.read(reader, mem.ptr_to_bytes(&cnt)); assert(err==nil)
	uvs1 := make([dynamic]f32, 0, 100, ray.MemAllocator())
	uvs2 := make([dynamic]f32, 0, 100, ray.MemAllocator())
	for k in 0..<cnt {
		uv: [2]f32
		io.read(reader, slice.reinterpret([]u8, uv[:]))
		append(&uvs1, uv[0], 1 - uv[1])
		append(&uvs2, uv[0], 1 - uv[1])
	}
	mesh.texcoords = cast([^]f32)raw_data(uvs1)
	mesh.texcoords2 = cast([^]f32)raw_data(uvs2)
}


parse_face_list :: proc(mesh: ^ray.Mesh) {
	cnt: u16
	_, err := io.read(reader, mem.ptr_to_bytes(&cnt)); assert(err==nil)
	indices := make([dynamic]u16, 0, 100, ray.MemAllocator())
	for cnt != 0 {
		cnt -= 1
		v: [4]u16
		io.read(reader, slice.reinterpret([]u8, v[:]))
		append(&indices, v[0], v[1], v[2])
		// fmt.println(11 - cnt, ": ", v[0], v[1], v[2])
		mesh.triangleCount += 1
	}

	enter_chunk()
	for id := next_chunk(); id != 0; id = next_chunk(){
		#partial switch cast(ChunkType)id {
			case .CHUNK_FACEMAT:
				// Skipped
		}
	}
	leave_chunk()
	mesh.indices = cast([^]u16)raw_data(indices)
}