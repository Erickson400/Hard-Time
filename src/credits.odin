package main

import bb "blitzbasic3d"
import "core:fmt"
import "core:mem"

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
		for _ in 1..=frames {
			
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
	// gamma: f32 = 0 // Unused
	go = 0
	gotim = 0
	keytim = 20
	for go == 0 {

		bb.Cls()
		frames := bb.WaitTimer(timer)
		for _ in 1..=frames {
			
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
		for _ in 1 ..= frames {
			
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
	p[cyc] = bb.LoadAnimMesh(fmt.tprint("Characters/Models/Model", Dig(charModel[pChar[cyc]], 10), ".3ds"))
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
		for _ in 1..=frames {
			
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
			if endFate[page] == 21 {
				scriptA = fmt.tprint(charName[endChar[page]], "continued to study and went on")
				scriptB = "to become a productive member of society..."
			}
			if endFate[page] == 22 {
				scriptA = fmt.tprint(charName[endChar[page]], "went on to hold down a decent")
				scriptB = "job and never committed another crime..."
			}
			if endFate[page] == 23 {
				scriptA = fmt.tprint(charName[endChar[page]], "managed to find work, but was")
				scriptB = "soon arrested for killing his boss..."
			}
			if endFate[page] == 24 {
				scriptA = fmt.tprint(charName[endChar[page]], "was transferred to a more")
				scriptB = "conservative jail and was soon executed..."
			}
			if endFate[page] == 25 {
				scriptA = fmt.tprint(charName[endChar[page]], "went on to write a best-selling")
				scriptB = "book about his experiences in prison..."
			}
			if endFate[page] == 26 {
				scriptA = fmt.tprint(charName[endChar[page]], "became a public speaker and")
				scriptB = "encouraged kids to avoid a life of crime..."
			}
			if endFate[page] == 27 {
				scriptA = fmt.tprint(charName[endChar[page]], "became a teacher, but was")
				scriptB = "later arrested for abusing his students..."
			}
			if endFate[page] == 28 {
				scriptA = fmt.tprint(charName[endChar[page]], "was recruited by a terrorist")
				scriptB = "cell and took part in a fatal bombing..."
			}
			if endFate[page] == 29 {
				scriptA = fmt.tprint(charName[endChar[page]], "was transferred to Guantanamo")
				scriptB = "Bay after getting involved in terrorism..."
			}
			if endFate[page] == 30 {
				scriptA = fmt.tprint(charName[endChar[page]], "went on to make a movie about")
				scriptB = "his experiences and became a millionaire..."
			}
			if endFate[page] == 31 {
				scriptA = fmt.tprint(charName[endChar[page]], "took part in a documentary")
				scriptB = "about the prison and became a TV star..."
			}
			if endFate[page] == 32 {
				scriptA = fmt.tprint(charName[endChar[page]], "got to grips with computers")
				scriptB = "and went on to become a game designer..."
			}
			if endFate[page] == 33 {
				scriptA = fmt.tprint(charName[endChar[page]], "got to grips with computers")
				scriptB = "and went on to create a popular website..."
			}
			if endFate[page] == 34 {
				scriptA = fmt.tprint(charName[endChar[page]], "got to grips with computers")
				scriptB = "and went on to find a cushy job in IT..."
			}
			if endFate[page] == 35 {
				scriptA = fmt.tprint(charName[endChar[page]], "was given his own radio show")
				scriptB = "and used it to share his experiences..."
			}
			if endFate[page] == 36 {
				scriptA = fmt.tprint(charName[endChar[page]], "used his experience to serve")
				scriptB = "as a warden after completing his sentence..."
			}
			if endFate[page] == 37 {
				scriptA = fmt.tprint(charName[endChar[page]], "succumbed to a terminal illness")
				scriptB = "that he was hiding from his fellow inmates..."
			}
			if endFate[page] == 38 {
				scriptA = fmt.tprint(charName[endChar[page]], "continued a life of discipline")
				scriptB = "and became a decorated soldier in the army..."
			}
			if endFate[page] == 39 {
				scriptA = fmt.tprint(charName[endChar[page]], "continued a life of discipline")
				scriptB = "in the army, but was killed in battle..."
			}
			if endFate[page] == 40 {
				scriptA = fmt.tprint(charName[endChar[page]], "went on to study medicine")
				scriptB = "and saved countless lives as a doctor..."
			}
			if endFate[page] == 41 {
				scriptA = fmt.tprint(charName[endChar[page]], "went on to lead an uneventful")
				scriptB = "life and died in the comfort of his home..."
			}
			if endFate[page] == 42 {
				scriptA = fmt.tprint(charName[endChar[page]], "trained as a chef and vowed")
				scriptB = "to improve the standard of prison food..."
			}
			if endFate[page] == 43 {
				scriptA = fmt.tprint(charName[endChar[page]], "continued to stay in shape")
				scriptB = "and went on to become a personal trainer..."
			}
			if endFate[page] == 44 {
				scriptA = fmt.tprint(charName[endChar[page]], "lost faith in human beings")
				scriptB = "and dedicated his life to animal welfare..."
			}
			if endFate[page] == 45 {
				scriptA = fmt.tprint(charName[endChar[page]], "went on to work with animals,")
				scriptB = "but was mauled by an ungrateful lion..."
			}
			if endFate[page] == 46 {
				scriptA = fmt.tprint(charName[endChar[page]], "'s vision continued to")
				scriptB = "deteriorate in prison and left him blind..."
			}
			if endFate[page] == 47 {
				scriptA = fmt.tprint(charName[endChar[page]], "became wheelchair bound after")
				scriptB = "breaking his back in a car accident..."
			}
			if endFate[page] == 48 {
				scriptA = fmt.tprint(charName[endChar[page]], "broke his neck in an accident")
				scriptB = "and never regained the use of his body..."
			}
			if endFate[page] == 49 {
				scriptA = fmt.tprint(charName[endChar[page]], "slipped into a coma after an")
				scriptB = "accident and never regained consciousness..."
			}
			if endFate[page] == 50 {
				scriptA = fmt.tprint(charName[endChar[page]], "tried to climb Mount Everest")
				scriptB = "with no equipment and fell to his death..."
			}
			if endFate[page] == 51 {
				scriptA = fmt.tprint(charName[endChar[page]], "embarked on an expedition to")
				scriptB = "the North Pole, but died on the first day..."
			}
			if endFate[page] == 52 {
				scriptA = fmt.tprint(charName[endChar[page]], "became a movie stuntman, but")
				scriptB = "tragically died during a failed stunt..."
			}
			if endFate[page] == 53 {
				scriptA = fmt.tprint(charName[endChar[page]], "started acting in porn films")
				scriptB = "and contracted every STD known to man..."
			}
			if endFate[page] == 54 {
				scriptA = fmt.tprint(charName[endChar[page]], "claimed to be the Messiah and")
				scriptB = "tried to bring peace to The Middle East..."
			}
			if endFate[page] == 55 {
				scriptA = fmt.tprint(charName[endChar[page]], "had an epiphany and embarked")
				scriptB = "on missionary work in the third world..."
			}
			if endFate[page] == 56 {
				scriptA = fmt.tprint(charName[endChar[page]], "became a millionaire and used")
				scriptB = "his wealth to adopt impoverished children..."
			}
			if endFate[page] == 57 {
				scriptA = fmt.tprint(charName[endChar[page]], "moved to another country where")
				scriptB = "nobody knew of his criminal background..."
			}
			if endFate[page] == 58 {
				scriptA = fmt.tprint("Upon release,", charName[endChar[page]], "forgot where he")
				scriptB = "lived and was left roaming the streets..."
			}
			if endFate[page] == 59 {
				scriptA = fmt.tprint(charName[endChar[page]], "failed to adjust to modern")
				scriptB = "life and became one of the homeless..."
			}
			if endFate[page] == 60 {
				scriptA = fmt.tprint(charName[endChar[page]], "failed to adjust to life on")
				scriptB = "the outside and soon committed suicide..."
			}
			if endFate[page] == 61 {
				scriptA = fmt.tprint("After being released,", charName[endChar[page]], "was")
				scriptB = "hunted down and killed by old enemies..."
			}
			if endFate[page] == 62 {
				scriptA = fmt.tprint(charName[endChar[page]], "went on to become a political")
				scriptB = "activist and lobbied to improve prisons..."
			}
			if endFate[page] == 63 {
				scriptA = fmt.tprint(charName[endChar[page]], "developed an affinity with")
				scriptB = "nature and ran away to live in the wild..."
			}
			if endFate[page] == 64 {
				scriptA = fmt.tprint(charName[endChar[page]], "successfully escaped from")
				scriptB = "prison and still hasn't been found..."
			}
			if endFate[page] == 65 {
				scriptA = fmt.tprint(charName[endChar[page]], "tried to escape from the")
				scriptB = "exercise yard, but was shot dead..."
			}
			if endFate[page] == 66 {
				scriptA = fmt.tprint(charName[endChar[page]], "returned to the wrong house")
				scriptB = "and brought up someone else's family..."
			}
			if endFate[page] == 67 {
				scriptA = fmt.tprint(charName[endChar[page]], "went back to live with his")
				scriptB = "parents and remains grounded to this day..."
			}
			if endFate[page] == 68 {
				scriptA = fmt.tprint(charName[endChar[page]], "went back to school, but")
				scriptB = "failed to complete the 1st grade..."
			}
			if endFate[page] == 69 {
				scriptA = fmt.tprint(charName[endChar[page]], "dedicated his life to sport")
				scriptB = "and played in a Superbowl final..."
			}
			if endFate[page] == 70 {
				scriptA = fmt.tprint(charName[endChar[page]], "united all the prison")
				scriptB = "gangs and now rules like a king..."
			}
			bb.SetFont(font[4])
			if bb.GraphicsWidth() < 800 do bb.SetFont(font[3])
			if bb.GraphicsWidth() > 800 do bb.SetFont(font[5])
			if bb.GraphicsWidth() > 1024 do bb.SetFont(font[6])
			OutlineStraight(scriptA, i32(rX(f32(x))) + 90, i32(rY(520)), 30, 30, 30, 250, 250, 250)
			OutlineStraight(scriptB, i32(rX(f32(x))) + 90, i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 300 {
			page += 1
			promoTim = 125
		}
		// mask shaky start
		if gotim <= 0 do Loader("Please Wait", "Leaving Prison")

		bb.Flip()
		// screenshot (F12)
		if cast(bool)bb.KeyHit(88) do Screenshot()

	}
	// restore sound
	if bb.ChannelPlaying(chAtmos) > 0 do bb.StopChannel(chAtmos)
	// free entities
	bb.FreeTimer(timer)
	bb.FreeEntity(fader)
	bb.FreeEntity(world)
	bb.FreeEntity(cam)
	bb.FreeEntity(camPivot)
	bb.FreeEntity(dummy)
	for cyc2 in 1..=no_lights {
		bb.FreeEntity(light[cyc2])
	}
	bb.FreeEntity(p[1])
	for limb in 1..=40 {
		if pShadow[1][limb] > 0 {
			bb.FreeEntity(pShadow[1][limb])
		}
	}
	// leave
	if gamEnded == 1 {
		gamName[slot] = ""
		screen = 6
	} else {
		screen = 5
	}
	mem.end_arena_temp_memory(checkpoint)
}