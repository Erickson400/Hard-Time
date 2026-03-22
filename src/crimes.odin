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
		digit := Dig(charModel[pChar[cyc]], 10)
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
		for limb in 1 ..= 40 {
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
	foc := 1
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
					if pSpeaking[cyc] != 0 && pState[cyc] != 2 {
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
						charSentence[gamChar[slot]] = charSentence[gamChar[slot]] + 1
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

	}

	mem.end_arena_temp_memory(checkpoint)
}










CrimePromos :: proc(cyc, v: i32, y: f32) {

}