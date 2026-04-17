package main

import bb "blitzbasic3d"
import "core:fmt"
import "core:mem"
import "core:strings"

////////////////////////////////////////////////////////////////////////////////
//------------------------------ HARD TIME: SCENES -----------------------------
////////////////////////////////////////////////////////////////////////////////

//---------------------------------------------------------------
/////////////////////// 52. COURT CASE //////////////////////////
//---------------------------------------------------------------
CourtCase :: proc() {
	checkpoint := mem.begin_arena_temp_memory(cast(^mem.Arena)context.temp_allocator.data)
	sentence: string
	//load setting
	Loader("Please Wait", "Preparing Court Case")
	world = bb.LoadAnimMesh("World/Courtroom/Courtroom.3ds")
	for count in i32(1) ..= 10 {
		digit := Dig(count, 10, context.temp_allocator)
		bb.EntityTexture(bb.FindChild(world, fmt.tprint("Crowd", digit)), tCrowd, 0, bb.RndI(0, 3))
	}
	sAtmos = bb.LoadSound("Sound/Ambience/Crowd.wav")
	//camera
	cam = bb.CreateCamera()
	bb.CameraViewport(cam, 0, 0, bb.GraphicsWidth(), bb.GraphicsHeight())
	camX, camY, camZ = 50, 30, -80
	bb.PositionEntity(cam, camX, camY, camZ)
	camType, camFoc = 10, 5
	//pivots
	camPivot = bb.CreatePivot()
	camPivX, camPivY, camPivZ = 7, 19, 127
	bb.PositionEntity(camPivot, camPivX, camPivY, camPivZ)
	dummy = bb.CreatePivot()
	//lighting
	bb.AmbientLight(200, 200, 200)
	LoadLighting()
	//background noise
	bb.LoopSound(sAtmos)
	chAtmos = bb.PlaySound(sAtmos)
	bb.ChannelVolume(chAtmos, 0.1)
	//LOAD CHARACTERS
	//calculate cast
	no_plays = 5
	for cyc in 1 ..=no_plays do pChar[cyc] = 0
	pChar[1] = gamChar[slot] //player
	pChar[2] = promoAccuser //accuser
	pChar[3] = 1 //player's lawyer
	pChar[4] = 2 //accuser's lawyer
	pChar[5] = 3 //judge
	GenerateCharacter(2, 2)
	GenerateCharacter(3, 3)
	//set locations
	pX[1], pY[1], pZ[1], pA[1] = -45, 2, 10, -15
	pX[2], pY[2], pZ[2], pA[2] = 55, 2, 10, 15
	pX[3], pY[3], pZ[3], pA[3] = -65, 2, 7, -40
	pX[4], pY[4], pZ[4], pA[4] = 75, 2, 7, 40
	pX[5], pY[5], pZ[5], pA[5] = 7, 19, 127, 180
	//load models
	for cyc in 1 ..=no_plays {
		digit := Dig(charModel[pChar[cyc]], 10, context.temp_allocator)
		p[cyc] = bb.LoadAnimMesh(fmt.tprint("Characters/Models/Model", digit, ".3ds"))
		pSeq[cyc][601] = bb.LoadAnimSeq(p[cyc], "Characters/Sequences/Standard01.3ds")
		pSeq[cyc][602] = bb.LoadAnimSeq(p[cyc], "Characters/Sequences/Standard02.3ds")
		pSeq[cyc][603] = bb.LoadAnimSeq(p[cyc], "Characters/Sequences/Standard03.3ds")
		pSeq[cyc][604] = bb.LoadAnimSeq(p[cyc], "Characters/Sequences/Standard04.3ds")
		if cyc <= 2 && (charInjured[pChar[cyc]] > 0 || charHealth[pChar[cyc]] < 10) {
			pSeq[cyc][1] = bb.ExtractAnimSeq(p[cyc], 925, 965, pSeq[cyc][602]) //weary
		} else {
			randy := bb.RndI(1, 3)
			if randy == 1 do pSeq[cyc][1] = bb.ExtractAnimSeq(p[cyc], 0, 40, pSeq[cyc][601]) //standing
			if randy == 2 do pSeq[cyc][1] = bb.ExtractAnimSeq(p[cyc], 770, 850, pSeq[cyc][604]) //hands on hips
			if randy == 3 do pSeq[cyc][1] = bb.ExtractAnimSeq(p[cyc], 860, 940, pSeq[cyc][604]) //folded arms
		}
		randy := bb.RndI(1, 3)
		if randy == 1 do pSeq[cyc][2] = bb.ExtractAnimSeq(p[cyc], 755, 835, pSeq[cyc][603]) //speaking
		if randy == 2 do pSeq[cyc][2] = bb.ExtractAnimSeq(p[cyc], 770, 850, pSeq[cyc][604]) //hands on hips
		if randy == 3 do pSeq[cyc][2] = bb.ExtractAnimSeq(p[cyc], 860, 940, pSeq[cyc][604]) //folded arms
		pSeq[cyc][3] = bb.ExtractAnimSeq(p[cyc], 1215, 1255, pSeq[cyc][603]) //sitting
		ApplyCostume(cyc)
		pEyes[cyc], pOldEyes[cyc] = 2, -1
		for limb in 1 ..=40 {
			pScar[cyc][limb] = charScar[pChar[cyc]][limb]
			if pLimb[cyc][limb] > 0 && pScar[cyc][limb] >= 5 {
				bb.HideEntity(pLimb[cyc][limb])
			}
		}
		SeverLimbs(cyc)
		for v in 1 ..=weapList {
			bb.HideEntity(bb.FindChild(p[cyc], weapFile[v]))
		}
		bb.HideEntity(bb.FindChild(p[cyc], "Barbell"))
		bb.HideEntity(bb.FindChild(p[cyc], "Phone"))
		bb.PositionEntity(p[cyc], pX[cyc], pY[cyc], pZ[cyc])
		bb.RotateEntity(p[cyc], 0, pA[cyc], 0)
		scaler := f32(charHeight[pChar[cyc]]) * 0.0025
		if cyc == 5 do scaler = 12 * 0.0025
		bb.ScaleEntity(p[cyc], 0.34 + scaler, 0.34 + scaler, 0.34 + scaler)
		if cyc <= 4 do bb.Animate(p[cyc], 1, bb.RndF(0.1, 0.3), pSeq[cyc][1], 0)
		if cyc == 5 do bb.Animate(p[cyc], 1, bb.RndF(0.1, 0.3), pSeq[cyc][3], 0)
		pState[cyc], pFoc[cyc] = 1, 0
	}
	//point light
	bb.PointEntity(light[1], p[5])
	//RESET SITUATION
	promoTim, promoStage = -100, 0
	promoEffect, promoVerdict = 0, 0
	for count in 1 ..=10 do promoReact[count] = 0
	if gamWarrant[slot] == 0 {
		promoStage, promoVerdict = 2, 2
	}
	//calculate fines
	promoCash = gamMoney[slot] / 5
	if promoCash < 100 do promoCash = 100
	if promoCash > 10000 do promoCash = 10000
	promoCash = RoundOff(promoCash, 100)
	//frame ratings
	Loader("Please Wait", "Preparing Court Case")
	timer = bb.CreateTimer(30)
	bb.SeedRnd(bb.MilliSecs())
	//MAIN LOOP
	//foc := 1 // Unused
	oldfoc: i32 = 1
	go, gotim, keytim = 0, -20, 0
	for go == 0 {

		bb.Cls()
		frames := bb.WaitTimer(timer)
		for _ in 1 ..=frames {

			// counters
			keytim -= 1
			if keytim < 1 do keytim = 0

			// PORTAL
			gotim += 1
			// speed-up's
			if gotim > 15 do promoTim += 1
			if promoTim > 50 && keytim == 0 {
				if cast(bool)bb.KeyDown(1) || cast(bool)bb.KeyDown(28) || cast(bool)ButtonPressed() {
					promoTim += 100
					keytim = 10
				}
			}
			// leave
			if promoStage == 3 && promoTim > 10200 do go = 1

			// THEME FADING
			if gotim > 0 {
				musicVol -= 0.0025
				if musicVol <= 0 {
					if bb.ChannelPlaying(chTheme) > 0 do bb.StopChannel(chTheme)
					musicVol = 0
				}
				if bb.ChannelPlaying(chTheme) > 0 do bb.ChannelVolume(chTheme, musicVol)
			}

			// SPEAKING
			for cyc in 1 ..=no_plays {
				// change animation
				if cyc <= 4 {
					if pSpeaking[cyc] == 0 && pState[cyc] != 1 {
						bb.Animate(p[cyc], 1, bb.RndF(0.1, 0.3), pSeq[cyc][1], 10)
						pState[cyc] = 1
					}
					if cast(bool)pSpeaking[cyc] && pState[cyc] != 2 {
						bb.Animate(p[cyc], 1, bb.RndF(0.25, 0.5), pSeq[cyc][2], 10)
						pState[cyc] = 2
					}
				}
				// expressions
				FacialExpressions(cyc)
			}

			// CAMERA
			Camera()

			bb.UpdateWorld()

			// OVERRIDE ANIMATION
			if pFoc[5] > 0 do PointHead(5, pLimb[pFoc[5]][1])
			
		}
		bb.RenderWorld(1)

		// DISPLAY
		// reset expressions
		oldfoc = camFoc
		for cyc in 1 ..=no_plays {
			pSpeaking[cyc] = 0
		}
		// introduce widescreen
		if promoTim > 0 && promoTim < 10000 {
			y: f32 = 60
			if promoTim <= 25 do y = PercentOf(60, f32(promoTim * 4))
			if promoTim >= 9975 do y = PercentOf(60, f32((10000 - promoTim) * 4))
			bb.Color(0, 0, 0)
			bb.Rect(i32(rX(0)), i32(rY(0)), i32(rX(800)), i32(rY(y)), 1)
			y = 480
			if promoTim <= 25 do y = 600 - PercentOf(120, f32(promoTim * 4))
			if promoTim >= 9975 do y = 600 - PercentOf(120, f32((10000 - promoTim) * 4))
			bb.Color(0, 0, 0)
			bb.Rect(i32(rX(0)), i32(rY(y)), i32(rX(800)), i32(rY(600)), 1)
		}
		// determine font
		bb.SetFont(font[4])
		if bb.GraphicsWidth() < 800 do bb.SetFont(font[3])
		if bb.GraphicsWidth() > 800 do bb.SetFont(font[5])
		if bb.GraphicsWidth() > 1024 do bb.SetFont(font[6])
		// OPENING LINE
		if promoStage == 0 && promoTim > 25 && promoTim < 325 {
			Speak(5, 2)
			pFoc[5] = 2
			Outline("We're gathered to hear the case against Prisoner", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline(fmt.tprint(CellName(pChar[1], context.temp_allocator), ". So, ", charName[pChar[2]], ", what's the story?"), i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
			if promoTim > 125 && promoReact[1] == 0 {
				bb.PlaySound(sMurmur)
				promoReact[1] = 1
			}
		}
		// 0. INTRO
		if gamWarrant[slot] == 0 {
			if promoStage == 2 {
				if promoTim > 25 && promoTim < 325 {
					Speak(5, 3)
					pFoc[5] = 1
					pEyes[1] = 1
					pEyes[2] = 3
					pEyes[3] = 1
					pEyes[4] = 3
					Outline(fmt.tprint(charName[gamChar[slot]], ", this court has seen you accused"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
					Outline(fmt.tprint("of ", strings.to_lower(textCrime[charCrime[gamChar[slot]]], context.temp_allocator), " and heard your defence..."), i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
				}
				if promoTim > 350 && promoTim < 650 {
					Speak(5, 2)
					pFoc[5] = 0
					Outline("The trial has gone on quite long enough, so i'd", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
					Outline("like to take this moment to deliver my verdict...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
				}
				if promoTim > 700 && promoTim < 1000 {
					Speak(5, 1)
					pFoc[5] = 1
					if promoEffect == 0 {
						bb.PlaySound(sJury[bb.RndI(1, 2)])
						bb.PlaySound(sPaper)
						statTim[6] = -100
						promoEffect = 1
					}
					Outline("I find you GUILTY and sentence you to", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
					Outline(fmt.tprint(charSentence[gamChar[slot]], " days in Southtown Correctional Facility!"), i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
				}
				if promoTim > 1025 && promoTim < 1325 {
					Speak(5, 1)
					pFoc[5] = 1
					Outline("That may not be a 'long' time, but it will be", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
					Outline("HARD time! You'll be lucky if you survive...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
				}
				if promoTim > 1350 && promoTim < 1650 {
					Speak(5, 2)
					pFoc[5] = 2
					Outline("I'm now handing you over to the wardens, and", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
					Outline("they'll help you settle into your new home...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
				}
				if promoTim > 1675 {
					promoStage = 3
					promoTim = 9975
					camFoc = 1
				}
			}
		}
		// 1. DISSENT
		if gamWarrant[slot] == 1 {
			// statements
			if promoStage == 0 {
				if promoTim > 350 && promoTim < 650 {
					Speak(2, 1)
					Outline(fmt.tprint(CellName(pChar[1], context.temp_allocator), " seems to have a problem with authority!"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
					Outline("He disrupts the system by ignoring my orders...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
					if promoTim > 450 && promoReact[2] == 0 {
						bb.PlaySound(sJury[bb.RndI(1, 2)])
						promoReact[2] = 1
					}
				}
				if promoTim > 675 && promoTim < 975 {
					Speak(1, 1)
					Outline("I'm not out of control - he's a control freak!", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
					Outline("Nothing the prisoners do is ever enough for him...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
					if promoTim > 775 && promoReact[3] == 0 {
						bb.PlaySound(sJury[bb.RndI(1, 2)])
						promoReact[3] = 1
					}
				}
				if promoTim > 1000 {
					promoStage = 1
					promoTim = 300
				}
			}
			// positive verdict
			if promoStage == 2 && promoVerdict == 1 {
				if promoTim > 325 && promoTim < 625 {
					Speak(5, 1)
					pFoc[5] = 2
					Outline(fmt.tprint(charName[pChar[2]], ", i'm not here to do your job!"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
					Outline("You should be able to handle your own prisoners...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
				}
				if promoStage == 2 && promoTim > 650 && promoTim < 950 && promoVerdict == 1 {
					Speak(5, 1)
					pFoc[5] = 2
					Outline("I've got my own rules to uphold - i haven't got", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
					Outline("time for yours! Just try to be more tolerant...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
				}
				if promoTim > 950 {
					promoStage = 3
					promoTim = 9975
					camFoc = 1
				}
			}
			// negative verdict
			if promoStage == 2 && promoVerdict == 2 {
				if promoTim > 325 && promoTim < 625 {
					Speak(5, 1)
					pFoc[5] = 1
					Outline("When the wardens tell you to do something, you", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
					Outline("do it! You're in no position to disagree...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
				}
				if promoTim > 650 && promoTim < 950 {
					Speak(5, 1)
					pFoc[5] = 1
					if promoEffect == 0 {
						bb.PlaySound(sPaper)
						statTim[6] = -100
						charSentence[gamChar[slot]] += 1
						promoEffect = 1
					}
					Outline("I'm sentencing you to another day to make up for", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
					Outline("the one you've wasted! Take it as a warning...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
				}
				if promoTim > 950 {
					promoStage = 3
					promoTim = 9975
					camFoc = 1
				}
			}
		}
		// 2. GANG MEMBERSHIP
		if gamWarrant[slot] == 2 {
			// statements
			if promoStage == 0 {
				if promoTim > 350 && promoTim < 650 {
					Speak(2, 1)
					Outline(fmt.tprint(CellName(pChar[1], context.temp_allocator), " is a known member of '", textGang[charGang[gamChar[slot]]], "';"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
					Outline("a gang which conspires against the prison system!", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
					if promoTim > 450 && promoReact[2] == 0 {
						bb.PlaySound(sJury[bb.RndI(1, 2)])
						promoReact[2] = 1
					}
				}
				if promoTim > 675 && promoTim < 975 {
					Speak(1, 1)
					Outline("I've simply found my place in a community!", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
					Outline("Our only agenda is to support each other...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
					if promoTim > 775 && promoReact[3] == 0 {
						bb.PlaySound(sJury[bb.RndI(1, 2)])
						promoReact[3] = 1
					}
				}
				if promoTim > 1000 {
					promoStage = 1
					promoTim = 300
				}
			}
			// positive verdict
			if promoStage == 2 && promoVerdict == 1 {
				if promoTim > 325 && promoTim < 625 {
					Speak(5, 1)
					pFoc[5] = 2
					Outline(fmt.tprint("You've got quite an imagination, ", charName[pChar[2]], "!"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
					Outline("This supposed 'gang' shouldn't affect your job...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
				}
				if promoStage == 2 && promoTim > 650 && promoTim < 950 && promoVerdict == 1 {
					Speak(5, 2)
					pFoc[5] = 2
					Outline("On the contrary, relationships can offer stability.", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
					Outline("Perhaps you need to find some friends of your own!", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
				}
				if promoTim > 950 {
					promoStage = 3
					promoTim = 9975
					camFoc = 1
				}
			}
			// negative verdict
			if promoStage == 2 && promoVerdict == 2 {
				if promoTim > 325 && promoTim < 625 {
					Speak(5, 1)
					pFoc[5] = 1
					Outline("I know that gang culture offers sanctuary, but", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
					Outline("it comes at a deadly price and must be avoided!", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
				}
				if promoTim > 650 && promoTim < 950 {
					Speak(5, 1)
					pFoc[5] = 1
					if promoEffect == 0 {
						bb.PlaySound(sPaper)
						bb.PlaySound(sCash)
						statTim[7] = -100
						if gamMoney[slot] > 0 do gamMoney[slot] = 0
						ChangeGang(gamChar[slot], 0)
						promoEffect = 1
					}
					Outline("I have no choice but to seize your bank account", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
					Outline("and terminate your affiliation with the gang...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
				}
				if promoTim > 950 {
					promoStage = 3
					promoTim = 9975
					camFoc = 1
				}
			}
		}
		// 3. TRYING TO ESCAPE
		if gamWarrant[slot] == 3 {
			if promoStage == 0 {
				if promoTim > 350 && promoTim < 650 {
					Speak(2, 1)
					Outline(fmt.tprint(CellName(pChar[1], context.temp_allocator), " was caught out of his cell during"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
					Outline("lockdown! He was obviously trying to escape...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
					if promoTim > 450 && promoReact[2] == 0 {
						bb.PlaySound(sJury[bb.RndI(1, 2)])
						promoReact[2] = 1
					}
				}
				if promoTim > 675 && promoTim < 975 {
					Speak(1, 1)
					Outline("I wasn't trying to escape! I was making my way", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
					Outline("back to my cell when this guy grabbed me...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
					if promoTim > 775 && promoReact[3] == 0 {
						bb.PlaySound(sJury[bb.RndI(1, 2)])
						promoReact[3] = 1
					}
				}
				if promoTim > 1000 {
					promoStage = 1
					promoTim = 300
				}
			}
			// positive verdict
			if promoStage == 2 && promoVerdict == 1 {
				if promoTim > 325 && promoTim < 625 {
					Speak(5, 1)
					pFoc[5] = 2
					Outline(fmt.tprint("You've got quite an imagination, ", charName[pChar[2]], "!"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
					Outline("An inmate can't just 'stroll' out of the prison...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
				}
				if promoStage == 2 && promoTim > 650 && promoTim < 950 && promoVerdict == 1 {
					Speak(5, 2)
					pFoc[5] = 2
					Outline("I see no evidence of an escape attempt here.", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
					Outline("All you had to do was usher him to his cell...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
				}
				if promoTim > 950 {
					promoStage = 3
					promoTim = 9975
					camFoc = 1
				}
			}
			// negative verdict
			if promoStage == 2 && promoVerdict == 2 {
				if promoTim > 325 && promoTim < 625 {
					Speak(5, 1)
					pFoc[5] = 1
					Outline("You've got no reason to be outside of your block", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
					Outline("during lockdown! All it does is arouse suspicion...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
				}
				if promoTim > 650 && promoTim < 950 {
					Speak(5, 1)
					pFoc[5] = 1
					if promoEffect == 0 {
						bb.PlaySound(sPaper)
						statTim[6] = -100
						charSentence[gamChar[slot]] += 1
						bb.PlaySound(sCash)
						statTim[7] = -100
						if gamMoney[slot] > 0 do gamMoney[slot] = 0
						promoEffect = 1
					}
					Outline("I have no choice but to seize your bank account", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
					Outline("and add another day for the one you've wasted...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
				}
				if promoTim > 950 {
					promoStage = 3
					promoTim = 9975
					camFoc = 1
				}
			}
		}
		// 4. ILLEGAL ITEM
		if gamWarrant[slot] == 4 {
			if promoStage == 0 {
				if promoTim > 350 && promoTim < 650 {
					Speak(2, 1)
					if weapHabitat[weapType[gamItem[slot]]] == 0 {
						Outline(fmt.tprint(CellName(pChar[1], context.temp_allocator), " was seen wielding a ", strings.to_lower(weapName[weapType[gamItem[slot]]], context.temp_allocator), "!"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
						Outline("A prisoner has no right to such weapons...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
					}
					if weapHabitat[weapType[gamItem[slot]]] > 0 {
						Outline(fmt.tprint(CellName(pChar[1], context.temp_allocator), " was caught carrying a ", strings.to_lower(weapName[weapType[gamItem[slot]]], context.temp_allocator), " where"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
						Outline("it didn't belong! God knows what he had planned...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
					}
					if promoTim > 450 && promoReact[2] == 0 {
						bb.PlaySound(sJury[bb.RndI(1, 2)])
						promoReact[2] = 1
					}
				}
				if promoTim > 675 && promoTim < 975 {
					Speak(1, 1)
					Outline(fmt.tprint("I found that ", strings.to_lower(weapName[weapType[gamItem[slot]]], context.temp_allocator), ", and was on my way to"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
					Outline("report it to the wardens when they grabbed me!", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
					if promoTim > 775 && promoReact[3] == 0 {
						bb.PlaySound(sJury[bb.RndI(1, 2)])
						promoReact[3] = 1
					}
				}
				if promoTim > 1000 {
					promoStage = 1
					promoTim = 300
				}
			}
			// positive verdict
			if promoStage == 2 && promoVerdict == 1 {
				if promoTim > 325 && promoTim < 625 {
					Speak(5, 1)
					pFoc[5] = 2
					Outline(fmt.tprint(charName[pChar[2]], ", there's no evidence to suggest"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
					Outline(fmt.tprint("that this ", strings.to_lower(weapName[weapType[gamItem[slot]]], context.temp_allocator), " was used for any crime!"), i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
				}
				if promoStage == 2 && promoTim > 650 && promoTim < 950 && promoVerdict == 1 {
					Speak(5, 1)
					pFoc[5] = 2
					Outline("I can't punish this man over your suspicions!", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
					Outline("Simply confiscate the item and leave it at that...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
				}
				if promoTim > 950 {
					promoStage = 3
					promoTim = 9975
					camFoc = 1
				}
			}
			// negative verdict
			if promoStage == 2 && promoVerdict == 2 {
				if promoTim > 325 && promoTim < 625 {
					Speak(5, 1)
					pFoc[5] = 1
					Outline("A prisoner has no business carrying a", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
					Outline(fmt.tprint(strings.to_lower(weapName[weapType[gamItem[slot]]], context.temp_allocator), "! It just looks suspicious..."), i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
				}
				if promoTim > 650 && promoTim < 950 {
					Speak(5, 1)
					pFoc[5] = 1
					if promoEffect == 0 {
						bb.PlaySound(sPaper)
						statTim[6] = -100
						randy := bb.RndI(1, 5)
						charSentence[gamChar[slot]] += randy
						if randy == 1 {
							sentence = strings.clone("a day", context.temp_allocator)
						} else {
							sentence = fmt.tprint(randy, " days")
						}
						promoEffect = 1
					}
					Outline("I'd like to nip this in the bud by adding", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
					Outline(fmt.tprint(sentence, " to your sentence. Take it as a warning!"), i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
				}
				if promoTim > 950 {
					promoStage = 3
					promoTim = 9975
					camFoc = 1
				}
			}
		}
		// 5. DRUG ABUSE
		if gamWarrant[slot] == 5 {
			if promoStage == 0 {
				if promoTim > 350 && promoTim < 650 {
					Speak(2, 1)
					Outline("This junkie has descended into a life of drug abuse!", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
					Outline("He cares more about his fix than rehabilitation...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
					if promoTim > 450 && promoReact[2] == 0 {
						bb.PlaySound(sJury[bb.RndI(1, 2)])
						promoReact[2] = 1
					}
				}
				if promoTim > 675 && promoTim < 975 {
					Speak(1, 1)
					Outline("I wasn't doing anything wrong! I was simply making", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
					Outline("use of the medication that the prison provides...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
					if promoTim > 775 && promoReact[3] == 0 {
						bb.PlaySound(sJury[bb.RndI(1, 2)])
						promoReact[3] = 1
					}
				}
				if promoTim > 1000 {
					promoStage = 1
					promoTim = 300
				}
			}
			// positive verdict
			if promoStage == 2 && promoVerdict == 1 {
				if promoTim > 325 && promoTim < 625 {
					Speak(5, 1)
					pFoc[5] = 2
					Outline(fmt.tprint("You've got quite an imagination, ", charName[pChar[2]], "!"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
					Outline("There's a difference between 'using' and 'abusing'...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
				}
				if promoStage == 2 && promoTim > 650 && promoTim < 950 && promoVerdict == 1 {
					Speak(5, 2)
					pFoc[5] = 2
					Outline("I can't blame this man for taking the edge off", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
					Outline("prison life! Just try to be more compassionate...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
				}
				if promoTim > 950 {
					promoStage = 3
					promoTim = 9975
					camFoc = 1
				}
			}
			// negative verdict
			if promoStage == 2 && promoVerdict == 2 {
				if promoTim > 325 && promoTim < 625 {
					Speak(5, 1)
					pFoc[5] = 1
					Outline("That medication is there to be used - not abused!", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
					Outline("You've done nothing to help your rehabilitation...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
				}
				if promoTim > 650 && promoTim < 950 {
					Speak(5, 1)
					pFoc[5] = 1
					if promoEffect == 0 {
						bb.PlaySound(sPaper)
						statTim[6] = -100
						randy := bb.RndI(1, 5)
						charSentence[gamChar[slot]] += randy
						if randy == 1 {
							sentence = strings.clone("a day", context.temp_allocator)
						} else {
							sentence = fmt.tprint(randy, " days")
						}
						bb.PlaySound(sCash)
						statTim[7] = -100
						gamMoney[slot] -= promoCash
						if charCrime[gamChar[slot]] < 3 do charCrime[gamChar[slot]] = 3
						promoEffect = 1
					}
					Outline(fmt.tprint("I'm fining you $", GetFigure(promoCash, context.temp_allocator), ", and adding ", sentence, " to"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
					Outline("make up for the ones you've spent in a stupor!", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
				}
				if promoTim > 950 {
					promoStage = 3
					promoTim = 9975
					camFoc = 1
				}
			}
		}
		// 6. TRADING ITEMS
		if gamWarrant[slot] == 6 {
			// statements
			if promoStage == 0 {
				if promoTim > 350 && promoTim < 650 {
					Speak(2, 1)
					lower := strings.to_lower(weapName[weapType[gamItem[slot]]], context.temp_allocator)
					Outline(fmt.tprint(CellName(pChar[1], context.temp_allocator), "was caught trading", lower, "s!"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
					Outline("He's turning prison life into a business...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
					if promoTim > 450 && promoReact[2] == 0 {
						bb.PlaySound(sJury[bb.RndI(1, 2)])
						promoReact[2] = 1
					}
				}
				if promoTim > 675 && promoTim < 975 {
					Speak(1, 1)
					lower := strings.to_lower(weapName[weapType[gamItem[slot]]], context.temp_allocator)
					Outline(fmt.tprint("I wasn't 'trading' that", lower, "! It was a"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
					Outline("simple exchange of resources between friends...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
					if promoTim > 775 && promoReact[3] == 0 {
						bb.PlaySound(sJury[bb.RndI(1, 2)])
						promoReact[3] = 1
					}
				}
				if promoTim > 1000 {
					promoStage = 1
					promoTim = 300
				}
			}
			// positive verdict
			if promoStage == 2 && promoVerdict == 1 {
				if promoTim > 325 && promoTim < 625 {
					Speak(5, 1)
					pFoc[5] = 2
					Outline(fmt.tprint("You've got quite an imagination,", fmt.tprint(charName[pChar[2]], "!")), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
					Outline("This man isn't trying to run a business empire...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
				}
				if promoStage == 2 && promoTim > 650 && promoTim < 950 && promoVerdict == 1 {
					Speak(5, 2)
					pFoc[5] = 2
					Outline("These men have already lost their freedom, and", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
					Outline("no amount of possessions can't change that fact...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
				}
				if promoTim > 950 {
					promoStage = 3
					promoTim = 9975
					camFoc = 1
				}
			}
			// negative verdict
			if promoStage == 2 && promoVerdict == 2 {
				if promoTim > 325 && promoTim < 625 {
					Speak(5, 1)
					pFoc[5] = 1
					Outline("You're not supposed to 'profit' from the prison", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
					Outline("experience - you're supposed to be punished by it!", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
				}
				if promoTim > 650 && promoTim < 950 {
					Speak(5, 1)
					pFoc[5] = 1
					if promoEffect == 0 {
						bb.PlaySound(sPaper)
						statTim[6] = -100
						randy := bb.RndI(1, 5)
						charSentence[gamChar[slot]] += randy
						if randy == 1 {
							sentence = strings.clone("1 day", context.temp_allocator)
						} else {
							sentence = fmt.tprint(randy, "days")
						}
						bb.PlaySound(sCash)
						statTim[7] = -100
						if gamMoney[slot] > 0 {
							gamMoney[slot] = 0
						}
						if charCrime[gamChar[slot]] < 4 {
							charCrime[gamChar[slot]] = 4
						}
						promoEffect = 1
					}
					Outline(fmt.tprint("I sentence you to an extra", sentence, "to think about that,"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
					Outline("and i must also seize the fortune that you've amassed...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
				}
				if promoTim > 950 {
					promoStage = 3
					promoTim = 9975
					camFoc = 1
				}
			}
		}
		// 7. STEALING
		if gamWarrant[slot] == 7 {
			// statements
			if promoStage == 0 {
				if promoTim > 350 && promoTim < 650 {
					Speak(2, 1)
					lower := strings.to_lower(weapName[weapType[gamItem[slot]]], context.temp_allocator)
					Outline(fmt.tprint(CellName(pChar[1], context.temp_allocator), "was caught stealing a", lower, "!"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
					Outline("The thief can't keep his hands to himself...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
					if promoTim > 450 && promoReact[2] == 0 {
						bb.PlaySound(sJury[bb.RndI(1, 2)])
						promoReact[2] = 1
					}
				}
				if promoTim > 675 && promoTim < 975 {
					Speak(1, 1)
					lower := strings.to_lower(weapName[weapType[gamItem[slot]]], context.temp_allocator)
					Outline(fmt.tprint("I didn't 'steal' that", lower, "! I was just"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
					Outline("trying to take back what was mine...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
					if promoTim > 775 && promoReact[3] == 0 {
						bb.PlaySound(sJury[bb.RndI(1, 2)])
						promoReact[3] = 1
					}
				}
				if promoTim > 1000 {
					promoStage = 1
					promoTim = 300
				}
			}
			// positive verdict
			if promoStage == 2 && promoVerdict == 1 {
				if promoTim > 325 && promoTim < 625 {
					Speak(5, 1)
					pFoc[5] = 2
					Outline(fmt.tprint(charName[pChar[2]], ",", "it's not my job to share"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
					Outline("out the toys amongst the children!", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
				}
				if promoStage == 2 && promoTim > 650 && promoTim < 950 && promoVerdict == 1 {
					Speak(5, 1)
					pFoc[5] = 2
					Outline("If an item comes between your prisoners, just", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
					Outline("confiscate the damn thing and leave it at that...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
				}
				if promoTim > 950 {
					promoStage = 3
					promoTim = 9975
					camFoc = 1
				}
			}
			// negative verdict
			if promoStage == 2 && promoVerdict == 2 {
				if promoTim > 325 && promoTim < 625 {
					Speak(5, 1)
					pFoc[5] = 1
					Outline(fmt.tprint("You're on a slippery slope,", CellName(pChar[1], context.temp_allocator), "! I see"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
					Outline("you sinking back into a life of crime...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
				}
				if promoTim > 650 && promoTim < 950 {
					Speak(5, 1)
					pFoc[5] = 1
					if promoEffect == 0 {
						bb.PlaySound(sPaper)
						statTim[6] = -100
						randy := bb.RndI(1, 5)
						charSentence[gamChar[slot]] += randy
						if randy == 1 {
							sentence = strings.clone("1 day", context.temp_allocator)
						} else {
							sentence = fmt.tprint(randy, "days")
						}
						bb.PlaySound(sCash)
						statTim[7] = -100
						gamMoney[slot] -= weapValue[weapType[gamItem[slot]]]
						if charCrime[gamChar[slot]] < 6 {
							charCrime[gamChar[slot]] = 6
						}
						promoEffect = 1
					}
					Outline(fmt.tprint("Perhaps another", sentence, "will straighten you out, and"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
					figure := GetFigure(weapValue[weapType[gamItem[slot]]], context.temp_allocator)
					lower := strings.to_lower(weapName[weapType[gamItem[slot]]], context.temp_allocator)
					Outline(fmt.tprint("i also order you to pay $", figure, "for a new", lower, "..."), i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
				}
				if promoTim > 950 {
					promoStage = 3
					promoTim = 9975
					camFoc = 1
				}
			}
		}
		// 8. ASSAULTING ANOTHER INMATE
		if gamWarrant[slot] == 8 {
			// statements
			if promoStage == 0 {
				if promoTim > 350 && promoTim < 650 {
					Speak(2, 1)
					Outline(fmt.tprint(CellName(pChar[1], context.temp_allocator), " is a particularly aggressive inmate and"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
					Outline("had to be restrained from harming the others!", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
					if promoTim > 450 && promoReact[2] == 0 {
						bb.PlaySound(sJury[bb.RndI(1, 2)])
						promoReact[2] = 1
					}
				}
				if promoTim > 675 && promoTim < 975 {
					Speak(1, 1)
					Outline("I was forced to do the warden's job! It's anarchy", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
					Outline("in there, so i constantly have to defend myself...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
					if promoTim > 775 && promoReact[3] == 0 {
						bb.PlaySound(sJury[bb.RndI(1, 2)])
						promoReact[3] = 1
					}
				}
				if promoTim > 1000 {
					promoStage = 1
					promoTim = 300
				}
			}
			// positive verdict
			if promoStage == 2 && promoVerdict == 1 {
				if promoTim > 325 && promoTim < 625 {
					Speak(5, 1)
					pFoc[5] = 2
					Outline(fmt.tprint(charName[pChar[2]], ", i'm not here to do your job!"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
					Outline("You should be able to defuse the odd scuffle...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
				}
				if promoStage == 2 && promoTim > 650 && promoTim < 950 && promoVerdict == 1 {
					Speak(5, 2)
					pFoc[5] = 2
					Outline("I see no reason to punish this man over a bit of", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
					Outline("roughhousing! Simply keep a close eye on him...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
				}
				if promoTim > 950 {
					promoStage = 3
					promoTim = 9975
					camFoc = 1
				}
			}
			// negative verdict
			if promoStage == 2 && promoVerdict == 2 {
				if promoTim > 325 && promoTim < 625 {
					Speak(5, 1)
					pFoc[5] = 1
					Outline("Prison is a place of learning - not fighting!", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
					Outline("Violent behaviour doesn't show much progress...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
				}
				if promoTim > 650 && promoTim < 950 {
					Speak(5, 1)
					pFoc[5] = 1
					if promoEffect == 0 {
						bb.PlaySound(sPaper)
						statTim[6] = -100
						randy := bb.RndI(1, 5)
						charSentence[gamChar[slot]] += randy
						if randy == 1 {
							sentence = strings.clone("1 day", context.temp_allocator)
						} else {
							sentence = fmt.tprint(randy, " days")
						}
						if charCrime[gamChar[slot]] < 8 do charCrime[gamChar[slot]] = 8
						promoEffect = 1
					}
					Outline("Since you obviously need more time to think about", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
					Outline(fmt.tprint("that, i'm adding another ", sentence, " to your sentence!"), i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
				}
				if promoTim > 950 {
					promoStage = 3
					promoTim = 9975
					camFoc = 1
				}
			}
		}
		// 9. ASSAULTING A WARDEN
		if gamWarrant[slot] == 9 {
			// statements
			if promoStage == 0 {
				if promoTim > 350 && promoTim < 650 {
					Speak(2, 1)
					Outline(fmt.tprint(CellName(pChar[1], context.temp_allocator), " has become so aggressive that even"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
					Outline("us wardens aren't safe from his outbursts!", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
					if promoTim > 450 && promoReact[2] == 0 {
						bb.PlaySound(sJury[bb.RndI(1, 2)])
						promoReact[2] = 1
					}
				}
				if promoTim > 675 && promoTim < 975 {
					Speak(1, 1)
					Outline("I never tried to hurt anybody! I was just going", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
					Outline("about my day and caught this guy in a bad mood...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
					if promoTim > 775 && promoReact[3] == 0 {
						bb.PlaySound(sJury[bb.RndI(1, 2)])
						promoReact[3] = 1
					}
				}
				if promoTim > 1000 {
					promoStage = 1
					promoTim = 300
				}
			}
			// positive verdict
			if promoStage == 2 && promoVerdict == 1 {
				if promoTim > 325 && promoTim < 625 {
					Speak(5, 1)
					pFoc[5] = 2
					Outline(fmt.tprint(charName[pChar[2]], ", i'm not here to do your job!"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
					Outline("You should be able to control your own prisoners...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
				}
				if promoStage == 2 && promoTim > 650 && promoTim < 950 && promoVerdict == 1 {
					Speak(5, 1)
					pFoc[5] = 2
					Outline("The only thing that has taken a 'beating' here", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
					Outline("is your ego! You should give as good as you get...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
				}
				if promoTim > 950 {
					promoStage = 3
					promoTim = 9975
					camFoc = 1
				}
			}
			// negative verdict
			if promoStage == 2 && promoVerdict == 2 {
				if promoTim > 325 && promoTim < 625 {
					Speak(5, 1)
					pFoc[5] = 1
					Outline("The wardens are there for the safety of the", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
					Outline("prisoners and shouldn't have to take their abuse!", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
				}
				if promoTim > 650 && promoTim < 950 {
					Speak(5, 1)
					pFoc[5] = 1
					if promoEffect == 0 {
						bb.PlaySound(sPaper)
						statTim[6] = -100
						randy := bb.RndI(3, 7)
						charSentence[gamChar[slot]] += randy
						if randy == 1 {
							sentence = strings.clone("1 day", context.temp_allocator)
						} else {
							sentence = fmt.tprint(randy, " days")
						}
						bb.PlaySound(sCash)
						statTim[7] = -100
						gamMoney[slot] -= promoCash
						if charCrime[gamChar[slot]] < 8 do charCrime[gamChar[slot]] = 8
						promoEffect = 1
					}
					Outline(fmt.tprint("Maybe another ", sentence, " will calm you down, and"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
					Outline(fmt.tprint("i also order you to pay $", GetFigure(promoCash, context.temp_allocator), " in damages..."), i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
				}
				if promoTim > 950 {
					promoStage = 3
					promoTim = 9975
					camFoc = 1
				}
			}
		}
		// 10. ASSAULT WITH WEAPON
		if gamWarrant[slot] == 10 {
			// statements
			if promoStage == 0 {
				if promoTim > 350 && promoTim < 650 {
					Speak(2, 1)
					lower := strings.to_lower(weapName[weapType[gamItem[slot]]], context.temp_allocator)
					Outline(fmt.tprint("This animal was caught using a", lower, "as a"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
					Outline("weapon! He intended to do some serious damage...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
					if promoTim > 450 && promoReact[2] == 0 {
						bb.PlaySound(sJury[bb.RndI(1, 2)])
						promoReact[2] = 1
					}
				}
				if promoTim > 675 && promoTim < 975 {
					Speak(1, 1)
					lower := strings.to_lower(weapName[weapType[gamItem[slot]]], context.temp_allocator)
					Outline(fmt.tprint("I didn't hurt anybody with that", lower, "!"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
					Outline("I just happened to be holding it at the time...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
					if promoTim > 775 && promoReact[3] == 0 {
						bb.PlaySound(sJury[bb.RndI(1, 2)])
						promoReact[3] = 1
					}
				}
				if promoTim > 1000 {
					promoStage = 1
					promoTim = 300
				}
			}
			// positive verdict
			if promoStage == 2 && promoVerdict == 1 {
				if promoTim > 325 && promoTim < 625 {
					Speak(5, 1)
					pFoc[5] = 2
					lower := strings.to_lower(weapName[weapType[gamItem[slot]]], context.temp_allocator)
					Outline(fmt.tprint("Just because a man is carrying a", lower, ","), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
					Outline("it doesn't mean he plans to use it as a weapon!", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
				}
				if promoStage == 2 && promoTim > 650 && promoTim < 950 && promoVerdict == 1 {
					Speak(5, 1)
					pFoc[5] = 2
					Outline("Stop being so melodramatic, and simply confiscate", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
					Outline("such items before the situation turns violent...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
				}
				if promoTim > 950 {
					promoStage = 3
					promoTim = 9975
					camFoc = 1
				}
			}
			// negative verdict
			if promoStage == 2 && promoVerdict == 2 {
				if promoTim > 325 && promoTim < 625 {
					Speak(5, 1)
					pFoc[5] = 1
					Outline("You shouldn't be fighting at all - let alone with", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
					lower := strings.to_lower(weapName[weapType[gamItem[slot]]], context.temp_allocator)
					Outline(fmt.tprint("weapons! That", lower, "could've killed someone..."), i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
				}
				if promoTim > 650 && promoTim < 950 {
					Speak(5, 1)
					pFoc[5] = 1
					if promoEffect == 0 {
						bb.PlaySound(sPaper)
						statTim[6] = -100
						randy := bb.RndI(5, 10)
						charSentence[gamChar[slot]] += randy
						if randy == 1 {
							sentence = strings.clone("1 day", context.temp_allocator)
						} else {
							sentence = fmt.tprint(randy, "days")
						}
						promoEffect = 1
					}
					Outline("This is extremely disturbing behaviour, and i", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
					Outline(fmt.tprint("sentence you to an extra", sentence, "to address it..."), i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
				}
				if promoTim > 950 {
					promoStage = 3
					promoTim = 9975
					camFoc = 1
				}
			}
		}
		// 11. GRIEVOUS BODILY HARM
		if gamWarrant[slot] == 11 {
			// statements
			if promoStage == 0 {
				if promoTim > 350 && promoTim < 650 {
					Speak(2, 1)
					Outline(fmt.tprint("This animal beat", charName[gamVictim[slot]], "so badly"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
					Outline(fmt.tprint("that the poor man lost", DescribeLimb(gamVictim[slot]), "!"), i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
					if promoTim > 450 && promoReact[2] == 0 {
						bb.PlaySound(sJury[bb.RndI(1, 2)])
						promoReact[2] = 1
					}
				}
				if promoTim > 675 && promoTim < 975 {
					Speak(1, 1)
					Outline(fmt.tprint("I never intended to hurt", charName[gamVictim[slot]], "!"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
					Outline(fmt.tprint("He lost", DescribeLimb(gamVictim[slot]), "when he fell on the ground..."), i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
					if promoTim > 775 && promoReact[3] == 0 {
						bb.PlaySound(sJury[bb.RndI(1, 2)])
						promoReact[3] = 1
					}
				}
				if promoTim > 1000 {
					promoStage = 1
					promoTim = 300
				}
			}
			// positive verdict
			if promoStage == 2 && promoVerdict == 1 {
				if promoTim > 325 && promoTim < 625 {
					Speak(5, 1)
					pFoc[5] = 2
					Outline(fmt.tprint("You're being a drama queen,", charName[pChar[2]], "!"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
					Outline(fmt.tprint(charName[gamVictim[slot]], "was never in any serious danger..."), i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
				}
				if promoStage == 2 && promoTim > 650 && promoTim < 950 && promoVerdict == 1 {
					Speak(5, 1)
					pFoc[5] = 2
					Outline("It sounds like nothing more than an accident.", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
					Outline("Just try to deal with it better next time...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
				}
				if promoTim > 950 {
					promoStage = 3
					promoTim = 9975
					camFoc = 1
				}
			}
			// negative verdict
			if promoStage == 2 && promoVerdict == 2 {
				if promoTim > 325 && promoTim < 625 {
					Speak(5, 1)
					pFoc[5] = 1
					Outline(fmt.tprint("It's a miracle that", charName[gamVictim[slot]], "survived!"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
					Outline("You're evidently a threat to your fellow inmates...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
				}
				if promoTim > 650 && promoTim < 950 {
					Speak(5, 1)
					pFoc[5] = 1
					if promoEffect == 0 {
						bb.PlaySound(sPaper)
						statTim[6] = -100
						randy := bb.RndI(5, 10)
						charSentence[gamChar[slot]] += randy
						if randy == 1 {
							sentence = strings.clone("1 day", context.temp_allocator)
						} else {
							sentence = fmt.tprint(randy, "days")
						}
						bb.PlaySound(sCash)
						statTim[7] = -100
						gamMoney[slot] -= 1000
						if charCrime[gamChar[slot]] < 11 do charCrime[gamChar[slot]] = 11
						promoEffect = 1
					}
					Outline(fmt.tprint("You deserve to be behind bars for another", sentence, ","), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
					Outline(fmt.tprint("and i also order you to pay $", GetFigure(1000, context.temp_allocator), "in medical fees..."), i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
				}
				if promoTim > 950 {
					promoStage = 3
					promoTim = 9975
					camFoc = 1
				}
			}
		}
		// 12. ATTEMPTED MURDER
		if gamWarrant[slot] == 12 {
			// statements
			if promoStage == 0 {
				if promoTim > 350 && promoTim < 650 {
					Speak(2, 1)
					Outline(fmt.tprint("This animal viciously attacked ", charName[gamVictim[slot]]), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
					Outline("and left the poor man fighting for his life!", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
					if promoTim > 450 && promoReact[2] == 0 {
						bb.PlaySound(sJury[bb.RndI(1, 2)])
						promoReact[2] = 1
					}
				}
				if promoTim > 675 && promoTim < 975 {
					Speak(1, 1)
					Outline(fmt.tprint("I never intended to hurt ", charName[gamVictim[slot]], "!"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
					Outline("It was a disagreement that got out of hand...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
					if promoTim > 775 && promoReact[3] == 0 {
						bb.PlaySound(sJury[bb.RndI(1, 2)])
						promoReact[3] = 1
					}
				}
				if promoTim > 1000 {
					promoStage = 1
					promoTim = 300
				}
			}
			// positive verdict
			if promoStage == 2 && promoVerdict == 1 {
				if promoTim > 325 && promoTim < 625 {
					Speak(5, 1)
					pFoc[5] = 2
					Outline(fmt.tprint("You're being a drama queen, ", charName[pChar[2]], "!"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
					Outline(fmt.tprint(charName[gamVictim[slot]], " was never in any serious danger..."), i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
				}
				if promoStage == 2 && promoTim > 650 && promoTim < 950 && promoVerdict == 1 {
					Speak(5, 1)
					pFoc[5] = 2
					Outline("It sounds like nothing more than an accident.", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
					Outline("Just try to deal with it better next time...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
				}
				if promoTim > 950 {
					promoStage = 3
					promoTim = 9975
					camFoc = 1
				}
			}
			// negative verdict
			if promoStage == 2 && promoVerdict == 2 {
				if promoTim > 325 && promoTim < 625 {
					Speak(5, 1)
					pFoc[5] = 1
					Outline(fmt.tprint("It's a miracle that ", charName[gamVictim[slot]], " survived!"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
					Outline("You're evidently a threat to your fellow inmates...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
				}
				if promoTim > 650 && promoTim < 950 {
					Speak(5, 1)
					pFoc[5] = 1
					if promoEffect == 0 {
						bb.PlaySound(sPaper)
						statTim[6] = -100
						randy := bb.RndI(5, 10)
						charSentence[gamChar[slot]] += randy
						if randy == 1 {
							sentence = strings.clone("1 day", context.temp_allocator)
						} else {
							sentence = fmt.tprint(randy, " days")
						}
						bb.PlaySound(sCash)
						statTim[7] = -100
						gamMoney[slot] -= 1000
						if charCrime[gamChar[slot]] < 12 do charCrime[gamChar[slot]] = 12
						promoEffect = 1
					}
					Outline(fmt.tprint("You deserve to be behind bars for another ", sentence, ","), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
					Outline(fmt.tprint("and i order you to pay $", GetFigure(1000, context.temp_allocator), " in medical fees..."), i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
				}
				if promoTim > 950 {
					promoStage = 3
					promoTim = 9975
					camFoc = 1
				}
			}
		}
		// 13. MURDER
		if gamWarrant[slot] == 13 {
			// statements
			if promoStage == 0 {
				if promoTim > 350 && promoTim < 650 {
					Speak(2, 1)
					Outline(fmt.tprint("This psycho viciously attacked ", charName[gamVictim[slot]]), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
					Outline("and succeeded in taking the poor man's life!", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
					if promoTim > 450 && promoReact[2] == 0 {
						bb.PlaySound(sJury[bb.RndI(1, 2)])
						promoReact[2] = 1
					}
				}
				if promoTim > 675 && promoTim < 975 {
					Speak(1, 1)
					Outline(fmt.tprint("I didn't kill ", charName[gamVictim[slot]], "! I was there when it"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
					Outline("happened, but i wasn't responsible for his death...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
					if promoTim > 775 && promoReact[3] == 0 {
						bb.PlaySound(sJury[bb.RndI(1, 2)])
						promoReact[3] = 1
					}
				}
				if promoTim > 1000 {
					promoStage = 1
					promoTim = 300
				}
			}
			// positive verdict
			if promoStage == 2 && promoVerdict == 1 {
				if promoTim > 325 && promoTim < 625 {
					Speak(5, 1)
					pFoc[5] = 2
					Outline(fmt.tprint("You just wanted a scapegoat, ", charName[pChar[2]], "!"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
					Outline("A fatality doesn't look good on anybody's record...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
				}
				if promoStage == 2 && promoTim > 650 && promoTim < 950 && promoVerdict == 1 {
					Speak(5, 1)
					pFoc[5] = 2
					Outline(fmt.tprint("The simple fact is that ", charName[gamVictim[slot]], " would"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
					Outline("still be alive if you were doing your job!", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
				}
				if promoTim > 950 {
					promoStage = 3
					promoTim = 9975
					camFoc = 1
				}
			}
			// negative verdict
			if promoStage == 2 && promoVerdict == 2 {
				if promoTim > 325 && promoTim < 625 {
					Speak(5, 1)
					pFoc[5] = 1
					Outline(fmt.tprint(CellName(pChar[1], context.temp_allocator), ", you murdered ", charName[gamVictim[slot]], " because"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
					Outline("you have absolutely no respect for human life!", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
				}
				if promoTim > 650 && promoTim < 950 {
					Speak(5, 1)
					pFoc[5] = 1
					if promoEffect == 0 {
						bb.PlaySound(sPaper)
						statTim[6] = -100
						randy := bb.RndI(7, 14)
						charSentence[gamChar[slot]] += randy
						if randy == 1 {
							sentence = strings.clone("1 day", context.temp_allocator)
						} else {
							sentence = fmt.tprint(randy, " days")
						}
						if charCrime[gamChar[slot]] < 14 do charCrime[gamChar[slot]] = 14
						promoEffect = 1
					}
					Outline("You're a menace to society, and i don't want", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
					Outline(fmt.tprint("to see you released for another ", sentence, " yet..."), i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
				}
				if promoTim > 950 {
					promoStage = 3
					promoTim = 9975
					camFoc = 1
				}
			}
		}
		// 14. SERIAL MURDER
		if gamWarrant[slot] == 14 {
			// statements
			if promoStage == 0 {
				if promoTim > 350 && promoTim < 650 {
					Speak(2, 1)
					Outline(fmt.tprint(charName[gamVictim[slot]], "'s recent death is just one of"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
					Outline("many that can be traced back to this psycho!", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
					if promoTim > 450 && promoReact[2] == 0 {
						bb.PlaySound(sJury[bb.RndI(1, 2)])
						promoReact[2] = 1
					}
				}
				if promoTim > 675 && promoTim < 975 {
					Speak(1, 1)
					Outline(fmt.tprint("I didn't kill ", charName[gamVictim[slot]], " or anybody else!"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
					Outline("In fact, i was there to help save their lives...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
					if promoTim > 775 && promoReact[3] == 0 {
						bb.PlaySound(sJury[bb.RndI(1, 2)])
						promoReact[3] = 1
					}
				}
				if promoTim > 1000 {
					promoStage = 1
					promoTim = 300
				}
			}
			// positive verdict
			if promoStage == 2 && promoVerdict == 1 {
				if promoTim > 325 && promoTim < 625 {
					Speak(5, 1)
					pFoc[5] = 2
					Outline(fmt.tprint(charName[pChar[2]], ", what were you doing while"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
					Outline("all of these people were dropping dead?!", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
				}
				if promoStage == 2 && promoTim > 650 && promoTim < 950 && promoVerdict == 1 {
					Speak(5, 1)
					pFoc[5] = 2
					Outline("The simple fact is that these supposed victims", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
					Outline("would all be alive if you were doing your job!", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
				}
				if promoTim > 950 {
					promoStage = 3
					promoTim = 9975
					camFoc = 1
				}
			}
			// negative verdict
			if promoStage == 2 && promoVerdict == 2 {
				if promoTim > 325 && promoTim < 625 {
					Speak(5, 1)
					pFoc[5] = 1
					Outline("One death on your hands can be explained away,", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
					Outline("but several makes you a cold-blooded killer!", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
				}
				if promoTim > 650 && promoTim < 950 {
					Speak(5, 1)
					pFoc[5] = 1
					if promoEffect == 0 {
						bb.PlaySound(sPaper)
						statTim[6] = -100
						randy := bb.RndI(10, 20)
						charSentence[gamChar[slot]] += randy
						if randy == 1 {
							sentence = strings.clone("1 day", context.temp_allocator)
						} else {
							sentence = fmt.tprint(randy, " days")
						}
						if charCrime[gamChar[slot]] < 14 do charCrime[gamChar[slot]] = 14
						promoEffect = 1
					}
					Outline("You're an evil human being, and i wouldn't", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
					Outline("be surprised if you never leave this place...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
				}
				if promoTim > 950 {
					promoStage = 3
					promoTim = 9975
					camFoc = 1
				}
			}
		}
		// INTERRUPT
		if promoStage == 1 {
			if promoTim > 325 && promoTim < 625 {
				Speak(5, 1)
				pFoc[5] = 0
				Outline("OK, you can both stop bickering! I'll settle this.", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
				Outline("Just give me a minute to think over the facts...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
			}
			if promoTim > 650 && promoTim < 950 {
				Speak(5, 2)
				pFoc[5] = 0
				promoVerdict = bb.RndI(1, 2)
				randy := bb.RndI(0, 110 - charIntelligence[gamChar[slot]])
				if randy <= 5 do promoVerdict = 1
				Outline("After hearing each of your statements and reviewing", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
				Outline("the evidence, this court rules in favour of...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
				if promoTim > 800 && promoReact[4] == 0 {
					bb.PlaySound(sMurmur)
					promoReact[4] = 1
				}
			}
			if promoTim > 1050 && promoTim < 1200 && promoVerdict == 1 {
				Speak(promoVerdict, 3)
				pEyes[1] = 3
				pEyes[2] = 1
				pEyes[3] = 3
				pEyes[4] = 1
				if promoReact[5] == 0 {
					bb.PlaySound(sJury[bb.RndI(1, 2)])
					promoReact[5] = 1
				}
				Outline(fmt.tprint("...Prisoner ", CellName(pChar[promoVerdict], context.temp_allocator), "!"), i32(rX(400)), i32(rY(535)), 30, 30, 30, 250, bb.RndI(150, 220), 100)
			}
			if promoTim > 1050 && promoTim < 1200 && promoVerdict == 2 {
				Speak(promoVerdict, 3)
				pEyes[1] = 1
				pEyes[2] = 3
				pEyes[3] = 1
				pEyes[4] = 3
				if promoReact[5] == 0 {
					bb.PlaySound(sJury[bb.RndI(1, 2)])
					promoReact[5] = 1
				}
				Outline(fmt.tprint("...", charName[pChar[promoVerdict]], "!"), i32(rX(400)), i32(rY(535)), 30, 30, 30, 250, bb.RndI(150, 220), 100)
			}
			if promoTim > 1200 {
				promoStage = 2
				promoTim = 300
				camFoc = 5
			}
		}
		// take photo
		if camFoc > 0 && camFoc == oldfoc {
			if pSpeaking[camFoc] > 0 && cast(bool)ReachedCord(camX, camZ, camTX, camTZ, 5) \
			&& cast(bool)ReachedCord(camPivX, camPivZ, camPivTX, camPivTZ, 5) {
				if charSnapped[pChar[camFoc]] == 0 do TakePhoto(pChar[camFoc])
				if camFoc <= 2 && charSnapped[camFoc] == 0 do TakePhoto(camFoc)
			}
		}
		// mask shaky start
		if gotim <= 0 do Loader("Please Wait", "Preparing Court Case")

		bb.Flip()
		// screenshot (F12)
		if cast(bool)bb.KeyHit(88) do Screenshot()

	}
	//restore sound
	if bb.ChannelPlaying(chAtmos) > 0 do bb.StopChannel(chAtmos)
	//free entities
	bb.FreeTimer(timer)
	bb.FreeEntity(world)
	bb.FreeEntity(cam)
	bb.FreeEntity(camPivot)
	bb.FreeEntity(dummy)
	for cyc in 1..=no_lights do bb.FreeEntity(light[cyc])
	for cyc in 1..=no_plays do bb.FreeEntity(p[cyc])
	//verdict effects
	if gamWarrant[slot] > 0 {
		RemovePromo(28)
		RemovePromo(29)
		RemovePromo(88)
		RemovePromo(89)
		RemovePromo(90)
		if gamMission[slot] == 19 do CompleteMission(1)
		ChangeRelationship(pChar[1], pChar[2], -1)
		if promoVerdict == 1 {
			charHappiness[gamChar[slot]] += 10
			charReputation[gamChar[slot]] -= 1
			statTim[4] = -50
			charPromo[pChar[2]][pChar[1]] = 28
		}
		if promoVerdict == 2 {
			charHappiness[gamChar[slot]] /= 2
			charReputation[gamChar[slot]] += 1
			statTim[4] = 50
			charPromo[pChar[2]][pChar[1]] = 29
		}
		for v in i32(1)..=no_chars {
			if v != gamChar[slot] && charRole[v] == 0 && charPromo[v][gamChar[slot]] == 0 {
				if promoVerdict == 1 && FriendlyChars(v, gamChar[slot]) == 0 do charPromo[v][gamChar[slot]] = 89
				if promoVerdict == 2 && cast(bool)FriendlyChars(v, gamChar[slot]) do charPromo[v][gamChar[slot]] = 88
				if promoVerdict == 2 && charGang[gamChar[slot]] == 6 && charGang[v] == 6 do charPromo[v][gamChar[slot]] = 90
			}
		}
	}
	//relocate to home block
	charX[gamChar[slot]], charZ[gamChar[slot]] = 0, -325
	charY[gamChar[slot]], charA[gamChar[slot]] = 20, 0
	charLocation[gamChar[slot]] = TranslateBlock(charBlock[gamChar[slot]])
	gamLocation[slot] = charLocation[gamChar[slot]]
	camX, camY, camZ = -100, 50, -200
	camPivX, camPivY, camPivZ = camX, camY, camZ
	charBreakdown[gamChar[slot]] = 0
	//initiation in hall
	if gamWarrant[slot] == 0 {
		charLocation[gamChar[slot]] = 9
		gamLocation[slot] = charLocation[gamChar[slot]]
		charX[gamChar[slot]], charZ[gamChar[slot]], charA[gamChar[slot]] = -260, -240, 160
		charLocation[pChar[2]] = 9
		charX[pChar[2]], charZ[pChar[2]], charA[pChar[2]] = -250, -260, 135
		charPromo[pChar[2]][gamChar[slot]] = 71
		camX, camY, camZ = 0, 75, 0
		camPivX, camPivY, camPivZ = camX, camY, camZ
	}
	//get rid of offending item
	if gamWarrant[slot] == 4 || gamWarrant[slot] == 6 || gamWarrant[slot] == 7 || gamWarrant[slot] == 10 {
		if gamItem[slot] > 0 && FindCarrier(gamItem[slot]) == 0 {
			weapLocation[gamItem[slot]] = 0
			gamItem[slot] = 0
		}
	}
	//proceed
	gamWarrant[slot] = 0
	screen = 50
	mem.end_arena_temp_memory(checkpoint)
}


//----------------------------------------------------------------------
///////////////////////////// CRIME PROMOS /////////////////////////////
//----------------------------------------------------------------------
CrimePromos :: proc(cyc, v: i32, y: f32) {
	checkpoint := mem.begin_arena_temp_memory(cast(^mem.Arena)context.temp_allocator.data)
	// 101. ARRESTED FOR DISSENT
	if gamPromo == 101 {
		if promoTim > 25 && promoTim < 325 {
			Speak(cyc, 1)
			promoAccuser = pChar[cyc]
			DropWeapon(v, 0)
			Outline(fmt.tprint("We've had enough of your attitude, ", CellName(pChar[v], context.temp_allocator), "!"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("Perhaps a judge will teach you some respect...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 325 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = 1
		}
	}
	// 102. ARRESTED FOR CONSPIRACY
	if gamPromo == 102 {
		if promoTim > 25 && promoTim < 325 {
			Speak(cyc, 1)
			promoAccuser = pChar[cyc]
			DropWeapon(v, 0)
			Outline(fmt.tprint("You joined the wrong gang, ", CellName(pChar[v], context.temp_allocator), "!"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline(fmt.tprint(textGang[charGang[pChar[v]]], " are under investigation..."), i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 325 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = 1
		}
	}
	// 103. ARRESTED FOR TRYING TO ESCAPE
	if gamPromo == 103 {
		if promoTim > 25 && promoTim < 325 {
			Speak(cyc, 1)
			promoAccuser = pChar[cyc]
			DropWeapon(v, 0)
			Outline("Your little adventure is over, Magellan!", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("Let's see you explain this to a judge...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 325 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = 1
		}
	}
	// 104. ARRESTED FOR ILLEGAL ITEM
	if gamPromo == 104 {
		if promoTim > 25 && promoTim < 325 {
			Speak(cyc, 1)
			promoAccuser = pChar[cyc]
			DropWeapon(v, 0)
			Outline(fmt.tprint("We caught you red-handed, ", CellName(pChar[v], context.temp_allocator), "! You're"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline(fmt.tprint("under arrest for carrying a ", strings.to_lower(weapName[weapType[gamItem[slot]]], context.temp_allocator), "..."), i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 325 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = 1
		}
	}
	// 105. ARRESTED FOR DRUG ABUSE
	if gamPromo == 105 {
		if promoTim > 25 && promoTim < 325 {
			Speak(cyc, 1)
			promoAccuser = pChar[cyc]
			DropWeapon(v, 0)
			Outline(fmt.tprint("Sorry to blow your high, ", CellName(pChar[v], context.temp_allocator), ", but"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("that poison won't help your rehabilitation!", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 325 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = 1
		}
	}
	// 106. ARRESTED FOR ILLEGAL TRADING
	if gamPromo == 106 {
		if promoTim > 25 && promoTim < 325 {
			Speak(cyc, 1)
			promoAccuser = pChar[cyc]
			DropWeapon(v, 0)
			Outline(fmt.tprint("Business is over, ", CellName(pChar[v], context.temp_allocator), "! You're under"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline(fmt.tprint("arrest for trading ", strings.to_lower(weapName[weapType[gamItem[slot]]], context.temp_allocator), "s..."), i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 325 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = 1
		}
	}
	// 107. ARRESTED FOR STEALING
	if gamPromo == 107 {
		if promoTim > 25 && promoTim < 325 {
			Speak(cyc, 1)
			promoAccuser = pChar[cyc]
			DropWeapon(v, 0)
			Outline(fmt.tprint("I saw you take that ", strings.to_lower(weapName[weapType[gamItem[slot]]], context.temp_allocator), ", ", CellName(pChar[v], context.temp_allocator), "!"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("You're under arrest for stealing...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 325 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = 1
		}
	}
	// 108. ARRESTED FOR ASSAULT
	if gamPromo == 108 {
		if promoTim > 25 && promoTim < 325 {
			Speak(cyc, 1)
			promoAccuser = pChar[cyc]
			DropWeapon(v, 0)
			Outline(fmt.tprint("You've thrown your last punch, ", CellName(pChar[v], context.temp_allocator), "! You're"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("under arrest for assaulting another inmate...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 325 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = 1
		}
	}
	// 109. ARRESTED FOR ASSAULTING A WARDEN
	if gamPromo == 109 {
		if promoTim > 25 && promoTim < 325 {
			Speak(cyc, 1)
			promoAccuser = pChar[cyc]
			DropWeapon(v, 0)
			Outline(fmt.tprint("You just picked the wrong fight, ", CellName(pChar[v], context.temp_allocator), "!"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("You're under arrest for assaulting a warden...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 325 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = 1
		}
	}
	// 110. ARRESTED FOR ASSAULT WITH WEAPON
	if gamPromo == 110 {
		if promoTim > 25 && promoTim < 325 {
			Speak(cyc, 1)
			promoAccuser = pChar[cyc]
			DropWeapon(v, 0)
			Outline(fmt.tprint("You could've killed someone with that ", strings.to_lower(weapName[weapType[gamItem[slot]]], context.temp_allocator), "!"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("You're under arrest for assault with a weapon...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 325 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = 1
		}
	}
	// 111. ARRESTED FOR ATTEMPTED MURDER
	if gamPromo == 111 {
		if promoTim > 25 && promoTim < 325 {
			Speak(cyc, 1)
			promoAccuser = pChar[cyc]
			DropWeapon(v, 0)
			Outline(fmt.tprint(charName[gamVictim[slot]], " is scarred for life because of you!"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("You're under arrest for grievous bodily harm...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 325 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = 1
		}
	}
	// 112. ARRESTED FOR ATTEMPTED MURDER
	if gamPromo == 112 {
		if promoTim > 25 && promoTim < 325 {
			Speak(cyc, 1)
			promoAccuser = pChar[cyc]
			DropWeapon(v, 0)
			Outline(fmt.tprint("You almost killed ", charName[gamVictim[slot]], ", you animal!"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("You're under arrest for attempted murder...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 325 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = 1
		}
	}
	// 113. ARRESTED FOR MURDER
	if gamPromo == 113 {
		if promoTim > 25 && promoTim < 325 {
			Speak(cyc, 1)
			promoAccuser = pChar[cyc]
			DropWeapon(v, 0)
			Outline(fmt.tprint("You killed ", charName[gamVictim[slot]], ", you animal!"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("You're going down for murder...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 325 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = 1
		}
	}
	// 114. ARRESTED FOR SERIAL KILLING
	if gamPromo == 114 {
		if promoTim > 25 && promoTim < 325 {
			Speak(cyc, 1)
			promoAccuser = pChar[cyc]
			DropWeapon(v, 0)
			Outline(fmt.tprint(charName[gamVictim[slot]], " is your last victim, ", CellName(pChar[v], context.temp_allocator), "!"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("You're going down for serial murder...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 325 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = 1
		}
	}
	//////////////////////////// ALARMS ////////////////////////////
	// 121. WANTED FOR DISSENT
	if gamPromo == 121 {
		if promoEffect == 0 {
			ProduceSound(bb.FindChild(world, "Tanoy01"), sTanoy, 22050, 1)
			promoEffect = 1
		}
		if promoTim > 25 && promoTim < 325 {
			Speak(cyc, 1)
			Outline(fmt.tprint("ATTENTION! Prisoner ", CellName(gamChar[slot], context.temp_allocator), " is under"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("arrest for disobeying the prison rules!", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 325 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = 1
		}
	}
	// 122. WANTED FOR CONSPIRACY
	if gamPromo == 122 {
		if promoEffect == 0 {
			ProduceSound(bb.FindChild(world, "Tanoy01"), sTanoy, 22050, 1)
			promoEffect = 1
		}
		if promoTim > 25 && promoTim < 325 {
			Speak(cyc, 1)
			Outline(fmt.tprint("ATTENTION! Prisoner ", CellName(gamChar[slot], context.temp_allocator), " is wanted"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("for engaging in gang activity!", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 325 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = 1
		}
	}
	// 123. WANTED FOR ESCAPE
	if gamPromo == 123 {
		if promoEffect == 0 {
			ProduceSound(bb.FindChild(world, "Tanoy01"), sTanoy, 22050, 1)
			promoEffect = 1
		} 
		if promoTim > 25 && promoTim < 325 {
			Speak(cyc, 1)
			Outline(fmt.tprint("ATTENTION! Prisoner ", CellName(gamChar[slot], context.temp_allocator), " is under"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("arrest for conspiring to escape!", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 325 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = 1
		}
	}
	// 124. WANTED FOR ILLEGAL ITEM
	if gamPromo == 124 {
		if promoEffect == 0 do ProduceSound(bb.FindChild(world, "Tanoy01"), sTanoy, 22050, 1) ; promoEffect = 1
		if promoTim > 25 && promoTim < 325 {
			Speak(cyc, 1)
			Outline(fmt.tprint("ATTENTION! Prisoner ", CellName(gamChar[slot], context.temp_allocator), " is under"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline(fmt.tprint("arrest for carrying a ", strings.to_lower(weapName[weapType[gamItem[slot]]], context.temp_allocator), "!"), i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 325 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = 1
		}
	}
	// 125. WANTED FOR DRUG ABUSE
	if gamPromo == 125 {
		if promoEffect == 0 do ProduceSound(bb.FindChild(world, "Tanoy01"), sTanoy, 22050, 1) ; promoEffect = 1
		if promoTim > 25 && promoTim < 325 {
			Speak(cyc, 1)
			Outline(fmt.tprint("ATTENTION! Prisoner ", CellName(gamChar[slot], context.temp_allocator), " is"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("wanted for drug abuse!", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 325 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = 1
		}
	}
	// 126. WANTED FOR ILLEGAL TRADING
	if gamPromo == 126 {
		if promoEffect == 0 do ProduceSound(bb.FindChild(world, "Tanoy01"), sTanoy, 22050, 1) ; promoEffect = 1
		if promoTim > 25 && promoTim < 325 {
			Speak(cyc, 1)
			Outline(fmt.tprint("ATTENTION! Prisoner ", CellName(gamChar[slot], context.temp_allocator), " is under"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline(fmt.tprint("arrest for trading ", strings.to_lower(weapName[weapType[gamItem[slot]]], context.temp_allocator), "s!"), i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 325 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = 1
		}
	}
	// 127. WANTED FOR ILLEGAL TRADING (stealing)
	if gamPromo == 127 {
		if promoEffect == 0 do ProduceSound(bb.FindChild(world, "Tanoy01"), sTanoy, 22050, 1) ; promoEffect = 1
		if promoTim > 25 && promoTim < 325 {
			Speak(cyc, 1)
			Outline(fmt.tprint("ATTENTION! Prisoner ", CellName(gamChar[slot], context.temp_allocator), " is wanted"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline(fmt.tprint("for stealing a ", strings.to_lower(weapName[weapType[gamItem[slot]]], context.temp_allocator), "!"), i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 325 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = 1
		}
	}
	// 128. WANTED FOR ASSAULT
	if gamPromo == 128 {
		if promoEffect == 0 {
			ProduceSound(bb.FindChild(world, "Tanoy01"), sTanoy, 22050, 1)
			promoEffect = 1
		}
		if promoTim > 25 && promoTim < 325 {
			Speak(cyc, 1)
			Outline(fmt.tprint("ATTENTION! Prisoner ", CellName(gamChar[slot], context.temp_allocator), " is wanted"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("for assaulting another inmate!", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 325 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = 1
		}
	}
	// 129. WANTED FOR ASSAULTING A WARDEN
	if gamPromo == 129 {
		if promoEffect == 0 {
			ProduceSound(bb.FindChild(world, "Tanoy01"), sTanoy, 22050, 1)
			promoEffect = 1
		}
		if promoTim > 25 && promoTim < 325 {
			Speak(cyc, 1)
			Outline(fmt.tprint("ATTENTION! Prisoner ", CellName(gamChar[slot], context.temp_allocator), " is under"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("arrest for assaulting a warden!", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 325 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = 1
		}
	}
	// 130. WANTED FOR ASSAULT WITH WEAPON
	if gamPromo == 130 {
		if promoEffect == 0 {
			ProduceSound(bb.FindChild(world, "Tanoy01"), sTanoy, 22050, 1)
			promoEffect = 1
		}
		if promoTim > 25 && promoTim < 325 {
			Speak(cyc, 1)
			Outline(fmt.tprint("ATTENTION! Prisoner ", CellName(gamChar[slot], context.temp_allocator), " is wanted"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline(fmt.tprint("for using a ", strings.to_lower(weapName[weapType[gamItem[slot]]], context.temp_allocator), " as a weapon!"), i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 325 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = 1
		}
	}
	// 131. WANTED FOR GRIEVIOUS BODILY HARM
	if gamPromo == 131 {
		if promoEffect == 0 {
			ProduceSound(bb.FindChild(world, "Tanoy01"), sTanoy, 22050, 1)
			promoEffect = 1
		}
		if promoTim > 25 && promoTim < 325 {
			Speak(cyc, 1)
			Outline(fmt.tprint("ATTENTION! Prisoner ", CellName(gamChar[slot], context.temp_allocator), " is wanted for"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline(fmt.tprint("mutilating the body of ", charName[gamVictim[slot]], "!"), i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 325 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = 1
		}
	}
	// 132. WANTED FOR ATTEMPTED MURDER
	if gamPromo == 132 {
		if promoEffect == 0 {
			ProduceSound(bb.FindChild(world, "Tanoy01"), sTanoy, 22050, 1)
			promoEffect = 1
		}
		if promoTim > 25 && promoTim < 325 {
			Speak(cyc, 1)
			Outline(fmt.tprint("ATTENTION! Prisoner ", CellName(gamChar[slot], context.temp_allocator), " is wanted for"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline(fmt.tprint("the attempted murder of ", charName[gamVictim[slot]], "!"), i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 325 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = 1
		}
	}
	// 133. WANTED FOR MURDER
	if gamPromo == 133 || gamPromo == 134 {
		if promoEffect == 0 {
			ProduceSound(bb.FindChild(world, "Tanoy01"), sTanoy, 22050, 1)
			promoEffect = 1
		}
		if promoTim > 25 && promoTim < 325 {
			Speak(cyc, 1)
			Outline(fmt.tprint("ATTENTION! Prisoner ", CellName(gamChar[slot], context.temp_allocator), " is wanted for"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline(fmt.tprint("the murder of ", charName[gamVictim[slot]], "!"), i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 325 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = 1
		}
	}
	mem.end_arena_temp_memory(checkpoint)
}