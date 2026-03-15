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
	y: f32 = 60
	if gamPromo > 0 {
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
	if gamPromo == 69 {
		// intro
		figure := GetFigure(promoCash, context.temp_allocator)
		optionA = strings.clone(fmt.tprint("Yes, accept $", figure, "!"))
		optionB = strings.clone("No thanks...")
		if promoStage == 0 && promoTim < 25 {
			promoCash = bb.RndI(10, 100)
			promoCash = promoCash * 10
		}
		if promoStage == 0 && promoTim > 25 && promoTim < 325 {
			Speak(cyc, 3)
			Outline("Listen, i'm a filmmaker and i'd like to make a", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("project about the rise and fall of a criminal!", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoStage == 0 && promoTim > 350 && promoTim < 650 {
			Speak(cyc, 3)
			Outline("Would you be interested in taking part if", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline(fmt.tprint("i paid $", figure, " for the rights to your story?"), i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
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
				if cast(bool)InProximity(v, nearest, 50) && charPromo[pChar[nearest]][pChar[v]] == 0 {
					charPromo[pChar[nearest]][pChar[v]] = 70
				}
				promoEffect = 1
			}
			Outline("Thanks for taking part! I'm sure the public", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("will be fascinated by your life story...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoStage == 3 && promoTim > 325 && promoTim < 625 {
			Speak(cyc, 1)
			Outline(fmt.tprint("You're turning down $", figure, " to become a star?!"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("No one cares about your pathetic life anyway...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoStage >= 2 && promoTim > 625 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = -1
		}
	}
	// 70. SNITCH FOR SELLING STORY
	if gamPromo == 70 {
		if promoTim > 25 && promoTim < 325 {
			Speak(cyc, 1)
			if promoEffect == 0 {
				charHappiness[pChar[v]] -= 5
				charReputation[pChar[v]] -= 1
				ChangeRelationship(pChar[cyc], pChar[v], -1)
				promoEffect = 1
			}
			Outline("I hope the money was worth it, you rat!", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("Nobody around here will trust you again...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 325 && promoTim < 9975 do promoTim = 9975
	}
	// 71. INITIATED AT MAIN HALL
	if gamPromo == 71 {
		if promoTim > 25 && promoTim < 325 {
			Speak(cyc, 2)
			Outline(fmt.tprint("Alright, ", charName[pChar[v]], ", that's you processed!"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline(fmt.tprint("You're now known as Prisoner ", CellName(pChar[v], context.temp_allocator), "..."), i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 350 && promoTim < 650 {
			Speak(cyc, 3)
			Outline(fmt.tprint("That means you're in Cell ", charCell[pChar[v]], " of the ", textBlock[charBlock[pChar[v]]], " Block,"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("so head over there and make yourself at home...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 650 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = -1
		}
	}
	// 72. CAUGHT USING ITEM AS WEAPON
	if gamPromo == 72 {
		// intro
		optionA = strings.clone("Yes, drop item...")
		optionB = strings.clone("No, it's mine!")
		if promoStage == 0 && promoTim > 25 && promoTim < 325 {
			Speak(cyc, 1)
			promoVariable = weapType[pWeapon[v]]
			Outline(fmt.tprint("Hey, ", CellName(pChar[v], context.temp_allocator), ", i saw what you did to"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline(fmt.tprint(charName[charPromoRef[pChar[cyc]]], " with that ", strings.to_lower(weapName[promoVariable], context.temp_allocator), "!"), i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoStage == 0 && promoTim > 350 && promoTim < 650 {
			Speak(cyc, 1)
			Outline("You shouldn't be fighting at all - let alone with", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("weapons! Put that down or there'll be trouble...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
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
				ChangeRelationship(pChar[cyc], pChar[v], -1)
				pAgenda[cyc] = 2
				pFollowFoc[cyc] = v
				randy := bb.RndI(0, 5)
				if randy == 0 && gamWarrant[slot] < 1 do gamWarrant[slot] = 1
				if randy == 1 && gamWarrant[slot] < 4 && pWeapon[v] > 0 && gamMission[slot] != 11 && gamMission[slot] != 12 {
					gamWarrant[slot] = 4
					gamItem[slot] = pWeapon[v]
				}
				if randy == 2 && gamWarrant[slot] < 10 && pWeapon[v] > 0 {
					gamWarrant[slot] = 10
					gamItem[slot] = pWeapon[v]
				}
				promoEffect = 1
			}
			Outline(fmt.tprint("You think i'm scared of a ", strings.to_lower(weapName[promoVariable], context.temp_allocator), "?"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("I'll take it and shove it up your ass!", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoStage >= 2 && promoTim > 625 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = 1
			promoUsed[1] = 1
			promoUsed[18] = 1
			promoUsed[53] = 1
		}
	}
	// 73. GUARD OFFERS IMMUNITY
	if gamPromo == 73 {
		// intro
		figure := GetFigure(promoCash, context.temp_allocator)
		optionA = strings.clone(fmt.tprint("Yes, pay $", figure, "!"))
		optionB = strings.clone("No thanks...")
		if promoStage == 0 && promoTim < 25 do promoCash = GetPromoMoney(1)
		if promoStage == 0 && promoTim > 25 && promoTim < 325 {
			Speak(cyc, 2)
			Outline(fmt.tprint("Listen, ", CellName(pChar[v], context.temp_allocator), ", i understand that a prisoner"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("needs to do his dirt to survive in here...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoStage == 0 && promoTim > 350 && promoTim < 650 {
			Speak(cyc, 3)
			Outline(fmt.tprint("That's why i'd like to help! Give me $", figure), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("and i'll cut you some slack for an hour or so?", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
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
				charReputation[pChar[v]] += 1
				ChangeRelationship(pChar[cyc], pChar[v], 1)
				charBribeTim[pChar[cyc]] = 5000
				promoEffect = 1
			}
			Outline("Thanks! This should buy you a little breathing", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("space. Just stay away from the other wardens...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoStage == 3 && promoTim > 325 && promoTim < 625 {
			Speak(cyc, 1)
			if promoEffect == 0 {
				ChangeRelationship(pChar[cyc], pChar[v], -1)
				promoEffect = 1
			}
			Outline("In that case, i'll ride you harder than ever!", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("It's better to be with me than against me...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoStage >= 2 && promoTim > 625 && promoTim < 9975 do promoTim = 9975
	}
	// 74. INMATE OFFERS PROTECTION
	if gamPromo == 74 {
		// intro
		figure := GetFigure(promoCash, context.temp_allocator)
		optionA = strings.clone(fmt.tprint("Yes, pay $", figure, "!"))
		optionB = strings.clone("No thanks...")
		if promoStage == 0 && promoTim < 25 do promoCash = GetPromoMoney(2)
		if promoStage == 0 && promoTim > 25 && promoTim < 325 {
			Speak(cyc, 2)
			Outline(fmt.tprint("Prison can be a cold place, ", charName[pChar[v]], "!"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("You need somebody to look out for you...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoStage == 0 && promoTim > 350 && promoTim < 650 {
			Speak(cyc, 3)
			Outline(fmt.tprint("I can offer that protection! Give me $", figure), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("and i'll watch your back for an hour or so?", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
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
				charFollowTim[pChar[cyc]] = 5000
				charBribeTim[pChar[cyc]] = charFollowTim[pChar[cyc]]
				promoEffect = 1
			}
			Outline("Thanks! This should buy you some peace of mind.", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("Do your thing and leave the worrying to me...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoStage == 3 && promoTim > 325 && promoTim < 625 {
			Speak(cyc, 1)
			if promoEffect == 0 {
				DamageRelationship(pChar[cyc], pChar[v], -1)
				promoEffect = 1
			}
			Outline("Fine, then add me to your list of enemies!", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("I guess you just can't help some people...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoStage >= 2 && promoTim > 625 && promoTim < 9975 do promoTim = 9975
	}
	// 75. TIME UP ON IMMUNITY
	if gamPromo == 75 {
		if promoTim > 25 && promoTim < 325 {
			Speak(cyc, 3)
			charBribeTim[pChar[cyc]] = 0
			Outline(fmt.tprint("Time's up, ", CellName(pChar[v], context.temp_allocator), "! I have to get back to work,"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("so don't step out of line from now on...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 325 && promoTim < 9975 {
			promoTim = 9975
			// promoUsed[gamPromo] = 1
		}
	}
	// 76. TIME UP ON PROTECTION
	if gamPromo == 76 {
		if promoTim > 25 && promoTim < 325 {
			Speak(cyc, 3)
			pAgenda[cyc] = 1
			pNowhere[cyc] = 99
			charFollowTim[pChar[cyc]] = 0
			charBribeTim[pChar[cyc]] = 0
			Outline(fmt.tprint("I've got to go now, ", charName[pChar[v]], ", but"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("maybe we'll do business again some time...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 325 && promoTim < 9975 {
			promoTim = 9975
			// promoUsed[gamPromo] = 1
		}
	}
	// 77. FRIEND COMES TO AID
	if gamPromo == 77 {
		if promoTim > 25 && promoTim < 325 {
			Speak(cyc, 1)
			if promoEffect == 0 {
				charHappiness[pChar[v]] += 5
				charReputation[pChar[v]] -= 1
				if charAngerTim[pChar[cyc]][charPromoRef[pChar[cyc]]] < 1000 do charAngerTim[pChar[cyc]][charPromoRef[pChar[cyc]]] = 1000
				ChangeRelationship(pChar[cyc], pChar[v], 1)
				promoEffect = 1
			}
			Outline(fmt.tprint("Don't worry, ", charName[pChar[v]], "! I'm gonna get"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline(fmt.tprint(charName[charPromoRef[pChar[cyc]]], " for what he did to you..."), i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 325 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = 1
		}
	}
	// 78. THANKED FOR INTERVENING
	if gamPromo == 78 {
		if promoTim > 25 && promoTim < 325 {
			Speak(cyc, 3)
			if promoEffect == 0 {
				charHappiness[pChar[v]] += 5
				charReputation[pChar[v]] += 1
				ChangeRelationship(pChar[cyc], pChar[v], 1)
				ChangeRelationship(pChar[cyc], charPromoRef[pChar[cyc]], -1)
				promoEffect = 1
			}
			Outline(fmt.tprint("Thanks for helping me out, ", charName[pChar[v]], "!"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline(fmt.tprint(charName[charPromoRef[pChar[cyc]]], " needs to be taught a lesson..."), i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 325 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = 1
		}
	}
	// 79. UNGRATEFUL FOR INTERVENING
	if gamPromo == 79 {
		if promoTim > 25 && promoTim < 325 {
			Speak(cyc, 1)
			if promoEffect == 0 {
				charHappiness[pChar[v]] -= 1
				charReputation[pChar[v]] += 1
				ChangeRelationship(pChar[cyc], pChar[v], -1)
				ChangeRelationship(pChar[cyc], charPromoRef[pChar[cyc]], -1)
				promoEffect = 1
			}
			Outline(fmt.tprint("Stay out of my business, ", charName[pChar[v]], "!"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline(fmt.tprint("I can handle a punk like ", charName[charPromoRef[pChar[cyc]]], "..."), i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 325 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = 1
		}
	}
	// 80. FALL OUT AFTER HITTING FRIEND
	if gamPromo == 80 {
		if promoTim > 25 && promoTim < 325 {
			Speak(cyc, 1)
			if promoEffect == 0 {
				charHappiness[pChar[v]] -= 1
				charReputation[pChar[v]] += 1
				DamageRelationship(pChar[cyc], pChar[v], -1)
				promoEffect = 1
			}
			Outline(fmt.tprint("Hey, ", charName[pChar[v]], ", what's your problem?!"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("I thought we were friends, but i guess not...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 325 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = 1
		}
	}
	// 81. PAY SOMEBODY TO ATTACK ENEMY
	if gamPromo == 81 {
		// intro
		figure := GetFigure(promoCash, context.temp_allocator)
		optionA = strings.clone(fmt.tprint("Yes, pay $", figure, "!"))
		optionB = strings.clone("No thanks...")
		if promoStage <= 1 && promoTim > 25 do ShowPhoto(charPromoRef[pChar[cyc]])
		if promoStage == 0 && promoTim < 25 do promoCash = GetPromoMoney(2)
		if promoStage == 0 && promoTim > 25 && promoTim < 325 {
			Speak(cyc, 2)
			Outline(fmt.tprint("Hey, ", charName[pChar[v]], ", i hear you've been"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline(fmt.tprint("having trouble with ", charName[charPromoRef[pChar[cyc]]], "?"), i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoStage == 0 && promoTim > 350 && promoTim < 650 {
			Speak(cyc, 3)
			Outline("I can take care of him if you want? Just give", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			figure2 := GetFigure(promoCash, context.temp_allocator)
			Outline(fmt.tprint("me $", figure2, " and he'll never bother you again!"), i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
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
				charReputation[pChar[v]] += 1
				charHappiness[pChar[v]] += 5
				ChangeRelationship(pChar[cyc], pChar[v], 1)
				ChangeRelationship(pChar[cyc], charPromoRef[pChar[cyc]], -1)
				charAngerTim[pChar[cyc]][charPromoRef[pChar[cyc]]] = 10000
				for count in 1..=no_plays {
					if pChar[count] == charPromoRef[pChar[cyc]] {
						pAgenda[cyc] = 2
						pFollowFoc[cyc] = count
					}
				}
				promoEffect = 1
			}
			Outline("Consider it done! As soon as i see that", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("asshole, he'll wish he'd never been born...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoStage == 3 && promoTim > 325 && promoTim < 625 {
			Speak(cyc, 1)
			if promoEffect == 0 {
				charReputation[pChar[v]] -= 1
				DamageRelationship(pChar[cyc], pChar[v], -1)
				if charAngerTim[pChar[cyc]][pChar[v]] < 100 do charAngerTim[pChar[cyc]][pChar[v]] = 100
				promoEffect = 1
			}
			Outline("Maybe it's YOU that deserves a beating!", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline(fmt.tprint(charName[charPromoRef[pChar[cyc]]], " would pay to see that..."), i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoStage >= 2 && promoTim > 625 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = 1
		}
	}
	// 82. CONFRONTED ABOUT KILLING FRIEND
	if gamPromo == 82 {
		if promoTim >= 25 && promoTim < 9975 do ShowPhoto(charPromoRef[pChar[cyc]])
		if promoTim > 25 && promoTim < 325 {
			Speak(cyc, 1)
			Outline(fmt.tprint("Hey, ", charName[pChar[v]], ", i know that you were"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline(fmt.tprint("responsible for ", charName[charPromoRef[pChar[cyc]]], "'s death!"), i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 350 && promoTim < 650 {
			Speak(cyc, 1)
			if promoEffect == 0 {
				charHappiness[pChar[v]] -= 5
				charReputation[pChar[v]] += 1
				charAngerTim[pChar[cyc]][pChar[v]] = 100000
				ChangeRelationship(pChar[cyc], pChar[v], -1)
				promoEffect = 1
			}
			Outline("He was a dear friend of mine, and i won't", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("rest until you pay for what you've done!", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 650 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = 1
		}
	}
	// 83. CONGRATULATED FOR KILLING ENEMY
	if gamPromo == 83 {
		if promoTim > 25 && promoTim < 325 {
			Speak(cyc, 3)
			ShowPhoto(charPromoRef[pChar[cyc]])
			if promoEffect == 0 {
				charHappiness[pChar[v]] += 5
				charReputation[pChar[v]] += 1
				ChangeRelationship(pChar[cyc], pChar[v], 1)
				promoEffect = 1
			}
			Outline(fmt.tprint("Hey, ", charName[pChar[v]], ", thanks for getting rid"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline(fmt.tprint("of ", charName[charPromoRef[pChar[cyc]]], "! I wish i'd done it myself..."), i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 325 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = 1
		}
	}
	// 84. FRIEND LIKES YOU BY ASSOCIATION
	if gamPromo == 84 {
		if promoTim >= 25 && promoTim < 9975 do ShowPhoto(charPromoRef[pChar[cyc]])
		if promoTim > 25 && promoTim < 325 {
			Speak(cyc, 3)
			Outline(fmt.tprint("Hey, ", charName[pChar[v]], ", i hear you're friends with"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline(fmt.tprint(charName[charPromoRef[pChar[cyc]]], "? Me too, so it's nice to meet you!"), i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 350 && promoTim < 650 {
			Speak(cyc, 3)
			if promoEffect == 0 {
				charHappiness[pChar[v]] += 5
				charReputation[pChar[v]] += 1
				ChangeRelationship(pChar[cyc], pChar[v], 1)
				promoEffect = 1
			}
			Outline("Any friend of his is a friend of mine,", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("so let me know if you ever need a favour...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 650 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = 1
		}
	}
	// 85. ENEMY HATES YOU BY ASSOCIATION
	if gamPromo == 85 {
		if promoTim >= 25 && promoTim < 9975 do ShowPhoto(charPromoRef[pChar[cyc]])
		if promoTim > 25 && promoTim < 325 {
			Speak(cyc, 1)
			Outline(fmt.tprint("Hey, ", charName[pChar[v]], ", i hear you've got a problem"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline(fmt.tprint("with ", charName[charPromoRef[pChar[cyc]]], "? Well, he's a friend of mine!"), i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 350 && promoTim < 650 {
			Speak(cyc, 1)
			if promoEffect == 0 {
				charHappiness[pChar[v]] -= 5
				charReputation[pChar[v]] += 1
				ChangeRelationship(pChar[cyc], pChar[v], -1)
				if charAngerTim[pChar[cyc]][pChar[v]] < 100 do charAngerTim[pChar[cyc]][pChar[v]] = 100
				promoEffect = 1
			}
			Outline("If he doesn't like you, i don't like you", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("either - so you better watch your back!", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 650 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = 1
		}
	}
	// 86. ASKED TO GIVE UP FRIEND
	if gamPromo == 86 {
		// intro
		optionA = strings.clone("Yes, give up friend...")
		optionB = strings.clone("No, forget it!")
		if promoStage <= 1 && promoTim > 25 do ShowPhoto(charPromoRef[pChar[cyc]])
		if promoStage == 0 && promoTim > 25 && promoTim < 325 {
			Speak(cyc, 1)
			Outline(fmt.tprint("Hey, ", charName[pChar[v]], ", why do you hang out"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline(fmt.tprint("with an asshole like ", charName[charPromoRef[pChar[cyc]]], "?!"), i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoStage == 0 && promoTim > 350 && promoTim < 650 {
			Speak(cyc, 1)
			Outline("Cut that loser out of your life, or we'll", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("have to assume that you're just as bad!", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
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
				charHappiness[pChar[v]] -= 5
				charReputation[pChar[v]] -= 1
				DamageRelationship(pChar[cyc], pChar[v], 1)
				ChangeRelationship(pChar[v], charPromoRef[pChar[cyc]], -1)
				if charPromo[charPromoRef[pChar[cyc]]][gamChar[slot]] == 0 {
					charPromo[charPromoRef[pChar[cyc]]][gamChar[slot]] = 87
					charPromoRef[charPromoRef[pChar[cyc]]] = pChar[cyc]
				}
				promoEffect = 1
			}
			Outline("A wise choice! It would have been a shame", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("if you ruined your life because of that guy...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoStage == 3 && promoTim > 325 && promoTim < 625 {
			Speak(cyc, 1)
			if promoEffect == 0 {
				charReputation[pChar[v]] += 1
				ChangeRelationship(pChar[cyc], pChar[v], -1)
				if charAngerTim[pChar[cyc]][pChar[v]] < 1000 do charAngerTim[pChar[cyc]][pChar[v]] = 1000
				pAgenda[cyc] = 2
				pFollowFoc[cyc] = v
				promoEffect = 1
			}
			Outline("That tells me everything i need to know about you!", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("If you share his company, you'll share his fate...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoStage >= 2 && promoTim > 625 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = 1
		}
	}
	// 87. CONFRONTED ABOUT BETRAYAL
	if gamPromo == 87 {
		if promoTim > 25 && promoTim < 325 {
			Speak(cyc, 1)
			ShowPhoto(charPromoRef[pChar[cyc]])
			Outline(fmt.tprint("Hey, ", charName[pChar[v]], ", i can't believe that you"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline(fmt.tprint("sold me out to be friends with ", charName[charPromoRef[pChar[cyc]]], "?!"), i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 350 && promoTim < 650 {
			Speak(cyc, 1)
			if promoEffect == 0 {
				charHappiness[pChar[v]] -= 5
				charReputation[pChar[v]] -= 1
				ChangeRelationship(pChar[cyc], pChar[v], -1)
				if charAngerTim[pChar[cyc]][pChar[v]] < 100 do charAngerTim[pChar[cyc]][pChar[v]] = 100
				promoEffect = 1
			}
			Outline("If that's your idea of friendship then i'm", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("glad to have you out of my life, you traitor!", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 650 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = 1
		}
	}
	// 88. REACTION TO GUILTY VERDICT
	if gamPromo == 88 {
		if promoTim > 25 && promoTim < 325 {
			Speak(cyc, 3)
			Outline(fmt.tprint("Don't listen to that judge, ", charName[pChar[v]], "!"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("His 'guilty' verdict makes you innocent to us...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 350 && promoTim < 650 {
			Speak(cyc, 1)
			if promoEffect == 0 {
				charHappiness[pChar[v]] += 5
				charReputation[pChar[v]] += 1
				ChangeRelationship(pChar[cyc], pChar[v], 1)
				promoEffect = 1
			}
			Outline("It's the ones that come back from court without", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("doing their time that you have to be suspicious of...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 650 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = 1
			RemovePromo(gamPromo)
		}
	}
	// 89. REACTION TO INNOCENT VERDICT
	if gamPromo == 89 {
		if promoTim > 25 && promoTim < 325 {
			Speak(cyc, 1)
			Outline(fmt.tprint("You're a snitch, ", charName[pChar[v]], "! Who did you"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("give up to get that judge off your back?!", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 350 && promoTim < 650 {
			Speak(cyc, 1)
			if promoEffect == 0 {
				charHappiness[pChar[v]] -= 5
				charReputation[pChar[v]] -= 1
				ChangeRelationship(pChar[cyc], pChar[v], -1)
				promoEffect = 1
			}
			Outline("When a man comes back from court without getting", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("time, there can only be one explanation for it...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 650 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = 1
			RemovePromo(gamPromo)
		}
	}
	// 90. PEAKS SHUN CRIMINAL
	if gamPromo == 90 {
		if promoTim > 25 && promoTim < 325 {
			Speak(cyc, 1)
			Outline("Your actions have brought shame on us,", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline(fmt.tprint(charName[pChar[v]], ". This is the end for you..."), i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 350 && promoTim < 650 {
			Speak(cyc, 2)
			if promoEffect == 0 {
				ChangeGang(pChar[v], 0)
				charHappiness[pChar[v]] -= 5
				charReputation[pChar[v]] += 1
				DamageRelationship(pChar[cyc], pChar[v], -1)
				promoEffect = 1
			}
			Outline("We wish you luck with your rehabilitation, but", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("i'm afraid it cannot continue under our banner...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 650 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = 1
			RemovePromo(gamPromo)
		}
	}
	// 91. CAUGHT IN FRIEND'S CELL
	if gamPromo == 91 {
		if promoTim >= 25 && promoTim < 9975 do ShowPhoto(charPromoRef[pChar[cyc]])
		if promoTim > 25 && promoTim < 325 {
			Speak(cyc, 1)
			Outline(fmt.tprint("Hey, ", charName[pChar[v]], ", what are you doing"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline(fmt.tprint("in there?! That's ", charName[charPromoRef[pChar[cyc]]], "'s cell..."), i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 350 && promoTim < 650 {
			Speak(cyc, 1)
			if promoEffect == 0 {
				charHappiness[pChar[v]] -= 1
				charReputation[pChar[v]] += 1
				if charAngerTim[pChar[cyc]][pChar[v]] < 100 do charAngerTim[pChar[cyc]][pChar[v]] = 100
				ChangeRelationship(pChar[cyc], pChar[v], -1)
				pAgenda[cyc] = 2
				pFollowFoc[cyc] = v
				pSubX[cyc] = 9999
				pSubZ[cyc] = 9999
				promoEffect = 1
			}
			Outline("He happens to be a friend of mine, so get", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("out before i kick you out on his behalf!", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 650 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = 1
		}
	}
	// 92. INMATE ASKS TO JOIN GANG
	if gamPromo == 92 {
		// intro
		optionA = strings.clone("Yes, recruit member...")
		optionB = strings.clone("No, forget it!")
		if promoStage == 0 && promoTim > 25 && promoTim < 325 {
			Speak(cyc, 3)
			Outline(fmt.tprint("Are you a member of ", textGang[charGang[pChar[v]]], "?"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("I've always wanted to join that gang!", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoStage == 0 && promoTim > 350 && promoTim < 650 {
			Speak(cyc, 3)
			Outline("Do you think you could find a place for me?", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("I'm sure i'd be a great asset to the cause...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
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
				charHappiness[pChar[v]] += 5
				ChangeRelationship(pChar[cyc], pChar[v], 1)
				ChangeGang(pChar[cyc], charGang[pChar[v]])
				for char in 1 ..= no_chars {
					suitable := 1
					if charGang[char] >= 1 && charGang[char] <= 3 && GetRace(pChar[cyc]) + 1 != charGang[char] do suitable = 0
					if charGang[char] == 4 && charIntelligence[pChar[cyc]] < 70 do suitable = 0
					if charGang[char] == 5 && (charStrength[pChar[cyc]] + charAgility[pChar[cyc]] < 140 || charModel[pChar[cyc]] >= 4) do suitable = 0
					if charGang[char] == charGang[pChar[v]] && char != pChar[cyc] && char != pChar[v] && charPromo[char][gamChar[slot]] == 0 {
						if suitable == 0 do charPromo[char][gamChar[slot]] = 264
						if suitable == 1 do charPromo[char][gamChar[slot]] = 265
					}
				}
				promoEffect = 1
			}
			Outline("Great! You won't regret this, i promise!", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline(fmt.tprint("I'll do anything for ", textGang[charGang[pChar[v]]], "..."), i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoStage == 3 && promoTim > 325 && promoTim < 625 {
			Speak(cyc, 1)
			if promoEffect == 0 {
				DamageRelationship(pChar[cyc], pChar[v], -1)
				promoEffect = 1
			}
			Outline("Who wants to join your pathetic club anyway?!", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("Everybody knows you're a laughing stock here...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoStage >= 2 && promoTim > 625 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = 1
		}
	}
	// 93. PAY YOUR WAY INTO GANG
	if gamPromo == 93 {
		// intro
		figure := GetFigure(promoCash, context.temp_allocator)
		optionA = strings.clone(fmt.tprint("Yes, pay $", figure, "!"))
		optionB = strings.clone("No thanks...")
		if promoStage == 0 && promoTim < 25 do promoCash = GetPromoMoney(1)
		if promoStage == 0 && promoTim > 25 && promoTim < 325 {
			Speak(cyc, 2)
			Outline(fmt.tprint("Hey, ", charName[pChar[v]], ", i'm sure you'd like to"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline(fmt.tprint("be a member of ", textGang[charGang[pChar[cyc]]], " like me?"), i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoStage == 0 && promoTim > 350 && promoTim < 650 {
			Speak(cyc, 3)
			Outline("Trouble is there's a strict selection process,", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			figure2 := GetFigure(promoCash, context.temp_allocator)
			Outline(fmt.tprint("but $", figure2, " might tempt me to overlook it?"), i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
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
				ChangeGang(pChar[v], charGang[pChar[cyc]])
				charHappiness[pChar[v]] += 5
				charReputation[pChar[v]] += 5
				ChangeRelationship(pChar[cyc], pChar[v], 1)
				promoEffect = 1
			}
			Outline("Thanks for your generous contribution! I'm", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("sure you'll be a great asset to the gang...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoStage == 3 && promoTim > 325 && promoTim < 625 {
			Speak(cyc, 1)
			if promoEffect == 0 {
				charReputation[pChar[v]] -= 1
				DamageRelationship(pChar[cyc], pChar[v], -1)
				promoEffect = 1
			}
			Outline("You'll never make any progress in here with that", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("attitude! You need to learn to grease the wheels...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoStage >= 2 && promoTim > 625 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = 1
		}
	}
	// 94. GANG REQUIREMENTS
	if gamPromo == 94 {
		if promoTim > 25 && promoTim < 325 {
			Speak(cyc, 2)
			Outline(fmt.tprint("Hey, ", charName[pChar[v]], ", i'm sure you'd like to"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline(fmt.tprint("be a member of ", textGang[charGang[pChar[cyc]]], " like me?"), i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 350 && promoTim < 650 {
			Speak(cyc, 1)
			if promoEffect == 0 {
				charHappiness[pChar[v]] -= 5
				charReputation[pChar[v]] -= 1
				promoEffect = 1
			}
			if charGang[pChar[cyc]] <= 3 {
				Outline("Well, dream on - because you need a tough", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
				Outline("reputation if you want to hang with us!", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
			}
			if charGang[pChar[cyc]] == 4 {
				Outline("Well, dream on - because you need to be", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
				Outline("intelligent if you want to hang with us!", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
			}
			if charGang[pChar[cyc]] == 5 {
				Outline("Well, dream on - because you need to be", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
				Outline("physically fit to keep the pace with us!", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
			}
			if charGang[pChar[cyc]] == 6 {
				Outline("Well, dream on - because your reputation", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
				Outline("is too violent for you to be one of us!", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
			}
		}
		if promoTim > 650 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = 1
		}
	}
	// 95. GANG ASKS YOU TO KICK UP
	if gamPromo == 95 {
		// intro
		figure := GetFigure(promoCash, context.temp_allocator)
		optionA = strings.clone(fmt.tprint("Yes, pay $", figure, "..."))
		optionB = strings.clone("No, it's mine!")
		if promoStage == 0 && promoTim < 25 do promoCash = GetPromoMoney(2)
		if promoStage == 0 && promoTim > 25 && promoTim < 325 {
			Speak(cyc, 1)
			Outline(fmt.tprint("Hey, ", charName[pChar[v]], ", nobody said being a"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline(fmt.tprint("member of ", textGang[charGang[pChar[v]]], " was free!"), i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoStage == 0 && promoTim > 350 && promoTim < 650 {
			Speak(cyc, 1)
			Outline("You need to kick up some of that money you've", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			figure2 := GetFigure(promoCash, context.temp_allocator)
			Outline(fmt.tprint("earned in our name! $", figure2, " should cover it..."), i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
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
				charHappiness[pChar[v]] -= 5
				charReputation[pChar[v]] += 1
				ChangeRelationship(pChar[cyc], pChar[v], 1)
				promoEffect = 1
			}
			Outline(fmt.tprint("You're a good earner, ", charName[pChar[v]], "!"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("Just remember that the family comes first...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoStage == 3 && promoTim > 325 && promoTim < 625 {
			Speak(cyc, 1)
			if promoEffect == 0 {
				ChangeGang(pChar[v], 0)
				charHappiness[pChar[v]] -= 5
				charReputation[pChar[v]] -= 5
				ChangeRelationship(pChar[cyc], pChar[v], -1)
				promoEffect = 1
			}
			Outline("In that case, take your ass somewhere else!", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("We haven't got any room for passengers...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoStage >= 2 && promoTim > 625 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = 1
		}
	}
	// 96. GANG ASKS YOU TO CONFORM
	if gamPromo == 96 {
		// intro
		optionA = strings.clone("Yes, conform to gang...")
		optionB = strings.clone("No, leave me alone!")
		if promoStage == 0 && promoTim > 25 && promoTim < 325 {
			Speak(cyc, 1)
			Outline(fmt.tprint("Hey, ", charName[pChar[v]], ", ", textGang[charGang[pChar[v]]]), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("aren't supposed to dress like that!", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoStage == 0 && promoTim > 350 && promoTim < 650 {
			Speak(cyc, 1)
			Outline("Return to how you were when you joined us,", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("or we'll have to question your loyalty!", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
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
				GangAdjust(pChar[v])
				ApplyCostume(v)
				charHappiness[pChar[v]] -= 5
				charReputation[pChar[v]] += 1
				ChangeRelationship(pChar[cyc], pChar[v], 1)
				promoEffect = 1
			}
			Outline("Good! That looks much better!", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("Now don't let it happen again...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoStage == 3 && promoTim > 325 && promoTim < 625 {
			Speak(cyc, 1)
			if promoEffect == 0 {
				ChangeGang(pChar[v], 0)
				charHappiness[pChar[v]] -= 5
				charReputation[pChar[v]] -= 5
				ChangeRelationship(pChar[cyc], pChar[v], -1)
				promoEffect = 1
			}
			Outline("If you're so ashamed of us then get out!", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("We don't need traitors like you in the gang...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoStage >= 2 && promoTim > 625 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = 1
		}
	}
	// 97. ENEMY ASKS TO BURY THE HATCHET
	if gamPromo == 97 {
		// intro
		optionA = strings.clone("Yes, make friends...")
		optionB = strings.clone("No, forget it!")
		if promoStage == 0 && promoTim > 25 && promoTim < 325 {
			Speak(cyc, 1)
			Outline(fmt.tprint("Listen, ", charName[pChar[v]], ", i know we haven't"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("been seeing eye-to-eye in recent weeks...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoStage == 0 && promoTim > 350 && promoTim < 650 {
			Speak(cyc, 2)
			Outline("Well, i for one am tired of the bickering", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("so what d'you say we put it all behind us?", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
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
				charHappiness[pChar[v]] += 5
				charReputation[pChar[v]] -= 1
				ChangeRelationship(pChar[cyc], pChar[v], 1)
				promoEffect = 1
			}
			Outline("Great! That's one less thing to worry about!", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("You need all the friends you can get in here...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoStage == 3 && promoTim > 325 && promoTim < 625 {
			Speak(cyc, 1)
			if promoEffect == 0 {
				charReputation[pChar[v]] += 1
				ChangeRelationship(pChar[cyc], pChar[v], -1)
				if charAngerTim[pChar[cyc]][pChar[v]] < 100 do charAngerTim[pChar[cyc]][pChar[v]] = 100
				promoEffect = 1
			}
			Outline("Fine! We'll wage war until you stop breathing!", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("You'll learn that pride comes before a fall...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoStage >= 2 && promoTim > 625 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = 1
		}
	}
	// 98. FRIENDLY WELCOME
	if gamPromo == 98 {
		if promoTim > 25 && promoTim < 325 {
			Speak(cyc, 3)
			if charGang[pChar[cyc]] == 0 {
				Outline(fmt.tprint("Welcome to the jungle! My name is ", charName[pChar[cyc]], ","), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
				Outline(fmt.tprint("and i live in Cell ", charCell[pChar[cyc]], " of the ", textBlock[charBlock[pChar[cyc]]], " Block..."), i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
			}
			if charGang[pChar[cyc]] > 0 {
				Outline(fmt.tprint("Welcome to the jungle! I'm ", charName[pChar[cyc]], ","), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
				Outline(fmt.tprint("and i'm a member of ", textGang[charGang[pChar[cyc]]], "..."), i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
			}
		}
		if promoTim > 350 && promoTim < 650 {
			Speak(cyc, 3)
			if promoEffect == 0 {
				charHappiness[pChar[v]] += 5
				ChangeRelationship(pChar[cyc], pChar[v], 1)
				promoEffect = 1
			}
			Outline("Life can be pretty tough inside this place,", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			if charGang[pChar[cyc]] == 0 do Outline("so look me up if you ever need a friend...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
			if charGang[pChar[cyc]] > 0 do Outline("so look us up if you ever need some support...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 650 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = 1
		}
	}
	// 99. NEUTRAL WELCOME
	if gamPromo == 99 {
		if promoTim > 25 && promoTim < 325 {
			Speak(cyc, 2)
			if charGang[pChar[cyc]] == 0 {
				Outline(fmt.tprint("I'm ", charName[pChar[cyc]], " from Cell ", charCell[pChar[cyc]], " of the ", textBlock[charBlock[pChar[cyc]]], " Block."), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
				Outline("Stay out of my way and we won't have a problem...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
			}
			if charGang[pChar[cyc]] > 0 {
				Outline(fmt.tprint("I'm ", charName[pChar[cyc]], " - a member of ", textGang[charGang[pChar[cyc]]], "!"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
				Outline("Stay out of my way and we won't have a problem...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
			}
		}
		if promoTim > 325 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = 1
		}
	}
	// 100. HOSTILE WELCOME
	if gamPromo == 100 {
		if promoTim > 25 && promoTim < 325 {
			Speak(cyc, 1)
			if promoEffect == 0 {
				charHappiness[pChar[v]] -= 5
				ChangeRelationship(pChar[cyc], pChar[v], -1)
				promoEffect = 1
			}
			if charGang[pChar[cyc]] == 0 {
				Outline(fmt.tprint("Watch your back, new boy! I'm ", charName[pChar[cyc]], " from"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
				Outline(fmt.tprint("Cell ", charCell[pChar[cyc]], " of the ", textBlock[charBlock[pChar[cyc]]], " Block and i rule this place..."), i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
			}
			if charGang[pChar[cyc]] > 0 {
				Outline(fmt.tprint("Watch your back, new boy! I'm ", charName[pChar[cyc]], " of"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
				Outline(fmt.tprint(textGang[charGang[pChar[cyc]]], " and we rule this place..."), i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
			}
		}
		if promoTim > 325 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = 1
		}
	}
	// 100-140: CRIME PROMOS
	CrimePromos(cyc, v, y)
	// 140-200: MISSION PROMOS
	MissionPromos(cyc, v, y)
	// 200-300: ADDITIONAL PROMOS
	// 200. FRIENDLY NEW ARRIVAL
	if gamPromo == 200 {
		if promoTim > 25 && promoTim < 325 {
			Speak(cyc, 3)
			if promoEffect == 0 {
				charHappiness[pChar[v]] += 5
				ChangeRelationship(pChar[cyc], pChar[v], 1)
				promoEffect = 1
			}
			Outline(fmt.tprint("Hi, ", charName[pChar[v]], ", my name is ", charName[pChar[cyc]], "."), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("I'm new here, but i hope we can be friends!", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 325 && promoTim < 9975 {
			promoTim = 9975
			// promoUsed[gamPromo] = 1
		}
	}
	// 201. HOSTILE NEW ARRIVAL
	if gamPromo == 201 {
		if promoTim > 25 && promoTim < 325 {
			Speak(cyc, 1)
			if promoEffect == 0 {
				charHappiness[pChar[v]] -= 5
				ChangeRelationship(pChar[cyc], pChar[v], -1)
				promoEffect = 1
			}
			Outline("Hey, there's a new king in town and his name", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline(fmt.tprint("is ", charName[pChar[cyc]], "! Watch your step around me..."), i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 325 && promoTim < 9975 {
			promoTim = 9975
			// promoUsed[gamPromo] = 1
		}
	}
	// 202. FRIENDLY ROOM-MATE
	if gamPromo == 202 {
		if promoTim > 25 && promoTim < 325 {
			Speak(cyc, 3)
			if promoEffect == 0 {
				charHappiness[pChar[v]] += 5
				ChangeRelationship(pChar[cyc], pChar[v], 1)
				promoEffect = 1
			}
			Outline("Well, it looks like we're sharing this cell!", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("Don't worry, i'm sure we'll get along fine...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 325 && promoTim < 9975 {
			promoTim = 9975
			// promoUsed[gamPromo] = 1
		}
	}
	// 203. NEUTRAL ROOM-MATE
	if gamPromo == 203 {
		if promoTim > 25 && promoTim < 325 {
			Speak(cyc, 2)
			Outline("So i guess i've got to share this cell with you?", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("Just stay out of my way and we'll be alright...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 325 && promoTim < 9975 {
			promoTim = 9975
			// promoUsed[gamPromo] = 1
		}
	}
	// 204. HOSTILE ROOM-MATE
	if gamPromo == 204 {
		if promoTim > 25 && promoTim < 325 {
			Speak(cyc, 1)
			if promoEffect == 0 {
				charHappiness[pChar[v]] -= 5
				ChangeRelationship(pChar[cyc], pChar[v], -1)
				promoEffect = 1
			}
			Outline("Damn, i can't believe i have to share a cell!", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("You better stay in the corner and shut up...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 325 && promoTim < 9975 {
			promoTim = 9975
			// promoUsed[gamPromo] = 1
		}
	}
	// 205. NEW CELL
	if gamPromo == 205 {
		if promoTim > 25 && promoTim < 325 {
			Speak(cyc, 1)
			Outline(fmt.tprint("Hey, ", charName[pChar[v]], ", the prison system has been"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("shaken up to stop you getting too comfortable!", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 350 && promoTim < 650 {
			Speak(cyc, 2)
			if promoEffect == 0 {
				AssignCell(gamChar[slot])
				ApplyCostume(v)
				FindCellMates()
				charHappiness[pChar[v]] -= 5
				promoEffect = 1
			}
			Outline(fmt.tprint("You're now in Cell ", charCell[pChar[v]], " of the ", textBlock[charBlock[pChar[v]]], " Block."), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("Head over there and make yourself at home...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 650 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = 1
		}
	}
	// 206. TANOY ANNOUNCES POWER FAILURE!
	if gamPromo == 206 {
		if promoEffect == 0 {
			ProduceSound(bb.FindChild(world, "Tanoy01"), sTanoy, 22050, 1)
			promoEffect = 1
		}
		if promoTim > 25 && promoTim < 325 {
			Speak(cyc, 2)
			Outline("ATTENTION! The prison seems be", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("suffering from a power failure!", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 350 && promoTim < 650 {
			Speak(cyc, 2)
			Outline("Please be patient while the problem", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("is rectified by our technical staff...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 650 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = 1
		}
		gamBlackout[slot] = bb.RndI(1000, 10000)
	}
	// 207. TANOY ANNOUNCES BOMB THREAT!
	if gamPromo == 207 {
		if promoEffect == 0 {
			ProduceSound(bb.FindChild(world, "Tanoy01"), sTanoy, 22050, 1)
			for char in 1 ..= no_chars {
				charHappiness[char] = charHappiness[char] / 2
			}
			promoEffect = 1
		}
		if promoTim > 25 && promoTim < 325 {
			Speak(cyc, 2)
			Outline("ATTENTION! The prison has been", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("targeted for a terrorist attack!", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 350 && promoTim < 650 {
			Speak(cyc, 2)
			Outline("All inmates should find a safe place to", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("hide until the threat has been removed...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 650 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = 1
		}
		gamBombThreat[slot] = bb.RndI(500, 5000)
	}
	// 208. CALLER ISSUES BOMB THREAT!
	if gamPromo == 208 {
		if promoTim > 25 && promoTim < 325 {
			Speak(cyc, 2)
			Outline("YOU'RE ALL GOING TO DIE!!!", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("We've rigged the prison with explosives...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 350 && promoTim < 650 {
			Speak(cyc, 2)
			if promoEffect == 0 {
				charHappiness[gamChar[slot]] /= 2
				promoEffect = 1
			}
			Outline("Run for your life like a coward - or accept", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("that your blood will be spilt for the cause!", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 650 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = 1
		}
		gamBombThreat[slot] = bb.RndI(500, 5000)
	}
	// 209. ALARMED BY DANGEROUS WEAPON
	if gamPromo == 209 {
		if promoTim > 25 && promoTim < 325 {
			Speak(cyc, 1)
			if promoEffect == 0 {
				charHappiness[gamChar[slot]] -= 5
				charReputation[gamChar[slot]] += 1
				ChangeRelationship(pChar[cyc], pChar[v], -1)
				promoEffect = 1
			}
			for count in 1 ..=no_plays {
				if charRole[pChar[count]] == 0 && pChar[count] != gamChar[slot] {
					pSubX[count] = 9999
					pSubZ[count] = 9999
					pAgenda[count] = 1
					pExploreY[count] = 10
					if pX[v] < 0 {
						pExploreX[count] = pX[count] + 300
					} else {
						pExploreX[count] = pX[count] - 300
					}
					if pZ[v] < 0 {
						pExploreZ[count] = pZ[count] + 300
					} else {
						pExploreZ[count] = pZ[count] - 300
					}
					pRunTim[count] = 200
				}
				if charRole[pChar[count]] == 1 {
					pSubX[count] = 9999
					pSubZ[count] = 9999
					pAgenda[count] = 2
					pFollowFoc[count] = v
					pRunTim[count] = 200
				}
			}
			Outline("EVERYBODY RUN FOR YOUR LIVES!", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline(fmt.tprint(charName[pChar[v]], " has got a ", strings.to_lower(weapName[weapType[pWeapon[v]]], context.temp_allocator), "!"), i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 325 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = 1
		}
	}
	// 210. WELCOME TO YARD
	if gamPromo == 210 {
		if promoTim > 25 && promoTim < 325 {
			Speak(cyc, 3)
			if charRole[pChar[cyc]] == 0 && promoEffect == 0 {
				ChangeRelationship(pChar[cyc], pChar[v], 1)
				promoEffect = 1
			}
			cell_name := CellName(pChar[v], context.temp_allocator)
			Outline(fmt.tprint("Welcome to the Exercise Yard, ", cell_name, "!"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("This is where you come to improve your body...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 350 && promoTim < 650 {
			Speak(cyc, 3)
			Outline("You can improve your strength by lifting weights,", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("or improve your agility by running around the yard...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 675 && promoTim < 975 {
			Speak(cyc, 3)
			Outline("But if that sounds too boring, you could always", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("try shooting hoops! It's a fun way to keep fit...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 975 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = -1
		}
	}
	// 211. WELCOME TO STUDY
	if gamPromo == 211 {
		if promoTim > 25 && promoTim < 325 {
			Speak(cyc, 3)
			if charRole[pChar[cyc]] == 0 && promoEffect == 0 {
				ChangeRelationship(pChar[cyc], pChar[v], 1)
				promoEffect = 1
			}
			Outline(fmt.tprint("Welcome to the Study, ", CellName(pChar[v], context.temp_allocator), "!"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("People come here to expand their minds...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 350 && promoTim < 650 {
			Speak(cyc, 3)
			Outline("You can improve your intelligence by reading", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("a book, or earn money by sorting those files...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 675 && promoTim < 975 {
			Speak(cyc, 3)
			Outline("If you know how to use a computer, you might even", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("want to access some information about your peers!", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 975 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = -1
		}
	}
	// 212. WELCOME TO HOSPITAL
	if gamPromo == 212 {
		if promoTim > 25 && promoTim < 325 {
			Speak(cyc, 3)
			if charRole[pChar[cyc]] == 0 && promoEffect == 0 {
				ChangeRelationship(pChar[cyc], pChar[v], 1)
				promoEffect = 1
			}
			Outline(fmt.tprint("Welcome to the Medical Bay, ", CellName(pChar[v], context.temp_allocator), "!"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("This is where you come if you feel weak...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 350 && promoTim < 650 {
			Speak(cyc, 3)
			Outline("You can rest your bones on one of the beds, or", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("help the healing process with a dose of drugs...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 675 && promoTim < 975 {
			Speak(cyc, 3)
			Outline("If you know what you're doing, you could even", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("earn good money by concocting the chemicals!", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 975 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = -1
		}
	}
	// 213. WELCOME TO KITCHEN
	if gamPromo == 213 {
		if promoTim > 25 && promoTim < 325 {
			Speak(cyc, 3)
			if charRole[pChar[cyc]] == 0 && promoEffect == 0 {
				ChangeRelationship(pChar[cyc], pChar[v], 1)
				promoEffect = 1
			}
			Outline(fmt.tprint("Welcome to the Canteen, ", CellName(pChar[v], context.temp_allocator), "!"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("Meals are served here everyday at 13:00...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 350 && promoTim < 650 {
			Speak(cyc, 3)
			Outline("You can also earn a little bit of money by", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("helping to prepare food behind the counter...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 650 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = -1
		}
	}
	// 214. WELCOME TO HALL
	if gamPromo == 214 {
		if promoTim > 25 && promoTim < 325 {
			Speak(cyc, 3)
			if charRole[pChar[cyc]] == 0 && promoEffect == 0 {
				ChangeRelationship(pChar[cyc], pChar[v], 1)
				promoEffect = 1
			}
			Outline(fmt.tprint("Welcome to the Main Hall, ", charName[pChar[v]], "!"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("This is the heart of the entire prison...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 350 && promoTim < 650 {
			Speak(cyc, 3)
			Outline("There's not much to do, but you can occupy", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("your mind by watching TV or using the computer...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 675 && promoTim < 975 {
			Speak(cyc, 3)
			Outline("It's worth keeping an eye on the phones too,", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("because we get some interesting calls here!", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 975 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = -1
		}
	}
	// 215. WELCOME TO WORKSHOP
	if gamPromo == 215 {
		if promoTim > 25 && promoTim < 325 {
			Speak(cyc, 3)
			if charRole[pChar[cyc]] == 0 && promoEffect == 0 {
				ChangeRelationship(pChar[cyc], pChar[v], 1)
				promoEffect = 1
			}
			Outline(fmt.tprint("Welcome to the Workshop, ", CellName(pChar[v], context.temp_allocator), "!"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("This is where items are created...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 350 && promoTim < 650 {
			Speak(cyc, 3)
			Outline("You get paid for everything you produce,", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("but you have to leave it on the bench...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 650 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = -1
		}
	}
	// 216. WELCOME TO TOILETS
	if gamPromo == 216 {
		if promoTim > 25 && promoTim < 325 {
			Speak(cyc, 2)
			if charRole[pChar[cyc]] == 0 && promoEffect == 0 {
				ChangeRelationship(pChar[cyc], pChar[v], 1)
				promoEffect = 1
			}
			Outline(fmt.tprint("Welcome to the Bathroom, ", charName[pChar[v]], "!"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("A lot of shady stuff happens in here...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 350 && promoTim < 650 {
			Speak(cyc, 3)
			Outline("This is the one place the wardens aren't", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("allowed, so you can do whatever you want!", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 650 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = -1
		}
	}
	// 217. SADNESS ABOUT DEAD FRIEND
	if gamPromo == 217 {
		if promoTim > 25 && promoTim < 325 {
			Speak(cyc, 3)
			ShowPhoto(charPromoRef[pChar[cyc]])
			if charRole[pChar[cyc]] == 0 && promoEffect == 0 {
				ChangeRelationship(pChar[cyc], pChar[v], 1)
				promoEffect = 1
			}
			Outline(fmt.tprint("Have you heard about ", charName[charPromoRef[pChar[cyc]]], "'s death?"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("That's sad news. He was a good friend of mine...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 325 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = 1
		}
	}
	// 218. HAPPINESS ABOUT DEAD ENEMY
	if gamPromo == 218 {
		if promoTim > 25 && promoTim < 325 {
			Speak(cyc, 3)
			ShowPhoto(charPromoRef[pChar[cyc]])
			if charRole[pChar[cyc]] == 0 && promoEffect == 0 {
				ChangeRelationship(pChar[cyc], pChar[v], 1)
				promoEffect = 1
			}
			Outline(fmt.tprint("Have you heard about ", charName[charPromoRef[pChar[cyc]]], "'s death?"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("I guess he finally got what was coming to him!", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 325 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = 1
		}
	}
	// 219. SADNESS ABOUT RELEASED FRIEND
	if gamPromo == 219 {
		if promoTim > 25 && promoTim < 325 {
			Speak(cyc, 3)
			ShowPhoto(charPromoRef[pChar[cyc]])
			if charRole[pChar[cyc]] == 0 && promoEffect == 0 {
				ChangeRelationship(pChar[cyc], pChar[v], 1)
				promoEffect = 1
			}
			Outline(fmt.tprint("Have you heard about ", charName[charPromoRef[pChar[cyc]]], "'s release?"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("Good for him! He deserves a better life...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 325 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = 1
		}
	}
	// 220. HAPPINESS ABOUT RELEASED ENEMY
	if gamPromo == 220 {
		if promoTim > 25 && promoTim < 325 {
			Speak(cyc, 3)
			ShowPhoto(charPromoRef[pChar[cyc]])
			if charRole[pChar[cyc]] == 0 && promoEffect == 0 {
				ChangeRelationship(pChar[cyc], pChar[v], 1)
				promoEffect = 1
			}
			Outline(fmt.tprint("Have you heard about ", charName[charPromoRef[pChar[cyc]]], "'s release?"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("He doesn't deserve it, but i'm glad he's gone!", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 325 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = 1
		}
	}
	// 221. FRIEND LOOKS FORWARD TO IMMINENT RELEASE
	if gamPromo == 221 {
		if promoTim > 25 && promoTim < 325 {
			Speak(cyc, 3)
			if promoEffect == 0 {
				charHappiness[pChar[v]] += 5
				ChangeRelationship(pChar[cyc], pChar[v], 1)
				promoEffect = 1
			}
			Outline(fmt.tprint("Hey, ", charName[pChar[v]], ", i'm getting out of here soon!"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("I just wanted to say goodbye before i leave...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 325 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = 1
		}
	}
	// 222. ENEMY BOASTS ABOUT IMMINENT RELEASE
	if gamPromo == 222 {
		if promoTim > 25 && promoTim < 325 {
			Speak(cyc, 1)
			if promoEffect == 0 {
				charHappiness[pChar[v]] -= 5
				ChangeRelationship(pChar[cyc], pChar[v], -1)
				promoEffect = 1
			}
			Outline(fmt.tprint("Hey, ", charName[pChar[v]], ", i'm getting released soon!"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("I'll be living it up while you're in here...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 325 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = 1
		}
	}
	// 223. CONGRATULATED ABOUT IMMINENT RELEASE
	if gamPromo == 223 {
		if promoTim > 25 && promoTim < 325 {
			Speak(cyc, 3)
			if promoEffect == 0 {
				charHappiness[pChar[v]] += 5
				ChangeRelationship(pChar[cyc], pChar[v], 1)
				promoEffect = 1
			}
			Outline(fmt.tprint("Hey, ", charName[pChar[v]], ", i hear you get out soon?"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("We'll miss you, but good luck out there!", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 325 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = 1
		}
	}
	// 224. BITTER ABOUT IMMINENT RELEASE
	if gamPromo == 224 {
		if promoTim > 25 && promoTim < 325 {
			Speak(cyc, 1)
			if promoEffect == 0 {
				charHappiness[pChar[v]] -= 5
				ChangeRelationship(pChar[cyc], pChar[v], -1)
				if charAngerTim[pChar[cyc]][pChar[v]] < 10000 {
					charAngerTim[pChar[cyc]][pChar[v]] = 10000
				}
				pAgenda[cyc] = 2
				pFollowFoc[cyc] = v
				promoEffect = 1
			}
			Outline(fmt.tprint("Hey, ", charName[pChar[v]], ", i hear you get out soon?"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("If it's up to me, you'll leave in a wheelchair!", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 325 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = 1
		}
	}
	// 225. GANG FRICTION
	if gamPromo == 225 {
		if promoTim > 25 && promoTim < 325 {
			Speak(cyc, 1)
			Outline(fmt.tprint("Hey, it's time for ", textGang[charGang[pChar[v]]], " to go!"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline(fmt.tprint(textGang[charGang[pChar[cyc]]], " rule this place now..."), i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 350 && promoTim < 650 {
			Speak(cyc, 1)
			if promoEffect == 0 {
				charHappiness[pChar[v]] -= 5
				charReputation[pChar[v]] += 1
				for char in 1 ..= no_chars {
					for count in 1 ..= no_chars {
						if (charGang[char] == charGang[pChar[cyc]] \
                        && charGang[count] == charGang[pChar[v]]) \
                        || (charGang[count] == charGang[pChar[cyc]] \
                        && charGang[char] == charGang[pChar[v]]) {
							ChangeRelationship(char, count, -1)
							if charAngerTim[char][count] < 10000 {
								charAngerTim[char][count] = 10000
							}
						}
					}
				}
				promoEffect = 1
			}
			Outline("You better prepare your troops - because we're", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("gonna wage war until there's only one gang left!", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 650 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = 1
		}
	}
	// 226. INSULTED BECAUSE OF STRENGTH
	if gamPromo == 226 {
		if promoTim > 25 && promoTim < 325 {
			Speak(cyc, 1)
			if promoEffect == 0 {
				charHappiness[pChar[v]] -= 5
				charReputation[pChar[v]] -= 1
				ChangeRelationship(pChar[cyc], pChar[v], -1)
				if charAngerTim[pChar[cyc]][pChar[v]] < 100 {
					charAngerTim[pChar[cyc]][pChar[v]] = 100
				}
				pAgenda[cyc] = 2
				pFollowFoc[cyc] = v
				promoEffect = 1
			}
			Outline(fmt.tprint("You're a pathetic specimen, ", charName[pChar[v]], "!"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("I could crush a weakling like you with one hand...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 325 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = 1
		}
	}
	// 227. PRAISED BECAUSE OF STRENGTH
	if gamPromo == 227 {
		if promoTim > 25 && promoTim < 325 {
			Speak(cyc, 3)
			if promoEffect == 0 {
				charHappiness[pChar[v]] += 5
				charReputation[pChar[v]] += 1
				ChangeRelationship(pChar[cyc], pChar[v], 1)
				promoEffect = 1
			}
			Outline(fmt.tprint("I wish i was as strong as you, ", charName[pChar[v]], "!"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("I'm sure it gets you through some tough times...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 325 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = 1
		}
	}
	// 228. INSULTED BECAUSE OF AGILITY
	if gamPromo == 228 {
		if promoTim > 25 && promoTim < 325 {
			Speak(cyc, 1)
			if promoEffect == 0 {
				charHappiness[pChar[v]] -= 5
				charReputation[pChar[v]] -= 1
				ChangeRelationship(pChar[cyc], pChar[v], -1)
				if charAngerTim[pChar[cyc]][pChar[v]] < 100 {
					charAngerTim[pChar[cyc]][pChar[v]] = 100
				}
				pAgenda[cyc] = 2
				pFollowFoc[cyc] = v
				promoEffect = 1
			}
			Outline(fmt.tprint("Hey, ", charName[pChar[v]], ", you're a lazy asshole!"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("I can probably walk faster than you run...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 325 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = 1
		}
	}
	// 229. PRAISED BECAUSE OF AGILITY
	if gamPromo == 229 {
		if promoTim > 25 && promoTim < 325 {
			Speak(cyc, 3)
			if promoEffect == 0 {
				charHappiness[pChar[v]] += 5
				charReputation[pChar[v]] += 1
				ChangeRelationship(pChar[cyc], pChar[v], 1)
				promoEffect = 1
			}
			Outline(fmt.tprint("I wish i was as fit as you, ", charName[pChar[v]], "!"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("I'm sure it makes life a lot easier in here...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 325 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = 1
		}
	}
	// 230. INSULTED BECAUSE OF INTELLIGENCE
	if gamPromo == 230 {
		if promoTim > 25 && promoTim < 325 {
			Speak(cyc, 1)
			if promoEffect == 0 {
				charHappiness[pChar[v]] -= 5
				charReputation[pChar[v]] -= 1
				ChangeRelationship(pChar[cyc], pChar[v], -1)
				if charAngerTim[pChar[cyc]][pChar[v]] < 100 do charAngerTim[pChar[cyc]][pChar[v]] = 100
				pAgenda[cyc] = 2
				pFollowFoc[cyc] = v
				promoEffect = 1
			}
			Outline(fmt.tprint("Hey, ", charName[pChar[v]], ", you must be retarded!"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("I've never met anybody as stupid as you...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 325 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = 1
		}
	}
	// 231. PRAISED BECAUSE OF INTELLIGENCE
	if gamPromo == 231 {
		if promoTim > 25 && promoTim < 325 {
			Speak(cyc, 3)
			if promoEffect == 0 {
				charHappiness[pChar[v]] += 5
				charReputation[pChar[v]] += 1
				ChangeRelationship(pChar[cyc], pChar[v], 1)
				promoEffect = 1
			}
			Outline(fmt.tprint("I wish i was as smart as you, ", charName[pChar[v]], "!"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("I bet you can have any job you want in here...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 325 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = 1
		}
	}
	// 232. INSULTED BECAUSE OF REPUTATION
	if gamPromo == 232 {
		if promoTim > 25 && promoTim < 325 {
			Speak(cyc, 1)
			if promoEffect == 0 {
				charHappiness[pChar[v]] -= 5
				charReputation[pChar[v]] -= 1
				ChangeRelationship(pChar[cyc], pChar[v], -1)
				if charAngerTim[pChar[cyc]][pChar[v]] < 100 do charAngerTim[pChar[cyc]][pChar[v]] = 100
				pAgenda[cyc] = 2
				pFollowFoc[cyc] = v
				promoEffect = 1
			}
			Outline(fmt.tprint("You're nothing but a pussy, ", charName[pChar[v]], "!"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("The wardens respect you more than the inmates...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 325 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = 1
		}
	}
	// 233. PRAISED BECAUSE OF REPUTATION
	if gamPromo == 233 {
		if promoTim > 25 && promoTim < 325 {
			Speak(cyc, 3)
			if promoEffect == 0 {
				charHappiness[pChar[v]] += 5
				charReputation[pChar[v]] += 1
				ChangeRelationship(pChar[cyc], pChar[v], 1)
				promoEffect = 1
			}
			Outline(fmt.tprint("I wish i had your reputation, ", charName[pChar[v]], "!"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("I bet it keeps a lot of people off your back...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 325 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = 1
		}
	}
	// 234. INSULTED BECAUSE OF FINANCES
	if gamPromo == 234 {
		if promoTim > 25 && promoTim < 325 {
			Speak(cyc, 1)
			if promoEffect == 0 {
				charHappiness[pChar[v]] -= 5
				charReputation[pChar[v]] -= 1
				ChangeRelationship(pChar[cyc], pChar[v], -1)
				if charAngerTim[pChar[cyc]][pChar[v]] < 100 do charAngerTim[pChar[cyc]][pChar[v]] = 100
				pAgenda[cyc] = 2
				pFollowFoc[cyc] = v
				promoEffect = 1
			}
			figure := GetFigure(gamMoney[slot], context.temp_allocator)
			Outline(fmt.tprint("Hey, ", charName[pChar[v]], ", is $", figure, " all you're worth?"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("That's loose change to me, you peasant!", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 325 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = 1
		}
	}
	// 235. PRAISED BECAUSE OF FINANCES
	if gamPromo == 235 {
		if promoTim > 25 && promoTim < 325 {
			Speak(cyc, 3)
			if promoEffect == 0 {
				charHappiness[pChar[v]] += 5
				charReputation[pChar[v]] += 1
				ChangeRelationship(pChar[cyc], pChar[v], 1)
				promoEffect = 1
			}
			Outline(fmt.tprint("I wish i was as rich as you, ", charName[pChar[v]], "!"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			figure := GetFigure(gamMoney[slot], context.temp_allocator)
			Outline(fmt.tprint("I bet $", figure, " makes life a lot easier in here..."), i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 325 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = 1
		}
	}
	// 236. INSULTED BECAUSE FOR BEING FAT
	if gamPromo == 236 {
		if promoTim > 25 && promoTim < 325 {
			Speak(cyc, 1)
			if promoEffect == 0 {
				charHappiness[pChar[v]] -= 5
				charReputation[pChar[v]] -= 1
				ChangeRelationship(pChar[cyc], pChar[v], -1)
				if charAngerTim[pChar[cyc]][pChar[v]] < 100 do charAngerTim[pChar[cyc]][pChar[v]] = 100
				pAgenda[cyc] = 2
				pFollowFoc[cyc] = v
				promoEffect = 1
			}
			Outline(fmt.tprint("Eeewww! You make me sick, ", charName[pChar[v]], "!"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("Take your fat ass somewhere else...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 325 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = 1
		}
	}
	// 237. INSULTED BECAUSE FOR BEING SKINNY
	if gamPromo == 237 {
		if promoTim > 25 && promoTim < 325 {
			Speak(cyc, 1)
			if promoEffect == 0 {
				charHappiness[pChar[v]] -= 5
				charReputation[pChar[v]] -= 1
				ChangeRelationship(pChar[cyc], pChar[v], -1)
				if charAngerTim[pChar[cyc]][pChar[v]] < 100 do charAngerTim[pChar[cyc]][pChar[v]] = 100
				pAgenda[cyc] = 2
				pFollowFoc[cyc] = v
				promoEffect = 1
			}
			Outline(fmt.tprint("Haha! You're a little runt, ", charName[pChar[v]], "!"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("I'd love to break that pencil neck of yours...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 325 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = 1
		}
	}
	// 238. INSULTED FOR INFERIOR CRIME
	if gamPromo == 238 {
		if promoTim > 25 && promoTim < 325 {
			Speak(cyc, 1)
			Outline(fmt.tprint("Hey, ", charName[pChar[v]], ", you think you're a big man"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline(fmt.tprint("because you're doing time for ", strings.to_lower(textCrime[charCrime[pChar[v]]], context.temp_allocator), "?!"), i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 350 && promoTim < 650 {
			Speak(cyc, 1)
			if promoEffect == 0 {
				charHappiness[pChar[v]] -= 5
				charReputation[pChar[v]] -= 1
				ChangeRelationship(pChar[cyc], pChar[v], -1)
				if charAngerTim[pChar[cyc]][pChar[v]] < 100 do charAngerTim[pChar[cyc]][pChar[v]] = 100
				pAgenda[cyc] = 2
				pFollowFoc[cyc] = v 
				promoEffect = 1
			}
			Outline("Well, screw that because i'm in here for", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline(fmt.tprint(strings.to_lower(textCrime[charCrime[pChar[cyc]]], context.temp_allocator), " - and that's even worse!"), i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 650 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = 1
		}
	}
	// 239. DISGUSTED BY SUPERIOR CRIME
	if gamPromo == 239 {
		if promoTim > 25 && promoTim < 325 {
			Speak(cyc, 2)
			Outline(fmt.tprint("Hey, ", charName[pChar[v]], ", i hear you're"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline(fmt.tprint("in here for ", strings.to_lower(textCrime[charCrime[pChar[v]]], context.temp_allocator), "?"), i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 350 && promoTim < 650 {
			Speak(cyc, 1)
			if promoEffect == 0 {
				charHappiness[pChar[v]] -= 5
				charReputation[pChar[v]] += 1
				ChangeRelationship(pChar[cyc], pChar[v], -1)
				promoEffect = 1
			}
			Outline("Animals like you should be in another prison!", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline(fmt.tprint("I'm only in here for ", strings.to_lower(textCrime[charCrime[pChar[cyc]]], context.temp_allocator), "..."), i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 650 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = 1
		}
	}
	// 240. COMFORTED ABOUT CRIME
	if gamPromo == 240 {
		if promoTim > 25 && promoTim < 325 {
			Speak(cyc, 2)
			Outline(fmt.tprint("Hey, ", charName[pChar[v]], ", i hear you're"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline(fmt.tprint("in here for ", strings.to_lower(textCrime[charCrime[pChar[v]]], context.temp_allocator), "?"), i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 350 && promoTim < 650 {
			Speak(cyc, 3)
			if promoEffect == 0 {
				charHappiness[pChar[v]] += 5
				ChangeRelationship(pChar[cyc], pChar[v], 1)
				promoEffect = 1
			}
			Outline("Don't worry, i'm sure you didn't do it!", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline(fmt.tprint("I've been accused of ", strings.to_lower(textCrime[charCrime[pChar[cyc]]], context.temp_allocator), "..."), i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 650 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = 1
		}
	}
	// 241. RIDICULED FOR WORKING
	if gamPromo == 241 {
		if promoTim > 25 && promoTim < 325 {
			Speak(cyc, 1)
			Outline(fmt.tprint("Haha! Look at ", charName[pChar[v]], " working!"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("Who are you trying to impress?", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 350 && promoTim < 650 {
			Speak(cyc, 1)
			if promoEffect == 0 {
				charHappiness[pChar[v]] -= 5
				charReputation[pChar[v]] -= 1
				ChangeRelationship(pChar[cyc], pChar[v], -1)
				if charAngerTim[pChar[cyc]][pChar[v]] < 100 do charAngerTim[pChar[cyc]][pChar[v]] = 100
				pAgenda[cyc] = 2
				pFollowFoc[cyc] = v 
				promoEffect = 1
			}
			Outline("Only the wardens respect a hard worker!", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("Real thugs earn their money doing dirt...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 650 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = 1
		}
	}
    // 242. BLOCK FRICTION



	
	

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

CrimePromos :: proc(cyc, v: i32, y: f32) {
	
}

MissionPromos :: proc(cyc, v: i32, y: f32) {
	
}