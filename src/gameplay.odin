package main

import bb "blitzbasic3d"
import "core:fmt"
import "core:mem"
import "core:strings"

//-------------------------------------------------------------------------
///////////////////////////////// HARD TIME ///////////////////////////////
//-------------------------------------------------------------------------
//~~~~~~~~~~~~~~~~~~~~~ Copyright � Mat Dickie 2007 ~~~~~~~~~~~~~~~~~~~~~~~
//~~~~~~~~~~ This program may not be re-released under any other ~~~~~~~~~~
//~~~~~~~ identity or sold commercially without express permission. ~~~~~~~
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

entry_point :: proc() {
	// INITIATE ENGINE 
	LoadOptions()
	ChangeResolution(optRes, 0)
	bb.SetBuffer(bb.BackBuffer())
	bb.AutoMidHandle(true)
	bb.EnableDirectInput(true)
	bb.SeedRnd(bb.MilliSecs())   

	// LOADING PROCESS
	// intro
	Intro()
	// load media
	LoadImages()
	LoadTextures()
	LoadWeaponData()

	// SCREEN MANAGEMENT
	bb.SeedRnd(bb.MilliSecs())
	screen: i32 = 1
	for {
		// load screen
		LoadScreen(screen)
		// get-out clause
		if cast(bool)bb.KeyDown(56) && cast(bool)bb.KeyDown(45) do return
		if screen == 0 do break
	}
}


LoadScreen :: proc(request: i32) {
	// main menus
	if request == 1 do MainMenu()
	if request == 2 do Options()
	if request == 3 do RedefineKeys()
	if request == 4 do RedefineGamepad()
	if request == 5 do SlotSelect()
	if request == 6 do Credits()
	if request == 7 do Outro()
	if request == 8 do EditSelect()
	// 3D scenes
	if request == 50 do Gameplay()
	if request == 51 do Editor()
	if request == 52 do CourtCase()
	if request == 53 do Ending()
}


//--------------------------------------------------------------------------
///////////////////////////// 50. GAMEPLAY /////////////////////////////////
//--------------------------------------------------------------------------
Gameplay :: proc() {
	checkpoint := mem.begin_arena_temp_memory(cast(^mem.Arena)context.temp_allocator.data)
	// adjust resolution
	ChangeResolution(optRes, 1)
	// load location
	Loader("Please Wait", fmt.tprint("Loading", textLocation[gamLocation[slot]]))
	LoadWorld()
	// load atmosphere
	Loader("Please Wait", "Loading Atmosphere")
	LoadAtmos()
	// background noise
	bb.LoopSound(sAtmos)
	chAtmos = bb.EmitSound(sAtmos, cam)
	bb.ChannelVolume(chAtmos, 0.3)
	if gamLocation[slot] == 6 || gamLocation[slot] == 8 || gamLocation[slot] == 9 {
		bb.ChannelVolume(chAtmos, f32(AreaPopulation(gamLocation[slot], -1)) * 0.015)
	}
	// load players
	for cyc in 1..=optPlayLim do pChar[cyc] = 0
	no_plays = 0
	for char in 1..=no_chars {
		if charLocation[char] == gamLocation[slot] && no_plays < optPlayLim {
			no_plays += 1
			pChar[no_plays] = char
		}
	}
	LoadPlayers()
	// load weapons
	Loader("Please Wait", "Loading Weapons")
	if gamLocation[slot] == 10 do PrepareCreations()
	LoadWeapons()
	LoadBullets()
	// assign weapons to characters
	for cyc in 1..=no_plays {
		if charWeapon[pChar[cyc]] > 0 do AttainWeapon(cyc, charWeapon[pChar[cyc]])
	}
	// load particles
	if optFX > 0 {
		Loader("Please Wait", "Loading Effects")
		no_particles = 500 
		if optFX == 1 do no_particles /= 2
		LoadParticles()
	}
	// load pools
	if optGore >= 2 {
		no_pools = 50 
		if optFX <= 1 do no_pools /= 2
		LoadPools()
	}
	// fading in/out
	fader = bb.CreateSprite()
	bb.ScaleSprite(fader, 20.0, 20.0)
	bb.SpriteViewMode(fader, 1)
	fadeAlpha = 0.0
	fadeTarget = 0.0
	bb.EntityAlpha(fader, fadeAlpha)
	bb.EntityColor(fader, 0.0, 0.0, 0.0)
	// reset status
	gamPause = 0
	gamDoor = 0
	gamPromo = 0
	promoTim = 0
	if GetBlock(gamLocation[slot]) > 0 do gamEscape[slot] = 0
	gamSpeed[slot] = 1
	// enable collisions
	bb.UpdateWorld()
	SetCollisions()
	// frame rating
	bb.SeedRnd(bb.MilliSecs())
	Loader("Please Wait", "Finalizing World")
	timer = bb.CreateTimer(30)
	// MAIN LOOP
	zoom := 1.0
	go = 0
	gotim = -50
	keytim = 20
	for go == 0 {

		bb.Cls()
		frames := bb.WaitTimer(timer)
		for _ in 1..=frames {
			
			// COUNTERS
			keytim -= 1
			if keytim < 1 do keytim = 0
			// stat highlighters
			if gotim > 0 && gamPromo == 0 {
				for count in 1..=10 {
					if statTim[count] < 0 do statTim[count] += 1
					if statTim[count] > 0 do statTim[count] -= 1
				}
			}
			
			// PORTAL
			gotim += 1
			if gotim == 0 do ProduceSound(cam, sDoor[3], 22050, 1)
			if gotim > 40 && keytim == 0 {
				if cast(bool)bb.KeyDown(1) && pAnim[gamPlayer[slot]] < 20 && gamPromo == 0 do go = -1
			}
			
			// THEME FADING
			if gotim > 0 {
				musicVol -= 0.0025
				if musicVol <= 0.0 {
					if bb.ChannelPlaying(chTheme) > 0 do bb.StopChannel(chTheme)
					musicVol = 0.0
				}
				if bb.ChannelPlaying(chTheme) > 0 do bb.ChannelVolume(chTheme, musicVol)
			}
			
			// FIDDLES
			if gotim > 40 && keytim == 0 {
				// decrease attributes
				if cast(bool)bb.KeyDown(12) {
					if cast(bool)bb.KeyDown(18) { pHealth[gamPlayer[slot]] -= 1; bb.PlaySound(sMenuBrowse); keytim = 3 }
					if cast(bool)bb.KeyDown(35) { charHappiness[gamChar[slot]] -= 1; bb.PlaySound(sMenuBrowse); keytim = 3 }
					if cast(bool)bb.KeyDown(31) { charStrength[gamChar[slot]] -= 1; bb.PlaySound(sMenuBrowse); keytim = 3 }
					if cast(bool)bb.KeyDown(30) { charAgility[gamChar[slot]] -= 1; bb.PlaySound(sMenuBrowse); keytim = 3 }
					if cast(bool)bb.KeyDown(23) { charIntelligence[gamChar[slot]] -= 1; bb.PlaySound(sMenuBrowse); keytim = 3 }
					if cast(bool)bb.KeyDown(19) { charReputation[gamChar[slot]] -= 1; bb.PlaySound(sMenuBrowse); keytim = 3 }
					if cast(bool)bb.KeyDown(50) { gamMoney[slot] -= 10; bb.PlaySound(sMenuBrowse); keytim = 5 }
					if cast(bool)bb.KeyDown(207) { charSentence[gamChar[slot]] -= 1; bb.PlaySound(sMenuBrowse); keytim = 5 }
				}
				// increase attributes
				if cast(bool)bb.KeyDown(13) {
					if cast(bool)bb.KeyDown(18) { pHealth[gamPlayer[slot]] += 1; bb.PlaySound(sMenuBrowse); keytim = 3 }
					if cast(bool)bb.KeyDown(35) { charHappiness[gamChar[slot]] += 1; bb.PlaySound(sMenuBrowse); keytim = 3 }
					if cast(bool)bb.KeyDown(31) { charStrength[gamChar[slot]] += 1; bb.PlaySound(sMenuBrowse); keytim = 3 }
					if cast(bool)bb.KeyDown(30) { charAgility[gamChar[slot]] += 1; bb.PlaySound(sMenuBrowse); keytim = 3 }
					if cast(bool)bb.KeyDown(23) { charIntelligence[gamChar[slot]] += 1; bb.PlaySound(sMenuBrowse); keytim = 3 }
					if cast(bool)bb.KeyDown(19) { charReputation[gamChar[slot]] += 1; bb.PlaySound(sMenuBrowse); keytim = 3 }
					if cast(bool)bb.KeyDown(50) { gamMoney[slot] += 10; bb.PlaySound(sMenuBrowse); keytim = 5 }
					if cast(bool)bb.KeyDown(207) { charSentence[gamChar[slot]] += 1; bb.PlaySound(sMenuBrowse); keytim = 5 }
				}
				// switch control
				if cast(bool)bb.KeyDown(56) && cast(bool)bb.KeyDown(15) && gamPromo == 0 {
					v := gamPlayer[slot]
					for {
						v += 1
						satisfied := 1
						if v > no_plays do v = 1
						if pHealth[v] <= 0 do satisfied = 0
						if satisfied == 1 || v == gamPlayer[slot] do break
					}
					if v != gamPlayer[slot] {
						bb.PlaySound(sMenuSelect); keytim = 10
						temp := pControl[v]
						pControl[v] = pControl[gamPlayer[slot]]
						pControl[gamPlayer[slot]] = temp
						camFoc = v
						gamPlayer[slot] = v
						gamChar[slot] = pChar[v]
					}
				}
			}
			
			// ppppppppppppppppppppppp PAUSE LOOP pppppppppppppppppppppppppppppppp
			// pause toggle
			if cast(bool)bb.KeyDown(25) && gotim > 20 && keytim == 0 {
				bb.PlaySound(sMenuSelect); keytim = 20
				gamPause = 0 if gamPause == 1 else 1
			}
			// pause loop
			if gamPause == 0 {
			
				// PROMOS
				if gamPromo == 0 do promoTim -= 1
				if promoTim < 0 do promoTim = 0
				if gamPromo > 0 {
					// timer
					if promoStage != 1 do promoTim += 1
					if promoTim > 50 && promoStage != 1 && keytim == 0 {
						if cast(bool)bb.KeyDown(1) || cast(bool)bb.KeyDown(28) || cast(bool)ButtonPressed() || cast(bool)ActionPressed(gamPlayer[slot]) { promoTim += 100; keytim = 10 }
					}
					// options
					if promoStage == 1 && keytim == 0 {
						if cast(bool)bb.KeyDown(200) || bb.JoyYDir() == -1 {
							foc -= 1
							bb.PlaySound(sMenuSelect)
							keytim = 6
						}
						if cast(bool)bb.KeyDown(208) || bb.JoyYDir() == 1 {
							foc += 1
							bb.PlaySound(sMenuSelect)
							keytim = 6
						}
						if foc < 1 do foc = 1
						if foc > 2 do foc = 2
						if charBreakdown[gamChar[slot]] > 0 do foc = 2
						// confirm
						if cast(bool)bb.KeyDown(28) || cast(bool)ButtonPressed() {
							bb.PlaySound(sMenuGo)
							keytim = 10
							if foc == 1 {
								promoStage = 2
								promoTim = 300
							}
							if foc == 2 {
								promoStage = 3
								promoTim = 300
							}
						}
						// cancel
						if cast(bool)bb.KeyDown(1) || charBreakdown[gamChar[slot]] > 0 {
							bb.PlaySound(sMenuBack)
							keytim = 10
							promoStage = 3
							promoTim = 300
						}
						// prepare return camera
						if promoStage != 1 {
							if promoActor[1] > 0 {
								if pChar[promoActor[1]] == gamChar[slot] do camFoc = promoActor[2]
							}
							if promoActor[2] != 0 {
								if pChar[promoActor[2]] == gamChar[slot] do camFoc = promoActor[1]
							}
						}
						// animated effects
						cyc := promoActor[1]
						v := promoActor[2]
						if cyc > 0 && v > 0 {
							if (gamPromo == 1 || gamPromo == 18 || gamPromo == 53 || gamPromo == 72) && promoStage == 2 do ChangeAnim(v, 21) // drop weapon
							if gamPromo == 7 && promoStage == 2 && pSeat[v] > 0 do ChangeAnim(v, 101) // vacate seat
							if (gamPromo == 8 || gamPromo == 11) && promoStage == 2 && pBed[v] > 0 do ChangeAnim(v, 101) // vacate bed
							if (gamPromo == 16 || gamPromo == 17 || gamPromo == 48) && promoStage == 2 { ChangeAnim(v, 25); ChangeAnim(cyc, 26) } // hand over item
							if (gamPromo == 49 || gamPromo == 50) && promoStage == 2 { ChangeAnim(cyc, 25); ChangeAnim(v, 26) } // acquire item
						}
					}
				}
				// announcements
				if gamPromo == 0 && promoTim == 0 && pAnim[gamPlayer[slot]] != 76 && pAnim[gamPlayer[slot]] != 77 {
					if gotim == 20 && gamWarrant[slot] > 0 && promoUsed[120+gamWarrant[slot]] == 0 do TriggerPromo(0, 0, 120+gamWarrant[slot])
					if gotim > 50 && gamWarrant[slot] == 0 {
						if gamFatality[slot] > 0 && gamPromo == 0 do TriggerPromo(0, 0, 31) // fatality
						if gamArrival[slot] > 0 && gamPromo == 0 do TriggerPromo(0, 0, 30) // arrival
						if gamRelease[slot] > 0 && gamPromo == 0 do TriggerPromo(0, 0, 32) // release
						if gamGrowth[slot] < -1 && gamPromo == 0 do TriggerPromo(gamPlayer[slot], 0, 61) // lost weight
						if gamGrowth[slot] > 1 && gamPromo == 0 do TriggerPromo(gamPlayer[slot], 0, 62) // gained weight
						randy := bb.RndI(0, 100000)
						if randy == 0 && gamBlackout[slot] == 0 && gamPromo == 0 && promoUsed[206] == 0 do TriggerPromo(0, 0, 206) // power failure!
						if randy == 1 && gamBombThreat[slot] == 0 && gamPromo == 0 && promoUsed[207] == 0 do TriggerPromo(0, 0, 207) // bomb threat!
						if randy == 2 && pInjured[gamPlayer[slot]] == 0 && gamPromo == 0 && promoUsed[252] == 0 { // sudden illness
							ProduceSound(p[gamPlayer[slot]], sChoke, 22050, 0.5) 
							TriggerPromo(gamPlayer[slot], 0, 252)
						}
						// corrupt warden
						randy = bb.RndI(0, 1000000)
						if randy <= no_chars && gamPromo == 0 && promoUsed[251] == 0 {
							if charRole[randy] == 1 && charLocation[randy] > 0 && charSnapped[randy] > 0 {
								ProduceSound(bb.FindChild(world, "Tanoy01"), sTanoy, 22050, 1)
								promoVariable = randy; TriggerPromo(0, 0, 251)
							}
						}
					}
				}
				// mission issues
				CheckMissions()
				// clock usage
				for count in 1..=no_promos {
					if promoUsed[count] >= 1 {
						promoUsed[count] += 1
						if count >= 98 && count <= 100 do promoUsed[count] += 1
					}
					if promoUsed[count] > 6000 do promoUsed[count] = 0
				}

				// PLAYERS
				PlayerCycle()
				DisplayPlayers()
				// preserve old positions
				for cyc in 1..=no_plays {
					pOldX[cyc] = pX[cyc]
					pOldY[cyc] = pY[cyc]
					pOldZ[cyc] = pZ[cyc]
					LimitStats(pChar[cyc])
				} 

				// WEAPONS
				WeaponCycle()
				BulletCycle()
				
				// PARTICLE EFFECTS
				if optFX > 0 {
					// particles
					ParticleCycle()
					// explosions
					ExplosionCycle()
				}
				// pools
				if optGore >= 2 {
					PoolCycle()
				}
			
				// LOCATION NOVELTIES
				// video screens
				if gamLocation[slot] == 9 {
					randy := bb.RndI(0, 100)
					if randy <= 1 do wScreen = bb.RndI(-5, 10)
					if wScreen < 0 do wScreen = 0
					if wScreen != wOldScreen {
						bb.EntityTexture(bb.FindChild(world, "TV"), tScreen[wScreen])
						wOldScreen = wScreen
					}
					randy = bb.RndI(0, 2)
					if randy == 0 && wScreen == 0 do bb.PositionTexture(tScreen[0], 1, bb.RndF(0.0, 2.0))
				}
				// food trays
				if gamLocation[slot] == 8 {
					for tray in 1..=no_chairs {
						if bb.FindChild(world, fmt.tprint("Tray", Dig(tray, 10))) > 0 && trayState[tray] >= 0 && trayState[tray] != trayOldState[tray] {
							bb.EntityTexture(bb.FindChild(world, fmt.tprint("Tray", Dig(tray, 10))), tTray[trayState[tray]])
							trayOldState[tray] = trayState[tray]
						}
					}
				} 
				// phone calls
				if gotim > 0 && gamLocation[slot] == 9 {
					if phoneRing == 0 {
						randy := bb.RndI(0, 10000)
						if phonePromo > 0 do randy = bb.RndI(1, 4)
						if randy >= 1 && randy <= 4 {
							if PhoneTaken(randy) == 0 && LockDown() == 0 {
								phoneRing = randy; phoneTim = bb.RndI(250, 1000)
								if phonePromo == 0 do GetPhonePromo()
								bb.LoopSound(sRing)
								chPhone = bb.EmitSound(sRing, bb.FindChild(world, fmt.tprint("Phone", Dig(phoneRing, 10))))  
							}
						}
					}
					if phoneRing > 0 {
						randy := bb.RndI(0, 1)
						if randy == 0 do bb.PositionEntity(bb.FindChild(world, fmt.tprint("Phone", Dig(phoneRing, 10))), phoneX[phoneRing], phoneY[phoneRing] + bb.RndF(-0.35, 0.35), phoneZ[phoneRing] + bb.RndF(-0.15, 0.15))
						if randy == 1 {
							bb.EntityColor(bb.FindChild(world, fmt.tprint("Alarm", Dig(phoneRing, 10))), bb.RndI(0, 255), 0, 0)
						} else {
							bb.EntityColor(bb.FindChild(world, fmt.tprint("Alarm", Dig(phoneRing, 10))), 5, 0, 0)
						}
						bb.EntityFX(bb.FindChild(world, fmt.tprint("Alarm", Dig(phoneRing, 10))), 9)
						phoneTim -= 1
						if phonePromo >= 172 && phonePromo <= 173 && phoneTim < 1 do phoneTim = 1
						if phoneTim < 0 || go != 0 {
							bb.PositionEntity(bb.FindChild(world, fmt.tprint("Phone", Dig(phoneRing, 10))), phoneX[phoneRing], phoneY[phoneRing], phoneZ[phoneRing])
							bb.EntityColor(bb.FindChild(world, fmt.tprint("Alarm", Dig(phoneRing, 10))), 5, 0, 0) 
							bb.EntityFX(bb.FindChild(world, fmt.tprint("Alarm", Dig(phoneRing, 10))), 0)
							bb.StopChannel(chPhone)
							phoneRing = 0
							phoneTim = 0
							if phonePromo != 172 && phonePromo != 173 do phonePromo = 0
						}
					}
				}
				// showers
				if gamLocation[slot] == 11 {
					shower: f32
					shower += 0.2
					bb.PositionTexture(tShower, 0, shower)
					CreateParticle(75 + bb.RndF(-15, 15), 11, 50 + bb.RndF(-15, 15), 6)
					CreateParticle(120 + bb.RndF(-15, 15), 11, 50 + bb.RndF(-15, 15), 6)
				}
				// bomb threat
				gamBombThreat[slot] -= 1
				if gamBombThreat[slot] < 0 do gamBombThreat[slot] = 0
				// b=gamBombThreat(slot)
				// if b==200 || b==190 || b==180 || b==170 || b==160 || b==150 || b==140 || b==130 || b==120 || b==110 || b==100 || b==90 || b==80 || b==70 || b==60 || b==50 || b==40 || b==30 || b==20 || b==10
				randy := bb.RndI(0, 30)
				if randy <= 1 && gamBombThreat[slot] >= 1 && gamBombThreat[slot] <= 300 {
					if GetBlock(gamLocation[slot]) > 0 do CreateExplosion(0, 0, bb.RndF(-295, 295), 15, bb.RndF(-340, 360), 10)
					if gamLocation[slot] == 2 do CreateExplosion(0, 0, bb.RndF(-15, 475), 15, bb.RndF(-50, 485), 10)
					if gamLocation[slot] == 4 do CreateExplosion(0, 0, bb.RndF(-140, 140), 15, bb.RndF(-140, 140), 10)
					if gamLocation[slot] == 6 do CreateExplosion(0, 0, bb.RndF(-140, 140), 15, bb.RndF(-140, 140), 10)
					if gamLocation[slot] == 8 do CreateExplosion(0, 0, bb.RndF(-260, 260), 15, bb.RndF(-350, 335), 10)
					if gamLocation[slot] == 9 do CreateExplosion(0, 0, bb.RndF(-290, 290), 15, bb.RndF(-290, 290), 10)
					if gamLocation[slot] == 10 do CreateExplosion(0, 0, bb.RndF(-95, 95), 15, bb.RndF(-115, 115), 10)
					if gamLocation[slot] == 11 do CreateExplosion(0, 0, bb.RndF(-140, 140), 15, bb.RndF(-70, 70), 10)
				}
				// sound alarm
				if gotim == 0 && gamWarrant[slot] > 0 {
					bb.LoopSound(sAlarm)
					chAlarm = bb.EmitSound(sAlarm, bb.FindChild(world, "Tanoy01"))
				}

				// ATMOSPHERE
				ManageAtmos()

				// CAMERA
				Camera() 
				// if bb.KeyDown(12) do zoom -= 0.01
				// if bb.KeyDown(13) do zoom += 0.01
				// bb.CameraZoom(cam, zoom)

				// ppppppppppppppppppppp END OF PAUSE LOOP pppppppppppppppppppppppp
			}

			if gamPause == 0 do bb.UpdateWorld()

			// OVERRIDE ANIMATION
			for cyc in 1..=no_plays {
				// point body
				if cast(bool)BodyViable(cyc) {
					if pFoc[cyc] > 0 do PointBody(cyc, pLimb[pFoc[cyc]][3])
				}
				// point head
				if cast(bool)HeadViable(cyc) {
					if pFoc[cyc] > 0 do PointHead(cyc, pLimb[pFoc[cyc]][1])
					if (cyc != promoActor[1] && cyc != promoActor[2]) || (cyc == promoActor[1] && promoActor[2] == 0) {
						if gamLocation[slot] == 9 && pSeat[cyc] >= 1 && pSeat[cyc] <= 6 do PointHead(cyc, bb.FindChild(world, "TV"))
						if cast(bool)OnComputer(cyc) do PointHead(cyc, bb.FindChild(world, "Screen"))
						if cast(bool)NearBasket(cyc) && cast(bool)Isolated(cyc, 30) do PointHead(cyc, bb.FindChild(world, "Rim"))
						if gamPromo > 0 && camFoc == 0 do PointHead(cyc, bb.FindChild(world, "Tanoy01"))
					}
				}
				// move correction 
				pCollisions[cyc] = bb.CountCollisions(pMovePivot[cyc])
				if pCollisions[cyc] > 0 {
					if pGrappler[cyc] > 0 || (pGrappling[cyc] > 0 && pAnim[cyc] >= 213) {
						shiftX: f32
						shiftZ: f32
						if bb.EntityX(pLimb[cyc][30], 1) > pOldMoveX[cyc] {
							shiftX = -1
						} else {
							shiftX = 1
						}
						if bb.EntityZ(pLimb[cyc][30], 1) > pOldMoveZ[cyc] {
							shiftZ = -1
						} else {
							shiftZ = 1
						}
						bb.PositionEntity(pPivot[cyc], bb.EntityX(pPivot[cyc]) + shiftX, bb.EntityY(pPivot[cyc]), bb.EntityZ(pPivot[cyc]) + shiftZ)
						if pGrappling[cyc] > 0 {
							v := pGrappling[cyc]
							bb.PositionEntity(pPivot[v], bb.EntityX(pPivot[v]) + shiftX, bb.EntityY(pPivot[v]), bb.EntityZ(pPivot[v]) + shiftZ)
						}
						if pGrappler[cyc] > 0 {
							v := pGrappler[cyc]
							bb.PositionEntity(pPivot[v], bb.EntityX(pPivot[v]) + shiftX, bb.EntityY(pPivot[v]), bb.EntityZ(pPivot[v]) + shiftZ)
						}
					}
				}
			}

		}
		bb.RenderWorld(1)

		// DISPLAY
		// DrawImage gLogo[3], i32(bb.rX(180)), i32(bb.rY(560))
		// status
		show := 1
		if gamPromo > 0 do show = 0
		if pAnim[gamPlayer[slot]] >= 76 && pAnim[gamPlayer[slot]] <= 77 && pAnimTim[gamPlayer[slot]] > 150 do show = 0
		if show == 1 {
			DisplayStatus(gamChar[slot], 72, 42)
			DisplayTime(727, 30)
			if cast(bool)OnComputer(gamPlayer[slot]) && pAnim[gamPlayer[slot]] == 102 \
			&& pState[gamPlayer[slot]] == 109 && pAnimTim[gamPlayer[slot]] > 10 {
				DisplayFile(gamFile, 100, 530)
			}
		}
		// diagnostics
		/*
		if bb.KeyDown(56) {
			bb.SetFont(fontNumber)
			Outline(fmt.tprint("Zoom: ", zoom), 100, 150, 0, 0, 0, 255, 255, 255)
			Outline(fmt.tprint("X: ", pX[camFoc]), 100, 150, 0, 0, 0, 255, 255, 255)
			Outline(fmt.tprint("Y: ", pY[camFoc]), 100, 165, 0, 0, 0, 255, 255, 255)
			Outline(fmt.tprint("Z: ", pZ[camFoc]), 100, 180, 0, 0, 0, 255, 255, 255) 
			Outline(fmt.tprint("A: ", pA[camFoc]), 100, 195, 0, 0, 0, 255, 255, 255)
			weaps := 0
			vices := 0
			for cyc in 1..=no_weaps {
				if weapState[cyc] > 0 && weapLocation[cyc] > 0 {
					weaps += 1
					if weapType[cyc] >= 16 && weapType[cyc] <= 18 do vices += 1
				}
			}
			Outline(fmt.tprint("Weapons: ", weaps, "/", no_weaps), 100, 250, 0, 0, 0, 255, 255, 255) 
			Outline(fmt.tprint("Vices: ", vices, "/", no_weaps), 100, 265, 0, 0, 0, 255, 255, 255) 
		}
		*/
		// display promo
		for cyc in 1..=no_plays {
			ResetExpressions(cyc)
		}
		if gamPromo > 0 {
			DisplayPromo()
		}
		// paused state
		if gamPause == 1 {
			DrawOption(-1, rX(400), rY(300), "PAUSED", "")
			bb.SetFont(font[1])
			Outline("(Press 'P' to resume play)", i32(rX(400)), i32(rY(300)) + 30, 0, 0, 0, 255, 255, 255)
		}
		// mask shaky start
		if gotim <= 0 do Loader("Please Wait", "Finalizing World")

		bb.Flip()
		// screenshot (F12)
		if cast(bool)bb.KeyHit(88) do Screenshot()
		// save preview shot
		if go == -1 {
			gamPhoto[slot] = bb.CreateImage(bb.GraphicsWidth(), bb.GraphicsHeight())
			bb.GrabImage(gamPhoto[slot], bb.GraphicsWidth() / 2, bb.GraphicsHeight() / 2)
		}

	} // Wend
	// restore sound
	if charHealth[gamChar[slot]] > 0 do Loader("Please Wait", "Restoring Sound")
	if bb.ChannelPlaying(chAtmos) > 0 do bb.StopChannel(chAtmos)
	if bb.ChannelPlaying(chAlarm) > 0 do bb.StopChannel(chAlarm)
	if bb.ChannelPlaying(chPhone) > 0 do bb.StopChannel(chPhone)
	bb.FreeEntity(camListener)
	// restore music
	if go == -1 || go == 3 || charHealth[gamChar[slot]] <= 0 {
		if bb.ChannelPlaying(chTheme) == 0 {
			bb.LoopSound(sTheme)
			chTheme = bb.PlaySound(sTheme)
		}
		musicVol = 1.0
		bb.ChannelVolume(chTheme, musicVol)
	}
	// remove world
	if charHealth[gamChar[slot]] > 0 do Loader("Please Wait", fmt.tprint("Leaving ", textLocation[oldLocation]))
	bb.FreeTimer(timer)
	bb.FreeEntity(fader)
	bb.FreeEntity(world)
	// remove camera
	if charHealth[gamChar[slot]] > 0 do Loader("Please Wait", "Removing Camera")
	bb.FreeEntity(cam)
	bb.FreeEntity(camPivot)
	bb.FreeEntity(dummy)
	// remove lights
	for cyc in 1..=no_lights {
		if charHealth[gamChar[slot]] > 0 do Loader("Please Wait", "Removing Lights") 
		bb.FreeEntity(light[cyc])
	}
	// remove players
	for cyc in 1..=no_plays {
		if charHealth[gamChar[slot]] > 0 do Loader("Please Wait", "Removing Players") 
		bb.FreeEntity(p[cyc])
		bb.FreeEntity(pPivot[cyc])
		bb.FreeEntity(pMovePivot[cyc]) 
		for limb in 1..=40 {
			if pShadow[cyc][limb] > 0 {
				bb.FreeEntity(pShadow[cyc][limb])
			}
		}
	}
	// remove weapons
	if no_weaps > 0 {
		for cyc in 1..=no_weaps {
			if charHealth[gamChar[slot]] > 0 do Loader("Please Wait", "Removing Weapons") 
			if weapLocation[cyc] == gamLocation[slot] {
				if weapState[cyc] == 0 do weapLocation[cyc] = 0
				bb.FreeEntity(weap[cyc])
				bb.FreeEntity(weapGround[cyc])
				bb.FreeEntity(weapWall[cyc]) 
			}
		}
	}
	// remove kits
	if gamLocation[slot] == 10 {
		for cyc in 1..=6 {
			bb.FreeEntity(kit[cyc])
		}
	}
	// remove bullets
	for cyc in 1..=no_bullets {
		bb.FreeEntity(bullet[cyc])
	}
	// remove particles
	if optFX > 0 {
		if charHealth[gamChar[slot]] > 0 do Loader("Please Wait", "Removing Effects")
		for cyc in 1..=no_particles {
			bb.FreeEntity(part[cyc])
		}
	}
	// remove pools
	if optGore >= 2 {
		if charHealth[gamChar[slot]] > 0 do Loader("Please Wait", "Removing Effects")
		for cyc in 1..=no_pools {
			bb.FreeEntity(pool[cyc])
		}
	}
	// clear collisions
	bb.ClearCollisions()
	// remove unused promos
	if charHealth[gamChar[slot]] > 0 do Loader("Please Wait", "Saving Progress")
	if go >= 1 do RevisePromos()
	// preserve locations
	if cast(bool)LockDown() {
		if GetBlock(gamLocation[slot]) == charBlock[gamChar[slot]] do gamEscape[slot] = 1 // left block
		if gamLocation[slot] == 9 && GetBlock(charLocation[gamChar[slot]]) == 0 do gamEscape[slot] = 1 // avoided block
	}
	gamLocation[slot] = charLocation[gamChar[slot]]
	for cyc in 1..=no_plays {
		if pChar[cyc] != gamChar[slot] || go == -1 {
			if pSeat[cyc] > 0 {
				pX[cyc] = pLeaveX[cyc]
				pZ[cyc] = pLeaveZ[cyc]
				pY[cyc] = pLeaveY[cyc]
				pA[cyc] = pLeaveA[cyc]
			}
			charX[pChar[cyc]] = pX[cyc];
			charZ[pChar[cyc]] = pZ[cyc]
			charY[pChar[cyc]] = pY[cyc];
			charA[pChar[cyc]] = pA[cyc]
		}
		if pHealth[cyc] <= 0 && charLocation[pChar[cyc]] > 0 && pChar[cyc] != gamChar[slot] {
			if charAttacker[pChar[cyc]] == gamChar[slot] && charWitness[gamChar[slot]] > 0 && charHealth[charWitness[gamChar[slot]]] > 0 {
				if gamWarrant[slot] < 12 {
					gamWarrant[slot] = bb.RndI(12, 13)
					gamVictim[slot] = pChar[cyc]
				}
			}
			RuinMission(pChar[cyc])
			charLocation[pChar[cyc]] = 0
			gamFatality[slot] = pChar[cyc]
			for v in 1..=no_chars {
				if v != gamChar[slot] && charPromo[v][gamChar[slot]] == 0 && charRelation[v][gamChar[slot]] >= 0 && charAngerTim[v][gamChar[slot]] == 0 {
					if charRelation[gamChar[slot]][pChar[cyc]] > 0 && charRelation[v][pChar[cyc]] > 0 {
						charPromo[v][gamChar[slot]] = 217; charPromoRef[v] = pChar[cyc]
					}
					if charRelation[gamChar[slot]][pChar[cyc]] < 0 && charRelation[v][pChar[cyc]] < 0 {
						charPromo[v][gamChar[slot]] = 218; charPromoRef[v] = pChar[cyc]
					}
				}
			}
		}
		charHealth[pChar[cyc]] = pHealth[cyc]
		charHP[pChar[cyc]] = pHP[cyc]
		charInjured[pChar[cyc]] = pInjured[cyc]
		charWeapon[pChar[cyc]] = pWeapon[cyc]
		if pWeapon[cyc] > 0 do weapLocation[pWeapon[cyc]] = charLocation[pChar[cyc]]
		for limb in 1..=40 {
			charScar[pChar[cyc]][limb] = pScar[cyc][limb]
		}
	}
	// body growth
	if gamGrowth[slot] == -1 && charModel[gamChar[slot]] > 1 {
		charModel[gamChar[slot]] -= 1
		gamGrowth[slot] = -2
	}
	if gamGrowth[slot] == 1 && charModel[gamChar[slot]] < 5 {
		charModel[gamChar[slot]] += 1
		gamGrowth[slot] = 2
	}
	// relocate CPU's
	if go >= 1 do RelocateChars()
	// prepare camera
	if go >= 1 {
		if GetBlock(gamLocation[slot]) > 0 {
			camX = -100
			camY = 50
			camZ = -200
		}
		if gamLocation[slot] == 2 {
			camX = 0
			camY = 25
			camZ = 250
		}
		if gamLocation[slot] == 4 || gamLocation[slot] == 6 {
			camX = -80
			camY = 25
			camZ = -80
		}
		if gamLocation[slot] == 8 {
			camX = -80
			camY = 25
			camZ = -260
		}
		if gamLocation[slot] == 9 {
			camX = 0
			camY = 75
			camZ = 0
		}
		if gamLocation[slot] == 10 {
			camX = -60
			camY = 40
			camZ = -50
		}
		if gamLocation[slot] == 11 {
			camX = 0
			camY = 25
			camZ = 0
		}
		camPivX = camX
		camPivY = camY
		camPivZ = camZ
	}
	// regenerate weapons
	if go >= 1 {
		for cyc in 1..=no_weaps {
			randy := bb.RndI(0, 50)
			if weapLocation[cyc] == 0 || weapState[cyc] == 0 do randy = bb.RndI(0, 25)
			if randy == 0 && cyc != gamItem[slot] && cyc != gamTarget[slot] \
			&& FindCarrier(cyc) == 0 && InsideCell(weapX[cyc], weapY[cyc], weapZ[cyc]) == 0 {
				randy = bb.RndI(0, 1)
				if randy == 0 && weapType[cyc] >= 16 && weapType[cyc] <= 18 && weapState[cyc] == 0 {
					GenerateWeapon(cyc, weapType[cyc], 0, 0, 0, 0)
				} else {
					GenerateWeapon(cyc, 0, 0, 0, 0, 0)
				}
			}
			if randy <= 10 && weapAmmo[cyc] == 0 && FindCarrier(cyc) != gamChar[slot] do weapAmmo[cyc] = bb.RndI(10, 100)
		}
	}
	// save & exit
	if go == -1 {
		gamName[slot] = strings.clone(fmt.tprint(CellName(gamChar[slot], context.temp_allocator), ": ", charName[gamChar[slot]]))
		bb.ResizeImage(gamPhoto[slot], 150, 100)
		bb.SaveImage(gamPhoto[slot], fmt.tprint("Data/Slot0", slot, "/Photos/Game.bmp"))
		bb.MaskImage(gamPhoto[slot], 255, 0, 255)
		screen = 5
	}
	SaveProgress()
	SaveChars()
	SavePhotos()
	SaveItems()
	// proceed
	if go == 1 do screen = 50
	if go == 2 do screen = 52
	if go == 3 {
		screen = 53
		gamEnded = 1
	}
	if charHealth[gamChar[slot]] == 0 {
		gamEnded = 1
		gamName[slot] = ""
		screen = 6
	}
	mem.end_arena_temp_memory(checkpoint)
}


