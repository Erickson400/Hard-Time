package main
////////////////////////////////////////////////////////////////////////////////
//----------------------------- HARD TIME: EDITOR ------------------------------
////////////////////////////////////////////////////////////////////////////////

import "core:fmt"
import "core:math"
import "core:strings"
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
    cyc := 1
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
        bb.DrawImage(gLogo[3], rX(570), rY(65))
        // PROFILE DISPLAY
        if page == 1 {
            // main options
            x := 570
            y := 145
            DrawOption(1, rX(x), rY(y), "Name", charName[char])
            DrawOption(2, rX(x), rY(y + 55), "Height", GetHeight(charHeight[char]))
            DrawOption(3, rX(x), rY(y + 115), "Strength", charStrength[char])
            DrawOption(4, rX(x), rY(y + 170), "Agility", charAgility[char])
            DrawOption(5, rX(x), rY(y + 230), "Intelligence", charIntelligence[char])
            DrawOption(6, rX(x), rY(y + 285), "Crime", fmt.Sprintf("%d. %s", charCrime[char], textCrime[charCrime[char]]))
            DrawOption(7, rX(x), rY(y + 345), ">>> APPEARANCE >>>", "")
            DrawOption(8, rX(x), rY(y + 400), "<<< SAVE & EXIT <<<", "")
            // enter name
            if (bb.KeyDown(14) || bb.ButtonPressed()) && foc == 1 && gotim > 40 && keytim == 0 {
                bb.PlaySound(sMenuBrowse)
                keytim = 20
                bb.FlushKeys()
                bb.DrawImage(gMenu[1], rX(x), rY(y))
                DrawOption(1, rX(x), rY(y), "Name", "   ")
                bb.Flip()
                bb.Locate(rX(x) + 15, rY(y) - 10)
                bb.Color(255, 255, 255)
                bb.SetFont(font[3])
                oldName := charName[char]
                charName[char] = strings.Left(bb.Input(""), 20)
                if charName[char] == "" {
                    charName[char] = oldName
                }
            } else {
                bb.SetFont(font[2])
                if foc == 1 {
                    Outline("(Press BACKSPACE to change)", rX(x), rY(y) + 18, 0, 0, 0, 255, 200, 150)
                }
            }
            // point reminder
            showY := 0
            if foc >= 3 && foc <= 5 && gamPointLimit < 999 {
                bb.SetFont(font[2])
                switch foc {
                case 3: showY = y + 115
                case 4: showY = y + 170
                case 5: showY = y + 230
                case 6: showY = y + 285
                }
                if gamPoints > 0 {
                    Outline(fmt.Sprintf("(%d Points Remaining)", gamPoints), rX(x), rY(showY) + 18, 0, 0, 0, 255, 200, 150)
                }
                if gamPoints == 0 {
                    Outline("(No Points Remaining!)", rX(x), rY(showY) + 18, 0, 0, 0, 200, 100, 100)
                }
            }
        }
        // APPEARANCE DISPLAY
        if page == 2 {
            // main options
            x := 570
            y := 145
            DrawOption(1, rX(x), rY(y), "Hair Style", textHair[charHairStyle[char]])
            DrawOption(2, rX(x), rY(y + 55), "Hair Colour", fmt.Sprintf("%d/%d", charHair[char], no_hairs))
            DrawOption(3, rX(x), rY(y + 115), "Face", fmt.Sprintf("%d/%d", charFace[char], no_faces))
            DrawOption(4, rX(x), rY(y + 170), "Eyewear", textSpecs[charSpecs[char]])
            DrawOption(5, rX(x), rY(y + 230), "Build", textModel[charModel[char]])
            DrawOption(6, rX(x), rY(y + 285), "Outfit", textCostume[charCostume[char]])
            DrawOption(7, rX(x), rY(y + 345), ">>> PROFILE >>>", "")
            DrawOption(8, rX(x), rY(y + 400), "<<< SAVE & EXIT <<<", "")
            // advice
            bb.SetFont(font[2])
            if foc == 5 {
                Outline("(Press ENTER to apply)", rX(x), rY(y + 230) + 18, 0, 0, 0, 255, 200, 150)
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
        if bb.KeyHit(88) {
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
    charPhoto[char] = bb.CreateImage(rX(300), rY(200))
    bb.GrabImage(charPhoto[char], rX(210), rY(220 - charHeight[char]))
    bb.ResizeImage(charPhoto[char], 150, 100)
    bb.SaveImage(charPhoto[char], fmt.Sprintf("Data/Slot0%s/Photos/Photo%s.bmp", slot, Dig(char, 100)))
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
    pSeq[cyc, 604] = bb.LoadAnimSeq(p[cyc], "Characters/Sequences/Standard04.3ds")
    pSeq[cyc, 1] = bb.ExtractAnimSeq(p[cyc], 770, 850, pSeq[cyc][604])
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
    if BaggyTop(charCostume[pChar[cyc]]) {
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



/*


*/















