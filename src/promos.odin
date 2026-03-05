package main

import "core:fmt"
import bb "blitzbasic3d"

////////////////////////////////////////////////////////////////////////////////
//---------------------------- HARD TIME: PROMOS -------------------------------
////////////////////////////////////////////////////////////////////////////////

//--------------------------------------------------------------------
/////////////////////// RISK SPONTANEOUS PROMO ///////////////////////
//--------------------------------------------------------------------
RiskPromo :: proc(cyc, v: i32) {
	talkRange: i32 = 60
	if pSeat[cyc] > 0 do talkRange = 100
	// //////////////////// LAW ENFORCEMENT ////////////////////
	if charPromo[pChar[cyc]][pChar[v]] == 0 \
	&& pChar[v] == gamChar[slot] \
	&& charRole[pChar[v]] == 0 \
	&& charRole[pChar[cyc]] == 1 \
	&& gamBlackout[slot] == 0 \
	&& AttackViable(cyc) >= 1 \
	&& AttackViable(cyc) <= 2 \
	&& pDazed[cyc] == 0 {
		// welcome to location
		if charExperience[pChar[v]] <= 2 \
		&& gamWarrant[slot] == 0 \
		&& charRelation[pChar[cyc]][pChar[v]] >= 0 \
		&& charAngerTim[pChar[cyc]][pChar[v]] == 0 \
		&& cast(bool)InProximity(cyc, v, 30) {
			if gamLocation[slot] == 2 && promoUsed[210] == 0 {
				charPromo[pChar[cyc]][pChar[v]] = 210
			}
			if gamLocation[slot] == 4 && promoUsed[211] == 0 {
				charPromo[pChar[cyc]][pChar[v]] = 211
			}
			if gamLocation[slot] == 6 && promoUsed[212] == 0 {
				charPromo[pChar[cyc]][pChar[v]] = 212
			}
			if gamLocation[slot] == 8 && promoUsed[213] == 0 {
				charPromo[pChar[cyc]][pChar[v]] = 213
			}
			if gamLocation[slot] == 10 && promoUsed[215] == 0 {
				charPromo[pChar[cyc]][pChar[v]] = 215
			}
		}
		// remind about dinner time
		if gamHours[slot] == 13 \
		&& gamMins[slot] > 20 \
		&& gamLocation[slot] != 8 \
		&& cast(bool)InProximity(cyc, v, 30) \
		&& charAngerTim[pChar[cyc]][pChar[v]] == 0 \
		&& pAnim[v] != 12 \
		&& pAnim[v] != 13 {
			if promoUsed[6] == 0 do charPromo[pChar[cyc]][pChar[v]] = 6
		}
		// out of block during lock down
		if LockDown() != 0 \
		&& GetBlock(gamLocation[slot]) != charBlock[pChar[v]] \
		&& cast(bool)InProximity(cyc, v, 50) {
			if charBribeTim[pChar[cyc]] == 0 \
			&& promoUsed[2] == 0 {
				charPromo[pChar[cyc]][pChar[v]] = 2
			}
		}
		// out of cell during lock down
		if LockDown() != 0 \
		&& GetBlock(gamLocation[slot]) == charBlock[pChar[v]] \
		&& InsideCell(pX[v], pY[v], pZ[v]) != charCell[pChar[v]] \
		&& cast(bool)InProximity(cyc, v, 50) \
		&& pAnim[v] != 12 \
		&& pAnim[v] != 13 {
			if charBribeTim[pChar[cyc]] == 0 && promoUsed[3] == 0 {
				charPromo[pChar[cyc]][pChar[v]] = 3
			}
		}
		// told off for sleeping in
		if LockDown() == 0 \
		&& pAnim[v] == 103 \
		&& gamLocation[slot] != 6 \
		&& cast(bool)InProximity(cyc, v, 100) \
		&& cast(bool)CellVisible(pX[cyc], pY[cyc], pZ[cyc], InsideCell(pX[v], pY[v], pZ[v])) {
			if charBribeTim[pChar[cyc]] == 0 && promoUsed[11] == 0 {
				charPromo[pChar[cyc]][pChar[v]] = 11
			}
		}
		// told off for being in foreign cell
		if GetBlock(gamLocation[slot]) > 0 \
		&& InsideCell(pX[v], pY[v], pZ[v]) > 0 \
		&& cast(bool)InProximity(cyc, v, 100) \
		&& cast(bool)CellVisible(pX[cyc], pY[cyc], pZ[cyc], InsideCell(pX[v], pY[v], pZ[v])) {
			if InsideCell(pX[v], pY[v], pZ[v]) != charCell[pChar[v]] \
			|| GetBlock(gamLocation[slot]) != charBlock[pChar[v]] {
				if charBribeTim[pChar[cyc]] == 0 && promoUsed[12] == 0 {
					charPromo[pChar[cyc]][pChar[v]] = 12
				}
			}
		}
		// caught carrying weapon
		if pWeapon[v] > 0 \
		&& weapHabitat[weapType[pWeapon[v]]] < 99 \
		&& weapHabitat[weapType[pWeapon[v]]] != gamLocation[slot] \
		&& cast(bool)InProximity(cyc, v, i32(weapSize[weapType[pWeapon[v]]] * 5)) \
		&& charBribeTim[pChar[cyc]] == 0 {
			if cast(bool)InLine(cyc, p[v], talkRange) {
				if gamLocation[slot] == 10 \
				&& weapCreate[weapType[pWeapon[v]]] > 0 \
				&& pWeapon[v] != charWeapon[pChar[v]] \
				&& promoUsed[53] == 0 {
					charPromo[pChar[cyc]][pChar[v]] = 53
				} else {
					if weapHabitat[weapType[pWeapon[v]]] == 0 && promoUsed[1] == 0 {
						charPromo[pChar[cyc]][pChar[v]] = 1
					}
					if weapHabitat[weapType[pWeapon[v]]] > 0 && promoUsed[18] == 0 {
						charPromo[pChar[cyc]][pChar[v]] = 18
					}
				}
			}
		}
		// confront about gang membership
		randy := bb.RndI(0, 10000)
		if randy == 0 \
		&& charGang[pChar[v]] > 0 \
		&& cast(bool)InProximity(cyc, v, 30) \
		&& charBribeTim[pChar[cyc]] == 0 {
			if cast(bool)InLine(cyc, p[v], talkRange) do charPromo[pChar[cyc]][pChar[v]] = 51
		}
		// offers/threats
		randy = bb.RndI(0, 10000)
		if gamWarrant[slot] == 0 \
		&& gamMoney[slot] > 0 \
		&& charBribeTim[pChar[cyc]] == 0 \
		&& cast(bool)InProximity(cyc, v, 30) {
			if cast(bool)InLine(cyc, p[v], talkRange) {
				if randy == 0 && Friendly(cyc, v) == 0 {
					charPromo[pChar[cyc]][pChar[v]] = 58 // invent charge
				}
				if charRelation[pChar[cyc]][pChar[v]] >= 0 && charAngerTim[pChar[cyc]][pChar[v]] == 0 {
					if randy == 1 do charPromo[pChar[cyc]][pChar[v]] = 73 // offer immunity
					if randy == 2 do charPromo[pChar[cyc]][pChar[v]] = 74 // offer protection
					if randy == 3 && charSentence[pChar[v]] > 0 {
						charPromo[pChar[cyc]][pChar[v]] = 245 // offer day off
					}
				}
			}
		}
		// appeals to your intelligence
		randy = bb.RndI(0, 10000)
		if randy == 0 \
		&& gamWarrant[slot] == 0 \
		&& charIntelligence[pChar[v]] > charIntelligence[pChar[cyc]] \
		&& charRelation[pChar[cyc]][pChar[v]] >= 0 \
		&& charAngerTim[pChar[cyc]][pChar[v]] == 0 \
		&& cast(bool)InProximity(cyc, v, 30) {
			if InLine(cyc, p[v], talkRange) != 0 {
				charPromo[pChar[cyc]][pChar[v]] = 244
			}
		}
		// praised for working
		if (pAnim[v] == 102 && (pState[v] == 102 || pState[v] == 104 || pState[v] == 108)) \
		|| pAnim[v] == 92 {
			randy = bb.RndI(0, 10000)
			if randy == 0 \
			&& gamWarrant[slot] == 0 \
			&& charRelation[pChar[cyc]][pChar[v]] >= 0 \
			&& charAngerTim[pChar[cyc]][pChar[v]] == 0 \
			&& cast(bool)InProximity(cyc, v, 30) {
				if cast(bool)InLine(cyc, p[v], talkRange) {
					charPromo[pChar[cyc]][pChar[v]] = 246
				}
			}
		}
		// working is futile
		if (pAnim[v] == 102 && pState[v] == 104) \
		|| pAnim[v] == 92 {
			if cast(bool)LockDown() \
			&& gamWarrant[slot] == 0 \
			&& cast(bool)InProximity(cyc, v, 50) {
				if cast(bool)InLine(cyc, p[v], talkRange) && promoUsed[248] == 0 {
					charPromo[pChar[cyc]][pChar[v]] = 248
				}
			}
		}
		// cell change
		randy = bb.RndI(0, 10000)
		if randy == 0 \
		&& gamWarrant[slot] == 0 \
		&& charBribeTim[pChar[cyc]] == 0 \
		&& cast(bool)InProximity(cyc, v, 30) {
			if cast(bool)InLine(cyc, p[v], talkRange) do charPromo[pChar[cyc]][pChar[v]] = 205
		}
		// told to clean scars
		chance := (20 - CountScars(v)) * 100
		if chance < 500 do chance = 500
		randy = bb.RndI(0, chance)
		if randy == 0 \
		&& CountScars(v) > 2 \
		&& gamLocation[slot] != 11 \
		&& gamWarrant[slot] == 0 \
		&& charBribeTim[pChar[cyc]] == 0 \
		&& cast(bool)InProximity(cyc, v, 30) {
			if cast(bool)InLine(cyc, p[v], talkRange) {
				charPromo[pChar[cyc]][pChar[v]] = 257
			}
		}
		// give yourself in
		randy = bb.RndI(0, 100)
		if randy == 0 \
		&& gamWarrant[slot] > 0 \
		&& cast(bool)bb.ChannelPlaying(chAlarm) \
		&& Friendly(cyc, v) == 0 \
		&& charBribeTim[pChar[cyc]] == 0 \
		&& cast(bool)InProximity(cyc, v, 50) {
			if cast(bool)InLine(cyc, p[v], talkRange) {
				charPromo[pChar[cyc]][pChar[v]] = 59
			}
		}
		// assign mission
		if gamWarrant[slot] == 0 \
		&& gamMission[slot] == 0 \
		&& charSentence[pChar[v]] > 0 \
		&& cast(bool)InProximity(cyc, v, 30) {
			if cast(bool)InLine(cyc, p[v], talkRange) {
				randy = bb.RndI(0, 10000)
				if randy == 1 && charStrength[pChar[v]] <= 80 {
					charPromo[pChar[cyc]][pChar[v]] = 141 // acquire strength
				}
				if randy == 2 && charAgility[pChar[v]] <= 80 {
					charPromo[pChar[cyc]][pChar[v]] = 142 // acquire agility
				}
				if randy == 3 && charIntelligence[pChar[v]] <= 80 {
					charPromo[pChar[cyc]][pChar[v]] = 143 // acquire intelligence
				}
				if randy == 5 && charReputation[pChar[v]] >= 70 {
					charPromo[pChar[cyc]][pChar[v]] = 145 // reduce reputation
				}
				if randy == 7 && gamMoney[slot] >= 0 && gamMoney[slot] <= 1000 {
					charPromo[pChar[cyc]][pChar[v]] = 147 // acquire money
				}
				if randy == 8 && charHairStyle[pChar[v]] > 1 \
				&& charHairStyle[pChar[v]] != charHairStyle[pChar[cyc]] {
					charPromo[pChar[cyc]][pChar[v]] = 148 // change hairstyle
				}
				if randy == 9 && charCostume[pChar[v]] != charCostume[pChar[cyc]] {
					charPromo[pChar[cyc]][pChar[v]] = 149 // change costume
				}
				if randy <= 10 && gamMoney[slot] < 0 {
					charPromo[pChar[cyc]][pChar[v]] = 146 // get out of debt
				}
			}
		}
		// mission reminder
		if gamWarrant[slot] == 0 \
		&& gamMission[slot] > 0 \
		&& pChar[cyc] == gamClient[slot] \
		&& cast(bool)InProximity(cyc, v, 30) {
			if cast(bool)InLine(cyc, p[v], talkRange) && promoUsed[171] == 0 {
				charPromo[pChar[cyc]][pChar[v]] = 171
			}
		}
		// give up illegitimate mission
		randy = bb.RndI(0, 10000)
		if randy == 0 \
		&& gamMission[slot] > 0 \
		&& charRole[gamClient[slot]] == 0 \
		&& cast(bool)InProximity(cyc, v, 30) \
		&& charBribeTim[pChar[cyc]] == 0 {
			if cast(bool)InLine(cyc, p[v], talkRange) && promoUsed[179] == 0 {
				charPromo[pChar[cyc]][pChar[v]] = 179
			}
		}
		// served sentence
		if charSentence[pChar[v]] <= 0 \
		&& gamWarrant[slot] == 0 \
		&& cast(bool)InProximity(cyc, v, 30) {
			if charStrength[pChar[v]] >= 70 \
			&& charAgility[pChar[v]] >= 70 \
			&& charIntelligence[pChar[v]] >= 70 \
			&& gamMoney[slot] >= 1000 {
				if promoUsed[60] == 0 do charPromo[pChar[cyc]][pChar[v]] = 60 // asked to leave
			} else {
				if promoUsed[262] == 0 && promoUsed[263] == 0 {
					if gamMoney[slot] < 1000 do charPromo[pChar[cyc]][pChar[v]] = 263 // not rich enough to leave
					if charStrength[pChar[v]] < 70 || charAgility[pChar[v]] < 70 \
					|| charIntelligence[pChar[v]] < 70 {
						charPromo[pChar[cyc]][pChar[v]] = 262 // not fit to leave
					}
				}
			}
		}
		// death sentence!
		if charSentence[pChar[v]] >= 100 \
		&& gamWarrant[slot] == 0 \
		&& charRelation[pChar[cyc]][pChar[v]] >= 0 \
		&& charAngerTim[pChar[cyc]][pChar[v]] == 0 \
		&& cast(bool)InProximity(cyc, v, 30) {
			if promoUsed[247] == 0 do charPromo[pChar[cyc]][pChar[v]] = 247
		}
	}
	// //////////////////// FELLOW INMATES ////////////////////
	if charPromo[pChar[cyc]][pChar[v]] == 0 && pChar[v] == gamChar[slot] \
	&& charRole[pChar[cyc]] == 0 && charFollowTim[pChar[cyc]] == 0 \
	&& (gamMission[slot] != 18 || pChar[cyc] != gamClient[slot]) \
	&& AttackViable(cyc) >= 1 && AttackViable(cyc) <= 2 && pDazed[cyc] == 0 {
		// welcome to location
		if charExperience[pChar[v]] <= 2 && charRelation[pChar[cyc]][pChar[v]] >= 0 \
		&& charAngerTim[pChar[cyc]][pChar[v]] == 0 && cast(bool)InProximity(cyc, v, 30) {
			if GetRace(pChar[v]) == GetRace(pChar[cyc]) || charGang[pChar[cyc]] == 0 \
			|| charGang[pChar[cyc]] >= 4 {
				if gamLocation[slot] == 9 && promoUsed[214] == 0 {
					charPromo[pChar[cyc]][pChar[v]] = 214
				}
				if gamLocation[slot] == 11 && promoUsed[216] == 0 {
					charPromo[pChar[cyc]][pChar[v]] = 216
				}
			}
		}
		// introductions
		if charExperience[pChar[v]] <= 2 && charSnapped[pChar[cyc]] == 0 \
		&& charRelation[pChar[cyc]][pChar[v]] == 0 && charAngerTim[pChar[cyc]][pChar[v]] == 0 \
		&& charGang[pChar[cyc]] != charGang[pChar[v]] && cast(bool)InProximity(cyc, v, 30) {
			if cast(bool)InLine(cyc, p[v], talkRange) {
				if GetRace(pChar[v]) == GetRace(pChar[cyc]) || charGang[pChar[cyc]] == 0 \
				|| charGang[pChar[cyc]] >= 4 {
					randy := InferiorDice(cyc, v)
					if randy <= 1 do charPromo[pChar[cyc]][pChar[v]] = 98 // friendly
				}
				if charGang[pChar[cyc]] != 6 {
					randy := SuperiorDice(cyc, v)
					if randy <= 1 do charPromo[pChar[cyc]][pChar[v]] = 99 // neutral
					if randy == 2 do charPromo[pChar[cyc]][pChar[v]] = 100 // hostile
				}
			}
		}
		// their imminent release
		if charSentence[pChar[cyc]] <= 1 && cast(bool)InProximity(cyc, v, 30) {
			if cast(bool)InLine(cyc, p[v], talkRange) {
				if cast(bool)Friendly(cyc, v) && promoUsed[221] == 0 {
					charPromo[pChar[cyc]][pChar[v]] = 221
				}
				if charRelation[pChar[cyc]][pChar[v]] < 0 && promoUsed[222] == 0 {
					charPromo[pChar[cyc]][pChar[v]] = 222
				}
			}
		}
		// your imminent release
		if charSentence[pChar[v]] <= 1 && cast(bool)InProximity(cyc, v, 30) {
			if cast(bool)InLine(cyc, p[v], talkRange) {
				if InferiorDice(cyc, v) <= 5 && cast(bool)Friendly(cyc, v) && promoUsed[223] == 0 {
					charPromo[pChar[cyc]][pChar[v]] = 223
				}
				if SuperiorDice(cyc, v) <= 5 && charRelation[pChar[cyc]][pChar[v]] < 0 \
				&& promoUsed[224] == 0 {
					charPromo[pChar[cyc]][pChar[v]] = 224
				}
			}
		}
		// pestered for seat
		randy := SuperiorDice(cyc, v)
		if pSeat[v] > 0 && pSeat[cyc] == 0 && Friendly(cyc, v) == 0 && cast(bool)InProximity(cyc, v, 30) {
			if cast(bool)InLine(cyc, p[v], talkRange) {
				if randy <= 1 || (randy == 2 && gamLocation[slot] == 8 && trayState[pSeat[cyc]] > 0) {
					charPromo[pChar[cyc]][pChar[v]] = 7
				}
			}
		}
		// pestered for bed
		randy = SuperiorDice(cyc, v)
		if pBed[v] > 0 && pBed[cyc] == 0 && Friendly(cyc, v) == 0 && cast(bool)InProximity(cyc, v, 50) {
			if cast(bool)InLine(cyc, p[v], talkRange) {
				if randy == 0 || (randy == 1 && cast(bool)LockDown()) \
				|| (randy == 2 && gamLocation[slot] == 6) {
					charPromo[pChar[cyc]][pChar[v]] = 8
				}
			}
		}
		// told off for snooping around cell
		cell := InsideCell(pX[v], pY[v], pZ[v])
		if GetBlock(gamLocation[slot]) == charBlock[pChar[cyc]] && cell == charCell[pChar[cyc]] \
		&& Friendly(cyc, v) == 0 && cast(bool)InProximity(cyc, v, 100) \
		&& cast(bool)CellVisible(pX[cyc], pY[cyc], pZ[cyc], cell) \
		&& gamBlackout[slot] == 0 {
			if InsideCell(pX[cyc], pY[cyc], pZ[cyc]) == 0 || cast(bool)LockDown() \
			|| pBed[v] == charCell[pChar[cyc]] {
				if cell != charCell[pChar[v]] || GetBlock(gamLocation[slot]) != charBlock[pChar[v]] {
					if cast(bool)InLine(cyc, p[v], talkRange) && promoUsed[13] == 0 {
						charPromo[pChar[cyc]][pChar[v]] = 13
					}
				}
			}
		}
		// caught in friend's cell
		if GetBlock(gamLocation[slot]) > 0 && cell > 0 && (cell != charCell[pChar[v]] \
		|| GetBlock(gamLocation[slot]) != charBlock[pChar[v]]) \
		&& Friendly(cyc, v) == 0 && cast(bool)InProximity(cyc, v, 100) && gamBlackout[slot] == 0 {
			for char in 1..=no_chars {
				if char != pChar[cyc] && char != pChar[v] && charRole[char] == 0 \
				&& cast(bool)FriendlyChars(pChar[cyc], char) && charPromo[pChar[cyc]][pChar[v]] == 0 {
					if GetBlock(gamLocation[slot]) == charBlock[char] && cell == charCell[char] \
					&& cast(bool)CellVisible(pX[cyc], pY[cyc], pZ[cyc], cell) {
						if cast(bool)InLine(cyc, p[v], talkRange) && promoUsed[91] == 0 {
							charPromo[pChar[cyc]][pChar[v]] = 91
							charPromoRef[pChar[cyc]] = char
						}
					}
				}
			}
		}
		// interest in your item
		if pWeapon[v] > 0 && cast(bool)InProximity(cyc, v, 30) && gamBlackout[slot] == 0 {
			if cast(bool)InLine(cyc, p[v], talkRange) {
				randy = InferiorDice(cyc, v)
				if randy <= 1 || (randy == 2 && pAgenda[cyc] == 4 && pWeapon[v] == pWeapFoc[cyc]) \
				|| (randy == 3 && weapType[pWeapon[cyc]] >= 16 && weapType[pWeapon[cyc]] <= 18) {
					if charRelation[pChar[cyc]][pChar[v]] >= 0 && charAngerTim[pChar[cyc]][pChar[v]] == 0 {
						charPromo[pChar[cyc]][pChar[v]] = 48 // asks to buy
					}
				}
				randy = SuperiorDice(cyc, v)
				if randy == 0 || (randy == 1 && pAgenda[cyc] == 4 && pWeapon[v] == pWeapFoc[cyc]) {
					if Friendly(cyc, v) == 0 do charPromo[pChar[cyc]][pChar[v]] = 16 // bullied
				}
			}
		}
		// has item to sell
		randy = InferiorDice(cyc, v)
		if pWeapon[v] > 0 && charRelation[pChar[cyc]][pChar[v]] >= 0 \
		&& charAngerTim[pChar[cyc]][pChar[v]] == 0 \
		&& cast(bool)InProximity(cyc, v, 30) {
			if cast(bool)InLine(cyc, p[v], talkRange) {
				if randy <= 1 || (randy == 2 && weapType[pWeapon[cyc]] >= 16 \
				&& weapType[pWeapon[cyc]] <= 18) {
					if gamMoney[slot] >= weapValue[weapType[pWeapon[cyc]]] {
						charPromo[pChar[cyc]][pChar[v]] = 49 // offers to sell
					}
				}
				if randy == 3 || (randy == 4 && charRelation[pChar[cyc]][pChar[v]] == 1) {
					charPromo[pChar[cyc]][pChar[v]] = 50 // offers to give
				}
			}
		}
		// alarmed by dangerous weapon
		danger: i32 = 0
		w := weapType[pWeapon[v]]
		if w == 6 || w == 12 || (w >= 22 && w <= 23) { danger = 1 }
		if w >= 7 && w <= 9 { danger = 3 }
		randy = InferiorDice(cyc, v)
		if randy <= danger && danger > 0 && pWeapon[v] > 0 \
		&& weapHabitat[weapType[pWeapon[v]]] != gamLocation[slot] \
		&& cast(bool)InProximity(cyc, v, i32(weapSize[weapType[pWeapon[v]]] * 5)) \
		&& Friendly(cyc, v) == 0 {
			if cast(bool)InLine(cyc, p[v], talkRange) do charPromo[pChar[cyc]][pChar[v]] = 209
		}
		// insults
		if Friendly(cyc, v) == 0 && charAngerTim[pChar[cyc]][pChar[v]] == 0 && charGang[pChar[cyc]] != 6 \
		&& cast(bool)InProximity(cyc, v, 30) {
			if cast(bool)InLine(cyc, p[v], talkRange) {
				if SuperiorDice(cyc, v) == 0 && charStrength[pChar[v]] < charStrength[pChar[cyc]] - 10 {
					charPromo[pChar[cyc]][pChar[v]] = 226 // insult strength
				}
				if SuperiorDice(cyc, v) == 0 && charAgility[pChar[v]] < charAgility[pChar[cyc]] - 10 {
					charPromo[pChar[cyc]][pChar[v]] = 228 // insult agility
				}
				if SuperiorDice(cyc, v) == 0 && charIntelligence[pChar[v]] < charIntelligence[pChar[cyc]] - 10 {
					charPromo[pChar[cyc]][pChar[v]] = 230 // insult intelligence
				}
				if SuperiorDice(cyc, v) == 0 && charReputation[pChar[v]] < charReputation[pChar[cyc]] - 10 {
					charPromo[pChar[cyc]][pChar[v]] = 232 // insult reputation
				}
				if SuperiorDice(cyc, v) == 0 && gamMoney[slot] > 0 && gamMoney[slot] < 100 {
					charPromo[pChar[cyc]][pChar[v]] = 234 // insult finances
				}
				if SuperiorDice(cyc, v) == 0 && charModel[pChar[v]] >= 4 && charModel[pChar[cyc]] <= 3 {
					charPromo[pChar[cyc]][pChar[v]] = 236 // too fat
				}
				if SuperiorDice(cyc, v) == 0 && charModel[pChar[v]] == 1 && charModel[pChar[cyc]] >= 2 {
					charPromo[pChar[cyc]][pChar[v]] = 237 // too skinny
				}
				if SuperiorDice(cyc, v) == 0 && charCrime[pChar[v]] < charCrime[pChar[cyc]] {
					charPromo[pChar[cyc]][pChar[v]] = 238 // inferior crime
				}
				if InferiorDice(cyc, v) == 0 && charCrime[pChar[v]] > charCrime[pChar[cyc]] + 2 {
					charPromo[pChar[cyc]][pChar[v]] = 239 // superior crime
				}
				if GetBlock(gamLocation[slot]) > 0 && GetBlock(gamLocation[slot]) == charBlock[pChar[cyc]] && GetBlock(gamLocation[slot]) != charBlock[pChar[v]] {
					if SuperiorDice(cyc, v) == 0 {
						charPromo[pChar[cyc]][pChar[v]] = 242 // block rivalry
					}
				}
				if InferiorDice(cyc, v) == 0 && charReputation[pChar[v]] > charReputation[pChar[cyc]] && charReputation[pChar[v]] > 70 {
					charPromo[pChar[cyc]][pChar[v]] = 260 // challenge reputation
				}
				if SuperiorDice(cyc, v) == 0 && GetRace(pChar[v]) != GetRace(pChar[cyc]) {
					charPromo[pChar[cyc]][pChar[v]] = 266 // racial tension
				}
			}
		}
		// praise
		if charRelation[pChar[cyc]][pChar[v]] >= 0 && charAngerTim[pChar[cyc]][pChar[v]] == 0 \
		&& cast(bool)InProximity(cyc, v, 30) {
			if cast(bool)InLine(cyc, p[v], talkRange) {
				if InferiorDice(cyc, v) == 0 {
					charPromo[pChar[cyc]][pChar[v]] = 240 // comforted about crime
				}
				if InferiorDice(cyc, v) == 0 && charStrength[pChar[v]] > charStrength[pChar[cyc]] + 10 {
					charPromo[pChar[cyc]][pChar[v]] = 227 // praise strength
				}
				if InferiorDice(cyc, v) == 0 && charAgility[pChar[v]] > charAgility[pChar[cyc]] + 10 {
					charPromo[pChar[cyc]][pChar[v]] = 229 // praise agility
				}
				if InferiorDice(cyc, v) == 0 && charIntelligence[pChar[v]] > charIntelligence[pChar[cyc]] + 10 {
					charPromo[pChar[cyc]][pChar[v]] = 231 // praise intelligence
				}
				if InferiorDice(cyc, v) == 0 && charReputation[pChar[v]] > charReputation[pChar[cyc]] + 10 {
					charPromo[pChar[cyc]][pChar[v]] = 233 // praise reputation
				}
				if InferiorDice(cyc, v) == 0 && gamMoney[slot] > 1000 {
					charPromo[pChar[cyc]][pChar[v]] = 235 // praise finances
				}
				if charSnapped[pChar[cyc]] == 0 && charRelation[pChar[cyc]][pChar[v]] == 0 {
					if InferiorDice(cyc, v) == 0 && GetBlock(gamLocation[slot]) == 0 \
					&& charBlock[pChar[cyc]] == charBlock[pChar[v]] {
						charPromo[pChar[cyc]][pChar[v]] = 243 // block comradery
					}
					if InferiorDice(cyc, v) == 0 && GetRace(pChar[v]) == GetRace(pChar[cyc]) {
						charPromo[pChar[cyc]][pChar[v]] = 267 // racial comradery
					}
				}
			}
		}
		 // ridiculed for working
		if (pAnim[v] == 102 && pState[v] == 104) || pAnim[v] == 92 {
			randy = SuperiorDice(cyc, v)
			if randy == 0 && Friendly(cyc, v) == 0 && charGang[pChar[cyc]] != 6 \
			&& cast(bool)InProximity(cyc, v, 50) {
				if cast(bool)InLine(cyc, p[v], talkRange) {
					charPromo[pChar[cyc]][pChar[v]] = 241
				}
			}
		}
		// too close for comfort
		if Friendly(cyc, v) == 0 && charAngerTim[pChar[cyc]][pChar[v]] == 0 \
		&& charGang[pChar[cyc]] != 6 \
		&& cast(bool)InProximity(cyc, v, 30) {
			randy = SuperiorDice(cyc, v)
			if randy <= 1 && pAnim[cyc] >= 12 && pAnim[cyc] <= 13 && pAnim[v] < 20 \
			&& pAgenda[cyc] != 2 && cast(bool)InProximity(cyc, v, 15) {
				if cast(bool)InLine(cyc, p[v], talkRange) {
					charPromo[pChar[cyc]][pChar[v]] = 254 // get out of the way
				}
			}
			if randy >= 2 && randy <= 3 && pAnim[cyc] >= 12 && pAnim[cyc] <= 13 \
			&& pAnim[v] >= 12 && pAnim[v] <= 13 {
				if cast(bool)InLine(v, p[cyc], talkRange) && InLine(cyc, p[v], talkRange) == 0 {
					charPromo[pChar[cyc]][pChar[v]] = 255 // following me?!
				}
			}
			if randy >= 4 && randy <= 5 && pFoc[cyc] == v && pFoc[v] == cyc \
			&& pAnim[cyc] == 0 && pAnim[v] == 0 && pDazed[v] == 0 {
				if cast(bool)InLine(cyc, p[v], talkRange) && cast(bool)InLine(v, p[cyc], talkRange) {
					charPromo[pChar[cyc]][pChar[v]] = 256 // staring at me?!
				}
			}
		}
		// gang membership
		chance: i32 = 10000
		if charGang[pChar[v]] == 0 do chance /= 2
		if charRelation[pChar[cyc]][pChar[v]] > 0 do chance /= 2
		randy = bb.RndI(0, chance)
		if charGang[pChar[cyc]] > 0 && charGang[pChar[v]] != charGang[pChar[cyc]] \
		&& charGangHistory[pChar[v]][charGang[pChar[cyc]]] == 0 \
		&& charRelation[pChar[cyc]][pChar[v]] >= 0 \
		&& charAngerTim[pChar[cyc]][pChar[v]] == 0 \
		&& cast(bool)InProximity(cyc, v, 30) {
			if cast(bool)InLine(cyc, p[v], talkRange) \
			&& (GetRace(pChar[v]) == GetRace(pChar[cyc]) \
			|| charGang[pChar[cyc]] >= 4) {
				if randy <= 1 && charGang[pChar[cyc]] >= 1 && charGang[pChar[cyc]] <= 3 {
					if charReputation[pChar[v]] >= 70 {
						charPromo[pChar[cyc]][pChar[v]] = 32 + charGang[pChar[cyc]] // gang invite
					} else {
						charPromo[pChar[cyc]][pChar[v]] = 94 // rejected
					}
				}
				if randy <= 1 && charGang[pChar[cyc]] == 4 {
					if charIntelligence[pChar[v]] >= 70 {
						charPromo[pChar[cyc]][pChar[v]] = 36 // gladiator invite
					} else {
						charPromo[pChar[cyc]][pChar[v]] = 94 // rejected
					}
				}
				if randy <= 1 && charGang[pChar[cyc]] == 5 {
					if charStrength[pChar[v]] + charAgility[pChar[v]] >= 140 {
						charPromo[pChar[cyc]][pChar[v]] = 37 // gladiator invite
					} else {
						charPromo[pChar[cyc]][pChar[v]] = 94 // rejected
					}
				}
				if randy <= 1 && charGang[pChar[cyc]] == 6 {
					if charReputation[pChar[v]] >= 70 {
						charPromo[pChar[cyc]][pChar[v]] = 38 // gang invite
					} else {
						charPromo[pChar[cyc]][pChar[v]] = 94 // rejected
					}
				}
				if randy == 2 && gamMoney[slot] > 100 {
					charPromo[pChar[cyc]][pChar[v]] = 93 // buy in
				}
			}
		}
		// internal gang issues
		randy = SuperiorDice(cyc, v)
		if charGang[pChar[v]] > 0 && charGang[pChar[v]] == charGang[pChar[cyc]] \
		&& cast(bool)InProximity(cyc, v, 30) {
			if cast(bool)InLine(cyc, p[v], talkRange) {
				if randy == 0 && gamMoney[slot] > 100 do charPromo[pChar[cyc]][pChar[v]] = 95 // kick up
				if promoUsed[96] == 0 {
					if charGang[pChar[v]] == 1 && (charHairStyle[pChar[v]] > 1 || charSpecs[pChar[v]] != 4) {
						charPromo[pChar[cyc]][pChar[v]] = 96 // conform to Suns
					}
					if charGang[pChar[v]] == 5 && charCostume[pChar[v]] > 2 {
						charPromo[pChar[cyc]][pChar[v]] = 96 // conform to Gladiators
					}
				}
			}
		}
		// asks to join your gang
		randy = InferiorDice(cyc, v)
		if randy == 0 && charGang[pChar[v]] > 0 && charGang[pChar[v]] != charGang[pChar[cyc]] \
		&& charGangHistory[pChar[cyc]][charGang[pChar[v]]] == 0 \
		&& charRelation[pChar[cyc]][pChar[v]] >= 0 \
		&& charAngerTim[pChar[cyc]][pChar[v]] == 0 \
		&& cast(bool)InProximity(cyc, v, 30) {
			if cast(bool)InLine(cyc, p[v], talkRange) \
			&& (GetRace(pChar[v]) == GetRace(pChar[cyc]) || charGang[pChar[v]] >= 4) {
				charPromo[pChar[cyc]][pChar[v]] = 92
			}
		}
		// gang rivalry
		randy = SuperiorDice(cyc, v)
		if randy == 0 && charGang[pChar[cyc]] > 0 && charGang[pChar[v]] > 0 \
		&& charGang[pChar[v]] != charGang[pChar[cyc]] \
		&& charGang[pChar[cyc]] != 6 && Friendly(cyc, v) == 0 && cast(bool)InProximity(cyc, v, 30) {
			if cast(bool)InLine(cyc, p[v], talkRange) {
				charPromo[pChar[cyc]][pChar[v]] = 225
			}
		}
		// asks to bury the hatchet
		randy = InferiorDice(cyc, v)
		if randy == 0 && charRelation[pChar[cyc]][pChar[v]] < 0 && charAngerTim[pChar[cyc]][pChar[v]] == 0 \
		&& cast(bool)InProximity(cyc, v, 30) {
			if cast(bool)InLine(cyc, p[v], talkRange) {
				charPromo[pChar[cyc]][pChar[v]] = 97
			}
		}
		// witness blackmails
		if gamWarrant[slot] > 0 && gamMoney[slot] > 0 && pChar[cyc] == charWitness[pChar[v]] \
		&& Friendly(cyc, v) == 0 && cast(bool)InProximity(cyc, v, 50) {
			if cast(bool)InLine(cyc, p[v], talkRange) && promoUsed[55] == 0 {
				charPromo[pChar[cyc]][pChar[v]] = 55
			}
		}
		// offers to take blame
		randy = InferiorDice(cyc, v)
		if gamWarrant[slot] > 0 && gamMoney[slot] > 0 && charRelation[pChar[cyc]][pChar[v]] >= 0 \
		&& charAngerTim[pChar[cyc]][pChar[v]] == 0 && cast(bool)InProximity(cyc, v, 30) {
			if cast(bool)InLine(cyc, p[v], talkRange) {
				if randy == 0 || (randy == 1 && cast(bool)Friendly(cyc, v)) {
					charPromo[pChar[cyc]][pChar[v]] = 56
				}
			}
		}
		// asks you to take blame
		randy = bb.RndI(0, 10000)
		if gamWarrant[slot] == 0 && charRelation[pChar[cyc]][pChar[v]] >= 0 \
		&& charAngerTim[pChar[cyc]][pChar[v]] == 0 \
		&& cast(bool)InProximity(cyc, v, 30) {
			if cast(bool)InLine(cyc, p[v], talkRange) {
				if randy == 0 || (randy == 1 && cast(bool)Friendly(cyc, v)) {
					charPromo[pChar[cyc]][pChar[v]] = 57
				}
			}
		}
		// offers protection
		randy = SuperiorDice(cyc, v)
		if randy == 0 && gamWarrant[slot] == 0 && gamMoney[slot] > 0 \
		&& charRelation[pChar[cyc]][pChar[v]] >= 0 \
		&& charAngerTim[pChar[cyc]][pChar[v]] == 0 && charFollowTim[pChar[cyc]] == 0 \
		&& cast(bool)InProximity(cyc, v, 30) {
			if cast(bool)InLine(cyc, p[v], talkRange) {
				charPromo[pChar[cyc]][pChar[v]] = 74
			}
		}
		if charFollowTim[pChar[cyc]] >= 1 && charFollowTim[pChar[cyc]] <= 100 {
			charPromo[pChar[cyc]][pChar[v]] = 76
		}
		// offers to attack enemy
		randy = SuperiorDice(cyc, v)
		if randy == 0 && gamMoney[slot] > 0 && charRelation[pChar[cyc]][pChar[v]] >= 0 \
		&& charAngerTim[pChar[cyc]][pChar[v]] == 0 && cast(bool)InProximity(cyc, v, 30) {
			charPromoRef[pChar[cyc]] = 0
			its := 0
			for {
				charPromoRef[pChar[cyc]] = pChar[bb.RndI(1, no_plays)]
				its += 1
				if its > 100 {
					charPromoRef[pChar[cyc]] = 0
				}
				if charPromoRef[pChar[cyc]] == 0 || charRelation[pChar[v]][charPromoRef[pChar[cyc]]] < 0 {
					break
				}
			}
			if charPromoRef[pChar[cyc]] > 0 && cast(bool)InLine(cyc, p[v], talkRange) {
				charPromo[pChar[cyc]][pChar[v]] = 81
			}
		}
		// friend of a friend
		randy = InferiorDice(cyc, v)
		if randy == 0 && charRelation[pChar[cyc]][pChar[v]] >= 0 && charAngerTim[pChar[cyc]][pChar[v]] == 0 \
		&& cast(bool)InProximity(cyc, v, 30) {
			charPromoRef[pChar[cyc]] = 0
			its := 0
			for {
				charPromoRef[pChar[cyc]] = bb.RndI(4, no_chars)
				its += 1
				if its > 100 {
					charPromoRef[pChar[cyc]] = 0
				}
				if charPromoRef[pChar[cyc]] > 0 && charRelation[pChar[v]][charPromoRef[pChar[cyc]]] >= 0 {
					break
				}
			}
			if charPromoRef[pChar[cyc]] > 0 && cast(bool)InLine(cyc, p[v], talkRange) {
				charPromo[pChar[cyc]][pChar[v]] = 82
			}
		}
		// enemy by association
		randy = SuperiorDice(cyc, v)
		if randy == 0 && charRelation[pChar[cyc]][pChar[v]] >= 0 && charAngerTim[pChar[cyc]][pChar[v]] == 0 \
		&& cast(bool)InProximity(cyc, v, 30) {
			charPromoRef[pChar[cyc]] = 0
			its := 0
			for {
				charPromoRef[pChar[cyc]] = bb.RndI(4, no_chars)
				its += 1
				if its > 100 {
					charPromoRef[pChar[cyc]] = 0
				}
				if charPromoRef[pChar[cyc]] > 0 && charRelation[pChar[v]][charPromoRef[pChar[cyc]]] < 0 {
					break
				}
			}
			if charPromoRef[pChar[cyc]] > 0 && cast(bool)InLine(cyc, p[v], talkRange) {
				charPromo[pChar[cyc]][pChar[v]] = 85
			}
		}
		// asked to give up friend
		randy = SuperiorDice(cyc, v)
		if randy == 0 && charRelation[pChar[cyc]][pChar[v]] >= 0 && charAngerTim[pChar[cyc]][pChar[v]] == 0 \
		&& cast(bool)InProximity(cyc, v, 30) {
			charPromoRef[pChar[cyc]] = 0
			its := 0
			for {
				charPromoRef[pChar[cyc]] = bb.RndI(4, no_chars)
				its += 1
				if its > 100 {
					charPromoRef[pChar[cyc]] = 0
				}
				if charPromoRef[pChar[cyc]] > 0 && charRelation[pChar[v]][charPromoRef[pChar[cyc]]] > 0 {
					break
				}
			}
			if charPromoRef[pChar[cyc]] > 0 && cast(bool)InLine(cyc, p[v], talkRange) {
				charPromo[pChar[cyc]][pChar[v]] = 86
			}
		}
		// assign mission
		gang := 0
		if charGang[pChar[v]] > 0 && charGang[pChar[v]] == charGang[pChar[cyc]] {
			gang = 1
		}
		if gamMission[slot] == 0 && charRelation[pChar[cyc]][pChar[v]] >= 0 \
		&& charAngerTim[pChar[cyc]][pChar[v]] == 0 \
		&& cast(bool)InProximity(cyc, v, 30) {
			if cast(bool)InLine(cyc, p[v], talkRange) {
				if gang == 1 {
					randy = bb.RndI(0, 10000)
				} else {
					randy = bb.RndI(0, 20000)
				}
				if gang == 1 {
					if randy == 1 && charStrength[pChar[v]] <= 80 {
						charPromo[pChar[cyc]][pChar[v]] = 141 // acquire strength
					}
					if randy == 2 && charAgility[pChar[v]] <= 80 {
						charPromo[pChar[cyc]][pChar[v]] = 142 // acquire agility
					}
					if randy == 3 && charIntelligence[pChar[v]] <= 80 {
						charPromo[pChar[cyc]][pChar[v]] = 143 // acquire intelligence
					}
					if randy == 4 && charReputation[pChar[v]] <= 80 && charGang[pChar[v]] != 6 {
						charPromo[pChar[cyc]][pChar[v]] = 144 // acquire reputation
					}
					if randy == 5 && charReputation[pChar[v]] >= 70 && charGang[pChar[v]] == 6 {
						charPromo[pChar[cyc]][pChar[v]] = 145 // reduce reputation
					}
					if randy == 7 && gamMoney[slot] >= 0 && gamMoney[slot] <= 1000 {
						charPromo[pChar[cyc]][pChar[v]] = 147 // acquire money
					}
					if randy == 8 && charHairStyle[pChar[v]] > 1 \
					&& charHairStyle[pChar[v]] != charHairStyle[pChar[cyc]] {
						charPromo[pChar[cyc]][pChar[v]] = 148 // change hairstyle
					}
					if randy == 9 && charCostume[pChar[v]] != charCostume[pChar[cyc]] {
						charPromo[pChar[cyc]][pChar[v]] = 149 // change costume
					}
					if randy <= 9 && gamMoney[slot] < 0 {
						charPromo[pChar[cyc]][pChar[v]] = 146 // get out of debt
					}
					if randy == 19 && gamWarrant[slot] == 0 && charGang[pChar[v]] != 6 {
						charPromo[pChar[cyc]][pChar[v]] = 159 // get arrested
					}
				}
				if randy == 10 {
					charPromo[pChar[cyc]][pChar[v]] = 150 // bring item
				}
				if randy == 11 && pWeapon[cyc] > 0 {
					charPromo[pChar[cyc]][pChar[v]] = 151 // deliver given item
				}
				if randy == 12 {
					charPromo[pChar[cyc]][pChar[v]] = 152 // find & deliver item
				}
				if randy == 13 && charGang[pChar[cyc]] != 6 {
					charPromo[pChar[cyc]][pChar[v]] = 153 // kill character
				}
				if randy == 14 && charGang[pChar[cyc]] != 6 {
					charPromo[pChar[cyc]][pChar[v]] = 154 // injure character
				}
				if randy == 15 && charGang[pChar[cyc]] != 6 {
					charPromo[pChar[cyc]][pChar[v]] = 155 // assault character
				}
				if randy == 16 {
					charPromo[pChar[cyc]][pChar[v]] = 156 // meet character
				}
				if randy == 17 {
					charPromo[pChar[cyc]][pChar[v]] = 157 // identify character
				}
				if randy == 18 && gamHours[slot] <= 20 {
					charPromo[pChar[cyc]][pChar[v]] = 158 // guard character
				}
				if randy == 20 && charGang[pChar[v]] == 0 {
					charPromo[pChar[cyc]][pChar[v]] = 160 // join gang
				}
			}
		}
		// mission reminder
		if gamMission[slot] > 0 && pChar[cyc] == gamClient[slot] && cast(bool)InProximity(cyc, v, 50) {
			if cast(bool)InLine(cyc, p[v], talkRange) && promoUsed[171] == 0 {
				charPromo[pChar[cyc]][pChar[v]] = 171
			}
		}
	}
	////////////////////// UNIVERSAL ISSUES ////////////////////
	if charPromo[pChar[cyc]][pChar[v]] == 0 && pChar[v] == gamChar[slot] {
		if charFollowTim[pChar[cyc]] == 0 && (gamMission[slot] != 18 || pChar[cyc] != gamClient[slot]) \
		&& AttackViable(cyc) >= 1 && AttackViable(cyc) <= 2 && pDazed[cyc] == 0 {
			// offers to heal you
			randy := bb.RndI(0, 5000)
			if gamLocation[slot] == 6 {
				randy = bb.RndI(0, 1000)
			}
			if randy == 0 && gamMoney[slot] > 0 && charRelation[pChar[cyc]][pChar[v]] >= 0 \
			&& charAngerTim[pChar[cyc]][pChar[v]] == 0 && cast(bool)InProximity(cyc, v, 30) {
				injury := 0
				for limb in 1..=40 {
					if pScar[v][limb] >= 5 {
						injury += 1
					}
				}
				if injury > 0 && cast(bool)InLine(cyc, p[v], talkRange) {
					charPromo[pChar[cyc]][pChar[v]] = 250
				}
			}
			// offers to forge qualifications
			randy = bb.RndI(0, 10000)
			if gamLocation[slot] == 4 {
				randy = bb.RndI(0, 5000)
			}
			if randy == 0 && gamMoney[slot] > 100 && charIntelligence[pChar[v]] <= 75 \
			&& charRelation[pChar[cyc]][pChar[v]] >= 0 && charAngerTim[pChar[cyc]][pChar[v]] == 0 \
			&& cast(bool)InProximity(cyc, v, 30) {
				if cast(bool)InLine(cyc, p[v], talkRange) {
					charPromo[pChar[cyc]][pChar[v]] = 253
				}
			}
		}
		// time up on bribes
		if charBribeTim[pChar[cyc]] >= 1 && charBribeTim[pChar[cyc]] <= 100 \
		&& charFollowTim[pChar[cyc]] == 0 {
			charPromo[pChar[cyc]][pChar[v]] = 75
		}
		if charFollowTim[pChar[cyc]] >= 1 && charFollowTim[pChar[cyc]] <= 100 {
			charPromo[pChar[cyc]][pChar[v]] = 76
		}
	}
	////////////////////// LAST MINUTE LOGIC ////////////////////
	if charPromo[pChar[cyc]][pChar[v]] > 0 {
		// no longer carrying weapon
		if charPromo[pChar[cyc]][pChar[v]] == 1 || charPromo[pChar[cyc]][pChar[v]] == 16 \
		|| charPromo[pChar[cyc]][pChar[v]] == 18 || charPromo[pChar[cyc]][pChar[v]] == 48 \
		|| charPromo[pChar[cyc]][pChar[v]] == 53 || charPromo[pChar[cyc]][pChar[v]] == 72 {
			if pWeapon[v] == 0 {
				charPromo[pChar[cyc]][pChar[v]] = 0
			}
		}
		if charPromo[pChar[cyc]][pChar[v]] == 49 || charPromo[pChar[cyc]][pChar[v]] == 50 {
			if pWeapon[cyc] == 0 {
				charPromo[pChar[cyc]][pChar[v]] = 0
			}
		}
		// no longer in a gang
		if charPromo[pChar[cyc]][pChar[v]] == 42 && charGang[pChar[cyc]] == 0 {
			charPromo[pChar[cyc]][pChar[v]] = 0
		}
		if charPromo[pChar[cyc]][pChar[v]] == 47 {
			if charGang[pChar[cyc]] == 0 || charGang[pChar[v]] == 0 {
				charPromo[pChar[cyc]][pChar[v]] = 0
			}
		}
		if charPromo[pChar[cyc]][pChar[v]] == 45 && charGang[pChar[v]] == 0 {
			charPromo[pChar[cyc]][pChar[v]] = 0
		}
		if charPromo[pChar[cyc]][pChar[v]] == 46 && charGang[pChar[cyc]] == 0 {
			charPromo[pChar[cyc]][pChar[v]] = 0
		}
		// no longer wanted
		if charPromo[pChar[cyc]][pChar[v]] == 55 || charPromo[pChar[cyc]][pChar[v]] == 56 \
		|| charPromo[pChar[cyc]][pChar[v]] == 59 {
			if gamWarrant[slot] == 0 {
				charPromo[pChar[cyc]][pChar[v]] = 0
			}
		}
		// victim no longer dead
		if charPromo[pChar[cyc]][pChar[v]] == 82 || charPromo[pChar[cyc]][pChar[v]] == 83 {
			if charLocation[charPromoRef[pChar[cyc]]] > 0 {
				charPromo[pChar[cyc]][v] = 0
			}
		}
		// life no longer in danger
		if charPromo[pChar[cyc]][pChar[v]] == 258 && pHealth[cyc] <= 0 {
			charPromo[pChar[cyc]][pChar[v]] = 0
		}
		// already used
		if promoUsed[charPromo[pChar[cyc]][pChar[v]]] != 0 {
			charPromo[pChar[cyc]][pChar[v]] = 0
		}
	}
}


//--------------------------------------------------------------------
///////////////////////////// PROMO TEXT /////////////////////////////
//--------------------------------------------------------------------
DisplayPromo :: proc() {
	// translate identities
	cyc := promoActor[1]
	v := promoActor[2]
	//oldFoc := camFoc // Unused
	// introduce widescreen
	if gamPromo > 0 {
		y: f32 = 60
		if promoTim <= 25 do y = PercentOf(60, f32(promoTim) * 4)
		if promoTim >= 9975 do y = PercentOf(60, (10000 - f32(promoTim)) * 4)
		bb.Color(0, 0, 0)
		bb.Rect(i32(rX(0)), i32(rY(0)), i32(rX(800)), i32(rY(y)), 1)
		y = 480
		if promoTim <= 25 do y = 600 - PercentOf(120, f32(promoTim) * 4)
		if promoTim >= 9975 do y = 600 - PercentOf(120, (10000 - f32(promoTim)) * 4)
		bb.Color(0, 0, 0)
		bb.Rect(i32(rX(0)), i32(rY(y)), i32(rX(800)), i32(rY(600)), 1)
	}
	// determine font
	bb.SetFont(font[4])
	if bb.GraphicsWidth() < 800 do bb.SetFont(font[3])
	if bb.GraphicsWidth() > 800 do bb.SetFont(font[5])
	if bb.GraphicsWidth() > 1024 do bb.SetFont(font[6])
	// 1. GUARD CONFRONTS ABOUT ILLEGAL WEAPON
	if gamPromo == 1 {
		// intro
		optionA = "Yes, drop weapon..."
		optionB = "No, it's mine!"
		if promoStage == 0 && promoTim > 25 && promoTim < 325 {
			Speak(cyc, 1)
			cell_name := CellName(pChar[v])
			full_cell_name := fmt.aprint("Hey, ", cell_name, ", stop where you are! What")
			Outline(full_cell_name, i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			lower := bb.Lower(weapName[weapType[pWeapon[v]]])
			full_lower := fmt.aprint("are you doing with that ", lower, "?")
			Outline(full_lower, i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
			delete(full_lower)
			delete(full_cell_name)
			delete(cell_name)
			delete(lower)
		}
		if promoStage == 0 && promoTim > 350 && promoTim < 650 {
			Speak(cyc, 1)
			Outline("You know you're not allowed to carry weapons!", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("Put it down immediately or there'll be trouble...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoStage == 0 && promoTim > 650 do camFoc = v
		if promoStage == 0 && promoTim > 675 {
			promoStage = 1
			foc = 1
			keytim = 20
		}
		// responses
		if promoStage == 2 && promoTim > 325 && promoTim < 625 {
			Speak(cyc, 2)
			if promoEffect == 0 {
				charHappiness[pChar[v]] -= 5
				charReputation[pChar[v]] -= 1
				charAngerTim[pChar[cyc]][pChar[v]] = 0
				promoEffect = 1
			}
			Outline("That's right. Step away from the weapon and", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("perhaps we won't have to take this any further...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoStage == 3 && promoTim > 325 && promoTim < 625 {
			Speak(cyc, 1)
			if promoEffect == 0 {
				charReputation[pChar[v]] += 1
				if charAngerTim[pChar[cyc]][pChar[v]] < 100 do charAngerTim[pChar[cyc]][pChar[v]] = 100
				ChangeRelationship(pChar[cyc], pChar[v], -1)
				pAgenda[cyc] = 2
				pFollowFoc[cyc] = v
				randy := bb.RndI(0, 5)
				if randy == 0 && gamWarrant[slot] < 1 do gamWarrant[slot] = 1
				if randy == 1 && gamWarrant[slot] < 4 && pWeapon[v] > 0 && gamMission[slot] != 11 && gamMission[slot] != 12 {
					gamWarrant[slot] = 4
					gamItem[slot] = pWeapon[v]
				}
				promoEffect = 1
			}
			Outline("Well, you better know how to use it because", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("i'm gonna kick your ass until you give it up!", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoStage == 4 && promoTim > 325 && promoTim < 625 {
			promoTim = 9975
			promoUsed[gamPromo] = 1
		}
	}
	// 2. TOLD TO RETURN TO HOME BLOCK
	if gamPromo == 2 {
		if promoTim > 25 && promoTim < 325 {
			Speak(cyc, 1)
			cell_name := CellName(pChar[v])
			full_string := fmt.aprintf("Hey, ", cell_name, ", didn't you hear the buzzer? This")
			Outline(full_string, i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("place has been locked down for the night!", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
			delete(full_string)
			delete(cell_name)
		}
		if promoTim > 350 && promoTim < 650 {
			Speak(cyc, 1)
			if promoEffect == 0 {
				charHappiness[pChar[v]] -= 1
				charReputation[pChar[v]] -= 1
				promoEffect = 1
			}
			full_string := fmt.aprint("You're supposed to be in the ", textBlock[charBlock[pChar[v]]], " Block.")
			Outline(full_string, i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("Make your way there before i drag your sorry ass!", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
			delete(full_string)
		}
		if promoTim > 650 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = 1
		}
	}
	// 3. TOLD TO RETURN TO HOME CELL
	if gamPromo == 3 {
		if promoTim > 25 && promoTim < 325 {
			Speak(cyc, 1)
			cell_name := CellName(pChar[v])
			full_string := fmt.aprint("Come on, ", cell_name, ", get back to your cell! We're")
			Outline(full_string, i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("trying to lock this place down for the night...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
			delete(cell_name)
			delete(full_string)

		}
		if promoTim > 350 && promoTim < 650 {
			Speak(cyc, 1)
			if promoEffect == 0 {
				charHappiness[pChar[v]] -= 1
				charReputation[pChar[v]] -= 1
				promoEffect = 1
			}
			full_string := fmt.aprint("Your bed is in Cell ", charCell[pChar[v]], ". Use that one or")
			Outline(full_string, i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("i'll have to put you in a HOSPITAL bed!", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
			delete(full_string)
		}
		if promoTim > 650 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = 1
		}
	}
	// 4. TOLD OFF FOR FIGHTING
	if gamPromo == 4 {
		if promoTim > 25 && promoTim < 325 {
			Speak(cyc, 1)
			cell_name := CellName(pChar[v])
			full_string := fmt.aprint("Hey, ", cell_name, ", what's the problem here?")
			Outline(full_string, i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("If there's any fighting to do, i'll do it!", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
			delete(full_string)
			delete(cell_name)
		}
		if promoTim > 350 && promoTim < 650 {
			Speak(cyc, 1)
			if promoEffect == 0 {
				charHappiness[pChar[v]] -= 1
				charReputation[pChar[v]] += 1
				charAngerTim[pChar[cyc]][pChar[v]] = 0
				promoEffect = 1
			}
			Outline("All you animals have to worry about is the rules,", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("so stop bickering before i really lose my temper!", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 650 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = 1
		}
	}
	// 5. TOLD OFF FOR ATTACKING GUARD
	if gamPromo == 5 {
		if promoTim > 25 && promoTim < 325 {
			Speak(cyc, 1)
			cell_name := CellName(pChar[v])
			full_string := fmt.aprint("Hey, ", cell_name, ", you've got no business")
			Outline(full_string, i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("putting your hands on a police officer!", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
			delete(full_string)
			delete(cell_name)
		}
		if promoTim > 350 && promoTim < 650 {
			Speak(cyc, 1)
			Outline("If you want to pick a fight with us, we'll make", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("your life even more unbearable inside these walls!", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 675 && promoTim < 975 {
			Speak(cyc, 1)
			if promoEffect == 0 {
				charHappiness[pChar[v]] -= 1
				charReputation[pChar[v]] += 1
				DamageRelationship(pChar[cyc], pChar[v], -1)
				promoEffect = 1
			}
			Outline("Now straighten up and fly right before i", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("show you how hard a REAL man can hit!", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 975 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = 1
		}
	}
	// 6. REMINDED ABOUT DINNER TIME
	if gamPromo == 6 {
		if promoTim > 25 && promoTim < 325 {
			Speak(cyc, 2)
			cell_name := CellName(pChar[v])
			full_string := fmt.aprint("Hey, ", cell_name, ", didn't you hear the bell? Dinner")
			Outline(full_string, i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("is served! Go and get something to eat...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
			delete(full_string)
			delete(cell_name)
		}
		if promoTim > 325 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = 1
		}
	}
	// 7. TOLD TO GIVE UP SEAT
	if gamPromo == 7 {
		// intro
		optionA = "Yes, give up seat..."
		optionB = "No, go away!"
		if promoStage == 0 && promoTim > 25 && promoTim < 325 {
			Speak(cyc, 1)
			promoVariable = pSeat[v]
			cell_name := CellName(pChar[v])
			full_string := fmt.aprint("Hey, ", cell_name, ", get out of that seat!")
			Outline(full_string, i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("You've been hogging it all day. It's MY turn!", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
			delete(full_string)
			delete(cell_name)
		}
		if promoStage == 0 && promoTim > 325 do camFoc = v
		if promoStage == 0 && promoTim > 350 {
			promoStage = 1
			foc = 1
			keytim = 20
		}
		// responses
		if promoStage == 2 && promoTim > 325 && promoTim < 625 {
			Speak(cyc, 2)
			if promoVariable > 0 {
				digit := Dig(promoVariable, 10)
				child_string := fmt.aprint("Chair", digit)
				target := bb.FindChild(world, child_string)
				pTX[cyc] = bb.EntityX(target, 1)
				pTZ[cyc] = bb.EntityZ(target, 1)
				pAgenda[cyc] = -1
				pSubX[cyc] = 9999
				pSubZ[cyc] = 9999
				delete(child_string)
				delete(digit)
			}
			if promoEffect == 0 {
				charHappiness[pChar[v]] -= 5
				charReputation[pChar[v]] -= 1
				ChangeRelationship(pChar[cyc], pChar[v], -1)
				promoEffect = 1
			}
			Outline("That's right - take your lazy ass somewhere else!", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("I'm the king of this place and i deserve a throne...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoStage == 3 && promoTim > 325 && promoTim < 625 {
			Speak(cyc, 1)
			if promoEffect == 0 {
				charReputation[pChar[v]] += 1
				if charAngerTim[pChar[cyc]][pChar[v]] < 100 {
					charAngerTim[pChar[cyc]][pChar[v]] = 100
				}
				ChangeRelationship(pChar[cyc], pChar[v], -1)
				pAgenda[cyc] = 2
				pFollowFoc[cyc] = v
				promoEffect = 1
			}
			Outline("Fine! If you won't abdicate the throne, i'll", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("just have to drag your sorry ass from it!", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoStage >= 2 && promoTim > 625 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = 1
		}
	}
	// 8. TOLD TO GIVE UP BED
	if gamPromo == 8 {
		// intro
		optionA = "Yes, give up bed..."
		optionB = "No, go away!"
		if promoStage == 0 && promoTim > 25 && promoTim < 325 {
			Speak(cyc, 1)
			promoVariable = pBed[v]
			cell_name := CellName(pChar[v])
			full_string := fmt.aprint("Hey, ", cell_name, ", get out of that bed!")
			Outline(full_string, i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("I need to sleep too - and we're not sharing!", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
			delete(full_string)
			delete(cell_name)
		}
		if promoStage == 0 && promoTim > 325 do camFoc = v
		if promoStage == 0 && promoTim > 350 {
			promoStage = 1
			foc = 1
			keytim = 20
		}
		// responses
		if promoStage == 2 && promoTim > 325 && promoTim < 625 {
			Speak(cyc, 2)
			if promoVariable > 0 {
				digit := Dig(promoVariable, 10)
				child_string := fmt.aprint("Bed", digit)
				target := bb.FindChild(world, child_string)
				pTX[cyc] = bb.EntityX(target, 1)
				pTZ[cyc] = bb.EntityZ(target, 1)
				pAgenda[cyc] = -1
				pSubX[cyc] = 9999
				pSubZ[cyc] = 9999
				delete(child_string)
				delete(digit)
			}
			if promoEffect == 0 {
				charHappiness[pChar[v]] -= 5
				charReputation[pChar[v]] -= 1
				ChangeRelationship(pChar[cyc], pChar[v], -1)
				promoEffect = 1
			}
			Outline("That's right - take your lazy ass somewhere else!", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("I need my sleep, and you're not getting it!", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoStage == 3 && promoTim > 325 && promoTim < 625 {
			Speak(cyc, 1)
			if promoEffect == 0 {
				charReputation[pChar[v]] += 1
				if charAngerTim[pChar[cyc]][pChar[v]] < 100 {
					charAngerTim[pChar[cyc]][pChar[v]] = 100
				}
				ChangeRelationship(pChar[cyc], pChar[v], -1)
				pAgenda[cyc] = 2
				pFollowFoc[cyc] = v
				promoEffect = 1
			}
			Outline("Fine! If you won't stop dreaming, i'll", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("give you a NIGHTMARE to wake up to!", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoStage >= 2 && promoTim > 625 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = 1
		}


	}
	// 9. COMPLAIN ABOUT LOSING SEAT


	
}


ChangeRelationship :: proc(cyc, v, relation: i32) {
	
}


TriggerPromo :: proc(cyc, v, promo: i32) {

}


FacialExpressions :: proc(cyc: i32) {
	
}


ChangeGang :: proc(char, gang: i32) {
	
}


InferiorDice :: proc(cyc, v: i32) -> i32{
	return 0
}


SuperiorDice :: proc(cyc, v: i32) -> i32{
	return 0
}

Speak :: proc(cyc, v: i32) {
	
}

CellName :: proc(location: i32, allocator := context.allocator) -> string {
	return ""
}

DamageRelationship :: proc(cyc, v, damage: i32) {
	
}