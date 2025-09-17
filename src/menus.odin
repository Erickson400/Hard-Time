package main
////////////////////////////////////////////////////////////////////////////////
//-------------------------- HARD TIME: MENU SCREENS ---------------------------
////////////////////////////////////////////////////////////////////////////////

import "core:fmt"
import "core:strings"
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



/*
;//////////////////////////////////////////////////////////////////////////////
;---------------------------- 3. REDEFINE KEYS --------------------------------
;//////////////////////////////////////////////////////////////////////////////
Function RedefineKeys()
;frame rating
timer=CreateTimer(30)
;MAIN LOOP
foc=6 : oldfoc=foc : screenCall=0
go=0 : gotim=0 : keytim=20
While go=0

 If screenCall=0 Then Cls

 frames=WaitTimer(timer)
 For framer=1 To frames
	
	;timers
	keytim=keytim-1
	If keytim<1 Then keytim=0
	
	;PORTAL
    gotim=gotim+1
	If gotim>20 And keytim=0 And screenCall=0
	 ;leave
	 If KeyDown(1) Then go=-1
	 ;proceed
	 If KeyDown(28) Or ButtonPressed() Or MouseDown(1)
	  If foc=6 Then go=-1
	 EndIf
	EndIf
	
	;CONFIGURATION 
	If gotim>20 And keytim=0 And screenCall=0
	 ;highlight options
	 If KeyDown(200) Or JoyYDir()=-1 Then foc=foc-1 : PlaySound sMenuSelect : keytim=6
	 If KeyDown(208) Or JoyYDir()=1 Then foc=foc+1 : PlaySound sMenuSelect : keytim=6
	 If foc<1 Then foc=6
	 If foc>6 Then foc=1
	 ;activate
	 If KeyDown(28) Or ButtonPressed()
	  ;enter new command
	  If foc=<4
	   PlaySound sMenuBrowse : keytim=20
	   callX=MouseX() : callY=MouseY()
	   screenCall=foc
	  EndIf
	  ;restore defaults
	  If foc=5
	   PlaySound sTrash : keytim=20
	   keyAttack=30 : keyThrow=31
	   keyDefend=44 : keyPickUp=45
	  EndIf
	 EndIf 
	EndIf   
	
	;INPUT DELAY
    If screenCall>0 And keytim=0
     If screenCall=1 Then keyAttack=AssignKey(keyAttack)
     If screenCall=2 Then keyDefend=AssignKey(keyDefend)
     If screenCall=3 Then keyThrow=AssignKey(keyThrow)
     If screenCall=4 Then keyPickUp=AssignKey(keyPickUp)
    EndIf
	
 UpdateWorld
 Next
 RenderWorld 1

 ;DISPLAY
 TileImage gTile
 DrawImage gLogo(3),rX#(400),rY#(50)
 ;lock mouse
 If screenCall>0 Then MoveMouse callX,callY
 ;options
 SetFont font(1)
 y=120
 DrawOption(1,rX#(400),rY#(y),"Attack / Shoot","'"+Key$(keyAttack)+"' Key")
 DrawOption(2,rX#(400),rY#(y+60),"Defend / Run","'"+Key$(keyDefend)+"' Key")
 DrawOption(3,rX#(400),rY#(y+120),"Throw / Grab","'"+Key$(keyThrow)+"' Key")
 DrawOption(4,rX#(400),rY#(y+180),"Pick Up / Drop","'"+Key$(keyPickUp)+"' Key")
 DrawOption(5,rX#(400),rY#(y+250),"RESTORE DEFAULTS","")
 DrawOption(6,rX#(400),rY#(y+320),"<<< BACK <<<","")
 ;new overlay 
 If screenCall=1 Then DrawOption(1,rX#(400),rY#(y),"Attack / Shoot","Press New Key")
 If screenCall=2 Then DrawOption(2,rX#(400),rY#(y+60),"Defend / Run","Press New Key")
 If screenCall=3 Then DrawOption(3,rX#(400),rY#(y+120),"Throw / Grab","Press New Key")
 If screenCall=4 Then DrawOption(4,rX#(400),rY#(y+180),"Pick Up / Drop","Press New Key")

 Flip
 ;screenshot (F12)
 If KeyHit(88) Then Screenshot()

Wend
;leave
FreeTimer timer
If go=1 Then PlaySound sMenuGo Else PlaySound sMenuBack 
screen=2
End Function
*/