package main
////////////////////////////////////////////////////////////////////////////////
//---------------------------- HARD TIME: WEAPONS ------------------------------
////////////////////////////////////////////////////////////////////////////////

import "core:fmt"
import bb "blitzbasic3d"

//-----------------------------------------------------------------
//////////////////////// LOAD WEAPONS /////////////////////////////
//----------------------------------------------------------------- 
LoadWeapons :: proc() {
    for cyc in 1..=no_weaps {
        if weapLocation[cyc] == gamLocation[slot] {
            // generate
            // Loader("Please Wait","Loading Weapon "+cyc+" of "+no_weaps)
            weap[cyc] = bb.LoadAnimMesh(fmt.tprint("Weapons/{}.3ds", weapFile[weapType[cyc]]))
            bb.ScaleEntity(weap[cyc], 0.4, 0.4, 0.4)
            if weapTex[weapType[cyc]] > 0 {
                for count in 1..=bb.CountChildren(weap[cyc]) {
                    bb.EntityTexture(bb.GetChild(weap[cyc], count), weapTex[weapType[cyc]])
                }
            }
            if weapShiny[weapType[cyc]] > 0 {
                for count in 1..=bb.CountChildren(weap[cyc]) {
                    bb.EntityShininess(bb.GetChild(weap[cyc], count), weapShiny[weapType[cyc]])
                }
            }
            if weapName[weapType[cyc]] == "Bottle" {
                bb.EntityAlpha(weap[cyc], 0.9)
            }
            // collision detection
            bb.EntityType(weap[cyc], 3, 0)
            bb.EntityRadius(weap[cyc], 4, 1)
            weapGround[cyc] = bb.CreatePivot()
            bb.EntityType(weapGround[cyc], 4, 0)
            bb.EntityRadius(weapGround[cyc], 4, 1)
            weapWall[cyc] = bb.CreatePivot()
            bb.EntityType(weapWall[cyc], 4, 0)
            bb.EntityRadius(weapWall[cyc], 4, 1)
            // location
            weapY[cyc] += 10
            bb.PositionEntity(weap[cyc], weapX[cyc], weapY[cyc], weapZ[cyc])
            bb.RotateEntity(weap[cyc], 0, weapA[cyc], 0)
            if weapState[cyc] == 0 do bb.HideEntity(weap[cyc])
            // reset status
            weapGravity[cyc] = -1.0
            weapFlight[cyc] = 0
            weapCarrier[cyc] = 0
            weapOldScar[cyc] = -1
        }
    }    
}

//-----------------------------------------------------------------
//////////////////////// WEAPON CYCLE /////////////////////////////
//-----------------------------------------------------------------
WeaponCycle :: proc() {
    for cyc in 1..=no_weaps {
        if weapLocation[cyc] == gamLocation[slot] && weapState[cyc] > 0 {
            //store old positions 
            weapOldX[cyc] = weapX[cyc]
            weapOldY[cyc] = weapY[cyc]
            weapOldZ[cyc] = weapZ[cyc]
            //honour collision detection 
            weapX[cyc] = bb.EntityX(weap[cyc])
            weapY[cyc] = bb.EntityY(weap[cyc])
            weapZ[cyc] = bb.EntityZ(weap[cyc])
            if weapCarrier[cyc] == 0 {
                //find baskets
                if gamLocation[slot] == 2 && weapThrower[cyc] > 0 {
                    basket := bb.FindChild(world, "Rim")
                    if weapX[cyc] > bb.EntityX(basket, 1) - 6 && weapX[cyc] < bb.EntityX(basket, 1) + 6 && weapZ[cyc] > bb.EntityZ(basket, 1) - 6 && weapZ[cyc] < bb.EntityZ(basket, 1) + 6 {
                        if weapY[cyc] > bb.EntityY(basket, 1) - 8 && weapY[cyc] < bb.EntityY(basket, 1) - 2 && weapOldY[cyc] > bb.EntityY(basket, 1) - 2 {
                            ProduceSound(weap[cyc], weapSound[weapType[cyc]], 22050, 0)
                            ProduceSound(weap[cyc], sBasket, 22050, 0)
                            CreateSpurt(bb.EntityX(basket, 1), bb.EntityY(basket, 1), bb.EntityZ(basket, 1), 3, 10, 5)
                            charAgility[pChar[weapThrower[cyc]]] += bb.Rnd(0, 1)
                            charHappiness[pChar[weapThrower[cyc]]] += bb.Rnd(1, 5)
                            randy := bb.Rnd(0, 5)
                            if randy == 0 do charReputation[pChar[weapThrower[cyc]]] += 1
                            bb.PointEntity(weap[cyc], basket)
                            weapFlightA[cyc] = bb.EntityYaw(weap[cyc], 1)
                            if weapFlight[cyc] < 1.0 do weapFlight[cyc] = 1.0
                            if weapGravity[cyc] < 0 do weapGravity[cyc] = 0
                            weapThrower[cyc] = 0
                        }
                    }
                }
                //bounce on ground
                if weapY[cyc] < bb.EntityY(weapGround[cyc]) + 0.5 && weapGravity[cyc] < -(weapWeight[weapType[cyc]] * 5) {
                    if weapY[cyc] > 0 do CreateSpurt(weapX[cyc], weapY[cyc], weapZ[cyc], 2, 5, 5)
                    weapFlight[cyc] = weapFlight[cyc] - (weapFlight[cyc] / 6)
                    if gotim > 0 do ProduceSound(weap[cyc], weapSound[weapType[cyc]], 22050, weapGravity[cyc] / 8)
                    weapGravity[cyc] = MakePositive(weapGravity[cyc])
                    weapGravity[cyc] -= (weapGravity[cyc] / 3)
                    if weapGravity[cyc] < 0.25 || gotim < 0 do weapGravity[cyc] = 0
                    if weapFlight[cyc] < weapGravity[cyc] / 5 do weapFlight[cyc] = weapGravity[cyc] / 5
                    weapA[cyc] = weapA[cyc] + bb.Rnd(-20, 20)
                    if weapGravity[cyc] < 1.0 {
                        for v in 1..=no_plays {
                            weapSting[cyc][v] = 0
                        }
                    }
                    for v in 1..=no_plays {
                        if charRole[pChar[v]] == 1 && WeaponProximity(v, cyc, weapSize[weapType[cyc]] * 5) {
                            pAgenda[v] = 1
                            pExploreY[v] = pY[v]
                            pExploreX[v] = weapX[cyc]
                            pExploreZ[v] = weapZ[cyc]
                            pSubX[v] = 9999
                            pSubZ[v] = 9999
                        }
                    }
                    ExplodeWeapon(cyc, 0)
                }
                //bounce off wall
                if weapFlight[cyc] > 0 && weapY[cyc] > bb.EntityY(weapGround[cyc]) + 0.5 {
                    if weapX[cyc] > bb.EntityX(weapWall[cyc]) - 2.0 && weapX[cyc] < bb.EntityX(weapWall[cyc]) + 2.0 &&
                       weapY[cyc] > bb.EntityY(weapWall[cyc]) - 2.0 && weapY[cyc] < bb.EntityY(weapWall[cyc]) + 2.0 &&
                       weapZ[cyc] > bb.EntityZ(weapWall[cyc]) - 2.0 && weapZ[cyc] < bb.EntityZ(weapWall[cyc]) + 2.0 {
                        if gotim > 0 do ProduceSound(weap[cyc], weapSound[weapType[cyc]], 22050, bb.Rnd(0.1, 0.3))
                        CreateSpurt(weapX[cyc], weapY[cyc], weapZ[cyc], 1, 5, 5)
                        weapGravity[cyc] = 1.0
                        weapFlight[cyc] /= 4
                        weapFlightA[cyc] += 180
                        if gamLocation[slot] == 2 {
                            basket := bb.FindChild(world, "Rim")
                            if weapX[cyc] > bb.EntityX(basket, 1) - 100 && weapX[cyc] < bb.EntityX(basket, 1) + 100 &&
                               weapY[cyc] > bb.EntityY(basket, 1) - 20  && weapY[cyc] < bb.EntityY(basket, 1) + 30 &&
                               weapZ[cyc] > bb.EntityZ(basket, 1) - 100 && weapZ[cyc] < bb.EntityZ(basket, 1) + 100 {
                                weapFlightA[cyc] += bb.Rnd(-90, 90)
                            }
                        }
                        weapA[cyc] += bb.Rnd(-20, 20)
                        ExplodeWeapon(cyc, 0)
                    }
                }
                //bounce off humans
                if weapFlight[cyc] > 0 && weapY[cyc] > bb.EntityY(weapGround[cyc]) + 0.5 {
                    for v in 1..=no_plays {
                        range := weapSize[weapType[cyc]] - (weapSize[weapType[cyc]] / 3)
                        if AttackViable(v) == 3 do range *= 2
                        if WeaponProximity(v, cyc, range) && weapY[cyc] >= pY[v] + 5 && weapY[cyc] <= bb.EntityY(bb.FindChild(p[v], "Head"), 1) + 5 && AttackViable(v) > 0 && weapSting[cyc][v] == 1 {
                            charAttacker[pChar[v]] = pChar[weapThrower[cyc]]
                            blocked := 0
                            if pAnim[v] >= 74 && pAnim[v] <= 75 && InLine(v, weap[cyc], 90) do blocked = 1
                            ProduceSound(weap[cyc], weapSound[weapType[cyc]], 22050, 0)
                            ExplodeWeapon(cyc, 0)
                            if blocked == 0 {
                                if pHealth[v] > 0 do ProduceSound(p[v], sPain[bb.Rnd(1, 8)], 22050, 0)
                                CreateSpurt(pX[v], weapY[cyc] - 4, pZ[v], 2, 10, 99)
                                ScarArea(v, weapX[cyc], weapY[cyc], weapZ[cyc], 5)
                                if CountScars(v) >= 2 do ScarWeapon(cyc, 0)
                                pHealth[v] -= bb.Rnd(1, weapDamage[weapType[cyc]])
                                pHP[v] -= bb.Rnd(1, weapDamage[weapType[cyc]])
                                pHurtA[v] = weapFlightA[cyc]
                                pStagger[v] = 0.5
                                if AttackViable(v) >= 1 && AttackViable(v) <= 2 {
                                    if weapY[cyc] >= pY[v] + 20 do ChangeAnim(v, 70)
                                    if weapY[cyc] < pY[v] + 20 do ChangeAnim(v, 71)
                                    randy := bb.Rnd(0, 3)
                                    if randy == 0 && weapY[cyc] >= pY[v] + 20 do pDazed[v] = bb.Rnd(50, 200)
                                }
                                if AttackViable(v) == 3 {
                                    GroundReaction(v)
                                    pDT[v] = pDT[v] - 10
                                }
                            }
                            if blocked == 1 {
                                CreateSpurt(pX[v], weapY[cyc] - 4, pZ[v], 2, 5, 4)
                                if pWeapon[v] > 0 {
                                    ProduceSound(p[v], weapSound[weapType[pWeapon[v]]], 22050, 0)
                                    DropWeapon(v, 10)
                                }
                            }
                            weapFlightA[cyc] += 180
                            weapA[cyc] += bb.Rnd(-50.0, 50.0)
                            weapGravity[cyc] = 1.0
                            weapFlight[cyc] /= 4
                            if weapFlight[cyc] > 1.0 do weapFlight[cyc] = 1.0
                            if weapStyle[weapType[cyc]] == 7 && blocked == 0 {
                                ProduceSound(weap[cyc], sStab, 22050, 1)
                                weapGravity[cyc] = 0
                                weapFlight[cyc] = 0
                                if weapName[weapType[cyc]] == "Syringe" && pInjured[v] < 100 do pInjured[v] = bb.Rnd(100, 500)
                            }
                            RiskAnger(weapThrower[cyc], v)
                            DamageRep(weapThrower[cyc], v, 1)
                            weapSting[cyc][v] = 0
                        }
                    }
                }
                //flight
                weapFlight[cyc] = weapFlight[cyc] - 0.02
                if weapFlight[cyc] < 0 do weapFlight[cyc] = 0
                if weapFlight[cyc] > 0 {
                    if weapStyle[weapType[cyc]] != 7 do weapA[cyc] += weapFlight[cyc]
                    bb.RotateEntity(weap[cyc], 0, weapFlightA[cyc], 0)
                    bb.MoveEntity(weap[cyc], 0, 0, weapFlight[cyc])
                    if weapFlight[cyc] > 0.5 {
                        randy := bb.Rnd(0, 5)
                        if randy <= 0 && weapY[cyc] < 0 do CreateParticle(weapX[cyc], weapY[cyc], weapZ[cyc], 6)
                        randy = bb.Rnd(0, 60)
                        if randy <= weapScar[cyc] && weapScar[cyc] > 1 do CreatePool(weapX[cyc], weapY[cyc], weapZ[cyc], bb.Rnd(0.5, 2.0), 1, 1)
                    }
                }
                bb.RotateEntity(weap[cyc], 0, weapA[cyc], 0)
                //gravity
                if weapY[cyc] == weapOldY[cyc] && weapGravity[cyc] < 0 do weapGravity[cyc] = 0
                if weapGravity[cyc] > -8 do weapGravity[cyc] -= weapWeight[weapType[cyc]]
                bb.MoveEntity(weap[cyc], 0, weapGravity[cyc], 0)
                if gotim < 0 do bb.MoveEntity(weap[cyc], 0, -1.0, 0)
                //identify ground
                bb.ResetEntity(weapGround[cyc])
                bb.PositionEntity(weapGround[cyc], weapX[cyc], weapY[cyc] + 5, weapZ[cyc])
                bb.RotateEntity(weapGround[cyc], 0, weapA[cyc], 0)
                bb.EntityType(weapGround[cyc], 4, 0)
                bb.EntityRadius(weapGround[cyc], 4, 1)
                bb.MoveEntity(weapGround[cyc], 0, -500, 0)
                //identify walls
                bb.ResetEntity(weapWall[cyc])
                bb.PositionEntity(weapWall[cyc], weapX[cyc], weapY[cyc], weapZ[cyc])
                bb.RotateEntity(weapWall[cyc], 0, weapFlightA[cyc], 0)
                bb.EntityType(weapWall[cyc], 4, 0)
                bb.EntityRadius(weapWall[cyc], 4, 1)
                bb.MoveEntity(weapWall[cyc], 0, 0, 500)
            }
            //follow carrier
            v := weapCarrier[cyc]
            if v > 0 {
                bb.ResetEntity(weap[cyc])
                limb: i32
                if weapStyle[weapType[cyc]] == 2 {
                    limb = pLimb[v][6]
                } else {
                    limb = pLimb[v][19]
                }
                if bb.EntityY(limb, 1) > pY[v] + 10 {
                    bb.PositionEntity(weap[cyc], bb.EntityX(limb, 1), bb.EntityY(limb, 1), bb.EntityZ(limb, 1))
                } else {
                    bb.PositionEntity(weap[cyc], bb.EntityX(limb, 1), pY[v] + 10, bb.EntityZ(limb, 1))
                }
                weapA[cyc] = bb.EntityYaw(bb.FindChild(p[v], weapFile[weapType[cyc]]), 1)
                bb.EntityType(weap[cyc], 3, 0)
                bb.EntityRadius(weap[cyc], 4, 1)
            }
            //scarring
            ManageWeaponScars(cyc)
        }
    }
}

FindCarrier :: proc(cyc: i32) -> i32 {
    value: i32 = 0
    if cyc > 0 {
        for v in 1..=no_chars {
            if charWeapon[pChar[v]] == cyc do value = v
        }
    }
    return value
}



/*

*/

