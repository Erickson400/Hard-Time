package main
////////////////////////////////////////////////////////////////////////////////
//---------------------------- HARD TIME: DATA ---------------------------------
////////////////////////////////////////////////////////////////////////////////

import bb "blitzbasic3d"
import "core:strings"
import "core:slice"
import "core:fmt"
import "core:os"
import "core:mem"

//------------------------------------------------------------------------
/////////////////////////////// OPTIONS //////////////////////////////////
//------------------------------------------------------------------------

DATA_FOLDER :: "assets/Data/"


SaveOptions :: proc() {
    file := bb.WriteFile(DATA_FOLDER + "Options.dat")
    // Preferences
    bb.WriteInt(file, optRes)
    bb.WriteInt(file, optPopulation)
    bb.WriteInt(file, optFog)
    bb.WriteInt(file, optShadows)
    bb.WriteInt(file, optFX)
    bb.WriteInt(file, optGore)
    // Key controls
    bb.WriteInt(file, keyAttack)
    bb.WriteInt(file, keyDefend)
    bb.WriteInt(file, keyThrow)
    bb.WriteInt(file, keyPickUp)
    // Gamepad controls
    bb.WriteInt(file, buttAttack)
    bb.WriteInt(file, buttDefend)
    bb.WriteInt(file, buttThrow)
    bb.WriteInt(file, buttPickUp)
    // Game ID's
    for count in 1..=3 {
        bb.WriteString(file, gamName[count])
    }
    bb.CloseFile(file)
}


LoadOptions :: proc() {
    file := bb.WriteFile(DATA_FOLDER + "Options.dat")
    // Preferences
    optRes = bb.ReadInt(file)
    optPopulation = bb.ReadInt(file)
    optFog = bb.ReadInt(file)
    optShadows = bb.ReadInt(file)
    optFX = bb.ReadInt(file)
    optGore = bb.ReadInt(file)
    // Key controls
    keyAttack = bb.ReadInt(file)
    keyDefend = bb.ReadInt(file)
    keyThrow = bb.ReadInt(file)
    keyPickUp = bb.ReadInt(file)
    // Gamepad controls
    buttAttack = bb.ReadInt(file)
    buttDefend = bb.ReadInt(file)
    buttThrow = bb.ReadInt(file)
    buttPickUp = bb.ReadInt(file)
    // Game ID's
    for count in 1..=3 {
        gamName[count] = bb.ReadString(file)
    }
    bb.CloseFile(file)
}


//------------------------------------------------------------------------
/////////////////////////////// PROGRESS /////////////////////////////////
//------------------------------------------------------------------------
SaveProgress :: proc() {
    filepath := fmt.aprintf("%sslot0%d/Progress.dat", DATA_FOLDER, slot)
    defer delete(filepath)
    file := bb.WriteFile(filepath)
    // Status
    bb.WriteInt(file, no_chars)
    bb.WriteInt(file, gamChar[slot])
    bb.WriteInt(file, gamPlayer[slot])
    bb.WriteInt(file, gamLocation[slot])
    bb.WriteInt(file, gamMoney[slot])
    // Time
    bb.WriteInt(file, gamSpeed[slot])
    bb.WriteInt(file, gamSecs[slot])
    bb.WriteInt(file, gamMins[slot])
    bb.WriteInt(file, gamHours[slot])
    // Missions
    bb.WriteInt(file, gamMission[slot])
    bb.WriteInt(file, gamClient[slot])
    bb.WriteInt(file, gamTarget[slot])
    bb.WriteInt(file, gamDeadline[slot])
    bb.WriteInt(file, gamReward[slot])
    // Handles
    bb.WriteInt(file, gamWarrant[slot])
    bb.WriteInt(file, gamVictim[slot])
    bb.WriteInt(file, gamItem[slot])
    bb.WriteInt(file, gamArrival[slot])
    bb.WriteInt(file, gamFatality[slot])
    bb.WriteInt(file, gamRelease[slot])
    bb.WriteInt(file, gamEscape[slot])
    bb.WriteInt(file, gamGrowth[slot])
    bb.WriteInt(file, gamBlackout[slot])
    bb.WriteInt(file, gamBombThreat[slot])
    // Promos
    bb.WriteInt(file, phonePromo)
    for count in 1..=300 {
        bb.WriteInt(file, promoUsed[count])
    }
    // Camera
    bb.WriteFloat(file, camX)
    bb.WriteFloat(file, camY)
    bb.WriteFloat(file, camZ)
    bb.WriteFloat(file, camPivX)
    bb.WriteFloat(file, camPivY)
    bb.WriteFloat(file, camPivZ)
    // Atmosphere
    bb.WriteFloat(file, lightR)
    bb.WriteFloat(file, lightG)
    bb.WriteFloat(file, lightB)
    bb.WriteFloat(file, ambR)
    bb.WriteFloat(file, ambG)
    bb.WriteFloat(file, ambB)
    bb.WriteFloat(file, atmosR)
    bb.WriteFloat(file, atmosG)
    bb.WriteFloat(file, atmosB)
    bb.WriteFloat(file, skyR)
    bb.WriteFloat(file, skyG)
    bb.WriteFloat(file, skyB)
    // Dinner trays
    for count in 1..=50 {
        bb.WriteInt(file, trayState[count])
    }
    bb.CloseFile(file)
}


LoadProgress :: proc() {
    filepath := fmt.aprintf("%sslot0%d/Progress.dat", DATA_FOLDER, slot)
    defer delete(filepath)
    file := bb.ReadFile(filepath)
    // Status
    no_chars = bb.ReadInt(file)
    gamChar[slot] = bb.ReadInt(file)
    gamPlayer[slot] = bb.ReadInt(file)
    gamLocation[slot] = bb.ReadInt(file)
    gamMoney[slot] = bb.ReadInt(file)
    // Time
    gamSpeed[slot] = bb.ReadInt(file)
    gamSecs[slot] = bb.ReadInt(file)
    gamMins[slot] = bb.ReadInt(file)
    gamHours[slot] = bb.ReadInt(file)
    // Missions
    gamMission[slot] = bb.ReadInt(file)
    gamClient[slot] = bb.ReadInt(file)
    gamTarget[slot] = bb.ReadInt(file)
    gamDeadline[slot] = bb.ReadInt(file)
    gamReward[slot] = bb.ReadInt(file)
    // Handles
    gamWarrant[slot] = bb.ReadInt(file)
    gamVictim[slot] = bb.ReadInt(file)
    gamItem[slot] = bb.ReadInt(file)
    gamArrival[slot] = bb.ReadInt(file)
    gamFatality[slot] = bb.ReadInt(file)
    gamRelease[slot] = bb.ReadInt(file)
    gamEscape[slot] = bb.ReadInt(file)
    gamGrowth[slot] = bb.ReadInt(file)
    gamBlackout[slot] = bb.ReadInt(file)
    gamBombThreat[slot] = bb.ReadInt(file)
    // Promos
    phonePromo = bb.ReadInt(file)
    for count in 1..=300 {
        promoUsed[count] = bb.ReadInt(file)
    }
    // Camera
    camX = bb.ReadFloat(file)
    camY = bb.ReadFloat(file)
    camZ = bb.ReadFloat(file)
    camPivX = bb.ReadFloat(file)
    camPivY = bb.ReadFloat(file)
    camPivZ = bb.ReadFloat(file)
    // Atmosphere
    lightR = bb.ReadFloat(file)
    lightG = bb.ReadFloat(file)
    lightB = bb.ReadFloat(file)
    ambR = bb.ReadFloat(file)
    ambG = bb.ReadFloat(file)
    ambB = bb.ReadFloat(file)
    atmosR = bb.ReadFloat(file)
    atmosG = bb.ReadFloat(file)
    atmosB = bb.ReadFloat(file)
    skyR = bb.ReadFloat(file)
    skyG = bb.ReadFloat(file)
    skyB = bb.ReadFloat(file)
    // Dinner trays
    for count in 1..=50 {
        trayState[count] = bb.ReadInt(file)
    }
    bb.CloseFile(file)
}


//------------------------------------------------------------------------
////////////////////////////// CHARACTERS ////////////////////////////////
//------------------------------------------------------------------------
SaveChars :: proc() {
    for char in i32(1)..=no_chars {
        filepath := fmt.aprintf("%sslot0%d/Character%s.dat", DATA_FOLDER, slot, Dig(char, 100))
        defer delete(filepath)
        file := bb.WriteFile(filepath)
        // Appearance
        bb.WriteString(file, charName[char])
        bb.WriteInt(file, charSnapped[char])
        bb.WriteInt(file, charModel[char])
        bb.WriteInt(file, charHeight[char])
        bb.WriteInt(file, charSpecs[char])
        bb.WriteInt(file, charAccessory[char])
        bb.WriteInt(file, charHairStyle[char])
        bb.WriteInt(file, charHair[char])
        bb.WriteInt(file, charFace[char])
        bb.WriteInt(file, charCostume[char])
        for count in i32(1)..=40 {
            bb.WriteInt(file, charScar[char][count])
        }
        // attributes
        bb.WriteInt(file, charHealth[char])
        bb.WriteInt(file, charHP[char])
        bb.WriteInt(file, charInjured[char])
        bb.WriteInt(file, charStrength[char])
        bb.WriteInt(file, charAgility[char])
        bb.WriteInt(file, charHappiness[char])
        bb.WriteInt(file, charBreakdown[char])
        bb.WriteInt(file, charIntelligence[char])
        bb.WriteInt(file, charReputation[char])
        bb.WriteInt(file, charWeapon[char])
        for count in i32(1)..=30 {
            bb.WriteInt(file, charWeapHistory[char][count])
        }
        // Status
        bb.WriteInt(file, charRole[char])
        bb.WriteInt(file, charSentence[char])
        bb.WriteInt(file, charCrime[char])
        bb.WriteInt(file, charLocation[char])
        bb.WriteInt(file, charBlock[char])
        bb.WriteInt(file, charCell[char])
        bb.WriteInt(file, charExperience[char])
        bb.WriteFloat(file, charX[char])
        bb.WriteFloat(file, charY[char])
        bb.WriteFloat(file, charZ[char])
        bb.WriteFloat(file, charA[char])
        // Relationships
        for gang in i32(1)..=6 {
            bb.WriteInt(file, charGangHistory[char][gang])
        }
        bb.WriteInt(file, charAttacker[char])
        bb.WriteInt(file, charWitness[char])
        bb.WriteInt(file, charPromoRef[char])
        bb.WriteInt(file, charFollowTim[char])
        bb.WriteInt(file, charBribeTim[char])
        for v in i32(1)..=no_chars {
            bb.WriteInt(file, charRelation[char][v])
            bb.WriteInt(file, charAngerTim[char][v])
            bb.WriteInt(file, charPromo[char][v])
        }
        bb.CloseFile(file)
    }
}


LoadChars :: proc() {
    for char in i32(1)..=no_chars {
        filepath := fmt.aprintf("%sslot0%d/Character%s.dat", DATA_FOLDER, slot, Dig(char, 100))
        defer delete(filepath)
        file := bb.ReadFile(filepath)
        // Appearance
        charName[char] = bb.ReadString(file)
        charSnapped[char] = bb.ReadInt(file)
        charModel[char] = bb.ReadInt(file)
        charHeight[char] = bb.ReadInt(file)
        charSpecs[char] = bb.ReadInt(file)
        charAccessory[char] = bb.ReadInt(file)
        charHairStyle[char] = bb.ReadInt(file)
        charHair[char] = bb.ReadInt(file)
        charFace[char] = bb.ReadInt(file)
        charCostume[char] = bb.ReadInt(file)
        for count in i32(1)..=40 {
            charScar[char][count] = bb.ReadInt(file)
        }
        // attributes
        charHealth[char] = bb.ReadInt(file)
        charHP[char] = bb.ReadInt(file)
        charInjured[char] = bb.ReadInt(file)
        charStrength[char] = bb.ReadInt(file)
        charAgility[char] = bb.ReadInt(file)
        charHappiness[char] = bb.ReadInt(file)
        charBreakdown[char] = bb.ReadInt(file)
        charIntelligence[char] = bb.ReadInt(file)
        charReputation[char] = bb.ReadInt(file)
        charWeapon[char] = bb.ReadInt(file)
        for count in i32(1)..=30 {
            charWeapHistory[char][count] = bb.ReadInt(file)
        }
        // Status
        charRole[char] = bb.ReadInt(file)
        charSentence[char] = bb.ReadInt(file)
        charCrime[char] = bb.ReadInt(file)
        charLocation[char] = bb.ReadInt(file)
        charBlock[char] = bb.ReadInt(file)
        charCell[char] = bb.ReadInt(file)
        charExperience[char] = bb.ReadInt(file)
        charX[char] = bb.ReadFloat(file)
        charY[char] = bb.ReadFloat(file)
        charZ[char] = bb.ReadFloat(file)
        charA[char] = bb.ReadFloat(file)
        // Relationships
        for gang in i32(1)..=6 {
            charGangHistory[char][gang] = bb.ReadInt(file)
        }
        charAttacker[char] = bb.ReadInt(file)
        charWitness[char] = bb.ReadInt(file)
        charPromoRef[char] = bb.ReadInt(file)
        charFollowTim[char] = bb.ReadInt(file)
        charBribeTim[char] = bb.ReadInt(file)
        for v in i32(1)..=no_chars {
            charRelation[char][v] = bb.ReadInt(file)
            charAngerTim[char][v] = bb.ReadInt(file)
            charPromo[char][v] = bb.ReadInt(file)
        }
        bb.CloseFile(file)
    }
}


LoadPhotos :: proc() {
    Loader("Please Wait","Loading Photos")
    for char in i32(1)..=no_chars {
        charPhoto[char] = 0
        if charSnapped[char] > 0 {
            path := fmt.aprintf("%sSlot0%s/Photo/Photo%s.bmp", DATA_FOLDER, slot, Dig(char, 100))
            defer delete(path)
            charSnapped[char] = bb.LoadImage(path)
            if charPhoto[char] > 0 do bb.MaskImage(charPhoto[char], 255, 0, 255)
            if charPhoto[char] == 0 do charSnapped[char] = 0
        }
    }
}


SavePhotos :: proc() {
    if charHealth[gamChar[slot]] > 0 do Loader("Please Wait","Saving Photos")
    for char in i32(1)..=no_chars {
        path := fmt.aprintf("%sSlot0%s/Photo/Photo%s.bmp", DATA_FOLDER, slot, Dig(char, 100))
        defer delete(path)
        bb.SaveImage(charPhoto[char], path)
    }
}


//------------------------------------------------------------------------
//////////////////////////////// WEAPONS /////////////////////////////////
//------------------------------------------------------------------------
SaveItems :: proc() {
    path := fmt.aprintf("%sSlot0%s/Items.dat", DATA_FOLDER, slot)
    defer delete(path)
    file := bb.WriteFile(path)
    // Weapons
    bb.WriteInt(file, no_weaps)
    for cyc in i32(1)..=no_weaps {
        bb.WriteInt(file, weapType[cyc])
        bb.WriteInt(file, weapState[cyc])
        bb.WriteInt(file, weapLocation[cyc])
        bb.WriteFloat(file, weapX[cyc])
        bb.WriteFloat(file, weapY[cyc])
        bb.WriteFloat(file, weapZ[cyc])
        bb.WriteFloat(file, weapA[cyc])
        bb.WriteInt(file, weapCarrier[cyc])
        bb.WriteInt(file, weapClip[cyc])
        bb.WriteInt(file, weapAmmo[cyc])
        bb.WriteInt(file, weapScar[cyc])
    }
    // kits
    for count in 1..=6 {
        bb.WriteInt(file, kitType[count])
        bb.WriteInt(file, kitState[count])
    }
    bb.CloseFile(file)
}


LoadItems :: proc() {
    path := fmt.aprintf("%sSlot0%s/Items.dat", DATA_FOLDER, slot)
    defer delete(path)
    file := bb.ReadFile(path)
    // Weapons
    no_weaps = bb.ReadInt(file)
    for cyc in i32(1)..=no_weaps {
        weapType[cyc] = bb.ReadInt(file)
        weapState[cyc] = bb.ReadInt(file)
        weapLocation[cyc] = bb.ReadInt(file)
        weapX[cyc] = bb.ReadFloat(file)
        weapY[cyc] = bb.ReadFloat(file)
        weapZ[cyc] = bb.ReadFloat(file)
        weapA[cyc] = bb.ReadFloat(file)
        weapCarrier[cyc] = bb.ReadInt(file)
        weapClip[cyc] = bb.ReadInt(file)
        weapAmmo[cyc] = bb.ReadInt(file)
        weapScar[cyc] = bb.ReadInt(file)
    }
    // kits
    for count in 1..=6 {
        kitType[count] = bb.ReadInt(file)
        kitState[count] = bb.ReadInt(file)
    }
    bb.CloseFile(file)
}


//////////////////////////////////////////////////////////////////
//---------------------- RELATED FUNCTIONS -----------------------
//////////////////////////////////////////////////////////////////
GenerateGame :: proc() {

}


GenerateCharacter :: proc(char, role: i32) {
    
}


GenerateWeapon :: proc(cyc, style, area: i32, x, y, z: f32) {
    // Type
    weapType[cyc] = style
    if weapType[cyc] == 0 {
        weapType = bb.Rnd(1, weapList)
        randy := bb.Rnd(1, 20)
        if randy == 1 do weapType[cyc] = bb.Rnd(24, 25)
        if randy == 2 do weapType[cyc] = 15
        if randy >= 3 && randy <= 5 do weapType[cyc] = 16
        if randy >= 6 && randy <= 8 do weapType[cyc] = bb.Rnd(16, 18)
    }
    // General location
    weapLocation[cyc] = area
    if area == 0 {
        randy := bb.Rnd(0, 20)
        if randy <= 1 do weapLocation[cyc] = 1
        if randy >= 2 && randy <= 4 do weapLocation[cyc] = 2
        if randy >= 4 && randy <= 5 do weapLocation[cyc] = 3
        if randy == 6 do weapLocation[cyc] = 4
        if randy >= 7 && randy <= 8 do weapLocation[cyc] = 5
        if randy == 9 do weapLocation[cyc] = 6
        if randy >= 10 && randy <= 11 do weapLocation[cyc] = 7
        if randy >= 12 && randy <= 13 do weapLocation[cyc] = 8
        if randy >= 14 && randy <= 15 do weapLocation[cyc] = 9
        if randy == 17 do weapLocation[cyc] = 10
        if randy >= 18 && randy <= 20 do weapLocation[cyc] = 11
    }
    randy := bb.Rnd(0, 4)
    if randy == 0 && style == 0 && area == 0 do weapLocation[cyc] = 0
    // Favour habitat
    if weapLocation[cyc] > 0 && GetBlock(weapLocation[cyc]) == 0 && weapType[cyc] != 16 {
        randy := bb.Rnd(0, 2)
        if randy > 0 && weapHabitat[weapType[cyc]] > 0 && weapHabitat[weapType[cyc]] != 99 {
            weapLocation[cyc] = weapHabitat[weapType[cyc]]
        }
        if randy > 0 && weapType[cyc] == 14 do weapLocation[cyc] = 2
        if randy == 0 && weapType[cyc] >= 24 && weapType[cyc] <= 25 do weapLocation[cyc] = 11
    }
    // Pinpoint location
    weapX[cyc] = x; weapY[cyc] = y; weapZ[cyc] = z; 
    weapA[cyc] = bb.Rnd(0.0, 360.0)
    if weapY[cyc] == 0 && weapY[cyc] == 0 && weapZ[cyc] == 0 {
        weapX[cyc] = 50
        // Cell block locations
        if GetBlock(weapLocation[cyc]) > 0 {
            randy = bb.Rnd(0, 9)
            if randy <= 5 {
                for {
                    weapX[cyc] = bb.Rnd(-300.0, 300.0); weapZ[cyc] = bb.Rnd(-140.0, 350.0) 
                    if randy == 0 {
                        weapY[cyc] = 50
                    } else {
                        weapY[cyc] = 150
                    }
                    if InsideCell(weapX[cyc], weapY[cyc], weapZ[cyc]) > 0 do break
                }
                switch randy {
                    case 6:
                        weapX[cyc] = bb.Rnd(-190.0, 60.0); weapZ[cyc] = bb.Rnd(-140.0, 250.0) 
                    case 7:
                        weapX[cyc] = bb.Rnd(60.0, 190.0); weapZ[cyc] = bb.Rnd(-140.0, 250.0) 
                    case 8:
                        weapX[cyc] = bb.Rnd(-115.0, 115.0); weapZ[cyc] = bb.Rnd(-335.0, 15.0) 
                    case 9:
                        weapX[cyc] = bb.Rnd(-80.0, 80.0); weapZ[cyc] = bb.Rnd(-220.0, 350.0); weapY[cyc] = 150
                }
            }
            // Yard Locations
            if weapLocation[cyc] == 2 {
                randy := bb.Rnd(1, 2)
                switch randy {
                    case 1:
                        weapX[cyc] = bb.Rnd(-20.0, 475.0); weapZ[cyc] = bb.Rnd(-210.0, 475.0)
                    case 2:
                        weapX[cyc] = bb.Rnd(210.0, 475.0); weapZ[cyc] = bb.Rnd(-50.0, 475.0) 
                }
                if weapType[cyc] == 11 {
                    weapX[cyc] = bb.Rnd(210.0, 475.0); weapZ[cyc] = bb.Rnd(-50.0, 200.0) 
                }
                if weapType[cyc] == 14 {
                    weapX[cyc] = bb.Rnd(-30.0, 100.0); weapZ[cyc] = bb.Rnd(270.0, 425.0) 
                }
            }
            // Study locations
            if weapLocation[cyc] == 4 {
                randy := bb.Rnd(1, 5)
                switch randy {
                    case 1:
                        weapX[cyc] = bb.Rnd(-135.0, 135.0); weapZ[cyc] = bb.Rnd(-130.0, -40.0)
                    case 2:
                        weapX[cyc] = bb.Rnd(-120.0, 135.0); weapZ[cyc] = bb.Rnd(40.0, 120.0)
                    case 3:
                        weapX[cyc] = bb.Rnd(-120.0, -40.0); weapZ[cyc] = bb.Rnd(-135.0, 120.0)
                    case 4:
                        weapX[cyc] = bb.Rnd(40.0, 135.0); weapZ[cyc] = bb.Rnd(-125.0, 105.0)
                    case 5:
                        weapX[cyc] = bb.Rnd(-140.0, 140.0); weapZ[cyc] = bb.Rnd(-140.0, 140.0)
                }
                // Hospital locations
                // CONTINUE HERE
                
            }

        }


    }















}


GenerateName :: proc(char: i32, allocator := context.allocator) -> string {
    name: string
    for {
        name = fmt.aprintf("Character%s", Dig(char, 100), allocator = allocator)
        // Inmate
        if charRole[char] == 0 {
            randy := bb.Rnd(0, 1)
            random_index := bb.Rnd(0, 80)
            if randy == 0 || randy == 1 do delete(name)
            if randy == 0 do name = strings.clone(textNickName[random_index], allocator)
            if randy == 1 do name = fmt.aprint(textFirstName[random_index], " ", textSurName[bb.Rnd(0, 65)], allocator = allocator) 
        }
        // Officials
        if charRole[char] >= 1 {
            inclusions := [3]i32{1, 2, 3}
            if slice.contains(inclusions[:], charRole[char]) do delete(name, allocator)
            if charRole[char] == 1 do name = strings.clone("Warden ", allocator)
            if charRole[char] == 2 do name = strings.clone("Lawyer ", allocator)
            if charRole[char] == 3 do name = strings.clone("Judge ", allocator)
            name = strings.concatenate({name, textSurName[bb.Rnd(0, 65)]}, allocator)
        }
        // Find conflicts
        conflict := 0
        for v in 1..=no_chars {
            if charName[v] == name do conflict = 1
        }
        if conflict == 0 do break
        delete(name, allocator)
    }
    return name
}


AssignCell :: proc(char: i32) {
    its := 0
    for {
        its += 1
        satisfied := 1
        block := bb.Rnd(1, 4)
        cell := bb.Rnd(1, 20)
        if its < 10 && CellPopulation(block, cell) > 0 do satisfied = 0
        if CellPopulation(block, cell) > 1 do satisfied = 0
        if its < 10 && AreaPopulation(TranslateBlock(block), 0) >= optPopulation/5 do satisfied = 0
        if satisfied == 1 do break
    }
    charBlock[char] = block
    charCell[char] = cell
}


FindCellMates :: proc() {
    char := gamChar[slot]
    for v in 1..=no_chars {
        if v != char && 
        charRole[v] == 0 && 
        charCell[v] == charCell[char] && 
        charBlock[v] == charBlock[char] {
            randy := bb.Rnd(0, 2)
            if randy == 1 || (randy == 0 && charReputation[v] < charReputation[char]) {
                charPromo[v][char] = bb.Rnd(202, 203)
            }
            if randy == 2 || (randy == 0 && charReputation[v] >= charReputation[char]) {
                charPromo[v][char] = bb.Rnd(203, 204)
            }
        }
    }
}
