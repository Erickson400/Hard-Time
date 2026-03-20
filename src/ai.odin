package main

import bb "blitzbasic3d"
import "core:fmt"

////////////////////////////////////////////////////////////////////////////////
//--------------------- HARD TIME: ARTIFICIAL INTELLIGENCE ---------------------
////////////////////////////////////////////////////////////////////////////////

//----------------------------------------------------------------
///////////////////////// GET INPUT ////////////////////////////////
//----------------------------------------------------------------
GetInput :: proc(cyc: i32) {
	// reset commands
	cUp[cyc]	= 0
	cDown[cyc]	= 0
	cLeft[cyc]	= 0
	cRight[cyc] = 0
	cAttack[cyc]= 0
	cDefend[cyc]= 0
	cThrow[cyc] = 0
	cPickUp[cyc]= 0
	// get keyboard input
	if (pControl[cyc] == 1 || pControl[cyc] == 3) && charBreakdown[pChar[cyc]] == 0 {
		if cast(bool)bb.KeyDown(200) do cUp[cyc] = 1
		if cast(bool)bb.KeyDown(208) do cDown[cyc] = 1
		if cast(bool)bb.KeyDown(203) do cLeft[cyc] = 1
		if cast(bool)bb.KeyDown(205) do cRight[cyc] = 1
		if cast(bool)bb.KeyDown(keyAttack) do cAttack[cyc] = 1
		if cast(bool)bb.KeyDown(keyDefend) do cDefend[cyc] = 1
		if cast(bool)bb.KeyDown(keyThrow) do cThrow[cyc] = 1
		if cast(bool)bb.KeyDown(keyPickUp) do cPickUp[cyc] = 1
	}
	// get gamepad input
	if (pControl[cyc] == 2 || pControl[cyc] == 3) && charBreakdown[pChar[cyc]] == 0 {
		if bb.JoyYDir() == -1 do cUp[cyc] = 1
		if bb.JoyYDir() == 1 do cDown[cyc] = 1
		if bb.JoyXDir() == -1 do cLeft[cyc] = 1
		if bb.JoyXDir() == 1 do cRight[cyc] = 1
		if cast(bool)bb.JoyDown(buttAttack) do cAttack[cyc] = 1
		if cast(bool)bb.JoyDown(buttDefend) do cDefend[cyc] = 1
		if cast(bool)bb.JoyDown(buttThrow) do cThrow[cyc] = 1
		if cast(bool)bb.JoyDown(buttPickUp) do cPickUp[cyc] = 1
	}
	// get CPU input
	if pControl[cyc] == 0 || charBreakdown[pChar[cyc]] > 0 {
		AI(cyc)
	}
}


//----------------------------------------------------------------
///////////////// ARTIFICIAL INTELLIGENCE ////////////////////////
//----------------------------------------------------------------
AI :: proc(cyc: i32) {
	randy, its, satisfied, v, cell, current, target: i32
	alert:i32
	range, intensity: i32

	// DETERMINE AGENDA
	pOldAgenda[cyc] = pAgenda[cyc]
	if cyc != promoActor[1] && cyc != promoActor[2] {
		randy = bb.RndI(0, 1000)
		if randy == 0 { pAgenda[cyc] = 0 }
		if randy == 1 { pAgenda[cyc] = 1 }
		if randy == 2 || charPromo[pChar[cyc]][gamChar[slot]] > 0 \
		|| charFollowTim[pChar[cyc]] > 0 {
			pAgenda[cyc] = 2
			pFollowFoc[cyc] = 0
		}
		if randy == 3 || cast(bool)LockDown() {
			if charRole[pChar[cyc]] == 0 && GetBlock(gamLocation[slot]) > 0 \
			&& charFollowTim[pChar[cyc]] == 0 {
				pAgenda[cyc] = 3
			}
		}
		if randy == 4 || (randy == 5 && charRole[pChar[cyc]] == 1) {
			if pWeapon[cyc] == 0 {
				pAgenda[cyc] = 4
				pWeapFoc[cyc] = 0
			}
		}
	}
	// avoid conversation area
	if gamPromo > 0 && promoActor[1] > 0 && promoActor[2] > 0 \
	&& cyc != promoActor[1] && cyc != promoActor[2] {
		if pTX[cyc] > LowestValue(pX[promoActor[1]], pX[promoActor[2]]) \
		&& pTX[cyc] < HighestValue(pX[promoActor[1]], pX[promoActor[2]]) \
		&& pTZ[cyc] > LowestValue(pZ[promoActor[1]], pZ[promoActor[2]]) \
		&& pTZ[cyc] < HighestValue(pZ[promoActor[1]], pZ[promoActor[2]]) {
			pNowhere[cyc] = 99
		}
	}
	// rethink if getting nowhere
	if pNowhere[cyc] > 30 {
		if pSubX[cyc] == 9999 && pSubZ[cyc] == 9999 {
			pSubX[cyc] = pX[cyc] + bb.RndF(-200, 200)
			pSubZ[cyc] = pZ[cyc] + bb.RndF(-200, 200)
		} else {
			pSubX[cyc] = 9999
			pSubZ[cyc] = 9999
		}
		pAgenda[cyc] = 1
	}
	// EXECUTE AGENDA
	// contemplate
	if pAgenda[cyc] == 0 {
		randy = bb.RndI(0, 200)
		if randy <= 1 && pAnim[cyc] < 20 {
			for {
				pTA[cyc] = bb.RndF(0, 360)
				if SatisfiedAngle(pA[cyc], pTA[cyc], 10) == 0 do break
			}
		}
		pTX[cyc] = pX[cyc]
		pTY[cyc] = pY[cyc]
		pTZ[cyc] = pZ[cyc]
		pSubX[cyc] = 9999
		pSubZ[cyc] = 9999
		pExploreRange[cyc] = 5
	}
	// explore
	if pAgenda[cyc] == 1 {
		randy = bb.RndI(0, 500)
		if randy <= 1 || pNowhere[cyc] > 30 || pAgenda[cyc] != pOldAgenda[cyc] {
			if GetBlock(gamLocation[slot]) > 0 {
				pExploreX[cyc] = bb.RndF(-290.0, 290.0)
				pExploreY[cyc] = 10
				pExploreZ[cyc] = bb.RndF(-330.0, 350.0)
				randy = bb.RndI(0, 1)
				if randy == 0 {
					for {
						pExploreX[cyc] = bb.RndF(-290.0, 290.0)
						pExploreY[cyc] = 105
						pExploreZ[cyc] = bb.RndF(-140.0, 350.0)
						if pExploreX[cyc] < -150 || pExploreX[cyc] > 150 || pExploreZ[cyc] > 210 {
							break
						}
					}
				}
				if pExploreX[cyc] > -50 && pExploreX[cyc] < 50 \
				&& pExploreZ[cyc] > 20 && pExploreZ[cyc] < 210 {
					pExploreY[cyc] = 9999
				}
			}
			if gamLocation[slot] == 2 {
				for {
					pExploreX[cyc] = bb.RndF(-25.0, 485.0)
					pExploreY[cyc] = 10
					pExploreZ[cyc] = bb.RndF(-45.0, 490.0)
					if pExploreX[cyc] > 200 || pExploreZ[cyc] > 200 do break
				}
			}
			if gamLocation[slot] == 4 || gamLocation[slot] == 6 {
				pExploreX[cyc] = bb.RndF(-140.0, 140.0)
				pExploreY[cyc] = 10
				pExploreZ[cyc] = bb.RndF(-140.0, 140.0)
			}
			if gamLocation[slot] == 8 {
				pExploreX[cyc] = bb.RndF(-255.0, 255.0)
				pExploreY[cyc] = 10
				pExploreZ[cyc] = bb.RndF(-340.0, 330.0)
			}
			if gamLocation[slot] == 9 {
				pExploreX[cyc] = bb.RndF(-295.0, 295.0)
				pExploreY[cyc] = 10
				pExploreZ[cyc] = bb.RndF(-295.0, 295.0)
				randy = bb.RndI(0, 5)
				if randy == 0 || (randy == 1 && phoneRing > 0) {
					pExploreX[cyc] = bb.RndF(-295.0, -260.0)
					pExploreZ[cyc] = bb.RndF(-50.0, 70.0)
				}
			}
			if gamLocation[slot] == 10 {
				pExploreX[cyc] = bb.RndF(-95.0, 95.0)
				pExploreY[cyc] = 10
				pExploreZ[cyc] = bb.RndF(-115.0, 115.0)
			}
			if gamLocation[slot] == 11 {
				pExploreX[cyc] = bb.RndF(-140.0, 140.0)
				pExploreY[cyc] = 10
				pExploreZ[cyc] = bb.RndF(-65.0, 70.0)
			}
			pSubX[cyc] = 9999
			pSubZ[cyc] = 9999
			pNowhere[cyc] = 0
		}
		pTX[cyc] = pExploreX[cyc]
		pTY[cyc] = pExploreY[cyc]
		pTZ[cyc] = pExploreZ[cyc]
		pExploreRange[cyc] = 5
		if InsideCell(pX[cyc], pY[cyc], pZ[cyc]) == charCell[pChar[cyc]] \
		&& cast(bool)cellLocked[gamLocation[slot]][charCell[pChar[cyc]]] {
			pAgenda[cyc] = 3
		}
	}
	// follow
	if pAgenda[cyc] == 2 {
		if no_plays > 1 {
			alert = 0
			v = pFoc[gamPlayer[slot]]
			if v > 0 && v != cyc && (charAngerTim[pChar[cyc]][pChar[v]] > 0 \
			|| charAngerTim[pChar[v]][gamChar[slot]] > 0) {
				alert = 1
				if charAngerTim[pChar[cyc]][pChar[v]] < 10 {
					charAngerTim[pChar[cyc]][pChar[v]] = 10
				}
			}
			if charFollowTim[pChar[cyc]] > 0 && alert == 0 {
				pFollowFoc[cyc] = gamPlayer[slot]
			}
			if charFollowTim[pChar[cyc]] > 0 && alert == 1 {
				pFollowFoc[cyc] = pFoc[gamPlayer[slot]]
			}
			if charPromo[pChar[cyc]][gamChar[slot]] > 0 && gamPromo == 0 {
				pFollowFoc[cyc] = gamPlayer[slot]
			}
			for pFollowFoc[cyc] == 0 || pFollowFoc[cyc] == cyc {
				pFollowFoc[cyc] = bb.RndI(1, no_plays)
				randy = bb.RndI(0, 1)
				its = 0
				if randy == 0 {
					for Friendly(cyc, pFollowFoc[cyc]) == 0 && its < 100 {
						pFollowFoc[cyc] = bb.RndI(1, no_plays)
						its += 1
					}
				}
			}
			pTX[cyc] = pX[pFollowFoc[cyc]]
			pTY[cyc] = pY[pFollowFoc[cyc]]
			pTZ[cyc] = pZ[pFollowFoc[cyc]]
			if pOldAgenda[cyc] != 2 do pExploreRange[cyc] = bb.RndF(15.0, 50.0)
			if pExploreRange[cyc] < 10 do pExploreRange[cyc] = 10
			if charAngerTim[pChar[cyc]][pChar[pFollowFoc[cyc]]] > 0 do pExploreRange[cyc] = 10
		} else {
			pAgenda[cyc] = 1
		}
	}
	// enter cell
	if pAgenda[cyc] == 3 {
		randy = bb.RndI(0, 500)
		cell = charCell[pChar[cyc]]
		if randy <= 1 || pAgenda[cyc] != pOldAgenda[cyc] \
		|| InsideCell(pExploreX[cyc], pExploreY[cyc], pExploreZ[cyc]) != cell {
			pExploreX[cyc] = bb.RndF(cellX1[cell], cellX2[cell])
			pExploreY[cyc] = cellY1[cell] + 10
			pExploreZ[cyc] = bb.RndF(cellZ1[cell], cellZ2[cell])
			pSubX[cyc] = 9999
			pSubZ[cyc] = 9999
			pNowhere[cyc] = 0
		}
		pTX[cyc] = pExploreX[cyc]
		pTY[cyc] = pExploreY[cyc]
		pTZ[cyc] = pExploreZ[cyc]
		pExploreRange[cyc] = 5
	}
	// pursue weapon
	if pAgenda[cyc] == 4 {
		its = 0
		if pWeapFoc[cyc] == 0 || weapLocation[pWeapFoc[cyc]] != gamLocation[slot] {
			for {
				pWeapFoc[cyc] = bb.RndI(1, no_weaps)
				randy = bb.RndI(0, 1)
				if randy == 0 && weapCarrier[pWeapFoc[cyc]] > 0 do satisfied = 0
				if weapCarrier[pWeapFoc[cyc]] > 0 && Friendly(cyc, weapCarrier[pWeapFoc[cyc]]) == 0 {
					satisfied = 0
				}
				its += 1
				if its > 100 {
					pWeapFoc[cyc] = 0
					satisfied = 1
				}
				if satisfied == 1 do break
			}
		}
		if pWeapFoc[cyc] > 0 && pWeapon[cyc] != pWeapFoc[cyc] {
			pTX[cyc] = weapX[pWeapFoc[cyc]]
			pTZ[cyc] = weapZ[pWeapFoc[cyc]]
			pExploreRange[cyc] = 5
		} else {
			pAgenda[cyc] = 1
		}
	}
	// CONSIDER SUB-ROUTES
	// reset once satisified
	if Reached(pX[cyc], pSubX[cyc], 5) != 0 do pSubX[cyc] = 9999
	if Reached(pZ[cyc], pSubZ[cyc], 5) != 0 do pSubZ[cyc] = 9999
	// filter current sub-route
	if pSubX[cyc] != 9999 do pTX[cyc] = pSubX[cyc]
	if pSubZ[cyc] != 9999 do pTZ[cyc] = pSubZ[cyc]
	if GetBlock(gamLocation[slot]) > 0 {
		// get into cell
		current = InsideCell(pX[cyc], pY[cyc], pZ[cyc])
		target	= InsideCell(pTX[cyc], pTY[cyc], pTZ[cyc])
		if current == 0 && target > 0 {
			if ReachedCord(pX[cyc], pZ[cyc], cellDoorX[target], cellDoorZ[target], 30) == 0 {
				pSubX[cyc] = cellDoorX[target]
				pSubZ[cyc] = cellDoorZ[target]
			}
		}
		// get out of cell
		if current > 0 && target != current {
			if ReachedCord(pX[cyc], pZ[cyc], cellDoorX[current], cellDoorZ[current], 30) == 0 {
				pSubX[cyc] = cellDoorX[current]
				pSubZ[cyc] = cellDoorZ[current]
			}
		}
		// head upstairs
		if pY[cyc] < 100 && pTY[cyc] > 100 && pTY[cyc] < 9999 {
			if pX[cyc] < -50 || pX[cyc] > 50 {
				if pSubX[cyc] < -40 || pSubX[cyc] > 40 do pSubX[cyc] = bb.RndF(-40.0, 40.0)
				if pZ[cyc] > 10 do pSubZ[cyc] = 10
			}
			if pX[cyc] > -50 && pX[cyc] < 50 \
			&& (pTX[cyc] < -50 || pTX[cyc] > 50) {
				if pSubX[cyc] < -40 || pSubX[cyc] > 40 do pSubX[cyc] = bb.RndF(-40.0, 40.0)
				if pTZ[cyc] < 220 do pSubZ[cyc] = 220
			}
		}
		// head downstairs
		if pY[cyc] > 100 && pTY[cyc] < 100 && pTY[cyc] < 9999 {
			if pX[cyc] < -50 || pX[cyc] > 50 {
				if pSubX[cyc] < -40 || pSubX[cyc] > 40 do pSubX[cyc] = bb.RndF(-40.0, 40.0)
				if pZ[cyc] < 220 do pSubZ[cyc] = 220
			}
			if pX[cyc] > -50 && pX[cyc] < 50 \
			&& (pTX[cyc] < -50 || pTX[cyc] > 50) {
				if pSubX[cyc] < -40 || pSubX[cyc] > 40 do pSubX[cyc] = bb.RndF(-40.0, 40.0)
				if pTZ[cyc] > 10 do pSubZ[cyc] = 10
			}
		}
		// negotiate balcony
		if pY[cyc] > 100 && pTY[cyc] > 100 && pTY[cyc] < 9999 &&
		   pZ[cyc] < 220 && pTZ[cyc] < 220 {
			if pX[cyc] > -50 && pX[cyc] < 50 \
			&& (pTX[cyc] < -50 || pTX[cyc] > 50) {
				pSubZ[cyc] = 220
			}
			if pX[cyc] > -150 && pX[cyc] < 150 \
			&& (pTX[cyc] < -150 || pTX[cyc] > 150) {
				pSubZ[cyc] = 220
			}
			if (pX[cyc] < -150 && pTX[cyc] > 150) \
			|| (pX[cyc] > 150 && pTX[cyc] < -150) {
				pSubZ[cyc] = 220
			}
		}
		// get around stairs
		if pY[cyc] < 100 && pZ[cyc] > 10 && pTZ[cyc] > 10 {
			if pX[cyc] < -45 && pTX[cyc] > 45 {
				pSubX[cyc] = -40
				pSubZ[cyc] = 10
			}
			if pX[cyc] > 45 && pTX[cyc] < -45 {
				pSubX[cyc] = 40
				pSubZ[cyc] = 10
			}
		}
		// get off stairs
		if pTY[cyc] < 100 && pX[cyc] >= -40 && pX[cyc] <= 40 \
		&& pZ[cyc] > 10 && pTZ[cyc] > 10 {
			if pTX[cyc] < -45 || pTX[cyc] > 45 {
				pSubZ[cyc] = 10
			}
		}
	}
	if gamLocation[slot] == 8 {
		// get out from behind kitchen counter
		if pX[cyc] < -145 && pZ[cyc] < 145 {
			if pTX[cyc] > -145 || pTZ[cyc] > 145 {
				pSubX[cyc] = -215
				pSubZ[cyc] = 160
			}
		}
		// get in behind kitchen counter
		if pTX[cyc] < -145 && pTZ[cyc] < 165 {
			if pX[cyc] > -125 {
				pSubX[cyc] = -215
				pSubZ[cyc] = 180
			}
			if pZ[cyc] > 165 && pTX[cyc] > -190 {
				pSubX[cyc] = -215
				pSubZ[cyc] = 180
			}
		}
	}
	// MOVEMENT INPUT
	// pursue sub-route
	if pSubX[cyc] != 9999 {
		pTX[cyc] = pSubX[cyc]
		pExploreRange[cyc] = 5
	}
	if pSubZ[cyc] != 9999 {
		pTZ[cyc] = pSubZ[cyc]
		pExploreRange[cyc] = 5
	}
	// update target angle
	if ReachedCord(pX[cyc], pZ[cyc], pTX[cyc], pTZ[cyc], i32(pExploreRange[cyc])) != 0 \
	&& ReachedHeight(pY[cyc], pTY[cyc], 20) != 0 {
		pSatisfied[cyc] = 20
		pSubX[cyc] = 9999
		pSubZ[cyc] = 9999
	} else {
		bb.PositionEntity(dummy, pTX[cyc], pY[cyc], pTZ[cyc])
		bb.PointEntity(p[cyc], dummy)
		pTA[cyc] = CleanAngle(bb.EntityYaw(p[cyc]))
		bb.RotateEntity(p[cyc], 0, pA[cyc], 0)
		cUp[cyc] = 1
		if cast(bool)ReachedCord(pX[cyc], pZ[cyc], pTX[cyc], pTZ[cyc], 20) \
		&& SatisfiedAngle(pA[cyc], pTA[cyc], 25) == 0 {
			cUp[cyc] = 0
		}
		if pAgenda[cyc] == 2 && pSatisfied[cyc] > 0 {
			cUp[cyc] = 0
		}
	}
	// turn
	if SatisfiedAngle(pA[cyc], pTA[cyc], 15) == 0 {
		if ReachAngle(pA[cyc], pTA[cyc], 1) > 0 do cLeft[cyc] = 1
		if ReachAngle(pA[cyc], pTA[cyc], 1) < 0 do cRight[cyc] = 1
	}
	// override when grappling
	if pGrappling[cyc] > 0 {
		cUp[cyc] = 0
		cDown[cyc] = 0
		cLeft[cyc] = 0
		cRight[cyc] = 0
	}
	// running
	if pAnim[cyc] >= 12 && pAnim[cyc] <= 13 && cast(bool)VerticalPressed(cyc) {
		randy = bb.RndI(0, 500)
		if ReachedCord(pX[cyc], pZ[cyc], pTX[cyc], pTZ[cyc], 200) == 0 {
			randy = bb.RndI(0, 50)
		}
		if pAgenda[cyc] == 2 && charAngerTim[pChar[cyc]][pChar[pFoc[cyc]]] > 0 {
			randy = bb.RndI(0, 50)
			if pAnim[pFoc[cyc]] == 13 do randy = 0
		}
		if randy <= 1 && pRunTim[cyc] == 0 do pRunTim[cyc] = bb.RndI(25, 200)
		if cast(bool)ReachedCord(pX[cyc], pZ[cyc], pTX[cyc], pTZ[cyc], 10) {
			pRunTim[cyc] = 0
		}
		if pRunTim[cyc] > 0 do cDefend[cyc] = 1
	}
	// WEAPON INTERACTION
	// attracted to nearby item
	v = NearestWeapon(cyc)
	if v > 0 && pWeapon[cyc] == 0 && cast(bool)HandIntact(cyc, 17) && cast(bool)WeaponProximity(cyc, v, 50) \
	&& pSeat[cyc] == 0 && pBed[cyc] == 0 && pNowhere[cyc] == 0 {
		randy = bb.RndI(0, 500)
		if weapCarrier[v] > 0 {
			randy = bb.RndI(0, 5000)
		}
		if charRole[pChar[cyc]] == 1 && ((weapType[v] >= 7 && weapType[v] <= 9) ||
			weapType[v] == 12) {
			randy = bb.RndI(0, 50)
		}
		if randy == 0 && pAgenda[cyc] != 4 {
			pAgenda[cyc] = 4
			pWeapFoc[cyc] = v
			pSubX[cyc] = 9999
			pSubZ[cyc] = 9999
		}
	}
	// pick up nearby item
	range = i32(weapSize[weapType[v]] + 5)
	if weapY[v] > pY[cyc] + 10 {
		range += 10
	}
	if v > 0 && pWeapon[cyc] == 0 && weapCarrier[v] == 0 \
	&& cast(bool)WeaponProximity(cyc, v, range) && cast(bool)Isolated(cyc, 20) \
	&& cast(bool)HandIntact(cyc, 17) && pSeat[cyc] == 0 && pBed[cyc] == 0 {
		randy = bb.RndI(0, 30)
		if weapStyle[weapType[v]] >= 3 && weapStyle[weapType[v]] <= 4 && weapAmmo[v] == 0 {
			randy = bb.RndI(0, 100)
		}
		if randy == 0 || v == pWeapFoc[cyc] do cPickUp[cyc] = 1
	}
	// snatch enemy's weapon
	v = pFoc[cyc]
	if v > 0 && pWeapon[cyc] == 0 && pWeapon[v] > 0 && Friendly(cyc, v) == 0 \
	&& charGang[pChar[cyc]] != 6 && cast(bool)InProximity(cyc, v, 25) \
	&& AttackViable(v) >= 1 && AttackViable(v) <= 2 && cast(bool)HandIntact(cyc, 17) {
		randy = bb.RndI(0, 5000)
		if charRole[pChar[cyc]] == 1 ||
		   charAngerTim[pChar[cyc]][pChar[v]] > 0 {
			randy = bb.RndI(0, 100)
		}
		if randy == 0 || pWeapon[v] == pWeapFoc[cyc] {
			cPickUp[cyc] = 1
		}
	}
	// release current weapon
	if pWeapon[cyc] > 0 {
		randy = bb.RndI(0, 5000)
		if weapStyle[weapType[pWeapon[cyc]]] >= 3 \
		&& weapStyle[weapType[pWeapon[cyc]]] <= 4 \
		&& weapAmmo[pWeapon[cyc]] > 0 {
			randy = bb.RndI(0, 10000)
			if charRole[pChar[cyc]] == 1 {
				randy = 999
			}
		}
		if charRole[pChar[cyc]] == 0 \
		&& weapHabitat[weapType[pWeapon[cyc]]] < 99 \
		&& weapHabitat[weapType[pWeapon[cyc]]] != gamLocation[slot] {
			for v2 in 1..=no_plays {
				if charRole[pChar[v2]] == 1 && cast(bool)InProximity(v2, cyc, 20) {
					if cast(bool)InLine(cyc, p[v2], 60) && cast(bool)InLine(v2, p[cyc], 60) {
						randy = bb.RndI(0, 100 - charIntelligence[pChar[cyc]])
					}
				}
			}
		}
		if randy == 0 || weapAmmo[pWeapon[cyc]] == 0 {
			cPickUp[cyc] = 1
			cThrow[cyc] = 0 // drop
		}
		if cast(bool)InProximity(cyc, pFoc[cyc], 150) &&
		   InProximity(cyc, pFoc[cyc], 30) == 0 {
			if randy >= 1 && randy <= 3 {
				cThrow[cyc] = 1
				cPickUp[cyc] = 0
			} // throw
			if randy >= 4 && randy <= 6 &&
			   weapStyle[weapType[pWeapon[cyc]]] == 7 {
				cThrow[cyc] = 1
				cPickUp[cyc] = 0
			} // spear
			if randy <= 20 && cast(bool)NearBasket(cyc) {
				cThrow[cyc] = 1
				cPickUp[cyc] = 0
			} // basketball
			if randy <= 20 \
			&& weapStyle[weapType[pWeapon[cyc]]] == 6 {
				cThrow[cyc] = bb.RndI(0, 1)
				cPickUp[cyc] = bb.RndI(0, 1)
			} // explosive
		}
	}
	// answer phone
	v = PhoneProximity(cyc)
	if v > 0 && PhoneTaken(v) == 0 && pPhone[cyc] == 0 && cast(bool)Isolated(cyc, 30) {
		randy = bb.RndI(0, 200)
		if v == phoneRing {
			randy = bb.RndI(0, 50)
		}
		if randy == 0 {
			cPickUp[cyc] = 1
			cThrow[cyc] = 0
		}
	}
	// ATTACKING
	// find victims
	v = pFoc[cyc]
	if v > 0 && (charAngerTim[pChar[cyc]][pChar[v]] > 0 \
	|| charBreakdown[pChar[cyc]] > 0) && AttackViable(v) > 0 \
	&& pHealth[v] > 0 && charGang[pChar[cyc]] != 6 {
		// assess range
		range = 22
		if pWeapon[cyc] > 0 do range += i32(weapRange[weapType[pWeapon[cyc]]] * 2)
		if AttackViable(v) == 3 do range -= (range / 3)
		if weapStyle[weapType[pWeapon[cyc]]] >= 3 \
		&& weapStyle[weapType[pWeapon[cyc]]] <= 4 {
			range = 500
		}
		// assess intensity
		intensity = (100 - charReputation[pChar[cyc]]) * 3
		if charBreakdown[pChar[cyc]] > 0 do intensity /= 2
		if intensity < 10 do intensity = 10
		if pHealth[v] <= 5 do intensity *= 5
		if range >= 250 && InProximity(cyc, v, 30) == 0 do intensity *= 10
		// basic attacks
		if cast(bool)InProximity(cyc, v, range) {
			randy = bb.RndI(0, intensity)
			if randy <= 4 {
				cAttack[cyc] = 1
				cDefend[cyc] = 0
				cThrow[cyc] = 0
			}
			if randy >= 5 && randy <= 6 {
				cAttack[cyc] = 1
				cDefend[cyc] = 1
				cThrow[cyc] = 0
			}
			if randy >= 7 && randy <= 8 && cast(bool)InProximity(cyc, v, 30) \
			&& pGrappling[v] == 0 && pGrappler[v] == 0 && pSeat[v] == 0 && pBed[v] == 0 {
				cAttack[cyc] = 0
				cDefend[cyc] = 0
				cThrow[cyc] = 1
			}
		}
		// force low
		if cAttack[cyc] == 1 && AttackViable(v) == 2 {
			cUp[cyc] = 0
			cDown[cyc] = 0
			cLeft[cyc] = 0
			cRight[cyc] = 0
		}
		// force rear
		if cAttack[cyc] == 1 && AttackViable(v) == 1 \
		&& cast(bool)InProximity(cyc, v, 50) {
			if InLine(cyc, p[v], 115) == 0 {
				cAttack[cyc] = 1
				cThrow[cyc] = 1
			}
		}
		// don't shoot if not in sight
		if cAttack[cyc] == 1 && weapStyle[weapType[pWeapon[cyc]]] >= 3 \
		&& weapStyle[weapType[pWeapon[cyc]]] <= 4 {
			if InLine(cyc, p[v], 60) == 0 do cAttack[cyc] = 0
		}
	}
	// DEFENDING
	intensity = (100 - charIntelligence[pChar[cyc]]) * 3
	if intensity < 10 do intensity = 10
	if charBreakdown[pChar[cyc]] > 0 do intensity *= 5
	if AttackViable(cyc) >= 1 && AttackViable(cyc) <= 2 && cThrow[cyc] == 0 {
		for v2 in 1..=no_plays {
			if cyc != v2 && cyc == pFoc[v2] && charAngerTim[pChar[cyc]][pChar[v2]] > 0 {
				// hand-to-hand threats
				range = 30
				if pWeapon[v2] > 0 do range += i32(weapRange[weapType[pWeapon[v2]]] * 2)
				if cast(bool)InProximity(cyc, v2, range) && pAnim[v2] >= 30 \
				&& pAnim[v2] <= 49 && pAnim[v2] != 35 && pSting[v2] == 1 {
					if cast(bool)InLine(v2, p[cyc], 90) {
						randy = bb.RndI(0, intensity)
						if randy <= 5 || (randy <= 10 && cast(bool)InProximity(cyc, v2, range / 2)) \
						|| (pAnim[cyc] >= 74 && pAnim[cyc] <= 75) {
							cDefend[cyc] = 1
							cAttack[cyc] = 0
							cUp[cyc] = 0
							cDown[cyc] = 0
							cLeft[cyc] = 0
							cRight[cyc] = 0
						}
					}
				}
				// gun threats
				if cast(bool)InProximity(cyc, v2, 500) && pAnim[v2] >= 60 && pAnim[v2] <= 61 { // && pFireTim(v2)>5
					randy = bb.RndI(0, intensity)
					if randy <= 10 || (pAnim[cyc] >= 74 && pAnim[cyc] <= 75) {
						cDefend[cyc] = 1
						cAttack[cyc] = 0
						cUp[cyc] = 0
						cDown[cyc] = 0
						cLeft[cyc] = 0
						cRight[cyc] = 0
					}
				}
			}
		}
	}
}


//----------------------------------------------------------------
//////////////////// TRANSLATE INPUT /////////////////////////////
//----------------------------------------------------------------
TranslateInput :: proc(cyc: i32) {
	blocker, nearest, picker, phone, anim, v: i32
	// declaw
	if gamPromo > 0 || (cyc == gamPlayer[slot] && promoUsed[71] == 0) {
		cAttack[cyc] = 0
		cDefend[cyc] = 0
		cThrow[cyc] = 0
		cPickUp[cyc] = 0
		if cyc == promoActor[1] || cyc == promoActor[2] || (gamMission[slot] == 18 \
		&& pChar[cyc] == gamClient[slot]) || (cyc == gamPlayer[slot] && promoUsed[71] == 0) {
			cUp[cyc] = 0
			cDown[cyc] = 0
			cLeft[cyc] = 0
			cRight[cyc] = 0
		}
	}
	// force turn
	if gamPromo > 0 && pAnim[cyc] < 20 && pDazed[cyc] == 0 {
		if cyc == promoActor[1] {
			bb.PositionEntity(dummy, pX[cyc], pY[cyc], pZ[cyc])
			if promoActor[2] > 0 {
				bb.PointEntity(dummy, p[promoActor[2]])
				pTA[cyc] = CleanAngle(bb.EntityYaw(dummy))
			}
			if promoActor[2] < 0 {
				digit := Dig(i32(MakePositive(f32(promoActor[2]))), 10, context.allocator)
				padName := fmt.aprint("Pad", digit)
				delete(digit)
				bb.PointEntity(dummy, bb.FindChild(world, padName))
				delete(padName)
				pTA[cyc] = CleanAngle(bb.EntityYaw(dummy) + 180)
			}
		}
		if cyc == promoActor[2] {
			bb.PositionEntity(dummy, pX[cyc], pY[cyc], pZ[cyc])
			if promoActor[1] > 0 {
				bb.PointEntity(dummy, p[promoActor[1]])
				pTA[cyc] = CleanAngle(bb.EntityYaw(dummy))
			}
			if promoActor[1] < 0 {
				digit := Dig(i32(MakePositive(f32(promoActor[1]))), 10, context.allocator)
				padName := fmt.aprint("Pad", digit)
				delete(digit)
				bb.PointEntity(dummy, bb.FindChild(world, padName))
				delete(padName)
				pTA[cyc] = CleanAngle(bb.EntityYaw(dummy) + 180)
			}
		}
		if SatisfiedAngle(pA[cyc], pTA[cyc], 15) == 0 {
			if ReachAngle(pA[cyc], pTA[cyc], 1) > 0 do cLeft[cyc] = 1
			if ReachAngle(pA[cyc], pTA[cyc], 1) < 0 do cRight[cyc] = 1
		}
	}
	// turn
	if pAnim[cyc] < 10 && cast(bool)HorizontalPressed(cyc)&& VerticalPressed(cyc) == 0 {
		if pAnim[cyc] != 1 do ChangeAnim(cyc, 10)
		if pAnim[cyc] == 1 do ChangeAnim(cyc, 11)
	}
	// advance
	if pAnim[cyc] < 12 && cast(bool)VerticalPressed(cyc) do ChangeAnim(cyc, 12)
	// attacks
	if cAttack[cyc] == 1 && pAnim[cyc] < 20 && pDazed[cyc] == 0 {
		if cast(bool)DirPressed(cyc) do ChangeAnim(cyc, 30) // upper attack
		if DirPressed(cyc) == 0 do ChangeAnim(cyc, 31) // lower attack
		if cDefend[cyc] == 1 do ChangeAnim(cyc, 33) // big attack
		if AttackViable(pFoc[cyc]) == 3 do ChangeAnim(cyc, 32) // stomp
		if cThrow[cyc] == 1 do ChangeAnim(cyc, 34) // rear attack
		if pWeapon[cyc] > 0 && InProximity(cyc, pFoc[cyc], 25) == 0 && cThrow[cyc] == 0 {
			if weapStyle[weapType[pWeapon[cyc]]] == 3 do ChangeAnim(cyc, 61) // pistol
			if weapStyle[weapType[pWeapon[cyc]]] == 4 do ChangeAnim(cyc, 60) // machine gun
		}
	}
	// blocks
	if cDefend[cyc] == 1 && DirPressed(cyc) == 0 && pAnim[cyc] < 20 && pDazed[cyc] == 0 {
		if pAnim[cyc] == 1 || pAnim[cyc] == 11 {
			blocker = 75
		} else {
			blocker = 74
		}
		ChangeAnim(cyc, blocker)
	}
	// weapon interaction
	if cPickUp[cyc] == 1 && pAnim[cyc] < 20 && pDazed[cyc] == 0 {
		nearest = NearestWeapon(cyc)
		picker	= 0
		if nearest > 0 && cast(bool)WeaponProximity(cyc, nearest, 20) \
		&& weapCarrier[nearest] == 0 && pWeapon[cyc] == 0 {
			picker = 1
		}
		phone = PhoneProximity(cyc)
		if picker == 0 && phone > 0 && PhoneTaken(phone) == 0 && pPhone[cyc] == 0 {
			AnswerPhone(cyc, phone, 28)
		} else {
			if pPhone[cyc] > 0 do AnswerPhone(cyc, pPhone[cyc], 29)
			if pWeapon[cyc] > 0 && pPhone[cyc] == 0 do ChangeAnim(cyc, 21)
			if pWeapon[cyc] == 0 && pPhone[cyc] == 0 {
				if nearest > 0 {
					bb.PointEntity(pPivot[cyc], weap[nearest])
					pA[cyc] = bb.EntityYaw(pPivot[cyc])
				}
				anim = 20
				v = weapCarrier[nearest]
				if nearest > 0 && v > 0 && AttackViable(v) >= 1 && AttackViable(v) <= 2 {
					anim = 23
				}
				if nearest > 0 && weapY[nearest] > pY[cyc] + 10 do anim = 23
				ChangeAnim(cyc, anim)
			}
		}
	}
	// throw/grab
	if cThrow[cyc] == 1 && pAnim[cyc] < 20 && pDazed[cyc] == 0 {
		if pWeapon[cyc] > 0 && (InProximity(cyc, pFoc[cyc], 30) == 0 || cast(bool)NearBasket(cyc)) {
			if cast(bool)NearBasket(cyc) {
				ChangeAnim(cyc, 27)
			} else {
				ChangeAnim(cyc, 22)
			}
		} else {
			if AttackViable(pFoc[cyc]) != 3 do ChangeAnim(cyc, 200)
			if AttackViable(pFoc[cyc]) == 3 do ChangeAnim(cyc, 201)
		}
	}
	// automatic hang‑up
	if pPhone[cyc] > 0 && PhoneProximity(cyc) != pPhone[cyc] && pAnim[cyc] != 29 {
		if pAnim[cyc] < 20 {
			AnswerPhone(cyc, pPhone[cyc], 29)
		} else {
			ProduceSound(p[cyc], sPhone, 22050, 0)
			bb.HideEntity(bb.FindChild(p[cyc], "Phone"))
			digit := Dig(pPhone[cyc], 10)
			phoneName := fmt.aprintf("Phone%s", digit)
			delete(digit)
			bb.ShowEntity(bb.FindChild(world, phoneName))
			delete(phoneName)
			pPhone[cyc] = 0
		}
	}
	// chair interaction
	if no_chairs > 0 && pAnim[cyc] < 20 \
	&& pDazed[cyc] == 0 {
		for chair in 1..=no_chairs {
			pSeatFriction[cyc][chair] -= 1
			if pSeatFriction[cyc][chair] < 0 {
				pSeatFriction[cyc][chair] = 0
			}
			if cast(bool)ChairProximity(cyc, chair) && ChairTaken(chair) == 0 {
				if cast(bool)cUp[cyc] do pSeatFriction[cyc][chair] += 2
			}
			if pSeatFriction[cyc][chair] > 10 {
				ChangeAnim(cyc, 100)
				pSeat[cyc] = chair
				pLeaveX[cyc] = pX[cyc]
				pLeaveZ[cyc] = pZ[cyc]
				pLeaveY[cyc] = pY[cyc] + 5
				pLeaveA[cyc] = CleanAngle(pA[cyc] + 180)
				if gamLocation[slot] == 11 {
					ResetDummy(cyc)
					bb.MoveEntity(dummy, 0, 0, -5)
					pLeaveX[cyc] = bb.EntityX(dummy)
					pLeaveZ[cyc] = bb.EntityZ(dummy)
					pLeaveY[cyc] = pY[cyc] + 5
					pLeaveA[cyc] = CleanAngle(pA[cyc] + 180)
				}
			}
		}
	}
	// bed interaction
	if no_beds > 0 && pAnim[cyc] < 20 && pDazed[cyc] == 0 {
		for bed in 1..=no_beds {
			pBedFriction[cyc][bed] -= 1
			if pBedFriction[cyc][bed] < 0 do pBedFriction[cyc][bed] = 0
			if cast(bool)BedProximity(cyc, bed) && BedTaken(bed) == 0 {
				if cast(bool)cUp[cyc] do pBedFriction[cyc][bed] += 2
			}
			if pBedFriction[cyc][bed] > 10 {
				ChangeAnim(cyc, 100)
				pBed[cyc] = bed
				ResetDummy(cyc)
				bb.MoveEntity(dummy, 0, 0, -5)
				pLeaveX[cyc] = bb.EntityX(dummy)
				pLeaveZ[cyc] = bb.EntityZ(dummy)
				pLeaveY[cyc] = pY[cyc] + 5
				pLeaveA[cyc] = CleanAngle(pA[cyc] + 180)
			}
		}
	}
	// leave bed/seat if interrupted
	if pSeat[cyc] > 0 || pBed[cyc] > 0 {
		if pAnim[cyc] < 100 || pAnim[cyc] > 110 do ChangeAnim(cyc, 101)
	}
	// door interaction
	if pChar[cyc] == gamChar[slot] && gamDoor == 0 && pAnim[cyc] < 20 && pDazed[cyc] == 0 {
		for door in 1..=no_doors {
			pDoorFriction[cyc][door] -= 1
			if pDoorFriction[cyc][door] < 0 do pDoorFriction[cyc][door] = 0
			if pX[cyc] > doorX1[gamLocation[slot]][door] \
			&& pX[cyc] < doorX2[gamLocation[slot]][door] \
			&& pY[cyc] > doorY1[gamLocation[slot]][door] \
			&& pY[cyc] < doorY2[gamLocation[slot]][door] \
			&& pZ[cyc] > doorZ1[gamLocation[slot]][door] \
			&& pZ[cyc] < doorZ2[gamLocation[slot]][door] {
				if cUp[cyc] != 0 && cast(bool)SatisfiedAngle(pA[cyc], doorA[gamLocation[slot]][door], 45) {
					pDoorFriction[cyc][door] += 2
				}
			}
			if pDoorFriction[cyc][door] > 10 {
				ChangeAnim(cyc, 90)
				gamDoor = door
			}
		}
	}
}


//--------------------------------------------------------------
//////////////////// RELATED FUNCTIONS /////////////////////////
//--------------------------------------------------------------
DirPressed :: proc(cyc: i32) -> i32 {
	if cUp[cyc] == 1 || cDown[cyc] == 1 || cLeft[cyc] == 1 || cRight[cyc] == 1 {
		return 1
	}
	return 0
}


VerticalPressed :: proc(cyc: i32) -> i32 {
	if cUp[cyc] == 1 || cDown[cyc] == 1 {
		return 1
	}
	return 0
}


HorizontalPressed :: proc(cyc: i32) -> i32 {
	if cLeft[cyc] == 1 || cRight[cyc] == 1 {
		return 1
	}
	return 0
}


ActionPressed :: proc(cyc: i32) -> i32 {
	if cAttack[cyc] == 1 || cDefend[cyc] == 1 || cThrow[cyc] == 1 || cPickUp[cyc] == 1 {
		return 1
	}
	return 0
}


ButtonPressed :: proc() -> i32 {
	for count in i32(1)..=12 {
		if cast(bool)bb.JoyDown(count) {
			return 1
		}
	}
	return 0
}


EnforceBlocks :: proc(cyc: i32) {
	width, height, trapped: i32
	checkX, checkZ, ranger: f32

	// enemy bumping
	for v in 1..=no_plays {
		if cyc != v && pGrappling[cyc] != v && pGrappler[cyc] != v {
			width = 8
			height = 35
			checkX = pX[v]
			checkZ = pZ[v]
			if pGrappler[v] > 0 || pAnim[v] >= 210 {
				checkX = bb.EntityX(pLimb[v][30], 1)
				checkZ = bb.EntityZ(pLimb[v][30], 1)
			}
			if pOldX[cyc] > checkX - f32(width) \
			&& pOldX[cyc] < checkX + f32(width) \
			&& pOldZ[cyc] > checkZ - f32(width) \
			&& pOldZ[cyc] < checkZ + f32(width) {
				trapped = 1
			} else {
				if pX[cyc] > checkX - f32(width) \
				&& pX[cyc] < checkX + f32(width) \
				&& pZ[cyc] > checkZ - f32(width) \
				&& pZ[cyc] < checkZ + f32(width) \
				&& pY[cyc] > pY[v] - cast(f32)height \
				&& pY[cyc] < pY[v] + cast(f32)height {
					if pOldX[cyc] > checkX - f32(width) && pOldX[cyc] < checkX + f32(width) {
						pZ[cyc] = pOldZ[cyc]
					}
					if pOldZ[cyc] > checkZ - f32(width) && pOldZ[cyc] < checkZ + f32(width) {
						pX[cyc] = pOldX[cyc]
					}
					bb.PositionEntity(pPivot[cyc], pX[cyc], bb.EntityY(pPivot[cyc]), pZ[cyc])
					if pAnim[cyc] < 20 && cast(bool)VerticalPressed(cyc) do pNowhere[cyc] += 2
				}
			}
		}
	}
	// clock nowhere
	ranger = pSpeed[cyc] / 2
	if pX[cyc] > pOldX[cyc] - ranger \
	&& pX[cyc] < pOldX[cyc] + ranger \
	&& pZ[cyc] > pOldZ[cyc] - ranger \
	&& pZ[cyc] < pOldZ[cyc] + ranger {
		if pAnim[cyc] < 20 && cast(bool)VerticalPressed(cyc) do pNowhere[cyc] += 2
	}
}


ReachedHeight :: proc(y, tY: f32, range: i32) -> i32 {
	if y >= tY - f32(range) && y <= tY + f32(range) do return 1
	if tY == 9999.0 do return 1
	return 0
}


NearestEnemy :: proc(cyc: i32) -> i32 {
	value: i32 = 0
	hi: f32 = 9999.0
	distance: f32
	if cyc > 0 {
		for v in 1..=no_plays {
			distance = GetDistance(pX[cyc], pZ[cyc], pX[v], pZ[v])
			if pY[v] < pY[cyc] - 30 || pY[v] > pY[cyc] + 30 do distance += 100
			if charAngerTim[pChar[cyc]][pChar[v]] > 0 do distance /= 2
			if pAgenda[cyc] == 2 && v == pFollowFoc[cyc] do distance /= 2
			if Friendly(cyc, v) != 0 do distance *= 2
			if cyc == gamPlayer[slot] && charFollowTim[pChar[v]] > 0 do distance *= 2
			if v == gamPlayer[slot] && charFollowTim[pChar[cyc]] > 0 do distance *= 2
			if pGrappler[v] > 0 do distance *= 2
			if cyc != v && distance < hi {
				value = v
				hi = distance
			}
		}
	}
	return value
}


// In proximity of enemy
InProximity :: proc(cyc, v, range: i32) -> i32 {
	range := range
	if pSeat[cyc] > 0 && pSeat[v] > 0 do range *= 2
	if pY[v] > pY[cyc] - 30 && pY[v] < pY[cyc] + 30 {
		checkX, checkZ: f32
		checkX = pX[cyc]
		checkZ = pZ[cyc]
		if pGrappling[cyc] > 0 || pGrappler[cyc] > 0 {
			checkX = bb.EntityX(pLimb[cyc][30], 1)
			checkZ = bb.EntityZ(pLimb[cyc][30], 1)
		}
		if checkX > pX[v] - f32(range) && checkX < pX[v] + f32(range) \
		&& checkZ > pZ[v] - f32(range) && checkZ < pZ[v] + f32(range) {
			return 1
		}
	}
	return 0
}


LimbProximity :: proc(limb: i32, x, z: f32, range: i32) -> i32 {
	if x > bb.EntityX(limb, 1) - f32(range) \
	&& x < bb.EntityX(limb, 1) + f32(range) \
	&& z > bb.EntityZ(limb, 1) - f32(range) \
	&& z < bb.EntityZ(limb, 1) + f32(range) {
		return 1
	}
	return 0
}


InRange :: proc(cyc, v, range: i32) -> i32 {
	value: i32 = 0
	if cast(bool)InProximity(cyc, v, range * 3) {
		ResetDummy(cyc)
		for depth in 1..=range {
			if value == 0 {
				span := f32(6 + (depth * 2))
				bb.MoveEntity(dummy, 0, 0, 4)
				checkX := bb.EntityX(dummy)
				checkZ := bb.EntityZ(dummy)
				if checkX > pX[v] - span \
				&& checkX < pX[v] + span \
				&& checkZ > pZ[v] - span \
				&& checkZ < pZ[v] + span {
					value = depth
				}
			}
		}
	}
	return value
}


InLine :: proc(cyc, entity, range: i32) -> i32 {
	ResetDummy(cyc)
	bb.PointEntity(dummy, entity)
	tA := CleanAngle(bb.EntityYaw(dummy))
	if cast(bool)SatisfiedAngle(pA[cyc], tA, range) {
		return 1
	}
	return 0
}


Isolated :: proc(cyc, range: i32) -> i32 {
	for v in 1..=no_plays {
		if cyc != v && Friendly(cyc, v) == 0 \
		&& cast(bool)InProximity(cyc, v, range) \
		&& AttackViable(v) != 3 {
			return 0
		}
	}
	return 1
}


FindThreat :: proc(cyc: i32) -> i32 { // 1=high, 2=low
	threat: i32 = 0
	range: i32
	if AttackViable(cyc) >= 1 && AttackViable(cyc) <= 2 {
		for v in 1..=no_plays {
			if cyc != v && cyc == pFoc[v] {
				// hand-to-hand threats
				range = 30
				if pWeapon[v] > 0 {
					range += i32(weapRange[weapType[pWeapon[v]]] * 2)
				}
				if cast(bool)InProximity(cyc, v, range) && pAnim[v] >= 30 \
				&& pAnim[v] <= 49 && pSting[v] == 1 {
					if cast(bool)InLine(v, p[cyc], 90) {
						if pAnim[v] == 31 || pAnim[v] == 35 || pAnim[v] == 41 {
							threat = 2
						} else {
							threat = 1
						}
						pFoc[cyc] = v
					}
				}
				//If InProximity(cyc,v,500) And pAnim(v)=>60 And pAnim(v)=<61 And pFireTim(v)=>5
				//If pY#(cyc)<pY#(v)-5 Or pY#(cyc)>pY#(v)+5 Then threat=2 Else threat=1
				//pFoc(cyc)=v 
				//EndIf  
			}
		}
	}
	return threat
}


// IDENTIFY FRIENDLY RELATIONSHIP (between players)
Friendly :: proc(cyc, v: i32) -> i32 {
	friendly: i32 = 0
	if charAngerTim[pChar[cyc]][pChar[v]] == 0 \
	&& charRelation[pChar[cyc]][pChar[v]] >= 0 {
		if charRelation[pChar[cyc]][pChar[v]] == 1 {
			friendly = 1
		}
		if charGang[pChar[cyc]] > 0 && charGang[pChar[cyc]] == charGang[pChar[v]] {
			friendly = 1
		}
		if pChar[cyc] == gamChar[slot] && (charFollowTim[pChar[v]] > 0 \
		|| charBribeTim[pChar[v]] > 0) {
			friendly = 1
		}
		if pChar[v] == gamChar[slot] && (charFollowTim[pChar[cyc]] > 0 \
		|| charBribeTim[pChar[cyc]] > 0) {
			friendly = 1
		}
	}
	return friendly
}


// IDENTIFY FRIENDLY RELATIONSHIP (between characters)
FriendlyChars :: proc(char, v: i32) -> i32 {
	friendly: i32 = 0
	if charAngerTim[char][v] == 0 && charRelation[char][v] >= 0 {
		if charRelation[char][v] == 1 {
			friendly = 1
		}
		if charGang[char] > 0 && charGang[char] == charGang[v] {
			friendly = 1
		}
	}
	return friendly
}


RiskAnger :: proc(cyc, v: i32) {
	randy: i32
	if pChar[cyc] == gamChar[slot] \
	&& charPromo[pChar[v]][pChar[cyc]] == 0 {
		if GetResponse(cyc, v, 0) > 0 \
		&& charRole[pChar[v]] == 1 \
		&& (pWeapon[cyc] == 0 || promoUsed[1] != 0) {
			charPromo[pChar[v]][pChar[cyc]] = 5 // assaulted officer
		}
		if GetResponse(cyc, v, 0) > 0 \
		&& charRole[pChar[v]] == 0 \
		&& charAngerTim[pChar[v]][pChar[cyc]] == 0 \
		&& charRelation[pChar[v]][pChar[cyc]] >= 0 {
			charPromo[pChar[v]][pChar[cyc]] = 14 // unprovoked attack
			if charGang[pChar[v]] > 0 && charGang[pChar[v]] != 6 && charGang[pChar[v]] != charGang[pChar[cyc]] {
				charPromo[pChar[v]][pChar[cyc]] = 40 // rival gang membr
			}
			if charGang[pChar[v]] > 0 && charGang[pChar[v]] != 6 && charGang[pChar[v]] == charGang[pChar[cyc]] {
				charPromo[pChar[v]][pChar[cyc]] = 41 //fellow  gang member
			}
			if charRelation[pChar[v]][pChar[cyc]] > 0 {
				charPromo[pChar[v]][pChar[cyc]] = 80 // out with friend
			}
			if charGang[pChar[v]] == 6 {
				charPromo[pChar[v]][pChar[cyc]] = 43 // 
			}
		}
		if GetResponse(cyc, v, 0) > 0 \
		&& pSeat[v] > 0 && charGang[pChar[v]] != 6 {
			charPromo[pChar[v]][pChar[cyc]] = 9 // lost seat
		}
		if GetResponse(cyc, v, 0) > 0 \
		&& pBed[v] > 0 && charGang[pChar[v]] != 6 {
			charPromo[pChar[v]][pChar[cyc]] = 10 // lost bed
		}
		randy = bb.RndI(0, 20)
		if randy == 0 && charRole[pChar[v]] == 1 \
		&& gamWarrant[slot] < 9 \
		&& charBribeTim[pChar[v]] == 0 {
			gamWarrant[slot] = 9 // assault officer warrantt 
		}
		// beg for mercy
		if charReputation[pChar[v]] < charReputation[pChar[cyc]] && promoUsed[258] == 0 {
			randy = bb.RndI(0, pHealth[v] * 2)
			if randy == 0 && pHealth[v] > 0 \
			&& pHealth[v] < 20 {
				charPromo[pChar[v]][pChar[cyc]] = 258
			}
			randy = bb.RndI(0, charHappiness[pChar[v]] * 2)
			if randy == 0 && charHappiness[pChar[v]] > 0 && charHappiness[pChar[v]] < 20 {
				charPromo[pChar[v]][pChar[cyc]] = 258
			}
		}
		// response to intervening
		for count in 1..=no_plays {
			if count != cyc && count != v \
			&& charPromo[pChar[count]][pChar[cyc]] == 0 \
			&& charAttacker[pChar[count]] == pChar[v] \
			&& charAngerTim[pChar[count]][pChar[cyc]] == 0 \
			&& charAngerTim[pChar[cyc]][pChar[v]] == 0 \
			&& charAngerTim[pChar[v]][pChar[cyc]] == 0 {
				if charAngerTim[pChar[count]][pChar[v]] > 0 \
				|| charAngerTim[pChar[v]][pChar[count]] > 0 {
					if cast(bool)InProximity(count, cyc, 30) \
					|| cast(bool)InProximity(count, v, 30) {
						randy = bb.RndI(0, 6)
						if randy == 0 || (randy == 1 \
						&& charRelation[pChar[count]][pChar[cyc]] > 0) {
							charPromo[pChar[count]][pChar[cyc]] = 78
						}
						if (randy == 2 && charRelation[pChar[count]][pChar[cyc]] <= 0) \
						|| (randy == 3 && charRelation[pChar[count]][pChar[cyc]] < 0) {
							charPromo[pChar[count]][pChar[cyc]] = 79
						}
						charPromoRef[pChar[count]] = pChar[v]
					}
				}
			}
		}
	}
	// offer mercy
	if pChar[v] == gamChar[slot] \
	&& gamMoney[slot] > 0 \
	&& charPromo[pChar[cyc]][pChar[v]] == 0 \
	&& charReputation[pChar[v]] < charReputation[pChar[cyc]] \
	&& promoUsed[259] == 0 {
		randy = bb.RndI(0, pHealth[v] * 2)
		if randy == 0 && pHealth[v] > 0 && pHealth[v] < 20 {
			charPromo[pChar[cyc]][pChar[v]] = 259
		}
		randy = bb.RndI(0, charHappiness[pChar[v]] * 2)
		if randy == 0 && charHappiness[pChar[v]] > 0 && charHappiness[pChar[v]] < 20 {
			charPromo[pChar[cyc]][pChar[v]] = 259
		}
	}
	// anger victim
	if charGang[pChar[v]] != 6 {
		reaction := (charStrength[pChar[v]] - 30) + (100 - charIntelligence[pChar[v]]) + (charReputation[pChar[v]] - 30)
		charAngerTim[pChar[v]][pChar[cyc]] = bb.RndI(reaction/2, reaction*4)
		pAgenda[v] = 2
		pFollowFoc[v] = cyc
		pSubX[v] = 9999
		pSubZ[v] = 9999
		randy = bb.RndI(0, 10)
		if randy == 0 && charRelation[pChar[v]][pChar[cyc]] >= 0 {
			ChangeRelationship(pChar[v],pChar[cyc], -1)
		}
	}
	// reset witnesses
	charWitness[pChar[cyc]] = 0
	if charRole[pChar[v]] == 1 && pHealth[v] > 0 {
		charWitness[pChar[cyc]] = pChar[v]
	}
	// affect others
	for count in 1..=no_plays {
		if count != cyc && count != v \
		&& pChar[count] != gamChar[slot] \
		&& gamBlackout[slot] == 0 {
			// find witnesses
			if charWitness[pChar[cyc]] == 0 \
			&& (Friendly(count, cyc) == 0 \
			|| Friendly(count, v) != 0) \
			&& charBribeTim[pChar[count]] == 0 \
			&& cast(bool)InProximity(count, cyc, 100) \
			&& AttackViable(count) >= 1 \
			&& AttackViable(count) <= 2 \
			&& pDazed[count] == 0 {
				if cast(bool)InLine(count, p[cyc], 60) \
				|| cast(bool)InLine(count, p[v], 60) {
					charWitness[pChar[cyc]] = pChar[v]
				}
			}
			// include friends
			if Friendly(count, v) != 0 \
			&& Friendly(count, cyc) == 0 \
			&& AttackViable(count) >= 1 \
			&& AttackViable(count) <= 2 \
			&& pDazed[count] == 0 {
				if cast(bool)InLine(count, p[cyc], 60) \
				|| cast(bool)InLine(count, p[v], 60) {
					if charAngerTim[pChar[count]][pChar[cyc]] == 0 {
						charAngerTim[pChar[count]][pChar[cyc]] = charAngerTim[pChar[v]][pChar[cyc]] / 2
					}
					if charRole[pChar[cyc]] == 0 \
					&& charRole[pChar[count]] == 1 {
						charAngerTim[pChar[count]][pChar[cyc]] = charAngerTim[pChar[count]][pChar[cyc]] / 2
					}
					if pFollowFoc[count] != cyc {
						pSubX[count] = 9999
						pSubZ[count] = 9999
					}
					pAgenda[count] = 2
					pFollowFoc[count] = cyc
					if GetResponse(cyc, count, 0) > 0 \
					&& pChar[cyc] == gamChar[slot] \
					&& charPromo[pChar[count]][pChar[cyc]] == 0 \
					&& charGang[pChar[count]] != 6 {
						if charRelation[pChar[count]][pChar[v]] == 1 {
							charPromo[pChar[count]][pChar[cyc]] = 15
						}
						if charGang[pChar[v]] > 0 && charGang[pChar[v]] == charGang[pChar[count]] {
							charPromo[pChar[count]][pChar[cyc]] = 39
						}
						charPromoRef[pChar[count]] = pChar[v]
					}
					if GetResponse(cyc, count, 0) > 0 \
					&& pChar[v] == gamChar[slot] \
					&& charPromo[pChar[count]][pChar[v]] == 0 \
					&& charGang[pChar[count]] != 6 {
						charPromo[pChar[count]][pChar[v]] = 77
						charPromoRef[pChar[count]] = pChar[cyc]
					}
				}
			}
			// clock civil war
			if charGang[pChar[count]] > 0 \
			&& charGang[pChar[cyc]] == charGang[pChar[count]] \
			&& charGang[pChar[v]] == charGang[pChar[count]] \
			&& AttackViable(count) >= 1 \
			&& AttackViable(count) <= 2 \
			&& pDazed[count] == 0 {
				if cast(bool)InLine(count, p[cyc], 60) \
				|| cast(bool)InLine(count, p[v], 60) {
					if charAngerTim[pChar[count]][pChar[cyc]] == 0 {
						charAngerTim[pChar[count]][pChar[cyc]] = charAngerTim[pChar[v]][pChar[cyc]] / 2
					}
					if pFollowFoc[count] != cyc {
						pSubX[count] = 9999
						pSubZ[count] = 9999
					}
					pAgenda[count] = 2
					pFollowFoc[count] = cyc
					if GetResponse(cyc, count, 0) > 0 \
					&& pChar[cyc] == gamChar[slot] \
					&& charPromo[pChar[count]][pChar[cyc]] == 0 \
					&& charGang[pChar[count]] != 6 {
						charPromo[pChar[count]][pChar[cyc]] = 41
						charPromoRef[pChar[count]] = pChar[v]
					}
				}
			}
			// include guards
			if charRole[pChar[count]] == 1 \
			&& charRole[pChar[cyc]] == 0 \
			&& (Friendly(count, cyc) == 0 \
			|| Friendly(count, v) != 0) \
			&& charBribeTim[pChar[count]] == 0 \
			&& AttackViable(count) >= 1 \
			&& AttackViable(count) <= 2 \
			&& pDazed[count] == 0 {
				if cast(bool)InLine(count, p[cyc], 60) \
				|| cast(bool)InLine(count, p[v], 60) {
					if charAngerTim[pChar[count]][pChar[cyc]] < 100 {
						charAngerTim[pChar[count]][pChar[cyc]] = 100
					}
					if pFollowFoc[count] != cyc {
						pSubX[count] = 9999
						pSubZ[count] = 9999
					}
					pAgenda[count] = 2
					pFollowFoc[count] = cyc
					if pChar[cyc] == gamChar[slot] \
					&& charPromo[pChar[count]][pChar[cyc]] == 0 \
					&& charBribeTim[pChar[count]] == 0 {
						if GetResponse(cyc, count, 0) > 0 {
							if charRole[pChar[v]] == 0 {
								charPromo[pChar[count]][pChar[cyc]] = 4
							}
							if charRole[pChar[v]] == 1 {
								charPromo[pChar[count]][pChar[cyc]] = 5
							}
							if pWeapon[cyc] > 0 && promoUsed[72] == 0 {
								charPromo[pChar[count]][pChar[cyc]] = 72
								charPromoRef[pChar[count]] = pChar[v]
							}
						}
						randy = bb.RndI(0, 50)
						if randy <= 1 && charRole[pChar[v]] == 1 && gamWarrant[slot] < 9 {
							gamWarrant[slot] = 9 // assault officer warrant
						}
						if randy == 2 && charRole[pChar[v]] == 0 && gamWarrant[slot] < 8 {
							gamWarrant[slot] = 8 // assault warrant
						}
						if pWeapon[cyc] > 0 \
						&& pAnim[cyc] != 23 \
						&& gamMission[slot] != 11 \
						&& gamMission[slot] != 12 {
							randy = bb.RndI(0, 50)
							if ((weapType[pWeapon[cyc]] >= 7 \
							&& weapType[pWeapon[cyc]] <= 9) \
							|| weapType[pWeapon[cyc]] == 23) {
								randy = bb.RndI(0, 25)
							}
							if randy <= 1 && gamWarrant[slot] < 10 {
								gamWarrant[slot] = 10
								gamItem[slot] = pWeapon[cyc] // assault w/ weapon
							}
							if randy == 2 && gamWarrant[slot] < 4 {
								gamWarrant[slot] = 4
								gamItem[slot] = pWeapon[cyc] // carrying weapon
							}
						}
						randy = bb.RndI(0, 5)
						if randy == 0 \
						   && pAnim[cyc] == 23 \
						   && pWeapon[cyc] > 0 \
						   && gamMission[slot] != 11 \
						   && gamMission[slot] != 12 {
							if gamWarrant[slot] < 7 {
								gamWarrant[slot] = 7
								gamItem[slot] = pWeapon[cyc] // caught stealing 
							}
						}
					}
				}
			}
		}
		// friend asks for help
		if count != cyc && count != v \
		&& pChar[count] == gamChar[slot] \
		&& cast(bool)Friendly(count, v)\
		&& charAngerTim[pChar[count]][pChar[cyc]] == 0 \
		&& charAngerTim[pChar[cyc]][pChar[count]] == 0 \
		&& cast(bool)InProximity(count, v, 50) \
		&& gamBlackout[slot] == 0 {
			randy = bb.RndI(0, 5)
			if randy == 0 \
			&& charPromo[pChar[v]][pChar[count]] == 0 \
			&& promoUsed[249] == 0 {
				charPromo[pChar[v]][pChar[count]] = 249
				charPromoRef[pChar[v]] = pChar[cyc]
			}
		}
		// calm down after intervention
		if charRole[pChar[cyc]] == 1 && charRole[pChar[v]] == 0 {
			charAngerTim[pChar[v]][count] /= 2
		}
	}
}


// RISK RESPONSE (v to cyc)
GetResponse :: proc(cyc, v, chance: i32) -> i32 {
	chance := chance
	// establish likelihood
	if chance == 0 {
		chance = (charReputation[pChar[cyc]] / 5) - (charReputation[pChar[v]] / 5)
		if chance < 1 || charRelation[pChar[v]][pChar[cyc]] == -1 || charRole[pChar[v]] == 1 {
			chance = 1
		}
	}
	// risk response
	randy := bb.RndI(0, chance)
	if randy == 0 do return 1
	return 0
}


TradingRisk :: proc(cyc, weapon: i32) {
	for v in 1..=no_plays {
		if charRole[pChar[v]] == 1 && v != pFoc[cyc] && Friendly(v, cyc) == 0 \
		&& charBribeTim[pChar[v]] == 0 && gamBlackout[slot] == 0 \
		&& AttackViable(v) >= 1 && AttackViable(v) <= 2 \
		&& pDazed[v] == 0 && cast(bool)InProximity(v, cyc, 50) {
			if cast(bool)InLine(v, p[cyc], 60) {
				randy := bb.RndI(0, 5)
				if randy == 0 && pChar[cyc] == gamChar[slot] \
				&& gamMission[slot] != 11 && gamMission[slot] != 12 {
					if gamWarrant[slot] < 6 {
						gamWarrant[slot] = 6
						gamItem[slot] = weapon
					}
				}
				pAgenda[v] = 4
				pWeapFoc[v] = weapon
				pSubX[v] = 9999
				pSubZ[v] = 9999
			}
		}
	}
}


AssessRelationships :: proc(cyc: i32) {
	if cast(bool)FocViable(cyc) {
		// look at nearest by default
		pFoc[cyc] = NearestEnemy(cyc)
		// consider relationships
		for v in 1..=no_plays {
			// guarantee racial friction
			if pChar[cyc] != gamChar[slot] {
				if charGang[pChar[cyc]] >= 1 && charGang[pChar[cyc]] <= 3 \
				&& charGang[pChar[cyc]] != charGang[pChar[v]] \
				&& GetRace(pChar[cyc]) != GetRace(pChar[v]) \
				&& Friendly(cyc, v) == 0 {
					charRelation[pChar[cyc]][pChar[v]] = -1
				}
			}
			// calm down
			if gamPromo == 0 {
				charAngerTim[pChar[cyc]][pChar[v]] -= 1
				if AttackViable(cyc) == 3 || AttackViable(v) == 3 {
					charAngerTim[pChar[cyc]][pChar[v]] -= 1
				}
				if charRole[pChar[cyc]] == 0 && charRole[pChar[v]] == 0 \
				&& charReputation[pChar[cyc]] < charReputation[pChar[v]] {
					charAngerTim[pChar[cyc]][pChar[v]] -= 1
				}
				if charRole[pChar[cyc]] == 0 && charRole[pChar[v]] == 1 \
				&& cast(bool)InProximity(cyc, v, 100) {
					charAngerTim[pChar[cyc]][pChar[v]] -= 1
				}
			}
			if charAngerTim[pChar[cyc]][pChar[v]] < 0 {
				charAngerTim[pChar[cyc]][pChar[v]] = 0
			}
			// spontaneous anger
			if charAngerTim[pChar[cyc]][pChar[v]] == 0 {
				randy := bb.RndI(0, 10000)
				if randy == 0 && charRelation[pChar[cyc]][pChar[v]] == 0 {
					charAngerTim[pChar[cyc]][pChar[v]] = 10
				}
				if randy <= 5 && charRelation[pChar[cyc]][pChar[v]] == -1 {
					charAngerTim[pChar[cyc]][pChar[v]] = 10
				}
			}
			// law enforcement
			if charRole[pChar[cyc]] == 1 && charRole[pChar[v]] == 0 \
			&& Friendly(cyc, v) == 0 && charBribeTim[pChar[cyc]] == 0 \
			&& gamBlackout[slot] == 0 && AttackViable(cyc) >= 1 \
			&& AttackViable(cyc) <= 2 && pDazed[cyc] == 0 {
				// confiscate weapons
				if pWeapon[v] > 0 && weapHabitat[weapType[pWeapon[v]]] < 99 \
				&& weapHabitat[weapType[pWeapon[v]]] != gamLocation[slot] \
				&& cast(bool)InProximity(cyc, v, i32(weapSize[weapType[pWeapon[v]]] * 5)) {
					if cast(bool)InLine(cyc, p[v], 60) {
						randy := bb.RndI(0, 100)
						if randy == 0 || pChar[v] == gamChar[slot] {
							if pAgenda[cyc] != 4 {
								pSubX[cyc] = 9999
								pSubZ[cyc] = 9999
							}
							pAgenda[cyc] = 4
							pWeapFoc[cyc] = pWeapon[v]
							if charAngerTim[pChar[cyc]][pChar[v]] < 10 {
								charAngerTim[pChar[cyc]][pChar[v]] = 10
							}
						}
						randy = bb.RndI(0, 1000)
						if (weapType[pWeapon[v]] >= 7 && weapType[pWeapon[v]] <= 9) \
						|| weapType[pWeapon[v]] == 23 {
							randy = bb.RndI(0, 500)
						}
						if randy == 0 || (randy == 1 && weapHabitat[weapType[pWeapon[v]]] == 0) {
							if pChar[v] == gamChar[slot] && gamPromo == 0 \
							&& gamMission[slot] != 11 && gamMission[slot] != 12 {
								if gamWarrant[slot] < 4 {
									gamWarrant[slot] = 4
									gamItem[slot] = pWeapon[v]
								}
							}
						}
					}
				}
				// clock drug abuse
				if pAnim[v] >= 93 && pAnim[v] <= 95 \
				&& weapHabitat[weapType[pWeapon[v]]] != gamLocation[slot] \
				&& cast(bool)InProximity(cyc, v, 50) {
					if cast(bool)InLine(cyc, p[v], 60) {
						randy := bb.RndI(0, 100)
						if randy == 0 || pChar[v] == gamChar[slot] {
							if pAgenda[cyc] != 4 {
								pSubX[cyc] = 9999
								pSubZ[cyc] = 9999
							}
							pAgenda[cyc] = 4
							pWeapFoc[cyc] = pWeapon[v]
							if charAngerTim[pChar[cyc]][pChar[v]] < 10 {
								charAngerTim[pChar[cyc]][pChar[v]] = 10
							}
						}
						randy = bb.RndI(0, 500)
						if randy <= 1 && pChar[v] == gamChar[slot] \
						&& gamWarrant[slot] < 5 && gamPromo == 0 {
							gamWarrant[slot] = 5
						}
					}
				}
				// clock gang membership
				if pChar[v] == gamChar[slot] && charGang[pChar[v]] > 0 \
				&& cast(bool)InProximity(cyc, v, 30) {
					if cast(bool)InLine(cyc, p[v], 60) {
						randy := bb.RndI(0, 5000)
						if randy == 0 && gamWarrant[slot] < 2 && gamPromo == 0 {
							gamWarrant[slot] = 2
						}
					}
				}
				// out of block during lock down
				if cast(bool)LockDown() && pChar[v] == gamChar[slot] \
				&& GetBlock(gamLocation[slot]) != charBlock[pChar[v]] {
					if cast(bool)InLine(cyc, p[v], 60) {
						if pAgenda[cyc] != 2 {
							pSubX[cyc] = 9999
							pSubZ[cyc] = 9999
						}
						pAgenda[cyc] = 2
						pFollowFoc[cyc] = v
						randy := bb.RndI(0, 100)
						if randy == 0 && charAngerTim[pChar[cyc]][pChar[v]] < 10 {
							charAngerTim[pChar[cyc]][pChar[v]] = 10
						}
						randy = bb.RndI(0, 5000)
						if randy == 0 && cast(bool)InProximity(cyc, v, 100) \
						&& (gamHours[slot] > 22 || gamHours[slot] < 7) \
						&& gamWarrant[slot] < 1 && gamPromo == 0 {
							gamWarrant[slot] = 1
						}
						if randy <= 50 && cast(bool)InProximity(cyc, v, 100) \
						&& gamEscape[slot] == 1 && gamWarrant[slot] < 3 && gamPromo == 0 {
							gamWarrant[slot] = 3
						}
					}
				}
				// out of cell during lock down
				if cast(bool)LockDown() && pChar[v] == gamChar[slot] \
				&& GetBlock(gamLocation[slot]) == charBlock[pChar[v]] \
				&& InsideCell(pX[v], pY[v], pZ[v]) != charCell[pChar[v]] \
				&& pAnim[v] != 12 && pAnim[v] != 13 {
					if cast(bool)InLine(cyc, p[v], 60) {
						if pAgenda[cyc] != 2 {
							pSubX[cyc] = 9999
							pSubZ[cyc] = 9999
						}
						pAgenda[cyc] = 2
						pFollowFoc[cyc] = v
						randy := bb.RndI(0, 100)
						if randy == 0 && charAngerTim[pChar[cyc]][pChar[v]] < 10 {
							charAngerTim[pChar[cyc]][pChar[v]] = 10
						}
						randy = bb.RndI(0, 5000)
						if randy == 0 && cast(bool)InProximity(cyc, v, 100) \
						&& (gamHours[slot] > 22 || gamHours[slot] < 7) \
						&& gamWarrant[slot] < 1 && gamPromo == 0 {
							gamWarrant[slot] = 1
						}
					}
				}
			}
			// wave to friends
			cellConflict: i32 = 0
			cell := InsideCell(pX[v], pY[v], pZ[v])
			if cell > 0 && CellVisible(pX[cyc], pY[cyc], pZ[cyc], cell) == 0 {
				cellConflict = 1
			}
			if cellConflict == 0 && cyc != v && cast(bool)InProximity(cyc, v, 100) \
			&& pInteract[cyc][v] == 0 && cast(bool)Friendly(cyc, v) \
			&& cast(bool)Friendly(v, cyc) && pAnim[cyc] < 20 && pAnim[v] < 20 \
			&& pDazed[cyc] == 0 && pDazed[v] == 0 && v != promoActor[1] \
			&& v != promoActor[2] {
				if (charFollowTim[pChar[cyc]] == 0 || v != gamPlayer[slot]) \
				&& (charFollowTim[pChar[v]] == 0 || cyc != gamPlayer[slot]) {
					if cast(bool)InLine(cyc, p[v], 60) && cast(bool)InLine(v, p[cyc], 60) {
						pFoc[cyc] = v
						ChangeAnim(cyc, 91)
						pFoc[v] = cyc
						ChangeAnim(v, 91)
						pInteract[cyc][v] = 1
						pInteract[v][cyc] = 1
					}
				}
			}
			// trigger promos
			if charPromo[pChar[cyc]][pChar[v]] >= 202 \
			&& charPromo[pChar[cyc]][pChar[v]] <= 204 {
				if GetBlock(gamLocation[slot]) != charBlock[pChar[cyc]] \
				|| InsideCell(pX[cyc], pY[cyc], pZ[cyc]) != charCell[pChar[cyc]] \
				|| InsideCell(pX[v], pY[v], pZ[v]) != charCell[pChar[v]] {
					cellConflict = 1
				}
			}
			if gotim > 50 && gamPromo == 0 && promoTim == 0 && cellConflict == 0 \
			&& cyc != v && pHealth[cyc] > 0 && pHealth[v] > 0 && pPhone[cyc] == 0 \
			&& pPhone[v] == 0 && pAnim[v] != 90 {
				oldPromo := charPromo[pChar[cyc]][pChar[v]]
				RiskPromo(cyc, v)
				if charPromo[pChar[cyc]][pChar[v]] > 0 {
					if cast(bool)InProximity(cyc, v, 50) \
					|| (cast(bool)InProximity(cyc, v, 100) \
					&& oldPromo != charPromo[pChar[cyc]][pChar[v]]) {
						TriggerPromo(cyc, v, charPromo[pChar[cyc]][pChar[v]])
						charPromo[pChar[cyc]][pChar[v]] = 0
					}
				}
			}
		}
	}
	// pursue warrant
	if charRole[pChar[cyc]] == 1 && gamWarrant[slot] > 0 && charBribeTim[pChar[cyc]] == 0 {
		if pAgenda[cyc] != 2 {
			pSubX[cyc] = 9999
			pSubZ[cyc] = 9999
		}
		pAgenda[cyc] = 2
		pFollowFoc[cyc] = gamPlayer[slot]
		if charAngerTim[pChar[cyc]][gamChar[slot]] < 10 {
			charAngerTim[pChar[cyc]][gamChar[slot]] = 10
		}
	}
	// promo override
	if gamPromo > 0 {
		if cyc == promoActor[1] && promoActor[2] > 0 do pFoc[cyc] = promoActor[2]
		if cyc == promoActor[2] && promoActor[1] > 0 do pFoc[cyc] = promoActor[1]
	}
}
