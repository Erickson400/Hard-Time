package main

import "core:fmt"
import "core:mem"
import bb "blitzbasic3d"

////////////////////////////////////////////////////////////////////////////////
//------------------------------ HARD TIME: WORLD ------------------------------
////////////////////////////////////////////////////////////////////////////////

SetCollisions :: proc() {
	// entity physics
	for count in i32(10)..=11 {
		bb.Collisions(1, count, 2, 3) // humans >>> scenery
		bb.Collisions(2, count, 2, 3) // shadows >>> scenery
		bb.Collisions(3, count, 2, 1) // weapon models >>> scenery
		bb.Collisions(4, count, 2, 1) // weapon pivots >>> scenery
	}
	// camera physics
	bb.Collisions(5, 10, 2, 3) // camera >>> scenery
}


//--------------------------------------------------------------------
/////////////////////////// LOAD TERRAIN /////////////////////////////
//--------------------------------------------------------------------
LoadWorld :: proc() {
	arena_mem := make([]byte, 1 * mem.Kilobyte)
	defer delete(arena_mem)
	arena: mem.Arena
	mem.arena_init(&arena, arena_mem)
	arena_alloc := mem.arena_allocator(&arena)

	// Prison block
	if GetBlock(gamLocation[slot]) > 0 {
		world = bb.LoadAnimMesh("World/Block/Block.3ds")
		bb.EntityType(world, 10, 1)
		bb.Animate(world, 3, 10)
		cellLocked[gamLocation[slot]][0] = 0
		for count in i32(1)..=20 {
			digit := Dig(count,10)
			switch gamLocation[slot] {
			case 1:
				bb.EntityTexture(bb.FindChild(world, fmt.aprint("Plate", digit, allocator = arena_alloc)), tBlock[1], 0, 2)
			case 3:
				bb.EntityTexture(bb.FindChild(world, fmt.aprint("Plate", digit, allocator = arena_alloc)), tBlock[2], 0, 2)
			case 5:
				bb.EntityTexture(bb.FindChild(world, fmt.aprint("Plate", digit, allocator = arena_alloc)), tBlock[3], 0, 2)
			case 7:
				bb.EntityTexture(bb.FindChild(world, fmt.aprint("Plate", digit, allocator = arena_alloc)), tBlock[4], 0, 2)
			}
			bb.EntityTexture(bb.FindChild(world, fmt.aprint("Plate", digit, allocator = arena_alloc)), tCell[count], 0, 3)
			bb.EntityType(bb.FindChild(world, fmt.aprint("Door", digit, allocator = arena_alloc)), 11, 0)
			bb.EntityType(bb.FindChild(world, fmt.aprint("Plate", digit, allocator = arena_alloc)), 11, 0)
			bb.EntityType(bb.FindChild(world, fmt.aprint("Bars", digit, allocator = arena_alloc)), 11, 0)
			cellLocked[gamLocation[slot]][count] = 0
			delete(digit)
		}
		bb.EntityTexture(bb.FindChild(world, "Sign01"), tSign[9], 0, 2)
		bb.EntityTexture(bb.FindChild(world, "Sign02"), tSign[gamLocation[slot]], 0, 2)
		no_chars, no_beds, no_doors = 0, 20, 1
		sAtmos = bb.LoadSound("Sound/Ambience/Quiet.wav")
		mem.arena_free_all(&arena)
	}
	// Exercise yard
	if gamLocation[slot] == 2 {
		world = bb.LoadAnimMesh("World/Yard/Yard.3ds")
		bb.EntityType(world, 10, 1)
		bb.EntityTexture(bb.FindChild(world, "Sign01"), tSign[9], 0, 2)
		bb.EntityTexture(bb.FindChild(world, "Net"), tNet)
		bb.EntityType(bb.FindChild(world, "Net"), 0)
		bb.EntityType(bb.FindChild(world, "Rim"), 0)
		for count in i32(1)..=2 {
			bb.EntityTexture(bb.FindChild(world, fmt.aprint("Fence0", Dig(count,10, arena_alloc), allocator = arena_alloc)), tFence)
		}
		no_chars, no_beds, no_doors = 6, 0, 1
		sAtmos = bb.LoadSound("Sound/Ambience/Yard.wav")
	}
	// Study
	if gamLocation[slot] == 4 {
		world = bb.LoadAnimMesh("World/Study/Study.3ds")
		bb.EntityType(world, 10, 1)
		bb.EntityTexture(bb.FindChild(world, "Sign01"), tSign[9], 0, 2)
		bb.EntityTexture(bb.FindChild(world, "Sign02"), tSign[10], 0, 2)
		bb.EntityFX(bb.FindChild(world, "Screen"), 9)
		no_chars, no_beds, no_doors = 5, 0, 2
		sAtmos = bb.LoadSound("Sound/Ambience/Quiet.wav")
	}
	// Hospital
	if gamLocation[slot] == 6 {
		world = bb.LoadAnimMesh("World/Hospital/Hospital.3ds")
		bb.EntityType(world, 10, 1)
		bb.EntityTexture(bb.FindChild(world, "Sign01"), tSign[9], 0, 2)
		bb.EntityTexture(bb.FindChild(world, "Sign02"), tSign[11], 0, 2)
		bb.EntityFX(bb.FindChild(world, "Screen"), 9)
		for count in i32(1)..=4 {
			digit := Dig(count,10)
			bb.EntityAlpha(bb.FindChild(world, fmt.aprint("Beaker0", digit, allocator = arena_alloc)), 0.7)
			bb.EntityAlpha(bb.FindChild(world, fmt.aprint("Water0", digit, allocator = arena_alloc)), 0.5)
			delete(digit)
		}
		no_chars, no_beds, no_doors = 9, 3, 2
		sAtmos = bb.LoadSound("Sound/Ambience/Hall.wav")
		mem.arena_free_all(&arena)
	}
	// Kitchen
	if gamLocation[slot] == 8 {
		world = bb.LoadAnimMesh("World/Kitchen/Kitchen.3ds")
		bb.EntityType(world, 10, 1)
		bb.EntityTexture(bb.FindChild(world, "Sign01"), tSign[9], 0, 2)
		for count in i32(1)..=4 {
			bb.EntityAlpha(bb.FindChild(world, fmt.aprint("Window0", Dig(count,10, arena_alloc), allocator = arena_alloc)), 0.5)
		}
		for tray in i32(1)..=50 {
			trayOldState[tray] = -1
		}
		no_chars, no_beds, no_doors = 45, 0, 1
		sAtmos = bb.LoadSound("Sound/Ambience/Canteen.wav")
		mem.arena_free_all(&arena)
	}
	// Main hall
	if gamLocation[slot] == 9 {
		world = bb.LoadAnimMesh("World/Hall/Hall.3ds")
		bb.EntityType(world, 10, 1)
		for count in i32(1)..=8 {
			bb.EntityTexture(bb.FindChild(world, fmt.aprint("Sign", Dig(count,10, arena_alloc), allocator = arena_alloc)), tSign[count], 0, 2)
		}
		for count in i32(1)..=9 {
			bb.EntityShininess(bb.FindChild(world, fmt.aprint("Ball", Dig(count,10, arena_alloc), allocator = arena_alloc)), 1.0)
		}
		bb.EntityFX(bb.FindChild(world, "TV"), 9)
		bb.EntityFX(bb.FindChild(world, "Screen"), 9)
		for count in i32(1)..=4 {
			digit := Dig(count,10)
			bb.EntityAlpha(bb.FindChild(world, fmt.aprint("Alarm", digit, allocator = arena_alloc)), 0.8)
			bb.EntityShininess(bb.FindChild(world, fmt.aprint("Alarm", digit, allocator = arena_alloc)), 1.0)
			bb.EntityColor(bb.FindChild(world, fmt.aprint("Alarm", digit, allocator = arena_alloc)), 5, 0, 0)
			bb.EntityShininess(bb.FindChild(world, fmt.aprint("Phone", digit, allocator = arena_alloc)), 1.0)
			phoneX[count] = bb.EntityX(bb.FindChild(world, fmt.aprint("Phone", digit, allocator = arena_alloc)), 1)
			phoneY[count] = bb.EntityY(bb.FindChild(world, fmt.aprint("Phone", digit, allocator = arena_alloc)), 1)
			phoneZ[count] = bb.EntityZ(bb.FindChild(world, fmt.aprint("Phone", digit, allocator = arena_alloc)), 1)
			delete(digit)
		}
		no_chars, no_beds, no_doors = 8, 0, 8
		sAtmos = bb.LoadSound("Sound/Ambience/Hall.wav")
		mem.arena_free_all(&arena)
	}
	// Workshop
	if gamLocation[slot] == 10 {
		world = bb.LoadAnimMesh("World/Workshop/Workshop.3ds")
		bb.EntityType(world, 10, 1)
		bb.EntityTexture(bb.FindChild(world, "Sign01"), tSign[4], 0, 2)
		no_chars, no_beds, no_doors = 6, 0, 1
		for cyc in i32(1)..=6 {
			kit[cyc] = bb.LoadAnimMesh(fmt.aprint("Weapons/", weapFile[kitType[cyc]], " Kit.3ds", allocator = arena_alloc))
			bb.ScaleEntity(kit[cyc], 0.4, 0.4, 0.4)
			limb := bb.FindChild(world, fmt.aprint("Table", Dig(cyc,10, arena_alloc), allocator = arena_alloc))
			bb.PositionEntity(kit[cyc], bb.EntityX(limb, 1), bb.EntityY(limb, 1), bb.EntityZ(limb, 1))
			if cyc >= 5 {
				bb.RotateEntity(kit[cyc], 0, 90, 0)
			}
			if weapTex[kitType[cyc]] != nil {
				for count in i32(1)..=bb.CountChildren(kit[cyc]) {
					bb.EntityTexture(bb.GetChild(kit[cyc], count), weapTex[kitType[cyc]])
				}
			}
			if kitState[cyc] == 0 do bb.HideEntity(kit[cyc])
		}
		sAtmos = bb.LoadSound("Sound/Ambience/Quiet.wav")
		mem.arena_free_all(&arena)
	}
	// Toilets
	if gamLocation[slot] == 11 {
		world = bb.LoadAnimMesh("World/Toilets/Toilets.3ds")
		bb.EntityType(world, 10, 1)
		bb.EntityTexture(bb.FindChild(world, "Sign01"), tSign[6], 0, 2)
		for count in i32(1)..=5 {
			bb.EntityType(bb.FindChild(world, fmt.aprint("Door", Dig(count,10, arena_alloc), allocator = arena_alloc)), 11, 0)
			bb.EntityAlpha(bb.FindChild(world, fmt.aprint("Water", Dig(count,10, arena_alloc), allocator = arena_alloc)), 0.5)
		}
		for count in i32(1)..=4 {
			bb.EntityType(bb.FindChild(world, fmt.aprint("Shower", Dig(count,10, arena_alloc), allocator = arena_alloc)), 0, 0)
			bb.EntityTexture(bb.FindChild(world, fmt.aprint("Shower", Dig(count,10, arena_alloc), allocator = arena_alloc)), tShower)
			bb.EntityAlpha(bb.FindChild(world, fmt.aprint("Shower", Dig(count,10, arena_alloc), allocator = arena_alloc)), 0.6)
		}
		no_chars, no_beds, no_doors = 5, 0, 1
		sAtmos = bb.LoadSound("Sound/Ambience/Bathroom.wav")
		mem.arena_free_all(&arena)
	}
	// Reset screen
	wOldScreen = -1
}


//--------------------------------------------------------------------
////////////////////////// LOAD ATMOSPHERE ///////////////////////////
//--------------------------------------------------------------------
LoadAtmos :: proc() {
	// CAMERA(S)
	cam = bb.CreateCamera()
	bb.CameraViewport(cam, 0, 0, bb.GraphicsWidth(), bb.GraphicsHeight())
	bb.EntityType(cam, 5, 0)
	bb.EntityRadius(cam, 5)
	bb.PositionEntity(cam, camX, camY, camZ)
	camType = 1
	// pivot
	camPivot = bb.CreatePivot()
	bb.PositionEntity(camPivot, camPivX, camPivY, camPivZ)
	// fog effect
	if gamLocation[slot] == 2 do bb.CameraRange(cam, 1, 2000)
	bb.CameraFogMode(cam, optFog)
	bb.CameraFogRange(cam, 400, 1000)
	switch gamLocation[slot] {
	case 4, 6, 10, 11: 
		bb.CameraFogRange(cam, 250, 1000)
	}
	// additional
	if screen == 50 {
		range: f32 = 0.02
		camListener = bb.CreateListener(cam, range, range, range)
	}
	dummy = bb.CreatePivot()
	// lighting
	LoadLighting()
}


LoadLighting :: proc() {
	// use lights in scene
	no_lights = 0
	for count in i32(1)..=10 {
		digit := Dig(count,10, context.allocator)
		light_string := fmt.aprint("Light", digit)
		limb := bb.FindChild(world, light_string)
		if limb > 0 {
			no_lights += 1
			light[no_lights] = bb.CreateLight(3)
			bb.PositionEntity(light[no_lights], bb.EntityX(limb, 1), bb.EntityY(limb, 1), bb.EntityZ(limb, 1))
			bb.RotateEntity(light[no_lights], 90, 0, 0)
			bb.LightRange(light[no_lights], 500)
			bb.LightConeAngles(light[no_lights], 0, 135)
			bb.EntityFX(limb, 9)
			bb.EntityShininess(limb, 1.0)
		}
		delete(digit)
		delete(light_string)
	}
	// last resort
	if no_lights == 0 {
		no_lights = 1
		light[no_lights] = bb.CreateLight(1)
	}
}


//--------------------------------------------------------------------
////////////////////// MANAGE ATMOSPHERE /////////////////////////////
//--------------------------------------------------------------------
ManageAtmos :: proc() {
	// time scale
	gamSpeed[slot] = 1
	if gamPromo == 0 {
		if pAnim[camFoc] == 92 || pAnim[camFoc] == 132 do gamSpeed[slot] = 5
		if pAnim[camFoc] == 102 && OnComputer(camFoc) == 0 do gamSpeed[slot] = 5
		if pAnim[camFoc] == 103 do gamSpeed[slot] = 20
	}
	// increment time
	gamSecs[slot] += gamSpeed[slot]
	if gamSecs[slot] >= 60 {
		gamMins[slot] += 1
		gamSecs[slot] = 0
	}
	if gamMins[slot] >= 60 {
		gamHours[slot] += 1
		gamMins[slot] = 0
	}
	if gamHours[slot] >= 24 {
		for char in i32(1)..=no_chars {
			charExperience[char] += 1
			charSentence[char] -= 1
			if charSentence[char] < 0 do charSentence[char] = 0
			if char != gamChar[slot] && charLocation[char] > 0 {
				v := bb.RndI(1, no_chars)
				if char != v  { 
					// NOTE: Likely a bug. Functions in Basic that don't return a value
					// are interpreted as returning 0 if assigned to a variable.
					// In this code it overwrites the charRelation element to 0 since ChangeRelationship
					// returns nothing. The intended code might've been calling ChangeRelationship
					// without the assignment.

					//ChangeRelationship(char, v, bb.RndI(-1, 1))
					charRelation[char][v] = 0
				}
				charStrength[char] += bb.RndI(-2, 2)
				charAgility[char] += bb.RndI(-2, 2)
				if charRole[char] == 1 {
					charHappiness[char] = bb.RndI(50, 100)
				} else {
					charHappiness[char] = bb.RndI(10, 100)
				}
				charIntelligence[char] += bb.RndI(-2, 2)
				charReputation[char] += bb.RndI(-2, 2)
				LimitStats(char)
			}
		}
		gamHours[slot] = 0
		statTim[6] = 100
	}
	// lock/open cells
	if gamMins[slot] == 0 && gamSecs[slot] == 0 {
		if gamHours[slot] == 7 {
			ProduceSound(cam, sBuzzer, 22050, 1)
			statTim[5] = 50
			if gamPromo == 0 && pAnim[gamPlayer[slot]] == 103 {
				TriggerPromo(0, 0, 26)
			}
		}
		if gamHours[slot] == 22 {
			ProduceSound(cam, sBuzzer, 22050, 1)
			statTim[5] = 50
			if InsideCell(pX[gamPlayer[slot]], pY[gamPlayer[slot]], pZ[gamPlayer[slot]]) != charCell[gamChar[slot]] || 
			gamLocation[slot] != TranslateBlock(charBlock[gamChar[slot]]) {
				if gamPromo == 0 && pAnim[gamPlayer[slot]] != 76 && pAnim[gamPlayer[slot]] != 77 {
					TriggerPromo(0, 0, 25)
				}
			}
		}
	}
	if GetBlock(gamLocation[slot]) > 0 {
		if (LockDown() == 0 || LockReady(gamLocation[slot]) == 0) && cellLocked[gamLocation[slot]][0] == 1 do LockCells(0)
		if LockDown() > 0 && LockReady(gamLocation[slot]) > 0 && cellLocked[gamLocation[slot]][0] == 0 do LockCells(1)
	}
	// serve dinner
	if gamHours[slot] == 13 && gamMins[slot] == 0 && gamSecs[slot] == 0 {
		ProduceSound(cam, sBell, 22050, 1)
		statTim[5] = 50
		if gamPromo == 0 && pAnim[gamPlayer[slot]] != 76 && pAnim[gamPlayer[slot]] != 77 {
			if gamLocation[slot] != 8 || pSeat[gamPlayer[slot]] == 0 do TriggerPromo(0, 0, 27)
		}
		for tray in i32(1)..=50 {
			trayState[tray] = bb.RndI(1, 7)
		}
	}
	// eat into trays
	if gamHours[slot] != 13 && gamMins[slot] == 0 && gamSecs[slot] == 0 {
		for tray in i32(1)..=50 {
			if tray != pSeat[gamPlayer[slot]] || gamLocation[slot] != 8 {
				trayState[tray] -= 1
			}
			if trayState[tray] < 0 do trayState[tray] = 0
		}

	}
	// morning effects
	if gamHours[slot] == 7 && gamMins[slot] == 0 && gamSecs[slot] == 0 {
		// NOTE: Likely a bug. Mat uses the cyc local variable again at the last loop
		// of this if statement. Any variable used in a Basic function becomes a local variable
		// of that function. Technically its shadowing. After the loop below finishes using cyc, it will be 6 till the
		// function exits. I made a variable called cyc2 to replicate this behaviour.
		// The intended code might've been to use the v index instead of cyc for the last loop
		// in this scope.
		
		cyc2: i32
		for cyc in i32(1)..=6 {
			for {
				kitType[cyc] = bb.RndI(1, weapList)
				if weapCreate[kitType[cyc]] == 1 do break
			}
			randy := bb.RndI(0, 2)
			kitState[cyc] = 1 if randy <= 1 else 0
			cyc2 = cyc
		}
		for char in i32(1)..=no_chars {
			if char != gamChar[slot] && charLocation[char] > 0 {
				charHealth[char] += bb.RndI(10, 100)
				if charHealth[char] > 100 do charHealth[char] = 100
				randy := bb.RndI(0, 10000)
				if randy == 0 && charInjured[char] == 0 do charInjured[char] = bb.RndI(1000, 80000)
			}
		}
		for v in 1..=no_plays {
			if pChar[v] != gamChar[slot] {
				pHealth[v] = charHealth[pChar[cyc2]]
				pInjured[v] = charInjured[pChar[cyc2]]
			}
		}
	}
	// day properties
	if gamHours[slot] >= 10 && gamHours[slot] <= 16 {
		ambTR, ambTG, ambTB = 200.0, 200.0, 200.0
		lightTR, lightTG, lightTB = 220.0, 210.0, 200.0
		atmosTR, atmosTG, atmosTB = 200.0, 200.0, 240.0
		skyTR, skyTG, skyTB = 255.0, 255.0, 255.0
		if gamLocation[slot] != 2 do atmosTR, atmosTG, atmosTB = 160.0, 130.0, 100.0
	}
	// dusk/dawn properties
	if (gamHours[slot] >= 7 && gamHours[slot] <= 9) || (gamHours[slot] >= 17 && gamHours[slot] <= 19) {
		ambTR, ambTG, ambTB = 200.0, 190.0, 170.0
		lightTR, lightTG, lightTB = 200.0, 180.0, 160.0
		atmosTR, atmosTG, atmosTB = 160.0, 130.0, 100.0
		skyTR, skyTG, skyTB = 220.0, 200.0, 180.0
	}
	// twilight properties
	if (gamHours[slot] >= 20 && gamHours[slot] <= 22) || (gamHours[slot] >= 4 && gamHours[slot] <= 6) {
		ambTR, ambTG, ambTB = 150.0, 150.0, 150.0
		lightTR, lightTG, lightTB = 100.0, 100.0, 100.0
		atmosTR, atmosTG, atmosTB = 110.0, 100.0, 120.0
		skyTR, skyTG, skyTB = 140.0, 140.0, 160.0
	}
	// night properties
	if gamHours[slot] >= 23 || gamHours[slot] <= 3 {
		ambTR, ambTG, ambTB = 80.0, 80.0, 80.0
		lightTR, lightTG, lightTB = 50.0, 50.0, 50.0
		atmosTR, atmosTG, atmosTB = 40.0, 40.0, 70.0
		skyTR, skyTG, skyTB = 80.0, 80.0, 100.0
	}
	// black-out properties
	gamBlackout[slot] -= gamSpeed[slot]
	if gamBlackout[slot] < 0 do gamBlackout[slot] = 0
	if gamBlackout[slot] > 10 && gamLocation[slot] != 2 {
		ambTR, ambTG, ambTB = 30.0, 30.0, 30.0
		lightTR, lightTG, lightTB = 10.0, 10.0, 10.0
		atmosTR, atmosTG, atmosTB = 0.0, 0.0, 0.0
	}
	// apply ambience
	changer := 0.025 * f32(gamSpeed[slot])
	if gotim < 0 || (gamBlackout[slot] > 0 && gamLocation[slot] != 2) do changer = 10.0
	if ambR < ambTR do ambR += changer
	if ambR > ambTR do ambR -= changer
	if ambG < ambTG do ambG += changer
	if ambG > ambTG do ambG -= changer
	if ambB < ambTB do ambB += changer
	if ambB > ambTB do ambB -= changer
	bb.AmbientLight(ambR, ambG, ambB)
	// apply lighting
	if lightR < lightTR do lightR += changer
	if lightR > lightTR do lightR -= changer
	if lightG < lightTG do lightG += changer
	if lightG > lightTG do lightG -= changer
	if lightB < lightTB do lightB += changer
	if lightB > lightTB do lightB -= changer
	for count in i32(1)..=no_lights {
		digit := Dig(count,10)
		light_string := fmt.aprint("Light",digit)
		bb.LightColor(light[count], lightR, lightG, lightB)
		if gamBlackout[slot] > 10 && gamLocation[slot] != 2 {
			bb.EntityColor(bb.FindChild(world, light_string), 100, 100, 100)
			bb.EntityFX(bb.FindChild(world, light_string), 0)
		} else {
			bb.EntityColor(bb.FindChild(world, light_string), 255, 255, 255)
			bb.EntityFX(bb.FindChild(world, light_string), 9)
		}
		delete(digit)
		delete(light_string)
	}
	// apply atmosphere
	if atmosR < atmosTR do atmosR += changer
	if atmosR > atmosTR do atmosR -= changer
	if atmosG < atmosTG do atmosG += changer
	if atmosG > atmosTG do atmosG -= changer
	if atmosB < atmosTB do atmosB += changer
	if atmosB > atmosTB do atmosB -= changer
	bb.CameraFogColor(cam, atmosR, atmosG, atmosB)
	// apply sky
	if skyR < skyTR do skyR += changer
	if skyR > skyTR do skyR -= changer
	if skyG < skyTG do skyG += changer
	if skyG > skyTG do skyG -= changer
	if skyB < skyTB do skyB += changer
	if skyB > skyTB do skyB -= changer
	if bb.FindChild(world, "Sky") > 0 {
		bb.EntityColor(bb.FindChild(world, "Sky"), cast(i32)skyR, cast(i32)skyG, cast(i32)skyB)
	}    
}


//--------------------------------------------------------------------
////////////////////// CAMERA OPERATIONS /////////////////////////////
//--------------------------------------------------------------------
Camera :: proc(){
	// honour collision detection
	camX = bb.EntityX(cam)
	camY = bb.EntityY(cam)
	camZ = bb.EntityZ(cam)
	// timer
	camTim -= 1
	if camTim < 0 do camTim = 0
	camRectify -= 1
	if camRectify < 0 do camRectify = 0
	// auto cam type
	if camType > 0 || camTim == 0 {
		camType = 1
		if gamPromo > 0 || screen == 52 do camType = 10
		if camFoc > 0 && screen == 50 {
			if pAnim[camFoc] >= 93 && pAnim[camFoc] <= 95 do camType = 10
			if pAnim[camFoc] == 96 do camType = 11
			if pAnim[camFoc] >= 97 && pAnim[camFoc] <= 98 do camType = 10
			if pAnim[camFoc] == 102 do camType = 10
			if pAnim[camFoc] == 132 do camType = 10
			if pAnim[camFoc] >= 76 && pAnim[camFoc] <= 77 {
				camType = 12 if pAnimTim[camFoc] > 150 else 11
			}
		}
	}
	// trigger manual
	//if KeyDown(56) {
		//if KeyDown(21) && CamConflict(21) == 0 do camType = 0 : camTim = 100
		//if KeyDown(23) && CamConflict(23) == 0 do camType = 0 : camTim = 100
		//for count in i32(35)..=38 {
			//if KeyDown(count) && CamConflict(count) == 0 do camType = 0 : camTim = 100
		//}
	//}
	if screen == 50 {
		camMouseX = f32(bb.MouseXSpeed() / 2)
		camMouseY = f32(-(bb.MouseYSpeed() / 2))
		if camMouseX != 0 || camMouseY != 0{
			camType = 0
			camTim = 100
		}
		bb.MoveMouse(i32(rX(400)), i32(rY(300)))
	}
	// CAMERA PLACEMENT
	// manual control
	if camType == 0 {
		//if KeyDown(36) && CamConflict(36) == 0 do bb.MoveEntity(cam, -2, 0, 0)
		//if KeyDown(38) && CamConflict(38) == 0 do bb.MoveEntity(cam, 2, 0, 0)
		//if KeyDown(35) && CamConflict(35) == 0 do bb.MoveEntity(cam, 0, -2, 0)
		//if KeyDown(21) && CamConflict(21) == 0 do bb.MoveEntity(cam, 0, 2, 0)
		//if KeyDown(23) && CamConflict(23) == 0 do bb.MoveEntity(cam, 0, 0, 2)
		//if KeyDown(37) && CamConflict(37) == 0 do bb.MoveEntity(cam, 0, 0, -2)
		if cast(bool)bb.MouseDown(1) || cast(bool)bb.MouseDown(2) {
			if camMouseY > 0 && ReachedCord(camX, camZ, camPivTX, camPivTZ, 20) > 0 && camY >= camPivTY - 20 && camY <= camPivTY + 5 {
				bb.MoveEntity(cam, camMouseX, 0, 0)
			} else {
				bb.MoveEntity(cam, camMouseX, 0, camMouseY)
			}
		} else {
			bb.MoveEntity(cam, camMouseX, camMouseY / 2, 0)
		}
		camX = bb.EntityX(cam); camTX = camX
		camY = bb.EntityY(cam); camTY = camY
		camZ = bb.EntityZ(cam); camTZ = camZ
	}
	if camFoc > 0 {
		// over the shoulder
		if camType == 1 {
			ResetDummy(camFoc)
			camTY = pY[camFoc] + 40
			zoom: f32 = 0
			zoom = 70 if pGrappler[camFoc] > 0 else -70
			if InsideCell(pX[camFoc], pY[camFoc], pZ[camFoc]) > 0 {
				zoom /= 2
				camTY -= 5
			}
			bb.MoveEntity(dummy, 0, 0, zoom)
			camTX = bb.EntityX(dummy)
			camTZ = bb.EntityZ(dummy)
			if GetBlock(gamLocation[slot]) > 0 && pBed[camFoc] > 0 && pAnim[camFoc] != 101 {
				camTX = GetCentre(f32(cellX1[pBed[camFoc]]), f32(cellX2[pBed[camFoc]]))
				camTZ = GetCentre(f32(cellZ1[pBed[camFoc]]), f32(cellZ2[pBed[camFoc]]))
			}
		}
		// head shot
		if camType == 10 {
			ResetDummy(camFoc)
			zoom: f32 = 0
			sway: f32 = 12 if camFoc == promoActor[1] else -12
			if OnComputer(camFoc) > 0 do sway = 12
			if pGrappling[camFoc] > 0 || pGrappler[camFoc] > 0 {
				zoom = -28
			} else {
				zoom = 28
			}
			if pPhone[camFoc] > 0 {
				digit := Dig(pPhone[camFoc],10)
				pad_string := fmt.aprint("Pad", digit)
				limb := bb.FindChild(world, pad_string)
				if pZ[camFoc] < bb.EntityZ(limb, 1) {
					zoom = -28
				} else {
					zoom = 28
				}
				delete(digit)
				delete(pad_string)
			}
			if gamPromo > 0 && promoActor[1] > 0 && promoActor[2] > 0 {
				closeness := 30 - GetDistance(f32(pX[promoActor[1]]), f32(pZ[promoActor[1]]), f32(pX[promoActor[2]]), f32(pZ[promoActor[2]]))
				if closeness < 0 do closeness = 0
				if sway < 0 do sway = sway - (closeness / 2)
				if sway > 0 do sway = sway + (closeness / 2)
				if zoom < 0 do zoom = zoom + (closeness / 2)
				if zoom > 0 do zoom = zoom - (closeness / 2)
			}
			if screen == 52 {
				sway = -12 if camFoc == 2 else 12
				zoom = 28
			}
			bb.MoveEntity(dummy, sway, 0, zoom)
			camTX = bb.EntityX(dummy)
			camTY = pY[camFoc] + 30
			if screen == 50 && pGrappler[camFoc] > 0 do camTY = pY[camFoc] + 10
			camTZ = bb.EntityZ(dummy)
		}
		// dying
		if camType == 11 {
			ResetDummy(camFoc)
			if pAnim[camFoc] == 76 do bb.MoveEntity(dummy, -15, 0, 20); camTY = pY[camFoc] + 10
			if pAnim[camFoc] == 77 do bb.MoveEntity(dummy, 10, 0, -25); camTY = pY[camFoc] + 1
			if pAnim[camFoc] == 96 do bb.MoveEntity(dummy, -20, 0, 30); camTY = pY[camFoc] + 10
			camTX = bb.EntityX(dummy); camTZ = bb.EntityZ(dummy)
		}
		// dead
		if camType == 12 {
			camTX = pX[camFoc]; camTY = pY[camFoc] + 500; camTZ = pZ[camFoc]
		}
	}
	// PIVOT PLACEMENT
	if camFoc > 0 {
		// standard
		camPivTX = pX[camFoc]
		camPivTY = pY[camFoc] + 25
		camPivTZ = pZ[camFoc]
		if screen == 50 {
			// seated offset
			if pAnim[camFoc] == 102 || pAnim[camFoc] == 103 do camPivTY = pY[camFoc] + 15
			// projected location
			if pGrappling[camFoc] > 0 || pGrappler[camFoc] > 0 {
				camPivTX = bb.EntityX(pLimb[camFoc][30], 1)
				camPivTZ = bb.EntityZ(pLimb[camFoc][30], 1)
			}
			// grapple victim
			if camType == 10 && pGrappler[camFoc] > 0 do camPivTY = pY[camFoc] + 15
			// dying face
			if (pAnim[camFoc] >= 76 && pAnim[camFoc] <= 77) || pAnim[camFoc] == 96 {
				camPivTX = bb.EntityX(pLimb[camFoc][1], 1)
				camPivTY = bb.EntityY(pLimb[camFoc][1], 1) + 1
				camPivTZ = bb.EntityZ(pLimb[camFoc][1], 1)
			}
		}
		// court seat offset
		if screen == 52 && camFoc == 5 do camPivTY = pY[camFoc] + 22
	}
	// NOVELTY SPEAKERS
	// tanoy announcement
	if camFoc == 0 {
		limb := bb.FindChild(world, "Tanoy01")
		bb.PositionEntity(dummy, bb.EntityX(limb, 1), bb.EntityY(limb, 1), bb.EntityZ(limb, 1))
		bb.RotateEntity(dummy, bb.EntityPitch(limb, 1), bb.EntityYaw(limb, 1), bb.EntityRoll(limb, 1))
		bb.MoveEntity(dummy, 15, -60, 0)
		camTX = bb.EntityX(dummy)
		camTY = bb.EntityY(dummy)
		camTZ = bb.EntityZ(dummy)
		camPivTX = bb.EntityX(limb, 1)
		camPivTY = bb.EntityY(limb, 1)
		camPivTZ = bb.EntityZ(limb, 1)
	}
	// phone call
	if camFoc < 0 {
		digit := Dig(i32(MakePositive(f32(camFoc))),10)
		pad_string := fmt.aprint("Pad", digit)
		limb := bb.FindChild(world, pad_string)
		bb.PositionEntity(dummy, bb.EntityX(limb, 1), bb.EntityY(limb, 1), bb.EntityZ(limb, 1))
		bb.RotateEntity(dummy, 0, 270, 0)
		if pZ[gamPlayer[slot]] >= bb.EntityZ(limb, 1) do bb.MoveEntity(dummy, 12, 0, 25)
		if pZ[gamPlayer[slot]] < bb.EntityZ(limb, 1) do bb.MoveEntity(dummy, -12, 0, 25)
		camTX = bb.EntityX(dummy)
		camTY = bb.EntityY(dummy) - 5
		camTZ = bb.EntityZ(dummy)
		camPivTX = bb.EntityX(limb, 1)
		camPivTY = bb.EntityY(limb, 1)
		camPivTZ = bb.EntityZ(limb, 1)
		delete(digit)
		delete(pad_string)
	}
	// ENFORCE BLOCKS
	if screen == 50 && camFoc > 0 && camType > 0 && gamPromo == 0 {
		// cell logic
		if GetBlock(gamLocation[slot]) > 0 {
			current := InsideCell(camX, camY, camZ)
			target := InsideCell(camTX, camTY, camTZ)
			if current > 0 && target != current {
				if ReachedCord(camX, camZ, cellDoorX[current], cellDoorZ[current], 20) == 0 && CellVisible(camX, camY, camZ, current) == 0 {
					camTX = cellDoorX[current]
					camTZ = cellDoorZ[current]
				}
			}
			if target > 0 && target != current {
				if ReachedCord(camX, camZ, cellDoorX[target], cellDoorZ[target], 20) == 0 && CellVisible(camX, camY, camZ, target) == 0 {
					camTX = cellDoorX[target]
					camTZ = cellDoorZ[target]
				}
			}
		}
		// help over stairs/balcony
		if GetBlock(gamLocation[slot]) > 0 {
			if (camX < -145 || camX > 145 || camZ > 205) && pY[camFoc] < 100 {
				if camY > 100 && camTY < 130 do camTY = 130
			}
			stairProgress := pZ[camFoc] - 20
			if stairProgress < 0 do stairProgress = 0
			if stairProgress > 180 do stairProgress = 180
			stairPercent := GetPercent(f32(stairProgress), 180)
			stairY := 30 + stairPercent
			if camX > -50 && camX < 50 && camZ > 20 && camZ < 210 {
				if (pX[camFoc] < -45 || pX[camFoc] > 45) && pZ[camFoc] > 20 && pY[camFoc] < 100 {
					if camTY < stairY do camTY = stairY
				}
			}
		}
		// cubicle logic
		if gamLocation[slot] == 11 {
			if camX < 50 || pX[camFoc] < 50 {
				if camTZ >= 5 do camTZ = 5
				if pZ[camFoc] > 5 {
					if pX[camFoc] > -143 && pX[camFoc] < -112 do camTX = -128
					if pX[camFoc] > -107 && pX[camFoc] < -76 do camTX = -92
					if pX[camFoc] > -71 && pX[camFoc] < -40 do camTX = -55
					if pX[camFoc] > -34 && pX[camFoc] < -6 do camTX = -20
					if pX[camFoc] > -1 && pX[camFoc] < 29 do camTX = 15
				}
			}
		}
	}
	// CAMERA OPERATION
	// camera tracking
	if gotim > 0 {
		speeder := 100 - (gotim * 2)
		if speeder < 30 do speeder = 30
		if screen == 52 && speeder < 60 do speeder = 60
		if camType == 11 && speeder < 60 do speeder = 60
		if camType == 12 do speeder = 480
		GetSmoothSpeeds(camX, camTX, camY, camTY, camZ, camTZ, speeder)
		if camType == 12 do speedY = 0.4
		if camX < camTX do camX += speedX
		if camX > camTX do camX -= speedX
		if camY < camTY do camY += (speedY / 2)
		if camY > camTY do camY -= (speedY / 2)
		if camZ < camTZ do camZ += speedZ
		if camZ > camTZ do camZ -= speedZ
	}
	// pivot tracking
	speeder: i32 = 15
	if screen == 52 do speeder = 30
	GetSmoothSpeeds(camPivX, camPivTX, camPivY, camPivTY, camPivZ, camPivTZ, speeder)
	if camPivX < camPivTX do camPivX += speedX
	if camPivX > camPivTX do camPivX -= speedX
	if camPivY < camPivTY do camPivY += speedY
	if camPivY > camPivTY do camPivY -= speedY
	if camPivZ < camPivTZ do camPivZ += speedZ
	if camPivZ > camPivTZ do camPivZ -= speedZ
	// position & point
	bb.PositionEntity(camPivot, camPivX, camPivY, camPivZ)
	bb.PointEntity(cam, camPivot)
	bb.PositionEntity(cam, camX, camY, camZ)
	// fader
	if screen == 50 {
		if fadeAlpha < fadeTarget do fadeAlpha += 0.0025
		if fadeAlpha > fadeTarget do fadeAlpha -= 0.0025
		if fadeAlpha < 0 do fadeAlpha = 0
		if fadeAlpha > 1.0 do fadeAlpha = 1.0
		bb.PositionEntity(dummy, camX, camY, camZ)
		bb.RotateEntity(dummy, bb.EntityPitch(cam), bb.EntityYaw(cam), bb.EntityRoll(cam))
		bb.MoveEntity(dummy, 0, 0, 3)
		bb.PositionEntity(fader, bb.EntityX(dummy), bb.EntityY(dummy), bb.EntityZ(dummy))
		bb.EntityAlpha(fader, fadeAlpha)
	}
}


// Unused
//ZOOM CAMERA TO TARGET
// ZoomCamera :: proc() {
// 	camX = camTX
// 	camY = camTY
// 	camZ = camTZ
// }


//RESET DUMMY (in terms of target)
ResetDummy :: proc(cyc: i32) {
	bb.PositionEntity(dummy, pX[cyc], pY[cyc], pZ[cyc])
	bb.RotateEntity(dummy, 0, pA[cyc], 0)
}

// Unused function
//CAMERA vs CONTROL CONFLICTS?
// CamConflict :: proc(command: i32) -> i32 {
	// These variables are never declared.
	// It'll just return 1 if command is 0
// 	keyShoot, keyPass, keyLob: i32 = 0, 0, 0
// 	if command == keyShoot || command == keyPass || command == keyLob {
// 		return 1
// 	}
// 	return 0
// }

//ENTER DOOR
EnterDoor :: proc(cyc: i32, door: i32) {
	//store current location
	//oldLocation := gamLocation[slot] // Unused
	//north >>> hall
	if gamLocation[slot] == 1 {
		charX[pChar[cyc]] = -150
		charZ[pChar[cyc]] = 280
		charY[pChar[cyc]] = 20
		charA[pChar[cyc]] = 180
		charLocation[pChar[cyc]] = 9
	}
	//yard >>> hall
	if gamLocation[slot] == 2 {
		charX[pChar[cyc]] = 150
		charZ[pChar[cyc]] = 280
		charY[pChar[cyc]] = 20
		charA[pChar[cyc]] = 180
		charLocation[pChar[cyc]] = 9
	}
	//east >>> hall
	if gamLocation[slot] == 3 {
		charX[pChar[cyc]] = 280
		charZ[pChar[cyc]] = 150
		charY[pChar[cyc]] = 20
		charA[pChar[cyc]] = 90
		charLocation[pChar[cyc]] = 9
	}
	//study >>> hall
	if gamLocation[slot] == 4 && door == 1 {
		charX[pChar[cyc]] = 280
		charZ[pChar[cyc]] = -150
		charY[pChar[cyc]] = 20
		charA[pChar[cyc]] = 90
		charLocation[pChar[cyc]] = 9
	}
	//study >>> workshop
	if gamLocation[slot] == 4 && door == 2 {
		charX[pChar[cyc]] = 0
		charZ[pChar[cyc]] = -105
		charY[pChar[cyc]] = 20
		charA[pChar[cyc]] = 0
		charLocation[pChar[cyc]] = 10
	}
	//south >>> hall
	if gamLocation[slot] == 5 {
		charX[pChar[cyc]] = 150
		charZ[pChar[cyc]] = -280
		charY[pChar[cyc]] = 20
		charA[pChar[cyc]] = 0
		charLocation[pChar[cyc]] = 9
	}
	//hospital >>> hall
	if gamLocation[slot] == 6 && door != 2 {
		charX[pChar[cyc]] = -150
		charZ[pChar[cyc]] = -280
		charY[pChar[cyc]] = 20
		charA[pChar[cyc]] = 0
		charLocation[pChar[cyc]] = 9
	}
	//hospital >>> toilets
	if gamLocation[slot] == 6 && door == 2 {
		charX[pChar[cyc]] = 90
		charZ[pChar[cyc]] = -55
		charY[pChar[cyc]] = 20
		charA[pChar[cyc]] = 0
		charLocation[pChar[cyc]] = 11
	}
	//west >>> hall
	if gamLocation[slot] == 7 {
		charX[pChar[cyc]] = -280
		charZ[pChar[cyc]] = -150
		charY[pChar[cyc]] = 20
		charA[pChar[cyc]] = 270
		charLocation[pChar[cyc]] = 9
	}
	//kitchen >>> hall
	if gamLocation[slot] == 8 {
		charX[pChar[cyc]] = -280
		charZ[pChar[cyc]] = 150
		charY[pChar[cyc]] = 20
		charA[pChar[cyc]] = 270
		charLocation[pChar[cyc]] = 9
	}
	//hall >>> block
	if gamLocation[slot] == 9 && (door == 1 || door == 3 || door == 5 || door == 7) {
		charX[pChar[cyc]] = 0
		charZ[pChar[cyc]] = -325
		charY[pChar[cyc]] = 20
		charA[pChar[cyc]] = 0
		charLocation[pChar[cyc]] = door
	}
	//hall >>> yard
	if gamLocation[slot] == 9 && door == 2 {
		charX[pChar[cyc]] = 80
		charZ[pChar[cyc]] = 215
		charY[pChar[cyc]] = 20
		charA[pChar[cyc]] = 0
		charLocation[pChar[cyc]] = door
	}
	//hall >>> study
	if gamLocation[slot] == 9 && door == 4 {
		charX[pChar[cyc]] = 5
		charZ[pChar[cyc]] = -130
		charY[pChar[cyc]] = 20
		charA[pChar[cyc]] = 0
		charLocation[pChar[cyc]] = 4
	}
	//hall >>> hospital
	if gamLocation[slot] == 9 && door == 6 {
		charX[pChar[cyc]] = 0
		charZ[pChar[cyc]] = -130
		charY[pChar[cyc]] = 20
		charA[pChar[cyc]] = 0
		charLocation[pChar[cyc]] = 6
	}
	//hall >>> kitchen
	if gamLocation[slot] == 9 && door == 8 {
		charX[pChar[cyc]] = 0
		charZ[pChar[cyc]] = -330
		charY[pChar[cyc]] = 20
		charA[pChar[cyc]] = 0
		charLocation[pChar[cyc]] = 8
	}
	//workshop >>> study
	if gamLocation[slot] == 10 {
		charX[pChar[cyc]] = 135
		charZ[pChar[cyc]] = 0
		charY[pChar[cyc]] = 20
		charA[pChar[cyc]] = 90
		charLocation[pChar[cyc]] = 4
	}
	//toilets >>> hospital
	if gamLocation[slot] == 11 {
		charX[pChar[cyc]] = 0
		charZ[pChar[cyc]] = 130
		charY[pChar[cyc]] = 20
		charA[pChar[cyc]] = 180
		charLocation[pChar[cyc]] = 6
	}
	//proceed
	pDoorFriction[cyc][door] = 0
	go = 1
}

//RELOCATE CPU CHARACTERS
RelocateChars :: proc() {
	for char in 1..=no_chars {
		if char != gamChar[slot] && charRole[char] <= 1 && charLocation[char] > 0 {
			//get new destination
			target: i32 = 0
			source := charLocation[char]
			randy := bb.RndI(0, 20)
			if charRole[char] == 1 && AreaPopulation(charLocation[char], 1) > 2 {
				randy = bb.RndI(0, 10)
			}
			if charLocation[char] == 8 && (gamHours[slot] < 12 || gamHours[slot] > 14) {
				randy = bb.RndI(0, 10)
			}
			if randy == 0 && charLocation[char] >= 1 && charLocation[char] <= 8 do target = 9
			if randy == 0 && charLocation[char] == 9 do target = bb.RndI(1, 8)
			if randy == 1 && charLocation[char] == 9 do target = 2
			if randy == 1 && charLocation[char] == 4 do target = 10
			if randy == 1 && charLocation[char] == 10 do target = 4
			if randy == 1 && charLocation[char] == 6 do target = 11
			if randy == 1 && charLocation[char] == 11 do target = 6
			if randy == 2 && charRole[char] == 0 && charLocation[char] == 9 {
				target = TranslateBlock(charBlock[char])
			}
			if randy == 3 || charY[char] < 0 do target = bb.RndI(1, 11)
			if randy >= 4 && randy <= 5 && gamHours[slot] >= 12 && gamHours[slot] <= 14 {
				target = 8
			}
			//consider population
			if target == 4 || target == 6 || target == 10 || target == 11 {
				if AreaPopulation(target, -1) >= 10 do target = 0
				if charRole[char] == 1 && AreaPopulation(target, 1) >= 2 do target = 0
			}
			if AreaPopulation(target, -1) >= 20 do target = 0
			if charRole[char] == 1 && AreaPopulation(charLocation[char], 1) <= 1 && charLocation[char] != 11 do target = 0
			if charRole[char] == 1 && AreaPopulation(target, 1) >= 4 do target = 0
			if charRole[char] == 1 && target == 11 do target = 0
			//force back to cell
			if LockDown() > 0 || (gamHours[slot] == 21 && gamMins[slot] >= 30) {
				if charRole[char] == 0 do target = TranslateBlock(charBlock[char])
			}
			//mission blocks
			if gamMission[slot] > 0 && char == gamClient[slot] do target = 0
			if gamMission[slot] == 11 || gamMission[slot] == 12 || gamMission[slot] == 16 {
				if char == gamTarget[slot] do target = 0
			}
			//shadow runner
			if charFollowTim[char] > 0 do target = charLocation[gamChar[slot]]
			//deliver to destination
			if target > 0 && target != source {
				//north >>> hall
				if source == 1 && target == 9 {
					charX[char] = bb.RndF(-200.0, -100.0)
					charZ[char] = bb.RndF(230.0, 280.0)
					charY[char] = 20
					charA[char] = bb.RndF(135.0, 225.0)
				}
				//yard >>> hall
				if source == 2 && target == 9 {
					charX[char] = bb.RndF(100.0, 200.0)
					charZ[char] = bb.RndF(230.0, 280.0)
					charY[char] = 20
					charA[char] = bb.RndF(135.0, 225.0)
				}
				//east >>> hall
				if source == 3 && target == 9 {
					charX[char] = bb.RndF(230.0, 280.0)
					charZ[char] = bb.RndF(100.0, 200.0)
					charY[char] = 20
					charA[char] = bb.RndF(45.0, 135.0)
				}
				//study >>> hall
				if (source == 4 || source == 10) && target == 9 {
					charX[char] = bb.RndF(230.0, 280.0)
					charZ[char] = bb.RndF(-200.0, -100.0)
					charY[char] = 20
					charA[char] = bb.RndF(45.0, 135.0)
				}
				//study >>> workshop
				if target == 10 {
					charX[char] = bb.RndF(-25.0, 25.0)
					charZ[char] = bb.RndF(-105.0, -55.0)
					charY[char] = 20
					charA[char] = bb.RndF(-45.0, 45.0)
				}
				//south >>> hall
				if source == 5 && target == 9 {
					charX[char] = bb.RndF(100.0, 200.0)
					charZ[char] = bb.RndF(-280.0, -230.0)
					charY[char] = 20
					charA[char] = bb.RndF(-45.0, 45.0)
				}
				//hospital >>> hall
				if (source == 6 || source == 11) && target == 9 {
					charX[char] = bb.RndF(-200.0, -100.0)
					charZ[char] = bb.RndF(-280.0, -230.0)
					charY[char] = 20
					charA[char] = bb.RndF(-45.0, 45.0)
				}
				//hospital >>> toilets
				if target == 11 {
					charX[char] = bb.RndF(40.0, 140.0)
					charZ[char] = bb.RndF(-55.0, -5.0)
					charY[char] = 20
					charA[char] = bb.RndF(-45.0, 45.0)
				}
				//west >>> hall
				if source == 7 && target == 9 {
					charX[char] = bb.RndF(-280.0, -230.0)
					charZ[char] = bb.RndF(-200.0, -100.0)
					charY[char] = 20
					charA[char] = bb.RndF(225.0, 315.0)
				}
				//kitchen >>> hall
				if source == 8 && target == 9 {
					charX[char] = bb.RndF(-280.0, -230.0)
					charZ[char] = bb.RndF(100.0, 200.0)
					charY[char] = 20
					charA[char] = bb.RndF(225.0, 315.0)
				}
				//hall >>> block
				if GetBlock(target) > 0 {
					charX[char] = bb.RndF(-50.0, 50.0)
					charZ[char] = bb.RndF(-325.0, -275.0)
					charY[char] = 20
					charA[char] = bb.RndF(-45.0, 45.0)
				}
				//hall >>> yard
				if target == 2 {
					charX[char] = bb.RndF(30.0, 130.0)
					charZ[char] = bb.RndF(215.0, 265.0)
					charY[char] = 20
					charA[char] = bb.RndF(-45.0, 45.0)
				}
				//hall >>> study
				if source != 10 && target == 4 {
					charX[char] = bb.RndF(-45.0, 55.0)
					charZ[char] = bb.RndF(-130.0, -80.0)
					charY[char] = 20
					charA[char] = bb.RndF(-45.0, 45.0)
				}
				//hall >>> hospital
				if source != 11 && target == 6 {
					charX[char] = bb.RndF(-50.0, 50.0)
					charZ[char] = bb.RndF(-130.0, -80.0)
					charY[char] = 20
					charA[char] = bb.RndF(-45.0, 45.0)
				}
				//hall >>> kitchen
				if target == 8 {
					charX[char] = bb.RndF(-50.0, 50.0)
					charZ[char] = bb.RndF(-330.0, -180.0)
					charY[char] = 20
					charA[char] = bb.RndF(-45.0, 45.0)
				}
				//workshop >>> study
				if source == 10 && target == 4 {
					charX[char] = bb.RndF(85.0, 135.0)
					charZ[char] = bb.RndF(-25.0, 25.0)
					charY[char] = 20
					charA[char] = bb.RndF(45.0, 135.0)
				}
				//toilet >>> hospital
				if source == 11 && target == 10 {
					charX[char] = bb.RndF(-50.0, 50.0)
					charZ[char] = bb.RndF(80.0, 130.0)
					charY[char] = 20
					charA[char] = bb.RndF(135.0, 225.0)
				}
				//place inside cell
				if charRole[char] == 0 && bool(LockDown()) && GetBlock(target) > 0 && target != gamLocation[slot] {
					charX[char] = GetCentre(cellX1[charCell[char]], cellX2[charCell[char]])
					charZ[char] = GetCentre(cellZ1[charCell[char]], cellZ2[charCell[char]])
					charY[char] = cellY1[charCell[char]] + 20
					charA[char] = bb.RndF(0.0, 360.0)
				}
				//update location
				charLocation[char] = target
			}
			//released
			if charRole[char] == 0 && charSentence[char] <= 0 && (char != gamClient[slot] || gamMission[slot] == 0) {
				charLocation[char] = 0
				gamRelease[slot] = char
				RuinMission(char)
				for v in 1..=no_chars {
					if v != gamChar[slot] && charPromo[v][gamChar[slot]] == 0 && charRelation[v][gamChar[slot]] >= 0 && charAngerTim[v][gamChar[slot]] == 0 {
						// NOTE: Likely a bug. cyc is undefined in this function scope.
						// Blitz will interpret it as being 0. I'm not sure what was the intended behaviour.
						cyc := 0
						if charRelation[gamChar[slot]][pChar[cyc]] > 0 && charRelation[v][pChar[cyc]] > 0 {
							charPromo[v][gamChar[slot]] = 219
							charPromoRef[v] = char
						}
						if charRelation[gamChar[slot]][pChar[cyc]] < 0 && charRelation[v][pChar[cyc]] < 0 {
							charPromo[v][gamChar[slot]] = 220
							charPromoRef[v] = char
						}
					}
				}
			}
			//make weapon follow
			if charWeapon[char] > 0 do weapLocation[charWeapon[char]] = charLocation[char]
		}
		//introduce new characters
		randy := bb.RndI(0, 10)
		if randy == 0 && char != gamChar[slot] && charRole[char] <= 1 &&
		charLocation[char] == 0 && char != gamFatality[slot] &&
		char != gamRelease[slot] && gamArrival[slot] == 0 {
			role: i32 = 0
			if GamePopulation(1) < optPopulation / 5 {
				role = 1
			} else {
				role = 0
			}
			GenerateCharacter(char, role)
			if charLocation[char] > 0 do gamArrival[slot] = char
			if role == 0 {
				randy = bb.RndI(0, 4)
				if randy == 1 || (randy == 0 && charReputation[char] < charReputation[gamChar[slot]]) {
					charPromo[char][gamChar[slot]] = 200
				}
				if randy == 2 || (randy == 0 && charReputation[char] >= charReputation[gamChar[slot]]) {
					charPromo[char][gamChar[slot]] = 201
				}
				if charRole[char] == 0 && charCell[char] == charCell[gamChar[slot]] && charBlock[char] == charBlock[gamChar[slot]] {
					randy = bb.RndI(0, 2)
					if randy == 1 || (randy == 0 && charReputation[char] < charReputation[gamChar[slot]]) {
						charPromo[char][gamChar[slot]] = bb.RndI(202, 203)
					}
					if randy == 2 || (randy == 0 && charReputation[char] >= charReputation[gamChar[slot]]) {
						charPromo[char][gamChar[slot]] = bb.RndI(203, 204)
					}
				}
			}
		}
		//change gang affilliations
		oldGang := charGang[char]
		randy = bb.RndI(0, 1000)
		if randy >= 1 && randy <= 6 && char != gamChar[slot] && charRole[char] == 0 && charLocation[char] > 0 {
			if charGang[char] == 0 {
				if randy == 1 && charGangHistory[char][1] == 0 && GetRace(char) == 0 {
					ChangeGang(char, 1)
				}
				if randy == 2 && charGangHistory[char][2] == 0 && GetRace(char) == 1 {
					ChangeGang(char, 2)
				}
				if randy == 3 && charGangHistory[char][3] == 0 && GetRace(char) == 2 {
					ChangeGang(char, 3)
				}
				if randy == 4 && charGangHistory[char][4] == 0 && charIntelligence[char] > 70 {
					ChangeGang(char, 4)
				}
				if randy == 5 && charGangHistory[char][5] == 0 && charStrength[char] + charAgility[char] > 140 {
					ChangeGang(char, 5)
				}
				if randy == 6 && charGangHistory[char][6] == 0 && charReputation[char] < 70 {
					ChangeGang(char, 6)
				}
			} else {
				ChangeGang(char, 0)
			}
			if charGang[char] != oldGang && charPromo[char][gamChar[slot]] == 0 {
				if oldGang == charGang[gamChar[slot]] && charRelation[char][gamChar[slot]] == 1 {
					charPromo[char][gamChar[slot]] = 45 // left gang
				}
				if charGang[char] > 0 && charGang[char] != charGang[gamChar[slot]] && charRelation[char][gamChar[slot]] == 1 {
					charPromo[char][gamChar[slot]] = 46 // friend joins a gang
				}
				if charGang[char] > 0 && charGang[char] == charGang[gamChar[slot]] {
					charPromo[char][gamChar[slot]] = 47 // new member to your gang
				}
			}
		}
	}
}

//COUNT AREA POPULATION
AreaPopulation :: proc(area, role: i32) -> i32 { // -1=any
	value: i32 = 0
	for char in 1..=no_chars {
		if charRole[char] == role || role == -1 && charLocation[char] == area do value += 1
	}
	return value
}

//COUNT CELL POPULATION
CellPopulation :: proc(block: i32, cell: i32) -> i32 {
	value: i32 = 0
	for char in 1..=no_chars {
		if charBlock[char] == block && charCell[char] == cell do value += 1
	}
	return value
}

//COUNT GAME POPULATION
GamePopulation :: proc(role: i32) -> i32 { // -1=any
	value: i32 = 0
	for char in 1..=no_chars {
		if charRole[char] == role || role == -1 do value += 1
	}
	return value
}

//GET BLOCK (FROM LOCATION)
GetBlock :: proc(area: i32) -> i32 {
	if area == 1 do return 1
	if area == 3 do return 2
	if area == 5 do return 3
	if area == 7 do return 4
	return 0
}

//GET BLOCK LOCATION (FROM ID)
TranslateBlock :: proc(block: i32) -> i32 {
	if block == 1 do return 1
	if block == 2 do return 3
	if block == 3 do return 5
	if block == 4 do return 7
	return 0
}

//LOCK DOWN TIME?
LockDown :: proc() -> i32 {
	value: i32 = 0
	if gamHours[slot] < 7 || gamHours[slot] >= 22 do value = 1
	return value
}

// CELLS READY TO BE LOCKED?
LockReady :: proc(area: i32) -> i32 {
	value: i32 = 1
	for v in 1..=no_plays {
		// not in cell
		if charRole[pChar[v]] == 0 && (GetBlock(area) == charBlock[pChar[v]] || pChar[v] != gamChar[slot]) {
			if InsideCell(pX[v], pY[v], pZ[v]) != charCell[pChar[v]] do value = 0
		}
		// cell occupied by illegal
		if charRole[pChar[v]] == 1 || GetBlock(area) != charBlock[pChar[v]] {
			if InsideCell(pX[v], pY[v], pZ[v]) > 0 do value = 0
		}
	}
	// open for warrant
	if gamWarrant[slot] > 0 do value = 0
	return value
}

LockCells :: proc(lock: i32) { // 0=open, 1=close
	// play door sound and animate
	ProduceSound(cam, sDoor[3], 22050, 1)
	if lock == 0 do bb.Animate(world, 3, 4.0)
	if lock == 1 do bb.Animate(world, 3, -4.0)
	for count in 0..=20 {
		cellLocked[gamLocation[slot]][count] = lock
	}
}

InsideCell :: proc(x, y, z: f32) -> i32 {
	// find matches
	cell: i32 = 0
	for count in i32(1)..=20 {
		if y >= cellY1[count] && y <= cellY2[count] {
			if x >= cellX1[count] && x <= cellX2[count] && z >= cellZ1[count] && z <= cellZ2[count] {
				cell = count
			}
		}
	}
	// null if not in block
	if screen == 50 && go == 0 {
		if GetBlock(gamLocation[slot]) == 0 do cell = 0
	}
	return cell
}

// IN LINE WITH CELL?
CellVisible :: proc(x, y, z: f32, cell: i32) -> i32 {
	value: i32 = 0
	if GetBlock(gamLocation[slot]) > 0 && cell > 0 {
		if y >= cellY1[cell] && y <= cellY2[cell] {
			if cell == 5 || cell == 6 || cell == 15 || cell == 16 {
				if x >= cellX1[cell] && x <= cellX2[cell] do value = 1
			} else {
				if z >= cellZ1[cell] && z <= cellZ2[cell] do value = 1
			}
		}
	}
	return value
}

// IN PROXIMITY OF CHAIR?
ChairProximity :: proc(cyc: i32, chair: i32) -> i32 {
	digit := Dig(chair, 10)
	chair_string := fmt.aprint("Chair%d", digit)
	value: i32 = 0
	limb := bb.FindChild(world, chair_string)
	if pX[cyc] > bb.EntityX(limb, 1)-18 && pX[cyc] < bb.EntityX(limb, 1)+18 \
	&& pY[cyc] > bb.EntityY(limb, 1)-30 && pY[cyc] < bb.EntityY(limb, 1)-5 \
	&& pZ[cyc] > bb.EntityZ(limb, 1)-18 && pZ[cyc] < bb.EntityZ(limb, 1)+18 {
		back: i32 = 0
		if gamLocation[slot] != 11 {
			bb.PositionEntity(dummy, bb.EntityX(limb, 1), bb.EntityY(limb, 1), bb.EntityZ(limb, 1))
			bb.RotateEntity(dummy, 0, bb.EntityYaw(limb, 1), 0)
			bb.MoveEntity(dummy, 0, 0, -30)
			if pX[cyc] > bb.EntityX(dummy, 1)-20 && pX[cyc] < bb.EntityX(dummy, 1)+20 \
			&& pZ[cyc] > bb.EntityZ(dummy, 1)-20 && pZ[cyc] < bb.EntityZ(dummy, 1)+20 {
				back = 1
			}
		}
		if back == 0 && cast(bool)InLine(cyc, limb, 45) do value = 1
	}
	delete(digit)
	delete(chair_string)
	return value
}

// CHAIR TAKEN?
ChairTaken :: proc(chair: i32) -> i32 {
	for v in 1..=no_plays {
		if pSeat[v] == chair do return 1
	}
	return 0
}

// IN PROXIMITY OF BED?
BedProximity :: proc(cyc: i32, bed: i32) -> i32 {
	digit := Dig(bed, 10)
	bed_string := fmt.aprint("Mat%d", digit)
	value: i32 = 0
	limb := bb.FindChild(world, bed_string)
	if pX[cyc] > bb.EntityX(limb, 1)-25 && pX[cyc] < bb.EntityX(limb, 1)+25 \
	&& pY[cyc] > bb.EntityY(limb, 1)-25 && pY[cyc] < bb.EntityY(limb, 1) \
	&& pZ[cyc] > bb.EntityZ(limb, 1)-25 && pZ[cyc] < bb.EntityZ(limb, 1)+25 {
		if cast(bool)InLine(cyc, limb, 45) do value = 1
	}
	delete(digit)
	delete(bed_string)
	return value
}

// BED TAKEN?
BedTaken :: proc(bed: i32) -> i32 {
	for v in 1..=no_plays {
		if pBed[v] == bed do return 1
	}
	return 0
}

// IN PROXIMITY OF PHONE?
PhoneProximity :: proc(cyc: i32) -> i32 {
	value: i32 = 0
	if gamLocation[slot] == 9 {
		for v in i32(1)..=4 {
			digit := Dig(v, 10)
			pad_string := fmt.aprint("Pad%d", digit)
			limb := bb.FindChild(world, pad_string)
			if pX[cyc] > bb.EntityX(limb, 1)-20 && pX[cyc] < bb.EntityX(limb, 1)+20 \
			&& pZ[cyc] > bb.EntityZ(limb, 1)-15 && pZ[cyc] < bb.EntityZ(limb, 1)+15 {
				value = v
			}
			delete(digit)
			delete(pad_string)
		}
	}
	return value
}

// PHONE TAKEN?
PhoneTaken :: proc(phone: i32) -> i32 {
	for v in 1..=no_plays {
		if pPhone[v] == phone do return 1
	}
	return 0
}

// ON COMPUTER?
OnComputer :: proc(cyc: i32) -> i32 {
	if gamLocation[slot] == 4 && pSeat[cyc] == 5 do return 1
	if gamLocation[slot] == 6 && pSeat[cyc] == 5 do return 1
	if gamLocation[slot] == 9 && pSeat[cyc] == 7 do return 1
	return 0
}

// NEAR BASKET
NearBasket :: proc(cyc: i32) -> i32 {
	value: i32 = 0
	if gamLocation[slot] == 2 && pWeapon[cyc] > 0 {
		limb := bb.FindChild(world, "Rim")
		if pX[cyc] > bb.EntityX(limb, 1)-100 && pX[cyc] < bb.EntityX(limb, 1)+100 \
		&& pZ[cyc] > bb.EntityZ(limb, 1)-100 && pZ[cyc] < bb.EntityZ(limb, 1)+100 {
			if cast(bool)InLine(cyc, limb, 60) do value = 1
		}
	}
	return value
}

