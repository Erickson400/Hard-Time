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



	mem.end_arena_temp_memory(checkpoint)
}

// up to 471


CompleteMission :: proc(result: i32) {

}

RuinMission :: proc(char: i32) {

}

GetPromoMoney :: proc(num: i32) -> i32 {
	return 0
}

MakeDeal :: proc(cyc, v: i32) {
	
}

GetClient :: proc(cyc, v: i32) -> i32 {
	return 0
}

AssignMission :: proc(cyc, mission: i32) {
	
}

FindVictim :: proc(cyc, v: i32) -> i32 {
	return 0
}