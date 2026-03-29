package main

import bb "blitzbasic3d"
import "core:fmt"
import "core:mem"
import "core:strings"

////////////////////////////////////////////////////////////////////////////////
//----------------------------- HARD TIME: MISSIONS ----------------------------
////////////////////////////////////////////////////////////////////////////////

//----------------------------------------------------------------------
//////////////////////////// MISSION PROMOS ////////////////////////////
//----------------------------------------------------------------------
MissionPromos :: proc(cyc, v: i32, y: f32) {
	checkpoint := mem.begin_arena_temp_memory(cast(^mem.Arena)context.temp_allocator.data)
	// PHONE INTRO
	if gamPromo >= 141 && gamPromo <= 170 && GetClient(cyc, v) == 0 {
		if promoTim > 25 && promoTim < 325 {
			Speak(cyc, 2)
			Outline("Hey, you don't know me but listen up! If you", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("do me a favour i'll make it worth your while...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
	}
	// STRANGER INTRO
	if gamPromo >= 141 && gamPromo <= 170 && GetClient(cyc, v) == 1 {
		if promoTim > 25 && promoTim < 325 {
			Speak(cyc, 2)
			ChangeRelationship(pChar[cyc], pChar[v], 1)
			Outline(fmt.tprint("Hey, ", charName[pChar[v]], ", do you fancy earning some"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("easy money? I've got a little job for you...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
	}
	// GANG INTRO
	if gamPromo >= 141 && gamPromo <= 170 && GetClient(cyc, v) == 2 {
		if promoTim > 25 && promoTim < 325 {
			Speak(cyc, 2)
			ChangeRelationship(pChar[cyc], pChar[v], 1)
			Outline(fmt.tprint("It's time to prove yourself, ", charName[pChar[v]], "!"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("We need you to do something for the gang...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
	}
	// WARDEN INTRO
	if gamPromo >= 141 && gamPromo <= 170 && GetClient(cyc, v) == 3 {
		if promoTim > 25 && promoTim < 325 {
			Speak(cyc, 2)
			Outline(fmt.tprint("Listen, ", CellName(pChar[v], context.temp_allocator), ", i've been keeping an eye on your"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("progress and i think changes need to be made...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
	}
	// 1. ACQUIRE STRENGTH
	if gamPromo == 141 {
		if promoTim < 350 {
			AssignMission(cyc, gamPromo - 140)
			gamTarget[slot] = charStrength[gamChar[slot]] + 5
		}
		if promoTim > 350 && promoTim < 650 {
			Speak(cyc, 1)
			Outline("You're not strong enough to survive in here!", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline(fmt.tprint("Raise your strength to ", gamTarget[slot], "% by ", gamDeadline[slot], ":00 tomorrow..."), i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 650 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = 1
		}
	}
	// 2. ACQUIRE AGILITY
	if gamPromo == 142 {
		if promoTim < 350 {
			AssignMission(cyc, gamPromo - 140)
			gamTarget[slot] = charAgility[gamChar[slot]] + 5
		}
		if promoTim > 350 && promoTim < 650 {
			Speak(cyc, 1)
			Outline("You're not fit enough to keep up with the pace!", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline(fmt.tprint("Raise your agility to ", gamTarget[slot], "% by ", gamDeadline[slot], ":00 tomorrow..."), i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 650 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = 1
		}
	}
	// 3. ACQUIRE INTELLIGENCE
	if gamPromo == 143 {
		if promoTim < 350 {
			AssignMission(cyc, gamPromo - 140)
			gamTarget[slot] = charIntelligence[gamChar[slot]] + 5
		}
		if promoTim > 350 && promoTim < 650 {
			Speak(cyc, 1)
			Outline("Your lack of knowledge is holding you back!", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline(fmt.tprint("Raise your intellect to ", gamTarget[slot], "% by ", gamDeadline[slot], ":00 tomorrow..."), i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 650 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = 1
		}
	}
	// 4. ACQUIRE REPUTATION
	if gamPromo == 144 {
		if promoTim < 350 {
			AssignMission(cyc, gamPromo - 140)
			gamTarget[slot] = charReputation[gamChar[slot]] + 5
		}
		if promoTim > 350 && promoTim < 650 {
			Speak(cyc, 1)
			Outline("The people in here don't take you seriously!", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline(fmt.tprint("Build a reputation of ", gamTarget[slot], "% by ", gamDeadline[slot], ":00 tomorrow..."), i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 650 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = 1
		}
	}
	// 5. LOSE REPUTATION
	if gamPromo == 145 {
		if promoTim < 350 {
			AssignMission(cyc, gamPromo - 140)
			gamTarget[slot] = charReputation[gamChar[slot]] - 5
		}
		if promoTim > 350 && promoTim < 650 {
			Speak(cyc, 1)
			Outline("You care more about reputation than rehabilitation!", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline(fmt.tprint("Reduce it to ", gamTarget[slot], "% by ", gamDeadline[slot], ":00 tomorrow..."), i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 650 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = 1
		}
	}
	// 6. GET OUT OF DEBT
	if gamPromo == 146 {
		if promoTim < 350 {
			AssignMission(cyc, gamPromo - 140)
			gamTarget[slot] = 0
		}
		if promoTim > 350 && promoTim < 650 {
			Speak(cyc, 1)
			Outline("Your financial status brings shame on you!", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline(fmt.tprint("Get out of debt by ", gamDeadline[slot], ":00 tomorrow..."), i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 650 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = 1
		}
	}
	// 7. ACQUIRE FORTUNE
	if gamPromo == 147 {
		if promoTim < 350 {
			AssignMission(cyc, gamPromo - 140)
			gamTarget[slot] = gamMoney[slot] + 250
		}
		if promoTim > 350 && promoTim < 650 {
			Speak(cyc, 1)
			Outline("You need to get to work and start earning money!", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline(fmt.tprint("Amass a fortune of $", GetFigure(gamTarget[slot], context.temp_allocator), " by ", gamDeadline[slot], ":00 tomorrow..."), i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 650 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = 1
		}
	}
	// 8. CHANGE HAIRSTYLE
	if gamPromo == 148 {
		if promoTim < 350 {
			AssignMission(cyc, gamPromo - 140)
			gamTarget[slot] = charHairStyle[pChar[cyc]]
		}
		if promoTim > 350 && promoTim < 650 {
			Speak(cyc, 1)
			Outline("That hairstyle is making you a laughing stock!", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline(fmt.tprint("Grab a comb and copy mine by ", gamDeadline[slot], ":00 tomorrow..."), i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 650 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = 1
		}
	}
	// 9. CHANGE COSTUME
	if gamPromo == 149 {
		if promoTim < 350 {
			AssignMission(cyc, gamPromo - 140)
			gamTarget[slot] = charCostume[pChar[cyc]]
		}
		if promoTim > 350 && promoTim < 650 {
			Speak(cyc, 1)
			Outline("The way you dress is a crime against fashion!", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline(fmt.tprint("Grab a mirror and copy me by ", gamDeadline[slot], ":00 tomorrow..."), i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 650 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = 1
		}
	}
	// 10. ACQUIRE ITEM
	if gamPromo == 150 {
		if promoTim < 350 {
			AssignMission(cyc, gamPromo - 140)
			for {
				gamTarget[slot] = bb.RndI(1, weapList)
				if weapType[pWeapon[cyc]] != gamTarget[slot] && weapType[pWeapon[v]] != gamTarget[slot] do break
			}
		}
		if promoTim > 350 && promoTim < 650 {
			Speak(cyc, 3)
			Outline(fmt.tprint("I've been looking everywhere for a ", bb.Lower(weapName[gamTarget[slot]]), "!"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline(fmt.tprint("See if you can get me one by ", gamDeadline[slot], ":00 tomorrow..."), i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 650 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = 1
		}
	}
	// 11. DELIVER GIVEN ITEM
	if gamPromo == 151 {
		if promoTim < 350 {
			AssignMission(cyc, gamPromo - 140)
			gamItem[slot] = weapType[pWeapon[cyc]]
			its := 0
			for {
				gamTarget[slot] = bb.RndI(1, no_chars)
				its += 1
				if (charSnapped[gamTarget[slot]] > 0 || its > 100) \\
				&& charRole[gamTarget[slot]] == 0 \
				&& charLocation[gamTarget[slot]] > 0 \
				&& charLocation[gamTarget[slot]] != gamLocation[slot] {
					break
				}
			}
		}
		if promoTim > 350 && promoTim < 9975 do ShowPhoto(gamTarget[slot])
		if promoTim > 350 && promoTim < 650 {
			Speak(cyc, 3)
			ChangeRelationship(pChar[cyc], gamTarget[slot], 1)
			if promoEffect == 0 {
				ChangeAnim(cyc, 25)
				ChangeAnim(v, 26)
				promoEffect = 1
			}
			Outline(fmt.tprint("Find ", charName[gamTarget[slot]], " in the ", textLocation[charLocation[gamTarget[slot]]], " and"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline(fmt.tprint("give him this ", bb.Lower(weapName[gamItem[slot]]), " by ", gamDeadline[slot], ":00 tomorrow..."), i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 650 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = 1
		}
	}
	// 12. FIND & DELIVER ITEM
	if gamPromo == 152 {
		if promoTim < 350 {
			AssignMission(cyc, gamPromo - 140)
			gamItem[slot] = bb.RndI(1, weapList)
			its := 0
			for {
				gamTarget[slot] = bb.RndI(1, no_chars)
				its += 1
				if (charSnapped[gamTarget[slot]] > 0 || its > 100) \
				&& charRole[gamTarget[slot]] == 0 \
				&& charLocation[gamTarget[slot]] > 0 \
				&& charLocation[gamTarget[slot]] != gamLocation[slot] {
					break
				}
			}
			if cyc > 0 {
				ChangeRelationship(pChar[cyc], gamTarget[slot], 1)
			}
		}
		if promoTim > 350 && promoTim < 9975 do ShowPhoto(gamTarget[slot])
		if promoTim > 350 && promoTim < 650 {
			Speak(cyc, 3)
			Outline(fmt.tprint("I need to get a ", bb.Lower(weapName[gamItem[slot]]), " to a guy"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline(fmt.tprint("called '", charName[gamTarget[slot]], "' in the ", textLocation[charLocation[gamTarget[slot]]], "..."), i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 675 && promoTim < 975 {
			Speak(cyc, 3)
			Outline("I'd appreciate it if you could get hold of", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline(fmt.tprint("one and take it to him by ", gamDeadline[slot], ":00 tomorrow?"), i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 975 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = 1
		}
	}
	// 13. KILL CHARACTER
	if gamPromo == 153 {
		if promoTim < 350 {
			AssignMission(cyc, gamPromo - 140)
			gamReward[slot] = 500
			gamTarget[slot] = FindVictim(cyc, v)
		}
		if promoTim > 350 && promoTim < 9975 do ShowPhoto(gamTarget[slot])
		if promoTim > 350 && promoTim < 650 {
			Speak(cyc, 1)
			Outline(fmt.tprint(charName[gamTarget[slot]], " has got to go! Track him down"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline(fmt.tprint("and kill him for me by ", gamDeadline[slot], ":00 tomorrow..."), i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 650 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = 1
		}
	}
	// 14. MUTILATE CHARACTER
	if gamPromo == 154 {
		if promoTim < 350 {
			AssignMission(cyc, gamPromo - 140)
			gamReward[slot] = 250
			gamTarget[slot] = FindVictim(cyc, v)
		}
		if promoTim > 350 && promoTim < 9975 do ShowPhoto(gamTarget[slot])
		if promoTim > 350 && promoTim < 650 {
			Speak(cyc, 1)
			Outline(fmt.tprint(charName[gamTarget[slot]], "needs to be taught a lesson!"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline(fmt.tprint("Inflict an injury on him by", gamDeadline[slot], ":00 tomorrow..."), i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 650 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = 1
		}
	}
	// 15. ASSAULT CHARACTER
	if gamPromo == 155 {
		if promoTim < 350 {
			AssignMission(cyc, gamPromo - 140)
			gamTarget[slot] = FindVictim(cyc, v)
		}
		if promoTim > 350 && promoTim < 9975 do ShowPhoto(gamTarget[slot])
		if promoTim > 350 && promoTim < 650 {
			Speak(cyc, 1)
			Outline(fmt.tprint(charName[gamTarget[slot]], "has got it coming! Track him down"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline(fmt.tprint("and give him a beating by", gamDeadline[slot], ":00 tomorrow..."), i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 650 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = 1
		}
	}
	// 16. MEET CHARACTER
	if gamPromo == 156 {
		if promoTim < 350 {
			AssignMission(cyc, gamPromo - 140)
			its := 0
			for {
				gamTarget[slot] = bb.RndI(1, no_chars)
				its += 1
				if (charSnapped[gamTarget[slot]] == 0 || its > 100) \
				&& charRole[gamTarget[slot]] == 0 \
				&& charLocation[gamTarget[slot]] > 0 \
				&& charLocation[gamTarget[slot]] != gamLocation[slot] {
					break
				}
			}
			if cyc > 0 do ChangeRelationship(pChar[cyc], gamTarget[slot], 1)
		}
		if promoTim > 350 && promoTim < 650 {
			Speak(cyc, 3)
			Outline(fmt.tprint("I need to reach someone called '", charName[gamTarget[slot]], "'.", sep=""), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			hair := "unusual"
			if charHair[gamTarget[slot]] <= 2 do hair = "dark"
			if charHair[gamTarget[slot]] >= 3 && charHair[gamTarget[slot]] <= 4 do hair = "brown"
			if charHair[gamTarget[slot]] == 5 do hair = "red"
			if charHair[gamTarget[slot]] >= 6 && charHair[gamTarget[slot]] <= 7 do hair = "blonde"
			if charHair[gamTarget[slot]] >= 8 && charHair[gamTarget[slot]] <= 9 do hair = "grey"
			if charHairStyle[gamTarget[slot]] == 0 do hair = "no"
			if charHairStyle[gamTarget[slot]] == 1 do hair = "shaved"
			Outline(fmt.tprint("He's a", bb.Lower(textModel[charModel[gamTarget[slot]]]), textRace[GetRace(gamTarget[slot])], "guy with", hair, "hair..."), i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 675 && promoTim < 975 {
			Speak(cyc, 3)
			Outline(fmt.tprint("He should be waiting in the ", textLocation[charLocation[gamTarget[slot]]], ".", sep=""), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline(fmt.tprint("Go and meet him there before", gamDeadline[slot], ":00 tomorrow..."), i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 975 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = 1
		}
	}
	// 17. IDENTIFY CHARACTER
	if gamPromo == 157 {
		if promoTim < 350 {
			AssignMission(cyc, gamPromo - 140)
			its := 0
			for {
				gamTarget[slot] = bb.RndI(1, no_chars)
				its += 1
				if (charSnapped[gamTarget[slot]] == 0 || its > 100) \
				&& charRole[gamTarget[slot]] == 0 \
				&& charLocation[gamTarget[slot]] > 0 \
				&& charLocation[gamTarget[slot]] != gamLocation[slot] {
					break
				}
			}
		}
		if promoTim > 350 && promoTim < 650 {
			Speak(cyc, 3)
			Outline(fmt.tprint("I need to know who lives in Cell", charCell[gamTarget[slot]], "of the", textBlock[charBlock[gamTarget[slot]]], "Block."), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline(fmt.tprint("Look into it and get back to me by", gamDeadline[slot], ":00 tomorrow..."), i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 650 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = 1
		}
	}
	// 18. GUARD CHARACTER
	if gamPromo == 158 {
		if promoTim < 350 do AssignMission(cyc, gamPromo - 140)
		if promoTim > 350 && promoTim < 650 {
			Speak(cyc, 3)
			Outline("I've got a feeling something's about to go down!", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("Could you watch by back for a little while?", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 650 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = 1
			if gamMins[slot] >= 45 {
				gamDeadline[slot] = gamHours[slot] + 2
			} else {
				gamDeadline[slot] = gamHours[slot] + 1
			}
		}
	}
	// 19. GET ARRESTED
	if gamPromo == 159 {
		if promoTim < 350 {
			AssignMission(cyc, gamPromo - 140)
			gamReward[slot] = 500
		}
		if promoTim > 350 && promoTim < 650 {
			Speak(cyc, 3)
			Outline(fmt.tprint("We need to put", textGang[charGang[pChar[cyc]]], "on the map!"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline(fmt.tprint("See if you can get arrested by", gamDeadline[slot], ":00 tomorrow..."), i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 650 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = 1
		}
	}
	// 20. JOIN A GANG
	if gamPromo == 160 {
		if promoTim < 350 {
			AssignMission(cyc, gamPromo - 140)
			gamReward[slot] = 500
			its := 0
			for {
				conflict := 0
				its += 1
				gamTarget[slot] = bb.RndI(1, 6)
				if cyc > 0 {
					if gamTarget[slot] == charGang[pChar[cyc]] do conflict = 1
				}
				if gamTarget[slot] == charGang[pChar[v]] do conflict = 1
				if charGangHistory[gamChar[slot]][gamTarget[slot]] > 0 && its < 100 do conflict = 1
				if conflict == 0 do break
			}
		}
		if promoTim > 350 && promoTim < 650 {
			Speak(cyc, 3)
			Outline(fmt.tprint("I need to know more about ", textGang[gamTarget[slot]], "."), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline(fmt.tprint("Try to infiltrate that gang by ", gamDeadline[slot], ":00 tomorrow..."), i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 650 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = 1
		}
	}
	////////////////////////// MISSION REACTIONS ////////////////////////////
	// 171. MISSION REMINDER
	if gamPromo == 171 {
		if promoTim > 25 && promoTim < 325 && gamMission[slot] == 1 {
			Speak(cyc, 2)
			Outline("Hey, remember you're on a mission to", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline(fmt.tprint("raise your strength to ", gamTarget[slot], "% by ", gamDeadline[slot], ":00...", sep=""), i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 25 && promoTim < 325 && gamMission[slot] == 2 {
			Speak(cyc, 2)
			Outline("Hey, remember you're on a mission to", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline(fmt.tprint("raise your agility to ", gamTarget[slot], "% by ", gamDeadline[slot], ":00...", sep=""), i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 25 && promoTim < 325 && gamMission[slot] == 3 {
			Speak(cyc, 2)
			Outline("Hey, remember you're on a mission to", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline(fmt.tprint("raise your intelligence to ", gamTarget[slot], "% by ", gamDeadline[slot], ":00...", sep=""), i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 25 && promoTim < 325 && gamMission[slot] == 4 {
			Speak(cyc, 2)
			Outline("Hey, remember you're on a mission to", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline(fmt.tprint("acquire a reputation of ", gamTarget[slot], "% by ", gamDeadline[slot], ":00...", sep=""), i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 25 && promoTim < 325 && gamMission[slot] == 5 {
			Speak(cyc, 2)
			Outline("Hey, remember you're on a mission to", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline(fmt.tprint("reduce your reputation to ", gamTarget[slot], "% by ", gamDeadline[slot], ":00...", sep=""), i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 25 && promoTim < 325 && gamMission[slot] == 6 {
			Speak(cyc, 2)
			Outline("Hey, remember you're on a mission", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline(fmt.tprint("to get out of debt by ", gamDeadline[slot], ":00...", sep=""), i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 25 && promoTim < 325 && gamMission[slot] == 7 {
			Speak(cyc, 2)
			Outline("Hey, remember you're on a mission to", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline(fmt.tprint("amass a fortune of $", GetFigure(gamTarget[slot], context.temp_allocator), " by ", gamDeadline[slot], ":00...", sep=""), i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 25 && promoTim < 325 && gamMission[slot] == 8 {
			Speak(cyc, 2)
			Outline("Hey, remember you're on a mission to", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline(fmt.tprint("make your hair like mine by ", gamDeadline[slot], ":00...", sep=""), i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 25 && promoTim < 325 && gamMission[slot] == 9 {
			Speak(cyc, 2)
			Outline("Hey, remember you're on a mission to", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline(fmt.tprint("make your outfit like mine by ", gamDeadline[slot], ":00...", sep=""), i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 25 && promoTim < 325 && gamMission[slot] == 10 {
			Speak(cyc, 2)
			Outline("Hey, remember you're on a mission to", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline(fmt.tprint("bring me a ", strings.to_lower(weapName[gamTarget[slot]], context.temp_allocator), " by ", gamDeadline[slot], ":00...", sep=""), i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 25 && promoTim < 325 && gamMission[slot] >= 11 && gamMission[slot] <= 12 {
			Speak(cyc, 2)
			ShowPhoto(gamTarget[slot])
			Outline(fmt.tprint("Hey, remember to deliver that ", strings.to_lower(weapName[gamItem[slot]], context.temp_allocator), " to", sep=""), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline(fmt.tprint(charName[gamTarget[slot]], " in the ", textLocation[charLocation[gamTarget[slot]]], " by ", gamDeadline[slot], ":00...", sep=""), i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 25 && promoTim < 325 && gamMission[slot] == 13 {
			Speak(cyc, 2)
			ShowPhoto(gamTarget[slot])
			Outline("Hey, remember you're on a mission to", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline(fmt.tprint("kill ", charName[gamTarget[slot]], " by ", gamDeadline[slot], ":00...", sep=""), i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 25 && promoTim < 325 && gamMission[slot] == 14 {
			Speak(cyc, 2)
			ShowPhoto(gamTarget[slot])
			Outline("Hey, remember you're on a mission to", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline(fmt.tprint("injure ", charName[gamTarget[slot]], " by ", gamDeadline[slot], ":00...", sep=""), i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 25 && promoTim < 325 && gamMission[slot] == 15 {
			Speak(cyc, 2)
			ShowPhoto(gamTarget[slot])
			Outline("Hey, remember you're on a mission to", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline(fmt.tprint("attack ", charName[gamTarget[slot]], " by ", gamDeadline[slot], ":00...", sep=""), i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 25 && promoTim < 325 && gamMission[slot] == 16 {
			Speak(cyc, 2)
			Outline("Hey, remember you need to meet a guy called", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline(fmt.tprint("'", charName[gamTarget[slot]], "' in the ", textLocation[charLocation[gamTarget[slot]]], " by ", gamDeadline[slot], ":00...", sep=""), i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 25 && promoTim < 325 && gamMission[slot] == 17 {
			Speak(cyc, 2)
			Outline("Hey, remember i need to know who lives in", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline(fmt.tprint("Cell ", charCell[gamTarget[slot]], " of the ", textBlock[charBlock[gamTarget[slot]]], " Block by ", gamDeadline[slot], ":00...", sep=""), i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 25 && promoTim < 325 && gamMission[slot] == 18 {
			Speak(cyc, 2)
			Outline("Hey, remember i'm depending on you", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline(fmt.tprint("to watch my back until ", gamDeadline[slot], ":00...", sep=""), i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 25 && promoTim < 325 && gamMission[slot] == 19 {
			Speak(cyc, 2)
			Outline("Hey, remember you're on a mission", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline(fmt.tprint("to get arrested by ", gamDeadline[slot], ":00...", sep=""), i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 25 && promoTim < 325 && gamMission[slot] == 20 {
			Speak(cyc, 2)
			Outline("Hey, remember you're on a mission to", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline(fmt.tprint("join ", textGang[gamTarget[slot]], " by ", gamDeadline[slot], ":00...", sep=""), i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 325 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = 1
		}
	}
	// 172. PHONE FAILURE
	if gamPromo == 172 && GetClient(cyc, v) == 0 {
		if promoTim > 25 && promoTim < 325 {
			Speak(cyc, 1)
			if promoEffect == 0 {
				charHappiness[gamChar[slot]] -= 5
				charReputation[gamChar[slot]] -= 1
				gamMission[slot] = 0
				gamClient[slot] = 0
				promoEffect = 1
			}
			Outline("You couldn't accomplish one little task for me?", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("No wonder you're behind bars, you useless moron!", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 325 && promoTim < 9975 {
			promoTim = 9975
		}
	}
	// 172. PEER FAILURE
	if gamPromo == 172 && GetClient(cyc, v) == 1 {
		if promoTim > 25 && promoTim < 325 {
			Speak(cyc, 1)
			if promoEffect == 0 {
				charHappiness[gamChar[slot]] -= 5
				charReputation[gamChar[slot]] -= 1
				ChangeRelationship(pChar[cyc], pChar[v], -1)
				gamMission[slot] = 0
				gamClient[slot] = 0
				promoEffect = 1
			}
			Outline(fmt.tprint("You screwed up, ", charName[pChar[v]], "! That's the last"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("time i ask you to do something for me...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 325 && promoTim < 9975 {
			promoTim = 9975
		}
	}
	// 172. GANG FAILURE
	if gamPromo == 172 && GetClient(cyc, v) == 2 {
		if promoTim > 25 && promoTim < 325 {
			Speak(cyc, 1)
			if promoEffect == 0 {
				charHappiness[gamChar[slot]] -= 5
				charReputation[gamChar[slot]] -= 1
				ChangeGang(gamChar[slot], 0)
				gamMission[slot] = 0
				gamClient[slot] = 0
				promoEffect = 1
			}
			Outline(fmt.tprint("You let down the whole gang, ", charName[pChar[v]], "!"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("You're no longer worthy of wearing that ink...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 325 && promoTim < 9975 {
			promoTim = 9975
		}
	}
	// 172. WARDEN FAILURE
	if gamPromo == 172 && GetClient(cyc, v) == 3 {
		if promoTim > 25 && promoTim < 325 {
			Speak(cyc, 1)
			if promoEffect == 0 {
				charHappiness[gamChar[slot]] -= 5
				charReputation[gamChar[slot]] += 1
				charSentence[gamChar[slot]] += 1
				statTim[6] = -50
				ChangeRelationship(pChar[cyc], pChar[v], -1)
				gamMission[slot] = 0
				gamClient[slot] = 0
				promoEffect = 1
			}
			Outline(fmt.tprint("You ignored my advice, ", CellName(pChar[v], context.temp_allocator), "! Since you're not"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("making progress, i'll just extend your sentence...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 325 && promoTim < 9975 do promoTim = 9975
	}
	// 173. PHONE SUCCESS
	if gamPromo == 173 && GetClient(cyc, v) == 0 {
		if promoTim > 25 && promoTim < 325 {
			Speak(cyc, 3)
			if promoEffect == 0 {
				bb.PlaySound(sCash)
				statTim[7] = 50
				gamMoney[slot] += gamReward[slot]
				charHappiness[gamChar[slot]] += 10
				charReputation[gamChar[slot]] += 1
				gamMission[slot] = 0
				gamClient[slot] = 0
				promoEffect = 1
			}
			Outline("Nice work, my friend! You did what i asked.", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline(fmt.tprint("I've wired $", GetFigure(gamReward[slot], context.temp_allocator), " to your account as a reward..."), i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 325 && promoTim < 9975 do promoTim = 9975
	}
	// 173. PEER SUCCESS
	if gamPromo == 173 && GetClient(cyc, v) == 1 {
		if promoTim > 25 && promoTim < 325 {
			Speak(cyc, 3)
			if promoEffect == 0 {
				if gamMission[slot] == 10 {
					ChangeAnim(v, 25)
					ChangeAnim(cyc, 26)
				} else {
					MakeDeal(cyc, v)
				}
				bb.PlaySound(sCash)
				statTim[7] = 50
				gamMoney[slot] += gamReward[slot]
				charHappiness[gamChar[slot]] += 10
				charReputation[gamChar[slot]] += 1
				ChangeRelationship(pChar[cyc], pChar[v], 1)
				gamMission[slot] = 0
				gamClient[slot] = 0
				promoEffect = 1
			}
			Outline(fmt.tprint("Nice work, ", charName[pChar[v]], "! That really helped me out."), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline(fmt.tprint("You've earned every penny of this $", GetFigure(gamReward[slot], context.temp_allocator), " reward..."), i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 325 && promoTim < 9975 do promoTim = 9975
	}
	// 173. GANG SUCCESS
	if gamPromo == 173 && GetClient(cyc, v) == 2 {
		if promoTim > 25 && promoTim < 325 && charGang[pChar[cyc]] != 6 {
			Speak(cyc, 3)
			if promoEffect == 0 {
				if gamMission[slot] == 10 {
					ChangeAnim(v, 25)
					ChangeAnim(cyc, 26)
				} else {
					MakeDeal(cyc, v)
				}
				bb.PlaySound(sCash)
				statTim[7] = 50
				gamMoney[slot] += gamReward[slot]
				charHappiness[gamChar[slot]] += 10
				charReputation[gamChar[slot]] += 1
				ChangeRelationship(pChar[cyc], pChar[v], 1)
				gamMission[slot] = 0
				gamClient[slot] = 0
				promoEffect = 1
			}
			Outline(fmt.tprint("You've done the gang proud, ", charName[pChar[v]], "!"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline(fmt.tprint("Take $", GetFigure(gamReward[slot], context.temp_allocator), " as a reward for your efforts..."), i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 25 && promoTim < 325 && charGang[pChar[cyc]] == 6 {
			Speak(cyc, 3)
			if promoEffect == 0 {
				if gamMission[slot] == 10 {
					ChangeAnim(v, 25)
					ChangeAnim(cyc, 26)
				}
				charSentence[gamChar[slot]] -= 1
				statTim[6] = 50
				charHappiness[gamChar[slot]] += 10
				charReputation[gamChar[slot]] -= 1
				ChangeRelationship(pChar[cyc], pChar[v], 1)
				gamMission[slot] = 0
				gamClient[slot] = 0
				promoEffect = 1
			}
			Outline(fmt.tprint("You're on the right path, ", charName[pChar[v]], "! You"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("deserve to have a day taken off your sentence...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 325 && promoTim < 9975 do promoTim = 9975
	}
	// 173. WARDEN SUCCESS
	if gamPromo == 173 && GetClient(cyc, v) == 3 {
		if promoTim > 25 && promoTim < 325 {
			Speak(cyc, 3)
			if promoEffect == 0 {
				if gamMission[slot] == 10 {
					ChangeAnim(v, 25)
					ChangeAnim(cyc, 26)
				}
				charHappiness[gamChar[slot]] += 10
				charReputation[gamChar[slot]] -= 1
				charSentence[gamChar[slot]] -= 1
				statTim[6] = 50
				if charRelation[pChar[cyc]][pChar[v]] < 0 do ChangeRelationship(pChar[cyc], pChar[v], 0)
				gamMission[slot] = 0
				gamClient[slot] = 0
				promoEffect = 1
			}
			Outline(fmt.tprint("Nice work, ", CellName(pChar[v], context.temp_allocator), "! Since you're making progress,"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("i'll have a day taken off your sentence...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 325 && promoTim < 9975 do promoTim = 9975
	}
	// 174. MISSED DEADLINE
	if gamPromo == 174 {
		if promoTim > 25 && promoTim < 325 {
			Speak(cyc, 1)
			if promoEffect == 0 {
				charHappiness[pChar[cyc]] -= 5
				charReputation[pChar[cyc]] -= 1
				promoEffect = 1
			}
			Outline(fmt.tprint("Damn, i've missed the ", gamDeadline[slot], ":00 deadline!"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			if gamClient[slot] == 0 do Outline("That guy on the phone won't be happy...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
			if gamClient[slot] > 0 do Outline(fmt.tprint(charName[gamClient[slot]], " is gonna give me hell..."), i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 325 && promoTim < 9975 do promoTim = 9975
	}
	// 175. DELIVERED GIVEN ITEM
	if gamPromo == 175 {
		if promoTim > 25 && promoTim < 325 {
			Speak(cyc, 3)
			if pWeapon[cyc] > 0 && pAnim[cyc] < 20 {
				ChangeAnim(cyc, 25)
				ChangeAnim(v, 26)
			}
			Outline(fmt.tprint("Hey, ", charName[pChar[v]], ", ", charName[gamClient[slot]], " asked me"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline(fmt.tprint("to deliver this ", strings.to_lower(weapName[gamItem[slot]], context.temp_allocator), " to you..."), i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 350 && promoTim < 650 {
			Speak(v, 3)
			if promoEffect == 0 {
				charHappiness[pChar[cyc]] = charHappiness[pChar[cyc]] + 5
				charReputation[pChar[cyc]] = charReputation[pChar[cyc]] + 1
				ChangeRelationship(pChar[cyc], pChar[v], 1)
				promoEffect = 1
			}
			Outline(fmt.tprint("Oh, thanks! I gave the money to ", charName[gamClient[slot]], ","), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("so i guess you should ask him for your cut...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 650 && promoTim < 9975 {
			promoTim = 9975
			// promoUsed[gamPromo] = 1
		}
	}

	// 176. FOUND & DELIVERED ITEM
	if gamPromo == 176 {
		if promoTim > 25 && promoTim < 325 {
			Speak(cyc, 3)
			if pWeapon[cyc] > 0 && pAnim[cyc] < 20 {
				ChangeAnim(cyc, 25)
				ChangeAnim(v, 26)
			}
			if gamClient[slot] > 0 {
				Outline(fmt.tprint("Hey, ", charName[pChar[v]], ", ", charName[gamClient[slot]], " asked me"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
				Outline(fmt.tprint("to deliver this ", strings.to_lower(weapName[gamItem[slot]], context.temp_allocator), " to you..."), i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
			} else {
				Outline(fmt.tprint("Hey, ", charName[pChar[v]], ", i received a call asking"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
				Outline(fmt.tprint("me to deliver this ", strings.to_lower(weapName[gamItem[slot]], context.temp_allocator), " to you..."), i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
			}
		}
		if promoTim > 350 && promoTim < 650 {
			Speak(v, 3)
			if promoEffect == 0 {
				bb.PlaySound(sCash)
				statTim[7] = 50
				gamMoney[slot] += gamReward[slot]
				charHappiness[pChar[cyc]] += 10
				charReputation[pChar[cyc]] += 1
				ChangeRelationship(pChar[cyc], pChar[v], 1)
				gamMission[slot] = 0
				promoEffect = 1
			}
			Outline(fmt.tprint("Oh, thanks! I was going to pay him $", GetFigure(gamReward[slot], context.temp_allocator), ","), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("but i guess that money should go to you now...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 650 && promoTim < 9975 {
			promoTim = 9975
			// promoUsed[gamPromo] = 1
		}
	}

	// 177. MET CHARACTER
	if gamPromo == 177 {
		if promoTim > 25 && promoTim < 325 {
			Speak(cyc, 3)
			if gamClient[slot] > 0 {
				Outline(fmt.tprint("Hey, ", charName[pChar[v]], ", do you know ", charName[gamClient[slot]], "?"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
				Outline("He asked me to get a message to you...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
			} else {
				Outline(fmt.tprint("Hey, ", charName[pChar[v]], ", i received a call from"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
				Outline("someone asking me to meet you here...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
			}
		}
		if promoTim > 350 && promoTim < 650 {
			Speak(v, 3)
			if promoEffect == 0 {
				charHappiness[pChar[cyc]] += 5
				charReputation[pChar[cyc]] += 1
				ChangeRelationship(pChar[cyc], pChar[v], 1)
				promoEffect = 1
			}
			Outline("Yeah, i know what that's about! Thanks for the", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("message. Go back and tell him everything's fine...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 650 && promoTim < 9975 {
			promoTim = 9975
			// promoUsed[gamPromo] = 1
		}
	}

	// 178. IDENTIFIED CHARACTER
	if gamPromo == 178 {
		if promoTim > 25 && promoTim < 325 {
			Speak(cyc, 3)
			if gamClient[slot] > 0 {
				Outline(fmt.tprint("Hey, are you from Cell ", charCell[pChar[v]], " of the ", textBlock[charBlock[pChar[v]]], " Block?"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
				Outline(fmt.tprint(charName[gamClient[slot]], " has been looking for you..."), i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
			} else {
				Outline(fmt.tprint("Hey, are you from Cell ", charCell[pChar[v]], " of the ", textBlock[charBlock[pChar[v]]], " Block?"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
				Outline("Someone on the phone was asking after for you...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
			}
		}
		if promoTim > 350 && promoTim < 650 {
			Speak(v, 3)
			if promoEffect == 0 {
				charHappiness[pChar[cyc]] += 5
				charReputation[pChar[cyc]] += 1
				ChangeRelationship(pChar[cyc], pChar[v], 1)
				promoEffect = 1
			}
			Outline(fmt.tprint("Yeah, my name is ", charName[pChar[v]], "! Thanks for the"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("message. Go back and tell him i'm on the way...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoTim > 650 && promoTim < 9975 {
			promoTim = 9975
			// promoUsed[gamPromo] = 1
		}
	}
	if gamPromo == 179 {
		// intro
		optionA = strings.clone("Yes, abort mission...", context.allocator)
		optionB = strings.clone("No, forget it!", context.allocator)
		
		if promoStage == 0 && promoTim > 25 && promoTim < 325 && gamClient[slot] == 0 {
			Speak(cyc, 1)
			Outline(fmt.tprint("Hey, ", CellName(pChar[v], context.temp_allocator), ", i hear you're running errands"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("for some guy on the other end of a phone?", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoStage == 0 && promoTim > 25 && promoTim < 325 && gamClient[slot] > 0 {
			Speak(cyc, 1)
			Outline(fmt.tprint("Hey, ", CellName(pChar[v], context.temp_allocator), ", a little bird tells me that"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline(fmt.tprint("you're running errands for ", charName[gamClient[slot]], "?"), i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoStage == 0 && promoTim > 350 && promoTim < 650 {
			Speak(cyc, 1)
			Outline("The only orders you have to obey are MINE!", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("Give up this nonsense before i get suspicious...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
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
				if charRelation[pChar[cyc]][pChar[v]] < 0 do ChangeRelationship(pChar[cyc], pChar[v], 0)
				CompleteMission(-1)
				promoEffect = 1
			}
			Outline("Good for you! He never really cared about you.", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("He was just using you to do his dirty work...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoStage == 3 && promoTim > 325 && promoTim < 625 {
			Speak(cyc, 1)
			if promoEffect == 0 {
				charReputation[pChar[v]] += 1
				ChangeRelationship(pChar[cyc], pChar[v], -1)
				randy := bb.RndI(0, 5)
				if randy == 0 && gamWarrant[slot] < 1 do gamWarrant[slot] = 1
				if randy == 1 && charGang[pChar[v]] > 0 && gamWarrant[slot] < 2 do gamWarrant[slot] = 2
				promoEffect = 1
			}
			Outline("Whatever they're paying you, it's not worth it!", i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
			Outline("I'll make sure you never leave this place...", i32(rX(400)), i32(rY(560)), 30, 30, 30, 250, 250, 250)
		}
		if promoStage >= 2 && promoTim > 625 && promoTim < 9975 {
			promoTim = 9975
			promoUsed[gamPromo] = 1
		}
	}
	mem.end_arena_temp_memory(checkpoint)
}

//-----------------------------------------------------------------
//////////////////////// RELATED FUNCTIONS ////////////////////////
//-----------------------------------------------------------------

// ASSESS CLIENT TYPE
GetClient :: proc(cyc, v: i32) -> i32 {
	// phone by default
	if cyc > 0 && v > 0 {
		// peer
		if charRole[pChar[cyc]] == 0 do return 1
		// gang member
		if charRole[pChar[cyc]] == 0 && charGang[pChar[cyc]] > 0 && charGang[pChar[cyc]] == charGang[pChar[v]] do return 2
		// warden
		if charRole[pChar[cyc]] == 1 do return 3
	}
	return 0
}


// ASSIGN MISSION
AssignMission :: proc(cyc, mission: i32) {
	gamMission[slot] = mission
	if cyc > 0 {
		gamClient[slot] = pChar[cyc]
	} else {
		gamClient[slot] = 0
	}
	gamDeadline[slot] = gamHours[slot]
	gamReward[slot] = 100
	promoUsed[171] = 1
}


// CHECK MISSIONS
CheckMissions :: proc() {
	if gamMission[slot] > 0 && gamPromo != 172 && gamPromo != 173 \
	&& charPromo[gamClient[slot]][gamChar[slot]] != 172 \
	&& charPromo[gamClient[slot]][gamChar[slot]] != 173 \
	&& phonePromo != 172 && phonePromo != 173 {
		// failed
		result: i32 = 0
		if gamHours[slot] == gamDeadline[slot] && gamMins[slot] == 0 && gamSecs[slot] == 0 {
			result = 1 if gamMission[slot] == 18 else -1
			if result == -1 && gamPromo == 0 do TriggerPromo(gamPlayer[slot], 0, 174)
			statTim[5] = 50
		}
		// completions
		if (charLocation[gamClient[slot]] == gamLocation[slot] \
		&& cast(bool)InProximity(gamPlayer[slot], charPlayer[gamClient[slot]], 30)) || gamClient[slot] <= 0 {
			if gamMission[slot] == 1 && charStrength[gamChar[slot]] >= gamTarget[slot] do result = 1 // acquired strength 
			if gamMission[slot] == 2 && charAgility[gamChar[slot]] >= gamTarget[slot] do result = 1 // acquired agility  
			if gamMission[slot] == 3 && charIntelligence[gamChar[slot]] >= gamTarget[slot] do result = 1 // acquired intelligence 
			if gamMission[slot] == 4 && charReputation[gamChar[slot]] >= gamTarget[slot] do result = 1 // acquired reputation  
			if gamMission[slot] == 5 && charReputation[gamChar[slot]] <= gamTarget[slot] do result = 1 // reduced reputation
			if gamMission[slot] >= 6 && gamMission[slot] <= 7 && gamMoney[slot] >= gamTarget[slot] do result = 1 // acquired bank balance
			if gamMission[slot] == 8 && charHairStyle[gamChar[slot]] == gamTarget[slot] do result = 1 // changed hairstyle
			if gamMission[slot] == 9 && charCostume[gamChar[slot]] == gamTarget[slot] do result = 1 // changed costume
			if gamMission[slot] == 10 && weapType[pWeapon[gamPlayer[slot]]] == gamTarget[slot] do result = 1 // acquired item
			if gamMission[slot] == 20 && charGang[gamChar[slot]] == gamTarget[slot] do result = 1 // joined gang
		}
		// deliveries
		if gamMission[slot] == 11 || gamMission[slot] == 12 {
			if charLocation[gamTarget[slot]] == gamLocation[slot] \
			&& cast(bool)InProximity(gamPlayer[slot], charPlayer[gamTarget[slot]], 30) \
			&& weapType[pWeapon[gamPlayer[slot]]] == gamItem[slot] {
				if gamMission[slot] == 11 do charPromo[gamChar[slot]][gamTarget[slot]] = 175
				if gamMission[slot] == 12 do charPromo[gamChar[slot]][gamTarget[slot]] = 176
				result = 1
			}
		}
		// meetings
		if gamMission[slot] == 16 || gamMission[slot] == 17 {
			if charLocation[gamTarget[slot]] == gamLocation[slot] \
			&& cast(bool)InProximity(gamPlayer[slot], charPlayer[gamTarget[slot]], 30) {
				if gamMission[slot] == 16 do charPromo[gamChar[slot]][gamTarget[slot]] = 177
				if gamMission[slot] == 17 do charPromo[gamChar[slot]][gamTarget[slot]] = 178
				result = 1
			}
		}
		// failed to gaurd
		if gamMission[slot] == 18 {
			if charLocation[gamClient[slot]] != gamLocation[slot] \
			|| InProximity(gamPlayer[slot], charPlayer[gamClient[slot]], 100) == 0 {
				result = -1
			}
		}
		// trigger reactions
		if result != 0 do CompleteMission(result)
	}
}


// COMPLETE MISSION
CompleteMission :: proc(result: i32) {
	if gamMission[slot] > 0 {
		if gamClient[slot] > 0 {
			// client reactions
			if result == -1 do charPromo[gamClient[slot]][gamChar[slot]] = 172
			if result == 1 do charPromo[gamClient[slot]][gamChar[slot]] = 173
		} else {
			// phone reactions
			if result == -1 do phonePromo = 172
			if result == 1 do phonePromo = 173
		}
	}
}


// GET PROMO MONEY
GetPromoMoney :: proc(factor: i32) -> i32 {
	// randomized figure
	value := bb.RndI(gamMoney[slot] / 5, gamMoney[slot])
	value = value / factor
	// limits
	if value < 100 / factor do value = 100 / factor
	if value > 1000 do value = 1000
	value = RoundOff(value, 10)
	if value > gamMoney[slot] do value = gamMoney[slot]
	return value
}


// GET PHONE PROMO
GetPhonePromo :: proc() {
	// wrong number by default
	phonePromo = 63
	// social calls
	randy := bb.RndI(0, 5)
	if randy == 0 do phonePromo = 64 // friend calls
	if randy == 1 do phonePromo = 65 // family calls
	// sentence reduction
	randy = bb.RndI(0, 25)
	if randy == 0 && gamMoney[slot] > 100 && charSentence[gamChar[slot]] >= 7 do phonePromo = 66 // lawyer shaves a day
	if randy == 1 && gamMoney[slot] > 1000 && charSentence[gamChar[slot]] >= 12 do phonePromo = 24 // lawyer shaves a week
	if randy == 2 && charGang[gamChar[slot]] > 0 && charSentence[gamChar[slot]] >= 12 do phonePromo = 67 // gang shaves a day
	// media offers
	randy = bb.RndI(0, 25)
	if randy == 0 do phonePromo = 68 // sell story to journalist
	if randy == 1 do phonePromo = 69 // sell story to filmmaker
	if randy == 2 do phonePromo = 261 // human rights donation
	// mission assignments
	randy = bb.RndI(0, 50)
	if gamMission[slot] == 0 {
		if randy == 1 do phonePromo = 152
		if randy == 2 do phonePromo = 153
		if randy == 3 do phonePromo = 154
		if randy == 4 do phonePromo = 155
		if randy == 5 do phonePromo = 156
		if randy == 6 do phonePromo = 157
		if randy == 7 do phonePromo = 160
	}
	// bomb threat
	randy = bb.RndI(0, 50)
	if randy == 0 do phonePromo = 208
	// mission reminder
	if gamMission[slot] > 0 && gamClient[slot] == 0 do phonePromo = 171
	// avoid recently used
	if phonePromo != 63 && promoUsed[phonePromo] != 0 do phonePromo = 63
}


// EXCHANGE MONEY
MakeDeal :: proc(cyc, v: i32) {
	if pAnim[cyc] < 20 do ChangeAnim(cyc, 99)
	if pAnim[v] < 20 do ChangeAnim(v, 99)
}


// FIND VIOLENT MISSION VICTIM
FindVictim :: proc(cyc, v: i32) -> i32 {
	// find ideal character
	victim: i32
	its := 0
	for {
		conflict := 0
		its += 1
		victim = bb.RndI(1, no_chars)
		if cyc > 0 {
			if victim == pChar[cyc] || charRelation[pChar[cyc]][victim] > 0 do conflict = 1
		}
		if victim == pChar[v] do conflict = 1
		if charLocation[victim] == 0 || charRole[victim] == 2 do conflict = 1
		if charSnapped[victim] == 0 && its < 100 do conflict = 1
		if conflict == 0 do break
	}
	// set as enemy
	if cyc > 0 {
		ChangeRelationship(pChar[cyc], victim, -1)
	}
	return victim
}


// RUIN MISSION (when key character leaves)
RuinMission :: proc(char: i32) {
	if gamMission[slot] > 0 {
		// client gone
		if char == gamClient[slot] do gamMission[slot] = 0
		// target gone
		if char == gamTarget[slot] {
			if gamMission[slot] >= 13 && gamMission[slot] <= 15 do CompleteMission(1)
			if gamMission[slot] == 11 || gamMission[slot] == 12 || gamMission[slot] == 16 || gamMission[slot] == 17 do CompleteMission(-1)
		}
	}
}
