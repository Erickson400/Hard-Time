package main
////////////////////////////////////////////////////////////////////////////////
//------------------------------ HARD TIME: WORLD ------------------------------
////////////////////////////////////////////////////////////////////////////////

import "core:fmt"
import "core:strings"
import "core:strconv"
import bb "blitzbasic3d"


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
    // Prison block
    if GetBlock(gamLocation[slot]) > 0 {
        world = bb.LoadAnimMesh("World/Block/Block.3ds")
        bb.EntityType(world, 10, 1)
        bb.Animate(world, 3, 10)
        cellLocked[gamLocation[slot]][0] = 0
        for count in i32(1)..=20 {
            switch gamLocation[slot] {
            case 1:
                bb.EntityTexture(bb.FindChild(world, fmt.tprint("Plate", Dig(count,10))), tBlock[1], 0, 2)
            case 3:
                bb.EntityTexture(bb.FindChild(world, fmt.tprint("Plate", Dig(count,10))), tBlock[2], 0, 2)
            case 5:
                bb.EntityTexture(bb.FindChild(world, fmt.tprint("Plate", Dig(count,10))), tBlock[3], 0, 2)
            case 7:
                bb.EntityTexture(bb.FindChild(world, fmt.tprint("Plate", Dig(count,10))), tBlock[4], 0, 2)
            }
            bb.EntityTexture(bb.FindChild(world, fmt.tprint("Plate", Dig(count,10))), tCell[count], 0, 3)
            bb.EntityType(bb.FindChild(world, fmt.tprint("Door", Dig(count,10))), 11, 0)
            bb.EntityType(bb.FindChild(world, fmt.tprint("Plate", Dig(count,10))), 11, 0)
            bb.EntityType(bb.FindChild(world, fmt.tprint("Bars", Dig(count,10))), 11, 0)
            cellLocked[gamLocation[slot]][count] = 0
        }
        bb.EntityTexture(bb.FindChild(world, "Sign01"), tSign[9], 0, 2)
        bb.EntityTexture(bb.FindChild(world, "Sign02"), tSign[gamLocation[slot]], 0, 2)
        no_chars, no_beds, no_doors = 0, 20, 1
        sAtmos = bb.LoadSound("Sound/Ambience/Quiet.wav")
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
            bb.EntityTexture(bb.FindChild(world, fmt.tprint("Fence0", Dig(count,10))), tFence)
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
            bb.EntityAlpha(bb.FindChild(world, fmt.tprint("Beaker0", Dig(count,10))), 0.7)
            bb.EntityAlpha(bb.FindChild(world, fmt.tprint("Water0", Dig(count,10))), 0.5)
        }
        no_chars, no_beds, no_doors = 9, 3, 2
        sAtmos = bb.LoadSound("Sound/Ambience/Hall.wav")
    }
    // Kitchen
    if gamLocation[slot] == 8 {
        world = bb.LoadAnimMesh("World/Kitchen/Kitchen.3ds")
        bb.EntityType(world, 10, 1)
        bb.EntityTexture(bb.FindChild(world, "Sign01"), tSign[9], 0, 2)
        for count in i32(1)..=4 {
            bb.EntityAlpha(bb.FindChild(world, fmt.tprint("Window0", Dig(count,10))), 0.5)
        }
        for tray in i32(1)..=50 {
            trayOldState[tray] = -1
        }
        no_chars, no_beds, no_doors = 45, 0, 1
        sAtmos = bb.LoadSound("Sound/Ambience/Canteen.wav")
    }
    // Main hall
    if gamLocation[slot] == 9 {
        world = bb.LoadAnimMesh("World/Hall/Hall.3ds")
        bb.EntityType(world, 10, 1)
        for count in i32(1)..=8 {
            bb.EntityTexture(bb.FindChild(world, fmt.tprint("Sign", Dig(count,10))), tSign[count], 0, 2)
        }
        for count in i32(1)..=9 {
            bb.EntityShininess(bb.FindChild(world, fmt.tprint("Ball", Dig(count,10))), 1.0)
        }
        bb.EntityFX(bb.FindChild(world, "TV"), 9)
        bb.EntityFX(bb.FindChild(world, "Screen"), 9)
        for count in i32(1)..=4 {
            bb.EntityAlpha(bb.FindChild(world, fmt.tprint("Alarm", Dig(count,10))), 0.8)
            bb.EntityShininess(bb.FindChild(world, fmt.tprint("Alarm", Dig(count,10))), 1.0)
            bb.EntityColor(bb.FindChild(world, fmt.tprint("Alarm", Dig(count,10))), 5, 0, 0)
            bb.EntityShininess(bb.FindChild(world, fmt.tprint("Phone", Dig(count,10))), 1.0)
            phoneX[count] = bb.EntityX(bb.FindChild(world, fmt.tprint("Phone", Dig(count,10))), 1)
            phoneY[count] = bb.EntityY(bb.FindChild(world, fmt.tprint("Phone", Dig(count,10))), 1)
            phoneZ[count] = bb.EntityZ(bb.FindChild(world, fmt.tprint("Phone", Dig(count,10))), 1)
        }
        no_chars, no_beds, no_doors = 8, 0, 8
        sAtmos = bb.LoadSound("Sound/Ambience/Hall.wav")
    }
    // Workshop
    if gamLocation[slot] == 10 {
        world = bb.LoadAnimMesh("World/Workshop/Workshop.3ds")
        bb.EntityType(world, 10, 1)
        bb.EntityTexture(bb.FindChild(world, "Sign01"), tSign[4], 0, 2)
        no_chars, no_beds, no_doors = 6, 0, 1
        for cyc in i32(1)..=6 {
            kit[cyc] = bb.LoadAnimMesh(fmt.tprint("Weapons/", weapFile[kitType[cyc]], " Kit.3ds"))
            bb.ScaleEntity(kit[cyc], 0.4, 0.4, 0.4)
            limb := bb.FindChild(world, fmt.tprint("Table", Dig(cyc,10)))
            bb.PositionEntity(kit[cyc], bb.EntityX(limb, 1), bb.EntityY(limb, 1), bb.EntityZ(limb, 1))
            if cyc >= 5 {
                bb.RotateEntity(kit[cyc], 0, 90, 0)
            }
            if weapTex[kitType[cyc]] > 0 {
                for count in i32(1)..=bb.CountChildren(kit[cyc]) {
                    bb.EntityTexture(bb.GetChild(kit[cyc], count), weapTex[kitType[cyc]])
                }
            }
            if kitState[cyc] == 0 {
                bb.HideEntity(kit[cyc])
            }
        }
        sAtmos = bb.LoadSound("Sound/Ambience/Quiet.wav")
    }
    // Toilets
    if gamLocation[slot] == 11 {
        world = bb.LoadAnimMesh("World/Toilets/Toilets.3ds")
        bb.EntityType(world, 10, 1)
        bb.EntityTexture(bb.FindChild(world, "Sign01"), tSign[6], 0, 2)
        for count in i32(1)..=5 {
            bb.EntityType(bb.FindChild(world, fmt.tprint("Door", Dig(count,10))), 11, 0)
            bb.EntityAlpha(bb.FindChild(world, fmt.tprint("Water", Dig(count,10))), 0.5)
        }
        for count in i32(1)..=4 {
            bb.EntityType(bb.FindChild(world, fmt.tprint("Shower", Dig(count,10))), 0, 0)
            bb.EntityTexture(bb.FindChild(world, fmt.tprint("Shower", Dig(count,10))), tShower)
            bb.EntityAlpha(bb.FindChild(world, fmt.tprint("Shower", Dig(count,10))), 0.6)
        }
        no_chars, no_beds, no_doors = 5, 0, 1
        sAtmos = bb.LoadSound("Sound/Ambience/Bathroom.wav")
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
    if gamLocation[slot] == 2 {
        bb.CameraRange(cam, 1, 2000)
    }
    bb.CameraFogMode(cam, optFog)
    bb.CameraFogRange(cam, 400, 1000)
    if gamLocation[slot] == 4 || gamLocation[slot] == 6 || gamLocation[slot] == 10 || gamLocation[slot] == 11 {
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
        limb := bb.FindChild(world, fmt.tprint("Light", Dig(count,10)))
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
                v := bb.Rnd(1, no_chars)
                if char != v do charRelation[char][v] = ChangeRelationship(char, v, Rnd(-1, 1))
                charStrength[char] += bb.Rnd(-2, 2)
                charAgility[char] += bb.Rnd(-2, 2)
                if charRole[char] == 1 {
                    charHappiness[char] = bb.Rnd(50, 100)
                } else {
                    charHappiness[char] = bb.Rnd(10, 100)
                }
                charIntelligence[char] += bb.Rnd(-2, 2)
                charReputation[char] += bb.Rnd(-2, 2)
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
            if InsideCell(pX[gamPlayer[slot]], pY[gamPlayer[slot]], pZ[gamPlayer[slot]]) != charCell[gamChar[slot]] || gamLocation[slot] != TranslateBlock(charBlock[gamChar[slot]]) {
                if gamPromo == 0 && pAnim[gamPlayer[slot]] != 76 && pAnim[gamPlayer[slot]] != 77 {
                    TriggerPromo(0, 0, 25)
                }
            }
        }
    }
    if GetBlock(gamLocation[slot]) > 0 {
        if (LockDown() == 0 || LockReady(gamLocation[slot]) == 0) && cellLocked[gamLocation[slot]][0] == 1 do LockCells(0)
        if LockDown() && LockReady(gamLocation[slot]) && cellLocked[gamLocation[slot]][0] == 0 do LockCells(1)
    }
    // serve dinner
    if gamHours[slot] == 13 && gamMins[slot] == 0 && gamSecs[slot] == 0 {
        ProduceSound(cam, sBell, 22050, 1)
        statTim[5] = 50
        if gamPromo == 0 && pAnim[gamPlayer[slot]] != 76 && pAnim[gamPlayer[slot]] != 77 {
            if gamLocation[slot] != 8 || pSeat[gamPlayer[slot]] == 0 do TriggerPromo(0, 0, 27)
        }
        for tray in i32(1)..=50 {
            trayState[tray] = bb.Rnd(1, 7)
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
        cyc2: i32 = 1 // In blitz, cyc is in the function scope, and mat is using it further down
        for cyc in i32(1)..=6 {
            cyc2 += 1
            for {
                kitType[cyc] = bb.Rnd(1, weapList)
                if weapCreate[kitType[cyc]] == 1 do break
            }
            randy := bb.Rnd(0, 2)
            if randy <= 1 {
                kitState[cyc] = 1
            } else {
                kitState[cyc] = 0
            }
        }
        for char in i32(1)..=no_chars {
            if char != gamChar[slot] && charLocation[char] > 0 {
                charHealth[char] += bb.Rnd(10, 100)
                if charHealth[char] > 100 do charHealth[char] = 100
                randy := bb.Rnd(0, 10000)
                if randy == 0 && charInjured[char] == 0 do charInjured[char] = bb.Rnd(1000, 80000)
            }
        }
        for v in i32(1)..=no_plays {
            if pChar[v] != gamChar[slot] {
                pHealth[v] = f32(charHealth[pChar[cyc2]])
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
        bb.LightColor(light[count], lightR, lightG, lightB)
        if gamBlackout[slot] > 10 && gamLocation[slot] != 2 {
            bb.EntityColor(bb.FindChild(world, fmt.tprint("Light", Dig(count,10))), 100, 100, 100)
            bb.EntityFX(bb.FindChild(world, fmt.tprint("Light", Dig(count,10))), 0)
        } else {
            bb.EntityColor(bb.FindChild(world, fmt.tprint("Light", Dig(count,10))), 255, 255, 255)
            bb.EntityFX(bb.FindChild(world, fmt.tprint("Light", Dig(count,10))), 9)
        }
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
        bb.EntityColor(bb.FindChild(world, "Sky"), skyR, skyG, skyB)
    }    
}



/*

*/




GetBlock :: proc(area: i32) -> i32 {
    block: i32 = 0
    switch area {
    case 1: block = 1
    case 3: block = 2
    case 5: block = 3
    case 7: block = 4
    }
    return block
}



