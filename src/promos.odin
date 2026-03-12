package main

import bb "blitzbasic3d"
import "core:fmt"
import "core:strings"
import "core:mem"

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
	checkpoint := mem.begin_arena_temp_memory(cast(^mem.Arena)(context.temp_allocator.data))
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
	delete(optionA)
	delete(optionB)
	// 1. GUARD CONFRONTS ABOUT ILLEGAL WEAPON
	if gamPromo == 1 {
		// intro
		optionA = strings.clone("Yes, drop weapon...")
		optionB = strings.clone("No, it's mine!")
		if promoStage == 0 && promoTim > 25 && promoTim < 325 {
			Speak(cyc, 1)
			full_cell_name := fmt.tprint("Hey, ", CellName(pChar[v], context.temp_allocator), ", stop where you are! What")
			Outline(full_cell_name, i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			lower := bb.Lower(weapName[weapType[pWeapon[v]]])
			full_lower := fmt.tprint("are you doing with that ", lower, "?")
			Outline(full_lower, i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
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
			full_string := fmt.tprintf("Hey, %s, didn't you hear the buzzer? This", CellName(pChar[v], context.temp_allocator))
			Outline(full_string, i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("place has been locked down for the night!", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 350 && promoTim < 650 {
			Speak(cyc, 1)
			if promoEffect == 0 {
				charHappiness[pChar[v]] -= 1
				charReputation[pChar[v]] -= 1
				promoEffect = 1
			}
			full_string := fmt.tprint("You're supposed to be in the ", textBlock[charBlock[pChar[v]]], " Block.")
			Outline(full_string, i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("Make your way there before i drag your sorry ass!", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
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
			full_string := fmt.tprint("Come on, ", CellName(pChar[v], context.temp_allocator), ", get back to your cell! We're")
			Outline(full_string, i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("trying to lock this place down for the night...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 350 && promoTim < 650 {
			Speak(cyc, 1)
			if promoEffect == 0 {
				charHappiness[pChar[v]] -= 1
				charReputation[pChar[v]] -= 1
				promoEffect = 1
			}
			full_string := fmt.tprint("Your bed is in Cell ", charCell[pChar[v]], ". Use that one or")
			Outline(full_string, i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("i'll have to put you in a HOSPITAL bed!", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
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
			full_string := fmt.tprint("Hey, ", CellName(pChar[v], context.temp_allocator), ", what's the problem here?")
			Outline(full_string, i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("If there's any fighting to do, i'll do it!", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
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
			full_string := fmt.tprint("Hey, ", CellName(pChar[v], context.temp_allocator), ", you've got no business")
			Outline(full_string, i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("putting your hands on a police officer!", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
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
			full_string := fmt.tprint("Hey, ", CellName(pChar[v], context.temp_allocator), ", didn't you hear the bell? Dinner")
			Outline(full_string, i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("is served! Go and get something to eat...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 325 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = 1
		}
	}
	// 7. TOLD TO GIVE UP SEAT
	if gamPromo == 7 {
		// intro
		optionA = strings.clone("Yes, give up seat...")
		optionB = strings.clone("No, go away!")
		if promoStage == 0 && promoTim > 25 && promoTim < 325 {
			Speak(cyc, 1)
			promoVariable = pSeat[v]
			full_string := fmt.tprint("Hey, ", CellName(pChar[v], context.temp_allocator), ", get out of that seat!")
			Outline(full_string, i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("You've been hogging it all day. It's MY turn!", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
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
				child_string := fmt.tprint("Chair", digit)
				target := bb.FindChild(world, child_string)
				pTX[cyc] = bb.EntityX(target, 1)
				pTZ[cyc] = bb.EntityZ(target, 1)
				pAgenda[cyc] = -1
				pSubX[cyc] = 9999
				pSubZ[cyc] = 9999
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
		optionA = strings.clone("Yes, give up bed...")
		optionB = strings.clone("No, go away!")
		if promoStage == 0 && promoTim > 25 && promoTim < 325 {
			Speak(cyc, 1)
			promoVariable = pBed[v]
			full_string := fmt.tprint("Hey, ", CellName(pChar[v], context.temp_allocator), ", get out of that bed!")
			Outline(full_string, i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("I need to sleep too - and we're not sharing!", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
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
				child_string := fmt.tprint("Bed", digit)
				target := bb.FindChild(world, child_string)
				pTX[cyc] = bb.EntityX(target, 1)
				pTZ[cyc] = bb.EntityZ(target, 1)
				pAgenda[cyc] = -1
				pSubX[cyc] = 9999
				pSubZ[cyc] = 9999
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
	if gamPromo == 9 {
		if promoTim > 25 && promoTim < 325 {
			Speak(cyc, 1)
			if promoEffect == 0 {
				charHappiness[pChar[v]] -= 1
				charReputation[pChar[v]] += 1
				if charAngerTim[pChar[cyc]][pChar[v]] < 100 {
					charAngerTim[pChar[cyc]][pChar[v]] = 100
				}
				DamageRelationship(pChar[cyc], pChar[v], -1)
				pAgenda[cyc] = 2
				pFollowFoc[cyc] = v
				promoEffect = 1
			}
			full_string := fmt.tprint("Hey, ", charName[pChar[v]], ", i was sitting there!")
			Outline(full_string, i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("Since i'm on my feet, i should kick your ass!", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 325 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = 1
		}
	}
	// 10. COMPLAIN ABOUT LOSING BED
	if gamPromo == 10 {
		if promoTim > 25 && promoTim < 325 {
			Speak(cyc, 1)
			if promoEffect == 0 {
				charHappiness[pChar[v]] -= 1
				charReputation[pChar[v]] += 1
				if charAngerTim[pChar[cyc]][pChar[v]] < 100 {
					charAngerTim[pChar[cyc]][pChar[v]] = 100
				}
				DamageRelationship(pChar[cyc], pChar[v], -1)
				pAgenda[cyc] = 2
				pFollowFoc[cyc] = v
				promoEffect = 1
			}
			full_string := fmt.tprint("Hey, ", charName[pChar[v]], ", i was sleeping there!")
			Outline(full_string, i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("You don't wake me up unless you want a fight!", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 325 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = 1
		}
	}
	// 11. TOLD TO STOP SLEEPING
	if gamPromo == 11 {
		// intro
		optionA = strings.clone("Yes, get up...")
		optionB = strings.clone("No, leave me alone!")
		if promoStage == 0 && promoTim > 25 && promoTim < 325 {
			Speak(cyc, 1)
			full_string := fmt.tprint("Hey, ", CellName(pChar[v], context.temp_allocator), ", sleeping time is over!")
			Outline(full_string, i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("Get out of bed before i drag you out!", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoStage == 0 && promoTim > 325 {
			camFoc = v
		}
		if promoStage == 0 && promoTim > 350 {
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
			Outline("That's right - wake your lazy ass up!", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("There's plenty you could be doing...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
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
				randy := bb.RndI(0, 5)
				if randy == 0 && gamWarrant[slot] < 1 {
					gamWarrant[slot] = 1
				}
				promoEffect = 1
			}
			Outline("Fine! If you want to sleep all day, i'll", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("give you a reason to be flat on your back!", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoStage >= 2 && promoTim > 625 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = 1
		}
	}
	// 12. GUARD TELLS YOU TO LEAVE FOREIGN CELL
	if gamPromo == 12 {
		if promoTim > 25 && promoTim < 325 {
			Speak(cyc, 1)
			if promoEffect == 0 {
				charHappiness[pChar[v]] -= 1
				charReputation[pChar[v]] += 1
				if charAngerTim[pChar[cyc]][pChar[v]] < 100 {
					charAngerTim[pChar[cyc]][pChar[v]] = 100
				}
				pAgenda[cyc] = 2
				pFollowFoc[cyc] = v
				pSubX[cyc] = 9999
				pSubZ[cyc] = 9999
				randy := bb.RndI(0, 10)
				if randy == 0 && gamWarrant[slot] < 1 {
					gamWarrant[slot] = 1
				}
				promoEffect = 1
			}
			full_string := fmt.tprint("Hey, ", CellName(pChar[v], context.temp_allocator), ", get out of that cell!")
			Outline(full_string, i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("You've got no business being in there...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 325 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = 1
		}
	}
	// 13. INMATE TELLS YOU TO LEAVE HIS CELL
	if gamPromo == 13 {
		if promoTim > 25 && promoTim < 325 {
			Speak(cyc, 1)
			if promoEffect == 0 {
				charHappiness[pChar[v]] -= 1
				charReputation[pChar[v]] += 1
				if charAngerTim[pChar[cyc]][pChar[v]] < 100 {
					charAngerTim[pChar[cyc]][pChar[v]] = 100
				}
				ChangeRelationship(pChar[cyc], pChar[v], -1)
				pAgenda[cyc] = 2
				pFollowFoc[cyc] = v
				pSubX[cyc] = 9999
				pSubZ[cyc] = 9999
				promoEffect = 1
			}
			Outline("Hey, what are you doing in MY cell?!", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("Get out of there before i kick you out!", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 325 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = 1
		}
	}
	// 14. COMPLAIN ABOUT UNPROVOKED ATTACK
	if gamPromo == 14 {
		if promoTim > 25 && promoTim < 325 {
			Speak(cyc, 1)
			if promoEffect == 0 {
				charHappiness[pChar[v]] -= 1
				charReputation[pChar[v]] += 1
				if charAngerTim[pChar[cyc]][pChar[v]] < 100 {
					charAngerTim[pChar[cyc]][pChar[v]] = 100
				}
				DamageRelationship(pChar[cyc], pChar[v], -1)
				promoEffect = 1
			}
			Outline("Hey, what's your problem?! Touch me again", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("and it'll be the last thing you ever do...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 325 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = 1
		}
	}
	// 15. COMPLAIN ABOUT BEING BUMPED
	if gamPromo == 15 {
		if promoTim > 25 && promoTim < 325 {
			Speak(cyc, 1)
			ShowPhoto(charPromoRef[pChar[cyc]])
			full_string := fmt.tprint("Hey, ", charName[pChar[v]], ", watch who you mess with!")
			full_string2 := fmt.tprint( charName[charPromoRef[pChar[cyc]]], " is a personal friend of mine...")
			Outline(full_string, i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline(full_string2, i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 350 && promoTim < 650 {
			Speak(cyc, 1)
			if promoEffect == 0 {
				if charAngerTim[pChar[cyc]][pChar[v]] < 100 {
					charAngerTim[pChar[cyc]][pChar[v]] = 100
				}
				ChangeRelationship(pChar[cyc], pChar[v], -1)
				pAgenda[cyc] = 2
				pFollowFoc[cyc] = v
				pSubX[cyc] = 9999
				pSubZ[cyc] = 9999
				promoEffect = 1
			}
			Outline("An attack on MY friends is an attack on", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("ME, so let's see how tough you are now!", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 650 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = 1
		}
	}
	// 16. INMATE DEMANDS ITEM
	if gamPromo == 16 {
		// intro
		optionA = strings.clone("Yes, give item...")
		optionB = strings.clone("No, it's mine!")
		if promoStage == 0 && promoTim > 25 && promoTim < 325 {
			Speak(cyc, 1)
			weap_name := bb.Lower(weapName[weapType[pWeapon[v]]])
			full_string := fmt.tprint("Hey, ", charName[pChar[v]], ", i need that ", weap_name, "!")
			Outline(full_string, i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("Give it to me or i'll take it by force...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoStage == 0 && promoTim > 325 {
			camFoc = v
		}
		if promoStage == 0 && promoTim > 350 {
			promoStage = 1
			foc = 1
			keytim = 20
		}
		// responses
		if promoStage == 2 && promoTim > 325 && promoTim < 625 {
			Speak(cyc, 3)
			if promoEffect == 0 {
				charHappiness[pChar[v]] -= 5
				charReputation[pChar[v]] -= 1
				DamageRelationship(pChar[cyc], pChar[v], 1)
				promoEffect = 1
			}
			Outline("Thanks, this should come in handy!", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("Maybe i'll return the favour some time...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoStage == 3 && promoTim > 325 && promoTim < 625 {
			Speak(cyc, 1)
			if promoEffect == 0 {
				charReputation[pChar[v]] += 1
				if charAngerTim[pChar[cyc]][pChar[v]] < 100 {
					charAngerTim[pChar[cyc]][pChar[v]] = 100
				}
				ChangeRelationship(pChar[cyc], pChar[v], -1)
				pAgenda[cyc] = 4
				pWeapFoc[cyc] = pWeapon[v]
				promoEffect = 1
			}
			Outline("Well, it better be worth it because i'm", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("gonna kick your ass until you give it up!", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoStage >= 2 && promoTim > 625 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = 1
		}
	}
	// 17. COMPLAIN ABOUT STOLEN ITEM
	if gamPromo == 17 {
		// intro
		optionA = strings.clone("Yes, return item...")
		optionB = strings.clone("No, it's mine!")
		if promoStage == 0 && promoTim > 25 && promoTim < 325 {
			Speak(cyc,1)
			lower := bb.Lower(weapName[weapType[pWeapon[v]]])
			full_string := fmt.tprint("Hey, ", charName[pChar[v]], ", that's my ", lower, "!")
			Outline(full_string, i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("Give it back or i'll show you what it's for...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoStage == 0 && promoTim > 350 && promoTim < 650 do camFoc = v
		if promoStage == 0 && promoTim > 350 && promoTim < 650 {
			promoStage = 1
			foc = 1
			keytim = 20
		}
		// responses
		if promoStage == 2 && promoTim > 325 && promoTim < 625 {
			Speak(cyc,2)
			if promoEffect == 0 {
				charHappiness[pChar[v]] -= 1
				charReputation[pChar[v]] -= 1
				ChangeRelationship(pChar[cyc],pChar[v],0)
				charAngerTim[pChar[cyc]][pChar[v]] = 0
				promoEffect = 1
			}
			Outline("I should think so too! If you ever touch my stuff", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("again, i won't give you a choice in the matter...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoStage == 3 && promoTim > 325 && promoTim < 625 {
			Speak(cyc,1)
			if promoEffect == 0 {
				charReputation[pChar[v]] += 1
				if charAngerTim[pChar[cyc]][pChar[v]] < 100 do charAngerTim[pChar[cyc]][pChar[v]] = 100
				ChangeRelationship(pChar[cyc],pChar[v],-1)
				pAgenda[cyc] = 4
				pWeapFoc[cyc] = pWeapon[v]
				randy := bb.RndI(0,5)
				if randy == 0 && charRole[pChar[cyc]] == 1 && gamWarrant[slot] < 1 do gamWarrant[slot] = 1
				if pWeapon[v] > 0 && gamMission[slot] != 11 && gamMission[slot] != 12 {
					if randy == 1 && charRole[pChar[cyc]] == 1 && gamWarrant[slot] < 4 {
						gamWarrant[slot] = 4
						gamItem[slot] = pWeapon[v]
					}
					if randy == 2 && gamWarrant[slot] < 7 {
						gamWarrant[slot] = 7
						gamItem[slot] = pWeapon[v]
					}
				}
				promoEffect = 1
			}
			Outline("Well, that just makes me all the more suspicious!", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("Anything valuable to you is worth confiscating...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoStage >= 2 && promoTim > 625 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = 1
		}
	}
	// 18. CARRYING ITEM OUT OF CONTEXT
	if gamPromo == 18 {
		// intro
		optionA = strings.clone("Yes, drop item...")
		optionB = strings.clone("No, it's mine!")
		if promoStage == 0 && promoTim > 25 && promoTim < 325 {
			Speak(cyc,1)
			promoVariable := weapType[pWeapon[v]]
			lower := bb.Lower(weapName[promoVariable])
			full_string := fmt.tprint("Hey, ", CellName(pChar[v], context.temp_allocator), ", stop where you are! What")
			Outline(full_string, i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			full_string2 := fmt.tprint("are you doing with that ", lower, "?")
			Outline(full_string2, i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoStage == 0 && promoTim > 350 && promoTim < 650 {
			Speak(cyc,1)
			Outline("You know that kind of thing doesn't belong here!", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
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
			Speak(cyc,2)
			if promoEffect == 0 {
				charHappiness[pChar[v]] -= 5
				charReputation[pChar[v]] -= 1
				charAngerTim[pChar[cyc]][pChar[v]] = 0
				promoEffect = 1
			}
			full_string := fmt.tprint("That's right. Step away from the ", weapName[promoVariable])
			Outline(full_string, i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("and we won't have to take this any further...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoStage == 3 && promoTim > 325 && promoTim < 625 {
			Speak(cyc,1)
			if promoEffect == 0 {
				charReputation[pChar[v]] += 1
				if charAngerTim[pChar[cyc]][pChar[v]] < 100 do charAngerTim[pChar[cyc]][pChar[v]] = 100
				ChangeRelationship(pChar[cyc],pChar[v],-1)
				pAgenda[cyc] = 4
				pWeapFoc[cyc] = pWeapon[v]
				randy := bb.RndI(0,5)
				if randy == 0 && charRole[pChar[cyc]] < 1 do gamWarrant[slot] = 1
				if randy == 1 && charRole[pChar[cyc]] < 4 && pWeapon[v] > 0 \
				&& gamMission[slot] != 11 && gamMission[slot] != 12 {
					gamWarrant[slot] = 4
					gamItem[slot] = pWeapon[v]
				}
				if randy == 2 && gamWarrant[slot] < 5 && pWeapon[v] > 0 \
				&& weapType[pWeapon[v]] >= 16 && weapType[pWeapon[v]] <= 18 {
					gamWarrant[slot] = 5
				}
				promoEffect = 1
			}
			Outline("Well, that just makes me all the more suspicious!", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("Anything valuable to you is worth confiscating...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoStage >= 2 && promoTim > 625 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = 1
		}
	}
	// 19. NOT INTELLIGENT ENOUGH TO USE COMPUTER
	if gamPromo == 19 {
		if promoTim > 25 && promoTim < 325 {
			Speak(cyc,1)
			Outline("Damn, i wish i was intelligent enough to", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("use this computer! It could come in handy...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 325 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = 1
		}
	}
	// 20. NOT INTELLIGENT ENOUGH TO COOK
	if gamPromo == 20 {
		if promoTim > 25 && promoTim < 325 {
			Speak(cyc,1)
			Outline("Damn, i wish i was intelligent enough to", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("prepare food! It's not as tiring as sweeping...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 325 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = 1
		}
	}
	// 21. NOT INTELLIGENT ENOUGH TO WORK IN STUDY
	if gamPromo == 21 {
		if promoTim > 25 && promoTim < 325 {
			Speak(cyc,1)
			Outline("Damn, i wish i was intelligent enough to arrange", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("these files! It pays better than preparing food...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 325 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = 1
		}
	}
	// 22. NOT INTELLIGENT ENOUGH TO WORK IN MEDICINE
	if gamPromo == 22 {
		if promoTim > 25 && promoTim < 325 {
			Speak(cyc,1)
			Outline("Damn, i wish i was intelligent enough to mix", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("these chemicals! It pays better than filing...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 325 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = 1
		}
	}
	// 23. NOT STRONG ENOUGH TO MAKE WEAPONS
	if gamPromo == 23 {
		if promoTim > 25 && promoTim < 325 {
			Speak(cyc,1)
			Outline("Damn, i wish i was strong enough to", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("make things! This could come in handy...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 325 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = 1
		}
	}
	// 24. LAWYER OFFERS TO REDUCE SENTENCE
	if gamPromo == 24 {
		// intro
		figure := GetFigure(promoCash, context.temp_allocator)
		optionA = fmt.aprint("Yes, pay $", figure, "!")
		optionB = strings.clone("No, forget it...")
		if promoStage == 0 && promoTim < 25 do promoCash = GetPromoMoney(1)
		if promoStage == 0 && promoTim > 25 && promoTim < 325 {
			Speak(cyc,3)
			full_string := fmt.tprint("Hi, ", charName[pChar[v]], ", it's your lawyer speaking.")
			Outline(full_string, i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("I've got some good news about your case!", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoStage == 0 && promoTim > 350 && promoTim < 650 {
			Speak(cyc,3)
			Outline("Some new evidence has cast doubt on your conviction,", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("so we should be able to get your sentence reduced!", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoStage == 0 && promoTim > 675 && promoTim < 975 {
			Speak(cyc,3)
			figure2 := GetFigure(promoCash, context.temp_allocator)
			full_string := fmt.tprint("The only problem is we'll need $", figure2, " to take")
			Outline(full_string, i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("it to court. Do you want to wire me the money?", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoStage == 0 && promoTim > 975 do camFoc = v
		if promoStage == 0 && promoTim > 1000 {
			promoStage = 1
			foc = 1
			keytim = 20
		}
		// responses
		if promoStage == 2 && promoTim > 325 && promoTim < 625 {
			Speak(cyc,3)
			if promoEffect == 0 {
				bb.PlaySound(sCash)
				statTim[6] = 100
				statTim[7] = -50
				gamMoney[slot] -= promoCash
				charSentence[pChar[v]] -= 7
				charHappiness[pChar[v]] += 10
				charReputation[pChar[v]] -= 1
				promoEffect = 1
			}
			Outline("Alright, i'll get onto it immediately! Your", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			figure2 := GetFigure(charSentence[pChar[v]], context.temp_allocator)
			full_string := fmt.tprint("sentence should be down to just ", figure2, " days...")
			Outline(full_string, i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoStage == 3 && promoTim > 325 && promoTim < 625 {
			Speak(cyc,1)
			Outline("Damn, i thought we were onto something here!", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("I guess you don't care about getting out...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoStage >= 2 && promoTim > 625 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = 1
		}
	}
	// 25. TANOY ANNOUNCES LOCK DOWN
	if gamPromo == 25 {
		if promoEffect == 0 {
			ProduceSound(bb.FindChild(world, "Tanoy01"), sTanoy, 22050, 1)
			promoEffect = 1
		}
		if promoTim > 25 && promoTim < 325 {
			Speak(cyc, 2)
			Outline("ATTENTION! The prison is being locked down for the", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("night. All inmates should return to their home cell...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 325 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = 1
		}
	}
	// 26. TANOY ANNOUNCES NEW DAY
	if gamPromo == 26 {
		if promoEffect == 0 {
			ProduceSound(bb.FindChild(world, "Tanoy01"), sTanoy, 22050, 1)
			promoEffect = 1
		}
		if promoTim > 25 && promoTim < 325 {
			Speak(cyc, 2)
			Outline("ATTENTION! Lock down is over. All inmates", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("should wake up and resume their rehabilitation...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 325 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = 1
		}
	}
	// 27. TANOY ANNOUNCES DINNER TIME
	if gamPromo == 27 {
		if promoEffect == 0 {
			ProduceSound(bb.FindChild(world, "Tanoy01"), sTanoy, 22050, 1)
			promoEffect = 1
		}
		if promoTim > 25 && promoTim < 325 {
			Speak(cyc, 2)
			Outline("ATTENTION! Dinner is served in the canteen.", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("Take your seat now to avoid disappointment...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 325 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = 1
		}
	}
	// 28. COURT CASE VICTORY AFTERMATH
	if gamPromo == 28 {
		if promoTim > 25 && promoTim < 325 {
			Speak(cyc, 1)
			full_string := fmt.tprint("Hey, ", CellName(pChar[v], context.temp_allocator), ", we both know that you")
			Outline(full_string, i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("deserved to be crucified by that judge!", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 350 && promoTim < 650 {
			Speak(cyc, 1)
			Outline("There may not be any justice in HIS court", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("room, but there is justice in MY prison!", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 675 && promoTim < 975 {
			Speak(cyc, 1)
			if promoEffect == 0 {
				charHappiness[pChar[v]] -= 5
				charReputation[pChar[v]] += 1
				ChangeRelationship(pChar[cyc], pChar[v], -1)
				if charAngerTim[pChar[cyc]][pChar[v]] < 1000 {
					charAngerTim[pChar[cyc]][pChar[v]] = 1000
				}
				promoEffect = 1
			}
			Outline("For every day you should have been sentenced", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("to, i'm gonna make your life a living hell!", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 975 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = 1
		}
	}
	// 29. COURT CASE FAILURE AFTERMATH
	if gamPromo == 29 {
		if promoTim > 25 && promoTim < 325 {
			Speak(cyc, 2)
			full_string := fmt.tprint("Hey, ", CellName(pChar[v], context.temp_allocator), ", we both know that")
			Outline(full_string, i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("justice was done in that courtroom!", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 350 && promoTim < 650 {
			Speak(cyc, 3)
			if promoEffect == 0 {
				charHappiness[pChar[v]] += 5
				charReputation[pChar[v]] -= 1
				ChangeRelationship(pChar[cyc], pChar[v], 0)
				charAngerTim[pChar[cyc]][pChar[v]] = 0
				promoEffect = 1
			}
			Outline("There's no reason for either of us to hold a grudge,", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("so just toe the line and we won't have a problem...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 650 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = 1
		}
	}
	// 30. TANOY ANNOUNCES NEW ARRIVAL
	if gamPromo == 30 {
		if promoEffect == 0 {
			ProduceSound(bb.FindChild(world, "Tanoy01"), sTanoy, 22050, 1)
			promoEffect = 1
		}
		if promoTim > 25 && promoTim < 325 && charRole[gamArrival[slot]] == 0 {
			Speak(cyc, 2)
			Outline(fmt.tprint("ATTENTION! A new inmate called '", charName[gamArrival[slot]], "'"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline(fmt.tprint("will now occupy Cell ", charCell[gamArrival[slot]], " of the ", textBlock[charBlock[gamArrival[slot]]], " Block..."), i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 25 && promoTim < 325 && charRole[gamArrival[slot]] == 1 {
			Speak(cyc, 2)
			Outline(fmt.tprint("ATTENTION! A new officer called '", charName[gamArrival[slot]], "'"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline(fmt.tprint("will now patrol the ", textLocation[charLocation[gamArrival[slot]]], " area..."), i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 325 && promoTim < 9975 {
			promoTim = 9975
			gamArrival[slot] = 0
		}
	}
	// 31. TANOY ANNOUNCES FATALITY
	if gamPromo == 31 {
		if promoEffect == 0 {
			ProduceSound(bb.FindChild(world, "Tanoy01"), sTanoy, 22050, 1)
			promoEffect = 1
		}
		if promoTim > 25 && promoTim < 9975 {
			ShowPhoto(gamFatality[slot])
			for count in 1..=no_plays {
				if pAnim[count] < 20 do ChangeAnim(i32(count), 131)
			}
		}
		if promoTim > 25 && promoTim < 325 && charRole[gamFatality[slot]] == 0 {
			Speak(cyc, 2)
			Outline(fmt.tprint("ATTENTION! Prisoner ", CellName(gamFatality[slot], context.temp_allocator), ", otherwise known"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline(fmt.tprint("as '", charName[gamFatality[slot]], "', has been found dead!"), i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 25 && promoTim < 325 && charRole[gamFatality[slot]] == 1 {
			Speak(cyc, 2)
			Outline(fmt.tprint("ATTENTION! ", charName[gamFatality[slot]]), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("has been found dead!", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 350 && promoTim < 650 && (gamFatality[slot] == 0 || charAttacker[gamFatality[slot]] == 0 || charWitness[charAttacker[gamFatality[slot]]] == 0) {
			Speak(cyc, 2)
			Outline("Unfortunately, no witnesses have come forward", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("to shed light on the circumstances of his death...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 350 && promoTim < 650 && gamFatality[slot] > 0 && charAttacker[gamFatality[slot]] > 0 && charWitness[charAttacker[gamFatality[slot]]] > 0 {
			Speak(cyc, 2)
			Outline("His untimely death is thought to be related", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline(fmt.tprint("to a dispute with ", charName[charAttacker[gamFatality[slot]]], "..."), i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 675 && promoTim < 975 && charRole[gamFatality[slot]] == 0 {
			Speak(cyc, 2)
			Outline("Our condolences go out to both his friends within the", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("prison and the family that he leaves behind outside...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 675 && promoTim < 975 && charRole[gamFatality[slot]] == 1 {
			Speak(cyc, 2)
			Outline("We at the prison are deeply saddened by his passing,", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("and our condolences go to his family on the outside...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 975 && promoTim < 9975 {
			promoTim = 9975
			gamFatality[slot] = 0
		}
	}
	// 32. TANOY ANNOUNCES RELEASE
	if gamPromo == 32 {
		if promoEffect == 0 {
			ProduceSound(bb.FindChild(world, "Tanoy01"), sTanoy, 22050, 1)
			promoEffect = 1
		}
		if promoTim > 25 && promoTim < 9975 do ShowPhoto(gamRelease[slot])
		if promoTim > 25 && promoTim < 325 {
			Speak(cyc, 2)
			Outline(fmt.tprint("ATTENTION! Prisoner ", CellName(gamRelease[slot], context.temp_allocator), ", otherwise known"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline(fmt.tprint("as '", charName[gamRelease[slot]], "', has been released..."), i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 350 && promoTim < 650 {
			Speak(cyc, 2)
			lower := bb.Lower(textCrime[charCrime[gamRelease[slot]]])
			Outline(fmt.tprint("He served his sentence for ", lower), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("and we now welcome him back into society...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 650 && promoTim < 9975 {
			promoTim = 9975
			gamRelease[slot] = 0
		}
	}
	// 33. INVITED TO JOIN SUNS OF GOD
	if gamPromo == 33 {
		// intro
		optionA = strings.clone("Yes, join gang!")
		optionB = strings.clone("No thanks...")
		if promoStage == 0 && promoTim > 25 && promoTim < 325 {
			Speak(cyc, 2)
			Outline(fmt.tprint("Hey, ", CellName(pChar[v], context.temp_allocator), ", your skin is white"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("but you're not letting it shine bright!", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoStage == 0 && promoTim > 350 && promoTim < 650 {
			Speak(cyc, 3)
			Outline("Why don't you join The Suns Of God and help us", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("purify this place? We could use a guy like you...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoStage == 0 && promoTim > 650 do camFoc = v
		if promoStage == 0 && promoTim > 675 {
			promoStage = 1
			foc = 1
			keytim = 20
		}
		// responses
		if promoStage == 2 && promoTim > 325 && promoTim < 625 {
			Speak(cyc, 3)
			if promoEffect == 0 {
				ChangeGang(pChar[v], 1)
				charHappiness[pChar[v]] += 5
				charReputation[pChar[v]] += 5
				ChangeRelationship(pChar[cyc], pChar[v], 1)
				promoEffect = 1
			}
			Outline("Welcome to the family, brother! Discovering", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("your roots is the first step to growing strong...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoStage == 3 && promoTim > 325 && promoTim < 625 {
			Speak(cyc, 1)
			if promoEffect == 0 {
				charReputation[pChar[v]] -= 1
				AngerGang(pChar[v], charGang[pChar[cyc]])
				promoEffect = 1
			}
			Outline("You're either with us or against us! If you're", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("not part of the solution, you're the problem...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoStage >= 2 && promoTim > 625 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = 1
		}
	}
	// 34. INVITED TO JOIN AVATARS OF ALLAH
	if gamPromo == 34 {
		// intro
		optionA = strings.clone("Yes, join gang!")
		optionB = strings.clone("No thanks...")
		if promoStage == 0 && promoTim > 25 && promoTim < 325 {
			Speak(cyc, 2)
			Outline(fmt.tprint("Hey, ", CellName(pChar[v], context.temp_allocator), ", you've been sent to"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("this prison to serve a greater cause...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoStage == 0 && promoTim > 350 && promoTim < 650 {
			Speak(cyc, 3)
			Outline("Join The Avatars Of Allah and help us wage war", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("on the infidels! We could use a guy like you...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoStage == 0 && promoTim > 650 do camFoc = v
		if promoStage == 0 && promoTim > 675 {
			promoStage = 1
			foc = 1
			keytim = 20
		}
		// responses
		if promoStage == 2 && promoTim > 325 && promoTim < 625 {
			Speak(cyc, 3)
			if promoEffect == 0 {
				ChangeGang(pChar[v], 2)
				charHappiness[pChar[v]] += 5
				charReputation[pChar[v]] += 5
				ChangeRelationship(pChar[cyc], pChar[v], 1)
				promoEffect = 1
			}
			Outline("Welcome to the family, brother! Surrender your", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("life to the cause and justice will be done...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoStage == 3 && promoTim > 325 && promoTim < 625 {
			Speak(cyc, 1)
			if promoEffect == 0 {
				charReputation[pChar[v]] -= 1
				AngerGang(pChar[v], charGang[pChar[cyc]])
				promoEffect = 1
			}
			Outline("You're either with us or against us! If you don't", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("kill the infidels, you'll die alongside them...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoStage >= 2 && promoTim > 625 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = 1
		}
	}
	// 35. INVITED TO JOIN THE DARK SIDE
	if gamPromo == 35 {
		// intro
		optionA = strings.clone("Yes, join gang!")
		optionB = strings.clone("No thanks...")
		if promoStage == 0 && promoTim > 25 && promoTim < 325 {
			Speak(cyc, 2)
			Outline(fmt.tprint("Hey, ", CellName(pChar[v], context.temp_allocator), ", aren't you tired of"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("being judged by the colour of your skin?", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoStage == 0 && promoTim > 350 && promoTim < 650 {
			Speak(cyc, 3)
			Outline("This place is designed to keep the black man down,", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("but join The Dark Side and we can fight back!", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoStage == 0 && promoTim > 650 do camFoc = v
		if promoStage == 0 && promoTim > 675 {
			promoStage = 1
			foc = 1
			keytim = 20
		}
		// responses
		if promoStage == 2 && promoTim > 325 && promoTim < 625 {
			Speak(cyc, 3)
			if promoEffect == 0 {
				ChangeGang(pChar[v], 3)
				charHappiness[pChar[v]] += 5
				charReputation[pChar[v]] += 5
				ChangeRelationship(pChar[cyc], pChar[v], 1)
				promoEffect = 1
			}
			Outline("Welcome to the family, brother! Discovering", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("your roots is the first step to growing strong...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoStage == 3 && promoTim > 325 && promoTim < 625 {
			Speak(cyc, 1)
			if promoEffect == 0 {
				charReputation[pChar[v]] -= 1
				AngerGang(pChar[v], charGang[pChar[cyc]])
				promoEffect = 1
			}
			Outline("You're either with us or against us! If you're", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("not part of the solution, you're the problem...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoStage >= 2 && promoTim > 625 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = 1
		}
	}
	// 36. INVITED TO JOIN POWERS THAT BE
	if gamPromo == 36 {
		// intro
		optionA = strings.clone("Yes, join gang!")
		optionB = strings.clone("No thanks...")
		if promoStage == 0 && promoTim > 25 && promoTim < 325 {
			Speak(cyc, 2)
			Outline(fmt.tprint("Hey, ", CellName(pChar[v], context.temp_allocator), ", haven't you ever heard"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("that the pen is mightier than the sword?", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoStage == 0 && promoTim > 350 && promoTim < 650 {
			Speak(cyc, 3)
			Outline("Knowledge is power, so join The Powers That Be", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("and we can bring down this system from within!", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoStage == 0 && promoTim > 650 do camFoc = v
		if promoStage == 0 && promoTim > 675 {
			promoStage = 1
			foc = 1
			keytim = 20
		}
		// responses
		if promoStage == 2 && promoTim > 325 && promoTim < 625 {
			Speak(cyc, 3)
			if promoEffect == 0 {
				ChangeGang(pChar[v], 4)
				charHappiness[pChar[v]] += 5
				charReputation[pChar[v]] += 5
				ChangeRelationship(pChar[cyc], pChar[v], 1)
				promoEffect = 1
			}
			Outline("Welcome to the family, brother! Discovering", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("your roots is the first step to growing strong...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoStage == 3 && promoTim > 325 && promoTim < 625 {
			Speak(cyc, 1)
			if promoEffect == 0 {
				charReputation[pChar[v]] -= 1
				AngerGang(pChar[v], charGang[pChar[cyc]])
				promoEffect = 1
			}
			Outline("You're either with us or against us! If you're", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("not part of the solution, you're the problem...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoStage >= 2 && promoTim > 625 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = 1
		}
	}
	// 37. INVITED TO JOIN GLADIATORS
	if gamPromo == 37 {
		// intro
		optionA = strings.clone("Yes, join gang!")
		optionB = strings.clone("No thanks...")
		if promoStage == 0 && promoTim > 25 && promoTim < 325 {
			Speak(cyc, 2)
			Outline(fmt.tprint("Hey, ", CellName(pChar[v], context.temp_allocator), ", i'm sure you know"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("that only the strong survive in here?", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoStage == 0 && promoTim > 350 && promoTim < 650 {
			Speak(cyc, 3)
			Outline("So why not join The Gladiators and fight alongside", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("your fellow athletes? We could use a guy like you...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoStage == 0 && promoTim > 650 do camFoc = v
		if promoStage == 0 && promoTim > 675 {
			promoStage = 1
			foc = 1
			keytim = 20
		}
		// responses
		if promoStage == 2 && promoTim > 325 && promoTim < 625 {
			Speak(cyc, 3)
			if promoEffect == 0 {
				ChangeGang(pChar[v], 5)
				charHappiness[pChar[v]] += 5
				charReputation[pChar[v]] += 5
				ChangeRelationship(pChar[cyc], pChar[v], 1)
				promoEffect = 1
			}
			Outline("Welcome to the team, soldier! Wear the ink", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("with pride and we'll always have your back...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoStage == 3 && promoTim > 325 && promoTim < 625 {
			Speak(cyc, 1)
			if promoEffect == 0 {
				charReputation[pChar[v]] -= 1
				AngerGang(pChar[v], charGang[pChar[cyc]])
				promoEffect = 1
			}
			Outline("You're either with us or against us - and this is", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("one wall you really don't want to come up against!", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoStage >= 2 && promoTim > 625 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = 1
		}
	}
	// 38. INVITED TO JOIN THE PEAKS
	if gamPromo == 38 {
		// intro
		optionA = strings.clone("Yes, join gang!")
		optionB = strings.clone("No thanks...")
		if promoStage == 0 && promoTim > 25 && promoTim < 325 {
			Speak(cyc, 2)
			Outline(fmt.tprint("Hey, ", CellName(pChar[v], context.temp_allocator), ", don't forget that the"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("point of prison is to better yourself...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoStage == 0 && promoTim > 350 && promoTim < 650 {
			Speak(cyc, 3)
			Outline("Join The Peaks and we'll guide you to your", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("highest self! You'll be out before you know it...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoStage == 0 && promoTim > 650 do camFoc = v
		if promoStage == 0 && promoTim > 675 {
			promoStage = 1
			foc = 1
			keytim = 20
		}
		// responses
		if promoStage == 2 && promoTim > 325 && promoTim < 625 {
			Speak(cyc, 3)
			if promoEffect == 0 {
				ChangeGang(pChar[v], 6)
				charHappiness[pChar[v]] += 5
				charReputation[pChar[v]] -= 1
				ChangeRelationship(pChar[cyc], pChar[v], 1)
				promoEffect = 1
			}
			Outline("Welcome to the family, brother! We don't offer", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("an easy life, but it will be a meaningful one...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoStage == 3 && promoTim > 325 && promoTim < 625 {
			Speak(cyc, 2)
			Outline("That's your choice, but do remember that those", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("who live by the sword will die by the same fate...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoStage >= 2 && promoTim > 625 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = 1
		}
	}
	// 39. CONFRONTED ABOUT ATTACKING GANG MEMBER
	if gamPromo == 39 {
		if promoTim > 25 && promoTim < 325 {
			Speak(cyc, 1)
			Outline(fmt.tprint("Hey, ", charName[pChar[v]], ", watch who you mess with!"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline(fmt.tprint(charName[charPromoRef[pChar[cyc]]], " is a member of ", textGang[charGang[pChar[cyc]]], "..."), i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 350 && promoTim < 650 {
			Speak(cyc, 1)
			if promoEffect == 0 {
				charHappiness[pChar[v]] -= 5
				charReputation[pChar[v]] += 1
				AngerGang(pChar[v], charGang[pChar[cyc]])
				pAgenda[cyc] = 2
				pFollowFoc[cyc] = v
				pSubX[cyc] = 9999
				pSubZ[cyc] = 9999
				promoEffect = 1
			}
			Outline("An attack on one of us is an attack on the", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("whole crew, so pick your battles carefully!", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 650 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = 1
		}
	}
	// 40. ASSAULTED RIVAL GANG MEMBER
	if gamPromo == 40 {
		if promoTim > 25 && promoTim < 325 {
			Speak(cyc, 1)
			Outline("Hey, do you know who you're messing with?!", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline(fmt.tprint("I'm a member of ", textGang[charGang[pChar[cyc]]], "..."), i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 350 && promoTim < 650 {
			Speak(cyc, 1)
			if promoEffect == 0 {
				charHappiness[pChar[v]] -= 5
				charReputation[pChar[v]] += 1
				AngerGang(pChar[v], charGang[pChar[cyc]])
				promoEffect = 1
			}
			Outline("This ink means something! One word from me", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("and the whole crew will be on your back...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 650 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = 1
		}
	}
	// 41. ASSAULTED FELLOW GANG MEMBER
	if gamPromo == 41 {
		if promoTim > 25 && promoTim < 325 {
			Speak(cyc, 1)
			Outline(fmt.tprint("Hey, ", charName[pChar[v]], ", why are you attacking"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline(fmt.tprint("a fellow member of ", textGang[charGang[pChar[cyc]]], "?!"), i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 350 && promoTim < 650 {
			Speak(cyc, 1)
			if promoEffect == 0 {
				charGang[pChar[v]] = 0
				GangAdjust(pChar[v])
				ApplyCostume(v)
				charHappiness[pChar[v]] -= 5
				charReputation[pChar[v]] -= 1
				AngerGang(pChar[v], charGang[pChar[cyc]])
				promoEffect = 1
			}
			Outline("The last thing a crew needs is civil war!", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("A traitor doesn't deserve to wear that ink...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 650 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = 1
		}
	}
	// 42. DEFECTED FROM GANG
	if gamPromo == 42 {
		if promoTim > 25 && promoTim < 325 && charGang[pChar[v]] == 0 {
			Speak(cyc, 1)
			Outline(fmt.tprint("Hey, ", charName[pChar[v]], ", how could you turn"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline(fmt.tprint("your back on ", textGang[charGang[pChar[cyc]]], "?!"), i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 25 && promoTim < 325 && charGang[pChar[v]] > 0 {
			Speak(cyc, 1)
			Outline(fmt.tprint("Hey, ", charName[pChar[v]], ", how could you turn your back"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline(fmt.tprint("on ", textGang[charGang[pChar[cyc]]], " to join ", textGang[charGang[pChar[v]]], "?!"), i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 350 && promoTim < 650 {
			Speak(cyc, 1)
			if promoEffect == 0 {
				charHappiness[pChar[v]] -= 5
				charReputation[pChar[v]] -= 1
				AngerGang(pChar[v], charGang[pChar[cyc]])
				promoEffect = 1
			}
			Outline("Don't you know the only way out is DEATH?", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("You soon will when the others hear about this!", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 650 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = 1
			RemovePromo(gamPromo)
		}
	}
	// 43. FORGIVE UNPROVOKED ATTACK
	if gamPromo == 43 {
		if promoTim > 25 && promoTim < 325 {
			Speak(cyc, 3)
			Outline("Brother, what hurts you so much that you", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("feel you need to hurt me to heal it?", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 350 && promoTim < 650 {
			Speak(cyc, 2)
			if promoEffect == 0 {
				charHappiness[pChar[v]] -= 5
				charReputation[pChar[v]] -= 1
				ChangeRelationship(pChar[cyc], pChar[v], 1)
				promoEffect = 1
			}
			Outline("Come, you will find that the respect of these", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("men isn't worth sacrificing your soul for...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 650 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = 1
		}
	}
	// 44. FORGIVEN FOR STEALING
	if gamPromo == 44 {
		if promoTim > 25 && promoTim < 325 {
			Speak(cyc, 3)
			Outline("Brother, what is it you're hoping to attain?", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			lower_name := strings.to_lower(weapName[weapType[pWeapon[v]]], context.temp_allocator)
			Outline(fmt.tprint("Will that ", lower_name, " really bring you happiness?"), i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 350 && promoTim < 650 {
			Speak(cyc, 2)
			if promoEffect == 0 {
				charHappiness[pChar[v]] -= 5
				charReputation[pChar[v]] -= 1
				ChangeRelationship(pChar[cyc], pChar[v], 1)
				promoEffect = 1
			}
			Outline("Detach yourself from these possessions, and you", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("will discover that what matters can never be lost...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 650 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = 1
		}
	}
	// 45. FORMER GANG MEMBER ASKS YOU TO LEAVE TOO
	if gamPromo == 45 {
		// intro
		optionA = strings.clone("Yes, leave gang...")
		optionB = strings.clone("No, forget it!")
		if promoStage == 0 && promoTim > 25 && promoTim < 325 {
			Speak(cyc, 2)
			Outline(fmt.tprint("Hey, ", charName[pChar[v]], ", i thought you should"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline(fmt.tprint("know that i've left ", textGang[charGang[pChar[v]]], "!"), i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoStage == 0 && promoTim > 350 && promoTim < 650 {
			Speak(cyc, 3)
			Outline("Why don't you leave before it's too late?", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("They'll only use you to do their dirty work!", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoStage == 0 && promoTim > 650 do camFoc = v
		if promoStage == 0 && promoTim > 675 {
			promoStage = 1
			foc = 1
			keytim = 20
		}
		// responses
		if promoStage == 2 && promoTim > 325 && promoTim < 625 {
			Speak(cyc, 3)
			if promoEffect == 0 {
				ChangeGang(pChar[v], 0)
				charHappiness[pChar[v]] -= 5
				charReputation[pChar[v]] -= 1
				ChangeRelationship(pChar[cyc], pChar[v], 1)
				promoEffect = 1
			}
			Outline("Good for you! They're gonna come after us when", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("they hear about this, but we'll survive together...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoStage == 3 && promoTim > 325 && promoTim < 625 {
			Speak(cyc, 1)
			if promoEffect == 0 {
				charReputation[pChar[v]] += 1
				DamageRelationship(pChar[cyc], pChar[v], -1)
				promoEffect = 1
			}
			Outline("In that case, we can no longer be friends!", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline(fmt.tprint("I want nothing to do with ", textGang[charGang[pChar[v]]], "..."), i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoStage >= 2 && promoTim > 625 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = 1
		}
	}
	// 46. FRIEND JOINS A GANG
	if gamPromo == 46 {
		// intro
		optionA = strings.clone("Yes, join gang!")
		optionB = strings.clone("No thanks...")
		if promoStage == 0 && promoTim > 25 && promoTim < 325 {
			Speak(cyc, 2)
			Outline(fmt.tprint("Hey, ", charName[pChar[v]], ", you're now looking"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline(fmt.tprint("at a member of ", textGang[charGang[pChar[cyc]]], "!"), i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoStage == 0 && promoTim > 350 && promoTim < 650 {
			Speak(cyc, 3)
			Outline("Do you want me to get you into the gang too?", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("Their support can make life easier in here!", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoStage == 0 && promoTim > 650 do camFoc = v
		if promoStage == 0 && promoTim > 675 {
			promoStage = 1
			foc = 1
			keytim = 20
		}
		// responses
		if promoStage == 2 && promoTim > 325 && promoTim < 625 {
			Speak(cyc, 3)
			if promoEffect == 0 {
				ChangeGang(pChar[v], charGang[pChar[cyc]])
				charHappiness[pChar[v]] += 5
				charReputation[pChar[v]] += 5
				ChangeRelationship(pChar[cyc], pChar[v], 1)
				promoEffect = 1
			}
			Outline("Welcome to the family, brother! Trust me, it's", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("much better to be with us than against us...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoStage == 3 && promoTim > 325 && promoTim < 625 {
			Speak(cyc, 1)
			if promoEffect == 0 {
				charReputation[pChar[v]] -= 1
				DamageRelationship(pChar[cyc], pChar[v], -1)
				promoEffect = 1
			}
			Outline("In that case, we can no longer be friends!", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline(fmt.tprint("My loyalties lie with ", textGang[charGang[pChar[cyc]]], "..."), i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoStage >= 2 && promoTim > 625 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = 1
		}
	}
	// 47. NEW MEMBER OF YOUR GANG
	if gamPromo == 47 {
		if promoTim > 25 && promoTim < 325 {
			Speak(cyc, 3)
			Outline(fmt.tprint("Hey, ", charName[pChar[v]], ", i'm now a member"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline(fmt.tprint("of ", textGang[charGang[pChar[v]]], " as well!"), i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 350 && promoTim < 650 {
			Speak(cyc, 3)
			if promoEffect == 0 {
				charHappiness[pChar[v]] += 5
				ChangeRelationship(pChar[cyc], pChar[v], 1)
				promoEffect = 1
			}
			Outline("It's great to be onboard! I hope we can", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("work together to rule this place...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 650 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = 1
		}
	}
	// 48. INMATE ASKS TO BUY ITEM
	if gamPromo == 48 {
		// intro
		optionA = strings.clone(fmt.tprint("Yes, accept $", promoCash, "!"))
		optionB = strings.clone("No sale...")
		if promoStage == 0 && promoTim < 25 {
			promoVariable = pWeapon[v]
			promoCash = bb.RndI(weapValue[weapType[promoVariable]] / 2, weapValue[weapType[promoVariable]] + (weapValue[weapType[promoVariable]] / 2))
		}
		if promoStage == 0 && promoTim > 325 do camFoc = v
		if promoStage == 0 && promoTim > 350 {
			promoStage = 1
			foc = 1
			keytim = 20
		}
		// responses
		if promoStage == 2 && promoTim > 325 && promoTim < 625 {
			Speak(cyc, 3)
			if promoEffect == 0 {
				bb.PlaySound(sCash)
				statTim[7] = 50
				gamMoney[slot] += promoCash
				charHappiness[pChar[v]] += 5
				charReputation[pChar[v]] += 1
				ChangeRelationship(pChar[cyc], pChar[v], 1)
				promoEffect = 1
			}
			Outline("Great! This should come in handy.", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("Maybe we'll do business again some time...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoStage == 3 && promoTim > 325 && promoTim < 625 {
			Speak(cyc, 1)
			if promoEffect == 0 {
				if charAngerTim[pChar[cyc]][pChar[v]] < 100 do charAngerTim[pChar[cyc]][pChar[v]] = 100
				ChangeRelationship(pChar[cyc], pChar[v], -1)
				pAgenda[cyc] = 4
				pWeapFoc[cyc] = promoVariable
				promoEffect = 1
			}
			Outline("Fine! If you won't sell it, i'll have to take it!", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("Assholes like you deserve to be robbed...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoStage >= 2 && promoTim > 625 && promoTim < 9975 {
			promoTim = 9975
		}
	}
	// 49. INMATE TRIES TO SELL ITEM
	if gamPromo == 49 {
		// intro
		optionA = strings.clone(fmt.tprint("Yes, pay $", promoCash, "!"))
		optionB = strings.clone("No thanks...")
		if promoStage == 0 && promoTim < 25 {
			promoVariable = pWeapon[cyc]
			promoCash = bb.RndI(weapValue[weapType[promoVariable]] / 2, weapValue[weapType[promoVariable]] + (weapValue[weapType[promoVariable]] / 2))
			if promoCash > gamMoney[slot] do promoCash = gamMoney[slot]
		}
		if promoStage == 0 && promoTim > 25 && promoTim < 325 {
			Speak(cyc, 2)
			Outline(fmt.tprint("Hey, ", charName[pChar[v]], ", would you be interested"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline(fmt.tprint("in buying this ", strings.to_lower(weapName[weapType[promoVariable]], context.temp_allocator), " for $", promoCash, "?"), i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoStage == 0 && promoTim > 325 do camFoc = v
		if promoStage == 0 && promoTim > 350 {
			promoStage = 1
			foc = 1
			keytim = 20
		}
		// responses
		if promoStage == 2 && promoTim > 325 && promoTim < 625 {
			Speak(cyc, 3)
			if promoEffect == 0 {
				bb.PlaySound(sCash)
				statTim[7] = -50
				gamMoney[slot] -= promoCash
				charHappiness[pChar[v]] += 5
				charReputation[pChar[v]] += 1
				ChangeRelationship(pChar[cyc], pChar[v], 1)
				promoEffect = 1
			}
			Outline("Good for you! I hope you enjoy it.", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("Maybe we'll do business again some time...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoStage == 3 && promoTim > 325 && promoTim < 625 {
			Speak(cyc, 1)
			if promoEffect == 0 {
				DamageRelationship(pChar[cyc], pChar[v], -1)
				promoEffect = 1
			}
			Outline("Hey, it's your choice! But don't come crying", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("to me the next time you need something...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoStage >= 2 && promoTim > 625 && promoTim < 9975 {
			promoTim = 9975
		}
	}
	// 50. FRIEND OFFERS ITEM
	if gamPromo == 50 {
		// intro
		optionA = strings.clone("Yes, accept item!")
		optionB = strings.clone("No thanks...")
		if promoStage == 0 && promoTim > 25 && promoTim < 325 {
			Speak(cyc, 3)
			Outline(fmt.tprint("Hey, ", charName[pChar[v]], ", do you want this ", strings.to_lower(weapName[weapType[pWeapon[cyc]]], context.temp_allocator), "?"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("I don't need it anymore, so it's up for grabs...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoStage == 0 && promoTim > 325 do camFoc = v
		if promoStage == 0 && promoTim > 350 {
			promoStage = 1
			foc = 1
			keytim = 20
		}
		// responses
		if promoStage == 2 && promoTim > 325 && promoTim < 625 {
			Speak(cyc, 3)
			if promoEffect == 0 {
				charHappiness[pChar[v]] += 5
				ChangeRelationship(pChar[cyc], pChar[v], 1)
				promoEffect = 1
			}
			Outline("Consider it yours, my friend! I hope you", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("get as much use out of it as i did...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoStage == 3 && promoTim > 325 && promoTim < 625 {
			Speak(cyc, 1)
			if promoEffect == 0 {
				DamageRelationship(pChar[cyc], pChar[v], -1)
				promoEffect = 1
			}
			Outline("Hey, i was just trying to make your life easier!", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("Maybe somebody else in here will appreciate it...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoStage >= 2 && promoTim > 625 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = 1
		}
	}
	// 51. WARDEN ASKS YOU TO LEAVE GANG
	if gamPromo == 51 {
		// intro
		optionA = strings.clone("Yes, leave gang...")
		optionB = strings.clone("No, forget it!")
		if promoStage == 0 && promoTim > 25 && promoTim < 325 {
			Speak(cyc, 2)
			Outline(fmt.tprint("Hey, ", CellName(pChar[v], context.temp_allocator), ", let me see those tattoos!"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline(fmt.tprint("Are you a member of ", textGang[charGang[pChar[v]]], "?"), i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoStage == 0 && promoTim > 350 && promoTim < 650 {
			Speak(cyc, 1)
			Outline("We're cracking down on that gang, so give", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("them up or we'll make an example out of you!", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoStage == 0 && promoTim > 650 do camFoc = v
		if promoStage == 0 && promoTim > 675 {
			promoStage = 1
			foc = 1
			keytim = 20
		}
		// responses
		if promoStage == 2 && promoTim > 325 && promoTim < 625 {
			Speak(cyc, 3)
			if promoEffect == 0 {
				ChangeGang(pChar[v], 0)
				charHappiness[pChar[v]] -= 5
				charReputation[pChar[v]] -= 1
				ChangeRelationship(pChar[cyc], pChar[v], 1)
				promoEffect = 1
			}
			Outline("Good for you! Those guys never cared about you.", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("They just wanted someone to do their dirty work...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoStage == 3 && promoTim > 325 && promoTim < 625 {
			Speak(cyc, 1)
			if promoEffect == 0 {
				charReputation[pChar[v]] += 1
				ChangeRelationship(pChar[cyc], pChar[v], -1)
				randy := bb.RndI(0, 2)
				if randy == 0 && gamWarrant[slot] < 2 do gamWarrant[slot] = 2
				promoEffect = 1
			}
			Outline("You're willing to take the heat for those assholes?!", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("Perhaps you need reminding who runs this place...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoStage >= 2 && promoTim > 625 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = 1
		}
	}
	// 52. WARDEN OFFERS TO OVERLOOK CRIME
	if gamPromo == 52 {
		// intro
		optionA = strings.clone(fmt.tprint("Yes, pay $", promoCash, "..."))
		optionB = strings.clone("No, i don't care!")
		if promoStage == 0 && promoTim < 25 {
			promoCash = gamWarrant[slot] * 50
			if promoCash < 50 do promoCash = 50
			promoCash = RoundOff(promoCash, 10)
			if promoCash > gamMoney[slot] do promoCash = gamMoney[slot]
		}
		if promoStage == 0 && promoTim > 25 && promoTim < 325 {
			Speak(cyc, 1)
			Outline(fmt.tprint("Hey, ", CellName(pChar[v], context.temp_allocator), ", i'm supposed to"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline(fmt.tprint("take you in for ", strings.to_lower(textWarrant[gamWarrant[slot]], context.temp_allocator), "..."), i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoStage == 0 && promoTim > 350 && promoTim < 650 {
			Speak(cyc, 2)
			Outline("Fortunately for you, i'm feeling generous!", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline(fmt.tprint("Slip me $", promoCash, " and i'll drop the charges?"), i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoStage == 0 && promoTim > 650 do camFoc = v
		if promoStage == 0 && promoTim > 675 {
			promoStage = 1
			foc = 1
			keytim = 20
		}
		// responses
		if promoStage == 2 && promoTim > 325 && promoTim < 625 {
			Speak(cyc, 3)
			if promoEffect == 0 {
				bb.PlaySound(sCash)
				statTim[7] = -50
				gamMoney[slot] -= promoCash
				charHappiness[pChar[v]] += 5
				charReputation[pChar[v]] -= 1
				DamageRelationship(pChar[cyc], pChar[v], 1)
				for count in 1..=no_plays {
					if charRole[pChar[count]] == 1 {
						pAgenda[count] = 1
						pNowhere[count] = 99
						charAngerTim[pChar[count]][pChar[v]] = 0
					}
				}
				if bb.ChannelPlaying(chAlarm) > 0 do bb.StopChannel(chAlarm)
				gamWarrant[slot] = 0
				promoEffect = 1
			}
			Outline("It seems you're not the man we're looking for!", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("I can't even remember what the crime was now...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoStage == 3 && promoTim > 325 && promoTim < 625 {
			Speak(cyc, 1)
			if promoEffect == 0 {
				DamageRelationship(pChar[cyc], pChar[v], -1)
				promoEffect = 1
			}
			Outline("Fine! If you won't accept my help, all that", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("remains is to drag you before the judge...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoStage >= 2 && promoTim > 625 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = 1
		}
	}
	// 53. CARRYING ITEM IN WORKSHOP
	if gamPromo == 53 {
		// intro
		optionA = strings.clone("Yes, drop item...")
		optionB = strings.clone("No, it's mine!")
		if promoStage == 0 && promoTim > 25 && promoTim < 325 {
			Speak(cyc, 1)
			promoVariable = weapType[pWeapon[v]]
			Outline(fmt.tprint("Hey, ", CellName(pChar[v], context.temp_allocator), ", stop where you are! What"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline(fmt.tprint("are you doing with that ", strings.to_lower(weapName[promoVariable], context.temp_allocator), "?"), i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoStage == 0 && promoTim > 350 && promoTim < 650 {
			Speak(cyc, 1)
			Outline("This is where you get paid for making items -", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("not taking them! Put that back where it belongs...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
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
			Outline(fmt.tprint("That's right. Step away from the ", strings.to_lower(weapName[promoVariable], context.temp_allocator)), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("and we won't have to take this any further...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoStage == 3 && promoTim > 325 && promoTim < 625 {
			Speak(cyc, 1)
			if promoEffect == 0 {
				charReputation[pChar[v]] += 1
				if charAngerTim[pChar[cyc]][pChar[v]] < 100 do charAngerTim[pChar[cyc]][pChar[v]] = 100
				promoEffect = 1
				pAgenda[cyc] = 1
				pFollowFoc[cyc] = v
				randy := bb.RndI(0, 5)
				if randy == 0 && gamWarrant[slot] < 1 do gamWarrant[slot] = 1
				if pWeapon[v] > 0 && gamMission[slot] != 11 && gamMission[slot] != 12 {
					if randy == 1 && gamWarrant[slot] < 4 {
						gamWarrant[slot] = 4
						gamItem[slot] = pWeapon[v]
					}
					if randy == 2 && gamWarrant[slot] < 7 {
						gamWarrant[slot] = 7
						gamItem[slot] = pWeapon[v]
					}
				}
				promoEffect = 1
			}
			Outline("You morons never know when to quit! You could", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("have earned, but now i'm gonna make you pay...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoStage >= 2 && promoTim > 625 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = 1
		}
	}
	// 54. ANGRY ABOUT MUTILATION
	if gamPromo == 54 {
		if promoTim > 25 && promoTim < 325 {
			Speak(cyc, 1)
			Outline(fmt.tprint("Hey, ", charName[pChar[v]], ", look what you've done!"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("I'll be scarred for life because of you!", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 350 && promoTim < 650 {
			Speak(cyc, 1)
			if promoEffect == 0 {
				charHappiness[pChar[v]] -= 1
				charReputation[pChar[v]] += 1
				charAngerTim[pChar[cyc]][pChar[v]] = 100000
				ChangeRelationship(pChar[cyc], pChar[v], -1)
				promoEffect = 1
			}
			Outline("I'm never gonna forgive your for this!", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("I won't stop until you feel the same pain...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 650 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = 1
		}
	}
	// 55. WITNESS BLACKMAILS YOU
	if gamPromo == 55 {
		// intro
		figure := GetFigure(promoCash, context.temp_allocator)
		optionA = strings.clone(fmt.tprint("Yes, pay $", figure, "..."))
		optionB = strings.clone("No, i don't care!")
		if promoStage == 0 && promoTim < 25 do promoCash = GetPromoMoney(1)
		if promoStage == 0 && promoTim > 25 && promoTim < 325 {
			Speak(cyc, 1)
			Outline(fmt.tprint("Hey, ", charName[pChar[v]], ", i saw what you did!"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("I could send you down for a long time...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoStage == 0 && promoTim > 350 && promoTim < 650 {
			Speak(cyc, 2)
			figure2 := GetFigure(promoCash, context.temp_allocator)
			Outline("Fortunately for you, i'm a compassionate man and", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline(fmt.tprint("may be willing to forget what i saw for $", figure2, "?"), i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoStage == 0 && promoTim > 650 do camFoc = v
		if promoStage == 0 && promoTim > 675 {
			promoStage = 1
			foc = 1
			keytim = 20
		}
		// responses
		if promoStage == 2 && promoTim > 325 && promoTim < 625 {
			Speak(cyc, 3)
			if promoEffect == 0 {
				MakeDeal(cyc, v)
				bb.PlaySound(sCash)
				statTim[7] = -50
				gamMoney[slot] -= promoCash
				charHappiness[pChar[v]] += 5
				charReputation[pChar[v]] -= 1
				DamageRelationship(pChar[cyc], pChar[v], 1)
				charWitness[pChar[v]] = 0
				gamWarrant[slot] = 0
				if bb.ChannelPlaying(chAlarm) > 0 do bb.StopChannel(chAlarm)
				promoEffect = 1
			}
			Outline("Turns out i didn't see anything after all!", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("I guess the wardens just lost their case...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoStage == 3 && promoTim > 325 && promoTim < 625 {
			Speak(cyc, 1)
			if promoEffect == 0 {
				ChangeRelationship(pChar[cyc], pChar[v], -1)
				promoEffect = 1
			}
			Outline("Fine, have it your way! When the wardens hear my", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("version of the story they'll throw away the key...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoStage >= 2 && promoTim > 625 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = 1
		}
	}
	// 56. INMATE OFFERS TO TAKE BLAME
	if gamPromo == 56 {
		// intro
		figure := GetFigure(promoCash, context.temp_allocator)
		optionA = strings.clone(fmt.tprint("Yes, pay $", figure, "..."))
		optionB = strings.clone("No, i don't care!")
		if promoStage == 0 && promoTim < 25 do promoCash = GetPromoMoney(1)
		if promoStage == 0 && promoTim > 25 && promoTim < 325 {
			Speak(cyc, 1)
			Outline(fmt.tprint("Hey, ", charName[pChar[v]], ", what have you been up to?"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline(fmt.tprint("Word is you're wanted for ", strings.to_lower(textWarrant[gamWarrant[slot]], context.temp_allocator), "!"), i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoStage == 0 && promoTim > 350 && promoTim < 650 {
			Speak(cyc, 2)
			figure2 := GetFigure(promoCash, context.temp_allocator)
			Outline("Fortunately for you, i need money - and may be", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline(fmt.tprint("willing to take the blame if you pay me $", figure2, "?"), i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoStage == 0 && promoTim > 650 do camFoc = v
		if promoStage == 0 && promoTim > 675 {
			promoStage = 1
			foc = 1
			keytim = 20
		}
		// responses
		if promoStage == 2 && promoTim > 325 && promoTim < 625 {
			Speak(cyc, 3)
			if promoEffect == 0 {
				MakeDeal(cyc, v)
				bb.PlaySound(sCash)
				statTim[7] = -50
				gamMoney[slot] -= promoCash
				charHappiness[pChar[v]] += 5
				charReputation[pChar[v]] -= 1
				ChangeRelationship(pChar[cyc], pChar[v], 1)
				for count in 1..=no_plays {
					if charRole[pChar[count]] == 1 {
						charAngerTim[pChar[count]][pChar[cyc]] = 1000
						pAgenda[count] = 2
						pFollowFoc[count] = cyc
					}
				}
				charSentence[pChar[cyc]] += 180
				charWitness[pChar[v]] = 0
				gamWarrant[slot] = 0
				if bb.ChannelPlaying(chAlarm) > 0 do bb.StopChannel(chAlarm)
				promoEffect = 1
			}
			Outline("This should ease the pain when i take the heat!", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("I'm never getting out, so i might as well profit...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoStage == 3 && promoTim > 325 && promoTim < 625 {
			Speak(cyc, 1)
			if promoEffect == 0 {
				ChangeRelationship(pChar[cyc], pChar[v], -1)
				pAgenda[cyc] = 2
				pFollowFoc[cyc] = v
				promoEffect = 1
			}
			Outline("Fine, have it your way! I'll take the side", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("of the wardens and make sure you go down...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoStage >= 2 && promoTim > 625 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = 1
		}
	}
	// 57. INMATE ASKS YOU TO TAKE BLAME
	if gamPromo == 57 {
		// intro
		figure := GetFigure(promoCash, context.temp_allocator)
		optionA = strings.clone(fmt.tprint("Yes, accept $", figure, "!"))
		optionB = strings.clone("No thanks...")
		if promoStage == 0 && promoTim < 25 {
			promoVariable = bb.RndI(1, 14)
			promoCash = bb.RndI(promoVariable * 50, promoVariable * 100)
			promoCash = RoundOff(promoCash, 50)
		}
		if promoStage == 0 && promoTim > 25 && promoTim < 325 {
			Speak(cyc, 3)
			Outline(fmt.tprint("Hey, ", charName[pChar[v]], ", you've got to help me!"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline(fmt.tprint("The wardens want me for ", strings.to_lower(textWarrant[promoVariable], context.temp_allocator), "!"), i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoStage == 0 && promoTim > 350 && promoTim < 650 {
			Speak(cyc, 3)
			figure2 := GetFigure(promoCash, context.temp_allocator)
			Outline("Take the heat for me and i won't forget it!", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline(fmt.tprint("I'll even pay you $", figure2, " for your trouble?"), i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoStage == 0 && promoTim > 650 do camFoc = v
		if promoStage == 0 && promoTim > 675 {
			promoStage = 1
			foc = 1
			keytim = 20
		}
		// responses
		if promoStage == 2 && promoTim > 325 && promoTim < 625 {
			Speak(cyc, 3)
			if promoEffect == 0 {
				MakeDeal(cyc, v)
				bb.PlaySound(sCash)
				statTim[7] = 50
				gamMoney[slot] += promoCash
				charHappiness[pChar[v]] -= 5
				charReputation[pChar[v]] += 5
				ChangeRelationship(pChar[cyc], pChar[v], 1)
				gamWarrant[slot] = promoVariable
				gamVictim[slot] = bb.RndI(1, no_chars)
				if gamMission[slot] != 11 && gamMission[slot] != 12 do gamItem[slot] = bb.RndI(1, no_weaps)
				promoEffect = 1
			}
			Outline("Thanks, you just saved my life! Here's your money.", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("Having a friend like you will be worth every penny...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoStage == 3 && promoTim > 325 && promoTim < 625 {
			Speak(cyc, 1)
			if promoEffect == 0 {
				DamageRelationship(pChar[cyc], pChar[v], -1)
				charReputation[pChar[v]] -= 1
				for count in 1..=no_plays {
					if charRole[pChar[count]] == 1 {
						charAngerTim[pChar[count]][pChar[cyc]] = 1000
						pAgenda[count] = 2
						pFollowFoc[count] = cyc
					}
				}
				promoEffect = 1
			}
			figure2 := GetFigure(promoCash, context.temp_allocator)
			Outline(fmt.tprint("You're turning down $", figure2, " to tell a few lies?!"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("Don't come to me the next time you need a favour...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoStage >= 2 && promoTim > 625 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = 1
		}
	}
	// 58. WARDEN THREATENS TO MAKE UP CHARGE
	if gamPromo == 58 {
		// intro
		figure := GetFigure(promoCash, context.temp_allocator)
		optionA = strings.clone(fmt.tprint("Yes, pay $", figure, "..."))
		optionB = strings.clone("No, do your worst!")
		if promoStage == 0 && promoTim < 25 do promoCash = GetPromoMoney(1)
		if promoStage == 0 && promoTim > 25 && promoTim < 325 {
			Speak(cyc, 2)
			Outline(fmt.tprint("You know, ", CellName(pChar[v], context.temp_allocator), ", being a warden is a very"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("respectable job. People believe whatever you say!", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoStage == 0 && promoTim > 350 && promoTim < 650 {
			Speak(cyc, 1)
			Outline("For instance, i don't have to SEE you morons", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("committing a crime - all i have to do is SAY it!", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoStage == 0 && promoTim > 675 && promoTim < 975 {
			Speak(cyc, 1)
			figure = GetFigure(promoCash, context.temp_allocator)
			Outline(fmt.tprint("Give me $", figure, " or i'll give you an example!"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("I could have you before a judge right now...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoStage == 0 && promoTim > 975 do camFoc = v
		if promoStage == 0 && promoTim > 1000 {
			promoStage = 1
			foc = 1
			keytim = 20
		}
		// responses
		if promoStage == 2 && promoTim > 325 && promoTim < 625 {
			Speak(cyc, 2)
			if promoEffect == 0 {
				MakeDeal(cyc, v)
				bb.PlaySound(sCash)
				statTim[7] = -50
				gamMoney[slot] -= promoCash
				charHappiness[pChar[v]] -= 5
				charReputation[pChar[v]] -= 1
				promoEffect = 1
			}
			Outline("A wise choice! It would have been a shame", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("if you ruined your life for no reason...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoStage == 3 && promoTim > 325 && promoTim < 625 {
			Speak(cyc, 1)
			if promoEffect == 0 {
				charHappiness[pChar[v]] /= 2
				charReputation[pChar[v]] += 1
				ChangeRelationship(pChar[cyc], pChar[v], -1)
				gamWarrant[slot] = bb.RndI(1, 14)
				gamVictim[slot] = bb.RndI(1, no_chars)
				if gamMission[slot] != 11 && gamMission[slot] != 12 do gamItem[slot] = bb.RndI(1, no_weaps)
				promoEffect = 1
			}
			Outline("Wrong move! It turns out you're wanted for", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			warrantText := strings.to_lower(textWarrant[gamWarrant[slot]], context.temp_allocator)
			Outline(fmt.tprint(warrantText, "! I'll have to take you in..."), i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoStage >= 2 && promoTim > 625 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = 1
		}
	}
	// 59. WARDEN AKS YOU TO GIVE YOURSELF IN
	if gamPromo == 59 {
		if promoTim > 25 && promoTim < 325 {
			Speak(cyc, 1)
			warrantText := strings.to_lower(textWarrant[gamWarrant[slot]], context.temp_allocator)
			Outline(fmt.tprint("You're wanted for ", warrantText, ", ", CellName(pChar[v], context.temp_allocator), "!"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("It's only a matter of time before we catch you...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 350 && promoTim < 650 {
			Speak(cyc, 2)
			Outline("Give yourself up! The sooner you face the charges,", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("the sooner you can get on with your rehabilitation...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 650 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = 1
		}
	}
	// 60. TIME TO GO
	if gamPromo == 60 {
		// intro
		optionA = strings.clone("Yes, let me go!")
		optionB = strings.clone("No, not yet...")
		if promoStage == 0 && promoTim > 25 && promoTim < 325 {
			Speak(cyc, 3)
			Outline(fmt.tprint("You've served your sentence, ", CellName(pChar[v], context.temp_allocator), "!"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("Would you like me to escort you outside?", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoStage == 0 && promoTim > 325 do camFoc = v
		if promoStage == 0 && promoTim > 350 {
			promoStage = 1
			foc = 1
			keytim = 20
		}
		// responses
		if promoStage == 2 && promoTim > 325 && promoTim < 625 {
			Speak(cyc, 3)
			Outline("OK, you're a free man now so i wish you luck!", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("We'll keep you posted on what happens in here...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoStage == 3 && promoTim > 325 && promoTim < 625 {
			Speak(cyc, 2)
			Outline("Alright, i'll give you some time to say goodbye.", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("You'll have to leave this place eventually though...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoStage >= 2 && promoTim > 625 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = 1
		}
	}
	// 61. LOSE WEIGHT
	if gamPromo == 61 {
		if promoTim < 100 && pAnim[cyc] < 20 do ChangeAnim(cyc, 130)
		if promoTim > 25 && promoTim < 325 {
			Speak(cyc, 3)
			if promoEffect == 0 {
				pHealth[cyc] += 5
				charStrength[pChar[cyc]] -= 5
				charAgility[pChar[cyc]] += 5
				charHappiness[pChar[cyc]] += 5
				gamGrowth[slot] = 0
				promoEffect = 1
			}
			Outline("Whoa, i think i've lost some weight!", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("I certainly feel lighter on my feet...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 325 && promoTim < 9975 do promoTim = 9975 //; promoUsed[gamPromo] = 1
	}
	// 62. GAIN WEIGHT
	if gamPromo == 62 {
		if promoTim < 100 && pAnim[cyc] < 20 do ChangeAnim(cyc, 130)
		if promoTim > 25 && promoTim < 325 {
			Speak(cyc, 3)
			if promoEffect == 0 {
				if charModel[pChar[cyc]] <= 3 {
					pHealth[cyc] += 5
				} else {
					pHealth[cyc] -= 5
				}
				charStrength[pChar[cyc]] += 5
				charAgility[pChar[cyc]] -= 5
				if charModel[pChar[cyc]] <= 3 {
					charHappiness[pChar[cyc]] += 5
				} else {
					charHappiness[pChar[cyc]] -= 5
				}
				gamGrowth[slot] = 0
				promoEffect = 1
			}
			Outline("Whoa, i think i've gained some weight!", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("I certainly feel a lot more powerful...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 325 && promoTim < 9975 do promoTim = 9975 //; promoUsed[gamPromo] = 1
	}
	// 63. WRONG NUMBER
	if gamPromo == 63 {
		if promoTim < 25 {
			for {
				promoVariable = bb.RndI(1, no_chars)
				if promoVariable != gamChar[slot] do break
			}
		}
		if promoTim > 25 && promoTim < 325 {
			Speak(cyc, 3)
			Outline("Hello? Who's that?! Sorry, i was hoping to", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline(fmt.tprint("speak to somebody called '", charName[promoVariable], "'..."), i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 325 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = 1
		}
	}
	// 64. SOCIAL CALL
	if gamPromo == 64 {
		if promoTim > 25 && promoTim < 325 {
			Speak(cyc, 3)
			Outline(fmt.tprint("Hi, ", charName[gamChar[slot]], ", how are you holding up?"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("I was just calling to check you're alright!", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 350 && promoTim < 650 {
			Speak(cyc, 3)
			if promoEffect == 0 {
				charHappiness[pChar[v]] += 5
				promoEffect = 1
			}
			Outline("We all miss you back to home, and we hope", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("you get out soon! Keep your head up, friend...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 650 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = 1
		}
	}
	// 65. FAMILY CALL
	if gamPromo == 65 {
		if promoTim > 25 && promoTim < 325 {
			Speak(cyc, 3)
			Outline("Hi, darling, it's your wife here. We miss you!", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("I thought you might like to talk to the kids?", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 325 do camFoc = v
		if promoTim > 350 && promoTim < 650 {
			Speak(v, 3)
			Outline("Hi, kids! I know you wish i was home, but", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("daddy has got some important work to do...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 675 && promoTim < 975 {
			Speak(v, 3)
			if promoEffect == 0 {
				charHappiness[pChar[v]] += 5
				promoEffect = 1
			}
			Outline("I'm a 'secret agent' like we saw on TV!", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("Be good while i'm saving the world! Bye...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 975 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = 1
		}
	}
	// 66. LAWYER OFFERS TO SHAVE A DAY OFF
	if gamPromo == 66 {
		// intro
		figure := GetFigure(promoCash, context.temp_allocator)
		optionA = strings.clone(fmt.tprint("Yes, pay $", figure, "!"))
		optionB = strings.clone("No, forget it...")
		if promoStage == 0 && promoTim < 25 do promoCash = GetPromoMoney(2)
		if promoStage == 0 && promoTim > 25 && promoTim < 325 {
			Speak(cyc, 3)
			Outline(fmt.tprint("Hi, ", charName[pChar[v]], ", it's your lawyer speaking."), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("I've got some good news about your case!", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoStage == 0 && promoTim > 350 && promoTim < 650 {
			Speak(cyc, 3)
			Outline("One of those idiots messed up your paperwork,", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("so we should be able to claim back a day!", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoStage == 0 && promoTim > 675 && promoTim < 975 {
			Speak(cyc, 3)
			Outline(fmt.tprint("The only problem is we'll need $", figure, " to file"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("an appeal. Do you want to wire me the money?", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoStage == 0 && promoTim > 975 do camFoc = v
		if promoStage == 0 && promoTim > 1000 {
			promoStage = 1
			foc = 1
			keytim = 20
		}
		// responses
		if promoStage == 2 && promoTim > 325 && promoTim < 625 {
			Speak(cyc, 3)
			if promoEffect == 0 {
				bb.PlaySound(sCash)
				statTim[6] = 100
				statTim[7] = -50
				gamMoney[slot] -= promoCash
				charSentence[pChar[v]] -= 1
				charHappiness[pChar[v]] += 5
				promoEffect = 1
			}
			Outline("Alright, i'll get onto it immediately! Your", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			figure2 := GetFigure(charSentence[pChar[v]], context.temp_allocator)
			Outline(fmt.tprint("sentence should be down to just ", strings.to_lower(figure2, context.temp_allocator), " days..."), i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoStage == 3 && promoTim > 325 && promoTim < 625 {
			Speak(cyc, 1)
			Outline("Damn, i thought we were onto something here!", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("I guess you don't care about getting out...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoStage >= 2 && promoTim > 625 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = 1
		}
	}
	// 67. GANG REDUCES YOUR SENTENCE
	if gamPromo == 67 {
		if promoTim > 25 && promoTim < 325 {
			Speak(cyc, 3)
			Outline(fmt.tprint("Hey, ", charName[gamChar[slot]], ", i hear you're doing a good"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline(fmt.tprint("job of representing ", textGang[charGang[gamChar[slot]]], " in there?"), i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 350 && promoTim < 650 {
			Speak(cyc, 3)
			Outline("I want you out of prison as soon as possible", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("so that i can put you to work on the street!", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 675 && promoTim < 975 {
			Speak(cyc, 3)
			if promoEffect == 0 {
				charSentence[pChar[v]] -= 1
				statTim[6] = 100
				charHappiness[pChar[v]] += 5
				charReputation[pChar[v]] += 1
				promoEffect = 1
			}
			Outline("I'll pull some strings with the wardens and", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("try to get some time shaved off your sentence...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 650 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = 1
		}
	}
	// 68. SELL STORY TO JOURNALIST
	if gamPromo == 68 {
		// intro
		figure := GetFigure(promoCash, context.temp_allocator)
		optionA = strings.clone(fmt.tprint("Yes, accept $", figure, "!"))
		optionB = strings.clone("No thanks...")
		if promoStage == 0 && promoTim < 25 {
			promoCash = bb.RndI(10, 100)
			promoCash *= 10
		}
		if promoStage == 0 && promoTim > 25 && promoTim < 325 {
			Speak(cyc, 3)
			Outline("Listen, i'm a journalist and i'm trying to put", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("together a piece about life inside prison...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoStage == 0 && promoTim > 350 && promoTim < 650 {
			Speak(cyc, 3)
			Outline("I'd love to hear about your experiences! Would", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline(fmt.tprint("you be willing to share your story for $", figure, "?"), i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoStage == 0 && promoTim > 650 do camFoc = v
		if promoStage == 0 && promoTim > 675 {
			promoStage = 1
			foc = 1
			keytim = 20
		}
		// responses
		if promoStage == 2 && promoTim > 325 && promoTim < 625 {
			Speak(cyc, 3)
			if promoEffect == 0 {
				bb.PlaySound(sCash)
				statTim[7] = 50
				gamMoney[slot] += promoCash
				charHappiness[pChar[v]] += 5
				charReputation[pChar[v]] -= 1
				nearest := NearestEnemy(v)
				if InProximity(v, nearest, 50) != 0 && charPromo[pChar[nearest]][pChar[v]] == 0 do charPromo[pChar[nearest]][pChar[v]] = 70
				promoEffect = 1
			}
			Outline("Thanks for taking part! I'm sure the public", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("will be fascinated by what you have to say...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoStage == 3 && promoTim > 325 && promoTim < 625 {
			Speak(cyc, 1)
			Outline(fmt.tprint("You're turning down $", figure, " to talk to me?!"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("No one cares what you morons have to say anyway...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoStage >= 2 && promoTim > 625 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = -1
		}
	}
	// 69. SELL MOVIE RIGHTS




	

	mem.end_arena_temp_memory(checkpoint)
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

CellName :: proc(location: i32, allocator: mem.Allocator) -> string {
	return ""
}

DamageRelationship :: proc(cyc, v, damage: i32) {
	
}

ShowPhoto :: proc(char: i32) {
	
}

AngerGang :: proc(char, gang: i32) {
	
}

RemovePromo :: proc(sus: i32) {
	
}