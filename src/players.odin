package main

import "core:fmt"
import bb "blitzbasic3d"

////////////////////////////////////////////////////////////////////////////////
//---------------------------- HARD TIME: PLAYERS ------------------------------
////////////////////////////////////////////////////////////////////////////////

//-----------------------------------------------------------------
////////////////////////// LOAD PLAYERS ///////////////////////////
//-----------------------------------------------------------------
LoadPlayers :: proc() {
    for cyc in 1..=no_plays {
        // generate model
        Loader("Please Wait", fmt.tprintf("Loading Character %d of %d", cyc, no_plays))
        p[cyc] = bb.LoadAnimMesh(fmt.tprintf("Characters/Models/Model%d.3ds", Dig(charModel[pChar[cyc]], 10)))
        LoadSequences(cyc)
        // appearance
        ApplyCostume(cyc)
        // restore scars 
        for limb in 1..=40 {
            pOldScar[cyc][limb] = -1
            pScar[cyc][limb] = charScar[pChar[cyc]][limb]
            if pLimb[cyc][limb] > 0 && pScar[cyc][limb] >= 5 {
                bb.HideEntity(pLimb[cyc][limb]);
            }
        }
        SeverLimbs(cyc)
        // hide weapons by default
        bb.HideEntity(bb.FindChild(p[cyc], "Phone"))
        bb.HideEntity(bb.FindChild(p[cyc], "Barbell"))
        for v in 1..=weapList {
            bb.HideEntity(bb.FindChild(p[cyc], weapFile[v]))
        }
        bb.EntityAlpha(bb.FindChild(p[cyc], "Bottle"), 0.9)
        bb.EntityShininess(bb.FindChild(p[cyc], "Phone"), 1.0)
        // location
        pX[cyc] = charX[pChar[cyc]]
        pZ[cyc] = charZ[pChar[cyc]]
        pOldX[cyc] = pX[cyc]
        pOldZ[cyc] = pZ[cyc]
        pTX[cyc] = pX[cyc]
        pTZ[cyc] = pZ[cyc]
        pA[cyc] = charA[pChar[cyc]]
        pTA[cyc] = pA[cyc]
        pY[cyc] = charY[pChar[cyc]] + 20
        pGravity[cyc] = 1.0
        bb.PositionEntity(p[cyc], pX[cyc], pY[cyc], pZ[cyc])
        bb.RotateEntity(p[cyc], 0, pA[cyc], 0)
        scaler := cast(f32)charHeight[pChar[cyc]] * 0.0025
        bb.ScaleEntity(p[cyc], 0.34 + scaler, 0.34 + scaler, 0.34 + scaler)
        bb.Animate(p[cyc], 1, 0.5, pSeq[cyc][1], 0)
        // collision detection
        pPivot[cyc] = bb.CreatePivot()
        bb.EntityType(pPivot[cyc], 1, 0)
        bb.EntityRadius(pPivot[cyc], 8, 18)
        bb.PositionEntity(pPivot[cyc], pX[cyc], pY[cyc] + 18, pZ[cyc])
        pMovePivot[cyc] = bb.CreatePivot()
        bb.EntityType(pMovePivot[cyc], 4, 0)
        bb.EntityRadius(pMovePivot[cyc], 8, 18)
        bb.PositionEntity(pMovePivot[cyc], pX[cyc], pY[cyc] + 18, pZ[cyc])
        // reset values
        pAnim[cyc] = 0
        pAnimTim[cyc] = 0
        pState[cyc] = 0
        pAgenda[cyc] = bb.Rnd(0, 2)
        pNowhere[cyc] = 99
        pSubX[cyc] = 9999
        pSubZ[cyc] = 9999
        pEyes[cyc] = 2
        pOldEyes[cyc] = -1
        pHealth[cyc] = cast(f32)charHealth[pChar[cyc]]
        pHP[cyc] = charHP[pChar[cyc]]
        pInjured[cyc] = charInjured[pChar[cyc]]
        pWeapon[cyc] = 0
        pPhone[cyc] = 0
        pSeat[cyc] = 0
        pBed[cyc] = 0
        pGrappling[cyc] = 0
        pGrappler[cyc] = 0
        for v in 1..=no_plays {
            pInteract[cyc][v] = 0
        }
        for v in 1..=no_chairs {
            pSeatFriction[cyc][v] = 0
        }
        for v in 1..=no_beds {
            pBedFriction[cyc][v] = 0
        }
        // shadows
        for limb in 1..=40 {
            pShadow[cyc][limb] = 0
            if limb == 30 || (optShadows == 2 && (limb == 1 || (limb >= 4 && limb <= 6) || (limb >= 17 && limb <= 19) || limb == 32 || limb == 33 || limb == 35 || limb == 36)) {
                pShadow[cyc][limb] = bb.LoadSprite("World/Sprites/Shadow.png", 2)
                bb.ScaleSprite(pShadow[cyc][limb], 13, 13)
                if limb != 30 do bb.ScaleSprite(pShadow[cyc][limb], 10, 10)
                if limb == 6 || limb == 19 || limb == 33 || limb == 36 do bb.ScaleSprite(pShadow[cyc][limb], 8, 8)
                bb.RotateEntity(pShadow[cyc][limb], 90, 0, 0)
                bb.SpriteViewMode(pShadow[cyc][limb], 2)
                bb.EntityColor(pShadow[cyc][limb], 10, 10, 10)
                bb.PositionEntity(pShadow[cyc][limb], pX[cyc], pY[cyc], pZ[cyc])
            }
        }
        // assess control 
        charPlayer[pChar[cyc]] = cyc
        pControl[cyc] = 0
        if pChar[cyc] == gamChar[slot] {
            pControl[cyc] = 3
            camFoc = cyc
            gamPlayer[slot] = cyc
        }
    }
}

//-----------------------------------------------------------------
/////////////////////////// PLAYER CYCLE //////////////////////////
//-----------------------------------------------------------------
PlayerCycle :: proc() {
    for cyc in 1..=no_plays {
        // counters
        pNowhere[cyc] -= 1
        if pNowhere[cyc] < 0 do pNowhere[cyc] = 0
        pSatisfied[cyc] -= 1
        if pSatisfied[cyc] < 0 do pSatisfied[cyc] = 0
        pRunTim[cyc] -= 1
        if pRunTim[cyc] < 0 do pRunTim[cyc] = 0
        // service timers
        if gamPromo == 0 do charFollowTim[pChar[cyc]] -= gamSpeed[slot]
        if charFollowTim[pChar[cyc]] < 0 || charRelation[pChar[cyc]][gamChar[slot]] < 0 {
            charFollowTim[pChar[cyc]] = 0
        }
        if gamPromo == 0 do charBribeTim[pChar[cyc]] -= gamSpeed[slot]
        if charBribeTim[pChar[cyc]] < 0 || charRelation[pChar[cyc]][gamChar[slot]] < 0 {
            charBribeTim[pChar[cyc]] = 0
        }
        // honour collision detection
        if pSeat[cyc] == 0 && pBed[cyc] == 0 {
            pGround[cyc] = bb.EntityY(pShadow[cyc][30])
            pX[cyc] = bb.EntityX(pPivot[cyc])
            pY[cyc] = bb.EntityY(pPivot[cyc]) - 18
            pZ[cyc] = bb.EntityZ(pPivot[cyc])
        }
        // prepare for move correction
        if pCollisions[cyc] == 0 {
            pOldMoveX[cyc] = bb.EntityX(pLimb[cyc][30], 1)
            pOldMoveZ[cyc] = bb.EntityZ(pLimb[cyc][30], 1)
        }
        // enforce blocks
        if pSeat[cyc] == 0 && pBed[cyc] == 0 {
            EnforceBlocks(cyc)
        }
        // clock stat changes
        if gotim > 0 && pChar[cyc] == gamChar[slot] {
            if charStrength[pChar[cyc]] > charOldStrength[pChar[cyc]] do statTim[1] = 20
            if charStrength[pChar[cyc]] < charOldStrength[pChar[cyc]] do statTim[1] = -20
            if charAgility[pChar[cyc]] > charOldAgility[pChar[cyc]] do statTim[2] = 20
            if charAgility[pChar[cyc]] < charOldAgility[pChar[cyc]] do statTim[2] = -20
            if charIntelligence[pChar[cyc]] > charOldIntelligence[pChar[cyc]] do statTim[3] = 20
            if charIntelligence[pChar[cyc]] < charOldIntelligence[pChar[cyc]] do statTim[3] = -20
            if charReputation[pChar[cyc]] > charOldReputation[pChar[cyc]] do statTim[4] = 20
            if charReputation[pChar[cyc]] < charOldReputation[pChar[cyc]] do statTim[4] = -20
        }
        // clock old stats
        charOldStrength[pChar[cyc]] = charStrength[pChar[cyc]]
        charOldAgility[pChar[cyc]] = charAgility[pChar[cyc]]
        charOldIntelligence[pChar[cyc]] = charIntelligence[pChar[cyc]]
        charOldReputation[pChar[cyc]] = charReputation[pChar[cyc]]
        // assess relationships
        AssessRelationships(cyc)
        // get input
        if gotim > 0 {
            GetInput(cyc)
            TranslateInput(cyc)
        }
        // trigger falls
        if (pHP[cyc] <= 0 || pHealth[cyc] <= 0) && cast(bool)CollapseViable(cyc) {
            randy := bb.Rnd(0, 4)
            if randy <= 2 do ChangeAnim(cyc, 80)
            if randy >= 3 do ChangeAnim(cyc, 83)
            if cast(bool)SatisfiedAngle(pA[cyc], pHurtA[cyc], 45) && pDazed[cyc] == 0 {
                ChangeAnim(cyc, 86)
            }
            if pDT[cyc] < 50 do pDT[cyc] = 150 - i32(pHealth[cyc])
        }
        if gotim > 0 && pY[cyc] > pGround[cyc] + 5 && pAnim[cyc] != 87 && pGrappling[cyc] == 0 && pGrappler[cyc] == 0 && pSeat[cyc] == 0 && pBed[cyc] == 0 {
            ChangeAnim(cyc, 87)
        }
        // trigger breakdown
        if gotim > 0 && charHappiness[pChar[cyc]] <= 0 && charBreakdown[pChar[cyc]] == 0 && pGrappling[cyc] == 0 && pGrappler[cyc] == 0 {
            if pHealth[cyc] > 0 && cast(bool)AttackViable(cyc) >= 1 && cast(bool)AttackViable(cyc) <= 2 && pAnim[cyc] != 87 {
                ChangeAnim(cyc, 96)
            }
        }
        // manage animations
        Animations(cyc)
        // gravity
        if pY[cyc] >= pOldY[cyc] - 0.5 && pY[cyc] <= pOldY[cyc] + 0.5 {
            if pGravity[cyc] < -1.0 do pGravity[cyc] = -1.0
        }
        if pGravity[cyc] > -10.0 do pGravity[cyc] -= 0.3
        if bb.KeyDown(201) && pControl[cyc] > 0 do pGravity[cyc] = bb.Rnd(2.0, 10.0)
        if pSeat[cyc] > 0 || pBed[cyc] > 0 do pGravity[cyc] = 0
        bb.MoveEntity(pPivot[cyc], 0, pGravity[cyc], 0)
        // monitor status
        MonitorStatus(cyc)
        // bind to chair/bed
        if pAnim[cyc] >= 100 && pAnim[cyc] <= 109 {
            if pAnim[cyc] == 101 {
                pSeatX[cyc] = pLeaveX[cyc]
                pSeatZ[cyc] = pLeaveZ[cyc]
                pSeatY[cyc] = pLeaveY[cyc]
                pSeatA[cyc] = pLeaveA[cyc]
            } else {
                if pSeat[cyc] > 0 {
                    target := bb.FindChild(world, fmt.tprintf("Chair%d", Dig(pSeat[cyc], 10)))
                    pSeatX[cyc] = bb.EntityX(target, 1)
                    pSeatZ[cyc] = bb.EntityZ(target, 1)
                    pSeatY[cyc] = bb.EntityY(target, 1) - 13
                    pSeatA[cyc] = CleanAngle(bb.EntityYaw(target, 1))
                    if gamLocation[slot] == 11 {
                        pSeatA[cyc] = CleanAngle(bb.EntityYaw(target, 1) + 180)
                    }
                }
                if pBed[cyc] > 0 {
                    target := bb.FindChild(world, fmt.tprintf("Mat%d", Dig(pBed[cyc], 10)))
                    pSeatX[cyc] = bb.EntityX(target, 1)
                    pSeatZ[cyc] = bb.EntityZ(target, 1)
                    pSeatY[cyc] = bb.EntityY(target, 1) - 10
                    pSeatA[cyc] = CleanAngle(bb.EntityYaw(target, 1) + 95)
                }
            }
            GetSmoothSpeeds(pX[cyc], pSeatX[cyc], pY[cyc], pSeatY[cyc], pZ[cyc], pSeatZ[cyc], 10)
            if pX[cyc] < pSeatX[cyc] do pX[cyc] += speedX
            if pX[cyc] > pSeatX[cyc] do pX[cyc] -= speedX
            if pY[cyc] < pSeatY[cyc] do pY[cyc] += speedY
            if pY[cyc] > pSeatY[cyc] do pY[cyc] -= speedY
            if pZ[cyc] < pSeatZ[cyc] do pZ[cyc] += speedZ
            if pZ[cyc] > pSeatZ[cyc] do pZ[cyc] -= speedZ
            bb.PositionEntity(pPivot[cyc], pX[cyc], pY[cyc], pZ[cyc])
            if SatisfiedAngle(pA[cyc], pSeatA[cyc], 10) == 0 {
                pA[cyc] += ReachAngle(pA[cyc], pSeatA[cyc], 5)
            }
            if SatisfiedAngle(pA[cyc], pSeatA[cyc], 45) == 0 {
                pA[cyc] += ReachAngle(pA[cyc], pSeatA[cyc], 10)
            }
            if cast(bool)SatisfiedAngle(pA[cyc], pSeatA[cyc], 10){
                pA[cyc] = pSeatA[cyc]
            }
            pA[cyc] = CleanAngle(pA[cyc])
            bb.PositionEntity(pPivot[cyc], 0, pA[cyc], 0)
        }
    }
}

//-----------------------------------------------------------------
//////////////////////// RELATED FUNCTIONS ////////////////////////
//-----------------------------------------------------------------

DisplayPlayers :: proc() {
    for cyc in 1..=no_plays {
        // manage scars
        ManageScars(cyc)
        // facial expressions
        if cast(bool)GrimaceViable(cyc) {
            pSpeaking[cyc] = 1
            pEyes[cyc] = 1
            if pAnim[cyc] == 91 || pAnim[cyc] == 93 || pAnim[cyc] == 95 {
                pEyes[cyc] = 3
            }
        }
        FacialExpressions(cyc)
        // update display
        pA[cyc] = CleanAngle(pA[cyc])
        bb.RotateEntity(p[cyc], 0, pA[cyc], 0)
        bb.RotateEntity(pPivot[cyc], 0, pA[cyc], 0)
        bb.PositionEntity(p[cyc], pX[cyc], pY[cyc], pZ[cyc])
        if pGrappling[cyc] > 0 || pGrappler[cyc] > 0 {
            bb.ResetEntity(pMovePivot[cyc])
            bb.PositionEntity(pMovePivot[cyc], pX[cyc], bb.EntityY(pPivot[cyc]), pZ[cyc])
            bb.EntityType(pMovePivot[cyc], 4, 0)
            bb.EntityRadius(pMovePivot[cyc], 8, 18)
            bb.PositionEntity(pMovePivot[cyc], bb.EntityX(pLimb[cyc][30], 1), bb.EntityY(pPivot[cyc]), bb.EntityZ(pLimb[cyc][30], 1))
        }
        // prevent falling underground
        if pY[cyc] < 0 {
            bb.ResetEntity(pPivot[cyc])
            bb.PositionEntity(pPivot[cyc], 0, 50, 0)
            if gamLocation[slot] == 2 {
                bb.PositionEntity(pPivot[cyc], 80, 50, 230)
            }
            bb.EntityType(pPivot[cyc], 1, 0)
            bb.EntityRadius(pPivot[cyc], 8, 18)
        }
        // core shadow
        bb.ResetEntity(pShadow[cyc][30])
        bb.PositionEntity(pShadow[cyc][30], bb.EntityX(pLimb[cyc][30], 1), bb.EntityY(pLimb[cyc][30], 1), bb.EntityZ(pLimb[cyc][30], 1))
        bb.RotateEntity(pShadow[cyc][30], 90, bb.EntityYaw(pLimb[cyc][30], 1), 0)
        bb.EntityType(pShadow[cyc][30], 2, 0)
        bb.EntityRadius(pShadow[cyc][30], 2, 0.75)
        bb.MoveEntity(pShadow[cyc][30], 0, 0, 250)
        // if pSeat[cyc]>0 Then EntityType pShadow(cyc,30),0,0 : PositionEntity pShadow(cyc,30),pSeatX#(cyc),pSeatY#(cyc)+2.0,pSeatZ#(cyc)
        // if pBed[cyc]>0 Then EntityType pShadow(cyc,30),0,0 : PositionEntity pShadow(cyc,30),pSeatX#(cyc),EntityY(pLimb(cyc,30),1)-3.5,pSeatZ#(cyc)
        if pAnim[cyc] == 100 || pAnim[cyc] == 101 || pSeat[cyc] > 0 || pBed[cyc] > 0 {
            bb.EntityType(pShadow[cyc][30], 0, 0)
            bb.PositionEntity(pShadow[cyc][30], bb.EntityX(pLimb[cyc][30], 1), pLeaveY[cyc] - 4.5, bb.EntityZ(pLimb[cyc][30], 1))
        }
        if optShadows == 0 {
            bb.EntityAlpha(pShadow[cyc][30], 0)
        } else {
            if optShadows == 1 do bb.EntityAlpha(pShadow[cyc][30], 0.5)
            if optShadows == 2 do bb.EntityAlpha(pShadow[cyc][30], 0.2)
        }
        // additional shadows
        if optShadows == 2 {
            for limb in 1..=40 {
                if limb != 30 && pShadow[cyc][limb] > 0 {
                    bb.RotateEntity(pShadow[cyc][limb], 90, bb.EntityYaw(pLimb[cyc][limb], 1), 0)
                    bb.PositionEntity(pShadow[cyc][limb], bb.EntityX(pLimb[cyc][limb], 1), pGround[cyc], bb.EntityZ(pLimb[cyc][limb], 1))
                    // if pSeat[cyc]>0 Then PositionEntity pShadow(cyc,limb),EntityX(pLimb(cyc,limb),1),pSeatY#(cyc)+2.0,EntityZ(pLimb(cyc,limb),1)
                    // if pBed[cyc]>0 Then PositionEntity pShadow(cyc,limb),EntityX(pLimb(cyc,limb),1),EntityY(pLimb(cyc,30),1)-3.5,EntityZ(pLimb(cyc,limb),1)
                    if pAnim[cyc] == 100 || pAnim[cyc] == 101 || pSeat[cyc] > 0 || pBed[cyc] > 0 {
                        bb.PositionEntity(pShadow[cyc][limb], bb.EntityX(pLimb[cyc][limb], 1), pLeaveY[cyc] - 4.5, bb.EntityZ(pLimb[cyc][limb], 1))
                    }
                    bb.EntityAlpha(pShadow[cyc][limb], 0.1)
                    if limb == 6 || limb == 19 do bb.EntityAlpha(pShadow[cyc][limb], 0.15)
                }
            }
        }
    }
}

FindChar :: proc(char: i32) {
    value: i32 = 0
    for v in 1..=no_plays {
        if pChar[v] == char do value = v
    }
    return value
}

ScarLimb :: proc(cyc, limb, chance: i32) {
    if limb == 0 do chance *= 2
    randy := bb.Rnd(0, chance)
    if randy == 0 && pScar[cyc][limb] <= 4 {
        // add scarring
        pScar[cyc][limb] += 1
        if pScar[cyc][limb] > 4 do pScar[cyc][limb] = 4
        if pScar[cyc][limb] >= 2 && limb > 0 && pLimb[cyc][limb] > 0 {
            vol := cast(f32)pScar[cyc][limb] * 0.1
            ProduceSound(p[cyc], sBleed, 22050, vol)
            limbX := bb.EntityX(pLimb[cyc][limb], 1)
            limbY := bb.EntityY(pLimb[cyc][limb], 1)
            limbZ := bb.EntityZ(pLimb[cyc][limb], 1)
            CreatePool(limbX, pGround[cyc], limbZ, bb.Rnd(1.0, 5.0), 1, 1)
            if pScar[cyc][limb] >= 3 do LoseLimb(cyc, limb, chance)
        }
        // lose accessories
        if limb == 1 {
            randy = bb.Rnd(0, 8)
            if randy == 0 && charSpecs[pChar[cyc]] > 0 do bb.HideEntity(bb.FindChild(p[cyc], "Specs"))
            if randy >= 1 && randy <= 2 && charSpecs[pChar[cyc]] > 0 {
                bb.HideEntity(bb.FindChild(p[cyc], fmt.tprintf("Lens0%d", Dig(randy, 10))))
            } 
            pDazed[cyc] = bb.Rnd(50, 200)
        }
    }
    // risk blinding
    randy = bb.Rnd(0, 100)
    if randy == 0 && limb == 1 do pDazed[cyc] = bb.Rnd(50, 200)
}

ScarArea :: proc(cyc: i32, x, y, z: f32, chance: i32) {
    for limb in i32(0)..=40 {
        risk := chance
        if limb == 1 do risk = chance * 2
        if x == 0 && y == 0 && z == 0 {
            ScarLimb(cyc, limb, risk)
        } else {
            if pLimb[cyc][limb] > 0 {
                limbX := bb.EntityX(pLimb[cyc][limb], 1)
                limbY := bb.EntityY(pLimb[cyc][limb], 1)
                limbZ := bb.EntityZ(pLimb[cyc][limb], 1)
                if x > limbX - 10 && x < limbX + 10 && z > limbZ - 10 && z < limbZ + 10 && y > limbY - 10 && y < limbY + 10 {
                    ScarLimb(cyc, limb, chance)
                }
            }
        }
    }
}

SeverLimbs :: proc(cyc: i32) {
    // ears
    if pScar[cyc][37] == 5 && pScar[cyc][38] == 5 {
        bb.EntityTexture(pLimb[cyc][1], tSeverEars, 0, 6)
    }
    // torso
    if pScar[cyc][4] == 5 && pScar[cyc][17] <= 4 {
        bb.EntityTexture(pLimb[cyc][3], tSeverBody[1], 0, 6)
    }
    if pScar[cyc][4] <= 4 && pScar[cyc][17] == 5 {
        bb.EntityTexture(pLimb[cyc][3], tSeverBody[2], 0, 6)
    }
    if pScar[cyc][4] == 5 && pScar[cyc][17] == 5 {
        bb.EntityTexture(pLimb[cyc][3], tSeverBody[3], 0, 6)
    }
    // arms
    for limb in 4..=29 {
        if pScar[cyc][limb] == 5 {
            if limbSource[limb] >= 6 && limbSource[limb] <= 16 {
                bb.EntityTexture(pLimb[cyc][limbSource[limb]], tSeverArm[1], 0, 6)
            }
            if limbSource[limb] >= 19 && limbSource[limb] <= 29 {
                bb.EntityTexture(pLimb[cyc][limbSource[limb]], tSeverArm[1], 0, 6)
            }
            if limbSource[limb] == 5 || limbSource[limb] == 18 {
                bb.EntityTexture(pLimb[cyc][limbSource[limb]], tSeverArm[2], 0, 6)
            }
            if limbSource[limb] == 4 || limbSource[limb] == 17 {
                bb.EntityTexture(pLimb[cyc][limbSource[limb]], tSeverArm[3], 0, 6)
            }
        }
    }
    // legs
    for limb in 30..=36 {
        if pScar[cyc][limb] == 5 {
            if limbSource[limb] == 32 || limbSource[limb] == 35 {
                bb.EntityTexture(pLimb[cyc][limbSource[limb]], tSeverLegs[1], 0, 6)
            }
            if limbSource[limb] == 31 || limbSource[limb] == 34 {
                bb.EntityTexture(pLimb[cyc][limbSource[limb]], tSeverLegs[2], 0, 6)
            }
            if limbSource[limb] == 30 {
                bb.EntityTexture(pLimb[cyc][limbSource[limb]], tSeverLegs[3], 0, 6)
            }
        }
    }
}



/*
;LOSE LIMB
Function LoseLimb(cyc,limb,chance)
 ;assess significance
 major=MajorLimb(limb)
 ;risk loss
 If chance<5 Then chance=5
 If major=1 Then chance=chance*2
 If (limbPrecede(limb)>0 And pScar(cyc,limbPrecede(limb))=<1) Or (limbSource(limb)>0 And pScar(cyc,limbSource(limb))=<1)
  chance=chance*2
 EndIf
 randy=Rnd(0,chance)
 If randy=0 And optGore=>3 And limbSource(limb)>0 And pScar(cyc,limbSource(limb))=<4
  If (pScar(cyc,limbPrecede(limb))=>2 Or limbPrecede(limb)=0) And (pScar(cyc,limbSource(limb))=>2 Or limbSource(limb)=0)
   ;pain and mess
   ProduceSound(p(cyc),sBleed,22050,1)
   limbX#=EntityX(pLimb(cyc,limb),1)
   limbY#=EntityY(pLimb(cyc,limb),1)
   limbZ#=EntityZ(pLimb(cyc,limb),1)
   If major=0
    If pHealth(cyc)>0 Then ProduceSound(p(cyc),sPain(Rnd(1,8)),22050,1)
    CreateSpurt(limbX#,limbY#,limbZ#,1,5,3)
    CreatePool(limbX#,pGround#(cyc),limbZ#,Rnd(3.0,10.0),2,1) 
    RiskInjury(cyc,50)
   EndIf
   If major=1
    If pHealth(cyc)>0 Then ProduceSound(p(cyc),sAgony(Rnd(1,3)),22050,1)
    CreateSpurt(limbX#,limbY#,limbZ#,3,15,3)
    CreatePool(limbX#,pGround#(cyc),limbZ#,Rnd(5.0,15.0),5,1) 
    pHealth(cyc)=pHealth(cyc)/2
    charHappiness(pChar(cyc))=charHappiness(pChar(cyc))/2
    If pInjured(cyc)<1000 Then pInjured(cyc)=1000
   EndIf
   DropWeapon(cyc,0)
   pHP(cyc)=0
   ;remove limb
   pScar(cyc,limb)=5
   If limbPrecede(limb)>0 Then pScar(cyc,limbPrecede(limb))=5
   SeverLimbs(cyc)
   HideEntity pLimb(cyc,limb)
   ;risk punishment
   If gamMission(slot)=14 And pChar(cyc)=gamTarget(slot) Then CompleteMission(1)
   If charAttacker(pChar(cyc))=gamChar(slot)
    If charPromo(pChar(cyc),gamChar(slot))=0 Then charPromo(pChar(cyc),gamChar(slot))=54
    For v=1 To no_plays
     If charRole(pChar(v))=1 And (Friendly(v,gamPlayer(slot))=0 Or Friendly(v,cyc)) And charBribeTim(pChar(v))=0 And gamBlackout(slot)=0 And InProximity(v,gamPlayer(slot),50) And AttackViable(v)=>1 And AttackViable(v)=<2 And pDazed(v)=0
      If InLine(v,p(gamPlayer(slot)),60) Or InLine(v,p(cyc),60)
       randy=Rnd(0,2)
       If (randy=0 Or major=1) And gamWarrant(slot)<11 Then gamWarrant(slot)=11 : gamVictim(slot)=pChar(cyc)
      EndIf
     EndIf
    Next
   EndIf 
  EndIf
 EndIf
End Function
*/
