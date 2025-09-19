package main
////////////////////////////////////////////////////////////////////////////////
//-------------------------- HARD TIME: MENU SCREENS ---------------------------
////////////////////////////////////////////////////////////////////////////////

import "core:fmt"
import "core:strings"
import "core:strconv"
import bb "blitzbasic3d"

////////////////////////////////////////////////////////////////////////////////
//------------------------------ 1. MAIN MENU ----------------------------------
////////////////////////////////////////////////////////////////////////////////
MainMenu :: proc() {
    // frame rating
    timer := bb.CreateTimer(30)
    // MAIN LOOP
    foc: i32 = 1
    oldfoc: i32 = foc
    go: i32 = 0
    gotim: i32 = 0
    keytim: i32 = 20

    for go == 0 {
        // clear / timing
        bb.Cls()
        frames := bb.WaitTimer(timer)
        for framer in 1..=frames {
            // timers
            keytim -= 1
            if keytim < 1 do keytim = 0

            // PORTAL
            gotim += 1
            if gotim > 20 && keytim == 0 {
                // leave
                if bb.KeyDown(1) {
                    go = -1
                }
                // proceed
                if bb.KeyDown(28) || bb.ButtonPressed() {
                    go = -1 if foc == 4 else 1
                }
            }

            // CONFIGURATION
            if gotim > 20 && keytim == 0 {
                if bb.KeyDown(200) || bb.JoyYDir() == -1 {
                    foc -= 1
                    bb.PlaySound(sMenuSelect)
                    keytim = 6
                }
                if bb.KeyDown(208) || bb.JoyYDir() == 1 {
                    foc += 1
                    bb.PlaySound(sMenuSelect)
                    keytim = 6
                }
                if foc < 1 do foc = 4
                if foc > 4 do foc = 1
            }
            bb.UpdateWorld()
        }
        bb.RenderWorld(1)

        // DISPLAY
        bb.TileImage(gTile)
        DrawMainLogo(rX(400.0), rY(300.0))
        bb.DrawImage(gMDickie, i32(rX(400.0)), i32(rY(515.0)))
        // options
        DrawOption(1, rX(400.0), rY(75.0), "PLAY", "")
        DrawOption(2, rX(400.0), rY(130.0), "OPTIONS", "")
        DrawOption(3, rX(400.0), rY(185.0), "CREDITS", "")
        DrawOption(4, rX(400.0), rY(415.0), "<<< EXIT <<<", "")

        bb.Flip()
        // screenshot (F12)
        if bb.KeyHit(88) > 0 {
            Screenshot()
        }
    }

    // leave
    bb.FreeTimer(timer)
    if go == 1 {
        bb.PlaySound(sMenuGo)
    } else {
        bb.PlaySound(sMenuBack)
    }
    if go == 1 {
        if foc == 1 do screen = 5
        if foc == 2 do screen = 2
        if foc == 3 {
            gamEnded = 0
            screen = 6
        }
    }
    if go == -1 do screen = 7
}


////////////////////////////////////////////////////////////////////////////////
//------------------------------- 2. OPTIONS -----------------------------------
////////////////////////////////////////////////////////////////////////////////
Options :: proc() {
    // frame rating
    timer := bb.CreateTimer(30)

    // MAIN LOOP
    foc: i32 = 9
    oldfoc: i32 = foc
    go: i32 = 0
    gotim: i32 = 0
    keytim: i32 = 20

    for go == 0 {
        bb.Cls()
        frames := bb.WaitTimer(timer)
        for framer in 1..=frames {

            // timers
            keytim -= 1
            if keytim < 1 do keytim = 0

            // PORTAL
            gotim += 1
            if gotim > 20 && keytim == 0 {
                // leave
                if bb.KeyDown(1) do go = -1
                // proceed
                if bb.KeyDown(28) || bb.ButtonPressed() {
                    if foc < 6 {
                        foc = 9
                        keytim = 10
                    }
                    if foc >= 7 && foc <= 8 do go = 1
                    if foc == 9 && keytim == 0 do go = -1
                }
            }

            // CONFIGURATION
            if gotim > 20 && keytim == 0 {
                // highlight options
                if bb.KeyDown(200) || bb.JoyYDir() == -1 {
                    foc -= 1
                    bb.PlaySound(sMenuSelect)
                    keytim = 6
                }
                if bb.KeyDown(208) || bb.JoyYDir() == 1 {
                    foc += 1
                    bb.PlaySound(sMenuSelect)
                    keytim = 6
                }
                if foc < 1 do foc = 9
                if foc > 9 do foc = 1
                // browse left
                if bb.KeyDown(203) || bb.JoyXDir() == -1 {
                    switch foc {
                        case 1:
                            optRes -= 1
                            bb.PlaySound(sMenuBrowse)
                            keytim = 6
                        case 2:
                            optPopulation -= 5
                            bb.PlaySound(sMenuBrowse)
                            keytim = 6
                        case 3:
                            optFog -= 1
                            bb.PlaySound(sMenuBrowse)
                            keytim = 6
                        case 4:
                            optShadows -= 1
                            bb.PlaySound(sMenuBrowse)
                            keytim = 6
                        case 5:
                            optFX -= 1
                            bb.PlaySound(sMenuBrowse)
                            keytim = 6
                        case 6:
                            optGore -= 1
                            bb.PlaySound(sMenuBrowse)
                            keytim = 6
                    }
                }
                // browse right
                if bb.KeyDown(205) || bb.JoyXDir() == 1 {
                    switch foc {
                        case 1:
                            optRes += 1
                            bb.PlaySound(sMenuBrowse)
                            keytim = 6
                        case 2:
                            optPopulation += 5
                            bb.PlaySound(sMenuBrowse)
                            keytim = 6
                        case 3:
                            optFog += 1
                            bb.PlaySound(sMenuBrowse)
                            keytim = 6
                        case 4:
                            optShadows += 1
                            bb.PlaySound(sMenuBrowse)
                            keytim = 6
                        case 5:
                            optFX += 1
                            bb.PlaySound(sMenuBrowse)
                            keytim = 6
                        case 6:
                            optGore += 1
                            bb.PlaySound(sMenuBrowse)
                            keytim = 6
                    }
                }
            }
            // Check limits
            if optRes < 1 do optRes = 1
            if optRes > 5 do optRes = 5
            if optPopulation < 40 do optPopulation = 40
            if optPopulation > 100 do optPopulation = 100
            if optFog < 0 do optFog = 1
            if optFog > 1 do optFog = 0
            if optShadows < 0 do optShadows = 0
            if optShadows > 2 do optShadows = 2
            if optFX < 0 do optFX = 0
            if optFX > 2 do optFX = 2
            if optGore < 0 do optGore = 0
            if optGore > 3 do optGore = 3

            bb.UpdateWorld()
        }
        bb.RenderWorld(1)

        // DISPLAY
        bb.TileImage(gTile)
        bb.DrawImage(gLogo[3], i32(rX(400.0)), i32(rY(50.0)))
        // options
        bb.SetFont(font[1])
        x, y, spacer: i32 = 300, 200, 53
        DrawOption(1, rX(400.0), rY(f32(y)), "Resolution", fmt.tprint(textResX[optRes], " x ", textResY[optRes])); y += spacer
        DrawOption(2, rX(400.0), rY(f32(y)), "Population", fmt.tprint(optPopulation, " Characters")); y += (spacer + 5)
        DrawOption(3, rX(400.0), rY(f32(y)), "Fog Effect", textOnOff[optFog]); y += spacer
        DrawOption(4, rX(400.0), rY(f32(y)), "Shadows", textShadows[optShadows]); y += spacer
        DrawOption(5, rX(400.0), rY(f32(y)), "Particle FX", textFX[optFX]); y += spacer
        DrawOption(6, rX(400.0), rY(f32(y)), "Gore", textGore[optGore]); y += (spacer + 5)
        DrawOption(7, rX(400.0), rY(f32(y)), "REDEFINE KEYS", ""); y += spacer
        DrawOption(8, rX(400.0), rY(f32(y)), "REDEFINE GAMEPAD", ""); y += (spacer + 5)
        DrawOption(9, rX(400.0), rY(f32(y)), "<<< BACK <<<", "")

        bb.Flip()
        // screenshot (F12)
        if bb.KeyHit(88) > 0 {
            Screenshot()
        }
    }

    // leave
    bb.FreeTimer(timer)
    if go == 1 {
        bb.PlaySound(sMenuGo)
    } else {
        bb.PlaySound(sMenuBack)
    }

    if go == 1 {
        if foc == 7 do screen = 3
        if foc == 8 do screen = 4
        if foc == 9 do screen = 1
    }
    if go == -1 do screen = 1
}


////////////////////////////////////////////////////////////////////////////////
//---------------------------- 3. REDEFINE KEYS --------------------------------
////////////////////////////////////////////////////////////////////////////////
RedefineKeys :: proc() {
    // frame rating
    timer := bb.CreateTimer(30)

    // MAIN LOOP
    foc: i32 = 6
    oldfoc: i32 = foc
    screenCall: i32 = 0
    go: i32 = 0
    gotim: i32 = 0
    keytim: i32 = 20

    for go == 0 {
        if screenCall == 0 do bb.Cls()
        frames := bb.WaitTimer(timer)
        for framer in 1..=frames {
            // timers
            keytim -= 1
            if keytim < 1 do keytim = 0

            // PORTAL
            gotim += 1
            if gotim > 20 && keytim == 0 && screenCall == 0 {
                // leave
                if bb.KeyDown(1) do go = -1
                // proceed
                if bb.KeyDown(28) || bb.ButtonPressed() || bb.MouseDown(1) {
                    if foc == 6 do go = -1
                }
            }

            // CONFIGURATION
            if gotim > 20 && keytim == 0 && screenCall == 0 {
                // highlight options
                if bb.KeyDown(200) || bb.JoyYDir() == -1 {
                    foc -= 1
                    bb.PlaySound(sMenuSelect)
                    keytim = 6
                }
                if bb.KeyDown(208) || bb.JoyYDir() == 1 {
                    foc += 1
                    bb.PlaySound(sMenuSelect)
                    keytim = 6
                }
                if foc < 1 do foc = 6
                if foc > 6 do foc = 1
                // activate
                if bb.KeyDown(28) || bb.ButtonPressed() {
                    // enter new command
                    if foc <= 4 {
                        bb.PlaySound(sMenuBrowse)
                        keytim = 20
                        callX = bb.MouseX()
                        callY = bb.MouseY()
                        screenCall = foc
                    }
                    // restore defaults
                    if foc == 5 {
                        bb.PlaySound(sTrash)
                        keytim = 20
                        keyAttack = 30
                        keyThrow = 31
                        keyDefend = 44
                        keyPickUp = 45
                    }
                }
            }

            // INPUT DELAY
            if screenCall > 0 && keytim == 0 {
                switch screenCall {
                    case 1: keyAttack = AssignKey(keyAttack)
                    case 2: keyDefend = AssignKey(keyDefend)
                    case 3: keyThrow = AssignKey(keyThrow)
                    case 4: keyPickUp = AssignKey(keyPickUp)
                }
            }

            bb.UpdateWorld()
        }
        bb.RenderWorld(1)

        // DISPLAY
        bb.TileImage(gTile)
        bb.DrawImage(gLogo[3], i32(rX(400.0)), i32(rY(50.0)))
        // lock mouse
        if screenCall > 0 {
            bb.MoveMouse(callX, callY)
        }
        // options
        bb.SetFont(font[1])
        y: i32 = 120
        DrawOption(1, rX(400.0), rY(f32(y)), "Attack / Shoot", fmt.tprint("'", Key[keyAttack], "' Key"))
        DrawOption(2, rX(400.0), rY(f32(y + 60)), "Defend / Run", fmt.tprint("'", Key[keyDefend], "' Key"))
        DrawOption(3, rX(400.0), rY(f32(y + 120)), "Throw / Grab", fmt.tprint("'", Key[keyThrow], "' Key"))
        DrawOption(4, rX(400.0), rY(f32(y + 180)), "Pick Up / Drop", fmt.tprint("'", Key[keyPickUp], "' Key"))
        DrawOption(5, rX(400.0), rY(f32(y + 250)), "RESTORE DEFAULTS", "")
        DrawOption(6, rX(400.0), rY(f32(y + 320)), "<<< BACK <<<", "")
        // new overlay
        switch screenCall {
            case 1: DrawOption(1, rX(400.0), rY(f32(y)), "Attack / Shoot", "Press New Key")
            case 2: DrawOption(2, rX(400.0), rY(f32(y + 60)), "Defend / Run", "Press New Key")
            case 3: DrawOption(3, rX(400.0), rY(f32(y + 120)), "Throw / Grab", "Press New Key")
            case 4: DrawOption(4, rX(400.0), rY(f32(y + 180)), "Pick Up / Drop", "Press New Key")
        }

        bb.Flip()
        // screenshot (F12)
        if bb.KeyHit(88) > 0 {
            Screenshot()
        }
    }

    // leave
    bb.FreeTimer(timer)
    if go == 1 {
        bb.PlaySound(sMenuGo)
    } else {
        bb.PlaySound(sMenuBack)
    }
    screen = 2
}


////////////////////////////////////////////////////////////////////////////////
//--------------------------- 4. REDEFINE GAMEPAD ------------------------------
////////////////////////////////////////////////////////////////////////////////
RedefineGamepad :: proc() {
    // frame rating
    timer := bb.CreateTimer(30)

    // MAIN LOOP
    foc: i32 = 6
    oldfoc: i32 = foc
    screenCall: i32 = 0
    go: i32 = 0
    gotim: i32 = 0
    keytim: i32 = 20

    for go == 0 {
        if screenCall == 0 do bb.Cls()
        frames := bb.WaitTimer(timer)
        for framer in 1..=frames {
            // timers
            keytim -= 1
            if keytim < 1 do keytim = 0

            // PORTAL
            gotim += 1
            if gotim > 20 && keytim == 0 && screenCall == 0 {
                // leave
                if bb.KeyDown(1) do go = -1
                // proceed
                if bb.KeyDown(28) || bb.ButtonPressed() || bb.MouseDown(1) {
                    if foc == 6 do go = -1
                }
            }

            // CONFIGURATION
            if gotim > 20 && keytim == 0 && screenCall == 0 {
                // highlight options
                if bb.KeyDown(200) || bb.JoyYDir() == -1 {
                    foc -= 1
                    bb.PlaySound(sMenuSelect)
                    keytim = 6
                }
                if bb.KeyDown(208) || bb.JoyYDir() == 1 {
                    foc += 1
                    bb.PlaySound(sMenuSelect)
                    keytim = 6
                }
                if foc < 1 do foc = 6
                if foc > 6 do foc = 1
                // activate
                if bb.KeyDown(28) || bb.ButtonPressed() {
                    // enter new command
                    if foc <= 4 {
                        bb.PlaySound(sMenuBrowse)
                        keytim = 20
                        callX = bb.MouseX()
                        callY = bb.MouseY()
                        screenCall = foc
                    }
                    // restore defaults
                    if foc == 5 {
                        bb.PlaySound(sTrash)
                        keytim = 20
                        buttAttack = 1
                        buttThrow = 2
                        buttDefend = 3
                        buttPickUp = 4
                    }
                }
            }
            // INPUT DELAY
            if screenCall > 0 && keytim == 0 {
                switch screenCall {
                    case 1: buttAttack = AssignButton(buttAttack)
                    case 2: buttDefend = AssignButton(buttDefend)
                    case 3: buttThrow = AssignButton(buttThrow)
                    case 4: buttPickUp = AssignButton(buttPickUp)
                }
            }

            bb.UpdateWorld()
        }
        bb.RenderWorld(1)

        // DISPLAY
        bb.TileImage(gTile)
        bb.DrawImage(gLogo[3], i32(rX(400.0)), i32(rY(50.0)))
        // lock mouse
        if screenCall > 0 {
            bb.MoveMouse(callX, callY)
        }
        // options
        bb.SetFont(font[1])
        y: i32 = 120
        DrawOption(1, rX(400.0), rY(f32(y)), "Attack / Shoot", fmt.tprint("Button ", buttAttack))
        DrawOption(2, rX(400.0), rY(f32(y + 60)), "Defend / Run", fmt.tprint("Button ", buttDefend))
        DrawOption(3, rX(400.0), rY(f32(y + 120)), "Throw / Grab", fmt.tprint("Button ", buttThrow))
        DrawOption(4, rX(400.0), rY(f32(y + 180)), "Pick Up / Drop", fmt.tprint("Button ", buttPickUp))
        DrawOption(5, rX(400.0), rY(f32(y + 250)), "RESTORE DEFAULTS", "")
        DrawOption(6, rX(400.0), rY(f32(y + 320)), "<<< BACK <<<", "")
        // new overlay
        switch screenCall {
            case 1: DrawOption(1, rX(400.0), rY(f32(y)), "Attack / Shoot", "Press New Button")
            case 2: DrawOption(2, rX(400.0), rY(f32(y + 60)), "Defend / Run", "Press New Button")
            case 3: DrawOption(3, rX(400.0), rY(f32(y + 120)), "Throw / Grab", "Press New Button")
            case 4: DrawOption(4, rX(400.0), rY(f32(y + 180)), "Pick Up / Drop", "Press New Button")
        }

        bb.Flip()
        // screenshot (F12)
        if bb.KeyHit(88) > 0 {
            Screenshot()
        }
    }

    // leave
    bb.FreeTimer(timer)
    if go == 1 {
        bb.PlaySound(sMenuGo)
    } else {
        bb.PlaySound(sMenuBack)
    }
    screen = 2
}


////////////////////////////////////////////////////////////////////////////////
//----------------------------- 5. SLOT SELECT --------------------------------
////////////////////////////////////////////////////////////////////////////////
SlotSelect :: proc() {
    // frame rating
    timer := bb.CreateTimer(30)
    // MAIN LOOP
    if slot >= 1 && slot <= 3 {
        foc: i32 = slot
    } else {
        foc: i32 = 1
    }
    go: i32 = 0
    gotim: i32 = 0
    keytim: i32 = 20

    for go == 0 {
        bb.Cls()
        frames := bb.WaitTimer(timer)
        for framer in 1..=frames {
            // timers
            keytim -= 1
            if keytim < 1 do keytim = 0

            // PORTAL
            gotim += 1
            if gotim > 20 && keytim == 0 {
                // leave
                if bb.KeyDown(1) do go = -1
                // proceed
                if bb.KeyDown(28) || bb.ButtonPressed() {
                    go = -1 if foc == 4 else 1
                }
            }

            // CONFIGURATION
            if gotim > 20 && keytim == 0 {
                // highlight slot
                if bb.KeyDown(200) || bb.JoyYDir() == -1 {
                    foc -= 1
                    bb.PlaySound(sMenuSelect)
                    keytim = 6
                }
                if bb.KeyDown(208) || bb.JoyYDir() == 1 {
                    foc += 1
                    bb.PlaySound(sMenuSelect)
                    keytim = 6
                }
                if foc < 1 do foc = 4
                if foc > 4 do foc = 1
                // reset
                if foc >= 1 && foc <= 3 {
                    if bb.KeyDown(14) || bb.KeyDown(210) {
                        gamName[foc] = ""
                        bb.PlaySound(sTrash)
                        keytim = 10
                    }
                    if bb.KeyDown(18) && gamName[foc] != "" {
                        bb.PlaySound(sComputer)
                        go = 2
                    }
                    if bb.KeyDown(207) && gamName[foc] != "" {
                        bb.PlaySound(sDoor[1])
                        go = 3
                    }
                }
            }

            bb.UpdateWorld()
        }
        bb.RenderWorld(1)

        // DISPLAY
        bb.TileImage(gTile)
        DrawMainLogo(rX(400.0), rY(300.0))
        bb.DrawImage(gMDickie, i32(rX(400.0)), i32(rY(515.0)))
        // game preview
        if foc >= 1 && foc <= 3 {
            if gamName[foc] != "" && gamPhoto[foc] > 0 {
                bb.DrawImage(gamPhoto[foc], i32(rX(400.0) - 160), i32(rY(20.0 + 55.0 * f32(foc))))
                bb.Color(0, 0, 0)
                bb.Rect(i32(rX(400.0) - 235), i32(rY(20.0 + 55.0 * f32(foc)) - 50), 150, 100, false)
            }
        }
        // options
        y: i32 = 75
        for count in 1..=3 {
            if gamName[count] == "" {
                DrawOption(count, rX(400.0), rY(f32(y)), "NEW GAME", "")
            } else {
                DrawOption(count, rX(400.0), rY(f32(y)), gamName[count], "")
            }
            y += 55
        }
        DrawOption(4, rX(400.0), rY(415.0), "<<< BACK <<<", "")

        bb.Flip()
        // screenshot (F12)
        if bb.KeyHit(88) > 0 {
            Screenshot()
        }
    }

    // leave
    bb.FreeTimer(timer)
    if go == 1 {
        bb.PlaySound(sMenuGo)
    } else {
        bb.PlaySound(sMenuBack)
    }
    if go == 1 {
        slot = foc
        oldLocation = 0
        if gamName[foc] == "" {
            Loader("Please Wait", "Generating Game")
            GenerateGame()
            gamChar[0] = gamChar[slot]
            gamPointLimit = 170
            screen = 51
        } else {
            Loader("Please Wait", "Restoring Game")
            LoadProgress()
            LoadChars()
            LoadPhotos()
            LoadItems()
            camX, camY, camZ = 0, 30, 0
            if charY[gamChar[slot]] >= 100 do camY = 130
            if gamLocation[slot] == 2 {
                camX = 350
                camZ = 350
            }
            screen = 50
        }
    }
    if go >= 2 {
        slot = foc
        Loader("Please Wait", "Restoring Game")
        LoadProgress()
        LoadChars()
        LoadPhotos()
        LoadItems()
        if go == 2 do screen = 8
        if go == 3 {
            gamEnded = 0
            screen = 53
        }
    }
    if go == -1 do screen = 1
}


////////////////////////////////////////////////////////////////////////////////
//------------------------------ 8. EDIT SELECT --------------------------------
////////////////////////////////////////////////////////////////////////////////
EditSelect :: proc() {
    // frame rating
    timer := bb.CreateTimer(30)
    // MAIN LOOP
    foc: i32 = 1
    oldfoc: i32 = foc
    go: i32 = 0
    gotim: i32 = 0
    keytim: i32 = 20

    for go == 0 {
        bb.Cls()
        frames := bb.WaitTimer(timer)
        for framer in 1..=frames {
            // timers
            keytim -= 1
            if keytim < 1 do keytim = 0

            // PORTAL
            gotim += 1
            if gotim > 20 && keytim == 0 {
                // leave
                if bb.KeyDown(1) do go = -1
                // proceed
                if bb.KeyDown(28) || bb.ButtonPressed() {
                    go = -1 if foc == 2 else 1
                }
            }

            // CONFIGURATION
            if gotim > 20 && keytim == 0 {
                // highlight option
                if bb.KeyDown(200) || bb.JoyYDir() == -1 {
                    foc -= 1
                    bb.PlaySound(sMenuSelect)
                    keytim = 6
                }
                if bb.KeyDown(208) || bb.JoyYDir() == 1 {
                    foc += 1
                    bb.PlaySound(sMenuSelect)
                    keytim = 6
                }
                if foc < 1 do foc = 2
                if foc > 2 do foc = 1
                // browse characters
                if foc == 1 {
                    if bb.KeyDown(203) || bb.JoyXDir() == -1 {
                        gamChar[0] -= 1
                        bb.PlaySound(sMenuBrowse)
                        keytim = 5
                    }
                    if bb.KeyDown(205) || bb.JoyXDir() == 1 {
                        gamChar[0] += 1
                        bb.PlaySound(sMenuBrowse)
                        keytim = 5
                    }
                }
            }
            // limits
            if gamChar[0] < 1 do gamChar[0] = no_chars
            if gamChar[0] > no_chars do gamChar[0] = 1

            bb.UpdateWorld()
        }
        bb.RenderWorld(1)

        // DISPLAY
        bb.TileImage(gTile)
        DrawMainLogo(rX(400.0), rY(300.0))
        bb.DrawImage(gMDickie, i32(rX(400.0)), i32(rY(515.0)))
        // options
        if charSnapped[gamChar[0]] > 0 && charPhoto[gamChar[0]] > 0 {
            bb.DrawImage(charPhoto[gamChar[0]], i32(rX(400.0)), i32(rY(185.0) - 80.0))
        } else {
            bb.DrawImage(gPhoto, i32(rX(400.0)), i32(rY(185.0) - 80.0))
        }
        DrawOption(1, rX(400.0), rY(185.0), "Character", fmt.tprint(gamChar[0], ". ", charName[gamChar[0]]))
        DrawOption(2, rX(400.0), rY(415.0), "<<< BACK <<<", "")

        bb.Flip()
        // screenshot (F12)
        if bb.KeyHit(88) > 0 {
            Screenshot()
        }
    }

    // leave
    bb.FreeTimer(timer)
    if go == 1 {
        bb.PlaySound(sMenuGo)
    } else {
        bb.PlaySound(sMenuBack)
    }
    if go == 1 {
        gamPointLimit = 999
        screen = 51
    }
    if go == -1 do screen = 5
}


//////////////////////////////////////////////////////////////////
//---------------------- RELATED FUNCTIONS -----------------------
//////////////////////////////////////////////////////////////////
DrawMainLogo :: proc(x: f32, y: f32) {
    // logo halves
    bb.DrawImage(gLogo[1], i32(x), i32(y))
    bb.DrawImage(gLogo[2], i32(x), i32(y))
    // version ID
    bb.SetFont(font[1])
    Outline(fmt.tprint("Version 1.", version), i32(x + 310.0), i32(y + 20.0), 20, 20, 20, 20, 20, 20)
}


//DRAW MENU ITEM
DrawOption :: proc(box: i32, x: f32, y: f32, scriptA: string, scriptB: string) {
    // assess highlight
    highlight := 0
    if foc == box || box == -1 do highlight = 1
    // draw solo box
    if scriptB == "" {
        if highlight == 1 do bb.DrawImage(gMenu[1], i32(x), i32(y))
        if highlight == 0 do bb.DrawImage(gMenu[2], i32(x), i32(y))
        SqueezeFont(scriptA, 185.0, 3)
        r, g, b: i32 = 135, 135, 135
        if highlight == 1 {
            r, g, b = 255, 255, 255
        }
        Outline(scriptA, i32(x), i32(y), 0, 0, 0, r, g, b)
    }
    // draw twin box
    if scriptB != "" {
        if highlight == 1 do bb.DrawImage(gMenu[3], i32(x), i32(y))
        if highlight == 0 do bb.DrawImage(gMenu[4], i32(x), i32(y))
        SqueezeFont(scriptA, 185.0, 3)
        r, g, b: i32 = 135, 135, 135
        if highlight == 1 {
            r, g, b = 255, 255, 255
        }
        Outline(scriptA, i32(x - 100.0), i32(y), 0, 0, 0, r, g, b)
        SqueezeFont(scriptB, 185.0, 3)
        Outline(scriptB, i32(x + 100.0), i32(y), 0, 0, 0, r, g, b)
    }
}

// SQUEEZE FONT INTO BOX
SqueezeFont :: proc(script: string, width, start: i32) {
    f: i32 = start
    bb.SetFont(font[f])
    for f > 0 && bb.StringWidth(script) > width {
        f -= 1
        bb.SetFont(font[f])
    }
}

// ASSIGN KEY PROCESS
AssignKey :: proc(current: i32) -> i32 {
    value: i32 = 0
    for value == 0 {
        for v in i32(0)..=255 {
            if bb.KeyDown(v) && keytim == 0 {
                if v != 0 && v != 1 && v != 28 && v != 25 {
                    value = v
                    screenCall = 0
                    bb.PlaySound(sMenuSelect)
                    gotim = 0
                    keytim = 20
                }
            }
        }
        if bb.KeyDown(1) && keytim == 0 {
            value = current
            screenCall = 0
            bb.PlaySound(sMenuBack)
            go = 0
            gotim = 0
            keytim = 30
        }
    }
    return value
}


// ASSIGN BUTTON PROCESS
AssignButton :: proc(current: i32) -> i32 {
    value: i32 = 28
    for value == 28 {
        for v in i32(1)..=12 {
            if bb.JoyDown(v) && keytim == 0 {
                value = v
                screenCall = 0
                bb.PlaySound(sMenuSelect)
                gotim = 0
                keytim = 20
            }
        }
        if bb.KeyDown(1) && keytim == 0 {
            value = current
            screenCall = 0
            bb.PlaySound(sMenuBack)
            go = 0
            gotim = 0
            keytim = 30
        }
    }
    return value
}


// STANDARD LOADING DISPLAY
Loader :: proc(scriptA: string, scriptB: string) {
    bb.Cls()
    // logos
    bb.TileImage(gTile)
    DrawMainLogo(rX(400.0), rY(300.0))
    bb.DrawImage(gMDickie, i32(rX(400.0)), i32(rY(515.0)))
    // message
    DrawOption(-1, rX(400.0), rY(415.0), scriptA, scriptB)
    // map reference
    if screen == 50 || screen == 52 {
        DisplayMap(400, 125)
    }
    bb.Flip()
}


// QUICK LOADING DISPLAY
QuickLoader :: proc(x: f32, y: f32, scriptA: string, scriptB: string) {
    bb.SetFont(font[1])
    DrawOption(-1, x, y, scriptA, scriptB)
    bb.Flip()
}


DisplayMap :: proc(x, y: i32) {
    bb.DrawImage(gMap, i32(rX(f32(x))), i32(rY(f32(y))))
    if screen == 50 {
        if gamLocation[slot] == 1 do bb.DrawImage(gMarker, i32(rX(f32(x)) - 21.0), i32(rY(f32(y)) - 46.0))
        if gamLocation[slot] == 2 do bb.DrawImage(gMarker, i32(rX(f32(x)) + 22.0), i32(rY(f32(y)) - 72.0))
        if gamLocation[slot] == 3 do bb.DrawImage(gMarker, i32(rX(f32(x)) + 47.0), i32(rY(f32(y)) - 15.0))
        if gamLocation[slot] == 4 {
            if oldLocation == 10 || (oldLocation == 4 && charLocation[gamChar[slot]] == 10) {
                bb.DrawImage(gMarker, i32(rX(f32(x)) + 55.0), i32(rY(f32(y)) + 30.0))
            } else {
                bb.DrawImage(gMarker, i32(rX(f32(x)) + 47.0), i32(rY(f32(y)) + 26.0))
            }
        }
        if gamLocation[slot] == 5 do bb.DrawImage(gMarker, i32(rX(f32(x)) + 20.0), i32(rY(f32(y)) + 53.0))
        if gamLocation[slot] == 6 {
            if oldLocation == 11 || (oldLocation == 6 && charLocation[gamChar[slot]] == 11) {
                bb.DrawImage(gMarker, i32(rX(f32(x)) - 21.0), i32(rY(f32(y)) + 67.0))
            } else {
                bb.DrawImage(gMarker, i32(rX(f32(x)) - 22.0), i32(rY(f32(y)) + 54.0))
            }
        }
        if gamLocation[slot] == 7 do bb.DrawImage(gMarker, i32(rX(f32(x)) - 50.0), i32(rY(f32(y)) + 23.0))
        if gamLocation[slot] == 8 do bb.DrawImage(gMarker, i32(rX(f32(x)) - 48.0), i32(rY(f32(y)) - 21.0))
        if gamLocation[slot] == 9 {
            if oldLocation == 0 do bb.DrawImage(gMarker, i32(rX(f32(x))), i32(rY(f32(y)) + 5.0))
            if oldLocation == 1 || (oldLocation == 9 && charLocation[gamChar[slot]] == 1) do bb.DrawImage(gMarker, i32(rX(f32(x)) - 21.0), i32(rY(f32(y)) - 31.0))
            if oldLocation == 2 || (oldLocation == 9 && charLocation[gamChar[slot]] == 2) do bb.DrawImage(gMarker, i32(rX(f32(x)) + 21.0), i32(rY(f32(y)) - 31.0))
            if oldLocation == 3 || (oldLocation == 9 && charLocation[gamChar[slot]] == 3) do bb.DrawImage(gMarker, i32(rX(f32(x)) + 37.0), i32(rY(f32(y)) - 16.0))
            if oldLocation == 4 || (oldLocation == 9 && charLocation[gamChar[slot]] == 4) do bb.DrawImage(gMarker, i32(rX(f32(x)) + 37.0), i32(rY(f32(y)) + 25.0))
            if oldLocation == 5 || (oldLocation == 9 && charLocation[gamChar[slot]] == 5) do bb.DrawImage(gMarker, i32(rX(f32(x)) + 20.0), i32(rY(f32(y)) + 40.0))
            if oldLocation == 6 || (oldLocation == 9 && charLocation[gamChar[slot]] == 6) do bb.DrawImage(gMarker, i32(rX(f32(x)) - 22.0), i32(rY(f32(y)) + 40.0))
            if oldLocation == 7 || (oldLocation == 9 && charLocation[gamChar[slot]] == 7) do bb.DrawImage(gMarker, i32(rX(f32(x)) - 39.0), i32(rY(f32(y)) + 24.0))
            if oldLocation == 8 || (oldLocation == 9 && charLocation[gamChar[slot]] == 8) do bb.DrawImage(gMarker, i32(rX(f32(x)) - 40.0), i32(rY(f32(y)) - 21.0))
        }
        if gamLocation[slot] == 10 do bb.DrawImage(gMarker, i32(rX(f32(x)) + 55.0), i32(rY(f32(y)) + 44.0))
        if gamLocation[slot] == 11 do bb.DrawImage(gMarker, i32(rX(f32(x)) - 21.0), i32(rY(f32(y)) + 78.0))
    }
}


ChangeResolution :: proc(resolution: i32, task: i32) {
    // assess preferences
    width := i32(strconv.atoi(textResX[resolution]))
    height := i32(strconv.atoi(textResY[resolution]))
    if bb.GfxMode3DExists(width, height, 16) == false {
        width = 800
        height = 600
        optRes = 2
    }
    // make transition?
    if width != bb.GraphicsWidth() || height != bb.GraphicsHeight() {
        if task > 0 {
            Loader("Please Wait", "Adjusting Resolution")
        }
        bb.Graphics3D(width, height, 16, 1)
        if task > 0 {
            LoadImages()
            Loader("Please Wait", "Restoring Media")
            LoadPhotos()
            LoadTextures()
            LoadWeaponData()
        }
    }
}


// GET SCREENSHOT
Screenshot :: proc() {
    // obtain image
    bb.PlaySound(sCamera)
    screenshot := bb.CreateImage(bb.GraphicsWidth(), bb.GraphicsHeight())
    bb.GrabImage(screenshot, bb.GraphicsWidth() / 2, bb.GraphicsHeight() / 2)
    // title & save
    temp := bb.MilliSecs() / 10
    namer := fmt.tprint("Screenshot - ", temp, ".bmp")
    bb.SaveImage(screenshot, fmt.tprint("Photo Album/", namer))
}
