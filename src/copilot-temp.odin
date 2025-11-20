package main

import "core:fmt"
import bb "blitzbasic3d"

part_two :: proc() {
    {
        if pAnimTim[cyc] >= 4 && pAnimTim[cyc] <= 10 && pScar[cyc][32] <= 4 && pSting[cyc] == 1 {
            for v in 1..=no_plays {
                range: i32 = pAnimTim[cyc] - 3
                if cyc != v && (Friendly(cyc, v) == 0 || v == pFoc[cyc]) && InProximity(cyc, v, 15 + range) && pY[cyc] > pY[v] - 30 && pY[cyc] < pY[v] + 5 && AttackViable(v) >= 1 && AttackViable(v) <= 2 && pSting[cyc] == 1 {
                    contact: i32 = InRange(cyc, v, range)
                    if contact > 0 {
                        charAttacker[pChar[v]] = pChar[cyc]
                        blocked: i32 = 0
                        randy: i32 = bb.Rnd(0, 10)
                        if randy <= 5 + BlockPower(v) && pAnim[v] >= 74 && pAnim[v] <= 75 && InLine(v, p[cyc], 90) do blocked = 1
                        if blocked == 0 {
                            ProduceSound(p[v], sImpact(bb.Rnd(1, 2)), 22050, 0)
                            ProduceSound(p[v], sPain(bb.Rnd(1, 8)), 22050, 0)
                            CreateSpurt(pX[v], pY[cyc], pZ[v], 2, 10, 99)
                            ScarLimb(v, 4, 10)
                            ChangeAnim(v, 71)
                            pDT[v] = (110 - pHealth[v]) * 2
                            pHealth[v] -= GetPower(cyc)
                            pHP[v] -= GetPower(cyc)
                        }
                        if blocked == 1 {
                            ProduceSound(p[v], sImpact(bb.Rnd(4, 5)), 22050, 0)
                            CreateSpurt(pX[v], pY[cyc], pZ[v], 2, 10, 4)
                            pHP[v] -= bb.Rnd(0, 1)
                        }
                        WeaponImpact(cyc, v, blocked)
                        pHurtA[v] = pA[cyc]
                        pStagger[v] = f32(8 - contact) * 0.2
                        if pStagger[v] < 0.2 do pStagger[v] = 0.2
                        RiskAnger(cyc, v)
                        GainStrength(cyc, 50)
                        DamageRep(cyc, v, 0)
                        pSting[cyc] = 0
                    }
                }
            }
        }
        if pAnimTim[cyc] > 18 do ChangeAnim(cyc, 0)
    }


}


/*
  If pAnimTim(cyc)=>4 And pAnimTim(cyc)=<10 And pScar(cyc,32)=<4 And pSting(cyc)=1
   
*/
