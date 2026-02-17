package main
////////////////////////////////////////////////////////////////////////////////
//---------------------------- HARD TIME: WEAPONS ------------------------------
////////////////////////////////////////////////////////////////////////////////

import "core:fmt"
import bb "blitzbasic3d"

//-----------------------------------------------------------------
//////////////////////// LOAD WEAPONS /////////////////////////////
//----------------------------------------------------------------- 
LoadWeapons :: proc() {
	for cyc in 1..=no_weaps {
		if weapLocation[cyc] == gamLocation[slot] {
			// generate
			// Loader("Please Wait","Loading Weapon "+cyc+" of "+no_weaps)
			weap[cyc] = bb.LoadAnimMesh(fmt.tprint("Weapons/{}.3ds", weapFile[weapType[cyc]]))
			bb.ScaleEntity(weap[cyc], 0.4, 0.4, 0.4)
			if weapTex[weapType[cyc]] > 0 {
				for count in 1..=bb.CountChildren(weap[cyc]) {
					bb.EntityTexture(bb.GetChild(weap[cyc], count), weapTex[weapType[cyc]])
				}
			}
			if weapShiny[weapType[cyc]] > 0 {
				for count in 1..=bb.CountChildren(weap[cyc]) {
					bb.EntityShininess(bb.GetChild(weap[cyc], count), weapShiny[weapType[cyc]])
				}
			}
			if weapName[weapType[cyc]] == "Bottle" {
				bb.EntityAlpha(weap[cyc], 0.9)
			}
			// collision detection
			bb.EntityType(weap[cyc], 3, 0)
			bb.EntityRadius(weap[cyc], 4, 1)
			weapGround[cyc] = bb.CreatePivot()
			bb.EntityType(weapGround[cyc], 4, 0)
			bb.EntityRadius(weapGround[cyc], 4, 1)
			weapWall[cyc] = bb.CreatePivot()
			bb.EntityType(weapWall[cyc], 4, 0)
			bb.EntityRadius(weapWall[cyc], 4, 1)
			// location
			weapY[cyc] += 10
			bb.PositionEntity(weap[cyc], weapX[cyc], weapY[cyc], weapZ[cyc])
			bb.RotateEntity(weap[cyc], 0, weapA[cyc], 0)
			if weapState[cyc] == 0 do bb.HideEntity(weap[cyc])
			// reset status
			weapGravity[cyc] = -1.0
			weapFlight[cyc] = 0
			weapCarrier[cyc] = 0
			weapOldScar[cyc] = -1
		}
	}    
}

//-----------------------------------------------------------------
//////////////////////// WEAPON CYCLE /////////////////////////////
//-----------------------------------------------------------------
WeaponCycle :: proc() {
	for cyc in 1..=no_weaps {
		if weapLocation[cyc] == gamLocation[slot] && weapState[cyc] > 0 {
			//store old positions 
			weapOldX[cyc] = weapX[cyc]
			weapOldY[cyc] = weapY[cyc]
			weapOldZ[cyc] = weapZ[cyc]
			//honour collision detection 
			weapX[cyc] = bb.EntityX(weap[cyc])
			weapY[cyc] = bb.EntityY(weap[cyc])
			weapZ[cyc] = bb.EntityZ(weap[cyc])
			if weapCarrier[cyc] == 0 {
				//find baskets
				if gamLocation[slot] == 2 && weapThrower[cyc] > 0 {
					basket := bb.FindChild(world, "Rim")
					if weapX[cyc] > bb.EntityX(basket, 1) - 6 && weapX[cyc] < bb.EntityX(basket, 1) + 6 && weapZ[cyc] > bb.EntityZ(basket, 1) - 6 && weapZ[cyc] < bb.EntityZ(basket, 1) + 6 {
						if weapY[cyc] > bb.EntityY(basket, 1) - 8 && weapY[cyc] < bb.EntityY(basket, 1) - 2 && weapOldY[cyc] > bb.EntityY(basket, 1) - 2 {
							ProduceSound(weap[cyc], weapSound[weapType[cyc]], 22050, 0)
							ProduceSound(weap[cyc], sBasket, 22050, 0)
							CreateSpurt(bb.EntityX(basket, 1), bb.EntityY(basket, 1), bb.EntityZ(basket, 1), 3, 10, 5)
							charAgility[pChar[weapThrower[cyc]]] += bb.Rnd(0, 1)
							charHappiness[pChar[weapThrower[cyc]]] += bb.Rnd(1, 5)
							randy := bb.Rnd(0, 5)
							if randy == 0 do charReputation[pChar[weapThrower[cyc]]] += 1
							bb.PointEntity(weap[cyc], basket)
							weapFlightA[cyc] = bb.EntityYaw(weap[cyc], 1)
							if weapFlight[cyc] < 1.0 do weapFlight[cyc] = 1.0
							if weapGravity[cyc] < 0 do weapGravity[cyc] = 0
							weapThrower[cyc] = 0
						}
					}
				}
				//bounce on ground
				if weapY[cyc] < bb.EntityY(weapGround[cyc]) + 0.5 && weapGravity[cyc] < -(weapWeight[weapType[cyc]] * 5) {
					if weapY[cyc] > 0 do CreateSpurt(weapX[cyc], weapY[cyc], weapZ[cyc], 2, 5, 5)
					weapFlight[cyc] = weapFlight[cyc] - (weapFlight[cyc] / 6)
					if gotim > 0 do ProduceSound(weap[cyc], weapSound[weapType[cyc]], 22050, weapGravity[cyc] / 8)
					weapGravity[cyc] = MakePositive(weapGravity[cyc])
					weapGravity[cyc] -= (weapGravity[cyc] / 3)
					if weapGravity[cyc] < 0.25 || gotim < 0 do weapGravity[cyc] = 0
					if weapFlight[cyc] < weapGravity[cyc] / 5 do weapFlight[cyc] = weapGravity[cyc] / 5
					weapA[cyc] += bb.Rnd(-20.0, 20.0)
					if weapGravity[cyc] < 1.0 {
						for v in 1..=no_plays {
							weapSting[cyc][v] = 0
						}
					}
					for v in 1..=no_plays {
						if charRole[pChar[v]] == 1 && cast(bool)WeaponProximity(v, cyc, cast(i32)weapSize[weapType[cyc]] * 5) {
							pAgenda[v] = 1
							pExploreY[v] = pY[v]
							pExploreX[v] = weapX[cyc]
							pExploreZ[v] = weapZ[cyc]
							pSubX[v] = 9999
							pSubZ[v] = 9999
						}
					}
					ExplodeWeapon(cyc, 0)
				}
				//bounce off wall
				if weapFlight[cyc] > 0 && weapY[cyc] > bb.EntityY(weapGround[cyc]) + 0.5 {
					if weapX[cyc] > bb.EntityX(weapWall[cyc]) - 2.0 && weapX[cyc] < bb.EntityX(weapWall[cyc]) + 2.0 &&
					   weapY[cyc] > bb.EntityY(weapWall[cyc]) - 2.0 && weapY[cyc] < bb.EntityY(weapWall[cyc]) + 2.0 &&
					   weapZ[cyc] > bb.EntityZ(weapWall[cyc]) - 2.0 && weapZ[cyc] < bb.EntityZ(weapWall[cyc]) + 2.0 {
						if gotim > 0 do ProduceSound(weap[cyc], weapSound[weapType[cyc]], 22050, bb.Rnd(0.1, 0.3))
						CreateSpurt(weapX[cyc], weapY[cyc], weapZ[cyc], 1, 5, 5)
						weapGravity[cyc] = 1.0
						weapFlight[cyc] /= 4
						weapFlightA[cyc] += 180
						if gamLocation[slot] == 2 {
							basket := bb.FindChild(world, "Rim")
							if weapX[cyc] > bb.EntityX(basket, 1) - 100 && weapX[cyc] < bb.EntityX(basket, 1) + 100 &&
							   weapY[cyc] > bb.EntityY(basket, 1) - 20  && weapY[cyc] < bb.EntityY(basket, 1) + 30 &&
							   weapZ[cyc] > bb.EntityZ(basket, 1) - 100 && weapZ[cyc] < bb.EntityZ(basket, 1) + 100 {
								weapFlightA[cyc] += bb.Rnd(-90.0, 90.0)
							}
						}
						weapA[cyc] += bb.Rnd(-20.0, 20.0)
						ExplodeWeapon(cyc, 0)
					}
				}
				//bounce off humans
				if weapFlight[cyc] > 0 && weapY[cyc] > bb.EntityY(weapGround[cyc]) + 0.5 {
					for v in 1..=no_plays {
						range := weapSize[weapType[cyc]] - (weapSize[weapType[cyc]] / 3)
						if AttackViable(v) == 3 do range *= 2
						if cast(bool)WeaponProximity(v, cyc, cast(i32)range) && weapY[cyc] >= pY[v] + 5 && weapY[cyc] <= bb.EntityY(bb.FindChild(p[v], "Head"), 1) + 5 && AttackViable(v) > 0 && weapSting[cyc][v] == 1 {
							charAttacker[pChar[v]] = pChar[weapThrower[cyc]]
							blocked := 0
							if pAnim[v] >= 74 && pAnim[v] <= 75 && cast(bool)InLine(v, weap[cyc], 90) do blocked = 1
							ProduceSound(weap[cyc], weapSound[weapType[cyc]], 22050, 0)
							ExplodeWeapon(cyc, 0)
							if blocked == 0 {
								if pHealth[v] > 0 do ProduceSound(p[v], sPain[bb.Rnd(1, 8)], 22050, 0)
								CreateSpurt(pX[v], weapY[cyc] - 4, pZ[v], 2, 10, 99)
								ScarArea(v, weapX[cyc], weapY[cyc], weapZ[cyc], 5)
								if CountScars(v) >= 2 do ScarWeapon(cyc, 0)
								pHealth[v] -= cast(f32)bb.Rnd(1, weapDamage[weapType[cyc]])
								pHP[v] -= bb.Rnd(1, weapDamage[weapType[cyc]])
								pHurtA[v] = weapFlightA[cyc]
								pStagger[v] = 0.5
								if AttackViable(v) >= 1 && AttackViable(v) <= 2 {
									if weapY[cyc] >= pY[v] + 20 do ChangeAnim(v, 70)
									if weapY[cyc] < pY[v] + 20 do ChangeAnim(v, 71)
									randy := bb.Rnd(0, 3)
									if randy == 0 && weapY[cyc] >= pY[v] + 20 do pDazed[v] = bb.Rnd(50, 200)
								}
								if AttackViable(v) == 3 {
									GroundReaction(v)
									pDT[v] = pDT[v] - 10
								}
							}
							if blocked == 1 {
								CreateSpurt(pX[v], weapY[cyc] - 4, pZ[v], 2, 5, 4)
								if pWeapon[v] > 0 {
									ProduceSound(p[v], weapSound[weapType[pWeapon[v]]], 22050, 0)
									DropWeapon(v, 10)
								}
							}
							weapFlightA[cyc] += 180
							weapA[cyc] += bb.Rnd(-50.0, 50.0)
							weapGravity[cyc] = 1.0
							weapFlight[cyc] /= 4
							if weapFlight[cyc] > 1.0 do weapFlight[cyc] = 1.0
							if weapStyle[weapType[cyc]] == 7 && blocked == 0 {
								ProduceSound(weap[cyc], sStab, 22050, 1)
								weapGravity[cyc] = 0
								weapFlight[cyc] = 0
								if weapName[weapType[cyc]] == "Syringe" && pInjured[v] < 100 do pInjured[v] = bb.Rnd(100, 500)
							}
							RiskAnger(weapThrower[cyc], v)
							DamageRep(weapThrower[cyc], v, 1)
							weapSting[cyc][v] = 0
						}
					}
				}
				//flight
				weapFlight[cyc] = weapFlight[cyc] - 0.02
				if weapFlight[cyc] < 0 do weapFlight[cyc] = 0
				if weapFlight[cyc] > 0 {
					if weapStyle[weapType[cyc]] != 7 do weapA[cyc] += weapFlight[cyc]
					bb.RotateEntity(weap[cyc], 0, weapFlightA[cyc], 0)
					bb.MoveEntity(weap[cyc], 0, 0, weapFlight[cyc])
					if weapFlight[cyc] > 0.5 {
						randy := bb.Rnd(0, 5)
						if randy <= 0 && weapY[cyc] < 0 do CreateParticle(weapX[cyc], weapY[cyc], weapZ[cyc], 6)
						randy = bb.Rnd(0, 60)
						if randy <= weapScar[cyc] && weapScar[cyc] > 1 do CreatePool(weapX[cyc], weapY[cyc], weapZ[cyc], bb.Rnd(0.5, 2.0), 1, 1)
					}
				}
				bb.RotateEntity(weap[cyc], 0, weapA[cyc], 0)
				//gravity
				if weapY[cyc] == weapOldY[cyc] && weapGravity[cyc] < 0 do weapGravity[cyc] = 0
				if weapGravity[cyc] > -8 do weapGravity[cyc] -= weapWeight[weapType[cyc]]
				bb.MoveEntity(weap[cyc], 0, weapGravity[cyc], 0)
				if gotim < 0 do bb.MoveEntity(weap[cyc], 0, -1.0, 0)
				//identify ground
				bb.ResetEntity(weapGround[cyc])
				bb.PositionEntity(weapGround[cyc], weapX[cyc], weapY[cyc] + 5, weapZ[cyc])
				bb.RotateEntity(weapGround[cyc], 0, weapA[cyc], 0)
				bb.EntityType(weapGround[cyc], 4, 0)
				bb.EntityRadius(weapGround[cyc], 4, 1)
				bb.MoveEntity(weapGround[cyc], 0, -500, 0)
				//identify walls
				bb.ResetEntity(weapWall[cyc])
				bb.PositionEntity(weapWall[cyc], weapX[cyc], weapY[cyc], weapZ[cyc])
				bb.RotateEntity(weapWall[cyc], 0, weapFlightA[cyc], 0)
				bb.EntityType(weapWall[cyc], 4, 0)
				bb.EntityRadius(weapWall[cyc], 4, 1)
				bb.MoveEntity(weapWall[cyc], 0, 0, 500)
			}
			//follow carrier
			v := weapCarrier[cyc]
			if v > 0 {
				bb.ResetEntity(weap[cyc])
				limb: i32
				if weapStyle[weapType[cyc]] == 2 {
					limb = pLimb[v][6]
				} else {
					limb = pLimb[v][19]
				}
				if bb.EntityY(limb, 1) > pY[v] + 10 {
					bb.PositionEntity(weap[cyc], bb.EntityX(limb, 1), bb.EntityY(limb, 1), bb.EntityZ(limb, 1))
				} else {
					bb.PositionEntity(weap[cyc], bb.EntityX(limb, 1), pY[v] + 10, bb.EntityZ(limb, 1))
				}
				weapA[cyc] = bb.EntityYaw(bb.FindChild(p[v], weapFile[weapType[cyc]]), 1)
				bb.EntityType(weap[cyc], 3, 0)
				bb.EntityRadius(weap[cyc], 4, 1)
			}
			//scarring
			ManageWeaponScars(cyc)
		}
	}
}

//-----------------------------------------------------------------
/////////////////////////// BULLETS ///////////////////////////////
//-----------------------------------------------------------------

LoadBullets :: proc() {
	for cyc in 1..=no_bullets {
		bullet[cyc] = bb.CreatePivot()
		bb.EntityType(bullet[cyc], 4, 0)
		bb.EntityRadius(bullet[cyc], 1, 1)
		bb.HideEntity(bullet[cyc])
		bulletState[cyc] = 0
	}
}

FireBullet :: proc(cyc: i32) {
	//decrement ammo
	weapAmmo[pWeapon[cyc]] -= 1
	if weapAmmo[pWeapon[cyc]] < 0 do weapAmmo[pWeapon[cyc]] = 0
	weapClip[pWeapon[cyc]] -= 1
	if weapClip[pWeapon[cyc]] < 0 do weapClip[pWeapon[cyc]] = 0
	//find slot
	v: i32 = 0
	for count in i32(1)..=no_bullets {
		if bulletState[count] == 0 do v = count
	}
	if v == 0 do v = bb.Rnd(1, no_bullets)
	//initiate bullet
	if weapStyle[weapType[pWeapon[cyc]]] == 3 {
		limb := bb.FindChild(p[cyc], "FlameB")
		bb.PositionEntity(bullet[v], bb.EntityX(limb, 1), bb.EntityY(limb, 1), bb.EntityZ(limb, 1))
		bulletXA[v] = -bb.EntityPitch(limb, 1)
		bulletYA[v] = bb.EntityYaw(limb, 1) + 90
		bulletZA[v] = bb.EntityRoll(limb, 1)
	}
	if weapStyle[weapType[pWeapon[cyc]]] == 4 {
		limb := bb.FindChild(p[cyc], "FlameA")
		bb.PositionEntity(bullet[v], bb.EntityX(limb, 1), bb.EntityY(limb, 1), bb.EntityZ(limb, 1))
		bulletXA[v] = bb.EntityPitch(limb, 1)
		bulletYA[v] = bb.EntityYaw(limb, 1) + 90
		bulletZA[v] = bb.EntityRoll(limb, 1)
	}
	bulletShooter[v] = cyc
	bulletState[v] = 1
	bulletTim[v] = 0
	bb.ShowEntity(bullet[v])
	//alert guards
	charReputation[pChar[cyc]] += bb.Rnd(0, 1)
	for count in 1..=no_plays {
		if charRole[pChar[count]] == 1 {
			if pWeapFoc[count] != pWeapon[cyc] {
				pSubX[count] = 9999
				pSubZ[count] = 9999
			}
			pAgenda[count] = 4
			pWeapFoc[count] = pWeapon[cyc]
		}
	}
}

BulletCycle :: proc() {
	for cyc in 1..=no_bullets {
		if bulletState[cyc] == 1 {
			for _ in 1..=10 {
				//honour collision detection 
				bulletX[cyc] = bb.EntityX(bullet[cyc])
				bulletY[cyc] = bb.EntityY(bullet[cyc])
				bulletZ[cyc] = bb.EntityZ(bullet[cyc])
				//flight
				bb.RotateEntity(bullet[cyc], bulletXA[cyc], bulletYA[cyc], bulletZA[cyc])
				bb.MoveEntity(bullet[cyc], 0, 0, 10)
				//scenery contact
				if bulletState[cyc] == 1 {
					for count in 1..=bb.CountCollisions(bullet[cyc]) {
						if bb.CollisionEntity(bullet[cyc], count) > 0 {
							ProduceSound(bullet[cyc], sRicochet[bb.Rnd(1, 3)], 22050, 0)
							ProduceSound(bullet[cyc], sImpact[bb.Rnd(4, 5)], 22050, 0)
							CreateSpurt(bulletX[cyc], bulletY[cyc] - 5, bulletZ[cyc], 0, 5, 4)
							bulletState[cyc] = 0
							bb.HideEntity(bullet[cyc])
						}
					}
				}
				//human contact
				for v in 1..=no_plays {
					range: f32 = 10
					if AttackViable(v) == 3 do range = 20
					if bulletX[cyc] > pX[v] - range && bulletX[cyc] < pX[v] + range && bulletZ[cyc] > pZ[v] - range && bulletZ[cyc] < pZ[v] + range && bulletY[cyc] >= pY[v] && bulletY[cyc] <= bb.EntityY(bb.FindChild(p[v], "Head"), 1) + 5 {
						if AttackViable(v) > 0 && bulletState[cyc] == 1 {
							charAttacker[pChar[v]] = pChar[bulletShooter[cyc]]
							ProduceSound(p[v], sImpact[bb.Rnd(4, 5)], 22050, 0)
							ProduceSound(p[v], sStab, 22050, 0)
							if pHealth[v] > 0 do ProduceSound(p[v], sPain[bb.Rnd(1, 8)], 22050, 0)
							CreateSpurt(pX[v], bulletY[cyc] - 5, pZ[v], 0, 5, 99)
							ScarArea(v, bulletX[cyc], bulletY[cyc] - 5, bulletZ[cyc], 2)
							CreatePool(bulletX[cyc], pGround[v], bulletZ[cyc], bb.Rnd(2.0, 8.0), 1, 1)
							if AttackViable(v) >= 1 && AttackViable(v) <= 2 {
								if bulletY[cyc] >= pY[v] + 20 && pAnim[v] != 70 do ChangeAnim(v, 70)
								if bulletY[cyc] < pY[v] + 20 && pAnim[v] != 71 do ChangeAnim(v, 71)
								pDT[v] = i32((150 - pHealth[v]) * 2)
							}
							if AttackViable(v) == 3 && pAnim[v] != 72 && pAnim[v] != 73 {
								GroundReaction(v)
								pDT[v] = pDT[v] - 10
							}
							pHealth[v] -= bb.Rnd(1.0, 5.0)
							pHP[v] -= bb.Rnd(1, 5)
							pHurtA[v] = bulletYA[cyc]
							pStagger[v] = 0.6
							RiskAnger(bulletShooter[cyc], v)
							DamageRep(bulletShooter[cyc], v, 0)
							bulletState[cyc] = 0
							bb.HideEntity(bullet[cyc])
						}
					}
				}
			}
			// range limit
			bulletTim[cyc] += 1
			if bulletTim[cyc] > 5 {
				bulletState[cyc] = 0
				bb.HideEntity(bullet[cyc])
			}
		}
	}
}

//--------------------------------------------------------------
//////////////////// RELATED FUNCTIONS /////////////////////////
//--------------------------------------------------------------
PrepareWeapons :: proc() {
	for cyc in 1..=6{
		if kitState[cyc] > 0 {
			if weapCreate[kitType[cyc]] > 0 {
				//find slot
				newbie: i32 = 0
				for v in 1..=no_weaps {
					if weapLocation[v] == 0 || (weapState[v] == 0 && weapLocation[v] != gamLocation[slot]) {
						newbie = v
						break
					}
				}
				//force slot
				if newbie == 0 {
					for {
						newbie = bb.Rnd(0, no_weaps)
						if FindCarrier(newbie) == 0 && weapLocation[newbie] != gamLocation[slot] {
							break
						}
					}
				}
				//fill slot
				if newbie > 0 {
					weapLocation[newbie] = gamLocation[slot]
					weapType[newbie] = kitType[cyc]
					weapState[newbie] = 0
				}
			}
		}
	}
}

CreateWeapon :: proc(weapon: i32, x, y, z: f32) {
	//find slot
	cyc: i32 = 0
	for v in 1..=no_weaps {
		if weapType[v] == weapon && weapLocation[v] == gamLocation[slot] && weapState[v] == 0 {
			cyc = v
		}
	}
	//force slot
	if cyc == 0 {
		for v in 1..=no_weaps {
			if weapType[v] == weapon && weapLocation[v] == gamLocation[slot] {
				cyc = v
			}
		}
	}
	//fill slot
	if cyc > 0 {
		ProduceSound(cam, sSwing, 22050, 0.5)
		CreateSpurt(x, y, z, 3, 10, 4)
		bb.ResetEntity(weap[cyc])
		weapX[cyc] = x
		weapY[cyc] = y
		weapZ[cyc] = z
		bb.PositionEntity(weap[cyc], weapX[cyc], weapY[cyc], weapZ[cyc])
		bb.EntityType(weap[cyc], 3, 0)
		bb.EntityRadius(weap[cyc], 4, 1)
		weapA[cyc] = bb.Rnd(0.0, 360.0)
		weapFlightA[cyc] = weapA[cyc]
		weapGravity[cyc] = weapWeight[weapType[cyc]] * 5
		weapFlight[cyc] = 0
		weapScar[cyc] = 0
		weapOldScar[cyc] = -1
		weapAmmo[cyc] = 100
		weapClip[cyc] = 10
		if weapStyle[weapType[cyc]] == 6 do weapClip[cyc] = 0
		if weapCarrier[cyc] > 0 {
			pWeapon[weapCarrier[cyc]] = 0
			weapCarrier[cyc] = 0
		}
		bb.ShowEntity(weap[cyc])
		weapState[cyc] = 1
		for v in 1..=no_plays {
			weapSting[cyc][v] = 0
		}
	}
}

FindCarrier :: proc(cyc: i32) -> i32 {
	value: i32 = 0
	if cyc > 0 {
		for v in 1..=no_chars {
			if charWeapon[pChar[v]] == cyc do value = v
		}
	}
	return value
}

AttainWeapon :: proc(cyc, v: i32) {
	// bind to player
	pWeapon[cyc] = v
	weapCarrier[v] = cyc
	// texturing issues
	if weapTex[weapType[v]] > 0 {
		bb.EntityTexture(bb.FindChild(p[cyc], weapFile[weapType[v]]), weapTex[weapType[v]])
	}
	bb.EntityShininess(bb.FindChild(p[cyc], weapFile[weapType[v]]), weapShiny[weapType[v]])
	// switch display
	bb.ShowEntity(bb.FindChild(p[cyc], weapFile[weapType[v]]))
	bb.HideEntity(weap[v])
	weapOldScar[v] = -1
}

DropWeapon :: proc(cyc, chance: i32) {
	v: i32 = pWeapon[cyc]
	randy: i32 = bb.Rnd(0, chance)
	if randy == 0 && v > 0 {
		ProduceSound(p[cyc], sShuffle[bb.Rnd(1, 3)], 44100, 0.5)
		if weapY[v] < pY[cyc] + 10 do weapY[v] = pY[cyc] + 10
		if pAnim[cyc] == 83 && pAnimTim[cyc] > 10 {
			weapFlightA[v] = pA[cyc] + 135
		} else {
			weapFlightA[v] = pA[cyc] + 315
		}
		if weapStyle[weapType[v]] == 2 {
			if pAnim[cyc] == 83 && pAnimTim[cyc] > 10 {
				weapFlightA[v] = pA[cyc] + 270
			} else {
				weapFlightA[v] = pA[cyc] + 45
			}
		}
		weapGravity[v] = 1.0
		weapFlight[v] = 0.5
		weapCarrier[v] = 0
		pWeapon[cyc] = 0
		bb.HideEntity(bb.FindChild(p[cyc], weapFile[weapType[v]]))
		bb.ShowEntity(weap[v])
		weapOldScar[v] = -1
		for count in 1..=no_plays {
			weapSting[v][count] = 0
		}
	}
}

ThrowWeapon :: proc(cyc: i32) {
	v: i32 = pWeapon[cyc]
	if v > 0 {
		// reset state
		weapFlightA[v] = pA[cyc]
		weapFlight[v] = 1.5 + weapGravity[v]
		if weapStyle[weapType[v]] == 7 && pAnim[cyc] != 27 {
			weapFlight[v] += (weapFlight[v] / 4)
			weapGravity[v] -= (weapGravity[v] / 3)
			weapA[v] = pA[cyc] + 180
		}
		if pAnim[cyc] == 27 {
			weapFlight[v] /= 2
			if weapGravity[v] > weapWeight[weapType[v]] * 20 do weapGravity[v] = weapWeight[weapType[v]] * 20
		}
		weapThrower[v] = cyc
		weapCarrier[v] = 0
		pWeapon[cyc] = 0
		bb.HideEntity(bb.FindChild(p[cyc], weapFile[weapType[v]]))
		bb.ShowEntity(weap[v])
		weapOldScar[v] = -1
		// make potent
		for count in 1..=no_plays {
			weapSting[v][count] = 1
		}
		weapSting[v][cyc] = 0
		if weapStyle[weapType[v]] == 6 do weapClip[v] = 1
	}
}

ScarWeapon :: proc(cyc, chance: i32) {
	randy: i32 = bb.Rnd(0, chance)
	if randy == 0 do weapScar[cyc] += 1
	if weapScar[cyc] > 4 do weapScar[cyc] = 4
}

ManageWeaponScars :: proc(cyc: i32) {
	if weapCarrier[cyc] == gamLocation[weapCarrier[cyc]] {
		// heal scars
		randy: i32 = bb.Rnd(0, 10000 / gamSpeed[gamLocation[weapCarrier[cyc]]])
		if randy == 0 do weapScar[cyc] -= 1
		if randy <= 10 && weapScar[cyc] > 1 && weapY[cyc] < 0 {
			weapScar[cyc] -= 1
			CreateParticle(weapX[cyc], weapY[cyc], weapZ[cyc], 3)
		}
		if weapScar[cyc] < 0 do weapScar[cyc] = 0
		// prevent gore
		if optGore == 0 && weapScar[cyc] > 1 do weapScar[cyc] = 1
		// apply scars
		if weapScar[cyc] != weapOldScar[cyc] {
			for limb in 1..=bb.CountChildren(weap[cyc]) {
				bb.EntityTexture(bb.GetChild(weap[cyc], limb), tBodyScar[weapScar[cyc]], 0, 2)
			}
			if weapCarrier[cyc] > 0 {
				limb: i32 = bb.FindChild(p[weapCarrier[cyc]], weapFile[weapType[cyc]])
				bb.EntityTexture(limb, tBodyScar[weapScar[cyc]], 0, 2)
			}
			weapOldScar[cyc] = weapScar[cyc]
		}
	}
}

NearestWeapon :: proc(cyc: i32) -> i32 {
	value: i32 = 0
	hi: f32 = 9999
	if no_weaps > 0 {
		for v in 1..=no_weaps {
			if weapLocation[v] == gamLocation[slot] {
				distance := GetDistance(pX[cyc], pZ[cyc], weapX[v], weapZ[v])
				if weapCarrier[v] > 0 do distance = distance * 2
				if weapY[v] < pY[cyc] - 30 || weapY[v] > pY[cyc] + 30 do distance = distance * 2
				if distance < hi && pWeaponTim[cyc][v] == 0 && weapState[v] == 1 {
					value = v
					hi = distance
				}
			}
		}
	}
	return value
}

WeaponProximity :: proc(cyc, v, range: i32) -> i32 {
	value: i32 = 0
	if weapLocation[v] == gamLocation[slot] && weapState[v] == 1 && pY[cyc] > weapY[v] - 30 && pY[cyc] < weapY[v] + 30 {
		checkX := pX[cyc]
		checkZ := pZ[cyc]
		if pGrappling[cyc] > 0 || pGrappler[cyc] > 0 {
			checkX = bb.EntityX(pLimb[cyc][30], 1)
			checkZ = bb.EntityZ(pLimb[cyc][30], 1)
		}
		if checkX > weapX[v]-cast(f32)range && checkX < weapX[v]+cast(f32)range && checkZ > weapZ[v]-cast(f32)range && checkZ < weapZ[v]+cast(f32)range {
			value = 1
		}
	}
	return value
}

WeaponImpact :: proc(cyc, v, blocked: i32) {
	w := pWeapon[cyc]
	if w > 0 {
		// effect
		ProduceSound(p[cyc], weapSound[weapType[w]], 22050, 0)
		if weapStyle[weapType[w]] == 7 {
			ProduceSound(p[v], sStab, 22050, 0)
		}
		if weapDamage[weapType[w]] > 1 {
			ScarArea(v, pX[v], bb.EntityY(pLimb[cyc][19], 1), pZ[v], 2)
		}
		charReputation[pChar[cyc]] += bb.Rnd(0, 1 + charRole[pChar[v]])
		charHappiness[pChar[v]] -= 1
		// damage
		if blocked == 1 {
			pHealth[v] -= 1
			pHP[v] -= 1
		} else {
			pHealth[v] -= bb.Rnd(1.0, f32(weapDamage[weapType[w]]))
			if pAnim[cyc] != 211 {
				pHP[v] -= bb.Rnd(1, weapDamage[weapType[w]])
			}
			pDT[v] += weapDamage[weapType[w]] * 10
			if weapName[weapType[w]] == "Syringe" && pInjured[v] < 100 {
				pInjured[v] = bb.Rnd(100, 500)
			}
		}
	}
}

FindSmashes :: proc(cyc: i32) {
	// weapon contact
	for v in 1..=no_weaps {
		range := weapSize[weapType[v]] + (weapSize[weapType[v]] / 2)
		if weapLocation[v] == gamLocation[slot] && weapState[v] == 1 && cast(bool)WeaponProximity(cyc, v, cast(i32)range) && pY[cyc] > weapY[v]-5 && weapCarrier[v] == 0 {
			ProduceSound(p[cyc], sPain[bb.Rnd(1, 8)], 22050, 0)
			ProduceSound(weap[v], weapSound[weapType[v]], 22050, 0)
			if weapStyle[weapType[v]] == 7 do ProduceSound(p[cyc], sStab, 22050, 1)
			CreateSpurt(weapX[v], weapY[v], weapZ[v], 3, 10, 99)
			ScarArea(cyc, weapX[v], pY[cyc], weapZ[v], 5)
			if CountScars(cyc) >= 2 {
				ScarWeapon(v, 1)
				CreatePool(weapX[v], pGround[cyc], weapZ[v], bb.Rnd(3.0, 10.0), 2, 1)
			}
			if weapStyle[weapType[v]] != 6 {
				bb.Animate(weap[v], 3, 2.0, 0, 1)
			}
			weapA[v] += bb.Rnd(-30.0, 30.0)
			weapX[v] += bb.Rnd(-2.0, 2.0)
			weapZ[v] += bb.Rnd(-2.0, 2.0)
			pHealth[cyc] -= cast(f32)bb.Rnd(1, weapDamage[weapType[v]])
			pDT[cyc] += 10 * weapDamage[weapType[v]]
			charHappiness[pChar[cyc]] -= 1
			charReputation[pChar[cyc]] -= 1
			RiskInjury(cyc, 100)
			weapThrower[v] = 0
			ExplodeWeapon(v, -1)
			if weapName[weapType[v]] == "Syringe" && pInjured[cyc] < 100 {
				pInjured[cyc] = bb.Rnd(100, 500)
			}
		}
	}
	// human contact
	for v in 1..=no_plays {
		if cast(bool)InProximity(cyc, v, 20) && AttackViable(v) == 3 {
			ProduceSound(p[cyc], sPain[bb.Rnd(1, 8)], 22050, 0)
			ProduceSound(p[v], sPain[bb.Rnd(1, 8)], 22050, 0)
			ProduceSound(p[v], sImpact[6], 22050, 0)
			CreateSpurt(pX[cyc], pY[v], pZ[cyc], 3, 10, 99)
			ScarArea(cyc, pX[cyc], pY[v], pZ[cyc], 10)
			ScarArea(v, pX[cyc], pY[v], pZ[cyc], 10)
			if AttackViable(v) == 3 do GroundReaction(v)
			pHealth[cyc] -= 1
			pHP[cyc] = 0
			RiskInjury(cyc, 200)
			pHealth[v] -= 1
			pHP[v] = 0
			RiskInjury(v, 200)
			charHappiness[pChar[cyc]] -= 1
			charReputation[pChar[cyc]] -= 1
			charHappiness[pChar[v]] -= 1
			charReputation[pChar[v]] -= 1
		}
	}
}

ExplodeWeapon :: proc(cyc, chance: i32) {
	randy := bb.Rnd(0, chance)
	if randy == 0 && weapStyle[weapType[cyc]] == 6 && (weapClip[cyc] > 0 || chance < 0) {
		if weapType[cyc] == 9 do CreateExplosion(weapThrower[cyc], weap[cyc], weapX[cyc], weapY[cyc], weapZ[cyc], 10)
		if weapType[cyc] == 19 do CreateExplosion(weapThrower[cyc], weap[cyc], weapX[cyc], weapY[cyc], weapZ[cyc], 11)
		if weapType[cyc] == 18 do CreateExplosion(weapThrower[cyc], weap[cyc], weapX[cyc], weapY[cyc], weapZ[cyc], 13)
		weapState[cyc] = 0
		bb.HideEntity(weap[cyc])
	}
}

ExhaustDrug :: proc(cyc: i32) {
	w := pWeapon[cyc]
	randy := bb.Rnd(0, 3)
	if randy == 0 do weapAmmo[w] -= 1
	if w > 0 && weapAmmo[w] <= 0 {
		ProduceSound(p[cyc], sSwing, 22050, 0.3)
		limb := bb.FindChild(p[cyc], weapFile[weapType[w]])
		CreateSpurt(bb.EntityX(limb, 1), bb.EntityY(limb, 1), bb.EntityZ(limb, 1), 2, 10, 4)
		DropWeapon(cyc, 0)
		weapState[w] = 0
		bb.HideEntity(weap[w])
		ChangeAnim(cyc, 21)
	}
}
