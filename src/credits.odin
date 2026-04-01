package main

import bb "blitzbasic3d"
import "core:fmt"
import "core:mem"
import "core:strings"

////////////////////////////////////////////////////////////////////////////////
//------------------------------ HARD TIME: CREDITS ----------------------------
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
//--------------------------------- INTRO --------------------------------------
////////////////////////////////////////////////////////////////////////////////
Intro :: proc() {
	checkpoint := mem.begin_arena_temp_memory(cast(^mem.Arena)context.temp_allocator.data)
	// initial media
	font[0] = bb.LoadFont("Kristen ITC.ttf", 13, 0, 0, 0)
	font[1] = bb.LoadFont("Kristen ITC.ttf", 16, 0, 0, 0)
	font[2] = bb.LoadFont("Kristen ITC.ttf", 20, 0, 0, 0)
	font[3] = bb.LoadFont("Kristen ITC.ttf", 24, 0, 0, 0)
	font[4] = bb.LoadFont("Kristen ITC.ttf", 36, 0, 0, 0)
	font[5] = bb.LoadFont("Kristen ITC.ttf", 42, 0, 0, 0)
	font[6] = bb.LoadFont("Kristen ITC.ttf", 48, 0, 0, 0)
	gTile = bb.LoadImage("Graphics/Tile.png")
	bb.MaskImage(gTile, 255, 0, 255)
	for count in 1..=3 {
		gLogo[count] = bb.LoadImage(fmt.tprint("Graphics/Logo0", count, ".png"))
		bb.MaskImage(gLogo[count], 255, 0, 255)
	}
	gMDickie = bb.LoadImage("Graphics/MDickie.png")
	bb.MaskImage(gMDickie, 255, 0, 255)
	for count in 1..=4 {
		gMenu[count] = bb.LoadImage(fmt.tprint("Graphics/Menu0", count, ".png"))
		bb.MaskImage(gMenu[count], 255, 0, 255)
	}
	// frame rating
	timer := bb.CreateTimer(30)
	// MAIN LOOP
	logoX1: f32 = -100
	logoX2: f32 = 900
	go = 0
	gotim = 0
	keytim = 20
	for go == 0 {

		bb.Cls()
		frames := bb.WaitTimer(timer)
		for framer in 1..=frames {
			
			// PROCESS     
			gotim += 1
			logoX1 += 40
			if logoX1 > 400 do logoX1 = 400
			logoX2 -= 40
			if logoX2 < 400 do logoX2 = 400
			if logoX1 == 400 && logoX2 == 400 && go == 0 {
				bb.PlaySound(sMenuGo)
				go = 1
			}
			
			bb.UpdateWorld()
		}
		bb.RenderWorld(1)

		// DISPLAY
		bb.TileImage(gTile)
		bb.DrawImage(gLogo[1], i32(rX(logoX1)), i32(rY(300)))
		bb.DrawImage(gLogo[2], i32(rX(logoX2)), i32(rY(300)))

		bb.Flip()
		// screenshot (F12)
		if cast(bool)bb.KeyHit(88) do Screenshot()
	}
	// leave
	Loader("Please Wait", "Loading Game")
	sTheme = bb.LoadSound("Sound/Theme.wav")
	bb.LoopSound(sTheme)
	chTheme = bb.PlaySound(sTheme)
	musicVol: f32 = 1.0
	bb.ChannelVolume(chTheme, musicVol)
	bb.FreeTimer(timer)
	mem.end_arena_temp_memory(checkpoint)
}


// //////////////////////////////////////////////////////////////////////////////
// ------------------------------- 6. CREDITS -----------------------------------
// //////////////////////////////////////////////////////////////////////////////
Credits :: proc() {
	// camera for fading
	cam = bb.CreateCamera()
	bb.CameraViewport(cam, 0, 0, bb.GraphicsWidth(), bb.GraphicsHeight())
	bb.CameraClsMode(cam, 0, 1)
	// sprite For fading
	fader = bb.CreateSprite()
	bb.ScaleSprite(fader, 30, 30)
	bb.SpriteViewMode(fader, 1)
	bb.PositionEntity(fader, 0, 20, -5)
	bb.PointEntity(cam, fader)
	fadeAlpha = 0
	if gamEnded == 1 do fadeAlpha = 1.0
	bb.EntityAlpha(fader, fadeAlpha)
	bb.EntityColor(fader, 0, 0, 0)
	// frame rating
	timer := bb.CreateTimer(30)
	// MAIN LOOP
	scroll: f32 = 0
	gamma: f32 = 0
	go = 0
	gotim = 0
	keytim = 20
	for go == 0 {
		bb.Cls()
		frames := bb.WaitTimer(timer)
		for framer in 1..=frames {
			
			// timers
			keytim -= 1
			if keytim < 1 do keytim = 0
			
			// PORTAL
			if gamEnded == 0 || fadeAlpha < 0.5 do gotim += 1
			if gotim > 20 && keytim == 0 {
				if cast(bool)bb.KeyDown(1) || cast(bool)bb.KeyDown(28) || cast(bool)ButtonPressed() do go = 1
			}
			
			// scroller
			if gotim > 20 {
				scroll -= 1
                // NOTE: Likely a bug. bb.JoyY() might be a typo, JoyYDir() is the probable function.
				if cast(bool)bb.KeyDown(200) || bb.JoyYDir() == -1.0 do scroll -= 5
				if cast(bool)bb.KeyDown(208) || bb.JoyYDir() == 1.0 do scroll += 6
				if scroll < -1300.0 do scroll = 400.0
				if scroll > 400.0 do scroll = -1300.0
			}
			
			// fade in
			if gamEnded == 1 {
				fadeAlpha -= 0.01
				if fadeAlpha <= 0 {
					fadeAlpha = 0
					gamEnded = 0
				}
				bb.EntityAlpha(fader, fadeAlpha)
			}
			
			bb.UpdateWorld()
		}
		
		// DISPLAY
		bb.TileImage(gTile)
		DrawMainLogo(rX(400), rY(300 + scroll))
		// opening comment
		bb.SetFont(font[3])
		y: f32 = 410
		Outline("Credit is to be given - not", i32(rX(400)), i32(rY(y + scroll)), 0, 0, 0, 255, 255, 255); y += 25
		Outline("taken. This game was made single-", i32(rX(400)), i32(rY(y + scroll)), 0, 0, 0, 255, 255, 255); y += 25
		Outline("handedly in 3 months. Figure out", i32(rX(400)), i32(rY(y + scroll)), 0, 0, 0, 255, 255, 255); y += 25
		Outline("how you feel about that...", i32(rX(400)), i32(rY(y + scroll)), 0, 0, 0, 255, 255, 255); y += 25
		// roles
		y = 550
		DrawOption(-1, rX(400), rY(y + scroll), "Concept", "© MDickie 2006"); y += 60
		DrawOption(-1, rX(400), rY(y + scroll), "Game Design", "Mat Dickie"); y += 60
		DrawOption(-1, rX(400), rY(y + scroll), "Programming", "Mat Dickie"); y += 60
		DrawOption(-1, rX(400), rY(y + scroll), "2D Graphics", "Mat Dickie"); y += 60
		DrawOption(-1, rX(400), rY(y + scroll), "3D Modeling", "Mat Dickie"); y += 60
		DrawOption(-1, rX(400), rY(y + scroll), "Texturing", "Mat Dickie"); y += 60
		DrawOption(-1, rX(400), rY(y + scroll), "Animation", "Mat Dickie"); y += 60
		DrawOption(-1, rX(400), rY(y + scroll), "Sound FX", "Mat Dickie"); y += 60
		DrawOption(-1, rX(400), rY(y + scroll), "Music", "Mat Dickie"); y += 60
		DrawOption(-1, rX(400), rY(y + scroll), "Scripts", "Mat Dickie"); y += 60
		DrawOption(-1, rX(400), rY(y + scroll), "Publishing", "MDickie.com"); y += 110
		
		// final logo
		bb.DrawImage(gMDickie, i32(rX(400)), i32(rY(y + scroll)))
		
		bb.RenderWorld(1)
		bb.Flip()
		
		// screenshot (F12)
		if cast(bool)bb.KeyHit(88) do Screenshot()
	}
	
	// leave
	if go == 1 do bb.PlaySound(sMenuGo)
	else do bb.PlaySound(sMenuBack)
	bb.FreeTimer(timer)
	bb.FreeEntity(cam)
	bb.FreeEntity(fader)
	screen = 1
}


// //////////////////////////////////////////////////////////////////////////////
// -------------------------------- 7. OUTRO ------------------------------------
// //////////////////////////////////////////////////////////////////////////////
Outro :: proc() {
	// frame rating
	timer := bb.CreateTimer(30)
	// MAIN LOOP
	colour: i32 = 0
	logoX1: f32 = 400.0
	logoX2: f32 = 400.0
	go = 0
	gotim  = 0
	keytim = 20
	for go == 0 {

		bb.Cls()
		frames := bb.WaitTimer(timer)
		for framer in 1 ..= frames {
			
			// PROCESS     
			gotim += 1
			if gotim > 50 {
				if cast(bool)bb.KeyDown(1) || cast(bool)bb.KeyDown(28) || cast(bool)ButtonPressed() || gotim > 400 do go = 1
			}
			// logo slide
			logoX1 -= 40.0
			logoX2 += 40.0
			// text fade
			colour += 20
			if colour > 255 do colour = 255
			// music fade
			musicVol -= 0.0025
			if musicVol < 0.0 do musicVol = 0.0
			bb.ChannelVolume(chTheme, musicVol)
			bb.UpdateWorld()
		}
		bb.RenderWorld(1)

		// DISPLAY
		bb.TileImage(gTile)
		// bb.SetFont(font[4])
		// Outline("'Turning nothing into", i32(rX(400)), i32(rY(300))-20, 0, 0, 0, colour, colour, colour)
		// Outline("something is God work...'", i32(rX(400)), i32(rY(300))+20, 0, 0, 0, colour, colour, colour)
		// Outline("'Tough times never last,", i32(rX(400)), i32(rY(300))-20, 0, 0, 0, colour, colour, colour)
		// Outline("but tough people do...'", i32(rX(400)), i32(rY(300))+20, 0, 0, 0, colour, colour, colour)
		bb.SetFont(font[3])
		Outline("'When a member of society falls down, he falls for those", i32(rX(400)), i32(rY(300))-48, 0, 0, 0, colour, colour, colour)
		Outline("behind him - as a caution against the stumbling stone.", i32(rX(400)), i32(rY(300))-18, 0, 0, 0, colour, colour, colour)
		Outline("And he falls for those ahead of him - who, though", i32(rX(400)), i32(rY(300))+15, 0, 0, 0, colour, colour, colour)
		Outline("faster and surer of foot, failed to remove the stone...'", i32(rX(400)), i32(rY(300))+45, 0, 0, 0, colour, colour, colour)
		bb.SetFont(font[2])
		Outline("- Kahlil Gibran", i32(rX(400)), i32(rY(300))+75, 0, 0, 0, colour, colour, colour)  
		bb.DrawImage(gLogo[1], i32(rX(logoX1)), i32(rY(300)))
		bb.DrawImage(gLogo[2], i32(rX(logoX2)), i32(rY(300)))
		bb.DrawImage(gMDickie, i32(rX(400)), i32(rY(515)))

		bb.Flip()
		// screenshot (F12)
		if cast(bool)bb.KeyHit(88) do Screenshot()

	}
	// leave
	bb.FreeTimer(timer)
	bb.StopChannel(chTheme)
	SaveOptions()
	screen = 0
}


//---------------------------------------------------------------
///////////////////////// 53. ENDING ////////////////////////////
//---------------------------------------------------------------
Ending :: proc() {
	checkpoint := mem.begin_arena_temp_memory(cast(^mem.Arena)context.temp_allocator.data)
	//load setting
	Loader("Please Wait", "Leaving Prison")
	world = bb.LoadAnimMesh("World/Yard/Outro.3ds")
	bb.EntityTexture(bb.FindChild(world, "Sign01"), tSign[9], 0, 2)
	bb.EntityTexture(bb.FindChild(world, "Net"), tNet)
	sAtmos = bb.LoadSound("Sound/Ambience/Yard.wav")
	//camera
	cam = bb.CreateCamera()
	bb.CameraViewport(cam, 0, 0, bb.GraphicsWidth(), bb.GraphicsHeight())
	camX = 375.0; camY = 30.0; camZ = -20.0
	camPivot = bb.CreatePivot()
	dummy = bb.CreatePivot()
	//fader
	fader = bb.CreateSprite()
	bb.ScaleSprite(fader, 20.0, 20.0)
	bb.SpriteViewMode(fader, 1)
	fadeAlpha = 0.0; fadeTarget = 0.0
	bb.EntityAlpha(fader, fadeAlpha)
	bb.EntityColor(fader, 0.0, 0.0, 0.0)
	//lighting
	LoadLighting()
	bb.AmbientLight(200.0, 190.0, 170.0)
	for count in 1..=no_lights {
		bb.LightColor(light[count], 200.0, 180.0, 160.0)
	}
	if optFog > 0 {
		bb.CameraFogMode(cam, 1)
		bb.CameraFogRange(cam, 500.0, 1000.0)
		bb.CameraFogColor(cam, 160.0, 130.0, 100.0)
	}
	bb.EntityColor(bb.FindChild(world, "Sky"), 220.0, 200.0, 180.0)
	//background noise
	bb.LoopSound(sAtmos)
	chAtmos = bb.PlaySound(sAtmos)
	bb.ChannelVolume(chAtmos, 0.1)
	//load character
	cyc: i32 = 1
	pChar[cyc] = gamChar[slot]
	p[cyc] = bb.LoadAnimMesh(fmt.tprint("Characters/Models/Model", Dig(charModel[pChar[cyc]], 10), ".3ds", sep=""))
	pSeq[cyc][603] = bb.LoadAnimSeq(p[cyc], "Characters/Sequences/Standard03.3ds")
	pSeq[cyc][604] = bb.LoadAnimSeq(p[cyc], "Characters/Sequences/Standard04.3ds")
	pSeq[cyc][1] = bb.ExtractAnimSeq(p[cyc], 770, 850, pSeq[cyc][604]) //standing
	pSeq[cyc][2] = bb.ExtractAnimSeq(p[cyc], 915, 995, pSeq[cyc][603]) //walking
	ApplyCostume(cyc)
	bb.EntityTexture(pLimb[cyc][1], tEyes[3], 0, 3)
	for limb in 1..=40 {
		pScar[cyc][limb] = charScar[pChar[cyc]][limb]
		if pLimb[cyc][limb] > 0 && pScar[cyc][limb] >= 5 {
			bb.HideEntity(pLimb[cyc][limb])
		}
	}
	SeverLimbs(cyc)
	for v in 1..=weapList {
		bb.HideEntity(bb.FindChild(p[cyc], weapFile[v]))
	}
	bb.HideEntity(bb.FindChild(p[cyc], "Barbell"))
	bb.HideEntity(bb.FindChild(p[cyc], "Phone"))
	pX[cyc] = 355.0; pY[cyc] = 12.0; pZ[cyc] = -30.0
	bb.PositionEntity(p[cyc], pX[cyc], pY[cyc], pZ[cyc])
	bb.RotateEntity(p[cyc], 0.0, 0.0, 0.0)
	scaler := f32(charHeight[pChar[cyc]]) * 0.0025
	bb.ScaleEntity(p[cyc], 0.34 + scaler, 0.34 + scaler, 0.34 + scaler)
	bb.Animate(p[cyc], 1, bb.RndF(0.1, 0.3), pSeq[cyc][1], 0.0)
	pStepTim[cyc] = 0; pState[cyc] = 1
	//shadows
	for limb in 1..=40 {
		pShadow[cyc][limb] = 0
		if limb == 30 || (optShadows == 2 && (limb == 1 \
        || (limb >= 4 && limb <= 6) || (limb >= 17 && limb <= 19) \
        || limb == 32 || limb == 33 || limb == 35 || limb == 36)) {
			pShadow[cyc][limb] = bb.LoadSprite("World/Sprites/Shadow.png", 2)
			bb.ScaleSprite(pShadow[cyc][limb], 13.0, 13.0)
			if limb != 30 do bb.ScaleSprite(pShadow[cyc][limb], 10.0, 10.0)
			if limb == 6 || limb == 19 || limb == 33 || limb == 36 do bb.ScaleSprite(pShadow[cyc][limb], 8.0, 8.0)
			bb.RotateEntity(pShadow[cyc][limb], 90.0, 0.0, 0.0)
			bb.SpriteViewMode(pShadow[cyc][limb], 2)
			bb.EntityAlpha(pShadow[cyc][limb], 0.1)
			if optShadows == 2 && (limb == 30 || limb == 6 || limb == 19) do bb.EntityAlpha(pShadow[cyc][limb], 0.2)
			if optShadows == 1 do bb.EntityAlpha(pShadow[cyc][limb], 0.5)
			if optShadows == 0 do bb.EntityAlpha(pShadow[cyc][limb], 0.0)
			bb.EntityColor(pShadow[cyc][limb], 10.0, 10.0, 10.0)
		}
	}
	//generate stories
	for count in 1..=9 {
		its := 0
		for {
			conflict := 0; its += 1
			endChar[count] = bb.RndI(1, no_chars)
			if charSnapped[endChar[count]] == 0 && its < 200 do conflict = 1
			if endChar[count] == gamChar[slot] || charRole[endChar[count]] > 0 || charHealth[endChar[count]] <= 0 do conflict = 1
			for v in 1..=count {
				if v != count && endChar[count] == endChar[v] do conflict = 1
			}
			if conflict == 0 do break
		}
		endFate[count] = bb.RndI(1, 70)
	}
	endChar[10] = gamChar[slot]
	endFate[10] = 0
	//frame ratings
	timer = bb.CreateTimer(30)
	bb.SeedRnd(bb.MilliSecs())
	//MAIN LOOP
	promoTim = 0
    page := 1
	go = 0
    gotim = -20
    keytim = 0
    for go == 0 {

        bb.Cls()
        frames := bb.WaitTimer(timer)
        for framer in 1..=frames {
            
            // counters
            keytim -= 1
            if keytim < 1 do keytim = 0
            
            // PORTAL 
            gotim += 1
            if gotim > 100 do promoTim += 1
            if gotim > 50 && keytim == 0 {
                if cast(bool)bb.KeyDown(1) || fadeAlpha >= 0.99 do go = 1
            }
            
            // MOVEMENT
            cyc := 1
            if gotim > 200 && pState[cyc] != 2 {
                bb.Animate(p[cyc], 1, 1.5, pSeq[cyc][2], 10)
                pState[cyc] = 2
            }
            if pState[cyc] == 2 {
                pZ[cyc] += 0.3
                pStepTim[cyc] += 1
            }
            if pZ[cyc] > 225 do fadeTarget = 1.0
            bb.PositionEntity(p[cyc], pX[cyc], pY[cyc], pZ[cyc])
            // shadows
            for limb in 1..=40 {
                if pShadow[cyc][limb] > 0 {
                    bb.RotateEntity(pShadow[cyc][limb], 90, bb.EntityYaw(pLimb[cyc][limb], 1), 0)
                    bb.PositionEntity(pShadow[cyc][limb], bb.EntityX(pLimb[cyc][limb], 1), pY[cyc] + 0.4, bb.EntityZ(pLimb[cyc][limb], 1))
                }
            }
            // footsteps
            if f32(pStepTim[cyc]) > 20.0/1.5 {
                ProduceSound(0, sStep[bb.RndI(3, 4)], 22050, 0) 
                pStepTim[cyc] = 0
            }  
            
            // CAMERA
            // camera tracking 
            if gotim > 0 {
                camTX = 450
                camTY = 30
                camTZ = 100
                GetSmoothSpeeds(camX, camTX, camY, camTY, camZ, camTZ, 240)
                if camX < camTX do camX += speedX
                if camX > camTX do camX -= speedX
                if camY < camTY do camY += (speedY / 2.0)
                if camY > camTY do camY -= (speedY / 2.0)
                if camZ < camTZ do camZ += speedZ
                if camZ > camTZ do camZ -= speedZ
            } 
            bb.PositionEntity(cam, camX, camY, camZ)
            bb.PositionEntity(camPivot, pX[cyc], pY[cyc] + 25, pZ[cyc])
            bb.PointEntity(cam, camPivot)
            // fader
            if fadeAlpha < fadeTarget do fadeAlpha += 0.001
            if fadeAlpha > fadeTarget do fadeAlpha -= 0.001
            if fadeAlpha < 0 do fadeAlpha = 0
            if fadeAlpha > 1.0 do fadeAlpha = 1.0
            bb.PositionEntity(dummy, camX, camY, camZ)
            bb.RotateEntity(dummy, bb.EntityPitch(cam), bb.EntityYaw(cam), bb.EntityRoll(cam))
            bb.MoveEntity(dummy, 0, 0, 3)
            bb.PositionEntity(fader, bb.EntityX(dummy), bb.EntityY(dummy), bb.EntityZ(dummy))
            bb.EntityAlpha(fader, fadeAlpha)  
            
            bb.UpdateWorld()
        }
        bb.RenderWorld(1)

        // DISPLAY
        // introduce widescreen
        if promoTim > 0 {
            y: f32
            if promoTim <= 100 {
                y = f32(PercentOf(60, f32(promoTim)))
            } else {
                y = 60
            }
            bb.Color(0, 0, 0)
            bb.Rect(i32(rX(0)), i32(rY(0)), i32(rX(800)), i32(rY(y)), 1)
            
            if promoTim <= 100 {
                y = 600 - f32(PercentOf(120, f32(promoTim)))
            } else {
                y = 480
            }
            bb.Color(0, 0, 0)
            bb.Rect(i32(rX(0)), i32(rY(y)), i32(rX(800)), i32(rY(600)), 1)
        }
        // display allumni
        if promoTim >= 125 && promoTim <= 275 && page >= 1 && page <= 10 {
            x: i32 = 82
            y: i32 = 539
            if charSnapped[endChar[page]] > 0 && charPhoto[endChar[page]] > 0 {
                bb.DrawImage(charPhoto[endChar[page]], i32(rX(f32(x))), i32(rY(f32(y))))
            } else {
                bb.DrawImage(gPhoto, i32(rX(f32(x))), i32(rY(f32(y))))
            }
            bb.Color(50, 50, 50)
            bb.Rect(i32(rX(f32(x))) - 75, i32(rY(f32(y))) - 50, 150, 100, 0)
            
            scriptA, scriptB: string
            // scriptA = "Steve Austin never left the prison system.180"
            if endFate[page] == 0 {
                scriptA = fmt.tprint(charName[endChar[page]], "was never heard from again, but")
                scriptB = "tales of his life are still told to this day..."
            }
            if endFate[page] == 1 {
                scriptA = fmt.tprint(charName[endChar[page]], "was brutally murdered by")
                scriptB = "another inmate and never saw his release..."
            }
            if endFate[page] == 2 {
                scriptA = fmt.tprint("Prison became too much for", charName[endChar[page]], ".")
                scriptB = "He hung himself from the bars of his cell..."
            }
            if endFate[page] == 3 {
                scriptA = fmt.tprint("Prison became too much for", charName[endChar[page]], ".")
                scriptB = "He slit his wrists in the bathroom..."
            }
            if endFate[page] == 4 {
                scriptA = fmt.tprint(charName[endChar[page]], "never left the prison system.")
                scriptB = "He remained behind bars until the day he died..."
            }
            if endFate[page] == 5 {
                scriptA = fmt.tprint(charName[endChar[page]], "kept disobeying the wardens")
                scriptB = "and was never considered for release..."
            }
            if endFate[page] == 6 {
                scriptA = fmt.tprint(charName[endChar[page]], "became embroiled in gang")
                scriptB = "culture and never left a life of crime..."
            }
            if endFate[page] == 7 {
                scriptA = fmt.tprint(charName[endChar[page]], "was released and went on")
                scriptB = "to marry his long-time girlfriend..."
            }
            if endFate[page] == 8 {
                scriptA = fmt.tprint(charName[endChar[page]], "was released and went on")
                scriptB = "to raise a family with his wife..."
            }
            if endFate[page] == 9 {
                scriptA = fmt.tprint(charName[endChar[page]], "returned to his wife and")
                scriptB = "children but never regained their trust..."
            }
            if endFate[page] == 10 {
                scriptA = fmt.tprint(charName[endChar[page]], "returned to his wife and")
                scriptB = "kids and became a committed family man..."
            }
            if endFate[page] == 11 {
                scriptA = fmt.tprint(charName[endChar[page]], "got used to being surrounded")
                scriptB = "by men and became a rampant homosexual..."
            }
            if endFate[page] == 12 {
                scriptA = fmt.tprint(charName[endChar[page]], "was left by his wife, but")
                scriptB = "went on to find love with another..."
            }
            if endFate[page] == 13 {
                scriptA = fmt.tprint(charName[endChar[page]], "was moved to a mental hospital")
                scriptB = "after being driven mad by prison life..."
            }
            if endFate[page] == 14 {
                scriptA = fmt.tprint(charName[endChar[page]], "became a sexual predator and")
                scriptB = "was soon back behind bars for rape..."
            }
            if endFate[page] == 15 {
                scriptA = fmt.tprint(charName[endChar[page]], "went on a killing spree upon")
                scriptB = "returning to find his wife having an affair..."
            }
            if endFate[page] == 16 {
                scriptA = fmt.tprint(charName[endChar[page]], "was accused of sexually abusing")
                scriptB = "his daughter and swiftly returned to prison..."
            }
            if endFate[page] == 17 {
                scriptA = fmt.tprint(charName[endChar[page]], "was killed by a speeding car")
                scriptB = "upon setting foot outside the prison gates..."
            }
            if endFate[page] == 18 {
                scriptA = fmt.tprint(charName[endChar[page]], "became involved in organized")
                scriptB = "crime and died during a drive-by shooting..."
            }
            if endFate[page] == 19 {
                scriptA = fmt.tprint(charName[endChar[page]], "developed a drug problem")
                scriptB = "and never made anything of his life..."
            }
            if endFate[page] == 20 {
                scriptA = fmt.tprint(charName[endChar[page]], "developed a drug problem")
                scriptB = "and eventually died of an overdose..."
            }

            
        }
    }



	mem.end_arena_temp_memory(checkpoint)
}