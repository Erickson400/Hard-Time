package main

import bb "blitzbasic3d"

////////////////////////////////////////////////////////////////////////////////
//------------------------- HARD TIME: PARTICLE EFFECTS ------------------------
////////////////////////////////////////////////////////////////////////////////

//-----------------------------------------------------------------
///////////////////////// PARTICLE EFFECTS ////////////////////////
//-----------------------------------------------------------------

LoadParticles :: proc() {
	for cyc in 1..=no_particles {
		part[cyc] = bb.LoadSprite("World/Sprites/Particle.bmp", 0)
		bb.EntityFX(part[cyc], 9)
		partState[cyc] = 0
		bb.HideEntity(part[cyc])
	}
}

CreateParticle :: proc(x: f32, y: f32, z: f32, style: i32) {
	if optFX > 0 {
		// find empty spot
		cyc: i32 = 0
		for count in 1..=no_particles {
			if partState[count] == 0 do cyc = count
		}
		// force spot!
		if cyc == 0 do cyc = bb.RndI(1, no_particles)
		// activate new particle
		if cyc > 0 {
			partX[cyc] = x
			partY[cyc] = y
			partZ[cyc] = z
			partA[cyc] = bb.RndF(0.0, 360.0)
			partGravity[cyc] = bb.RndF(1.0, 2.0)
			partFlight[cyc] = 0.3
			partSize[cyc] = bb.RndF(1.0, 5.0)
			partAlpha[cyc] = bb.RndF(0.5, 0.9)
			partFade[cyc] = 0.02
			// unique traits
			partType[cyc] = style
			if partType[cyc] == 1 { // fire
				bb.EntityColor(part[cyc], 220, bb.RndI(0, 100), 0)
			}
			if partType[cyc] == 2 { // smoke
				randy: i32 = bb.RndI(0, 100)
				bb.EntityColor(part[cyc], randy, randy, randy)
				partSize[cyc] = bb.RndF(1.0, 3.0)
				partFlight[cyc] = 0.1
				partGravity[cyc] = 0.1
				partAlpha[cyc] = bb.RndF(0.4, 0.8)
				partFade[cyc] = 0.01
			}
			if partType[cyc] == 3 { // blood
				bb.EntityColor(part[cyc], bb.RndI(50, 200), 0, 0)
				partFlight[cyc] = 0.2 // : partSize[cyc]=RndF(2.0,6.0)
				partGravity[cyc] = bb.RndF(0.5, 1.0)
				partAlpha[cyc] = bb.RndF(0.7, 0.9)
				partFade[cyc] = 0.035
			}
			if partType[cyc] == 4 { // impact
				bb.EntityColor(part[cyc], bb.RndI(90, 110), bb.RndI(70, 90), bb.RndI(40, 60)) //250,RndI(100,200),0
				partFlight[cyc] = 0.15 // : partSize[cyc]=RndF(2.0,6.0)
				partGravity[cyc] = bb.RndF(0.5, 1.0)
				partAlpha[cyc] = bb.RndF(0.6, 0.8)
				partFade[cyc] = 0.035
			}
			if partType[cyc] == 5 { // dust
				bb.EntityColor(part[cyc], 100, 80, 50)
				partAlpha[cyc] = bb.RndF(0.2, 0.5)
				partSize[cyc] = bb.RndF(1.0, 3.0)
				partGravity[cyc] = 0.5
			}
			if partType[cyc] == 6 { // water
				bb.EntityColor(part[cyc], 40, 60, 80)
				partFlight[cyc] = 0.3
				partSize[cyc] = bb.RndF(2.0, 6.0)
				partGravity[cyc] = bb.RndF(0.0, 1.0)
				partAlpha[cyc] = bb.RndF(0.3, 0.7)
				partFade[cyc] = 0.02
			}
			if partType[cyc] == 7 { // small fire
				bb.EntityColor(part[cyc], 220, bb.RndI(0, 100), 0)
				partSize[cyc] = bb.RndF(0.1, 1.0)
				partGravity[cyc] = 0
				partFade[cyc] = 0.1
			}
			if partType[cyc] == 8 { // multi-coloured
				bb.EntityColor(part[cyc], bb.RndI(100, 250), bb.RndI(100, 250), bb.RndI(100, 250))
			}
			if partType[cyc] == 9 { // green mist
				bb.EntityColor(part[cyc], 0, bb.RndI(100, 180), 0)
				partGravity[cyc] = bb.RndF(0.75, 1.25)
				partFade[cyc] = 0.03
			}
			if partType[cyc] == 10 { // explosion (fire)
				bb.EntityColor(part[cyc], 220, bb.RndI(0, 100), 0)
				partSize[cyc] = bb.RndF(5.0, 10.0)
				partAlpha[cyc] = bb.RndF(0.8, 1.0)
			}
			if partType[cyc] == 11 { // explosion (foam)
				randy := bb.RndI(100, 200)
				bb.EntityColor(part[cyc], randy, randy, randy)
				partSize[cyc] = bb.RndF(5.0, 10.0)
				partAlpha[cyc] = bb.RndF(0.6, 0.8)
			}
			if partType[cyc] == 12 { // explosion (water)
				bb.EntityColor(part[cyc], 40, 80, 120)
				partSize[cyc] = bb.RndF(5.0, 10.0)
				partAlpha[cyc] = bb.RndF(0.7, 0.9)
			}
			if partType[cyc] == 13 { // explosion (beer)
				bb.EntityColor(part[cyc], bb.RndI(50, 150), 50, 0)
				partSize[cyc] = bb.RndF(5.0, 10.0)
				partAlpha[cyc] = bb.RndF(0.7, 0.9)
			}
			if partType[cyc] == 14 { // beer (small)
				bb.EntityColor(part[cyc], bb.RndI(50, 150), 50, 0)
				partSize[cyc] = bb.RndF(0.5, 2.0)
				partFlight[cyc] = 0
				partGravity[cyc] = 0
			}
			// reset & show
			partTim[cyc] = 0
			partState[cyc] = 1
			bb.ShowEntity(part[cyc])
			bb.PositionEntity(part[cyc], partX[cyc], partY[cyc], partZ[cyc])
			bb.RotateEntity(part[cyc], 0.0, partA[cyc], 0.0)
			bb.ScaleSprite(part[cyc], partSize[cyc], partSize[cyc])
			bb.EntityAlpha(part[cyc], partAlpha[cyc])
		}
	}
}

CreateSpurt :: proc(x, y, z, spread: f32, density, style: i32) {
	density := density
	if optFX > 0 {
		// reduce density
		if optFX <= 1 do density /= 2
		// deliver particles
		for _ in 1..=density {
			if style < 99 {
				CreateParticle(x + bb.RndF(-spread, spread), y + bb.RndF(-spread, spread), z + bb.RndF(-spread, spread), style)
			}
			if style == 99 {
				CreateParticle(x + bb.RndF(-spread, spread), y + bb.RndF(-spread, spread), z + bb.RndF(-spread, spread), 4)
				CreateParticle(x + bb.RndF(-spread, spread), y + bb.RndF(-spread, spread), z + bb.RndF(-spread, spread), 3)
			}
		}
	}
}

ParticleCycle :: proc() {
	for cyc in 1..=no_particles {
		if partState[cyc] > 0 {
			if partType[cyc] != 7 {
				// gravity
				if partGravity[cyc] > -3.0 do partGravity[cyc] -= 0.05
				if partType[cyc] == 2 && partGravity[cyc] < 0.1 do partGravity[cyc] = 0.1
				if partType[cyc] == 14 && partGravity[cyc] < -0.1 do partGravity[cyc] = -0.1
				partY[cyc] += partGravity[cyc]
				// flight
				bb.MoveEntity(part[cyc], 0.0, 0.0, partFlight[cyc])
				partX[cyc] = bb.EntityX(part[cyc])
				partZ[cyc] = bb.EntityZ(part[cyc])
			}
			// update properties
			bb.PositionEntity(part[cyc], partX[cyc], partY[cyc], partZ[cyc])
			bb.RotateEntity(part[cyc], 0.0, partA[cyc], 0.0)
			bb.ScaleSprite(part[cyc], partSize[cyc], partSize[cyc])
			// transparency
			partAlpha[cyc] -= partFade[cyc]
			bb.EntityAlpha(part[cyc], partAlpha[cyc])
			// clock
			partTim[cyc] += 1
			if partAlpha[cyc] <= 0.0 || partTim[cyc] > 1000 do partState[cyc] = 0
		}
		// remove
		if partState[cyc] == 0 do bb.HideEntity(part[cyc])
	}
}

//-----------------------------------------------------------------
/////////////////////////// EXPLOSIONS ////////////////////////////
//-----------------------------------------------------------------

CreateExplosion :: proc(source, entity: i32, x, y, z: f32, style: i32) {
	if optFX > 0 {
		// find empty slot
		cyc: i32 = 0
		for count in 1..=no_explodes {
			if exTim[count] == 0 do cyc = i32(count)
		}
		if cyc == 0 do cyc = bb.RndI(1, no_explodes)
		// initiate explosion
		if exType[cyc] >= 11 {
			ProduceSound(entity, sExplosion, 0, 0.5)
			ProduceSound(entity, sSplash, 22050, 0)
		} else {
			ProduceSound(entity, sExplosion, 0, 1.0)
		}
		exSource[cyc] = f32(source)
		exType[cyc] = style
		exTim[cyc] = 20
		exX[cyc] = x
		exY[cyc] = y
		exZ[cyc] = z
		for v in 1..=no_plays {
			exHurt[cyc][v] = 0
		}
		// alert guards
		for count in 1..=no_plays {
			if charRole[pChar[count]] == 1 {
				pAgenda[count] = 1
				pExploreX[count] = x
				pExploreY[count] = pY[count]
				pExploreZ[count] = z
				pSubX[count] = 9999.0
				pSubZ[count] = 9999.0
			}
		}
	}
}

ExplosionCycle :: proc() {
	for cyc in i32(1)..=no_explodes {
		if exTim[cyc] > 0 {
			// blaze
			if exTim[cyc] == 20 || exTim[cyc] == 15 || exTim[cyc] == 10 || exTim[cyc] == 5 {
				density: i32 = 25
				if optFX <= 1 do density = 12
				for _ in 1..=density {
					CreateParticle(exX[cyc] + bb.RndF(-15.0, 15.0), bb.RndF(exY[cyc] - 5.0, exY[cyc] + 10.0), exZ[cyc] + bb.RndF(-15.0, 15.0), exType[cyc])
				}
				density = 15
				if optFX <= 1 do density = 7
				for _ in 1..=density {
					CreateParticle(exX[cyc] + bb.RndF(-10.0, 10.0), bb.RndF(exY[cyc] - 5.0, exY[cyc] + 5.0), exZ[cyc] + bb.RndF(-10.0, 10.0), exType[cyc])
				}
				density = 5
				if optFX <= 1 do density = 2
				for _ in 1..=density {
					CreateParticle(exX[cyc] + bb.RndF(-5.0, 5.0), exY[cyc], exZ[cyc] + bb.RndF(-5.0, 5.0), exType[cyc])
				}
				density = 10
				if optFX <= 1 do density = 5
				for _ in 1..=density {
					CreateParticle(exX[cyc] + bb.RndF(-10.0, 10.0), bb.RndF(exY[cyc], exY[cyc] + 5.0), exZ[cyc] + bb.RndF(-10.0, 10.0), 2)
				}
			}
			// mess
			if exTim[cyc] == 10 && exType[cyc] >= 11 {
				CreatePool(exX[cyc], 12.0, exZ[cyc], bb.RndF(10.0, 15.0), 1, exType[cyc] - 9)
			}
			// human damage
			if exTim[cyc] >= 5 && exTim[cyc] <= 18 {
				for v in 1..=no_plays {
					if cast(bool)BlastProximity(cyc, pX[v], pY[v], pZ[v], 40.0) do pDazed[v] = bb.RndI(100, 300)
					if exHurt[cyc][v] == 0 && cast(bool)BlastProximity(cyc, pX[v], pY[v], pZ[v], 30.0) {
						charAttacker[pChar[v]] = pChar[i32(exSource[cyc])]
						if exType[cyc] == 10 {
							ProduceSound(p[v], sBlaze, 22050, 0.5)
							if pHealth[v] > 0 do ProduceSound(p[v], sPain[bb.RndI(1, 8)], 22050, 0)
							CreateSpurt(pX[v], bb.EntityY(pLimb[v][1], 1), pZ[v], 5.0, 10, 2)
							CreatePool(pX[v], pGround[v], pZ[v], bb.RndF(5.0, 10.0), 3, 1)
							ScarArea(v, 0, 0, 0, 1)
							RiskInjury(v, 25)
							pHealth[v] -= 10
						}
						pHealth[v] -= 10
						pHP[v] = 0
						if AttackViable(v) != 3 do pDT[v] = (150 - pHealth[v]) * 2
						if AttackViable(v) >= 1 && AttackViable(v) <= 2 do ChangeAnim(v, 70)
						if AttackViable(v) == 3 do GroundReaction(v)
						if cast(bool)BlastProximity(cyc, pX[v], pY[v], pZ[v], 15.0) {
							randy: i32 = bb.RndI(1, 3)
							if randy == 1 && pHealth[v] > 0 do ChangeAnim(v, 80)
							if randy == 2 && pHealth[v] > 0 do ChangeAnim(v, 83)
							if randy == 3 && pHealth[v] > 0 do ChangeAnim(v, 86)
							if exType[cyc] == 10 {
								ScarArea(v, 0, 0, 0, 1)
								RiskInjury(v, 25)
								pHealth[v] -= 10
							}
							if AttackViable(v) != 3 do pDT[v] = (200 - pHealth[v]) * 2
						}
						if exSource[cyc] > 0 {
							RiskAnger(i32(exSource[cyc]), v)
							DamageRep(i32(exSource[cyc]), v, 1)
							if exType[cyc] == 10 do DamageRep(i32(exSource[cyc]), v, 1)
							if i32(exSource[cyc]) == gamPlayer[slot] && gamMission[slot] != 11 && gamMission[slot] != 12 {
								for count in 1..=no_plays {
									if charRole[pChar[count]] == 1 && Friendly(count, gamPlayer[slot]) == 0 && charBribeTim[pChar[count]] == 0 && AttackViable(count) >= 1 && AttackViable(count) <= 2 {
										if cast(bool)InLine(count, p[gamPlayer[slot]], 60.0) || cast(bool)InLine(count, p[v], 60.0) {
											randy := bb.RndI(0, 20)
											if exType[cyc] == 10 do randy = bb.RndI(0, 5)
											if randy == 0 && gamWarrant[slot] < 4 {
												gamWarrant[slot] = 4
												gamItem[slot] = pWeapon[cyc] // prosecuted for carrying
											}
											if randy == 1 && gamWarrant[slot] < 10 {
												gamWarrant[slot] = 10
												gamItem[slot] = pWeapon[cyc] // prosecuted for assault
											}
										}
									}
								}
							}
						}
						exHurt[cyc][v] = 1
					}
				}
			}
			// expire
			exTim[cyc] -= 1
		}
	}
}

BlastProximity :: proc(cyc: i32, x, y, z, range: f32) -> i32 {
	value: i32 = 0
	if x > exX[cyc] - range && x < exX[cyc] + range && z > exZ[cyc] - range && z < exZ[cyc] + range && y > exY[cyc] - 50 && y < exY[cyc] + 50 {
		value = 1
	}
	return value
}

//-----------------------------------------------------------------
////////////////////////////// POOLS //////////////////////////////
//-----------------------------------------------------------------

LoadPools :: proc() {
	for cyc in 1..=no_pools {
		pool[cyc] = bb.LoadSprite("World/Sprites/Pool.png", 4)
		bb.SpriteViewMode(pool[cyc], 2)
		bb.HideEntity(pool[cyc])
		poolState[cyc] = 0
	}
}

CreatePool :: proc(x, y, z, size: f32, layers, style: i32) {
	if optGore >= 2 {
		for count in 1..=layers {
			// find empty spot
			cyc: i32 = 0
			for check in 1..=no_pools {
				if poolState[check] == 0 do cyc = check
			}
			// force spot!
			if cyc == 0 do cyc = bb.RndI(1, no_pools)
			// generate pool
			poolX[cyc] = x
			poolZ[cyc] = z
			if count > 1 {
				poolX[cyc] = x + f32(bb.RndI(-5, 5))
				poolZ[cyc] = z + f32(bb.RndI(-5, 5))
			}
			poolA[cyc] = bb.RndF(0.0, 360.0)
			poolY[cyc] = y
			poolSize[cyc] = size
			poolAlpha[cyc] = 0.7
			poolState[cyc] = 1
			bb.ShowEntity(pool[cyc])
			// colour variations
			poolType[cyc] = style
			if style == 1 do bb.EntityColor(pool[cyc], bb.RndI(150, 220), 0, 0) // blood
			if style == 2 do bb.EntityColor(pool[cyc], 255, 255, 255) // foam
			if style == 3 do bb.EntityColor(pool[cyc], 100, 200, 255) // water
			if style == 4 do bb.EntityColor(pool[cyc], 150, 50, 0) // beer
		}
	}
}

PoolCycle :: proc() {
	for cyc in 1..=no_pools {
		if poolState[cyc] == 1 {
			// location
			bb.PositionEntity(pool[cyc], poolX[cyc], poolY[cyc], poolZ[cyc])
			bb.RotateEntity(pool[cyc], 90.0, poolA[cyc], 0.0)
			// fade away
			poolAlpha[cyc] -= 0.0005
			if poolY[cyc] < 0 do poolAlpha[cyc] -= 0.001
			bb.EntityAlpha(pool[cyc], poolAlpha[cyc])
			// shrink away
			poolSize[cyc] -= 0.01
			if poolY[cyc] < 0 do poolSize[cyc] -= 0.01
			bb.ScaleSprite(pool[cyc], poolSize[cyc], poolSize[cyc])
			// remove
			if poolSize[cyc] < 0.5 || poolAlpha[cyc] < 0.01 {
				poolState[cyc] = 0
				bb.HideEntity(pool[cyc])
			}
		}
	}
}
