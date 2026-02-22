package main

import bb "blitzbasic3d"
import "core:fmt"

////////////////////////////////////////////////////////////////////////////////
//---------------------------- HARD TIME: ANIMATIONS ---------------------------
////////////////////////////////////////////////////////////////////////////////

//-----------------------------------------------------------------
////////////////// LOAD ANIMATION SEQUENCES ///////////////////////
//-----------------------------------------------------------------
LoadSequences :: proc(cyc: i32) {
	// source files
	pSeq[cyc][601] = bb.LoadAnimSeq(p[cyc], "Characters/Sequences/Standard01.3ds")
	pSeq[cyc][602] = bb.LoadAnimSeq(p[cyc], "Characters/Sequences/Standard02.3ds")
	pSeq[cyc][603] = bb.LoadAnimSeq(p[cyc], "Characters/Sequences/Standard03.3ds")
	pSeq[cyc][604] = bb.LoadAnimSeq(p[cyc], "Characters/Sequences/Standard04.3ds")
	pSeq[cyc][610] = bb.LoadAnimSeq(p[cyc], "Characters/Sequences/Move_Execute.3ds")
	pSeq[cyc][611] = bb.LoadAnimSeq(p[cyc], "Characters/Sequences/Move_Receive.3ds")
	// 0-10: stances
	pSeq[cyc][1] = bb.ExtractAnimSeq(p[cyc], 0, 40, pSeq[cyc][601]) // standing (bare hands)
	pSeq[cyc][2] = bb.ExtractAnimSeq(p[cyc], 1145, 1185, pSeq[cyc][601]) // kneeling (bare hands)
	pSeq[cyc][3] = bb.ExtractAnimSeq(p[cyc], 925, 965, pSeq[cyc][602]) // injured stance
	pSeq[cyc][4] = bb.ExtractAnimSeq(p[cyc], 1065, 1105, pSeq[cyc][602]) // dazed stance
	pSeq[cyc][5] = bb.ExtractAnimSeq(p[cyc], 1980, 2020, pSeq[cyc][603]) // ball stance
	// 10-20: movement
	pSeq[cyc][10] = bb.ExtractAnimSeq(p[cyc], 140, 220, pSeq[cyc][601]) // standing turn
	pSeq[cyc][11] = bb.ExtractAnimSeq(p[cyc], 1195, 1275, pSeq[cyc][601]) // kneeling turn
	pSeq[cyc][12] = bb.ExtractAnimSeq(p[cyc], 915, 995, pSeq[cyc][603]) // walking
	pSeq[cyc][13] = bb.ExtractAnimSeq(p[cyc], 50, 130, pSeq[cyc][601]) // running
	pSeq[cyc][14] = bb.ExtractAnimSeq(p[cyc], 975, 1055, pSeq[cyc][602]) // injured movement
	pSeq[cyc][15] = bb.ExtractAnimSeq(p[cyc], 1115, 1195, pSeq[cyc][602]) // dazed movement
	pSeq[cyc][16] = bb.ExtractAnimSeq(p[cyc], 75, 155, pSeq[cyc][603]) // weapon movement
	pSeq[cyc][17] = bb.ExtractAnimSeq(p[cyc], 30, 110, pSeq[cyc][604]) // ball walk
	pSeq[cyc][18] = bb.ExtractAnimSeq(p[cyc], 120, 200, pSeq[cyc][604]) // ball run
	// 20-30: weapon interaction
	pSeq[cyc][20] = bb.ExtractAnimSeq(p[cyc], 1985, 2045, pSeq[cyc][601]) // pick-up weapon
	pSeq[cyc][21] = bb.ExtractAnimSeq(p[cyc], 65, 75, pSeq[cyc][602]) // drop weapon
	pSeq[cyc][22] = bb.ExtractAnimSeq(p[cyc], 205, 275, pSeq[cyc][602]) // throw weapon
	pSeq[cyc][23] = bb.ExtractAnimSeq(p[cyc], 255, 325, pSeq[cyc][603]) // snatch weapon
	pSeq[cyc][24] = bb.ExtractAnimSeq(p[cyc], 165, 245, pSeq[cyc][603]) // examine weapon
	pSeq[cyc][25] = bb.ExtractAnimSeq(p[cyc], 1860, 1900, pSeq[cyc][603]) // handover
	pSeq[cyc][26] = bb.ExtractAnimSeq(p[cyc], 1910, 1970, pSeq[cyc][603]) // basketball throw
	pSeq[cyc][27] = bb.ExtractAnimSeq(p[cyc], 400, 440, pSeq[cyc][604]) // phone pick-up
	// 30-40: hand-2-hand attacks
	pSeq[cyc][30] = bb.ExtractAnimSeq(p[cyc], 250, 320, pSeq[cyc][601]) // upper punch
	pSeq[cyc][31] = bb.ExtractAnimSeq(p[cyc], 1060, 1135, pSeq[cyc][601]) // lower kick
	pSeq[cyc][32] = bb.ExtractAnimSeq(p[cyc], 1405, 1455, pSeq[cyc][601]) // stomp
	pSeq[cyc][33] = bb.ExtractAnimSeq(p[cyc], 1675, 1745, pSeq[cyc][601]) // big attack
	pSeq[cyc][34] = bb.ExtractAnimSeq(p[cyc], 1775, 1875, pSeq[cyc][601]) // rear attack
	pSeq[cyc][35] = bb.ExtractAnimSeq(p[cyc], 105, 175, pSeq[cyc][602]) // rising attack
	// 40-50: weapon swings
	pSeq[cyc][40] = bb.ExtractAnimSeq(p[cyc], 305, 375, pSeq[cyc][602]) // upper swing
	pSeq[cyc][41] = bb.ExtractAnimSeq(p[cyc], 405, 485, pSeq[cyc][602]) // lower swing
	pSeq[cyc][42] = bb.ExtractAnimSeq(p[cyc], 745, 815, pSeq[cyc][602]) // ground swing
	pSeq[cyc][43] = bb.ExtractAnimSeq(p[cyc], 515, 585, pSeq[cyc][602]) // big swing
	pSeq[cyc][44] = bb.ExtractAnimSeq(p[cyc], 615, 715, pSeq[cyc][602]) // rear swing
	// 50-60: weapon stabs
	pSeq[cyc][51] = bb.ExtractAnimSeq(p[cyc], 335, 425, pSeq[cyc][603]) // quick stab
	pSeq[cyc][52] = bb.ExtractAnimSeq(p[cyc], 555, 625, pSeq[cyc][603]) // ground stab
	pSeq[cyc][53] = bb.ExtractAnimSeq(p[cyc], 455, 525, pSeq[cyc][603]) // big stab
	// 60-70: gun fire
	pSeq[cyc][60] = bb.ExtractAnimSeq(p[cyc], 1405, 1445, pSeq[cyc][602]) // rifle stance
	pSeq[cyc][61] = bb.ExtractAnimSeq(p[cyc], 1005, 1085, pSeq[cyc][603]) // rifle walk
	pSeq[cyc][62] = bb.ExtractAnimSeq(p[cyc], 1455, 1535, pSeq[cyc][602]) // rifle running
	pSeq[cyc][63] = bb.ExtractAnimSeq(p[cyc], 1545, 1585, pSeq[cyc][602]) // rifle fire
	pSeq[cyc][64] = bb.ExtractAnimSeq(p[cyc], 1735, 1795, pSeq[cyc][602]) // pistol fire
	pSeq[cyc][65] = bb.ExtractAnimSeq(p[cyc], 1645, 1725, pSeq[cyc][602]) // reload
	// 70-80: hurting & blocking
	pSeq[cyc][70] = bb.ExtractAnimSeq(p[cyc], 340, 390, pSeq[cyc][601]) // upper hurt
	pSeq[cyc][71] = bb.ExtractAnimSeq(p[cyc], 1320, 1380, pSeq[cyc][601]) // lower hurt
	pSeq[cyc][72] = bb.ExtractAnimSeq(p[cyc], 1490, 1550, pSeq[cyc][601]) // ground hurt (on back)
	pSeq[cyc][73] = bb.ExtractAnimSeq(p[cyc], 1575, 1645, pSeq[cyc][601]) // ground hurt (on front)
	pSeq[cyc][74] = bb.ExtractAnimSeq(p[cyc], 1885, 1925, pSeq[cyc][601]) // upper block
	pSeq[cyc][75] = bb.ExtractAnimSeq(p[cyc], 1935, 1975, pSeq[cyc][601]) // lower block
	pSeq[cyc][76] = bb.ExtractAnimSeq(p[cyc], 825, 865, pSeq[cyc][602]) // upper weapon block
	pSeq[cyc][77] = bb.ExtractAnimSeq(p[cyc], 875, 915, pSeq[cyc][602]) // lower weapon block
	pSeq[cyc][78] = bb.ExtractAnimSeq(p[cyc], 450, 595, pSeq[cyc][604]) // die (on back)
	pSeq[cyc][79] = bb.ExtractAnimSeq(p[cyc], 610, 760, pSeq[cyc][604]) // die (on front)
	// 80-90: falling & rising
	pSeq[cyc][80] = bb.ExtractAnimSeq(p[cyc], 415, 500, pSeq[cyc][601]) // fall onto back
	pSeq[cyc][81] = bb.ExtractAnimSeq(p[cyc], 510, 550, pSeq[cyc][601]) // lying on back
	pSeq[cyc][82] = bb.ExtractAnimSeq(p[cyc], 560, 670, pSeq[cyc][601]) // get up off back
	pSeq[cyc][83] = bb.ExtractAnimSeq(p[cyc], 695, 780, pSeq[cyc][601]) // fall onto front (turn)
	pSeq[cyc][84] = bb.ExtractAnimSeq(p[cyc], 790, 830, pSeq[cyc][601]) // lying on front
	pSeq[cyc][85] = bb.ExtractAnimSeq(p[cyc], 840, 910, pSeq[cyc][601]) // get up off front
	pSeq[cyc][86] = bb.ExtractAnimSeq(p[cyc], 935, 1030, pSeq[cyc][601]) // fall onto front (direct)
	pSeq[cyc][87] = bb.ExtractAnimSeq(p[cyc], 635, 675, pSeq[cyc][603]) // falling from a height
	pSeq[cyc][88] = bb.ExtractAnimSeq(p[cyc], 685, 745, pSeq[cyc][603]) // landing from a fall
	// 90-100: standing gestures
	pSeq[cyc][90] = bb.ExtractAnimSeq(p[cyc], 755, 835, pSeq[cyc][603]) // open door
	pSeq[cyc][91] = bb.ExtractAnimSeq(p[cyc], 1095, 1135, pSeq[cyc][603]) // friendly wave
	pSeq[cyc][92] = bb.ExtractAnimSeq(p[cyc], 260, 340, pSeq[cyc][604]) // sweeping
	pSeq[cyc][93] = bb.ExtractAnimSeq(p[cyc], 950, 990, pSeq[cyc][604]) // smoking
	pSeq[cyc][94] = bb.ExtractAnimSeq(p[cyc], 1000, 1040, pSeq[cyc][604]) // injecting
	pSeq[cyc][95] = bb.ExtractAnimSeq(p[cyc], 1050, 1090, pSeq[cyc][604]) // drinking
	pSeq[cyc][96] = bb.ExtractAnimSeq(p[cyc], 1120, 1370, pSeq[cyc][604]) // breakdown
	pSeq[cyc][97] = bb.ExtractAnimSeq(p[cyc], 1380, 1440, pSeq[cyc][604]) // comb hair
	pSeq[cyc][98] = bb.ExtractAnimSeq(p[cyc], 1450, 1510, pSeq[cyc][604]) // admire reflection
	// 100-120: seated gestures
	pSeq[cyc][100] = bb.ExtractAnimSeq(p[cyc], 1145, 1155, pSeq[cyc][603]) // static
	pSeq[cyc][101] = bb.ExtractAnimSeq(p[cyc], 1385, 1425, pSeq[cyc][603]) // slouching
	pSeq[cyc][102] = bb.ExtractAnimSeq(p[cyc], 1215, 1255, pSeq[cyc][603]) // reading
	pSeq[cyc][103] = bb.ExtractAnimSeq(p[cyc], 1265, 1375, pSeq[cyc][603]) // eating
	pSeq[cyc][104] = bb.ExtractAnimSeq(p[cyc], 1435, 1475, pSeq[cyc][603]) // building
	pSeq[cyc][105] = bb.ExtractAnimSeq(p[cyc], 1485, 1515, pSeq[cyc][603]) // lie down
	pSeq[cyc][106] = bb.ExtractAnimSeq(p[cyc], 1515, 1555, pSeq[cyc][603]) // sleeping
	pSeq[cyc][107] = bb.ExtractAnimSeq(p[cyc], 1565, 1620, pSeq[cyc][603]) // get off bed
	pSeq[cyc][108] = bb.ExtractAnimSeq(p[cyc], 1810, 1850, pSeq[cyc][603]) // weight-lifting
	pSeq[cyc][109] = bb.ExtractAnimSeq(p[cyc], 210, 250, pSeq[cyc][604]) // typing
	// 120-130: speaking stances
	pSeq[cyc][120] = bb.ExtractAnimSeq(p[cyc], 350, 390, pSeq[cyc][604]) // holding phone
	pSeq[cyc][121] = bb.ExtractAnimSeq(p[cyc], 755, 835, pSeq[cyc][603]) // hand gestures
	pSeq[cyc][122] = bb.ExtractAnimSeq(p[cyc], 770, 850, pSeq[cyc][604]) // hands on hips
	pSeq[cyc][123] = bb.ExtractAnimSeq(p[cyc], 860, 940, pSeq[cyc][604]) // folded arms
	// 130-200: additional
	pSeq[cyc][130] = bb.ExtractAnimSeq(p[cyc], 1520, 1600, pSeq[cyc][604]) // body changed
	pSeq[cyc][131] = bb.ExtractAnimSeq(p[cyc], 1610, 1650, pSeq[cyc][604]) // mourning
	pSeq[cyc][132] = bb.ExtractAnimSeq(p[cyc], 1660, 1720, pSeq[cyc][604]) // dumbbell curl
	// 200: moves
	LoadMoveSequences(cyc)
}

//----------------------------------------------------------------
//////////////////// MANAGE ANIMATIONS ///////////////////////////
//----------------------------------------------------------------
Animations :: proc(cyc: i32) {
	//----------- 0-10: STANCES ----------
	//standing
	if pAnim[cyc] == 0 {
		anim: i32 = 1
		speeder := bb.RndF(0.1, 0.3)
		if gamPromo > 0 && (cyc == promoActor[1] || cyc == promoActor[2]) && pSpeaking[cyc] == 1 {
			if pPromoState[cyc] > 0 {
				anim = 120 + pPromoState[cyc]
				speeder = bb.RndF(0.25, 0.5)
			}
			if pPromoState[cyc] >= 2 && pPromoState[cyc] <= 3 {
				anim = 120 + pPromoState[cyc]
				speeder = bb.RndF(0.1, 0.3)
			}
			if pWeapon[cyc] > 0 && pPromoState[cyc] >= 2 && pPromoState[cyc] <= 3 {
				anim = 121
				speeder = bb.RndF(0.25, 0.5)
			}
		}
		if pWeapon[cyc] > 0 && weapStyle[weapType[pWeapon[cyc]]] == 4 {
			anim = 60
			speeder = bb.RndF(0.1, 0.3)
		}
		if pInjured[cyc] > 0 || pHealth[cyc] < 10 do anim = 3
		if pDazed[cyc] > 0 {
			anim = 4
			speeder = bb.RndF(0.3, 0.6)
		}
		if pPhone[cyc] > 0 {
			anim = 120
			speeder = bb.RndF(0.1, 0.3)
		}
		relaxed := 0
		if (anim == 1 || anim == 122 || anim == 123) && (pState[cyc] == 1 || pState[cyc] == 122 || pState[cyc] == 123) {
			relaxed = 1
		}
		if pAnimTim[cyc] == 0 || (anim != pState[cyc] && relaxed == 0) {
			bb.Animate(p[cyc], 1, speeder, pSeq[cyc][anim], 10)
			pState[cyc] = anim
		}
		if gotim > 50 && pAnimTim[cyc] > 30 && pWeapon[cyc] > 0 && pPhone[cyc] == 0 && cyc != promoActor[1] && cyc != promoActor[2] {
			if weapName[weapType[pWeapon[cyc]]] == "Broom" {
				ChangeAnim(cyc, 92)
				pAgenda[cyc] = 0
				pTA[cyc] = pA[cyc]
			}
			if charRole[pChar[cyc]] == 0 && weapName[weapType[pWeapon[cyc]]] == "Cigarette" {
				ChangeAnim(cyc, 93)
				pAgenda[cyc] = 0
				pTA[cyc] = pA[cyc]
			}
			if charRole[pChar[cyc]] == 0 && weapName[weapType[pWeapon[cyc]]] == "Syringe" {
				ChangeAnim(cyc, 94)
				pAgenda[cyc] = 0
				pTA[cyc] = pA[cyc]
			}
			if charRole[pChar[cyc]] == 0 && weapName[weapType[pWeapon[cyc]]] == "Bottle" {
				ChangeAnim(cyc, 95)
				pAgenda[cyc] = 0
				pTA[cyc] = pA[cyc]
			}
			if weapName[weapType[pWeapon[cyc]]] == "Comb" {
				ChangeAnim(cyc, 97)
				pAgenda[cyc] = 0
				pTA[cyc] = pA[cyc]
			}
			if weapName[weapType[pWeapon[cyc]]] == "Mirror" {
				ChangeAnim(cyc, 98)
				pAgenda[cyc] = 0
				pTA[cyc] = pA[cyc]
			}
			if weapName[weapType[pWeapon[cyc]]] == "Dumbbell" {
				ChangeAnim(cyc, 132)
				pAgenda[cyc] = 0
				pTA[cyc] = pA[cyc]
			}
		}
	}
	//kneeling
	if pAnim[cyc] == 1 {
		anim: i32 = 2
		if pAnimTim[cyc] == 0 || anim != pState[cyc] {
			bb.Animate(p[cyc], 1, bb.RndF(0.1, 0.3), pSeq[cyc][anim], 10)
			pState[cyc] = anim
		}
		if pAnimTim[cyc] > 5 {
			if cast(bool)DirPressed(cyc) || pDazed[cyc] > 0 || cyc == promoActor[1] || cyc == promoActor[2] {
				ChangeAnim(cyc, 0)
			}
		}
	}
	//----------- 10-20: MOVEMENT ----------
	//standing turn
	if pAnim[cyc] == 10 {
		anim: i32 = 10
		if pWeapon[cyc] > 0 && weapStyle[weapType[pWeapon[cyc]]] == 4 do anim = 61
		if pWeapon[cyc] > 0 && weapStyle[weapType[pWeapon[cyc]]] == 5 do anim = 17
		if pInjured[cyc] > 0 || pHealth[cyc] < 10 do anim = 14
		if pDazed[cyc] > 0 do anim = 15
		if pAnimTim[cyc] == 0 || anim != pState[cyc] {
			randy: i32 = bb.RndI(-1, 1)
			if randy == -1 do bb.Animate(p[cyc], 1, -3.0, pSeq[cyc][anim], 5)
			if randy >= 0 do bb.Animate(p[cyc], 1, 3.0, pSeq[cyc][anim], 5)
			pState[cyc] = anim
		}
		if pDazed[cyc] > 0 {
			if cast(bool)cLeft[cyc] do pA[cyc] -= 5
			if cast(bool)cRight[cyc] do pA[cyc] += 5
		} else {
			if cast(bool)cLeft[cyc] do pA[cyc] += 10
			if cast(bool)cRight[cyc] do pA[cyc] -= 10
		}
		pA[cyc] = CleanAngle(pA[cyc])
		if pAnimTim[cyc] > 5 {
			if HorizontalPressed(cyc) == 0 || cast(bool)VerticalPressed(cyc) do ChangeAnim(cyc, 0)
		}
		pStepTim[cyc] += 1
	}
	// kneeling turn
	if pAnim[cyc] == 11 {
		anim: i32 = 11
		if pAnimTim[cyc] == 0 || anim != pState[cyc] {
			randy: i32 = bb.RndI(-1, 1)
			if randy == -1 do bb.Animate(p[cyc], 1, -3.0, pSeq[cyc][anim], 5)
			if randy >= 0 do bb.Animate(p[cyc], 1, 3.0, pSeq[cyc][anim], 5)
			pState[cyc] = anim
		}
		if cast(bool)cLeft[cyc] do pA[cyc] += 5
		if cast(bool)cRight[cyc] do pA[cyc] -= 5
		pA[cyc] = CleanAngle(pA[cyc])
		if pAnimTim[cyc] > 5 {
			if HorizontalPressed(cyc) == 0 || cast(bool)VerticalPressed(cyc) || pDazed[cyc] > 0 {
				ChangeAnim(cyc, 1)
			}
		}
		pStepTim[cyc] += 1
	}
	// walking
	if pAnim[cyc] == 12 {
		anim: i32 = 12
		transition: i32 = 5
		speeder: f32 = pSpeed[cyc] * 2.0
		if pWeapon[cyc] > 0 && weapStyle[weapType[pWeapon[cyc]]] == 4 do anim = 61
		if pWeapon[cyc] > 0 && weapStyle[weapType[pWeapon[cyc]]] == 5 do anim = 17
		if pHealth[cyc] < 10 {
			anim = 14
			speeder = pSpeed[cyc] * 3.0
		}
		if pInjured[cyc] > 0 {
			anim = 14
			speeder = pSpeed[cyc] * 4.0
		}
		if pDazed[cyc] > 0 {
			anim = 15
			speeder = pSpeed[cyc] * 5.0
		}
		if speeder < 3.0 do speeder = 3.0
		if pOldAnim[cyc] == 1 || pOldAnim[cyc] == 11 do transition = 10
		if pAnimTim[cyc] == 0 || anim != pState[cyc] {
			bb.Animate(p[cyc], 1, speeder, pSeq[cyc][anim], transition)
			pState[cyc] = anim
		}
		ApplyMovement(cyc, pSpeed[cyc])
		if pAnimTim[cyc] > 5 {
			if VerticalPressed(cyc) == 0 do ChangeAnim(cyc, 0)
		}
		if cast(bool)cDefend[cyc] && pInjured[cyc] == 0 && pDazed[cyc] == 0 do ChangeAnim(cyc, 13)
		pStepTim[cyc] += 1
	}
	// running
	if pAnim[cyc] == 13 {
		anim: i32 = 13
		transition: i32 = 5
		speeder: f32 = pSpeed[cyc] * 3.0
		if pWeapon[cyc] > 0 do anim = 16
		if pWeapon[cyc] > 0 && weapStyle[weapType[pWeapon[cyc]]] == 4 do anim = 62
		if pWeapon[cyc] > 0 && weapStyle[weapType[pWeapon[cyc]]] == 5 do anim = 18
		if speeder < 3.0 do speeder = 3.0
		if pOldAnim[cyc] == 1 || pOldAnim[cyc] == 11 do transition = 10
		if pAnimTim[cyc] == 0 || anim != pState[cyc] {
			bb.Animate(p[cyc], 1, speeder, pSeq[cyc][anim], transition)
			pState[cyc] = anim
		}
		ApplyMovement(cyc, pSpeed[cyc] * 2)
		if pAnimTim[cyc] > 5 {
			if VerticalPressed(cyc) == 0 || cast(bool)cDefend[cyc] == false || pDazed[cyc] > 0 do ChangeAnim(cyc, 0)
		}
		pStepTim[cyc] += 2
	}
	//----------- 20-30: WEAPON INTERACTION ----------
	// pick up weapon
	if pAnim[cyc] == 20 {
		if pAnimTim[cyc] == 0 do bb.Animate(p[cyc], 3, 3.0, pSeq[cyc][20], 5)
		// Note: v is undeclared, Blitz auomatically creates it and has 0 by default.
		// Original call: WeaponProximity(cyc, v, 5) == 0
		if pAnimTim[cyc] <= 11 && WeaponProximity(cyc, 0, 5) == 0 {
			bb.RotateEntity(pPivot[cyc], 0, pA[cyc], 0)
			bb.MoveEntity(pPivot[cyc], 0, 0, 0.3)
			pStepTim[cyc] += bb.RndI(0, 1)
		}
		if pAnimTim[cyc] == 5 do ProduceSound(p[cyc], sSwing, 22050, 0.1)
		if pAnimTim[cyc] == 11 && cast(bool)HandIntact(cyc, 17) {
			for v in 1..=no_weaps {
				range: i32 = cast(i32)weapSize[weapType[v]] + 5
				if weapLocation[v] == gamLocation[slot] && weapState[v] > 0 && pWeapon[cyc] == 0 && pWeaponTim[cyc][v] == 0 && weapCarrier[v] == 0 && pY[cyc] >= weapY[v] - 15 && pY[cyc] <= weapY[v] + 15 {
					if cast(bool)LimbProximity(pLimb[cyc][19], weapX[v], weapZ[v], range) || cast(bool)WeaponProximity(cyc, v, 5) {
						ProduceSound(p[cyc], sShuffle[bb.RndI(1, 3)], 22050, 0)
						ProduceSound(p[cyc], weapSound[weapType[v]], 22050, 0.5)
						CreateSpurt(weapX[v], weapY[v] + 1, weapZ[v], 2, 10, 5)
						AttainWeapon(cyc, v)
					}
				}
			}
		}
		if pAnimTim[cyc] > 20 {
			if pWeapon[cyc] > 0 && charWeapHistory[pChar[cyc]][weapType[pWeapon[cyc]]] == 0 {
				ChangeAnim(cyc, 24)
			} else {
				ChangeAnim(cyc, 0)
			}
		}
	}
	// drop weapon
	if pAnim[cyc] == 21 {
		if pAnimTim[cyc] == 0 do bb.Animate(p[cyc], 3, 2.0, pSeq[cyc][21], 10)
		if pAnimTim[cyc] == 4 do DropWeapon(cyc, 0)
		if pAnimTim[cyc] > 6 do ChangeAnim(cyc, 0)
	}
	// throw weapon
	if pAnimTim[cyc] == 22 {
		if pAnimTim[cyc] == 0 {
			bb.Animate(p[cyc], 3, 3.5, pSeq[cyc][22], 5)
			weapGravity[pWeapon[cyc]] = 1.0
		}
		if pAnimTim[cyc] == 6 do ProduceSound(p[cyc], sSwing, 22050, 0)
		if pAnimTim[cyc] <= 11 {
			if cast(bool)cThrow[cyc] || pControl[cyc] == 0 {
				weapGravity[pWeapon[cyc]] += 0.25
			}
		}
		if pAnimTim[cyc] == 11 do ThrowWeapon(cyc)
		if pAnimTim[cyc] > 21 do ChangeAnim(cyc, 0)
	}
	// snatch weapon
	if pAnim[cyc] == 23 {
		if pAnimTim[cyc] == 0 {
			bb.Animate(p[cyc], 3, 3.5, pSeq[cyc][23], 5)
			pSting[cyc] = 1
		}
		if pAnimTim[cyc] <= 15 && weapCarrier[NearestWeapon(cyc)] > 0 {
			FaceEntity(cyc, weap[NearestWeapon(cyc)], 5)
			bb.RotateEntity(pPivot[cyc], 0, pA[cyc], 0)
			bb.MoveEntity(pPivot[cyc], 0, 0, 0.5)
			pStepTim[cyc] += bb.RndI(0, 1)
		}
		if pAnimTim[cyc] == 6 do ProduceSound(p[cyc], sSwing, 22050, bb.RndF(0.2, 0.5))
		if pAnimTim[cyc] >= 9 && pAnimTim[cyc] <= 13 && cast(bool)HandIntact(cyc, 17) && pSting[cyc] == 1 {
			for v in 1..=no_plays {
				w: i32 = pWeapon[v]
				if w > 0 && cyc != v && pWeapon[cyc] == 0 && AttackViable(v) >= 1 && AttackViable(v) <= 2 && pY[cyc] > pY[v] - 15 && pY[cyc] < pY[v] + 15 && pSting[cyc] == 1 {
					if cast(bool)LimbProximity(pLimb[cyc][19], bb.EntityX(pLimb[v][19], 1), bb.EntityZ(pLimb[v][19], 1), 10) || InRange(cyc, v, 4) > 0 {
						charAttacker[pChar[v]] = pChar[cyc]
						ProduceSound(p[v], sImpact[bb.RndI(4, 5)], 22050, 0)
						ProduceSound(p[v], sPain[bb.RndI(1, 8)], 22050, 0)
						CreateSpurt(bb.EntityX(pLimb[v][19], 1), bb.EntityY(pLimb[v][19], 1) - 5, bb.EntityZ(pLimb[v][19], 1), 2, 10, 4)
						pHurtA[v] = pA[cyc]
						pStagger[v] = 0.6
						ChangeAnim(v, 71)
						ProduceSound(p[cyc], sShuffle[bb.RndI(1, 3)], 22050, 0)
						ProduceSound(p[v], weapSound[weapType[w]], 22050, 0)
						randy: i32 = bb.RndI(0, 2)
						if randy <= 1 {
							bb.HideEntity(bb.FindChild(p[v], weapFile[weapType[w]]))
							AttainWeapon(cyc, w)
							pWeapon[v] = 0
						}
						if randy == 2 do DropWeapon(v, 0)
						if GetResponse(cyc, v, 0) > 0 && pChar[cyc] == gamChar[slot] && charPromo[pChar[v]][pChar[cyc]] == 0 {
							charPromo[pChar[v]][pChar[cyc]] = 17
							if charGang[pChar[v]] == 6 do charPromo[pChar[v]][pChar[cyc]] = 44
						}
						RiskAnger(cyc, v)
						DamageRep(cyc, v, 2)
						pSting[cyc] = 0
					}
				}
			}
			for v in 1..=no_weaps {
				range: i32 = cast(i32)weapSize[weapType[v]] + 5
				if weapLocation[v] == gamLocation[slot] && weapState[v] > 0 && pWeapon[cyc] == 0 && pWeaponTim[cyc][v] == 0 && weapCarrier[v] == 0 && pY[cyc] >= weapY[v] - 40 && pY[cyc] < weapY[v] - 10 {
					if cast(bool)LimbProximity(pLimb[cyc][19], weapX[v], weapZ[v], range) || cast(bool)WeaponProximity(cyc, v, 5) {
						ProduceSound(p[cyc], sShuffle[bb.RndI(1, 3)], 22050, 0)
						ProduceSound(p[cyc], weapSound[weapType[v]], 22050, 0.5)
						CreateSpurt(weapX[v], weapY[v] + 1, weapZ[v], 2, 10, 5)
						AttainWeapon(cyc, v)
					}
				}
			}
		}
		if pAnimTim[cyc] > 20 {
			if pWeapon[cyc] > 0 && charWeapHistory[pChar[cyc]][weapType[pWeapon[cyc]]] == 0 {
				ChangeAnim(cyc, 24)
			} else {
				ChangeAnim(cyc, 0)
			}
		}
	}
	// examine weapon
	if pAnim[cyc] == 24 {
		if pAnimTim[cyc] == 0 do bb.Animate(p[cyc], 3, bb.RndF(0.5, 1.0), pSeq[cyc][24], 15)
		if pAnimTim[cyc] > 10 {
			randy: i32 = bb.RndI(0, 80)
			if Isolated(cyc, 30) == 0 do randy = bb.RndI(0, 40)
			if Isolated(cyc, 20) == 0 do randy = bb.RndI(0, 20)
			if Isolated(cyc, 10) == 0 do randy = bb.RndI(0, 10)
			if randy == 0 || pAnimTim[cyc] > 80 || charWeapHistory[pChar[cyc]][weapType[pWeapon[cyc]]] > 0 || pWeapon[cyc] == 0 {
				if pWeapon[cyc] > 0 do charWeapHistory[pChar[cyc]][weapType[pWeapon[cyc]]] = 1
				ChangeAnim(cyc, 0)
			}
		}
		pEyes[cyc] = 3
		pSpeaking[cyc] = 1
	}
	// handover (execute)
	if pAnim[cyc] == 25 {
		if pAnimTim[cyc] == 0 do bb.Animate(p[cyc], 3, 1.5, pSeq[cyc][25], 5)
		if pAnimTim[cyc] == 13 && pWeapon[cyc] > 0 {
			w: i32 = pWeapon[cyc]
			ProduceSound(p[cyc], sShuffle[bb.RndI(1, 3)], 22050, 0)
			ProduceSound(p[cyc], weapSound[weapType[w]], 22050, 0.5)
			DropWeapon(cyc, 0)
			if pWeapon[pFoc[cyc]] == 0 do AttainWeapon(pFoc[cyc], w)
			TradingRisk(cyc, w)
		}
		if pAnimTim[cyc] > 26 do ChangeAnim(cyc, 0)
	}
	// handover (receive)
	if pAnim[cyc] == 26 {
		if pAnimTim[cyc] == 0 {
			bb.Animate(p[cyc], 3, 1.5, pSeq[cyc][25], 5)
			DropWeapon(cyc, 0)
		}
		if pAnimTim[cyc] > 26 {
			if pWeapon[cyc] > 0 {
				TradingRisk(cyc, pWeapon[cyc])
				ChangeAnim(cyc, 24)
			} else {
				ChangeAnim(cyc, 0)
			}
		}
	}
	//basketball throw
	if pAnim[cyc] == 27 {
		if pAnimTim[cyc] == 0 {
			bb.Animate(p[cyc], 3, 2.5, pSeq[cyc][26], 10)
			weapGravity[pWeapon[cyc]] = 2.0
		}
		if pAnimTim[cyc] == 10 do ProduceSound(p[cyc], sSwing, 22050, 0)
		if pAnimTim[cyc] <= 16 {
			if cThrow[cyc] == 1 || pControl[cyc] == 0 {
				weapGravity[pWeapon[cyc]] += 0.2
			}
		}
		if pAnimTim[cyc] == 16 do ThrowWeapon(cyc)
		if pAnimTim[cyc] == 20 {
			ProduceSound(p[cyc], sThud, 22050, 0.5)
			pStepTim[cyc] = 99
			pHealth[cyc] -= bb.RndI(0, 1)
			randy: i32 = bb.RndI(0, 100)
			if randy == 0 && gamGrowth[slot] >= 0 do gamGrowth[slot] -= 1
		}
		if pAnimTim[cyc] > 28 do ChangeAnim(cyc, 0)
	}
	//phone pick-up
	if pAnim[cyc] == 28 {
		if pAnimTim[cyc] == 0 do bb.Animate(p[cyc], 3, 3.0, pSeq[cyc][27], 5)
		if pAnimTim[cyc] == 4 do ProduceSound(p[cyc], sSwing, 22050, bb.RndF(0.1, 0.3))
		if pAnimTim[cyc] == 8 && pScar[cyc][6] <= 4 && pPhone[cyc] == 0 {
			v: i32 = PhoneProximity(cyc)
			if v > 0 && PhoneTaken(v) == 0 {
				ProduceSound(p[cyc], sPhone, 22050, 0)
				bb.HideEntity(bb.FindChild(world, fmt.tprint("Phone", Dig(v, 10))))
				bb.ShowEntity(bb.FindChild(p[cyc], "Phone"))
				if phoneRing == v {
					bb.PositionEntity(bb.FindChild(world, fmt.tprint("Phone", Dig(phoneRing, 10))), phoneX[phoneRing], phoneY[phoneRing], phoneZ[phoneRing])
					bb.EntityColor(bb.FindChild(world, fmt.tprint("Alarm", Dig(phoneRing, 10))), 5, 0, 0)
					bb.EntityFX(bb.FindChild(world, fmt.tprint("Alarm", Dig(phoneRing, 10))), 0)
					bb.StopChannel(chPhone)
					phoneRing = 0
					phoneTim = 0
					if pChar[cyc] == gamChar[slot] && phonePromo > 0 {
						TriggerPromo(-v, cyc, phonePromo)
						phonePromo = 0
					}
				}
				pPhone[cyc] = v
			}
		}
		if pAnimTim[cyc] > 8 && pPhone[cyc] > 0 {
			ChangeAnim(cyc, 0)
			pAgenda[cyc] = 0
		}
		if pAnimTim[cyc] > 15 do ChangeAnim(cyc, 0)
	}
	//phone put-down
	if pAnim[cyc] == 29 {
		if pAnimTim[cyc] == 0 do bb.Animate(p[cyc], 3, 3.0, pSeq[cyc][27], 5)
		if pAnimTim[cyc] == 4 do ProduceSound(p[cyc], sSwing, 22050, bb.RndF(0.1, 0.3))
		if pAnimTim[cyc] == 8 && pPhone[cyc] > 0 {
			ProduceSound(p[cyc], sPhone, 22050, 0)
			bb.HideEntity(bb.FindChild(p[cyc], "Phone"))
			bb.ShowEntity(bb.FindChild(world, fmt.tprint("Phone", Dig(pPhone[cyc], 10))))
			pPhone[cyc] = 0
		}
		if pAnimTim[cyc] > 15 do ChangeAnim(cyc, 0)
	}
	//----------- 30-40: HAND-2-HAND ATTACKS ----------
	//upper punch
	if pAnim[cyc] == 30 {
		if pAnimTim[cyc] == 0 {
			bb.Animate(p[cyc], 3, 4.0, pSeq[cyc][30], 5)
			pSting[cyc] = 1
		}
		if pAnimTim[cyc] == 3 do ProduceSound(p[cyc], sSwing, 22050, bb.RndF(0.1, 0.3))
		if pAnimTim[cyc] <= 15 {
			FaceEntity(cyc, p[pFoc[cyc]], 5)
			bb.RotateEntity(pPivot[cyc], 0, pA[cyc], 0)
			bb.MoveEntity(pPivot[cyc], 0, 0, 0.5)
			pStepTim[cyc] += bb.RndI(0, 1)
		}
		if pAnimTim[cyc] >= 4 && pAnimTim[cyc] <= 10 && pScar[cyc][18] <= 4 && pSting[cyc] == 1 {
			for v in 1..=no_plays {
				range: i32 = pAnimTim[cyc] - 3
				if cyc != v && (Friendly(cyc, v) == 0 || v == pFoc[cyc]) && cast(bool)InProximity(cyc, v, 15 + range) && pY[cyc] > pY[v] - 30 && pY[cyc] < pY[v] + 5 && AttackViable(v) >= 1 && AttackViable(v) <= 2 && pSting[cyc] == 1 {
					contact: i32 = InRange(cyc, v, range)
					if contact > 0 {
						charAttacker[pChar[v]] = pChar[cyc]
						blocked: i32 = 0
						randy: i32 = bb.RndI(0, 10)
						if randy <= 5 + BlockPower(v) && pAnim[v] >= 74 && pAnim[v] <= 75 && cast(bool)InLine(v, p[cyc], 90) do blocked = 1
						if blocked == 0 {
							ProduceSound(p[v], sImpact[bb.RndI(1, 2)], 22050, 0)
							ProduceSound(p[v], sPain[bb.RndI(1, 8)], 22050, 0)
							CreateSpurt(pX[v], pY[cyc] + 22, pZ[v], 2, 10, 99)
							ScarLimb(v, 1, 10)
							ChangeAnim(v, 70)
							pDT[v] = ((110.0 - pHealth[v]) * 2)
							pHealth[v] -= GetPower(cyc)
							pHP[v] -= GetPower(cyc)
						}
						if blocked == 1 {
							if pWeapon[v] > 0 {
								ProduceSound(p[v], weapSound[weapType[pWeapon[v]]], 22050, 0)
								DropWeapon(v, 10)
							}
							ProduceSound(p[v], sImpact[bb.RndI(4, 5)], 22050, 0)
							CreateSpurt(pX[v], pY[cyc] + 22, pZ[v], 2, 10, 4)
							for limb in i32(4)..=29 {
								if pWeapon[v] == 0 do ScarLimb(v, limb, 10)
							}
							pHP[v] -= bb.RndI(0, 1)
						}
						WeaponImpact(cyc, v, blocked)
						pHurtA[v] = pA[cyc]
						pStagger[v] = f32(8 - contact) * 0.2
						if pStagger[v] < 0.2 do pStagger[v] = 0.2
						RiskAnger(cyc, v)
						GainStrength(cyc, 50)
						DamageRep(cyc, v, 0)
						pSting[cyc] = 0
					}
				}
			}
		}
		if pAnimTim[cyc] > 18 do ChangeAnim(cyc, 0)
		if pWeapon[cyc] > 0 && (weapStyle[weapType[pWeapon[cyc]]] == 1 || weapStyle[weapType[pWeapon[cyc]]] == 7) do ChangeAnim(cyc, 40)
	}
	//lower kick
	if pAnim[cyc] == 31 {
		if pAnimTim[cyc] == 0 {
			bb.Animate(p[cyc], 3, 3.5, pSeq[cyc][31], 8)
			pSting[cyc] = 1
		}
		if pAnimTim[cyc] == 2 do ProduceSound(p[cyc], sSwing, 22050, bb.RndF(0.1, 0.3))
		if pAnimTim[cyc] <= 18 {
			FaceEntity(cyc, p[pFoc[cyc]], 5)
			bb.RotateEntity(pPivot[cyc], 0, pA[cyc], 0)
			bb.MoveEntity(pPivot[cyc], 0, 0, 0.5)
			pStepTim[cyc] += bb.RndI(0, 1)
		}
		if pAnimTim[cyc] >= 4 && pAnimTim[cyc] <= 10 && pScar[cyc][32] <= 4 && pSting[cyc] == 1 {
			for v in 1..=no_plays {
				range: i32 = pAnimTim[cyc]
				if range > 7 { range = 7  }
				if cyc != v && (Friendly(cyc, v) == 0 || v == pFoc[cyc]) && cast(bool)InProximity(cyc, v, 15 + range) && pY[cyc] > pY[v] - 15 && pY[cyc] < pY[v] + 15 && AttackViable(v) >= 1 && AttackViable(v) <= 2 && pSting[cyc] == 1 {
					contact: i32 = InRange(cyc, v, range)
					if contact > 0 {
						charAttacker[pChar[v]] = pChar[cyc]
						blocked: i32 = 0
						randy: i32 = bb.RndI(0, 10)
						if randy <= 5 + BlockPower(v) && pAnim[v] >= 74 && pAnim[v] <= 75 && cast(bool)InLine(v, p[cyc], 90) {
							blocked = 1
						}
						if blocked == 0 {
							ProduceSound(p[v], sImpact[bb.RndI(4, 5)], 22050, 0)
							ProduceSound(p[v], sPain[bb.RndI(1, 8)], 22050, 0)
							CreateSpurt(pX[v], pY[cyc] + 15, pZ[v], 2, 10, 99)
							ScarArea(v, pX[v], pY[cyc] + 15, pZ[v], 10)
							ChangeAnim(v, 71)
							pDT[v] = ((110 - pHealth[v]) * 2)
							pHealth[v] -= GetPower(cyc)
							pHP[v] -= GetPower(cyc)
						}
						if blocked == 1 {
							if pWeapon[v] > 0 {
								ProduceSound(p[v], weapSound[weapType[pWeapon[v]]], 22050, 0)
								DropWeapon(v, 10)
							}
							ProduceSound(p[v], sImpact[bb.RndI(4, 5)], 22050, 0)
							CreateSpurt(pX[v], pY[cyc] + 15, pZ[v], 2, 10, 4)
							for limb in i32(4)..=29 {
								if pWeapon[v] == 0 {
									ScarLimb(v, limb, 10)
								}
							}
							pHP[v] -= bb.RndI(0, 1)
						}
						pHurtA[v] = pA[cyc]
						pStagger[v] = cast(f32)(8 - contact) * 0.3
						if pStagger[v] < 0.3 { pStagger[v] = 0.3  }
						RiskAnger(cyc, v)
						GainStrength(cyc, 50)
						DamageRep(cyc, v, 0)
						pSting[cyc] = 0
					}
				}
			}
		}
		if pAnimTim[cyc] > 22 do ChangeAnim(cyc, 1)
		if pWeapon[cyc] > 0 && (weapStyle[weapType[pWeapon[cyc]]] == 1 || weapStyle[weapType[pWeapon[cyc]]] == 7) {
			ChangeAnim(cyc, 41)
		}
	}
	//stomp
	if pAnim[cyc] == 32 {
		if pAnimTim[cyc] == 0 {
			bb.Animate(p[cyc], 3, 3.0, pSeq[cyc][32], 5)
			pSting[cyc] = 1
		}
		if pAnimTim[cyc] == 3 {
			ProduceSound(p[cyc], sSwing, 22050, bb.RndF(0.1, 0.3))
		}
		if pAnimTim[cyc] <= 12 {
			FaceEntity(cyc, p[pFoc[cyc]], 5)
			if InProximity(cyc, pFoc[cyc], 10) == 0 {
				bb.RotateEntity(pPivot[cyc], 0, pA[cyc], 0)
				bb.MoveEntity(pPivot[cyc], 0, 0, 0.5)
			}
		}
		if pAnimTim[cyc] >= 7 && pAnimTim[cyc] <= 11 && pScar[cyc][35] <= 4 && pSting[cyc] == 1 {
			v := pFoc[cyc]
			if cyc != v && (Friendly(cyc, v) == 0 || v == pFoc[cyc]) && cast(bool)InProximity(cyc, v, 25) && pY[cyc] > pY[v] - 15 && pY[cyc] < pY[v] + 15 && AttackViable(v) == 3 && pSting[cyc] == 1 {
				contact := InRange(cyc, v, 6)
				if contact > 0 {
					charAttacker[pChar[v]] = pChar[cyc]
					ProduceSound(p[v], sImpact[bb.RndI(4, 5)], 22050, 0)
					if pHealth[v] > 0 do ProduceSound(p[v], sPain[bb.RndI(1, 8)], 22050, 0)
					limb := pLimb[cyc][36]
					CreateSpurt(bb.EntityX(limb, 1), pY[v], bb.EntityZ(limb, 1), 2, 10, 99)
					ScarArea(v, bb.EntityX(limb, 1), pY[v], bb.EntityZ(limb, 1), 10)
					GroundReaction(v)
					pDT[v] -= 10
					pHealth[v] -= GetPower(cyc)
					RiskAnger(cyc, v)
					GainStrength(cyc, 100)
					DamageRep(cyc, v, 0)
					pSting[cyc] = 0
				}
			}
		}
		if pAnimTim[cyc] > 18 do ChangeAnim(cyc, 0)
		if pWeapon[cyc] > 0 && (weapStyle[weapType[pWeapon[cyc]]] <= 1 || weapStyle[weapType[pWeapon[cyc]]] == 7) {
			ChangeAnim(cyc, 42)
		}
	}
	//big attack
	if pAnim[cyc] == 33 {
		if pAnimTim[cyc] == 0 {
			bb.Animate(p[cyc], 3, 3.0, pSeq[cyc][33], 10)
			pSting[cyc] = 1
		}
		if pAnimTim[cyc] == 5 do ProduceSound(p[cyc], sSwing, 22050, bb.RndF(0.3, 0.5))
		if pAnimTim[cyc] <= 16 {
			FaceEntity(cyc, p[pFoc[cyc]], 5)
			bb.RotateEntity(pPivot[cyc], 0, pA[cyc], 0)
			bb.MoveEntity(pPivot[cyc], 0, 0, 0.5)
			pStepTim[cyc] = pStepTim[cyc] + bb.RndI(0, 1)
		}
		if pAnimTim[cyc] >= 10 && pAnimTim[cyc] <= 14 && (pScar[cyc][18] <= 4 || pScar[cyc][5] <= 4) && pSting[cyc] == 1 {
			for v in 1..=no_plays {
				range := pAnimTim[cyc] - 8
				if range > 5 do range = 5
				if pWeapon[cyc] > 0 do range += 1
				if cyc != v && (Friendly(cyc, v) == 0 || v == pFoc[cyc]) && cast(bool)InProximity(cyc, v, 15 + range) && pY[cyc] > pY[v] - 30 && pY[cyc] < pY[v] + 15 && AttackViable(v) >= 1 && AttackViable(v) <= 2 && pSting[cyc] == 1 {
					contact := InRange(cyc, v, range)
					if contact > 0 {
						charAttacker[pChar[v]] = pChar[cyc]
						blocked: i32 = 0
						randy := bb.RndI(0, 10)
						if randy <= 3 + BlockPower(v) && pAnim[v] >= 74 && pAnim[v] <= 75 && cast(bool)InLine(v, p[cyc], 90) {
							blocked = 1
						}
						if blocked == 0 {
							ProduceSound(p[v], sImpact[3], 22050, 0)
							ProduceSound(p[v], sPain[bb.RndI(1, 8)], 22050, 1)
							impactY := pY[cyc] + 20
							if impactY > bb.EntityY(pLimb[v][1], 1) do impactY = bb.EntityY(pLimb[v][1], 1)
							CreateSpurt(pX[v], impactY, pZ[v], 2, 10, 99)
							ScarLimb(v, 1, 10)
							ChangeAnim(v, 70)
							pDT[v] = ((150 - pHealth[v]) * 2)
							pHealth[v] -= GetPower(cyc) * 2
							pHP[v] -= GetPower(cyc) * 2
						}
						if blocked == 1 {
							if pWeapon[v] > 0 {
								ProduceSound(p[v], weapSound[weapType[pWeapon[v]]], 22050, 0)
								DropWeapon(v, 10)
							}
							ProduceSound(p[v], sImpact[6], 22050, 0)
							impactY := pY[cyc] + 20
							if impactY > bb.EntityY(pLimb[v][1], 1) do impactY = bb.EntityY(pLimb[v][1], 1)
							CreateSpurt(pX[v], impactY, pZ[v], 2, 10, 4)
							for limb in i32(4)..=29 {
								if pWeapon[v] == 0 do ScarLimb(v, limb, 10)
							}
							if pWeapon[v] == 0 do pHealth[v] -= 1
							pHP[v] -= 1
						}
						WeaponImpact(cyc, v, blocked)
						pHurtA[v] = pA[cyc]
						pStagger[v] = cast(f32)(8 - contact) * 0.2
						if pStagger[v] < 0.2 do pStagger[v] = 0.2
						RiskAnger(cyc, v)
						GainStrength(cyc, 25)
						DamageRep(cyc, v, 1)
						pSting[cyc] = 0
					}
				}
			}
		}
		if pAnimTim[cyc] > 23 do ChangeAnim(cyc, 0)
		if pWeapon[cyc] > 0 && (weapStyle[weapType[pWeapon[cyc]]] == 1 || weapStyle[weapType[pWeapon[cyc]]] == 7) {
			ChangeAnim(cyc, 43)
		}
	}
	//rear attack
	if pAnim[cyc] == 34 {
		if pAnimTim[cyc] == 0 {
			bb.Animate(p[cyc], 3, 4.0, pSeq[cyc][34], 10)
			for v in 1..=no_plays {
				pMultiSting[cyc][v] = 1
			}
		}
		if pAnimTim[cyc] == 5 do ProduceSound(p[cyc], sSwing, 22050, bb.RndF(0.3, 0.5))
		if pAnimTim[cyc] >= 5 && pAnimTim[cyc] <= 16 {
			bb.RotateEntity(pPivot[cyc], 0, pA[cyc], 0)
			bb.MoveEntity(pPivot[cyc], 0, 0, -1.0)
			pStepTim[cyc] = pStepTim[cyc] + bb.RndI(0, 1)
		}
		if pAnimTim[cyc] >= 7 && pAnimTim[cyc] <= 17 && pScar[cyc][18] <= 4 {
			for v in 1..=no_plays {
				range := pAnimTim[cyc] - 8
				if range > 5 do range = 5
				if cyc != v && (Friendly(cyc, v) == 0 || v == pFoc[cyc]) && cast(bool)LimbProximity(pLimb[cyc][18], pX[v], pZ[v], 8) && pY[cyc] > pY[v] - 30 && pY[cyc] < pY[v] + 5 && AttackViable(v) == 1 && pMultiSting[cyc][v] == 1 {
					charAttacker[pChar[v]] = pChar[cyc]
					blocked: i32 = 0
					randy := bb.RndI(0, 10)
					if randy <= 3 + BlockPower(v) && pAnim[v] >= 74 && pAnim[v] <= 75 && cast(bool)InLine(v, p[cyc], 90) {
						blocked = 1
					}
					if blocked == 0 {
						ProduceSound(p[v], sImpact[3], 22050, 0)
						ProduceSound(p[v], sPain[bb.RndI(1, 8)], 22050, 1)
						limb := pLimb[cyc][18]
						CreateSpurt(bb.EntityX(limb, 1), pY[cyc] + 20, bb.EntityZ(limb, 1), 2, 10, 99)
						ScarLimb(v, 1, 10)
						ChangeAnim(v, 70)
						pDT[v] = (150 - pHealth[v]) * 2
						pHealth[v] -= GetPower(cyc) * 2
						pHP[v] -= GetPower(cyc) * 2
					}
					if blocked == 1 {
						if pWeapon[v] > 0 {
							ProduceSound(p[v], weapSound[weapType[pWeapon[v]]], 22050, 0)
							DropWeapon(v, 10)
						}
						ProduceSound(p[v], sImpact[6], 22050, 0)
						CreateSpurt(pX[v], pY[cyc] + 20, pZ[v], 2, 10, 4)
						for limb in i32(4)..=29 {
							if pWeapon[v] == 0 do ScarLimb(v, limb, 10)
						}
						if pWeapon[v] == 0 do pHealth[v] -= 1
						pHP[v] -= 1
					}
					WeaponImpact(cyc, v, blocked)
					pHurtA[v] = pA[v] + 180
					pStagger[v] = 1.2
					RiskAnger(cyc, v)
					GainStrength(cyc, 25)
					DamageRep(cyc, v, 1)
					pMultiSting[cyc][v] = 0
				}
			}
		}
		if pAnimTim[cyc] > 30 {
			SharpTransition(cyc, 1, 180)
			ChangeAnim(cyc, 0)
		}
		if pWeapon[cyc] > 0 && weapStyle[weapType[pWeapon[cyc]]] == 1 {
			ChangeAnim(cyc, 44)
		}
	}
	//rising punch
	if pAnim[cyc] == 35 {
		if pAnimTim[cyc] == 0 {
			bb.Animate(p[cyc], 3, 3.0, pSeq[cyc][35], 5)
			pSting[cyc] = 1
		}
		if pAnimTim[cyc] == 3 do ProduceSound(p[cyc], sSwing, 22050, bb.RndF(0.1, 0.3))
		if pAnimTim[cyc] <= 15 {
			FaceEntity(cyc, p[pFoc[cyc]], 5)
			bb.RotateEntity(pPivot[cyc], 0, pA[cyc], 0)
			bb.MoveEntity(pPivot[cyc], 0, 0, 0.2)
			pStepTim[cyc] = pStepTim[cyc] + bb.RndI(0, 1)
		}
		if pAnimTim[cyc] >= 6 && pAnimTim[cyc] <= 11 && pScar[cyc][18] <= 4 && pSting[cyc] == 1 {
			for v in 1..=no_plays {
				range := pAnimTim[cyc] - 3
				if range > 6 do range = 6
				if cyc != v && (Friendly(cyc, v) == 0 || v == pFoc[cyc]) && cast(bool)InProximity(cyc, v, 15 + range) && pY[cyc] > pY[v] - 15 && pY[cyc] < pY[v] + 15 && AttackViable(v) >= 1 && AttackViable(v) <= 2 && pSting[cyc] == 1 {
					contact := InRange(cyc, v, range)
					if contact > 0 {
						charAttacker[pChar[v]] = pChar[cyc]
						blocked: i32 = 0
						randy := bb.RndI(0, 10)
						if randy <= 5 + BlockPower(v) && pAnim[v] >= 74 && pAnim[v] <= 75 && cast(bool)InLine(v, p[cyc], 90) {
							blocked = 1
						}
						if blocked == 0 {
							ProduceSound(p[v], sImpact[bb.RndI(4, 5)], 22050, 0)
							ProduceSound(p[v], sPain[bb.RndI(1, 8)], 22050, 0)
							CreateSpurt(pX[v], pY[cyc] + 15, pZ[v], 2, 10, 99)
							ScarArea(v, pX[v], pY[cyc] + 15, pZ[v], 10)
							ChangeAnim(v, 71)
							pDT[v] = (110 - pHealth[v]) * 2
							pHealth[v] -= GetPower(cyc)
							pHP[v] -= GetPower(cyc)
						}
						if blocked == 1 {
							if pWeapon[v] > 0 {
								ProduceSound(p[v], weapSound[weapType[pWeapon[v]]], 22050, 0)
								DropWeapon(v, 10)
							}
							ProduceSound(p[v], sImpact[bb.RndI(4, 5)], 22050, 0)
							CreateSpurt(pX[v], pY[cyc] + 15, pZ[v], 2, 10, 4)
							for limb in i32(4)..=29 {
								if pWeapon[v] == 0 do ScarLimb(v, limb, 10)
							}
							pHP[v] -= bb.RndI(0, 1)
						}
						WeaponImpact(cyc, v, blocked)
						pHurtA[v] = pA[cyc]
						pStagger[v] = cast(f32)(8 - contact) * 0.2
						if pStagger[v] < 0.2 do pStagger[v] = 0.2
						RiskAnger(cyc, v)
						GainStrength(cyc, 50)
						DamageRep(cyc, v, 0)
						pSting[cyc] = 0
					}
				}
			}
		}
		if pAnimTim[cyc] > 25 do ChangeAnim(cyc, 1)
		if pWeapon[cyc] > 0 && (weapStyle[weapType[pWeapon[cyc]]] == 1 || weapStyle[weapType[pWeapon[cyc]]] == 7) {
			ChangeAnim(cyc, 41)
		}
	}
	//----------- 40-50: SWORD ATTACKS ----------
	//upper swing
	if pAnim[cyc] == 40 {
		anim: i32 = 40
		if weapStyle[weapType[pWeapon[cyc]]] == 7 do anim = 51
		if pAnimTim[cyc] == 0 {
			bb.Animate(p[cyc], 3, 4.0, pSeq[cyc][anim], 5)
			pSting[cyc] = 1
		}
		if pAnimTim[cyc] == 3 do ProduceSound(p[cyc], sSwing, 22050, 0)
		if pAnimTim[cyc] <= 11 {
			FaceEntity(cyc, p[pFoc[cyc]], 5)
			bb.RotateEntity(pPivot[cyc], 0, pA[cyc], 0)
			bb.MoveEntity(pPivot[cyc], 0, 0, 0.4)
			pStepTim[cyc] = pStepTim[cyc] + bb.RndI(0, 1)
		}
		impactTim: i32 = 5
		if weapStyle[weapType[pWeapon[cyc]]] == 7 do impactTim = 9
		if pAnimTim[cyc] >= impactTim && pAnimTim[cyc] <= impactTim + 4 && pSting[cyc] == 1 {
			for v in 1..=no_plays {
				range := cast(i32)weapRange[weapType[pWeapon[cyc]]]
				if cyc != v && (Friendly(cyc, v) == 0 || v == pFoc[cyc]) && cast(bool)InProximity(cyc, v, 20 + range) && pY[cyc] > pY[v] - 30 && pY[cyc] < pY[v] + 15 && AttackViable(v) >= 1 && AttackViable(v) <= 2 && pSting[cyc] == 1 {
					contact := InRange(cyc, v, range)
					if contact > 0 {
						charAttacker[pChar[v]] = pChar[cyc]
						blocked := 0
						randy := bb.RndI(0, 10)
						if randy <= 5 + BlockPower(v) && pAnim[v] >= 74 && pAnim[v] <= 75 && cast(bool)InLine(v, p[cyc], 90) {
							blocked = 1
						}
						if blocked == 0 {
							ProduceSound(p[v], weapSound[weapType[pWeapon[cyc]]], 22050, 1)
							if weapStyle[weapType[pWeapon[cyc]]] == 7 do ProduceSound(p[v], sStab, 22050, 1)
							ProduceSound(p[v], sPain[bb.RndI(1, 8)], 22050, 0)
							CreateSpurt(pX[v], pY[cyc] + 20, pZ[v], 2, 10, 99)
							ScarArea(v, pX[v], pY[cyc] + 20, pZ[v], 2)
							if CountScars(v) >= 2 {
								ScarWeapon(pWeapon[cyc], 5)
								CreatePool(pX[v], pGround[v], pZ[v], bb.RndF(2.0, 8.0), 1, 1)
							}
							ChangeAnim(v, 70)
							pDT[v] = (110 - pHealth[v]) * 2
							pHealth[v] -= GetPower(cyc)
							pHP[v] -= GetPower(cyc)
							pDT[v] += (weapDamage[weapType[pWeapon[cyc]]] * 10)
							pHealth[v] -= bb.RndI(1, weapDamage[weapType[pWeapon[cyc]]])
							pHP[v] -= bb.RndI(1, weapDamage[weapType[pWeapon[cyc]]])
							if weapName[weapType[pWeapon[cyc]]] == "Syringe" && pInjured[v] < 100 {
								pInjured[v] = bb.RndI(100, 500)
							}
						}
						if blocked == 1 {
							if pWeapon[v] > 0 {
								ProduceSound(p[v], weapSound[weapType[pWeapon[v]]], 22050, 0)
								DropWeapon(v, 10)
							}
							ProduceSound(p[v], weapSound[weapType[pWeapon[cyc]]], 22050, 0)
							ProduceSound(p[v], sImpact[bb.RndI(4, 5)], 22050, 0)
							CreateSpurt(pX[v], pY[cyc] + 20, pZ[v], 2, 10, 4)
							for limb in i32(4)..=29 {
								if pWeapon[v] == 0 do ScarLimb(v, limb, 10)
							}
							if pWeapon[v] == 0 do pHealth[v] -= 1
							pHP[v] -= bb.RndI(0, 1)
						}
						pHurtA[v] = pA[cyc]
						pStagger[v] = cast(f32)(range - contact) * 0.2
						if pStagger[v] < 0.2 do pStagger[v] = 0.2
						RiskAnger(cyc, v)
						GainStrength(cyc, 50)
						DamageRep(cyc, v, 1)
						pSting[cyc] = 0
					}
				}
			}
		}
		if pAnimTim[cyc] > 18 do ChangeAnim(cyc, 0)
	}
	//lower swing
	if pAnim[cyc] == 41 {
		if pAnimTim[cyc] == 0 {
			bb.Animate(p[cyc], 3, 4.0, pSeq[cyc][41], 5)
			pSting[cyc] = 1
		}
		if pAnimTim[cyc] == 3 do ProduceSound(p[cyc], sSwing, 22050, 0)
		if pAnimTim[cyc] <= 11 {
			FaceEntity(cyc, p[pFoc[cyc]], 5)
			bb.RotateEntity(pPivot[cyc], 0, pA[cyc], 0)
			bb.MoveEntity(pPivot[cyc], 0, 0, 0.4)
			pStepTim[cyc] = pStepTim[cyc] + bb.RndI(0, 1)
		}
		if pAnimTim[cyc] >= 5 && pAnimTim[cyc] <= 9 && pSting[cyc] == 1 {
			for v in 1..=no_plays {
				range := cast(i32)weapRange[weapType[pWeapon[cyc]]] - 1
				if cyc != v && (Friendly(cyc, v) == 0 || v == pFoc[cyc]) && cast(bool)InProximity(cyc, v, 20 + range) && pY[cyc] > pY[v] - 15 && pY[cyc] < pY[v] + 15 && AttackViable(v) >= 1 && AttackViable(v) <= 2 && pSting[cyc] == 1 {
					contact := InRange(cyc, v, range)
					if contact > 0 {
						charAttacker[pChar[v]] = pChar[cyc]
						blocked: i32 = 0
						randy := bb.RndI(0, 10)
						if randy <= 5 + BlockPower(v) && pAnim[v] >= 74 && pAnim[v] <= 75 && cast(bool)InLine(v, p[cyc], 90) {
							blocked = 1
						}
						if blocked == 0 {
							ProduceSound(p[v], weapSound[weapType[pWeapon[cyc]]], 22050, 1)
							if weapStyle[weapType[pWeapon[cyc]]] == 7 do ProduceSound(p[v], sStab, 22050, 1)
							ProduceSound(p[v], sPain[bb.RndI(1, 8)], 22050, 0)
							CreateSpurt(pX[v], pY[cyc] + 10, pZ[v], 2, 10, 99)
							ScarArea(v, pX[v], pY[cyc] + 10, pZ[v], 2)
							if CountScars(v) >= 2 {
								ScarWeapon(pWeapon[cyc], 5)
								CreatePool(pX[v], pGround[v], pZ[v], bb.RndF(2.0, 8.0), 1, 1)
							}
							ChangeAnim(v, 71)
							pDT[v] = (110 - pHealth[v]) * 2
							pHealth[v] -= GetPower(cyc)
							pHP[v] -= GetPower(cyc)
							pDT[v] += (weapDamage[weapType[pWeapon[cyc]]] * 10)
							pHealth[v] -= bb.RndI(1, weapDamage[weapType[pWeapon[cyc]]])
							pHP[v] -= bb.RndI(1, weapDamage[weapType[pWeapon[cyc]]])
							if weapName[weapType[pWeapon[cyc]]] == "Syringe" && pInjured[v] < 100 {
								pInjured[v] = bb.RndI(100, 500)
							}
						}
						if blocked == 1 {
							if pWeapon[v] > 0 {
								ProduceSound(p[v], weapSound[weapType[pWeapon[v]]], 22050, 0)
								DropWeapon(v, 10)
							}
							ProduceSound(p[v], weapSound[weapType[pWeapon[cyc]]], 22050, 0)
							ProduceSound(p[v], sImpact[bb.RndI(4, 5)], 22050, 0)
							CreateSpurt(pX[v], pY[cyc] + 10, pZ[v], 2, 10, 4)
							for limb in i32(4)..=29 {
								if pWeapon[v] == 0 do ScarLimb(v, limb, 10)
							}
							if pWeapon[v] == 0 do pHealth[v] -= 1
							pHP[v] -= bb.RndI(0, 1)
						}
						pHurtA[v] = pA[cyc]
						pStagger[v] = cast(f32)(range - contact) * 0.2
						if pStagger[v] < 0.2 do pStagger[v] = 0.2
						RiskAnger(cyc, v)
						GainStrength(cyc, 50)
						DamageRep(cyc, v, 1)
						pSting[cyc] = 0
					}
				}
			}
		}
		if pAnimTim[cyc] > 18 do ChangeAnim(cyc, 0)
	}
	//ground swing
	if pAnim[cyc] == 42 {
		anim: i32 = 42
		if weapStyle[weapType[pWeapon[cyc]]] == 7 do anim = 52
		if pAnimTim[cyc] == 0 {
			bb.Animate(p[cyc], 3, 3.5, pSeq[cyc][anim], 10)
			pSting[cyc] = 1
		}
		if pAnimTim[cyc] == 4 do ProduceSound(p[cyc], sSwing, 22050, 0)
		if pAnimTim[cyc] <= 14 {
			FaceEntity(cyc, p[pFoc[cyc]], 5)
			if InProximity(cyc, pFoc[cyc], 15) == 0 {
				bb.RotateEntity(pPivot[cyc], 0, pA[cyc], 0)
				bb.MoveEntity(pPivot[cyc], 0, 0, 0.3)
			}
		}
		if pAnimTim[cyc] >= 10 && pAnimTim[cyc] <= 15 && pSting[cyc] == 1 {
			v := pFoc[cyc]
			if cyc != v && (Friendly(cyc, v) == 0 || v == pFoc[cyc]) && pY[cyc] > pY[v] - 15 && pY[cyc] < pY[v] + 15 && AttackViable(v) == 3 && pSting[cyc] == 1 {
				range := cast(i32)(weapRange[weapType[pWeapon[cyc]]] + (weapRange[weapType[pWeapon[cyc]]] / 3))
				if cast(bool)LimbProximity(bb.FindChild(p[cyc], weapFile[weapType[pWeapon[cyc]]]), pX[v], pZ[v], range) || cast(bool)LimbProximity(pLimb[cyc][19], pX[v], pZ[v], range / 2) {
					charAttacker[pChar[v]] = pChar[cyc]
					ProduceSound(p[v], weapSound[weapType[pWeapon[cyc]]], 22050, 1)
					if weapStyle[weapType[pWeapon[cyc]]] == 7 do ProduceSound(p[v], sStab, 22050, 1)
					if pHealth[v] > 0 do ProduceSound(p[v], sPain[bb.RndI(1, 8)], 22050, 0)
					//limb := bb.FindChild(p[cyc], weapFile[weapType[pWeapon[cyc]]]) // Unused
					CreateSpurt(pX[v], pY[v], pZ[v], 3, 10, 99)
					ScarArea(v, pX[v], pY[v], pZ[v], 2)
					if CountScars(v) >= 2 {
						ScarWeapon(pWeapon[cyc], 5)
						CreatePool(pX[v], pGround[v], pZ[v], bb.RndF(2.0, 8.0), 1, 1)
					}
					GroundReaction(v)
					pDT[v] -= 10
					pHealth[v] -= GetPower(cyc)
					pHealth[v] -= bb.RndI(1, weapDamage[weapType[pWeapon[cyc]]])
					if weapName[weapType[pWeapon[cyc]]] == "Syringe" && pInjured[v] < 100 {
						pInjured[v] = bb.RndI(100, 500)
					}
					RiskAnger(cyc, v)
					GainStrength(cyc, 50)
					DamageRep(cyc, v, 1)
					pSting[cyc] = 0
				}
			}
		}
		if pAnimTim[cyc] > 22 do ChangeAnim(cyc, 0)
	}
	//big swing
	if pAnim[cyc] == 43 {
		anim: i32 = 43
		if weapStyle[weapType[pWeapon[cyc]]] == 7 do anim = 53
		if pAnimTim[cyc] == 0 {
			bb.Animate(p[cyc], 3, 3.0, pSeq[cyc][anim], 10)
			pSting[cyc] = 1
		}
		if pAnimTim[cyc] == 5 do ProduceSound(p[cyc], sSwing, 22050, 0)
		if pAnimTim[cyc] <= 16 {
			FaceEntity(cyc, p[pFoc[cyc]], 5)
			bb.RotateEntity(pPivot[cyc], 0, pA[cyc], 0)
			bb.MoveEntity(pPivot[cyc], 0, 0, 0.4)
			pStepTim[cyc] = pStepTim[cyc] + bb.RndI(0, 1)
		}
		if pAnimTim[cyc] >= 10 && pAnimTim[cyc] <= 15 && pSting[cyc] == 1 {
			for v in 1..=no_plays {
				range := cast(i32)weapRange[weapType[pWeapon[cyc]]]
				if cyc != v && (Friendly(cyc, v) == 0 || v == pFoc[cyc]) && cast(bool)InProximity(cyc, v, 20 + range) && pY[cyc] > pY[v] - 30 && pY[cyc] < pY[v] + 15 && AttackViable(v) >= 1 && AttackViable(v) <= 2 && pSting[cyc] == 1 {
					contact := InRange(cyc, v, range)
					if contact > 0 {
						charAttacker[pChar[v]] = pChar[cyc]
						blocked: i32 = 0
						randy := bb.RndI(0, 10)
						if randy <= 3 + BlockPower(v) && pAnim[v] >= 74 && pAnim[v] <= 75 && cast(bool)InLine(v, p[cyc], 90) do blocked = 1
						if blocked == 0 {
							ProduceSound(p[v], weapSound[weapType[pWeapon[cyc]]], 22050, 1)
							if weapStyle[weapType[pWeapon[cyc]]] == 7 do ProduceSound(p[v], sStab, 22050, 1)
							ProduceSound(p[v], sImpact[3], 22050, 0)
							ProduceSound(p[v], sPain[bb.RndI(1, 8)], 22050, 1)
							impactY := pY[cyc] + 20
							if impactY > bb.EntityY(pLimb[v][1], 1) do impactY = bb.EntityY(pLimb[v][1], 1)
							CreateSpurt(pX[v], impactY, pZ[v], 2, 10, 99)
							ScarArea(v, pX[v], impactY, pZ[v], 2)
							if CountScars(v) >= 2 {
								ScarWeapon(pWeapon[cyc], 5)
								CreatePool(pX[v], pGround[v], pZ[v], bb.RndF(2.0, 8.0), 1, 1)
							}
							ChangeAnim(v, 70)
							pDT[v] = (150 - pHealth[v]) * 2
							pHealth[v] -= GetPower(cyc)
							pHP[v] -= GetPower(cyc)
							pDT[v] += (weapDamage[weapType[pWeapon[cyc]]] * 10)
							pHealth[v] -= weapDamage[weapType[pWeapon[cyc]]]
							pHP[v] -= weapDamage[weapType[pWeapon[cyc]]]
							if weapName[weapType[pWeapon[cyc]]] == "Syringe" && pInjured[v] < 100 {
								pInjured[v] = bb.RndI(100, 500)
							}
						}
						if blocked == 1 {
							if pWeapon[v] > 0 {
								ProduceSound(p[v], weapSound[weapType[pWeapon[v]]], 22050, 0)
								DropWeapon(v, 10)
							}
							ProduceSound(p[v], weapSound[weapType[pWeapon[cyc]]], 22050, 0)
							ProduceSound(p[v], sImpact[6], 22050, 0)
							impactY := pY[cyc] + 20
							if impactY > bb.EntityY(pLimb[v][1], 1) do impactY = bb.EntityY(pLimb[v][1], 1)
							CreateSpurt(pX[v], impactY, pZ[v], 2, 10, 4)
							for limb in i32(4)..=29 {
								if pWeapon[v] == 0 do ScarLimb(v, limb, 10)
							}
							if pWeapon[v] == 0 do pHealth[v] -= 1
							pHP[v] -= 1
						}
						pHurtA[v] = pA[cyc]
						pStagger[v] = cast(f32)(range - contact) * 0.2
						if pStagger[v] < 0.2 do pStagger[v] = 0.2
						RiskAnger(cyc, v)
						GainStrength(cyc, 25)
						DamageRep(cyc, v, 2)
						pSting[cyc] = 0
					}
				}
			}
		}
		if pAnimTim[cyc] > 26 do ChangeAnim(cyc, 0)
	}
	// rear swing
	if pAnim[cyc] == 44 {
		if pAnimTim[cyc] == 0 {
			bb.Animate(p[cyc], 3, 4.0, pSeq[cyc][44], 10)
			for v in 1..=no_plays {
				pMultiSting[cyc][v] = 1
			}
		}
		if pAnimTim[cyc] == 5 do ProduceSound(p[cyc], sSwing, 22050, 0)
		if pAnimTim[cyc] >= 5 && pAnimTim[cyc] <= 16 {
			bb.RotateEntity(pPivot[cyc], 0, pA[cyc], 0)
			bb.MoveEntity(pPivot[cyc], 0, 0, -1.0)
			pStepTim[cyc] += bb.RndI(0, 1)
		}
		if pAnimTim[cyc] >= 7 && pAnimTim[cyc] <= 20 {
			for v in 1..=no_plays {
				if cyc != v && (Friendly(cyc, v) == 0 || v == pFoc[cyc]) && pY[cyc] > pY[v] - 30 && pY[cyc] < pY[v] + 5 && AttackViable(v) == 1 && pMultiSting[cyc][v] == 1 {
					if cast(bool)LimbProximity(bb.FindChild(p[cyc], weapFile[weapType[pWeapon[cyc]]]), pX[v], pZ[v], 8) || cast(bool)LimbProximity(pLimb[cyc][18], pX[v], pZ[v], 8) || cast(bool)LimbProximity(pLimb[cyc][19], pX[v], pZ[v], 8) {
						charAttacker[pChar[v]] = pChar[cyc]
						blocked: i32 = 0
						randy := bb.RndI(0, 10)
						if randy <= 3 + BlockPower(v) && pAnim[v] >= 74 && pAnim[v] <= 75 && cast(bool)InLine(v, p[cyc], 90) do blocked = 1
						if blocked == 0 {
							ProduceSound(p[v], weapSound[weapType[pWeapon[cyc]]], 22050, 1)
							if weapStyle[weapType[pWeapon[cyc]]] == 7 do ProduceSound(p[v], sStab, 22050, 1)
							ProduceSound(p[v], sImpact[3], 22050, 0)
							ProduceSound(p[v], sPain[bb.RndI(1, 8)], 22050, 1)
							CreateSpurt(pX[v], pY[cyc] + 20, pZ[v], 2, 10, 99)
							ScarArea(v, pX[v], pY[cyc] + 20, pZ[v], 2)
							if CountScars(v) >= 2 {
								ScarWeapon(pWeapon[cyc], 5)
								CreatePool(pX[v], pGround[v], pZ[v], bb.RndF(2.0, 8.0), 1, 1)
							}
							ChangeAnim(v, 70)
							pDT[v] = (150 - pHealth[v]) * 2
							pHealth[v] -= GetPower(cyc)
							pHP[v] -= GetPower(cyc)
							pDT[v] += (weapDamage[weapType[pWeapon[cyc]]] * 10)
							pHealth[v] -= weapDamage[weapType[pWeapon[cyc]]]
							pHP[v] -= weapDamage[weapType[pWeapon[cyc]]]
							if weapName[weapType[pWeapon[cyc]]] == "Syringe" && pInjured[v] < 100 {
								pInjured[v] = bb.RndI(100, 500)
							}
						}
						if blocked == 1 {
							if pWeapon[v] > 0 {
								ProduceSound(p[v], weapSound[weapType[pWeapon[v]]], 22050, 0)
								DropWeapon(v, 10)
							}
							ProduceSound(p[v], weapSound[weapType[pWeapon[cyc]]], 22050, 1)
							ProduceSound(p[v], sImpact[6], 22050, 0)
							CreateSpurt(pX[v], pY[cyc] + 20, pZ[v], 2, 10, 4)
							for limb in i32(4)..=29 {
								if pWeapon[v] == 0 do ScarLimb(v, limb, 10)
							}
							if pWeapon[v] == 0 do pHealth[v] -= 1
							pHP[v] -= 1
						}
						pHurtA[v] = pA[cyc] + 180
						pStagger[v] = 1.2
						RiskAnger(cyc, v)
						GainStrength(cyc, 25)
						DamageRep(cyc, v, 2)
						pMultiSting[cyc][v] = 0
					}
				}
			}
		}
		if pAnimTim[cyc] > 30 {
			SharpTransition(cyc, 1, 180)
			ChangeAnim(cyc, 0)
		}
	}
	//----------- 60-70: GUN ATTACKS ----------
	// fire machine gun
	if pAnim[cyc] == 60 {
		if pAnimTim[cyc] == 0 {
			bb.Animate(p[cyc], 1, 1.5, pSeq[cyc][63], 5)
			pFireTim[cyc] = 0
		}
		if cDefend[cyc] == 0 || pControl[cyc] == 0 do FaceEntity(cyc, p[pFoc[cyc]], 5)
		pFireTim[cyc] += 1
		if pFireTim[cyc] == 5 {
			ProduceSound(p[cyc], sShot[bb.RndI(1, 2)], 22050, 0)
			flame := bb.FindChild(p[cyc], "FlameA")
			CreateParticle(bb.EntityX(flame, 1), bb.EntityY(flame, 1), bb.EntityZ(flame, 1), 2)
		}
		if pFireTim[cyc] == 6 do FireBullet(cyc)
		if pFireTim[cyc] >= 7 do pFireTim[cyc] = 1
		endTim: i32 = 10
		if pControl[cyc] == 0 do endTim = 20
		if pAnimTim[cyc] > endTim && (cAttack[cyc] == 0 || cast(bool)InProximity(cyc, pFoc[cyc], 20)) do ChangeAnim(cyc, 0)
		if weapClip[pWeapon[cyc]] == 0 do ChangeAnim(cyc, 62)
	}
	// fire pistol
	if pAnim[cyc] == 61 {
		if pAnimTim[cyc] == 0 {
			bb.Animate(p[cyc], 1, 1.5, pSeq[cyc][64], 5)
			pFireTim[cyc] = 0
		}
		if cDefend[cyc] == 0 || pControl[cyc] == 0 do FaceEntity(cyc, p[pFoc[cyc]], 5)
		pFireTim[cyc] += 1
		if pFireTim[cyc] == 5 {
			ProduceSound(p[cyc], sShot[bb.RndI(1, 2)], 22050, 1)
			flame := bb.FindChild(p[cyc], "FlameB")
			CreateParticle(bb.EntityX(flame, 1), bb.EntityY(flame, 1), bb.EntityZ(flame, 1), 2)
		}
		if pFireTim[cyc] == 6 do FireBullet(cyc)
		if pFireTim[cyc] >= 7 do pFireTim[cyc] = -5
		endTim: i32 = 10
		if pControl[cyc] == 0 do endTim = 20
		if pAnimTim[cyc] > endTim && (cAttack[cyc] == 0 || cast(bool)InProximity(cyc, pFoc[cyc], 20)) do ChangeAnim(cyc, 0)
		if weapClip[pWeapon[cyc]] == 0 do ChangeAnim(cyc, 62)
	}
	// reload
	if pAnim[cyc] == 62 {
		if pAnimTim[cyc] == 0 do bb.Animate(p[cyc], 1, 3.0, pSeq[cyc][65], 5)
		if pAnimTim[cyc] == 13 {
			ProduceSound(p[cyc], sReload, 22050, 0)
			weapClip[pWeapon[cyc]] = bb.RndI(1, 10)
			if weapClip[pWeapon[cyc]] > weapAmmo[pWeapon[cyc]] do weapClip[pWeapon[cyc]] = weapAmmo[pWeapon[cyc]]
		}
		if pAnimTim[cyc] > 28 {
			ChangeAnim(cyc, 0)
			if pControl[cyc] == 0 && weapClip[pWeapon[cyc]] == 0 do ChangeAnim(cyc, 21)
		}
	}
	//----------- 70-80: HURTING & BLOCKING ----------
	//upper hurt
	if pAnim[cyc] == 70 {
		if pAnimTim[cyc] == 0 do bb.Animate(p[cyc], 3, bb.RndF(1.0, 2.0), pSeq[cyc][70], 5)
		pStagger[cyc] -= 0.04
		if pAnimTim[cyc] <= 10 && pStagger[cyc] > 0 {
			bb.RotateEntity(pPivot[cyc], 0, pHurtA[cyc], 0)
			bb.MoveEntity(pPivot[cyc], 0, 0, pStagger[cyc])
			pStepTim[cyc] += bb.RndI(0, 1)
		}
		if pAnimTim[cyc] > 5 {
			randy: i32 = bb.RndI(0, 50)
			if randy == 0 && cast(bool)DirPressed(cyc) do ChangeAnim(cyc, 0)
			if randy <= 1 && cast(bool)ActionPressed(cyc) do ChangeAnim(cyc, 0)
		}
		if pAnimTim[cyc] > 25 do ChangeAnim(cyc, 0)
		DropWeapon(cyc, 20)
	}
	//lower hurt
	if pAnimTim[cyc] == 71 {
		if pAnimTim[cyc] == 0 do bb.Animate(p[cyc], 3, bb.RndF(1.5, 2.5), pSeq[cyc][71], 5)
		pStagger[cyc] -= 0.04
		if pAnimTim[cyc] <= 10 && pStagger[cyc] > 0 {
			bb.RotateEntity(pPivot[cyc], 0, pHurtA[cyc], 0)
			bb.MoveEntity(pPivot[cyc], 0, 0, pStagger[cyc])
			pStepTim[cyc] += bb.RndI(0, 1)
		}
		if pAnimTim[cyc] > 5 {
			randy: i32 = bb.RndI(0, 50)
			if randy == 0 && cast(bool)DirPressed(cyc) do ChangeAnim(cyc, 0)
			if randy <= 1 && cast(bool)ActionPressed(cyc) do ChangeAnim(cyc, 0)
		}
		if pAnimTim[cyc] > 25 do ChangeAnim(cyc, 0)
		DropWeapon(cyc, 20)
	}
	//ground hurt (on back)
	if pAnim[cyc] == 72 {
		if pAnimTim[cyc] == 0 do bb.Animate(p[cyc], 3, bb.RndF(1.5, 2.5), pSeq[cyc][72], 5)
		randy := bb.RndI(0, 100)
		if randy == 0 && pAnimTim[cyc] > 5 do ChangeAnim(cyc, 81)
		if pDT[cyc] <= 0 && (cast(bool)DirPressed(cyc) || cast(bool)ActionPressed(cyc) || pHealth[cyc] <= 0) do ChangeAnim(cyc, 81)
		if pAnimTim[cyc] > 24 do ChangeAnim(cyc, 81)
		DropWeapon(cyc, 5)
	}
	//ground hurt (on front)
	if pAnim[cyc] == 73 {
		if pAnimTim[cyc] == 0 do bb.Animate(p[cyc], 3, bb.RndF(1.5, 2.5), pSeq[cyc][73], 5)
		randy: i32 = bb.RndI(0, 100)
		if randy == 0 && pAnimTim[cyc] > 5 do ChangeAnim(cyc, 84)
		if pDT[cyc] <= 0 && (cast(bool)DirPressed(cyc) || cast(bool)ActionPressed(cyc) || pHealth[cyc] <= 0) do ChangeAnim(cyc, 84)
		if pAnimTim[cyc] > 28 do ChangeAnim(cyc, 84)
		DropWeapon(cyc, 5)
	}
	//upper block
	if pAnim[cyc] == 74 {
		anim: i32 = 74
		threat := FindThreat(cyc)
		if pWeapon[cyc] > 0 do anim = 76
		if pAnimTim[cyc] == 0 || anim != pState[cyc] {
			bb.Animate(p[cyc], 1, bb.RndF(0.2, 0.5), pSeq[cyc][anim], 6)
			pState[cyc] = anim
		}
		FaceEntity(cyc, p[pFoc[cyc]], 5)
		pStagger[cyc] -= 0.1
		if pStagger[cyc] > 0 {
			bb.RotateEntity(pPivot[cyc], 0, pHurtA[cyc], 0)
			bb.MoveEntity(pPivot[cyc], 0, 0, pStagger[cyc])
			pStepTim[cyc] += bb.RndI(0, 1)
		}
		if pAnimTim[cyc] > 5 && pStagger[cyc] <= 0 {
			if cDefend[cyc] == 0 || cAttack[cyc] == 1 do ChangeAnim(cyc, 0)
		}
		if cast(bool)DirPressed(cyc) do ChangeAnim(cyc, 0)
		if threat == 2 do ChangeAnim(cyc, 75)
	}
	//lower block
	if pAnim[cyc] == 75 {
		anim: i32 = 75
		//threat := FindThreat(cyc) Unused
		if pWeapon[cyc] > 0 do anim = 77
		if pAnimTim[cyc] == 0 || anim != pState[cyc] {
			bb.Animate(p[cyc], 1, bb.RndF(0.2, 0.5), pSeq[cyc][anim], 6)
			pState[cyc] = anim
		}
		FaceEntity(cyc, p[pFoc[cyc]], 5)
		pStagger[cyc] -= 0.1
		if pStagger[cyc] > 0 {
			bb.RotateEntity(pPivot[cyc], 0, pHurtA[cyc], 0)
			bb.MoveEntity(pPivot[cyc], 0, 0, pStagger[cyc])
			pStepTim[cyc] += bb.RndI(0, 1)
		}
		if pAnimTim[cyc] > 5 && pStagger[cyc] <= 0 {
			if cDefend[cyc] == 0 || cAttack[cyc] == 1 do ChangeAnim(cyc, 1)
		}
		if cast(bool)DirPressed(cyc) do ChangeAnim(cyc, 1)
	}
	//dying
	if pAnim[cyc] == 76 || pAnim[cyc] == 77 {
		if pAnimTim[cyc] == 0 {
			bb.Animate(p[cyc], 3, 1.0, pSeq[cyc][pAnim[cyc] + 2], 5)
		}
		if pAnimTim[cyc] == 5 {
			chDeath = bb.EmitSound(sDeath, p[cyc])
			if charAttacker[pChar[cyc]] > 0 && charWitness[charAttacker[pChar[cyc]]] > 0 {
				charReputation[charAttacker[pChar[cyc]]] += bb.RndI(1, 5)
			}
			if gamMission[slot] == 14 && pChar[cyc] == gamTarget[slot] {
				CompleteMission(1)
			}
			for v in 1..=no_plays {
				pAgenda[v] = 2
				pFollowFoc[v] = cyc
				pSubX[v] = 9999
				pSubZ[v] = 9999
			}
		}
		randy: i32 = bb.RndI(0, 200)
		if randy > 1 && pControl[cyc] > 0 && pAnimTim[cyc] > 70 {
			randy = bb.RndI(0, 150)
		}
		if randy > 1 && pControl[cyc] > 0 && pAnimTim[cyc] > 100 {
			randy = bb.RndI(0, 100)
		}
		if (randy <= 1 || pHealth[cyc] > 0) && pAnimTim[cyc] > 30 && pAnimTim[cyc] < 130 {
			if bb.ChannelPlaying(chDeath) {
				bb.StopChannel(chDeath)
			}
			if pAnim[cyc] == 76 {
				ChangeAnim(cyc, 82)
			}
			if pAnim[cyc] == 77 {
				SharpTransition(cyc, 85, 180)
				ChangeAnim(cyc, 85)
			}
			pHealth[cyc] = 25
			if charAttacker[pChar[cyc]] == gamChar[slot] && charWitness[gamChar[slot]] > 0 && charHealth[charWitness[gamChar[slot]]] > 0 {
				if gamWarrant[slot] < 12 {
					gamWarrant[slot] = 12
					gamVictim[slot] = pChar[cyc]
				}
			}
		}
		if pAnimTim[cyc] == 150 {
			if charAttacker[pChar[cyc]] > 0 {
				for v in 1..=no_chars {
					if charRelation[v][pChar[cyc]] > 0 {
						charRelation[v][charAttacker[pChar[cyc]]] = -1
					}
					if charAttacker[pChar[cyc]] == gamChar[slot] && charPromo[v][gamChar[slot]] == 0 && v != gamClient[slot] {
						if charRelation[v][pChar[cyc]] > 0 {
							charPromo[v][gamChar[slot]] = 82
							charPromoRef[v] = pChar[cyc]
						}
						if charRelation[v][pChar[cyc]] < 0 && charRelation[v][gamChar[slot]] >= 0 {
							charPromo[v][gamChar[slot]] = 83
							charPromoRef[v] = pChar[cyc]
						}
					}
				}
				if charWitness[charAttacker[pChar[cyc]]] > 0 {
					charReputation[charAttacker[pChar[cyc]]] += bb.RndI(1, 5)
					if charAttacker[pChar[cyc]] == gamChar[slot] && charHealth[charWitness[gamChar[slot]]] > 0 {
						if gamWarrant[slot] == 13 {
							gamWarrant[slot] = 14
						}
						if gamWarrant[slot] < 13 {
							gamWarrant[slot] = 13
						}
						gamVictim[slot] = pChar[cyc]
					}
				}
			}
			if gamMission[slot] > 0 && pChar[cyc] == gamClient[slot] {
				gamMission[slot] = 0
			}
			if gamMission[slot] >= 13 && gamMission[slot] <= 15 && pChar[cyc] == gamTarget[slot] {
				CompleteMission(1)
			}
		}
		if pAnimTim[cyc] > 150 {
			if pChar[cyc] == gamChar[slot] do fadeTarget = 1.0
			if pChar[cyc] == gamChar[slot] && pAnimTim[cyc] > 560 do go = 1
		}
		DropWeapon(cyc, 0)
	}
	//----------- 80-90: FALLING & RISING ----------
	//fall onto back
	if pAnim[cyc] == 80 {
		if pAnimTim[cyc] == 0 {
			bb.Animate(p[cyc], 3, 2.0, pSeq[cyc][80], 10)
			pStagger[cyc] = 1.75
			pStagger[cyc] -= 0.04
			if pAnimTim[cyc] <= 30 && pStagger[cyc] > 0 {
				pHurtA[cyc] = CleanAngle(pA[cyc] + 180)
				bb.RotateEntity(pPivot[cyc], 0, pA[cyc], 0)
				bb.MoveEntity(pPivot[cyc], 0, 0, -pStagger[cyc])
				pStepTim[cyc] += bb.RndI(0, 1)
			}
			if pAnimTim[cyc] == 22 {
				ProduceSound(p[cyc], sFall, 22050, 0)
				ProduceSound(p[cyc], sPain[bb.RndI(1, 8)], 22050, 0)
				ScarArea(cyc, 0, 0, 0, 10)
				FindSmashes(cyc)
				RiskInjury(cyc, 200)
				charHappiness[pChar[cyc]] -= 1
				charReputation[pChar[cyc]] -= bb.RndI(0, 1)
			}
			if pAnimTim[cyc] > 45 do ChangeAnim(cyc, 81)
			DropWeapon(cyc, 20)
		}
		//lying on back
		if pAnim[cyc] == 81 {
			transition: i32 = 5
			if pOldAnim[cyc] == 72 do transition = 10
			if pAnimTim[cyc] == 0 || pHealth[cyc] <= 0 {
				bb.Animate(p[cyc], 1, bb.RndF(0.1, 0.4), pSeq[cyc][81], transition)
			}
			if pDT[cyc] <= 0 && pHealth[cyc] > 0 {
				if cast(bool)DirPressed(cyc) || cast(bool)ActionPressed(cyc) || cyc == promoActor[1] || cyc == promoActor[2] || cast(bool)bb.KeyDown(1) do ChangeAnim(cyc, 82)
			}
			if gotim > 0 && pHealth[cyc] <= 0 && (gamPromo == 0 || pChar[cyc] != gamChar[slot]) do ChangeAnim(cyc, 76)
			if gamMission[slot] == 15 && pChar[cyc] == gamTarget[slot] && charAttacker[pChar[cyc]] == gamChar[slot] do CompleteMission(1)
			if gamMission[slot] == 18 && pChar[cyc] == gamClient[slot] && gamPromo != 158 do CompleteMission(-1)
		}
		//get up off back
		if pAnim[cyc] == 82 {
			if pAnimTim[cyc] == 0 {
				pAnimSpeed := bb.RndF(2.0, 4.0)
				if pInjured[cyc] > 0 do pAnimSpeed = 2.0
				bb.Animate(p[cyc], 3, pAnimSpeed, pSeq[cyc][82], 5)
			}
			animSpd := pAnimSpeed[cyc]
			if pAnimTim[cyc] == i32(25 / animSpd) || pAnimTim[cyc] == i32(55 / animSpd) {
				ProduceSound(p[cyc], sShuffle[bb.RndI(1, 3)], 44100, 0.5)
			}
			if pAnimTim[cyc] == i32(85 / animSpd) {
				pStepTim[cyc] = 99
				if cAttack[cyc] == 0 && pControl[cyc] == 0 && cast(bool)InProximity(cyc, pFoc[cyc], 20) && AttackViable(pFoc[cyc]) >= 1 && AttackViable(pFoc[cyc]) <= 2 {
					if charAngerTim[pChar[cyc]][pChar[pFoc[cyc]]] > 0 do cAttack[cyc] = bb.RndI(0, 1)
				}
				if cAttack[cyc] == 1 || cDefend[cyc] == 1 {
					SharpTransition(cyc, 2, 90)
					if cAttack[cyc] == 1 do ChangeAnim(cyc, 35)
					if cDefend[cyc] == 1 do ChangeAnim(cyc, 75)
				}
			}
			if pAnimTim[cyc] > i32(115 / animSpd) do ChangeAnim(cyc, 0)
			pHP[cyc] = bb.RndI(1, charStrength[pChar[cyc]] / 5)
		}
		//fall onto front (turn)
		if pAnim[cyc] == 83 {
			if pAnimTim[cyc] == 0 {
				bb.Animate(p[cyc], 3, 2.0, pSeq[cyc][83], 10)
				pStagger[cyc] = 1.5
			}
			pStagger[cyc] -= 0.025
			if pAnimTim[cyc] <= 35 && pStagger[cyc] > 0 {
				pHurtA[cyc] = CleanAngle(pA[cyc] + 180)
				bb.RotateEntity(pPivot[cyc], 0, pA[cyc], 0)
				bb.MoveEntity(pPivot[cyc], 0, 0, -pStagger[cyc])
				pStepTim[cyc] += bb.RndI(0, 1)
			}
			if pAnimTim[cyc] == 22 {
				ProduceSound(p[cyc], sFall, 22050, 0)
				ProduceSound(p[cyc], sPain[bb.RndI(1, 8)], 22050, 0)
				ScarArea(cyc, 0, 0, 0, 10)
				FindSmashes(cyc)
				RiskInjury(cyc, 200)
				charHappiness[pChar[cyc]] -= 1
				charReputation[pChar[cyc]] -= bb.RndI(0, 1)
			}
			if pAnimTim[cyc] > 50 do ChangeAnim(cyc, 84)
			DropWeapon(cyc, 20)
		}
		//lying on front
		if pAnim[cyc] == 84 {
			transition: i32 = 5
			if pOldAnim[cyc] == 73 do transition = 10
			if pAnimTim[cyc] == 0 || pHealth[cyc] <= 0 {
				bb.Animate(p[cyc], 1, bb.RndF(0.1, 0.4), pSeq[cyc][84], transition)
			}
			if pDT[cyc] <= 0 && pHealth[cyc] > 0 {
				if cast(bool)DirPressed(cyc) || cast(bool)ActionPressed(cyc) || cyc == promoActor[1] || cyc == promoActor[2] || cast(bool)bb.KeyDown(1) do ChangeAnim(cyc, 85)
			}
			if gotim > 0 && pHealth[cyc] <= 0 && (gamPromo == 0 || pChar[cyc] != gamChar[slot]) {
				SharpTransition(cyc, 85, 180)
				ChangeAnim(cyc, 85)
			}
		}
		if gotim > 0 && pHealth[cyc] <= 0 && (gamPromo == 0 || pChar[cyc] != gamChar[slot]) do ChangeAnim(cyc, 77)
		if gamMission[slot] == 15 && pChar[cyc] == gamTarget[slot] && charAttacker[pChar[cyc]] == gamChar[slot] do CompleteMission(1)
		if gamMission[slot] == 18 && pChar[cyc] == gamClient[slot] && gamPromo != 158 do CompleteMission(-1)
	}
	//get up off front
	if pAnim[cyc] == 85 {
		if pAnimTim[cyc] == 0 {
			pAnimSpeed[cyc] = bb.RndF(2.0, 4.0)
			if pInjured[cyc] > 0 {
				pAnimSpeed[cyc] = 2.0
			}
			bb.Animate(p[cyc], 3, pAnimSpeed[cyc], pSeq[cyc][85], 5)
		}
		if pAnimTim[cyc] ==i32(25 / pAnimSpeed[cyc]) {
			ProduceSound(p[cyc], sShuffle[bb.RndI(1, 3)], 44100, 0.5)
		}
		if pAnimTim[cyc] ==i32(55 / pAnimSpeed[cyc]) {
			pStepTim[cyc] = 99
			if cAttack[cyc] == 0 && pControl[cyc] == 0 && cast(bool)InProximity(cyc, pFoc[cyc], 20) {
				if AttackViable(pFoc[cyc]) >= 1 && AttackViable(pFoc[cyc]) <= 2 {
					cAttack[cyc] = bb.RndI(0, 1)
				}
			}
			if cAttack[cyc] == 1 do ChangeAnim(cyc, 35)
			if cDefend[cyc] == 1 do ChangeAnim(cyc, 75)
		}
		if pAnimTim[cyc] >i32(75 / pAnimSpeed[cyc]) {
			ChangeAnim(cyc, 0)
		}
		pHP[cyc] = bb.RndI(1, charStrength[pChar[cyc]] / 5)
	}
	//fall onto front (direct)
	if pAnim[cyc] == 86 {
		if pAnimTim[cyc] == 0 {
			bb.Animate(p[cyc], 3, 2.5, pSeq[cyc][86], 10)
			pStagger[cyc] = 1.0
		}
		pStagger[cyc] -= 0.01
		if pAnimTim[cyc] <= 35 && pStagger[cyc] > 0 {
			pHurtA[cyc] = pA[cyc]
			bb.RotateEntity(pPivot[cyc], 0, pA[cyc], 0)
			bb.MoveEntity(pPivot[cyc], 0, 0, pStagger[cyc])
			pStepTim[cyc] +=i32(bb.RndI(0, 1))
		}
		if pAnimTim[cyc] == 21 {
			ProduceSound(p[cyc], sFall, 22050, 0)
			ProduceSound(p[cyc], sPain[bb.RndI(1, 8)], 22050, 0)
			ScarArea(cyc, 0, 0, 0, 10)
			FindSmashes(cyc)
			RiskInjury(cyc, 200)
			charHappiness[pChar[cyc]] -= 1
			charReputation[pChar[cyc]] -=i32(bb.RndI(0, 1))
		}
		if pAnimTim[cyc] > 45 {
			SharpTransition(cyc, 84, 180)
			ChangeAnim(cyc, 84)
		}
		DropWeapon(cyc, 20)
	}
	//falling from a height
	if pAnim[cyc] == 87 {
		if pAnimTim[cyc] == 0 {
			bb.Animate(p[cyc], 1, bb.RndF(0.5, 1.0), pSeq[cyc][87], 5)
			if pGravity[cyc] < 0 {
				pGravity[cyc] = 0
			}
		}
		if cast(bool)cLeft[cyc] do pA[cyc] = CleanAngle(pA[cyc] + 5)
		if cast(bool)cRight[cyc] do pA[cyc] = CleanAngle(pA[cyc] - 5)
		bb.RotateEntity(pPivot[cyc], 0, pHurtA[cyc], 0)
		if pAnimTim[cyc] > 100 do bb.RotateEntity(pPivot[cyc], 0, pA[cyc], 0)
		if gotim > 0 do bb.MoveEntity(pPivot[cyc], 0, 0, 1.0)
		if pY[cyc] < pGround[cyc] + 5 {
			ProduceSound(p[cyc], sThud, 22050, 0)
			CreateSpurt(pX[cyc], pY[cyc], pZ[cyc], 5, 5, 4)
			if gotim > 0 && pGravity[cyc] < -3.0 {
				pHP[cyc] -= 1
			}
			if gotim > 0 && pGravity[cyc] <= -10.0 {
				pHP[cyc] = 0
				pHealth[cyc] -= 1
			}
			ChangeAnim(cyc, 88)
		}
	}
	//landing from a fall
	if pAnim[cyc] == 88 {
		if pAnimTim[cyc] == 0 {
			bb.Animate(p[cyc], 1, 3.0, pSeq[cyc][88], 5)
		}
		if pAnimTim[cyc] == 10 {
			pStepTim[cyc] = 99
		}
		if (pAnimTim[cyc] > 10 && pHP[cyc] <= 0) || pAnimTim[cyc] > 20 {
			ChangeAnim(cyc, 0)
		}
	}
	//----------- 90-100: STANDING GESTURES ----------
	//enter door
	if pAnim[cyc] == 90 {
		speeder: f32 = 0
		if pWeapon[cyc] > 0 {
			speeder = -3.0
		} else {
			speeder = 3.0
		}
		if pAnimTim[cyc] == 0 {
			bb.Animate(p[cyc], 3, speeder, pSeq[cyc][90], 5)
		}
		if SatisfiedAngle(pA[cyc], doorA[gamLocation[slot]][gamDoor], 10) == 0 {
			pA[cyc] += ReachAngle(pA[cyc], doorA[gamLocation[slot]][gamDoor], 5)
		}
		if pAnimTim[cyc] == 5 do ProduceSound(cam, sDoor[1], 22050, 1)
		if pAnimTim[cyc] > 10 do EnterDoor(cyc, gamDoor)
	}
	//friendly wave
	if pAnim[cyc] == 91 {
		if pAnimTim[cyc] == 0 do bb.Animate(p[cyc], 3, 1.5, pSeq[cyc][91], 7)
		if pAnimTim[cyc] == 10 do charHappiness[pChar[cyc]] += 1
		if pAnimTim[cyc] == 20 do bb.Animate(p[cyc], 3, 1.0, pSeq[cyc][1], 10)
		if pAnimTim[cyc] > 25 do ChangeAnim(cyc, 0)
	}
	//sweeping
	if pAnim[cyc] == 92 {
		if pAnimTim[cyc] == 0 do bb.Animate(p[cyc], 1, 1.0, pSeq[cyc][92], 10)
		if pAnimTim[cyc] > 10 {
			randy: i32 = bb.RndI(0, 50)
			if randy == 0 {
				ProduceSound(p[cyc], sShuffle[bb.RndI(1, 3)], 22050, 0)
			}
			if randy == 1 {
				ProduceSound(p[cyc], sSwing, 22050, bb.RndF(0.0, 0.2))
			}
			if randy <= 10 {
				CreateParticle(bb.EntityX(bb.FindChild(p[cyc], "Broom"), 1), pY[cyc], bb.EntityZ(bb.FindChild(p[cyc], "Broom"), 1), 5)
			}
			if pChar[cyc] == gamChar[slot] && LockDown() == 0 && pAnimTim[cyc] > 160 {
				bb.PlaySound(sCash)
				statTim[7] = 50
				gamMoney[slot] += 5
				pHealth[cyc] -= 1
				//charHappiness[pChar[cyc]] += bb.RndI(1, 5)
				randy = bb.RndI(0, 10)
				if randy == 0 && charReputation[pChar[cyc]] > 50 {
					charReputation[pChar[cyc]] -= 1
				}
				if randy == 0 && charReputation[pChar[cyc]] < 50 {
					charReputation[pChar[cyc]] += 1
				}
				if randy == 1 {
					charStrength[pChar[cyc]] += 1
				}
				pAnimTim[cyc] = 10
			}
			if cast(bool)DirPressed(cyc) || cast(bool)ActionPressed(cyc) || cyc == promoActor[1] || cyc == promoActor[2] || cast(bool)bb.KeyDown(1) {
				ChangeAnim(cyc, 0)
			}
		}
	}
	//smoking
	if pAnim[cyc] == 93 {
		if pAnimTim[cyc] == 0 do bb.Animate(p[cyc], 1, bb.RndF(0.2, 0.4), pSeq[cyc][93], 10)
		if pAnimTim[cyc] > 10 {
			limb := bb.FindChild(p[cyc], "Cigar")
			randy: i32 = bb.RndI(0, 5)
			if randy == 0 do CreateParticle(bb.EntityX(limb, 1), bb.EntityY(limb, 1), bb.EntityZ(limb, 1), 2)
			if randy == 1 do CreateParticle(bb.EntityX(limb, 1), bb.EntityY(limb, 1), bb.EntityZ(limb, 1), 7)
			randy = bb.RndI(0, 100)
			if randy == 0 do ProduceSound(p[cyc], sChoke, 22050, bb.RndF(0.1, 0.5))
			if randy <= 2 {
				charHappiness[pChar[cyc]] += 1
				pHealth[cyc] -= 1
			}
			randy = bb.RndI(0, 1000)
			if randy <= 1 && gamLocation[slot] != 11 do charReputation[pChar[cyc]] += 1
			if randy == 2 do charStrength[pChar[cyc]] -= 1
			if cast(bool)DirPressed(cyc) || cast(bool)ActionPressed(cyc) || cyc == promoActor[1] || cyc == promoActor[2] || cast(bool)bb.KeyDown(1) do ChangeAnim(cyc, 0)
			ExhaustDrug(cyc)
		}
	}
	//injecting
	if pAnim[cyc] == 94 {
		if pAnimTim[cyc] == 0 do bb.Animate(p[cyc], 1, bb.RndF(0.1, 0.3), pSeq[cyc][94], 10)
		if pAnimTim[cyc] > 10 {
			randy := bb.RndI(0, 100)
			if randy == 0 do ProduceSound(p[cyc], sPain[bb.RndI(1, 8)], 22050, 0)
			if randy <= 2 {
				charHappiness[pChar[cyc]] -= 1
				pHealth[cyc] += 1
			}
			if pInjured[cyc] > 0 do pInjured[cyc] -=i32(bb.RndI(0, 1))
			randy = bb.RndI(0, 1000)
			if randy <= 1 && gamLocation[slot] != 11 do charReputation[pChar[cyc]] += 1
			if randy == 2 do charAgility[pChar[cyc]] -= 1
			if cast(bool)DirPressed(cyc) || cast(bool)ActionPressed(cyc) || cyc == promoActor[1] || cyc == promoActor[2] || cast(bool)bb.KeyDown(1) do ChangeAnim(cyc, 0)
			ExhaustDrug(cyc)
		}
	}
	//drinking
	if pAnim[cyc] == 95 {
		if pAnimTim[cyc] == 0 do bb.Animate(p[cyc], 1, bb.RndF(0.25, 0.5), pSeq[cyc][95], 10)
		if pAnimTim[cyc] > 10 {
			limb := bb.FindChild(p[cyc], "Bottle")
			randy := bb.RndI(0, 5)
			if randy == 0 do CreateParticle(bb.EntityX(limb, 1), bb.EntityY(limb, 1), bb.EntityZ(limb, 1), 14)
			randy = bb.RndI(0, 100)
			if randy == 0 do ProduceSound(p[cyc], sDrink, 22050, 0)
			if randy == 1 do ProduceSound(p[cyc], sBottle, 22050, bb.RndF(0.1, 0.3))
			if randy <= 2 {
				charHappiness[pChar[cyc]] += 1
				pHealth[cyc] -= 1
			}
			randy = bb.RndI(0, 1000)
			if randy <= 1 && gamLocation[slot] != 11 do charReputation[pChar[cyc]] += 1
			if randy == 2 do charIntelligence[pChar[cyc]] -= 1
			if cast(bool)DirPressed(cyc) || cast(bool)ActionPressed(cyc) || cyc == promoActor[1] || cyc == promoActor[2] || cast(bool)bb.KeyDown(1) do ChangeAnim(cyc, 0)
			ExhaustDrug(cyc)
		}
	}
	//nervous breakdown
	if pAnim[cyc] == 96 {
		if pAnimTim[cyc] == 0 {
			bb.Animate(p[cyc], 3, 1.0, pSeq[cyc][96], 20)
			ProduceSound(p[cyc], sBreakdown, 22050, 1)
			charReputation[pChar[cyc]] -= 1
			if gamMission[slot] == 14 && pChar[cyc] == gamTarget[slot] {
				CompleteMission(1)
			}
		}
		if pAnimTim[cyc] == 35 || pAnimTim[cyc] == 150 {
			ProduceSound(p[cyc], sShuffle[bb.RndI(1, 3)], 22050, 0)
		}
		if pAnimTim[cyc] == 60 || pAnimTim[cyc] == 180 || pAnimTim[cyc] == 240 || pAnimTim[cyc] == 270 {
			pStepTim[cyc] = 99
		}
		if pAnimTim[cyc] > 270 {
			charIntelligence[pChar[cyc]] -= 1
			if charHappiness[pChar[cyc]] < 50 {
				charHappiness[pChar[cyc]] = 50
			}
			charBreakdown[pChar[cyc]] = 1000
			ChangeAnim(cyc, 0)
			pAgenda[cyc] = 2
		}
		DropWeapon(cyc, 20)
	}
	//comb hair
	if pAnim[cyc] == 97 {
		if pAnimTim[cyc] == 0 do bb.Animate(p[cyc], 1, bb.RndF(0.25, 0.5), pSeq[cyc][97], 10)
		if pAnimTim[cyc] > 10 {
			if pControl[cyc] > 0 {
				oldStyle := charHairStyle[pChar[cyc]]
				oldHair := charHair[pChar[cyc]]
				if cLeft[cyc] == 1 && keytim == 0 {
					charHairStyle[pChar[cyc]] -= 1
					bb.PlaySound(sMenuBrowse)
					keytim = 6
				}
				if cRight[cyc] == 1 && keytim == 0 {
					charHairStyle[pChar[cyc]] += 1
					bb.PlaySound(sMenuBrowse)
					keytim = 6
				}
				if cUp[cyc] == 1 && keytim == 0 {
					charHair[pChar[cyc]] -= 1
					bb.PlaySound(sMenuBrowse)
					keytim = 6
				}
				if cDown[cyc] == 1 && keytim == 0 {
					charHair[pChar[cyc]] += 1
					bb.PlaySound(sMenuBrowse)
					keytim = 6
				}
				if charHairStyle[pChar[cyc]] < 0 do charHairStyle[pChar[cyc]] = no_hairstyles
				if charHairStyle[pChar[cyc]] > no_hairstyles do charHairStyle[pChar[cyc]] = 0
				if charHair[pChar[cyc]] < 1 do charHair[pChar[cyc]] = no_hairs
				if charHair[pChar[cyc]] > no_hairs do charHair[pChar[cyc]] = 1
				if charHairStyle[pChar[cyc]] != oldStyle || charHair[pChar[cyc]] != oldHair {
					ApplyCostume(cyc)
				}
			}
			if (cast(bool)DirPressed(cyc) && pControl[cyc] == 0) || cast(bool)ActionPressed(cyc) || cyc == promoActor[1] || cyc == promoActor[2] || cast(bool)bb.KeyDown(1) {
				ChangeAnim(cyc, 0)
			}
		}
	}
	//admire reflection
	if pAnim[cyc] == 98 {
		if pAnimTim[cyc] == 0 {
			bb.Animate(p[cyc], 1, bb.RndF(0.25, 0.5), pSeq[cyc][98], 10)
		}
		if pAnimTim[cyc] > 10 {
			if pControl[cyc] > 0 {
				oldCostume := charCostume[pChar[cyc]]
				oldSpecs := charSpecs[pChar[cyc]]
				if cLeft[cyc] == 1 && keytim == 0 {
					charCostume[pChar[cyc]] -= 1
					bb.PlaySound(sMenuBrowse)
					keytim = 6
				}
				if cRight[cyc] == 1 && keytim == 0 {
					charCostume[pChar[cyc]] += 1
					bb.PlaySound(sMenuBrowse)
					keytim = 6
				}
				if cUp[cyc] == 1 && keytim == 0 {
					charSpecs[pChar[cyc]] -= 1
					bb.PlaySound(sMenuBrowse)
					keytim = 6
				}
				if cDown[cyc] == 1 && keytim == 0 {
					charSpecs[pChar[cyc]] += 1
					bb.PlaySound(sMenuBrowse)
					keytim = 6
				}
				if charCostume[pChar[cyc]] < 0 do charCostume[pChar[cyc]] = no_costumes
				if charCostume[pChar[cyc]] > no_costumes do charCostume[pChar[cyc]] = 0
				if charSpecs[pChar[cyc]] < 0 do charSpecs[pChar[cyc]] = no_specs
				if charSpecs[pChar[cyc]] > no_specs do charSpecs[pChar[cyc]] = 0
				if charCostume[pChar[cyc]] != oldCostume || charSpecs[pChar[cyc]] != oldSpecs {
					ApplyCostume(cyc)
				}
			}
			if (cast(bool)DirPressed(cyc) && pControl[cyc] == 0) || cast(bool)ActionPressed(cyc) || cyc == promoActor[1] || cyc == promoActor[2] || cast(bool)bb.KeyDown(1) {
				ChangeAnim(cyc, 0)
			}
		}
	}
	//mock handover (money)
	if pAnim[cyc] == 99 {
		if pAnimTim[cyc] == 0 do bb.Animate(p[cyc], 3, 1.5, pSeq[cyc][99], 5)
		if pAnimTim[cyc] > 26 do ChangeAnim(cyc, 0)
	}
	//----------- 100-110: SITTING GESTURES ----------
	//sit down
	if pAnim[cyc] == 100 && pSeat[cyc] > 0 {
		bb.EntityType(pPivot[cyc], 0, 0)
		if pAnimTim[cyc] == 0 do bb.Animate(p[cyc], 1, 2.0, pSeq[cyc][10], 5)
		if pAnimTim[cyc] == 5 do bb.Animate(p[cyc], 1, 1.0, pSeq[cyc][100], 10)
		if pAnimTim[cyc] == 5 do pStepTim[cyc] = 99
		if pAnimTim[cyc] == 5 do ProduceSound(p[cyc], sShuffle[bb.RndI(1, 3)], 22050, 0)
		if pAnimTim[cyc] == 10 {
			ProduceSound(p[cyc], sThud, 22050, 0.3)
			ProduceSound(p[cyc], sGeneric, 22050, 0.3)
		}
		if pAnimTim[cyc] > 10 {
			ChangeAnim(cyc, 102)
			pAgenda[cyc] = 0
		}
		if weapType[pWeapon[cyc]] != 16 do DropWeapon(cyc, 0)
	}
	//lie down
	if pAnim[cyc] == 100 && pBed[cyc] > 0 {
		bb.EntityType(pPivot[cyc], 0, 0)
		if pAnimTim[cyc] == 0 do bb.Animate(p[cyc], 3, 2.0, pSeq[cyc][105], 1)
		if pAnimTim[cyc] == 5 do bb.Animate(p[cyc], 1, 1.0, pSeq[cyc][106], 15)
		if pAnimTim[cyc] == 5 do ProduceSound(p[cyc], sShuffle[bb.RndI(1, 3)], 22050, 0)
		if pAnimTim[cyc] > 15 {
			ChangeAnim(cyc, 103)
			pAgenda[cyc] = 0
		}
		DropWeapon(cyc, 0)
	}
	//get off chair
	if pAnim[cyc] == 101 && pSeat[cyc] > 0 {
		if pAnimTim[cyc] == 0 do bb.Animate(p[cyc], 1, 2.0, pSeq[cyc][10], 5)
		if pAnimTim[cyc] == 5 do ProduceSound(p[cyc], sShuffle[bb.RndI(1, 3)], 22050, 0)
		if pAnimTim[cyc] == 5 do pStepTim[cyc] = 99
		if pAnimTim[cyc] > 10 {
			bb.ResetEntity(pPivot[cyc])
			bb.PositionEntity(pPivot[cyc], pX[cyc], pY[cyc] + 18, pZ[cyc])
			bb.EntityType(pPivot[cyc], 1, 0)
			bb.EntityRadius(pPivot[cyc], 8, 18)
			ChangeAnim(cyc, 0)
			pSeat[cyc] = 0
		}
	}
	//get off bed
	if pAnim[cyc] == 101 && pBed[cyc] > 0 {
		if pAnimTim[cyc] == 0 do bb.Animate(p[cyc], 3, 2.0, pSeq[cyc][107], 1)
		if pAnimTim[cyc] == 5 do ProduceSound(p[cyc], sShuffle[bb.RndI(1, 3)], 22050, 0)
		if pAnimTim[cyc] == 15 do pStepTim[cyc] = 99
		if pAnimTim[cyc] > 20 {
			bb.ResetEntity(pPivot[cyc])
			bb.PositionEntity(pPivot[cyc], pX[cyc], pY[cyc] + 18, pZ[cyc])
			bb.EntityType(pPivot[cyc], 1, 0)
			bb.EntityRadius(pPivot[cyc], 8, 18)
			ChangeAnim(cyc, 0)
			pBed[cyc] = 0
		}
	}
	//sitting loop
	if pAnim[cyc] == 102 {
		anim: i32 = 101
		speeder := bb.RndF(0.1, 0.3)
		if gamLocation[slot] == 2 && pSeat[cyc] >= 1 && pSeat[cyc] <= 3 {
			anim = 108
			speeder = bb.RndF(0.5, 1.0)
		}
		if cast(bool)OnComputer(cyc) {
			if pAnimTim[cyc] == 0 do gamFile = bb.RndI(1, no_chars)
			if charIntelligence[pChar[cyc]] >= 70 {
				anim = 109
				speeder = bb.RndF(0.25, 0.5)
			}
			if charIntelligence[pChar[cyc]] < 70 && pChar[cyc] == gamChar[slot] && gamPromo == 0 && promoUsed[19] == 0 {
				TriggerPromo(cyc, 0, 19)
			}
		}
		if charRole[pChar[cyc]] == 0 {
			if gamLocation[slot] == 4 && pSeat[cyc] >= 1 && pSeat[cyc] <= 3 {
				anim = 102
				speeder = bb.RndF(0.1, 0.3)
			}
			if cyc != promoActor[1] && cyc != promoActor[2] {
				if gamLocation[slot] == 4 && pSeat[cyc] == 4 {
					if charIntelligence[pChar[cyc]] >= 70 {
						anim = 104
						speeder = 0.5
					}
					if charIntelligence[pChar[cyc]] < 70 && pChar[cyc] == gamChar[slot] && gamPromo == 0 && promoUsed[21] == 0 {
						TriggerPromo(cyc, 0, 21)
					}
				}
				if gamLocation[slot] == 6 && pSeat[cyc] == 9 {
					if charIntelligence[pChar[cyc]] >= 80 {
						anim = 104
						speeder = 0.5
					}
					if charIntelligence[pChar[cyc]] < 80 && pChar[cyc] == gamChar[slot] && gamPromo == 0 && promoUsed[22] == 0 {
						TriggerPromo(cyc, 0, 22)
					}
				}
				if gamLocation[slot] == 8 && bb.FindChild(world, fmt.tprintf("Tray%v", pSeat[cyc])) > 0 && gamPromo != 27 {
					if trayState[pSeat[cyc]] > 0 || pFoodTim[cyc] > 0 {
						anim = 103
						speeder = 1.0
					}
				}
				if gamLocation[slot] == 8 && pSeat[cyc] == 45 {
					if charIntelligence[pChar[cyc]] >= 60 {
						anim = 104
						speeder = 0.5
					}
					if charIntelligence[pChar[cyc]] < 60 && pChar[cyc] == gamChar[slot] && gamPromo == 0 && promoUsed[20] == 0 {
						TriggerPromo(cyc, 0, 20)
					}
				}
				if gamLocation[slot] == 10 && pSeat[cyc] <= 6 && charRole[pChar[cyc]] == 0 {
					if kitState[pSeat[cyc]] > 0 && charStrength[pChar[cyc]] >= 70 {
						anim = 104
						speeder = 0.5
					}
					if kitState[pSeat[cyc]] > 0 && charStrength[pChar[cyc]] < 70 && pChar[cyc] == gamChar[slot] && gamPromo == 0 && promoUsed[23] == 0 {
						TriggerPromo(cyc, 0, 23)
					}
				}
			}
		}
		if pAnimTim[cyc] == 0 || anim != pState[cyc] {
			bb.Animate(p[cyc], 1, speeder, pSeq[cyc][anim], 10)
			pState[cyc] = anim
			pFoodTim[cyc] = 0
		}
		SittingEffects(cyc)
		if pAnimTim[cyc] > 10 && keytim == 0 {
			randy := bb.RndI(0, 500)
			if (randy == 0 || pAgenda[cyc] == 2 || pAgenda[cyc] == 4) && pControl[cyc] == 0 {
				ChangeAnim(cyc, 101)
			}
			if pControl[cyc] > 0 && (cast(bool)DirPressed(cyc) || cast(bool)ActionPressed(cyc) || cast(bool)bb.KeyDown(1)) {
				ChangeAnim(cyc, 101)
			}
			if pAnim[cyc] == 101 && pState[cyc] == 108 {
				ProduceSound(p[cyc], sThud, 22050, 0)
				ProduceSound(p[cyc], sAxe, 22050, 0)
			}
		}
	}
	//sleeping
	if pAnim[cyc] == 103 {
		if pAnimTim[cyc] == 0 do bb.Animate(p[cyc], 1, bb.RndF(0.1, 0.4), pSeq[cyc][106], 5)
		randy := bb.RndI(0, 100)
		if pInjured[cyc] > 0 do randy = bb.RndI(0, 300)
		if randy == 0 do ProduceSound(p[cyc], sSnore, 8000, bb.RndF(0.1, 1.0))
		if randy <= 1 && pHealth[cyc] < 100 do charHappiness[pChar[cyc]] += 1
		if randy <= 3 && pHealth[cyc] >= 100 do charHappiness[pChar[cyc]] -= 1
		if randy <= 3 do pHealth[cyc] += 1
		if pAnimTim[cyc] > 10 {
			randy = bb.RndI(0, 500)
			if (randy == 0 || pAgenda[cyc] == 2) && pControl[cyc] == 0 && !cast(bool)LockDown() do ChangeAnim(cyc, 101)
			if pControl[cyc] > 0 && (cast(bool)DirPressed(cyc) || cast(bool)ActionPressed(cyc) || cast(bool)bb.KeyDown(1)) do ChangeAnim(cyc, 101)
			if (cyc == promoActor[1] || cyc == promoActor[2]) && gamPromo != 8 && gamPromo != 11 do ChangeAnim(cyc, 101)
		}
	}
	//------------- 130+: ADDITIONAL -------------
	//changed body shape
	if pAnim[cyc] == 130 {
		if pAnimTim[cyc] == 0 do bb.Animate(p[cyc], 3, 0.5, pSeq[cyc][130], 5)
		if pAnimTim[cyc] > 150 || (pAnimTim[cyc] > 80 && gamPromo == 0) do ChangeAnim(cyc, 0)
	}
	//mourning
	if pAnim[cyc] == 131 {
		if pAnimTim[cyc] == 0 do bb.Animate(p[cyc], 1, bb.RndF(0.25, 0.5), pSeq[cyc][131], 10)
		if gamPromo != 31 {
			abort := 0
			randy := bb.RndI(0, 1000)
			if randy == 0 && pControl[cyc] == 0 do abort = 1
			if pControl[cyc] > 0 && (cast(bool)DirPressed(cyc) || cast(bool)ActionPressed(cyc)) do abort = 1
			if abort == 1 && pAnimTim[cyc] > 50 do ChangeAnim(cyc, 0)
			if pAnimTim[cyc] > 600 || cyc == promoActor[1] || cyc == promoActor[2] do ChangeAnim(cyc, 0)
		}
	}
	//dumbbell curl
	if pAnim[cyc] == 132 {
		if pAnimTim[cyc] == 0 do bb.Animate(p[cyc], 1, bb.RndF(0.3, 0.6), pSeq[cyc][132], 10)
		if pAnimTim[cyc] > 10 {
			randy: i32 = bb.RndI(0, 300)
			if randy <= 2 do ProduceSound(p[cyc], sPain[bb.RndI(1, 8)], 22050, bb.RndF(0.1, 0.5))
			if randy == 0 {
				charStrength[pChar[cyc]] += 1
				charHappiness[pChar[cyc]] += bb.RndI(1, 5)
				randy = bb.RndI(0, 5)
				if randy == 0 do charReputation[pChar[cyc]] += 1
				pHealth[cyc] -= 1
				randy = bb.RndI(0, 50)
				if randy == 0 && gamGrowth[slot] <= 0 do gamGrowth[slot] += 1
			}
			if cast(bool)DirPressed(cyc) || cast(bool)ActionPressed(cyc) || cyc == promoActor[1] || cyc == promoActor[2] || cast(bool)bb.KeyDown(1) do ChangeAnim(cyc, 0)
		}
	}
	//------------- MOVES -------------
	MoveAnims(cyc)
	//INCREMENTATION
	pAnimTim[cyc] += 1
}
//--------------------------------------------------------------
//////////////////// RELATED FUNCTIONS /////////////////////////
//--------------------------------------------------------------

//CHANGE ANIMATION
ChangeAnim :: proc(cyc, anim: i32) {
	pOldAnim[cyc] = pAnim[cyc]
	pAnim[cyc] = anim
	if pOldAnim[cyc] > anim {
		pAnimTim[cyc] = -1
	} else {
		pAnimTim[cyc] = 0
	}
}

//IMMEDIATE TRANSITION
SharpTransition :: proc(cyc, anim: i32, offset: f32) {
	//honour current co-ords
	pX[cyc] = bb.EntityX(pLimb[cyc][30], 1)
	pZ[cyc] = bb.EntityZ(pLimb[cyc][30], 1)
	pOldX[cyc] = pX[cyc]
	pOldZ[cyc] = pZ[cyc]
	//orientation
	if offset < 0 {
		pA[cyc] = bb.EntityYaw(pLimb[cyc][30], 1)
	}
	if offset >= 0 {
		pA[cyc] = pA[cyc] + offset
	}
	pA[cyc] = CleanAngle(pA[cyc])
	pTA[cyc] = pA[cyc]
	//immediate transition
	bb.PositionEntity(pPivot[cyc], pX[cyc], bb.EntityY(pPivot[cyc]), pZ[cyc])
	bb.RotateEntity(pPivot[cyc], 0, pA[cyc], 0)
	bb.Animate(p[cyc], 1, 1.0, pSeq[cyc][anim], 0)
}

//POINT BODY
PointBody :: proc(cyc, entity: i32) {
	//identify limbs involved
	limb := bb.FindChild(p[cyc], "Body")
	source := bb.FindChild(p[cyc], "Hips")
	//stabilize and point
	bb.RotateEntity(limb, bb.EntityPitch(source), bb.EntityYaw(source), bb.EntityRoll(source))
	bb.PointEntity(limb, entity)
	if pAnim[cyc] == 60 { //machine gun
		bb.RotateEntity(limb, bb.EntityPitch(limb)+5, bb.EntityYaw(limb)-40, bb.EntityRoll(limb))
		if AttackViable(pFoc[cyc]) == 3 {
			bb.RotateEntity(limb, bb.EntityPitch(limb)+10, bb.EntityYaw(limb), bb.EntityRoll(limb))
		}
	}
	if pAnim[cyc] == 61 { //pistol
		bb.RotateEntity(limb, bb.EntityPitch(limb)+10, bb.EntityYaw(limb)+36, bb.EntityRoll(limb))
		if AttackViable(pFoc[cyc]) == 3 {
			bb.RotateEntity(limb, bb.EntityPitch(limb)+15, bb.EntityYaw(limb), bb.EntityRoll(limb))
		}
	}
	//X limitations
	if bb.EntityPitch(limb) < bb.EntityPitch(source)-50 {
		bb.RotateEntity(limb, bb.EntityPitch(source)-50, bb.EntityYaw(limb), bb.EntityRoll(limb))
	}
	if bb.EntityPitch(limb) > bb.EntityPitch(source)+60 {
		bb.RotateEntity(limb, bb.EntityPitch(source)+60, bb.EntityYaw(limb), bb.EntityRoll(limb))
	}
	//Y limitations
	if bb.EntityYaw(limb) < bb.EntityYaw(source)-30 {
		bb.RotateEntity(limb, bb.EntityPitch(limb), bb.EntityYaw(source)-30, bb.EntityRoll(limb))
	}
	if bb.EntityYaw(limb) > bb.EntityYaw(source)+30 {
		bb.RotateEntity(limb, bb.EntityPitch(limb), bb.EntityYaw(source)+30, bb.EntityRoll(limb))
	}
	//Z limitations
	bb.RotateEntity(limb, bb.EntityPitch(limb), bb.EntityYaw(limb), 0)
}

//POINT HEAD
PointHead :: proc(cyc, entity: i32) {
	//identify limbs involved
	limb := bb.FindChild(p[cyc], "Head")
	source := bb.FindChild(p[cyc], "Body")
	//stabilize and point
	bb.RotateEntity(limb, bb.EntityPitch(source), bb.EntityYaw(source), bb.EntityRoll(source))
	bb.PointEntity(limb, entity)
	//X limitations
	if bb.EntityPitch(limb) < bb.EntityPitch(source)-60 {
		bb.RotateEntity(limb, bb.EntityPitch(source)-60, bb.EntityYaw(limb), bb.EntityRoll(limb))
	}
	if bb.EntityPitch(limb) > bb.EntityPitch(source)+10 {
		bb.RotateEntity(limb, bb.EntityPitch(source)+10, bb.EntityYaw(limb), bb.EntityRoll(limb))
	}
	//Y limitations
	if bb.EntityYaw(limb) < bb.EntityYaw(source)-45 {
		bb.RotateEntity(limb, bb.EntityPitch(limb), bb.EntityYaw(source)-45, bb.EntityRoll(limb))
	}
	if bb.EntityYaw(limb) > bb.EntityYaw(source)+45 {
		bb.RotateEntity(limb, bb.EntityPitch(limb), bb.EntityYaw(source)+45, bb.EntityRoll(limb))
	}
	//Z limitations
	bb.RotateEntity(limb, bb.EntityPitch(limb), bb.EntityYaw(limb), 0)
	//preserve long hair
	if bb.FindChild(p[cyc], "Hair_Long") > 0 {
		bb.RotateEntity(bb.FindChild(p[cyc], "Hair_Long"), -bb.EntityPitch(limb), -(bb.EntityYaw(limb)-(bb.EntityYaw(limb)/3)), -(bb.EntityRoll(limb)/2))
		if bb.EntityPitch(bb.FindChild(p[cyc], "Hair_Long")) < bb.EntityPitch(source)-10 {
			bb.RotateEntity(bb.FindChild(p[cyc], "Hair_Long"), bb.EntityPitch(source)-10, bb.EntityYaw(bb.FindChild(p[cyc], "Hair_Long")), bb.EntityRoll(bb.FindChild(p[cyc], "Hair_Long")))
		}
	}
}

//TURN TO FACE ENTITY
FaceEntity :: proc(cyc, entity: i32, turner: f32) {
	if entity > 0 {
		bb.PositionEntity(dummy, pX[cyc], pY[cyc], pZ[cyc])
		bb.PointEntity(dummy, entity)
		tA := CleanAngle(bb.EntityYaw(dummy))
		if SatisfiedAngle(pA[cyc], tA, i32(turner*2)) == 0 {
			pA[cyc] = pA[cyc] + ReachAngle(pA[cyc], tA, turner)
		}
	}
}

//APPLY MOVEMENT
ApplyMovement :: proc(cyc: i32, speed: f32) {
	//turn
	if pDazed[cyc] > 0 {
		if cast(bool)cLeft[cyc] do pA[cyc] = CleanAngle(pA[cyc] - 5)
		if cast(bool)cRight[cyc] do pA[cyc] = CleanAngle(pA[cyc] + 5)
	} else {
		if cast(bool)cLeft[cyc] do pA[cyc] = CleanAngle(pA[cyc] + 5)
		if cast(bool)cRight[cyc] do pA[cyc] = CleanAngle(pA[cyc] - 5)
	}
	//advance
	if cast(bool)VerticalPressed(cyc) {
		if cast(bool)cUp[cyc] do pHurtA[cyc] = pA[cyc]
		if cast(bool)cDown[cyc] do pHurtA[cyc] = CleanAngle(pA[cyc] + 180)
		bb.RotateEntity(pPivot[cyc], 0, pA[cyc], 0)
		if pDazed[cyc] > 0 {
			if cast(bool)cUp[cyc] do bb.MoveEntity(pPivot[cyc], 0, 0, -(speed / 2))
			if cast(bool)cDown[cyc] do bb.MoveEntity(pPivot[cyc], 0, 0, speed)
		} else {
			if cast(bool)cUp[cyc] do bb.MoveEntity(pPivot[cyc], 0, 0, speed)
			if cast(bool)cDown[cyc] do bb.MoveEntity(pPivot[cyc], 0, 0, -(speed / 2))
		}
	}
}

//GRIMACE VIABLE?
GrimaceViable :: proc(cyc: i32) -> i32 {
	viable: i32 = 1
	if pAnim[cyc] < 20 do viable = 0 //movement
	if pAnim[cyc] == 24 do viable = 0 //examining
	if pAnim[cyc] >= 74 && pAnim[cyc] <= 75 do viable = 0 //blocking
	if pAnim[cyc] >= 76 && pAnim[cyc] <= 77 && pAnimTim[cyc] > 130 do viable = 0 //dead
	if pAnim[cyc] == 81 || pAnim[cyc] == 84 do viable = 0 //lying
	if pAnim[cyc] == 92 || pAnim[cyc] == 97 || pAnim[cyc] == 98 do viable = 0 //sweeping/combing
	if pAnim[cyc] == 102 || pAnim[cyc] == 103 do viable = 0 //sitting/sleeping
	if pAnim[cyc] == 130 do viable = 0 //changed weight
	if pAnim[cyc] == 205 || pAnim[cyc] == 206 do viable = 0 //grappling
	return viable
}

//VIABLE TO TURN HEAD?
HeadViable :: proc(cyc: i32) -> i32 {
	viable: i32 = 0
	if pDazed[cyc] == 0 {
		//guaranteed states
		if pAnim[cyc] < 20 && pPhone[cyc] == 0 do viable = 1 //movement
		if pAnim[cyc] == 91 do viable = 1 //waving
		if pAnim[cyc] == 102 {
			if pState[cyc] == 101 do viable = 1 //slouching
			if cast(bool)OnComputer(cyc) do viable = 1 //working at computer
			if cyc == promoActor[1] || cyc == promoActor[2] do viable = 1 //talking while sitting
		}
		if pAnim[cyc] == 205 && (cyc == promoActor[1] || cyc == promoActor[2]) do viable = 1 //grappling
		//close speech override
		if pAnim[cyc] == 0 && cast(bool)pSpeaking[cyc] && pState[cyc] != 3 && pAnim[pFoc[cyc]] == 0 && pY[cyc] >= pY[pFoc[cyc]]-1 && pY[cyc] <= pY[pFoc[cyc]]+1 {
			if cast(bool)InLine(cyc, p[pFoc[cyc]], 5) do viable = 0
		}
		//monologue override
		if cyc == promoActor[1] && promoActor[2] == 0 do viable = 0
	}
	return viable
}

//VIABLE TO TURN BODY?
BodyViable :: proc(cyc: i32) -> i32 {
	viable: i32 = 0
	if pAnim[cyc] >= 60 && pAnim[cyc] <= 61 {
		if cDefend[cyc] == 0 || pControl[cyc] == 0 do viable = 1 //shooting
	}
	if pAnim[cyc] == 91 do viable = 1 //waving
	return viable
}

//VIABLE TO UPDATE FOC?
FocViable :: proc(cyc: i32) -> i32 {
	viable: i32 = 1
	if pAnim[cyc] == 25 || pAnim[cyc] == 26 do viable = 0 //handing over
	if pAnim[cyc] == 60 || pAnim[cyc] == 61 do viable = 0 //shooting
	if pAnim[cyc] == 91 do viable = 0 //waving
	if cyc == promoActor[1] || cyc == promoActor[2] do viable = 0 //speaking
	return viable
}

//VIABLE TO COLLAPSE?
CollapseViable :: proc(cyc: i32) -> i32 {
	viable: i32 = 1
	if pAnim[cyc] >= 72 && pAnim[cyc] <= 73 do viable = 0 //ground hurt
	if pAnim[cyc] >= 76 && pAnim[cyc] <= 77 do viable = 0 //dying
	if pAnim[cyc] >= 80 && pAnim[cyc] <= 89 do viable = 0 //lying
	if pAnim[cyc] == 96 do viable = 0 //breaking down 
	if pAnim[cyc] >= 100 && pAnim[cyc] <= 101 do viable = 0 //sitting
	if pAnim[cyc] >= 201 do viable = 0 //grappling
	return viable
}

//VIABLE TO ATTACK?
AttackViable :: proc(cyc: i32) -> i32 { //1=upper, 2=lower, 3=ground
	viable: i32 = 1
	//upper as standard
	//lower variations
	if pAnim[cyc] == 1 || pAnim[cyc] == 11 do viable = 2 //kneeling
	if pAnim[cyc] == 75 do viable = 2 //lower block
	//ground variations
	if pAnim[cyc] == 72 || pAnim[cyc] == 73 do viable = 3 //lying hurt
	if pAnim[cyc] >= 76 && pAnim[cyc] <= 77 && pAnimTim[cyc] > 150 do viable = 3 //lying dead
	if pAnim[cyc] == 81 || pAnim[cyc] == 84 do viable = 3 //lying
	//exceptions
	if pAnim[cyc] == 80 || pAnim[cyc] == 83 || pAnim[cyc] == 86 do viable = 0 //falling
	if pAnim[cyc] == 35 || pAnim[cyc] == 82 || pAnim[cyc] == 85 do viable = 0 //getting up
	if pAnim[cyc] == 90 do viable = 0 //opening door
	if pAnim[cyc] == 96 do viable = 0 //breaking down 
	if pAnim[cyc] >= 100 && pAnim[cyc] <= 101 do viable = 0 //sitting
	if pAnim[cyc] == 202 || pAnim[cyc] == 203 || pAnim[cyc] == 204 || pAnim[cyc] >= 210 do viable = 0 //grappling 
	//unavailable
	if pAnim[cyc] >= 76 && pAnim[cyc] <= 77 && pAnimTim[cyc] < 150 do viable = 0 //dying
	//if charState[pChar[cyc]] == 0 do viable = 0
	return viable
}

//GROUND HURT REACTION
GroundReaction :: proc(cyc: i32) {
	if pHealth[cyc] > 0 {
		//lying on back
		if pAnim[cyc] == 72 || pAnim[cyc] == 81 do ChangeAnim(cyc, 72)
		//lying on front
		if pAnim[cyc] == 73 || pAnim[cyc] == 84 do ChangeAnim(cyc, 73)
	}
}

//SEATED TASKS
SittingEffects :: proc(cyc: i32) {
	//watching TV
	if gamLocation[slot] == 9 && pSeat[cyc] >= 1 && pSeat[cyc] <= 6 && pState[cyc] == 101 {
		randy := bb.RndI(0, 7500)
		if randy == 1 && pChar[cyc] == gamChar[slot] {
			charStrength[pChar[cyc]] = charStrength[pChar[cyc]] - 1
		}
		if randy == 2 && pChar[cyc] == gamChar[slot] {
			charAgility[pChar[cyc]] = charAgility[pChar[cyc]] - 1
		}
		if randy == 3 && pChar[cyc] == gamChar[slot] {
			charIntelligence[pChar[cyc]] = charIntelligence[pChar[cyc]] - 1
		}
		randy = bb.RndI(0, 15000)
		if randy == 0 && gamGrowth[slot] <= 0 do gamGrowth[slot] = gamGrowth[slot] + 1
		randy = bb.RndI(0, 100)
		if randy <= 2 do charHappiness[pChar[cyc]] = charHappiness[pChar[cyc]] + 1
	}
	//studying
	if gamLocation[slot] == 4 && pState[cyc] == 102 {
		randy := bb.RndI(0, 200)
		if randy == 0 {
			charIntelligence[pChar[cyc]] = charIntelligence[pChar[cyc]] + 1
			charHappiness[pChar[cyc]] = charHappiness[pChar[cyc]] + bb.RndI(1, 5)
			randy = bb.RndI(0, 5)
			if randy == 0 && charReputation[pChar[cyc]] > 50 do charReputation[pChar[cyc]] = charReputation[pChar[cyc]] - 1
			if randy == 0 && charReputation[pChar[cyc]] < 50 do charReputation[pChar[cyc]] = charReputation[pChar[cyc]] + 1
		}
	}
	//searching computer
	if pChar[cyc] == gamChar[slot] && cast(bool)OnComputer(cyc) && pState[cyc] == 109 {
		if cLeft[cyc] == 1 && pAnimTim[cyc] > 10 && keytim == 0 {
			gamFile = gamFile - 1
			bb.PlaySound(sComputer)
			keytim = 5
		}
		if cRight[cyc] == 1 && pAnimTim[cyc] > 10 && keytim == 0 {
			gamFile = gamFile + 1
			bb.PlaySound(sComputer)
			keytim = 5
		}
		if gamFile < 1 do gamFile = no_chars
		if gamFile > no_chars do gamFile = 1
	}
	//weight-lifting
	if pState[cyc] == 108 {
		randy := bb.RndI(0, 200)
		if randy <= 2 do ProduceSound(p[cyc], sPain[bb.RndI(1, 8)], 22050, bb.RndF(0.1, 0.5))
		if randy == 0 {
			charStrength[pChar[cyc]] = charStrength[pChar[cyc]] + 1
			charHappiness[pChar[cyc]] = charHappiness[pChar[cyc]] + bb.RndI(1, 5)
			randy = bb.RndI(0, 5)
			if randy == 0 do charReputation[pChar[cyc]] = charReputation[pChar[cyc]] + 1
			pHealth[cyc] = pHealth[cyc] - 1
			randy = bb.RndI(0, 50)
			if randy == 0 && gamGrowth[slot] <= 0 do gamGrowth[slot] = gamGrowth[slot] + 1
		} 
		if pAnimTim[cyc] == 10 do ProduceSound(p[cyc], sAxe, 22050, 0)
	}
	//canteen food
	if pState[cyc] == 103 {
		limb: i32
		pFoodTim[cyc] = pFoodTim[cyc] - 1
		if pFoodTim[cyc] < 0 do pFoodTim[cyc] = 0
		if pAnimTim[cyc] == 30 || pAnimTim[cyc] == 40 do limb = bb.FindChild(p[cyc], "R_Finger04")
		if pAnimTim[cyc] == 85 || pAnimTim[cyc] == 95 do limb = bb.FindChild(p[cyc], "L_Finger04")
		if pAnimTim[cyc] == 30 || pAnimTim[cyc] == 85 {
			ProduceSound(p[cyc], sEat, 22050, 0)
			CreateSpurt(bb.EntityX(limb, 1), bb.EntityY(limb, 1), bb.EntityZ(limb, 1), 1, 5, 5) 
			trayState[pSeat[cyc]] = trayState[pSeat[cyc]] - 1
			pFoodTim[cyc] = 15
			if pChar[cyc] == gamChar[slot] {
				for tray: i32 = 1; tray <= 50; tray += 1 {
					if tray != pSeat[gamPlayer[slot]] && trayState[tray] > 0 do trayState[tray] = trayState[tray] - bb.RndI(0, 1)
				}
			}
		}
		if pAnimTim[cyc] == 40 || pAnimTim[cyc] == 95 {
			CreateSpurt(bb.EntityX(limb, 1), bb.EntityY(limb, 1), bb.EntityZ(limb, 1), 1, 5, 5) 
			charHappiness[pChar[cyc]] = charHappiness[pChar[cyc]] + bb.RndI(1, 5)
			pHealth[cyc] = pHealth[cyc] + 5
			randy: i32 = bb.RndI(0, 50)
			if randy == 0 && gamGrowth[slot] <= 0 do gamGrowth[slot] = gamGrowth[slot] + 1 
		} 
		if pAnimTim[cyc] > 120 do pAnimTim[cyc] = 10
	}
	//workshop kits
	if gamLocation[slot] == 10 && pState[cyc] == 104 {
		randy := bb.RndI(0, 30)
		if randy == 0 {
			charHappiness[pChar[cyc]] = charHappiness[pChar[cyc]] + bb.RndI(0, 1)
			ProduceSound(p[cyc], weapSound[kitType[pSeat[cyc]]], 22050, bb.RndF(0.1, 0.3))
			//limb = bb.FindChild(world, "Table" + bb.Dig$(pSeat[cyc], 10))
			//bb.PositionEntity(kit[pSeat[cyc]], bb.EntityX(limb, 1) + bb.RndF(-0.10, 0.10), bb.EntityY(limb, 1), bb.EntityZ(limb, 1) + bb.RndF(-0.10, 0.10))
		}
		chance := (150 - charStrength[pChar[cyc]]) + (150 - charIntelligence[pChar[cyc]])
		chance = chance * 4
		randy = bb.RndI(0, chance)
		if randy == 0 && pAnimTim[cyc] > 50 && kitState[pSeat[cyc]] > 0 {
			if pChar[cyc] == gamChar[slot] && cast(bool)LockDown() == false {
				bb.PlaySound(sCash)
				statTim[7] = 50
				gamMoney[slot] = gamMoney[slot] + 25 //weapValue[kitType[pSeat[cyc]]]
			}
			charHappiness[pChar[cyc]] = charHappiness[pChar[cyc]] + 5
			charReputation[pChar[cyc]] = charReputation[pChar[cyc]] + bb.RndI(0, 1)
			CreateWeapon(kitType[pSeat[cyc]], bb.EntityX(kit[pSeat[cyc]], 1), bb.EntityY(kit[pSeat[cyc]], 1) + 5, bb.EntityZ(kit[pSeat[cyc]], 1))
			bb.HideEntity(kit[pSeat[cyc]])
			kitState[pSeat[cyc]] = 0
		}
	}
	//working
	if gamLocation[slot] == 4 || gamLocation[slot] == 6 || gamLocation[slot] == 8  {
		if pChar[cyc] == gamChar[slot] && cast(bool)LockDown() == false && pState[cyc] == 104 && pAnimTim[cyc] > 160 {
			bb.PlaySound(sCash)
			statTim[7] = 50
			if gamLocation[slot] == 8 do gamMoney[slot] = gamMoney[slot] + 5
			if gamLocation[slot] == 4 do gamMoney[slot] = gamMoney[slot] + 10
			if gamLocation[slot] == 6 do gamMoney[slot] = gamMoney[slot] + 15
			charHappiness[pChar[cyc]] = charHappiness[pChar[cyc]] + bb.RndI(1, 5)
			randy := bb.RndI(0, 10)
			if randy == 0 && charReputation[pChar[cyc]] > 50 do charReputation[pChar[cyc]] = charReputation[pChar[cyc]] - 1
			if randy == 0 && charReputation[pChar[cyc]] < 50 do charReputation[pChar[cyc]] = charReputation[pChar[cyc]] + 1
			if randy == 1 do charIntelligence[pChar[cyc]] = charIntelligence[pChar[cyc]] + 1
			pAnimTim[cyc] = 10 
		}
	}
}

//  GET POWER
GetPower :: proc(cyc: i32) -> i32{
	power: i32 = 1
	if charStrength[pChar[cyc]] >= 60 do power = bb.RndI(1, 2)
	if charStrength[pChar[cyc]] >= 70 do power = 2
	if charStrength[pChar[cyc]] >= 80 do power = bb.RndI(2, 3)
	if charStrength[pChar[cyc]] >= 90 do power = 3
	return power
}

//  GET BLOCKING POTENTIAL
BlockPower :: proc(cyc: i32) -> i32{
	block: i32 = GetPower(cyc)
	if pWeapon[cyc] > 0 && weapStyle[weapType[pWeapon[cyc]]] == 1 do block = block + 1
	return block
}

//  ANSWER/HANG-UP PHONE
AnswerPhone :: proc(cyc, phone, anim: i32){
	if phone > 0 {
		bb.PointEntity(pPivot[cyc], bb.FindChild(world, fmt.tprintf("Pad%d", phone)))
		pA[cyc] = bb.EntityYaw(pPivot[cyc])
		ChangeAnim(cyc, anim)
	}
}

