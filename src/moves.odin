package main

import bb "blitzbasic3d"

////////////////////////////////////////////////////////////////////////////////
//---------------------------- HARD TIME: ANIMATIONS ---------------------------
////////////////////////////////////////////////////////////////////////////////

//-----------------------------------------------------------------
///////////////////// LOAD MOVE SEQUENCES /////////////////////////
//-----------------------------------------------------------------
LoadMoveSequences :: proc(cyc: i32) {
	//application
	pSeq[cyc][200] = bb.ExtractAnimSeq(p[cyc], 1650, 1720, pSeq[cyc][603]) //standing grapple lunge
	pSeq[cyc][201] = bb.ExtractAnimSeq(p[cyc], 1730, 1800, pSeq[cyc][603]) //ground grapple lunge
	pSeq[cyc][202] = bb.ExtractAnimSeq(p[cyc], 60, 100, pSeq[cyc][610]) //apply headlock [execute]
	pSeq[cyc][203] = bb.ExtractAnimSeq(p[cyc], 60, 100, pSeq[cyc][611]) //apply headlock [receive]
	pSeq[cyc][204] = bb.ExtractAnimSeq(p[cyc], 320, 400, pSeq[cyc][610]) //pick up from floor [execute]
	pSeq[cyc][205] = bb.ExtractAnimSeq(p[cyc], 320, 400, pSeq[cyc][611]) //pick up from floor [receive]
	pSeq[cyc][206] = bb.ExtractAnimSeq(p[cyc], 110, 150, pSeq[cyc][610]) //hold headlock [execute]
	pSeq[cyc][207] = bb.ExtractAnimSeq(p[cyc], 110, 150, pSeq[cyc][611]) //hold headlock [receive]
	pSeq[cyc][208] = bb.ExtractAnimSeq(p[cyc], 250, 310, pSeq[cyc][610]) //headlock movement [execute]
	pSeq[cyc][209] = bb.ExtractAnimSeq(p[cyc], 250, 310, pSeq[cyc][611]) //headlock movement [receive]
	//actions
	pSeq[cyc][210] = bb.ExtractAnimSeq(p[cyc], 160, 240, pSeq[cyc][610]) //release headlock [execute]
	pSeq[cyc][211] = bb.ExtractAnimSeq(p[cyc], 160, 240, pSeq[cyc][611]) //release headlock [receive]
	pSeq[cyc][212] = bb.ExtractAnimSeq(p[cyc], 410, 450, pSeq[cyc][610]) //headlock punch [execute]
	pSeq[cyc][213] = bb.ExtractAnimSeq(p[cyc], 410, 450, pSeq[cyc][611]) //headlock punch [receive]
	pSeq[cyc][214] = bb.ExtractAnimSeq(p[cyc], 460, 500, pSeq[cyc][610]) //knee to face [execute]
	pSeq[cyc][215] = bb.ExtractAnimSeq(p[cyc], 460, 500, pSeq[cyc][611]) //knee to face [receive]
	pSeq[cyc][216] = bb.ExtractAnimSeq(p[cyc], 510, 650, pSeq[cyc][610]) //headlock takedown [execute]
	pSeq[cyc][217] = bb.ExtractAnimSeq(p[cyc], 510, 650, pSeq[cyc][611]) //headlock takedown [receive]
	pSeq[cyc][218] = bb.ExtractAnimSeq(p[cyc], 660, 840, pSeq[cyc][610]) //bodyslam [execute]
	pSeq[cyc][219] = bb.ExtractAnimSeq(p[cyc], 660, 840, pSeq[cyc][611]) //bodyslam [receive]
	pSeq[cyc][220] = bb.ExtractAnimSeq(p[cyc], 850, 1000, pSeq[cyc][610]) //chokeslam [execute]
	pSeq[cyc][221] = bb.ExtractAnimSeq(p[cyc], 850, 1000, pSeq[cyc][611]) //chokeslam [receive]
	pSeq[cyc][222] = bb.ExtractAnimSeq(p[cyc], 1010, 1185, pSeq[cyc][610]) //bulldog [execute]
	pSeq[cyc][223] = bb.ExtractAnimSeq(p[cyc], 1010, 1185, pSeq[cyc][611]) //bulldog [receive]
	pSeq[cyc][224] = bb.ExtractAnimSeq(p[cyc], 1195, 1350, pSeq[cyc][610]) //push off [execute]
	pSeq[cyc][225] = bb.ExtractAnimSeq(p[cyc], 1195, 1350, pSeq[cyc][611]) //push off [receive]
	pSeq[cyc][226] = bb.ExtractAnimSeq(p[cyc], 1360, 1520, pSeq[cyc][610]) //kick throw [execute]
	pSeq[cyc][227] = bb.ExtractAnimSeq(p[cyc], 1360, 1520, pSeq[cyc][611]) //kick throw [receive]
}


//-----------------------------------------------------------------
/////////////////////// MOVE ANIMATIONS ///////////////////////////
//-----------------------------------------------------------------
MoveAnims :: proc(cyc: i32) {
	v: i32
	randy: i32
	//------------- HOLDING -------------
	switch pAnim[cyc] {
	case 200:
		// standing grapple lunge
		if pAnimTim[cyc] == 0 do bb.Animate(p[cyc], 3, 3.0, pSeq[cyc][200], 5)
		if pAnimTim[cyc] == 6 do ProduceSound(p[cyc], sSwing, 22050, bb.RndF(0.2, 0.5))
		if pAnimTim[cyc] <= 15 {
			FaceEntity(cyc, p[pFoc[cyc]], 10)
			bb.RotateEntity(pPivot[cyc], 0, pA[cyc], 0)
			bb.MoveEntity(pPivot[cyc], 0, 0, 0.5)
			pStepTim[cyc] += bb.RndI(0, 1)
		}
		if pAnimTim[cyc] >= 8 \
		&& pAnimTim[cyc] <= 13 \
		&& pScar[cyc][4] <= 4 \
		&& pGrappling[cyc] == 0 {
			for v_trg in 1 ..=no_plays {
				if cyc != v_trg \
				&& (cast(bool)Friendly(cyc, v_trg) == false || v_trg == pFoc[cyc]) \
				&& cast(bool)InProximity(cyc, v_trg, 20) \
				&& pY[cyc] > pY[v_trg] - 30 \
				&& pY[cyc] < pY[v_trg] + 5 \
				&& AttackViable(v_trg) >= 1 \
				&& AttackViable(v_trg) <= 2 \
				&& pGrappling[cyc] == 0 \
				&& pGrappling[v_trg] == 0 \
				&& pGrappler[v_trg] == 0 \
				&& pSeat[v_trg] == 0 \
				&& pBed[v_trg] == 0 {
					if cast(bool)InRange(cyc, v_trg, 6) {
						charAttacker[pChar[v_trg]] = pChar[cyc]
						ProduceSound(p[v_trg], sImpact[bb.RndI(4, 5)], 22050, 0)
						if pHealth[v_trg] > 0 do ProduceSound(p[v_trg], sPain[bb.RndI(1, 8)], 22050, 0)
						ChangeAnim(cyc, 203)
						ChangeAnim(v_trg, 202)
						pGrappling[cyc] = v_trg
						pGrappler[v_trg] = cyc
						FixGrapple(cyc, v_trg)
						pOldMoveX[v_trg] = bb.EntityX(pLimb[cyc][30], 1)
						pOldMoveZ[v_trg] = bb.EntityZ(pLimb[cyc][30], 1)
						RiskAnger(cyc, v_trg)
						GainStrength(cyc, 50)
						DamageRep(cyc, v_trg, 0)
					}
				}
			}
		}
		if pAnimTim[cyc] > 26 do ChangeAnim(cyc, 0)

	case 201:
		// ground grapple lunge
		if pAnimTim[cyc] == 0 do bb.Animate(p[cyc], 3, 3.0, pSeq[cyc][201], 5)
		if pAnimTim[cyc] == 6 do ProduceSound(p[cyc], sSwing, 22050, bb.RndF(0.2, 0.5))
		if pAnimTim[cyc] <= 15 {
			FaceEntity(cyc, p[pFoc[cyc]], 10)
			bb.RotateEntity(pPivot[cyc], 0, pA[cyc], 0)
			bb.MoveEntity(pPivot[cyc], 0, 0, 0.25)
			pStepTim[cyc] += bb.RndI(0, 1)
		}
		if pAnimTim[cyc] >= 10 \
		&& pAnimTim[cyc] <= 13 \
		&& pScar[cyc][4] <= 4 \
		&& pGrappling[cyc] == 0 {
			for v_trg in 1 ..= no_plays {
				if cyc != v_trg \
				&& (cast(bool)Friendly(cyc, v_trg) == false || v_trg == pFoc[cyc]) \
				&& cast(bool)InProximity(cyc, v_trg, 30) \
				&& pY[cyc] > pY[v_trg] - 30 \
				&& pY[cyc] < pY[v_trg] + 5 \
				&& AttackViable(v_trg) == 3 \
				&& pHealth[v_trg] > 0 \
				&& pGrappling[cyc] == 0 \
				&& pGrappler[v_trg] == 0 \
				&& pSeat[v_trg] == 0 \
				&& pBed[v_trg] == 0 {
					if cast(bool)InRange(cyc, v_trg, 8) {
						charAttacker[pChar[v_trg]] = pChar[cyc]
						ProduceSound(p[v_trg], sImpact[bb.RndI(4, 5)], 22050, 0)
						if pHealth[v_trg] > 0 do ProduceSound(p[v_trg], sPain[bb.RndI(1, 8)], 22050, 0)
						ChangeAnim(cyc, 204)
						ChangeAnim(v_trg, 202)
						randy = bb.RndI(0, (150 - charAgility[pChar[v_trg]]) * 3)
						if randy <= 25 {
							if cast(bool)DirPressed(v_trg) || cast(bool)ActionPressed(v_trg) || pControl[v_trg] == 0 do ChangeAnim(cyc, 218)
						}
						pGrappling[cyc] = v_trg
						pGrappler[v_trg] = cyc
						FixGrapple(cyc, v_trg)
						pOldMoveX[v_trg] = bb.EntityX(pLimb[cyc][30], 1)
						pOldMoveZ[v_trg] = bb.EntityZ(pLimb[cyc][30], 1)
						RiskAnger(cyc, v_trg)
						if pAnim[cyc] != 218 {
							DamageRep(cyc, v_trg, 0)
							GainStrength(cyc, 50)
						}
					}
				}
			}
		}
		if pAnimTim[cyc] > 26 do ChangeAnim(cyc, 0)

	case 202:
		// move victim
		v = pGrappler[cyc]
		if pAnim[v] < 200 {
			ChangeAnim(cyc, 71)
			SharpTransition(cyc, 71, 0)
			pGrappling[v] = 0
			pGrappler[cyc] = 0
		}
	case 203:
		// apply headlock
		v = pGrappling[cyc]
		if pAnimTim[cyc] == 0 {
			bb.Animate(p[cyc], 3, 2.5, pSeq[cyc][202], 0)
			bb.Animate(p[v], 3, 2.5, pSeq[v][203], 0)
		}
		if pAnimTim[cyc] == 4 || pAnimTim[cyc] == 12 do ProduceSound(p[cyc], sShuffle[bb.RndI(1, 3)], 22050, 0)
		if pAnimTim[cyc] == 8 || pAnimTim[cyc] == 16 do pStepTim[cyc] = 99
		if pAnimTim[cyc] > 16 {
			ChangeAnim(cyc, 205)
			randy = bb.RndI(0, (150 - charStrength[pChar[v]]) * 3)
			if randy <= 25 {
				if cast(bool)DirPressed(v) || cast(bool)ActionPressed(v) || pControl[v] == 0 do ChangeAnim(cyc, 217)
			}
		}
		DropWeapon(v, 5)
	case 204:
		// pick up from floor
		v = pGrappling[cyc]
		if pAnimTim[cyc] == 0 {
			bb.Animate(p[cyc], 3, 2.0, pSeq[cyc][204], 0)
			bb.Animate(p[v], 3, 2.0, pSeq[v][205], 0)
		}
		if pAnimTim[cyc] == 5 || pAnimTim[cyc] == 15 || pAnimTim[cyc] == 25 || pAnimTim[cyc] == 35 do ProduceSound(p[cyc], sShuffle[bb.RndI(1, 3)], 22050, 0)
		if pAnimTim[cyc] == 10 || pAnimTim[cyc] == 20 || pAnimTim[cyc] == 30 || pAnimTim[cyc] == 40 do pStepTim[cyc] = 99
		if pAnimTim[cyc] > 40 {
			ChangeAnim(cyc, 205)
			pHP[v] = bb.RndI(-2, 5)
			randy = bb.RndI(0, (150 - charStrength[pChar[v]]) * 3)
			if randy <= 25 {
				if cast(bool)DirPressed(v) || cast(bool)ActionPressed(v) || pControl[v] == 0 do ChangeAnim(cyc, 217)
			}
		}
		DropWeapon(v, 5)
	case 205:
		// hold headlock
		v = pGrappling[cyc]
		if pAnimTim[cyc] == 0 {
			bb.Animate(p[cyc], 1, 0.5, pSeq[cyc][206], 5)
			bb.Animate(p[v], 1, 0.5, pSeq[v][207], 5)
		}
		FixGrapple(cyc, v)
		if cast(bool)DirPressed(cyc) do ChangeAnim(cyc, 206)
		FindMoveCommands(cyc)
		DropWeapon(v, 0)
	case 206:
		// headlock movement
		v = pGrappling[cyc]
		if pAnimTim[cyc] == 0 {
			bb.Animate(p[cyc], 1, 1.5, pSeq[cyc][208], 5)
			bb.Animate(p[v], 1, 1.5, pSeq[v][209], 5)
		}
		if cast(bool)cLeft[cyc] do pA[cyc] = CleanAngle(pA[cyc] + 1)
		if cast(bool)cRight[cyc] do pA[cyc] = CleanAngle(pA[cyc] - 1)
		if cast(bool)VerticalPressed(cyc) {
			bb.RotateEntity(pPivot[cyc], 0, pA[cyc], 0)
			if cast(bool)cUp[cyc] do bb.MoveEntity(pPivot[cyc], 0, 0, -0.3)
			if cast(bool)cDown[cyc] do bb.MoveEntity(pPivot[cyc], 0, 0, 0.15)
		}
		FixGrapple(cyc, v)
		if pAnimTim[cyc] > 5 && cast(bool)DirPressed(cyc) == false do ChangeAnim(cyc, 205)
		FindMoveCommands(cyc)
		pStepTim[cyc] += 1
	case 210:
		// release headlock
		v = pGrappling[cyc]
		if pAnimTim[cyc] == 0 {
			bb.Animate(p[cyc], 3, 3.0, pSeq[cyc][210], 0)
			bb.Animate(p[v], 3, 3.0, pSeq[v][211], 0)
		}
		if pAnimTim[cyc] == 10 || pAnimTim[cyc] == 20 do ProduceSound(p[cyc], sShuffle[bb.RndI(1, 3)], 22050, 0)
		if pAnimTim[cyc] == 5 || pAnimTim[cyc] == 15 do pStepTim[cyc] = 99
		if pAnimTim[cyc] > 26 {
			charReputation[pChar[cyc]] -= 1
			ChangeAnim(cyc, 0)
			SharpTransition(cyc, 1, 0)
			ChangeAnim(v, 0)
			SharpTransition(v, 1, 180)
			pGrappling[cyc] = 0
			pGrappler[v] = 0
		}
	case 211:
		// headlock punch
		v = pGrappling[cyc]
		if pAnimTim[cyc] == 0 {
			bb.Animate(p[cyc], 1, 2.5, pSeq[cyc][212], 0)
			bb.Animate(p[v], 1, 2.5, pSeq[v][213], 0)
		}
		if pAnimTim[cyc] == 7 do ProduceSound(p[cyc], sSwing, 22050, bb.RndF(0.1, 0.3))
		if pAnimTim[cyc] == 12 {
			ProduceSound(p[cyc], sImpact[bb.RndI(1, 2)], 22050, 0)
			if pHealth[v] > 0 do ProduceSound(p[cyc], sPain[bb.RndI(1, 8)], 22050, 0)
			CreateSpurt(
				bb.EntityX(pLimb[cyc][6], 1),
				bb.EntityY(pLimb[cyc][6], 1),
				bb.EntityZ(pLimb[cyc][6], 1),
				1,
				5,
				99,
			)
			ScarLimb(v, 1, 10)
			pDT[v] = (150 - pHealth[v]) * 2
			pHealth[v] -= 1
			pHP[v] -= 1
			WeaponImpact(cyc, v, 0)
			DropWeapon(cyc, 5)
			RiskAnger(cyc, v)
			GainStrength(cyc, 50)
			DamageRep(cyc, v, 0)
		}
		if pAnimTim[cyc] >= 16 {
			pAnimTim[cyc] = 0
			if (cAttack[cyc] == 0 || DirPressed(cyc) == 0) && pHP[v] > 0 do ChangeAnim(cyc, 205)
			if pHP[v] <= 0 do ChangeAnim(cyc, 210)
			randy = bb.RndI(0, (150 - charStrength[pChar[v]]) * 3)
			if pAnim[cyc] == 211 && randy <= 10 {
				if cast(bool)DirPressed(v) || cast(bool)ActionPressed(v) || pControl[v] == 0 do ChangeAnim(cyc, 217)
			}
		}
	case 212:
		// knee to face
		v = pGrappling[cyc]
		if pAnimTim[cyc] == 0 {
			bb.Animate(p[cyc], 1, 2.25, pSeq[cyc][214], 0)
			bb.Animate(p[v], 1, 2.25, pSeq[v][215], 0)
		}
		if pAnimTim[cyc] == 4 do ProduceSound(p[cyc], sSwing, 22050, bb.RndF(0.2, 0.5))
		if pAnimTim[cyc] == 9 {
			randy = bb.RndI(1, 2)
			if randy == 1 do ProduceSound(p[cyc], sImpact[3], 22050, 0)
			if randy == 2 do ProduceSound(p[cyc], sImpact[6], 22050, 0)
			if pHealth[v] > 0 do ProduceSound(p[cyc], sPain[bb.RndI(1, 8)], 22050, 0)
			CreateSpurt(
				bb.EntityX(pLimb[cyc][35], 1),
				bb.EntityY(pLimb[cyc][35], 1),
				bb.EntityZ(pLimb[cyc][35], 1),
				1,
				5,
				99,
			)
			ScarLimb(v, 1, 10)
			pDT[v] = (150 - pHealth[v]) * 2
			pHealth[v] -= 1
			pHP[v] -= 1
			WeaponImpact(cyc, v, 0)
			DropWeapon(cyc, 5)
			RiskAnger(cyc, v)
			GainStrength(cyc, 50)
			DamageRep(cyc, v, 0)
		}
		if pAnimTim[cyc] >= 18 {
			pAnimTim[cyc] = 0
			if (cAttack[cyc] == 0 || cast(bool)DirPressed(cyc)) && pHP[v] > 0 do ChangeAnim(cyc, 205)
			if pHP[v] <= 0 do ChangeAnim(cyc, 210)
			randy = bb.RndI(0, (150 - charStrength[pChar[v]]) * 3)
			if pAnim[cyc] == 212 && randy <= 10 {
				if cast(bool)DirPressed(v) || cast(bool)ActionPressed(v) || pControl[v] == 0 do ChangeAnim(cyc, 217)
			}
		}
	case 213:
		// headlock takedown
		v = pGrappling[cyc]
		if pAnimTim[cyc] == 0 {
			bb.Animate(p[cyc], 3, 3.0, pSeq[cyc][216], 0)
			bb.Animate(p[v], 3, 3.0, pSeq[v][217], 0)
		}
		if pAnimTim[cyc] == 1 || pAnimTim[cyc] == 30 do ProduceSound(p[cyc], sShuffle[bb.RndI(1, 3)], 22050, 0)
		if pAnimTim[cyc] == 40 do pStepTim[cyc] = 99
		if pAnimTim[cyc] == 10 do ProduceSound(p[cyc], sSwing, 22050, 0)
		if pAnimTim[cyc] == 20 {
			ProduceSound(p[cyc], sFall, 22050, 0)
			ProduceSound(p[cyc], sThud, 22050, 0)
			ProduceSound(p[cyc], sImpact[6], 22050, 0)
			ProduceSound(p[cyc], sPain[bb.RndI(1, 8)], 22050, 0)
			pHealth[v] -= GetPower(cyc) * 3
			pDT[v] = (150 - pHealth[v]) * 2
			pHP[v] = 0
			pHP[cyc] -= bb.RndI(0, 1)
			RiskInjury(v, 100)
			ScarArea(v, 0, 0, 0, 10)
			FindSmashes(cyc)
			FindSmashes(v)
			WeaponImpact(cyc, v, 0)
			DropWeapon(cyc, 5)
			RiskAnger(cyc, v)
			GainStrength(cyc, 10)
			DamageRep(cyc, v, 1)
		}
		if pAnimTim[cyc] > 46 {
			ChangeAnim(cyc, 0)
			SharpTransition(cyc, 1, 180)
			ChangeAnim(v, 81)
			SharpTransition(v, 81, 180)
			pGrappling[cyc] = 0
			pGrappler[v] = 0
		}
	case 214:
		// bodyslam
		v = pGrappling[cyc]
		if pAnimTim[cyc] == 0 {
			bb.Animate(p[cyc], 3, 3.0, pSeq[cyc][218], 0)
			bb.Animate(p[v], 3, 3.0, pSeq[v][219], 0)
		}
		if pAnimTim[cyc] == 10 || pAnimTim[cyc] == 20 do ProduceSound(p[cyc], sShuffle[bb.RndI(1, 3)], 22050, 0)
		if pAnimTim[cyc] == 5 || pAnimTim[cyc] == 15 do pStepTim[cyc] = 99
		if pAnimTim[cyc] == 25 do ProduceSound(p[cyc], sSwing, 22050, 0)
		if pAnimTim[cyc] == 46 {
			ProduceSound(p[cyc], sFall, 22050, 0)
			ProduceSound(p[cyc], sThud, 22050, 0)
			ProduceSound(p[cyc], sImpact[6], 22050, 0)
			ProduceSound(p[cyc], sPain[bb.RndI(1, 8)], 22050, 0)
			pHealth[v] -= GetPower(cyc) * 3
			pDT[v] = (150 - pHealth[v]) * 2
			pHP[v] = 0
			pHP[cyc] -= bb.RndI(0, 1)
			RiskInjury(v, 100)
			ScarArea(v, 0, 0, 0, 10)
			FindSmashes(v)
			WeaponImpact(cyc, v, 0)
			DropWeapon(cyc, 5)
			RiskAnger(cyc, v)
			GainStrength(cyc, 10)
			DamageRep(cyc, v, 1)
		}
		if pAnimTim[cyc] > 60 {
			ChangeAnim(cyc, 0)
			SharpTransition(cyc, 1, 0.1)
			ChangeAnim(v, 81)
			SharpTransition(v, 81, 0.1)
			pGrappling[cyc] = 0
			pGrappler[v] = 0
		}
	case 215:
		// chokeslam
		v = pGrappling[cyc]
		if pAnimTim[cyc] == 0 {
			bb.Animate(p[cyc], 3, 3.75, pSeq[cyc][220], 0)
			bb.Animate(p[v], 3, 3.75, pSeq[v][221], 0)
		}
		if pAnimTim[cyc] == 6 || pAnimTim[cyc] == 12 do ProduceSound(p[cyc], sShuffle[bb.RndI(1, 3)], 22050, 0)
		if pAnimTim[cyc] == 3 || pAnimTim[cyc] == 9 do pStepTim[cyc] = 99
		if pAnimTim[cyc] == 12 do ProduceSound(p[cyc], sSwing, 22050, 0)
		if pAnimTim[cyc] == 26 {
			ProduceSound(p[cyc], sFall, 22050, 0)
			ProduceSound(p[cyc], sThud, 22050, 0)
			ProduceSound(p[cyc], sImpact[3], 22050, 0)
			ProduceSound(p[cyc], sPain[bb.RndI(1, 8)], 22050, 0)
			pHealth[v] -= GetPower(cyc) * 3
			pDT[v] = (150 - pHealth[v]) * 2
			pHP[v] = 0
			pHP[cyc] -= bb.RndI(0, 1)
			RiskInjury(v, 100)
			ScarArea(v, 0, 0, 0, 10)
			FindSmashes(v)
			WeaponImpact(cyc, v, 0)
			DropWeapon(cyc, 5)
			RiskAnger(cyc, v)
			GainStrength(cyc, 10)
			DamageRep(cyc, v, 1)
		}
		if pAnimTim[cyc] > 40 {
			ChangeAnim(cyc, 0)
			SharpTransition(cyc, 1, 90)
			ChangeAnim(v, 81)
			SharpTransition(v, 81, 270)
			pGrappling[cyc] = 0
			pGrappler[v] = 0
		}
	case 216:
		// bulldog
		v = pGrappling[cyc]
		if pAnimTim[cyc] == 0 {
			bb.Animate(p[cyc], 3, 3.0, pSeq[cyc][222], 0)
			bb.Animate(p[v], 3, 3.0, pSeq[v][223], 0)
		}
		if pAnimTim[cyc] == 7 do ProduceSound(p[cyc], sShuffle[bb.RndI(1, 3)], 22050, 0)
		if pAnimTim[cyc] == 48 || pAnimTim[cyc] == 58 do pStepTim[cyc] = 99
		if pAnimTim[cyc] == 13 do ProduceSound(p[cyc], sSwing, 22050, 0)
		if pAnimTim[cyc] == 26 {
			ProduceSound(p[cyc], sFall, 22050, 0)
			ProduceSound(p[cyc], sThud, 22050, 0)
			ProduceSound(p[cyc], sImpact[6], 22050, 0)
			ProduceSound(p[cyc], sPain[bb.RndI(1, 8)], 22050, 0)
			pHealth[v] -= GetPower(cyc) * 3
			pDT[v] = (150 - pHealth[v]) * 2
			pHP[v] = 0
			pHP[cyc] -= bb.RndI(0, 1)
			RiskInjury(v, 100)
			ScarArea(v, 0, 0, 0, 10)
			FindSmashes(cyc)
			FindSmashes(v)
			WeaponImpact(cyc, v, 0)
			DropWeapon(cyc, 5)
			RiskAnger(cyc, v)
			GainStrength(cyc, 10)
			DamageRep(cyc, v, 1)
		}
		if pAnimTim[cyc] > 58 {
			ChangeAnim(cyc, 0)
			SharpTransition(cyc, 1, 0)
			ChangeAnim(v, 84)
			SharpTransition(v, 84, 0)
			pGrappling[cyc] = 0
			pGrappler[v] = 0
		}
	case 217:
		// push off
		v = pGrappling[cyc]
		if pAnimTim[cyc] == 0 {
			bb.Animate(p[cyc], 3, 3.5, pSeq[cyc][224], 0)
			bb.Animate(p[v], 3, 3.5, pSeq[v][225], 0)
		}
		if pAnimTim[cyc] == 5 {
			ProduceSound(p[cyc], sShuffle[bb.RndI(1, 3)], 22050, 0)
			pStepTim[cyc] = 99
		}
		if pAnimTim[cyc] == 14 {
			ProduceSound(p[cyc], sSwing, 22050, 0)
			if pHealth[cyc] > 0 do ProduceSound(p[cyc], sPain[bb.RndI(1, 8)], 22050, 0)
		}
		if pAnimTim[cyc] == 30 {
			charAttacker[pChar[cyc]] = pChar[v]
			ProduceSound(p[cyc], sFall, 22050, 0)
			ProduceSound(p[cyc], sThud, 22050, 0)
			ProduceSound(p[cyc], sPain[bb.RndI(1, 8)], 22050, 0)
			pHealth[cyc] -= GetPower(v) * 2
			pDT[cyc] = (100 - pHealth[cyc]) * 2
			pHP[cyc] = 0
			pHP[v] -= bb.RndI(0, 1)
			RiskInjury(cyc, 100)
			ScarArea(cyc, 0, 0, 0, 10)
			FindSmashes(cyc)
			DropWeapon(cyc, 0)
			RiskAnger(v, cyc)
			GainStrength(v, 10)
			DamageRep(v, cyc, 1)
		}
		if pAnimTim[cyc] > 44 {
			ChangeAnim(cyc, 84)
			SharpTransition(cyc, 84, 0)
			ChangeAnim(v, 0)
			SharpTransition(v, 1, 180)
			pGrappling[cyc] = 0
			pGrappler[v] = 0
		}
	case 218:
		// ground throw
		v = pGrappling[cyc]
		if pAnimTim[cyc] == 0 {
			bb.Animate(p[cyc], 3, 3.0, pSeq[cyc][226], 0)
			bb.Animate(p[v], 3, 3.0, pSeq[v][227], 0)
		}
		if pAnimTim[cyc] == 6 || pAnimTim[cyc] == 38 do ProduceSound(p[cyc], sShuffle[bb.RndI(1, 3)], 22050, 0)
		if pAnimTim[cyc] == 45 || pAnimTim[cyc] == 53 do pStepTim[cyc] = 99
		if pAnimTim[cyc] == 6 do ProduceSound(p[cyc], sPain[bb.RndI(1, 8)], 22050, 0)
		if pAnimTim[cyc] == 16 do ProduceSound(p[cyc], sSwing, 22050, 0)
		if pAnimTim[cyc] == 31 {
			charAttacker[pChar[cyc]] = pChar[v]
			ProduceSound(p[cyc], sFall, 22050, 0)
			ProduceSound(p[cyc], sThud, 22050, 0)
			ProduceSound(p[cyc], sPain[bb.RndI(1, 8)], 22050, 0)
			pHealth[cyc] -= GetPower(v) * 3
			pDT[cyc] = (150 - pHealth[cyc]) * 2
			pHP[cyc] = 0
			pHP[v] = bb.RndI(1, 10)
			RiskInjury(cyc, 100)
			ScarArea(cyc, 0, 0, 0, 10)
			FindSmashes(cyc)
			DropWeapon(cyc, 0)
			RiskAnger(v, cyc)
			GainStrength(v, 10)
			DamageRep(v, cyc, 1)
		}
		if pAnimTim[cyc] > 53 {
			ChangeAnim(cyc, 81)
			SharpTransition(cyc, 81, 0)
			ChangeAnim(v, 0)
			SharpTransition(v, 1, 0)
			pGrappling[cyc] = 0
			pGrappler[v] = 0
		}
	}
}

//--------------------------------------------------------------
//////////////////// RELATED FUNCTIONS /////////////////////////
//--------------------------------------------------------------

//FIX GRAPPLE
FixGrapple :: proc(cyc: i32, v: i32) {
	//copy positions
	pX[v] = pX[cyc]
	pZ[v] = pZ[cyc]
	pOldX[v] = pX[v]
	pOldZ[v] = pZ[v]
	bb.ResetEntity(pPivot[v])
	bb.PositionEntity(
		pPivot[v],
		bb.EntityX(pPivot[cyc]),
		bb.EntityY(pPivot[cyc]),
		bb.EntityZ(pPivot[cyc]),
	)
	bb.EntityType(pPivot[v], 1, 0)
	bb.EntityRadius(pPivot[v], 8, 18)
	//same orientation
	pA[v] = pA[cyc]
	pHurtA[v] = pA[cyc]
	bb.RotateEntity(pPivot[v], 0, pA[v], 0)
	//discomfort
	randy := bb.RndI(0, 50)
	if randy == 0 {
		ProduceSound(p[v], sShuffle[bb.RndI(1, 3)], 22050, 0)
		ProduceSound(p[v], sPain[bb.RndI(1, 8)], 22050, bb.RndF(0.1, 0.5))
	}
}


//FIND MOVE COMMANDS
FindMoveCommands :: proc(cyc: i32) {
	//CPU choices
	move: i32 = 0
	v: i32 = pGrappling[cyc]
	randy: i32
	if pControl[cyc] == 0 || charBreakdown[pChar[cyc]] > 0 {
		randy = bb.RndI(0, 100)
		if randy <= 10 do move = bb.RndI(210, 216)
			if cast(bool)Friendly(cyc, v) && charBreakdown[pChar[cyc]] == 0 do move = 210
	}
	//human input
	if pControl[cyc] > 0 {
		if cast(bool)cThrow[cyc] do move = 210 //release
		if cast(bool)cAttack[cyc] && cast(bool)DirPressed(cyc) do move = 211 //punch
		if cast(bool)cAttack[cyc] && DirPressed(cyc) == 0 do move = 212 //knee
		if cast(bool)cDefend[cyc] && cast(bool)DirPressed(cyc) do move = 214 //bodyslam
		if cast(bool)cDefend[cyc] && DirPressed(cyc) == 0 do move = 215 //chokeslam
		if cast(bool)cPickUp[cyc] && cast(bool)DirPressed(cyc) do move = 216 //bulldog
		if cast(bool)cPickUp[cyc] && DirPressed(cyc) == 0 do move = 213 //headlock takedown
	}
	//find counters
	randy = bb.RndI(0, (150 - charStrength[pChar[v]]) * 3)
	if randy <= 1 || (randy <= 50 && move > 0) {
		if cast(bool)DirPressed(v) || cast(bool)ActionPressed(v) || pControl[v] == 0 do move = 217
	}
	//trigger arrests
	if charRole[pChar[cyc]] == 1 \
	&& pChar[v] == gamChar[slot] \
	&& gamWarrant[slot] > 0 \
	&& gamPromo == 0 {
		randy = bb.RndI(0, 4)
		if randy == 0 && gamMoney[slot] > 100 {
			TriggerPromo(cyc, v, 52)
		} else {
			TriggerPromo(cyc, v, 100 + gamWarrant[slot])
		}
	}
	//execute move
	if cyc != promoActor[1] \
	&& cyc != promoActor[2] \
	&& v != promoActor[1] \
	&& v != promoActor[2] {
		if move > 0 do ChangeAnim(cyc, move)
	}
}
