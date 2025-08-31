package main
////////////////////////////////////////////////////////////////////////////////
//---------------------------- HARD TIME: DATA ---------------------------------
////////////////////////////////////////////////////////////////////////////////

import bb "blitzbasic3d"
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






