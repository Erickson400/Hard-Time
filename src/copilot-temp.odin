package main

import "core:fmt"
import bb "blitzbasic3d"

part_two :: proc() {
    {
        if pAnimTim[cyc] >= 4 && pAnimTim[cyc] <= 10 && pScar[cyc][32] <= 4 && pSting[cyc] == 1 {
            for v in 1..=no_plays {
                range: i32 = pAnimTim[cyc]
                if range > 7 { range = 7  }
                if cyc != v && (Friendly(cyc, v) == 0 || v == pFoc[cyc]) && cast(bool)InProximity(cyc, v, 15 + range) && pY[cyc] > pY[v] - 15 && pY[cyc] < pY[v] + 15 && AttackViable(v) >= 1 && AttackViable(v) <= 2 && pSting[cyc] == 1 {
                    contact: i32 = InRange(cyc, v, range)
                    if contact > 0 {
                        charAttacker[pChar[v]] = pChar[cyc]
                        blocked: i32 = 0
                        randy: i32 = bb.Rnd(0, 10)
                        if randy <= 5 + BlockPower(v) && pAnim[v] >= 74 && pAnim[v] <= 75 && cast(bool)InLine(v, p[cyc], 90) {
                            blocked = 1
                        }
                        if blocked == 0 {
                            ProduceSound(p[v], sImpact[bb.Rnd(4, 5)], 22050, 0)
                            ProduceSound(p[v], sPain[bb.Rnd(1, 8)], 22050, 0)
                            CreateSpurt(pX[v], pY[cyc] + 15, pZ[v], 2, 10, 99)
                            ScarArea(v, pX[v], pY[cyc] + 15, pZ[v], 10)
                            ChangeAnim(v, 71)
                            pDT[v] = (110 - pHealth[v]) * 2
                            pHealth[v] = pHealth[v] - GetPower(cyc)
                            pHP[v] = pHP[v] - GetPower(cyc)
                        }
                        if blocked == 1 {
                            if pWeapon[v] > 0 {
                                ProduceSound(p[v], weapSound[weapType(pWeapon[v])], 22050, 0)
                                DropWeapon(v, 10)
                            }
                            ProduceSound(p[v], sImpact[bb.Rnd(4, 5)], 22050, 0)
                            CreateSpurt(pX[v], pY[cyc] + 15, pZ[v], 2, 10, 4)
                            for limb in 4..=29 {
                                if pWeapon[v] == 0 {
                                    ScarLimb(v, limb, 10)
                                }
                            }
                            pHP[v] = pHP[v] - bb.Rnd(0, 1)
                        }
                        pHurtA[v] = pA[cyc]
                        pStagger[v] = (8 - contact) * 0.3
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
        if pWeapon[cyc] > 0 && (weapStyle(weapType(pWeapon[cyc])) == 1 || weapStyle(weapType(pWeapon[cyc])) == 7) {
            ChangeAnim(cyc, 41)
        }
        //stomp
        if pAnim[cyc] == 32 {
            if pAnimTim[cyc] == 0 {
                Animate(p[cyc], 3, 3.0, pSeq[cyc][32], 5)
                pSting[cyc] = 1
            }
            if pAnimTim[cyc] == 3 {
                ProduceSound(p[cyc], sSwing, 22050, bb.Rnd(0.1, 0.3))
            }
            if pAnimTim[cyc] <= 12 {
                FaceEntity(cyc, p[pFoc[cyc]], 5)
                if InProximity(cyc, pFoc[cyc], 10) == 0 {
                    RotateEntity(pPivot[cyc], 0, pA[cyc], 0)
                    MoveEntity(pPivot[cyc], 0, 0, 0.5)
                }
            }
            if pAnimTim[cyc] >= 7 && pAnimTim[cyc] <= 11 && pScar[cyc][35] <= 4 && pSting[cyc] == 1 {
                v := pFoc[cyc]
                if cyc != v && (Friendly(cyc, v) == 0 || v == pFoc[cyc]) && cast(bool)InProximity(cyc, v, 25) && pY[cyc] > pY[v] - 15 && pY[cyc] < pY[v] + 15 && AttackViable(v) == 3 && pSting[cyc] == 1 {
                    contact := InRange(cyc, v, 6)
                    if contact > 0 {
                        charAttacker[pChar[v]] = pChar[cyc]
                        ProduceSound(p[v], sImpact[bb.Rnd(4, 5)], 22050, 0)
                        if pHealth[v] > 0 do ProduceSound(p[v], sPain[bb.Rnd(1, 8)], 22050, 0)
                        limb := pLimb(cyc, 36)
                        CreateSpurt(EntityX(limb, 1), pY[v], EntityZ(limb, 1), 2, 10, 99)
                        ScarArea(v, EntityX(limb, 1), pY[v], EntityZ(limb, 1), 10)
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
            if pWeapon[cyc] > 0 && (weapStyle(weapType(pWeapon[cyc])) <= 1 || weapStyle(weapType(pWeapon[cyc])) == 7) {
                ChangeAnim(cyc, 42)
            }
        }
        //big attack
        if pAnim[cyc] == 33 {
            if pAnimTim[cyc] == 0 {
                Animate(p[cyc], 3, 3.0, pSeq[cyc][33], 10)
                pSting[cyc] = 1
            }
            if pAnimTim[cyc] == 5 do ProduceSound(p[cyc], sSwing, 22050, bb.Rnd(0.3, 0.5))
            if pAnimTim[cyc] <= 16 {
                FaceEntity(cyc, p[pFoc[cyc]], 5)
                RotateEntity(pPivot[cyc], 0, pA[cyc], 0)
                MoveEntity(pPivot[cyc], 0, 0, 0.5)
                pStepTim[cyc] = pStepTim[cyc] + bb.Rnd(0, 1)
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
                            blocked := 0
                            randy := bb.Rnd(0, 10)
                            if randy <= 3 + BlockPower(v) && pAnim[v] >= 74 && pAnim[v] <= 75 && cast(bool)InLine(v, p[cyc], 90) {
                                blocked = 1
                            }
                            if blocked == 0 {
                                ProduceSound(p[v], sImpact[3], 22050, 0)
                                ProduceSound(p[v], sPain[bb.Rnd(1, 8)], 22050, 1)
                                impactY := pY[cyc] + 20
                                if impactY > bb.EntityY(pLimb[v, 1], 1) do impactY = bb.EntityY(pLimb[v, 1], 1)
                                CreateSpurt(pX[v], impactY, pZ[v], 2, 10, 99)
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
                                impactY := pY[cyc] + 20
                                if impactY > bb.EntityY(pLimb[v, 1], 1) do impactY = bb.EntityY(pLimb[v, 1], 1)
                                CreateSpurt(pX[v], impactY, pZ[v], 2, 10, 4)
                                for limb in 4..=29 {
                                    if pWeapon[v] == 0 do ScarLimb(v, limb, 10)
                                }
                                if pWeapon[v] == 0 do pHealth[v] -= 1
                                pHP[v] -= 1
                            }
                            WeaponImpact(cyc, v, blocked)
                            pHurtA[v] = pA[cyc]
                            pStagger[v] = (8 - contact) * 0.2
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
            if pWeapon[cyc] > 0 && (weapStyle(weapType(pWeapon[cyc])) == 1 || weapStyle(weapType(pWeapon[cyc])) == 7) {
                ChangeAnim(cyc, 43)
            }
        }
        //rear attack
        if pAnim[cyc] == 34 {
            if pAnimTim[cyc] == 0 {
                Animate(p[cyc], 3, 4.0, pSeq[cyc][34], 10)
                for v in 1..=no_plays {
                    pMultiSting[cyc][v] = 1
                }
            }
            if pAnimTim[cyc] == 5 do ProduceSound(p[cyc], sSwing, 22050, bb.Rnd(0.3, 0.5))
            if pAnimTim[cyc] >= 5 && pAnimTim[cyc] <= 16 {
                RotateEntity(pPivot[cyc], 0, pA[cyc], 0)
                MoveEntity(pPivot[cyc], 0, 0, -1.0)
                pStepTim[cyc] = pStepTim[cyc] + bb.Rnd(0, 1)
            }
            if pAnimTim[cyc] >= 7 && pAnimTim[cyc] <= 17 && pScar[cyc][18] <= 4 {
                for v in 1..=no_plays {
                    range := pAnimTim[cyc] - 8
                    if range > 5 do range = 5
                    if cyc != v && (Friendly(cyc, v) == 0 || v == pFoc[cyc]) && cast(bool)LimbProximity(pLimb[cyc, 18], pX[v], pZ[v], 8) && pY[cyc] > pY[v] - 30 && pY[cyc] < pY[v] + 5 && AttackViable(v) == 1 && pMultiSting[cyc][v] == 1 {
                        charAttacker[pChar[v]] = pChar[cyc]
                        blocked := 0
                        randy := bb.Rnd(0, 10)
                        if randy <= 3 + BlockPower(v) && pAnim[v] >= 74 && pAnim[v] <= 75 && cast(bool)InLine(v, p[cyc], 90) {
                            blocked = 1
                        }
                        if blocked == 0 {
                            ProduceSound(p[v], sImpact[3], 22050, 0)
                            ProduceSound(p[v], sPain[bb.Rnd(1, 8)], 22050, 1)
                            limb := pLimb[cyc, 18]
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
                            for limb in 4..=29 {
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
            if pWeapon[cyc] > 0 && weapStyle(weapType(pWeapon[cyc])) == 1 {
                ChangeAnim(cyc, 44)
            }
        }
        //rising punch
        if pAnim[cyc] == 35 {
            if pAnimTim[cyc] == 0 {
            Animate(p[cyc], 3, 3.0, pSeq[cyc][35], 5)
            pSting[cyc] = 1
            }
            if pAnimTim[cyc] == 3 do ProduceSound(p[cyc], sSwing, 22050, bb.Rnd(0.1, 0.3))
            if pAnimTim[cyc] <= 15 {
                FaceEntity(cyc, p[pFoc[cyc]], 5)
                RotateEntity(pPivot[cyc], 0, pA[cyc], 0)
                MoveEntity(pPivot[cyc], 0, 0, 0.2)
                pStepTim[cyc] = pStepTim[cyc] + bb.Rnd(0, 1)
            }
            if pAnimTim[cyc] >= 6 && pAnimTim[cyc] <= 11 && pScar[cyc][18] <= 4 && pSting[cyc] == 1 {
            for v in 1..=no_plays {
                range := pAnimTim[cyc] - 3
                if range > 6 do range = 6
                if cyc != v && (Friendly(cyc, v) == 0 || v == pFoc[cyc]) && cast(bool)InProximity(cyc, v, 15 + range) && pY[cyc] > pY[v] - 15 && pY[cyc] < pY[v] + 15 && AttackViable(v) >= 1 && AttackViable(v) <= 2 && pSting[cyc] == 1 {
                    contact := InRange(cyc, v, range)
                    if contact > 0 {
                        charAttacker[pChar[v]] = pChar[cyc]
                        blocked := 0
                        randy := bb.Rnd(0, 10)
                        if randy <= 5 + BlockPower(v) && pAnim[v] >= 74 && pAnim[v] <= 75 && cast(bool)InLine(v, p[cyc], 90) {
                            blocked = 1
                        }
                        if blocked == 0 {
                            ProduceSound(p[v], sImpact[bb.Rnd(4, 5)], 22050, 0)
                            ProduceSound(p[v], sPain[bb.Rnd(1, 8)], 22050, 0)
                            CreateSpurt(pX[v], pY[cyc] + 15, pZ[v], 2, 10, 99)
                            ScarArea(v, pX[v], pY[cyc] + 15, pZ[v], 10)
                            ChangeAnim(v, 71)
                            pDT[v] = (110 - pHealth[v]) * 2
                            pHealth[v] = pHealth[v] - GetPower(cyc)
                            pHP[v] = pHP[v] - GetPower(cyc)
                        }
                        if blocked == 1 {
                            if pWeapon[v] > 0 {
                                ProduceSound(p[v], weapSound[weapType(pWeapon[v])], 22050, 0)
                                DropWeapon(v, 10)
                            }
                            ProduceSound(p[v], sImpact[bb.Rnd(4, 5)], 22050, 0)
                            CreateSpurt(pX[v], pY[cyc] + 15, pZ[v], 2, 10, 4)
                            for limb in 4..=29 {
                                if pWeapon[v] == 0 do ScarLimb(v, limb, 10)
                            }
                            pHP[v] -= bb.Rnd(0, 1)
                        }
                        WeaponImpact(cyc, v, blocked)
                        pHurtA[v] = pA[cyc]
                        pStagger[v] = (8 - contact) * 0.2
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
        if pWeapon[cyc] > 0 && (weapStyle(weapType(pWeapon[cyc])) == 1 || weapStyle(weapType(pWeapon[cyc])) == 7) {
            ChangeAnim(cyc, 41)
        }
    }
    //----------- 40-50: SWORD ATTACKS ----------
    //upper swing
    if pAnim[cyc] == 40 {
        anim: i32 = 40
        if weapStyle(weapType(pWeapon[cyc])) == 7 do anim = 51
        if pAnimTim[cyc] == 0 {
            Animate(p[cyc], 3, 4.0, pSeq[cyc][anim], 5)
            pSting[cyc] = 1
        }
        if pAnimTim[cyc] == 3 do ProduceSound(p[cyc], sSwing, 22050, 0)
        if pAnimTim[cyc] <= 11 {
            FaceEntity(cyc, p[pFoc[cyc]], 5)
            RotateEntity(pPivot[cyc], 0, pA[cyc], 0)
            MoveEntity(pPivot[cyc], 0, 0, 0.4)
            pStepTim[cyc] = pStepTim[cyc] + bb.Rnd(0, 1)
        }
        impactTim: i32 = 5
        if weapStyle(weapType(pWeapon[cyc])) == 7 do impactTim = 9
        if pAnimTim[cyc] >= impactTim && pAnimTim[cyc] <= impactTim + 4 && pSting[cyc] == 1 {
            for v in 1..=no_plays {
                range := weapRange(weapType(pWeapon[cyc]))
                if cyc != v && (Friendly(cyc, v) == 0 || v == pFoc[cyc]) && cast(bool)InProximity(cyc, v, 20 + range) && pY[cyc] > pY[v] - 30 && pY[cyc] < pY[v] + 15 && AttackViable(v) >= 1 && AttackViable(v) <= 2 && pSting[cyc] == 1 {
                    contact := InRange(cyc, v, range)
                    if contact > 0 {
                        charAttacker[pChar[v]] = pChar[cyc]
                        blocked := 0
                        randy := bb.Rnd(0, 10)
                        if randy <= 5 + BlockPower(v) && pAnim[v] >= 74 && pAnim[v] <= 75 && cast(bool)InLine(v, p[cyc], 90) {
                            blocked = 1
                        }
                        if blocked == 0 {
                            ProduceSound(p[v], weapSound[weapType(pWeapon[cyc])], 22050, 1)
                            if weapStyle(weapType(pWeapon[cyc])) == 7 do ProduceSound(p[v], sStab, 22050, 1)
                            ProduceSound(p[v], sPain[bb.Rnd(1, 8)], 22050, 0)
                            CreateSpurt(pX[v], pY[cyc] + 20, pZ[v], 2, 10, 99)
                            ScarArea(v, pX[v], pY[cyc] + 20, pZ[v], 2)
                            if CountScars(v) >= 2 {
                                ScarWeapon(pWeapon[cyc], 5)
                                CreatePool(pX[v], pGround[v], pZ[v], bb.Rnd(2.0, 8.0), 1, 1)
                            }
                            ChangeAnim(v, 70)
                            pDT[v] = (110 - pHealth[v]) * 2
                            pHealth[v] = pHealth[v] - GetPower(cyc)
                            pHP[v] -= GetPower(cyc)
                            pDT[v] += (weapDamage[weapType[pWeapon[cyc]]] * 10)
                            pHealth[v] -= bb.Rnd(1, weapDamage[weapType[pWeapon[cyc]]])
                            pHP[v] -= bb.Rnd(1, weapDamage[weapType[pWeapon[cyc]]])
                            if weapName(weapType[pWeapon[cyc]]) == "Syringe" && pInjured[v] < 100 {
                                pInjured[v] = bb.Rnd(100, 500)
                            }
                        }
                        if blocked == 1 {
                            if pWeapon[v] > 0 {
                                ProduceSound(p[v], weapSound[weapType(pWeapon[v])], 22050, 0)
                                DropWeapon(v, 10)
                            }
                            ProduceSound(p[v], weapSound[weapType(pWeapon[cyc])], 22050, 0)
                            ProduceSound(p[v], sImpact[bb.Rnd(4, 5)], 22050, 0)
                            CreateSpurt(pX[v], pY[cyc] + 20, pZ[v], 2, 10, 4)
                            for limb in 4..=29 {
                                if pWeapon[v] == 0 do ScarLimb(v, limb, 10)
                            }
                            if pWeapon[v] == 0 do pHealth[v] -= 1
                            pHP[v] -= bb.Rnd(0, 1)
                        }
                        pHurtA[v] = pA[cyc]
                        pStagger[v] = (range - contact) * 0.2
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
            Animate(p[cyc], 3, 4.0, pSeq[cyc][41], 5)
            pSting[cyc] = 1
        }
        if pAnimTim[cyc] == 3 do ProduceSound(p[cyc], sSwing, 22050, 0)
        if pAnimTim[cyc] <= 11 {
            FaceEntity(cyc, p[pFoc[cyc]], 5)
            RotateEntity(pPivot[cyc], 0, pA[cyc], 0)
            MoveEntity(pPivot[cyc], 0, 0, 0.4)
            pStepTim[cyc] = pStepTim[cyc] + bb.Rnd(0, 1)
        }
        if pAnimTim[cyc] >= 5 && pAnimTim[cyc] <= 9 && pSting[cyc] == 1 {
            for v in 1..=no_plays {
                range := weapRange(weapType(pWeapon[cyc])) - 1
                if cyc != v && (Friendly(cyc, v) == 0 || v == pFoc[cyc]) && cast(bool)InProximity(cyc, v, 20 + range) && pY[cyc] > pY[v] - 15 && pY[cyc] < pY[v] + 15 && AttackViable(v) >= 1 && AttackViable(v) <= 2 && pSting[cyc] == 1 {
                    contact := InRange(cyc, v, range)
                    if contact > 0 {
                        charAttacker[pChar[v]] = pChar[cyc]
                        blocked := 0
                        randy := bb.Rnd(0, 10)
                        if randy <= 5 + BlockPower(v) && pAnim[v] >= 74 && pAnim[v] <= 75 && cast(bool)InLine(v, p[cyc], 90) {
                            blocked = 1
                        }
                        if blocked == 0 {
                            ProduceSound(p[v], weapSound[weapType(pWeapon[cyc])], 22050, 1)
                            if weapStyle(weapType(pWeapon[cyc])) == 7 do ProduceSound(p[v], sStab, 22050, 1)
                            ProduceSound(p[v], sPain[bb.Rnd(1, 8)], 22050, 0)
                            CreateSpurt(pX[v], pY[cyc] + 10, pZ[v], 2, 10, 99)
                            ScarArea(v, pX[v], pY[cyc] + 10, pZ[v], 2)
                            if CountScars(v) >= 2 {
                                ScarWeapon(pWeapon[cyc], 5)
                                CreatePool(pX[v], pGround[v], pZ[v], bb.Rnd(2.0, 8.0), 1, 1)
                            }
                            ChangeAnim(v, 71)
                            pDT[v] = (110 - pHealth[v]) * 2
                            pHealth[v] = pHealth[v] - GetPower(cyc)
                            pHP[v] = pHP[v] - GetPower(cyc)
                            pDT[v] = pDT[v] + (weapDamage(weapType(pWeapon[cyc])) * 10)
                            pHealth[v] = pHealth[v] - bb.Rnd(1, weapDamage(weapType(pWeapon[cyc])))
                            pHP[v] = pHP[v] - bb.Rnd(1, weapDamage(weapType(pWeapon[cyc])))
                            if weapName(weapType(pWeapon[cyc])) == "Syringe" && pInjured[v] < 100 {
                                pInjured[v] = bb.Rnd(100, 500)
                            }
                        }
                        if blocked == 1 {
                            if pWeapon[v] > 0 {
                                ProduceSound(p[v], weapSound[weapType(pWeapon[v])], 22050, 0)
                                DropWeapon(v, 10)
                            }
                            ProduceSound(p[v], weapSound[weapType(pWeapon[cyc])], 22050, 0)
                            ProduceSound(p[v], sImpact[bb.Rnd(4, 5)], 22050, 0)
                            CreateSpurt(pX[v], pY[cyc] + 10, pZ[v], 2, 10, 4)
                            for limb in 4..=29 {
                                if pWeapon[v] == 0 do ScarLimb(v, limb, 10)
                            }
                            if pWeapon[v] == 0 do pHealth[v] = pHealth[v] - 1
                            pHP[v] = pHP[v] - bb.Rnd(0, 1)
                        }
                        pHurtA[v] = pA[cyc]
                        pStagger[v] = (range - contact) * 0.2
                        if pStagger[v] < 0.2 do pStagger[v] = 0.2
                        RiskAnger(cyc, v)
                        GainStrength(cyc, 50)
                        DamageRep(cyc, v, 1)
                        pSting[cyc] = 0
                    }
                }
            }
        }
    }


}


/*
 ;----------- 40-50: SWORD ATTACKS ----------
 ;upper swing
 If pAnim(cyc)=40
  anim=40
  If weapStyle(weapType(pWeapon(cyc)))=7 Then anim=51
  If pAnimTim(cyc)=0 Then Animate p(cyc),3,4.0,pSeq(cyc,anim),5 : pSting(cyc)=1
  If pAnimTim(cyc)=3 Then ProduceSound(p(cyc),sSwing,22050,0)
  If pAnimTim(cyc)=<11
   FaceEntity(cyc,p(pFoc(cyc)),5)
   RotateEntity pPivot(cyc),0,pA#(cyc),0
   MoveEntity pPivot(cyc),0,0,0.4
   pStepTim(cyc)=pStepTim(cyc)+Rnd(0,1)
  EndIf
  If weapStyle(weapType(pWeapon(cyc)))=7 Then impactTim=9 Else impactTim=5
  If pAnimTim(cyc)=>impactTim And pAnimTim(cyc)=<impactTim+4 And pSting(cyc)=1
   For v=1 To no_plays
    range=weapRange#(weapType(pWeapon(cyc)))
    If cyc<>v And (Friendly(cyc,v)=0 Or v=pFoc(cyc)) And InProximity(cyc,v,20+range) And pY#(cyc)>pY#(v)-30 And pY#(cyc)<pY#(v)+15 And AttackViable(v)=>1 And AttackViable(v)=<2 And pSting(cyc)=1
     contact=InRange(cyc,v,range)
     If contact>0
      charAttacker(pChar(v))=pChar(cyc)
      blocked=0
      randy=Rnd(0,10)
      If randy=<5+BlockPower(v) And pAnim(v)=>74 And pAnim(v)=<75 And InLine(v,p(cyc),90) Then blocked=1
      If blocked=0
       ProduceSound(p(v),weapSound(weapType(pWeapon(cyc))),22050,1)
       If weapStyle(weapType(pWeapon(cyc)))=7 Then ProduceSound(p(v),sStab,22050,1) 
       ProduceSound(p(v),sPain(Rnd(1,8)),22050,0)
       CreateSpurt(pX#(v),pY#(cyc)+20,pZ#(v),2,10,99)
       ScarArea(v,pX#(v),pY#(cyc)+20,pZ#(v),2)
       If CountScars(v)=>2 Then ScarWeapon(pWeapon(cyc),5) : CreatePool(pX#(v),pGround#(v),pZ#(v),Rnd(2.0,8.0),1,1) 
       ChangeAnim(v,70) : pDT(v)=(110-pHealth(v))*2
       pHealth(v)=pHealth(v)-GetPower(cyc) : pHP(v)=pHP(v)-GetPower(cyc)
       pDT(v)=pDT(v)+(weapDamage(weapType(pWeapon(cyc)))*10)
       pHealth(v)=pHealth(v)-Rnd(1,weapDamage(weapType(pWeapon(cyc))))
       pHP(v)=pHP(v)-Rnd(1,weapDamage(weapType(pWeapon(cyc))))  
       If weapName$(weapType(pWeapon(cyc)))="Syringe" And pInjured(v)<100 Then pInjured(v)=Rnd(100,500)
      EndIf
      If blocked=1
       If pWeapon(v)>0 Then ProduceSound(p(v),weapSound(weapType(pWeapon(v))),22050,0) : DropWeapon(v,10)
       ProduceSound(p(v),weapSound(weapType(pWeapon(cyc))),22050,0)
       ProduceSound(p(v),sImpact(Rnd(4,5)),22050,0)
       CreateSpurt(pX#(v),pY#(cyc)+20,pZ#(v),2,10,4)
       For limb=4 To 29
        If pWeapon(v)=0 Then ScarLimb(v,limb,10)
       Next
       If pWeapon(v)=0 Then pHealth(v)=pHealth(v)-1
       pHP(v)=pHP(v)-Rnd(0,1)
      EndIf
      pHurtA#(v)=pA#(cyc) : pStagger#(v)=(range-contact)*0.2
      If pStagger#(v)<0.2 Then pStagger#(v)=0.2
      RiskAnger(cyc,v)
      GainStrength(cyc,50)
      DamageRep(cyc,v,1)
      pSting(cyc)=0
     EndIf
    EndIf
   Next
  EndIf
  If pAnimTim(cyc)>18 Then ChangeAnim(cyc,0)
 EndIf
 ;lower swing
 If pAnim(cyc)=41
  If pAnimTim(cyc)=0 Then Animate p(cyc),3,4.0,pSeq(cyc,41),5 : pSting(cyc)=1
  If pAnimTim(cyc)=3 Then ProduceSound(p(cyc),sSwing,22050,0)
  If pAnimTim(cyc)=<11
   FaceEntity(cyc,p(pFoc(cyc)),5)
   RotateEntity pPivot(cyc),0,pA#(cyc),0
   MoveEntity pPivot(cyc),0,0,0.4
   pStepTim(cyc)=pStepTim(cyc)+Rnd(0,1)
  EndIf
  If pAnimTim(cyc)=>5 And pAnimTim(cyc)=<9 And pSting(cyc)=1
   For v=1 To no_plays
    range=weapRange#(weapType(pWeapon(cyc)))-1
    If cyc<>v And (Friendly(cyc,v)=0 Or v=pFoc(cyc)) And InProximity(cyc,v,20+range) And pY#(cyc)>pY#(v)-15 And pY#(cyc)<pY#(v)+15 And AttackViable(v)=>1 And AttackViable(v)=<2 And pSting(cyc)=1
     contact=InRange(cyc,v,range)
     If contact>0
      charAttacker(pChar(v))=pChar(cyc)
      blocked=0
      randy=Rnd(0,10)
      If randy=<5+BlockPower(v) And pAnim(v)=>74 And pAnim(v)=<75 And InLine(v,p(cyc),90) Then blocked=1
      If blocked=0
       ProduceSound(p(v),weapSound(weapType(pWeapon(cyc))),22050,1)
        If weapStyle(weapType(pWeapon(cyc)))=7 Then ProduceSound(p(v),sStab,22050,1)
       ProduceSound(p(v),sPain(Rnd(1,8)),22050,0)
       CreateSpurt(pX#(v),pY#(cyc)+10,pZ#(v),2,10,99)
       ScarArea(v,pX#(v),pY#(cyc)+10,pZ#(v),2)
       If CountScars(v)=>2 Then ScarWeapon(pWeapon(cyc),5) : CreatePool(pX#(v),pGround#(v),pZ#(v),Rnd(2.0,8.0),1,1) 
       ChangeAnim(v,71) : pDT(v)=(110-pHealth(v))*2
       pHealth(v)=pHealth(v)-GetPower(cyc) : pHP(v)=pHP(v)-GetPower(cyc)
       pDT(v)=pDT(v)+(weapDamage(weapType(pWeapon(cyc)))*10)
       pHealth(v)=pHealth(v)-Rnd(1,weapDamage(weapType(pWeapon(cyc))))
       pHP(v)=pHP(v)-Rnd(1,weapDamage(weapType(pWeapon(cyc)))) 
       If weapName$(weapType(pWeapon(cyc)))="Syringe" And pInjured(v)<100 Then pInjured(v)=Rnd(100,500)  
      EndIf
      If blocked=1
       If pWeapon(v)>0 Then ProduceSound(p(v),weapSound(weapType(pWeapon(v))),22050,0) : DropWeapon(v,10)
       ProduceSound(p(v),weapSound(weapType(pWeapon(cyc))),22050,0)
       ProduceSound(p(v),sImpact(Rnd(4,5)),22050,0)
       CreateSpurt(pX#(v),pY#(cyc)+10,pZ#(v),2,10,4)
       For limb=4 To 29
        If pWeapon(v)=0 Then ScarLimb(v,limb,10)
       Next
       If pWeapon(v)=0 Then pHealth(v)=pHealth(v)-1
       pHP(v)=pHP(v)-Rnd(0,1)
      EndIf
      pHurtA#(v)=pA#(cyc) : pStagger#(v)=(range-contact)*0.2
      If pStagger#(v)<0.2 Then pStagger#(v)=0.2
      RiskAnger(cyc,v)
      GainStrength(cyc,50) 
      DamageRep(cyc,v,1)
      pSting(cyc)=0
     EndIf
    EndIf
   Next
  EndIf
*/
