package main
////////////////////////////////////////////////////////////////////////////////
//----------------------------- HARD TIME: EDITOR ------------------------------
////////////////////////////////////////////////////////////////////////////////

import "core:fmt"
import "core:math"
import "core:strings"
import "core:strconv"
import bb "blitzbasic3d"

//-------------------------------------------------------------------
/////////////////////// 51. EDIT CHARACTER //////////////////////////
//-------------------------------------------------------------------
Editor :: proc() {
    // loading
    Loader("Please Wait", "Loading Editor")
    // prison setting
    world := bb.LoadAnimMesh("World/Block/Block.3ds")
    // camera
    cam := bb.CreateCamera()
    bb.CameraViewport(cam, 0, 0, bb.GraphicsWidth(), bb.GraphicsHeight())
    bb.PositionEntity(cam, -232, 36, -89)
    if bb.GraphicsWidth() > 1024 {
        bb.PositionEntity(cam, -228, 36, -84)
    }
    bb.RotateEntity(cam, 3, 119, 0)
    // atmosphere
    bb.AmbientLight(200, 190, 170)
    light1 := bb.CreateLight(3)
    bb.PositionEntity(light1, -145, 100, -70)
    bb.RotateEntity(light1, 90, 0, 0)
    bb.LightRange(light1, 500)
    bb.LightConeAngles(light1, 0, 135)
    bb.LightColor(light1, 200, 180, 160)
    // load model
    cyc: i32 = 1
    char := gamChar[0]
    pChar[cyc] = char
    pX[cyc] = -257
    pY[cyc] = 11.5
    pZ[cyc] = -124
    ReloadModel(i32(cyc))
    // shadows
    for limb in 1..=40{
        pShadow[cyc][limb] = 0
        if limb == 30 || (optShadows == 2 && (limb == 1 || (limb >= 4 && limb <= 6) || (limb >= 17 &&
        limb <= 19) || limb == 32 || limb == 33 || limb == 35 || limb == 36)) {
            pShadow[cyc][limb] = bb.LoadSprite("World/Sprites/Shadow.png", 2)
            bb.ScaleSprite(pShadow[cyc][limb], 13, 13)
            if limb != 30 {
                bb.ScaleSprite(pShadow[cyc][limb], 10, 10)
            }
            if limb == 6 || limb == 19 || limb == 33 || limb == 36 {
                bb.ScaleSprite(pShadow[cyc][limb], 8, 8)
            }
            bb.RotateEntity(pShadow[cyc][limb], 90, 0, 0)
            bb.SpriteViewMode(pShadow[cyc][limb], 2)
            bb.EntityAlpha(pShadow[cyc][limb], 0.1)
            if optShadows == 2 && (limb == 30 || limb == 6 || limb == 19) {
                bb.EntityAlpha(pShadow[cyc][limb], 0.2)
            }
            if optShadows == 1 {
                bb.EntityAlpha(pShadow[cyc][limb], 0.5)
            }
            if optShadows == 0 {
                bb.EntityAlpha(pShadow[cyc][limb], 0)
            }
            bb.EntityColor(pShadow[cyc][limb], 10, 10, 10)
        }
    }
    // frame rating
    timer := bb.CreateTimer(30)
    // MAIN LOOP
    foc := 8
    oldfoc := foc
    page := 1
    go := 0
    gotim := 0
    keytim := 20

    for go == 0 {
        bb.Cls()
        screenCall := 0
        frames := bb.WaitTimer(timer)
        for framer in 1..=frames {
            // counters
            keytim -= 1
            if keytim < 1 {
                keytim = 0
            }

            // PORTAL
            gotim += 1
            if gotim > 40 && keytim == 0 {
                // quit
                if bb.KeyDown(1) {
                    go = -1
                }
                // activations
                if bb.KeyDown(28) || bb.ButtonPressed() {
                    // next page
                    if foc == 7 && keytim == 0 {
                        bb.PlaySound(sMenuGo)
                        keytim = 10
                        page += 1
                        foc = 7
                        gotim = 0
                        if page > 2 {
                            page = 1
                        }
                    }
                    // leave
                    if foc == 8 && keytim == 0 {
                        go = 1
                    }
                }
            }

            // CONFIGURATION
            if gotim > 20 && keytim == 0 {
                // browse up
                if bb.KeyDown(200) || bb.JoyYDir() == -1 {
                    foc -= 1
                    bb.PlaySound(sMenuSelect)
                    keytim = 6
                }
                // browse down
                if bb.KeyDown(208) || bb.JoyYDir() == 1 {
                    foc += 1
                    bb.PlaySound(sMenuSelect)
                    keytim = 6
                }
            }
            // limits
            if foc < 1 {
                foc = 1
            }
            if foc > 8 {
                foc = 8
            }

            // ASSESS POINTS
            gamPoints := gamPointLimit
            gamPoints -= charStrength[char]
            gamPoints -= charAgility[char]
            gamPoints -= charIntelligence[char]
            if gamPoints < 0 do gamPoints = 0

            // 1. PROFILE
            if page == 1 && foc >= 2 && foc <= 6 && keytim == 0 {
                // search left
                if bb.KeyDown(203) || bb.JoyXDir() == -1 {
                    switch foc {
                    case 2:
                        charHeight[char] -= 1
                        bb.PlaySound(sMenuBrowse)
                        keytim = 4
                    case 3:
                        charStrength[char] -= 1
                        bb.PlaySound(sMenuBrowse)
                        keytim = 3
                    case 4:
                        charAgility[char] -= 1
                        bb.PlaySound(sMenuBrowse)
                        keytim = 3
                    case 5:
                        charIntelligence[char] -= 1
                        bb.PlaySound(sMenuBrowse)
                        keytim = 3
                    case 6:
                        charCrime[char] -= 1
                        bb.PlaySound(sMenuBrowse)
                        keytim = 5
                    }
                }
                // search right
                if bb.KeyDown(205) || bb.JoyXDir() == 1 {
                    switch foc {
                    case 2:
                        charHeight[char] += 1
                        bb.PlaySound(sMenuBrowse)
                        keytim = 4
                    case 3:
                        if gamPoints > 0 {
                            charStrength[char] += 1
                            bb.PlaySound(sMenuBrowse)
                            keytim = 3
                        }
                    case 4:
                        if gamPoints > 0 {
                            charAgility[char] += 1
                            bb.PlaySound(sMenuBrowse)
                            keytim = 3
                        }
                    case 5:
                        if gamPoints > 0 {
                            charIntelligence[char] += 1
                            bb.PlaySound(sMenuBrowse)
                            keytim = 3
                        }
                    case 6:
                        charCrime[char] += 1
                        bb.PlaySound(sMenuBrowse)
                        keytim = 5
                    }
                }
            }
            // limits
            if charHeight[char] < 5 {
                charHeight[char] = 5
            }
            if charHeight[char] > 24 {
                charHeight[char] = 24
            }
            if charStrength[char] < 30 {
                charStrength[char] = 30
            }
            if charStrength[char] > 99 {
                charStrength[char] = 99
            }
            if charAgility[char] < 30 {
                charAgility[char] = 30
            }
            if charAgility[char] > 99 {
                charAgility[char] = 99
            }
            if charIntelligence[char] < 30 {
                charIntelligence[char] = 30
            }
            if charIntelligence[char] > 99 {
                charIntelligence[char] = 99
            }
            if charCrime[char] < 1 {
                charCrime[char] = 1
            }
            if charCrime[char] > 15 {
                charCrime[char] = 15
            }
            if gamPointLimit < 999 {
                charReputation[char] = 50 + (charCrime[char] * 2)
                charSentence[char] = 30 + (charCrime[char] * 2)
            }

            // 2. APPEARANCE
            oldHairStyle := charHairStyle[char]
            oldHair := charHair[char]
            oldFace := charFace[char]
            oldSpecs := charSpecs[char]
            oldModel := charModel[char]
            oldCostume := charCostume[char]
            if page == 2 && foc >= 1 && foc <= 6 && keytim == 0 {
                // search left
                if bb.KeyDown(203) || bb.JoyXDir() == -1 {
                    switch foc {
                    case 1:
                        charHairStyle[char] -= 1
                        bb.PlaySound(sMenuBrowse)
                        keytim = 5
                    case 2:
                        charHair[char] -= 1
                        bb.PlaySound(sMenuBrowse)
                        keytim = 6
                    case 3:
                        charFace[char] -= 1
                        bb.PlaySound(sMenuBrowse)
                        keytim = 4
                    case 4:
                        charSpecs[char] -= 1
                        bb.PlaySound(sMenuBrowse)
                        keytim = 6
                    case 5:
                        charModel[char] -= 1
                        bb.PlaySound(sMenuBrowse)
                        keytim = 6
                    case 6:
                        charCostume[char] -= 1
                        bb.PlaySound(sMenuBrowse)
                        keytim = 6
                    }
                }
                // search right
                if bb.KeyDown(205) || bb.JoyXDir() == 1 {
                    switch foc {
                    case 1:
                        charHairStyle[char] += 1
                        bb.PlaySound(sMenuBrowse)
                        keytim = 5
                    case 2:
                        charHair[char] += 1
                        bb.PlaySound(sMenuBrowse)
                        keytim = 6
                    case 3:
                        charFace[char] += 1
                        bb.PlaySound(sMenuBrowse)
                        keytim = 4
                    case 4:
                        charSpecs[char] += 1
                        bb.PlaySound(sMenuBrowse)
                        keytim = 6
                    case 5:
                        charModel[char] += 1
                        bb.PlaySound(sMenuBrowse)
                        keytim = 6
                    case 6:
                        charCostume[char] += 1
                        bb.PlaySound(sMenuBrowse)
                        keytim = 6
                    }
                }
                // refresh model
                if bb.KeyDown(28) || bb.ButtonPressed() {
                    if foc == 5 {
                        screenCall = 1
                        bb.PlaySound(sMenuGo)
                        keytim = 10
                    }
                }
            }
            // limits
            if charHairStyle[char] < 0 {
                charHairStyle[char] = no_hairstyles
            }
            if charHairStyle[char] > no_hairstyles {
                charHairStyle[char] = 0
            }
            if charHair[char] < 1 {
                charHair[char] = no_hairs
            }
            if charHair[char] > no_hairs {
                charHair[char] = 1
            }
            if charFace[char] < 1 {
                charFace[char] = no_faces
            }
            if charFace[char] > no_faces {
                charFace[char] = 1
            }
            if charSpecs[char] < 0 {
                charSpecs[char] = no_specs
            }
            if charSpecs[char] > no_specs {
                charSpecs[char] = 0
            }
            if charModel[char] < 1 {
                charModel[char] = no_models
            }
            if charModel[char] > no_models {
                charModel[char] = 1
            }
            if charCostume[char] < 0 {
                charCostume[char] = no_costumes
            }
            if charCostume[char] > no_costumes {
                charCostume[char] = 0
            }

            // UPDATE MODEL
            if oldHairStyle != charHairStyle[char] ||
                oldHair != charHair[char] ||
                oldFace != charFace[char] ||
                oldSpecs != charSpecs[char] ||
                oldModel != charModel[char] ||
                oldCostume != charCostume[char] {
                ApplyCostume(cyc)
            }

            // scale
            scaler := f32(charHeight[char]) * 0.0025
            bb.ScaleEntity(p[cyc], 0.35 + scaler, 0.35 + scaler, 0.35 + scaler)

            // shadows
            for limb in 1..=40 {
                if pShadow[cyc][limb] > 0 {
                bb.RotateEntity(pShadow[cyc][limb], 90, bb.EntityYaw(pLimb[cyc][limb], 1), 0)
                bb.PositionEntity(pShadow[cyc][limb], bb.EntityX(pLimb[cyc][limb], 1), pY[cyc] + 0.4, bb.EntityZ(pLimb[cyc][limb], 1))
                }
            }
            // CAMERA
            // change position
            // if bb.KeyDown(36) do pZ[cyc] -= 1
            // if bb.KeyDown(38) do pZ[cyc] += 1
            // if bb.KeyDown(23) do pX[cyc] -= 1
            // if bb.KeyDown(37) do pX[cyc] += 1
            // if bb.KeyDown(35) do pY[cyc] -= 1
            // if bb.KeyDown(21) do pY[cyc] += 1
            // bb.PositionEntity(cam, pX[cyc], pY[cyc], pZ[cyc])

            // change angles
            // camXA: f32 = 3
            // camYA: f32 = 119
            // camZA: f32 = 0
            // if bb.KeyDown(203) do camYA -= 1
            // if bb.KeyDown(205) do camYA += 1
            // if bb.KeyDown(200) do camXA -= 1
            // if bb.KeyDown(208) do camXA += 1
            // camXA = CleanAngle(camXA)
            // camYA = CleanAngle(camYA)
            // bb.RotateEntity(cam, camXA, camYA, camZA)

            bb.UpdateWorld()
        }
        bb.RenderWorld(1)

        // DISPLAY
        bb.DrawImage(gLogo[3], i32(rX(570)), i32(rY(65)))
        // PROFILE DISPLAY
        if page == 1 {
            // main options
            x: f32 = 570
            y: f32 = 145
            DrawOption(1, rX(x), rY(y), "Name", charName[char])
            DrawOption(2, rX(x), rY(y + 55), "Height", GetHeight(charHeight[char]))
            DrawOption(3, rX(x), rY(y + 115), "Strength", fmt.tprintf("%d", charStrength[char]))
            DrawOption(4, rX(x), rY(y + 170), "Agility", fmt.tprintf("%d", charAgility[char]))
            DrawOption(5, rX(x), rY(y + 230), "Intelligence", fmt.tprintf("%d", charIntelligence[char]))
            DrawOption(6, rX(x), rY(y + 285), "Crime", fmt.tprintf("%d. %s", charCrime[char], textCrime[charCrime[char]]))
            DrawOption(7, rX(x), rY(y + 345), ">>> APPEARANCE >>>", "")
            DrawOption(8, rX(x), rY(y + 400), "<<< SAVE & EXIT <<<", "")
            // enter name
            if (bb.KeyDown(14) || bb.ButtonPressed()) && foc == 1 && gotim > 40 && keytim == 0 {
                bb.PlaySound(sMenuBrowse)
                keytim = 20
                bb.FlushKeys()
                bb.DrawImage(gMenu[1], i32(rX(x)), i32(rY(y)))
                DrawOption(1, rX(x), rY(y), "Name", "   ")
                bb.Flip()
                bb.Locate(i32(rX(x)) + 15, i32(rY(y)) - 10)
                bb.Color(255, 255, 255)
                bb.SetFont(font[3])
                oldName := charName[char]
                charName[char] = bb.Left(bb.Input(""), 20)
                if charName[char] == "" {
                    charName[char] = oldName
                }
            } else {
                bb.SetFont(font[2])
                if foc == 1 {
                    Outline("(Press BACKSPACE to change)", i32(rX(x)), i32(rY(y)) + 18, 0, 0, 0, 255, 200, 150)
                }
            }
            // point reminder
            showY: f32 = 0
            if foc >= 3 && foc <= 5 && gamPointLimit < 999 {
                bb.SetFont(font[2])
                switch foc {
                case 3: showY = y + 115
                case 4: showY = y + 170
                case 5: showY = y + 230
                case 6: showY = y + 285
                }
                if gamPoints > 0 {
                    Outline(fmt.tprintf("(%d Points Remaining)", gamPoints), i32(rX(x)), i32(rY(showY)) + 18, 0, 0, 0, 255, 200, 150)
                }
                if gamPoints == 0 {
                    Outline("(No Points Remaining!)", i32(rX(x)), i32(rY(showY)) + 18, 0, 0, 0, 200, 100, 100)
                }
            }
        }
        // APPEARANCE DISPLAY
        if page == 2 {
            // main options
            x: f32 = 570
            y: f32 = 145
            DrawOption(1, rX(x), rY(y), "Hair Style", textHair[charHairStyle[char]])
            DrawOption(2, rX(x), rY(y + 55), "Hair Colour", fmt.tprintf("%d/%d", charHair[char], no_hairs))
            DrawOption(3, rX(x), rY(y + 115), "Face", fmt.tprintf("%d/%d", charFace[char], no_faces))
            DrawOption(4, rX(x), rY(y + 170), "Eyewear", textSpecs[charSpecs[char]])
            DrawOption(5, rX(x), rY(y + 230), "Build", textModel[charModel[char]])
            DrawOption(6, rX(x), rY(y + 285), "Outfit", textCostume[charCostume[char]])
            DrawOption(7, rX(x), rY(y + 345), ">>> PROFILE >>>", "")
            DrawOption(8, rX(x), rY(y + 400), "<<< SAVE & EXIT <<<", "")
            // advice
            bb.SetFont(font[2])
            if foc == 5 {
                Outline("(Press ENTER to apply)", i32(rX(x)), i32(rY(y + 230)) + 18, 0, 0, 0, 255, 200, 150)
            }
        }
        // loading call
        if screenCall == 1 {
            QuickLoader(rX(400), rY(300), "Please Wait", "Reloading Character")
            bb.FreeEntity(p[cyc])
            ReloadModel(cyc)
        }
        // diagnostics
        // bb.SetFont(fontNumber)
        // Outline(fmt.Sprintf("camX: %f", camX), rX(50), rY(50), 0, 0, 0, 255, 200, 150)
        // Outline(fmt.Sprintf("camY: %f", camY), rX(50), rY(65), 0, 0, 0, 255, 200, 150)
        // Outline(fmt.Sprintf("camZ: %f", camZ), rX(50), rY(80), 0, 0, 0, 255, 200, 150)
        // Outline(fmt.Sprintf("camXA: %f", camXA), rX(50), rY(150), 0, 0, 0, 155, 200, 250)
        // Outline(fmt.Sprintf("camYA: %f", camYA), rX(50), rY(165), 0, 0, 0, 155, 200, 250)
        // Outline(fmt.Sprintf("camZA: %f", camZA), rX(50), rY(180), 0, 0, 0, 155, 200, 250)

        bb.Flip()
        // screenshot (F12)
        if bb.KeyHit(88) > 0 {
            Screenshot()
        }
    }
    // leave
    if go >= 1 {
        if go == 1 {
            bb.PlaySound(sMenuGo)
        } else {
            bb.PlaySound(sMenuBack)
        }
    }

    // take photo
    QuickLoader(rX(400), rY(300), "Please Wait", "Saving Character")
    charPhoto[char] = bb.CreateImage(i32(rX(300)), i32(rY(200)))
    bb.GrabImage(charPhoto[char], i32(rX(210)), i32(rY(f32(220 - charHeight[char]))))
    bb.ResizeImage(charPhoto[char], 150, 100)
    bb.SaveImage(charPhoto[char], fmt.tprintf("Data/Slot0%s/Photos/Photo%s.bmp", slot, Dig(char, 100)))
    bb.MaskImage(charPhoto[char], 255, 0, 255)
    charSnapped[char] = 1
    SaveChars()

    // free entities
    bb.FreeTimer(timer)
    bb.FreeEntity(world)
    bb.FreeEntity(cam)
    bb.FreeEntity(light1)
    bb.FreeEntity(p[cyc])
    for limb in 1..=40 {
        if pShadow[cyc][limb] > 0 {
            bb.FreeEntity(pShadow[cyc][limb])
        }
    }

    // proceed
    screen = 8
    if gamPointLimit < 999 {
        for v in 1..=no_chars {
            if charRole[v] == 1 && charLocation[v] == 9 {
                promoAccuser = v
            }
        }
        screen = 52
    }
}


//-----------------------------------------------------------------
//////////////////////// RELATED FUNCTIONS ////////////////////////
//-----------------------------------------------------------------
ReloadModel :: proc(cyc: i32) {
    // sequences
    p[cyc] = bb.LoadAnimMesh(fmt.tprintf("Characters/Models/Model%d.3ds", charModel[pChar[cyc]]))
    pSeq[cyc][604] = bb.LoadAnimSeq(p[cyc], "Characters/Sequences/Standard04.3ds")
    pSeq[cyc][1] = bb.ExtractAnimSeq(p[cyc], 770, 850, pSeq[cyc][604])
    // position
    bb.Animate(p[cyc], 1, 0.1, pSeq[cyc][1], 0)
    bb.PositionEntity(p[cyc], pX[cyc], pY[cyc], pZ[cyc])
    bb.RotateEntity(p[cyc], 0, 345, 0)
    // load appearance
    ApplyCostume(cyc)
    bb.EntityTexture(bb.FindChild(p[cyc], "Head"), tEyes[1], 0, 3)
    // hide weapons by default
    bb.HideEntity(bb.FindChild(p[cyc], "Phone"))
    bb.HideEntity(bb.FindChild(p[cyc], "Barbell"))
    for v in 1..=weapList {
        bb.HideEntity(bb.FindChild(p[cyc], weapFile[v]))
    }
}


// IDENTIFY LIMBS
GetLimbs :: proc(cyc: i32) {
    // reset entries
    for count in 1..=40 {
        pLimb[cyc][count] = 0
    }
    // upper body
    pLimb[cyc][1] = bb.FindChild(p[cyc], "Head")
    pLimb[cyc][2] = bb.FindChild(p[cyc], "Neck")
    if BaggyTop(charCostume[pChar[cyc]]) > 0 {
        pLimb[cyc][3] = bb.FindChild(p[cyc], "Body_Baggy")
    } else {
        pLimb[cyc][3] = bb.FindChild(p[cyc], "Body")
    }
    // left arm
    pLimb[cyc][4] = bb.FindChild(p[cyc], "L_Bicep")
    pLimb[cyc][5] = bb.FindChild(p[cyc], "L_Arm")
    pLimb[cyc][6] = bb.FindChild(p[cyc], "L_Palm")
    pLimb[cyc][7] = bb.FindChild(p[cyc], "L_Thumb01")
    pLimb[cyc][8] = bb.FindChild(p[cyc], "L_Thumb02")
    for count in 1..=8 {
        pLimb[cyc][8 + count] = bb.FindChild(p[cyc], fmt.tprintf("L_Finger0%d", count))
    }
    // right arm
    pLimb[cyc][17] = bb.FindChild(p[cyc], "R_Bicep")
    pLimb[cyc][18] = bb.FindChild(p[cyc], "R_Arm")
    pLimb[cyc][19] = bb.FindChild(p[cyc], "R_Palm")
    pLimb[cyc][20] = bb.FindChild(p[cyc], "R_Thumb01")
    pLimb[cyc][21] = bb.FindChild(p[cyc], "R_Thumb02")
    for count in 1..=8 {
        pLimb[cyc][21 + count] = bb.FindChild(p[cyc], fmt.tprintf("R_Finger0%d", count))
    }
    // lower body
    pLimb[cyc][30] = bb.FindChild(p[cyc], "Hips")
    pLimb[cyc][31] = bb.FindChild(p[cyc], "L_Thigh")
    pLimb[cyc][32] = bb.FindChild(p[cyc], "L_Leg")
    pLimb[cyc][33] = bb.FindChild(p[cyc], "L_Foot")
    pLimb[cyc][34] = bb.FindChild(p[cyc], "R_Thigh")
    pLimb[cyc][35] = bb.FindChild(p[cyc], "R_Leg")
    pLimb[cyc][36] = bb.FindChild(p[cyc], "R_Foot")
    // additional
    pLimb[cyc][37] = bb.FindChild(p[cyc], "L_Ear")
    pLimb[cyc][38] = bb.FindChild(p[cyc], "R_Ear")
}


// MAJOR LIMB?
MajorLimb :: proc(limb: i32) -> i32 {
    return i32((limb >= 4 && limb <= 6) ||
           (limb >= 17 && limb <= 19) ||
           (limb >= 30 && limb <= 36))
}


HandIntact :: proc(cyc: i32, limb: i32) -> i32 { // left=4, right=17
    return i32(!(pScar[cyc][limb] >= 5 ||
             pScar[cyc][limb + 1] >= 5 ||
             pScar[cyc][limb + 2] >= 5))
}


// DESCRIBE LIMB
DescribeLimb :: proc(char: i32) -> string {
    injury := "a limb"
    // ears
    if charScar[char][37] >= 5 || charScar[char][38] >= 5 {
        injury = "an ear"
    }
    // fingers
    for count in 1..=8 {
        if charScar[char][8 + count] >= 5 || charScar[char][21 + count] >= 5 {
            injury = "a finger"
        }
    }
    // thumbs
    if charScar[char][7] >= 5 || charScar[char][8] >= 5 ||
       charScar[char][20] >= 5 || charScar[char][21] >= 5 {
        injury = "a thumb"
    }
    // hands
    if charScar[char][6] >= 5 || charScar[char][19] >= 5 {
        injury = "a hand"
    }
    // feet
    if charScar[char][33] >= 5 || charScar[char][36] >= 5 {
        injury = "a foot"
    }
    // arms
    if charScar[char][4] >= 5 || charScar[char][5] >= 5 ||
       charScar[char][17] >= 5 || charScar[char][18] >= 5 {
        injury = "an arm"
    }
    // legs
    if charScar[char][31] >= 5 || charScar[char][32] >= 5 ||
       charScar[char][34] >= 5 || charScar[char][35] >= 5 {
        injury = "a leg"
    }
    return injury
}


// DETERMINE RACE
GetRace :: proc(char: i32) -> i32 {
    value: i32 = 0
    if charFace[char] >= 21 && charFace[char] <= 40 {
        value = 1 // Asian
    }
    if charFace[char] >= 41 && charFace[char] <= 60 {
        value = 2 // Black
    }
    return value // 0 = White, 1 = Asian, 2 = Black
}


BaggyTop :: proc(costume: i32) -> i32 {
    baggy: i32 = 0
    if costume == 2 || costume == 4 || costume == 6 || costume == 8 {
        baggy = 1
    }
    return baggy
}


ApplyCostume :: proc(cyc: i32) {
    GetLimbs(cyc)
    ApplyHairstyle(cyc)
    ApplyEyewear(cyc)
    ApplyAccessories(cyc)
    ApplyClothing(cyc)
}


RemoveHair :: proc(cyc: i32) {
    for limb in 1..=15 {
        if bb.FindChild(p[cyc], hairFile[limb]) > 0 {
            bb.EntityAlpha(bb.FindChild(p[cyc], hairFile[limb]), 0)
        }
    }
}


ApplyHairstyle :: proc(cyc: i32) {
    // Hide all hair by default
    char := pChar[cyc]
    RemoveHair(cyc)
    showA, showB: i32 = 0, 0
    hairerA, hairerB: string = "", ""

    switch charHairStyle[char] {
    case 2:  hairerA = "Hair_Bald";   showA = 1
    case 3:  hairerA = "Hair_Thin";   showA = 1
    case 4:  hairerA = "Hair_Short";  showA = 1
    case 5:  hairerA = "Hair_Raise";  showA = 1
    case 6:  hairerA = "Hair_Quiff";  showA = 1
    case 7:  hairerA = "Hair_Mop";    showA = 1
    case 8:  hairerA = "Hair_Thick";  showA = 1
    case 9:  hairerA = "Hair_Full";   showA = 1
    case 10: hairerA = "Hair_Curl";   showA = 1
    case 11: hairerA = "Hair_Afro";   showA = 1
    case 12: hairerA = "Hair_Spike";  showA = 1
    case 13: hairerA = "Hair_Punk";   showA = 1
    case 14: hairerA = "Hair_Rolls";  showA = 1
    case 15: hairerA = "Hair_Bald";   hairerB = "Hair_Pony";   showA = 1; showB = 1
    case 16: hairerA = "Hair_Thin";   hairerB = "Hair_Pony";   showA = 1; showB = 1
    case 17: hairerA = "Hair_Short";  hairerB = "Hair_Pony";   showA = 1; showB = 1
    case 18: hairerA = "Hair_Raise";  hairerB = "Hair_Pony";   showA = 1; showB = 1
    case 19: hairerA = "Hair_Quiff";  hairerB = "Hair_Pony";   showA = 1; showB = 1
    case 20: hairerA = "Hair_Mop";    hairerB = "Hair_Pony";   showA = 1; showB = 1
    case 21: hairerA = "Hair_Thick";  hairerB = "Hair_Pony";   showA = 1; showB = 1
    case 22: hairerA = "Hair_Curl";   hairerB = "Hair_Pony";   showA = 1; showB = 1
    case 23: hairerA = "Hair_Punk";   hairerB = "Hair_Pony";   showA = 1; showB = 1
    case 24: hairerA = "Hair_Rolls";  hairerB = "Hair_Pony";   showA = 1; showB = 1
    case 25: hairerA = "Hair_Bald";   hairerB = "Hair_Long";   showA = 1; showB = 1
    case 26: hairerA = "Hair_Thin";   hairerB = "Hair_Long";   showA = 1; showB = 1
    case 27: hairerA = "Hair_Short";  hairerB = "Hair_Long";   showA = 1; showB = 1
    case 28: hairerA = "Hair_Raise";  hairerB = "Hair_Long";   showA = 1; showB = 1
    case 29: hairerA = "Hair_Quiff";  hairerB = "Hair_Long";   showA = 1; showB = 1
    case 30: hairerA = "Hair_Mop";    hairerB = "Hair_Long";   showA = 1; showB = 1
    case 31: hairerA = "Hair_Thick";  hairerB = "Hair_Long";   showA = 1; showB = 1
    }
    // Tuck hair under hat
    if charAccessory[char] == 2 || charAccessory[char] == 7 {
        if charHairStyle[char] >= 2 {
            hairerA = "Hair_Bald"
        }
    }
    // Tuck mop into headband
    if charAccessory[char] == 5 {
        if charHairStyle[char] == 7 || charHairStyle[char] == 20 || charHairStyle[char] == 30 {
            hairerA = "Hair_Short"
        }
    }
    // Compose hair
    if charHairStyle[char] > 1 {
        randy := bb.Rnd(1, 3)
        if showA == 1 {
            bb.EntityAlpha(bb.FindChild(p[cyc], hairerA), 1)
            bb.EntityTexture(bb.FindChild(p[cyc], hairerA), tHair[charHair[char]], 0, 1)
        }
        if showB == 1 {
            bb.EntityAlpha(bb.FindChild(p[cyc], hairerB), 1)
            bb.EntityTexture(bb.FindChild(p[cyc], hairerB), tHair[charHair[char]], 0, 1)
        }
    }
    // Add shaved layer
    if charHairStyle[char] == 1 || charHairStyle[char] == 14 || charHairStyle[char] == 24 {
        bb.EntityTexture(bb.FindChild(p[cyc], "Head"), tShaved, 0, 2)
    } else {
        bb.EntityTexture(bb.FindChild(p[cyc], "Head"), tMouth[0], 0, 2)
    }
}


ApplyEyewear :: proc(cyc: i32) {
    // hide by default
    char := pChar[cyc]
    bb.HideEntity(bb.FindChild(p[cyc], "Specs"))
    bb.HideEntity(bb.FindChild(p[cyc], "Lens01"))
    bb.HideEntity(bb.FindChild(p[cyc], "Lens02"))
    if charSpecs[char] > 0 {
        // compose specs
        bb.ShowEntity(bb.FindChild(p[cyc], "Specs"))
        bb.EntityShininess(bb.FindChild(p[cyc], "Specs"), 0.5)
        for count in 1..=2 {
            bb.ShowEntity(bb.FindChild(p[cyc], fmt.tprintf("Lens0%d", count)))
            bb.EntityColor(bb.FindChild(p[cyc], fmt.tprintf("Lens0%d", count)), 255, 255, 255)
            bb.EntityAlpha(bb.FindChild(p[cyc], fmt.tprintf("Lens0%d", count)), 0.35)
            bb.EntityShininess(bb.FindChild(p[cyc], fmt.tprintf("Lens0%d", count)), 1)
        }
        // golden frame
        if charSpecs[char] == 1 {
            bb.EntityTexture(bb.FindChild(p[cyc], "Specs"), tSpecs[1])
        }
        // silver frame
        if charSpecs[char] == 2 {
            bb.EntityTexture(bb.FindChild(p[cyc], "Specs"), tSpecs[2])
        }
        // black frame
        if charSpecs[char] == 3 {
            bb.EntityTexture(bb.FindChild(p[cyc], "Specs"), tSpecs[3])
        }
        // shades
        if charSpecs[char] == 4 {
            bb.EntityTexture(bb.FindChild(p[cyc], "Specs"), tSpecs[3])
            for count in 1..=2 {
                bb.EntityColor(bb.FindChild(p[cyc], fmt.tprintf("Lens0%d", count)), 0, 0, 0)
                bb.EntityAlpha(bb.FindChild(p[cyc], fmt.tprintf("Lens0%d", count)), 0.75)
            }
        }
    }
}


ApplyAccessories :: proc(cyc: i32) {
    // hide by default
    char := pChar[cyc]
    bb.HideEntity(bb.FindChild(p[cyc], "Turban"))
    bb.HideEntity(bb.FindChild(p[cyc], "Bling"))
    bb.HideEntity(bb.FindChild(p[cyc], "Tie"))
    bb.HideEntity(bb.FindChild(p[cyc], "BandA"))
    bb.HideEntity(bb.FindChild(p[cyc], "BandB"))
    bb.HideEntity(bb.FindChild(p[cyc], "Armband"))
    bb.HideEntity(bb.FindChild(p[cyc], "Cap"))
    // turban
    if charAccessory[char] == 2 {
        bb.ShowEntity(bb.FindChild(p[cyc], "Turban"))
    }
    // bling
    if charAccessory[char] == 3 {
        bb.EntityShininess(bb.FindChild(p[cyc], "Bling"), 1.0)
        bb.ShowEntity(bb.FindChild(p[cyc], "Bling"))
    }
    // tie
    if charAccessory[char] == 4 {
        bb.ShowEntity(bb.FindChild(p[cyc], "Tie"))
    }
    // headband
    if charAccessory[char] == 5 {
        bb.ShowEntity(bb.FindChild(p[cyc], "BandA"))
        if charHairStyle[char] < 1 || charHairStyle[char] == 13 || charHairStyle[char] == 14 ||
           charHairStyle[char] == 23 || charHairStyle[char] == 24 {
            bb.ShowEntity(bb.FindChild(p[cyc], "BandB"))
        }
    }
    // armband
    if charAccessory[char] == 6 {
        bb.ShowEntity(bb.FindChild(p[cyc], "Armband"))
    }
    // cap
    if charAccessory[char] == 7 {
        bb.ShowEntity(bb.FindChild(p[cyc], "Cap"))
    }
}


ApplyClothing :: proc(cyc: i32) {
    // head
    char := pChar[cyc]
    for limb in 1..=2 {
        bb.EntityTexture(pLimb[cyc][1], tFace[charFace[char]], 0, 1)
        bb.EntityTexture(pLimb[cyc][2], tFace[charFace[char]], 0, 1)
    }
    // ears
    for limb in 37..=38 {
        bb.EntityTexture(pLimb[cyc][limb], tFace[charFace[char]], 0, 1)
        bb.EntityTexture(pLimb[cyc][limb], tEars, 0, 3)
    }
    // body
    limb := 3
    bb.EntityTexture(pLimb[cyc][limb], tMouth[0], 0, 2)
    bb.EntityTexture(pLimb[cyc][limb], tMouth[0], 0, 3)
    bb.EntityTexture(pLimb[cyc][limb], tMouth[0], 0, 4)
    if charRole[char] == 0 {
        if charCostume[char] == 0 {
            body: i32
            if (charModel[char] < 2 && charStrength[char] < 70) || charModel[char] > 4 {
                body = 10
            } else {
                body = 1
            }
            bb.EntityTexture(pLimb[cyc][limb], tBody[body], 0, 1)
            if GetRace(char) > 0 {
                bb.EntityTexture(pLimb[cyc][limb], tBodyShade[GetRace(char)], 0, 2)
            }
            if charGang[char] > 0 {
                bb.EntityTexture(pLimb[cyc][limb], tTattooBody[charGang[char]], 0, 3)
            }
        }
        if charCostume[char] >= 1 && charCostume[char] <= 2 {
            bb.EntityTexture(pLimb[cyc][limb], tBody[2], 0, 1)
            if GetRace(char) > 0 {
                bb.EntityTexture(pLimb[cyc][limb], tBodyShade[2 + GetRace(char)], 0, 2)
            }
            if charGang[char] > 0 {
                bb.EntityTexture(pLimb[cyc][limb], tTattooVest[charGang[char]], 0, 3)
            }
        }
        if charCostume[char] >= 3 && charCostume[char] <= 4 {
            bb.EntityTexture(pLimb[cyc][limb], tBody[3], 0, 1)
        }
        if charCostume[char] >= 5 {
            bb.EntityTexture(pLimb[cyc][limb], tBody[4 + charBlock[char]], 0, 1)
        }
        if charCostume[cyc] >= 3 {
            bb.EntityTexture(pLimb[cyc][limb], tBlock[charBlock[char]], 0, 3)
            bb.EntityTexture(pLimb[cyc][limb], tCell[charCell[char]], 0, 4)
        }
    }
    if charRole[char] == 1 do bb.EntityTexture(pLimb[cyc][limb], tBody[4], 0, 1)
    if charRole[char] >= 2 do bb.EntityTexture(pLimb[cyc][limb], tBody[9], 0, 1)
    if BaggyTop(charCostume[char]) > 0 {
        bb.EntityAlpha(bb.FindChild(p[cyc], "Body_Baggy"), 1)
        bb.EntityAlpha(bb.FindChild(p[cyc], "Body"), 0)
    } else {
        bb.EntityAlpha(bb.FindChild(p[cyc], "Body"), 1)
        bb.EntityAlpha(bb.FindChild(p[cyc], "Body_Baggy"), 0)
    }
    // arms
    for limb in 4..=29 {
        bb.EntityTexture(pLimb[cyc][limb], tMouth[0], 0, 2)
        bb.EntityTexture(pLimb[cyc][limb], tMouth[0], 0, 3)
        if charRole[char] == 0 {
            if charCostume[char] <= 2 {
                bb.EntityTexture(pLimb[cyc][limb], tArm[1], 0, 1)
                if GetRace(char) > 0 do bb.EntityTexture(pLimb[cyc][limb], tArmShade[GetRace(char)], 0, 2)
                if charGang[char] > 0 do bb.EntityTexture(pLimb[cyc][limb], tTattooArm[charGang[char]], 0, 3)
            }
            if charCostume[char] >= 3 && charCostume[char] <= 4 {
                bb.EntityTexture(pLimb[cyc][limb], tArm[2], 0, 1)
                if GetRace(char) > 0 do bb.EntityTexture(pLimb[cyc][limb], tArmShade[2 + GetRace(char)], 0, 2)
                if charGang[char] > 0 do bb.EntityTexture(pLimb[cyc][limb], tTattooTee[charGang[char]], 0, 3)
            }
            if charCostume[char] >= 5 && charCostume[char] <= 6 {
                bb.EntityTexture(pLimb[cyc][limb], tArm[3 + charBlock[char]], 0, 1)
                if GetRace(char) > 0 do bb.EntityTexture(pLimb[cyc][limb], tArmShade[2 + GetRace(char)], 0, 2)
                if charGang[char] > 0 do bb.EntityTexture(pLimb[cyc][limb], tTattooTee[charGang[char]], 0, 3)
            }
            if charCostume[char] >= 7 && charCostume[char] <= 8 {
                bb.EntityTexture(pLimb[cyc][limb], tArm[7 + charBlock[char]], 0, 1)
                if GetRace(char) > 0 do bb.EntityTexture(pLimb[cyc][limb], tArmShade[4 + GetRace(char)], 0, 2)
                if charGang[char] > 0 do bb.EntityTexture(pLimb[cyc][limb], tTattooSleeve[charGang[char]], 0, 3)
            }
        }
        if charRole[char] == 1 {
            bb.EntityTexture(pLimb[cyc][limb], tArm[3], 0, 1)
            if GetRace(char) > 0 do bb.EntityTexture(pLimb[cyc][limb], tArmShade[2 + GetRace(char)], 0, 2)
        }
        if charRole[char] >= 2 {
            bb.EntityTexture(pLimb[cyc][limb], tArm[12], 0, 1)
            if GetRace(char) > 0 do bb.EntityTexture(pLimb[cyc][limb], tArmShade[6 + GetRace(char)], 0, 2)
        }
    }
    // legs
    for limb in 30..=36 {
        if charRole[char] == 0 do bb.EntityTexture(pLimb[cyc][limb], tLegs[1 + charBlock[char]], 0, 1)
        if charRole[char] == 1 do bb.EntityTexture(pLimb[cyc][limb], tLegs[1], 0, 1)
        if charRole[char] >= 2 do bb.EntityTexture(pLimb[cyc][limb], tLegs[6], 0, 1)
    }
}


GangAdjust :: proc(char: i32) {
    if charRole[char] == 0 do charAccessory[char] = charGang[char]
    // skinhead & shades
    if charGang[char] == 1 && charHairStyle[char] > 1 {
        charHairStyle[char] = bb.Rnd(0, 1)
        charSpecs[char] = 4
    } 
    // chest vest for thug
    if charGang[char] == 5 && charCostume[char] > 2 do charCostume[char] = bb.Rnd(0, 2)
}











