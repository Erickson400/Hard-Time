package main

import "core:fmt"
import bb "blitzbasic3d"

////////////////////////////////////////////////////////////////////////////////
//------------------------- HARD TIME: PARTICLE EFFECTS ------------------------
////////////////////////////////////////////////////////////////////////////////

//-----------------------------------------------------------------
///////////////////////// PARTICLE EFFECTS ////////////////////////
//-----------------------------------------------------------------

LoadParticles :: proc() {
    for cyc in 1..=no_particles {
        part[cyc] = bb.LoadSprite("World/Sprites/Particle.bmp", 0)
        bb.EntityFX(part[cyc], 9)
        partState[cyc] = 0
        bb.HideEntity(part[cyc])
    }
}

CreateParticle :: proc(x: f32, y: f32, z: f32, style: i32) {
    if optFX > 0 {
        // find empty spot
        cyc: i32 = 0
        for count in 1..=no_particles {
            if partState[count] == 0 do cyc = count
        }
        // force spot!
        if cyc == 0 do cyc = bb.Rnd(1, no_particles)
        // activate new particle
        if cyc > 0 {
            partX[cyc] = x
            partY[cyc] = y
            partZ[cyc] = z
            partA[cyc] = bb.Rnd(0.0, 360.0)
            partGravity[cyc] = bb.Rnd(1.0, 2.0)
            partFlight[cyc] = 0.3
            partSize[cyc] = bb.Rnd(1.0, 5.0)
            partAlpha[cyc] = bb.Rnd(0.5, 0.9)
            partFade[cyc] = 0.02
            // unique traits
            partType[cyc] = style
            if partType[cyc] == 1 { // fire
                bb.EntityColor(part[cyc], 220, bb.Rnd(0, 100), 0)
            }
            if partType[cyc] == 2 { // smoke
                randy: i32 = bb.Rnd(0, 100)
                bb.EntityColor(part[cyc], randy, randy, randy)
                partSize[cyc] = bb.Rnd(1.0, 3.0)
                partFlight[cyc] = 0.1
                partGravity[cyc] = 0.1
                partAlpha[cyc] = bb.Rnd(0.4, 0.8)
                partFade[cyc] = 0.01
            }
            if partType[cyc] == 3 { // blood
                bb.EntityColor(part[cyc], bb.Rnd(50, 200), 0, 0)
                partFlight[cyc] = 0.2 // : partSize[cyc]=Rnd(2.0,6.0)
                partGravity[cyc] = bb.Rnd(0.5, 1.0)
                partAlpha[cyc] = bb.Rnd(0.7, 0.9)
                partFade[cyc] = 0.035
            }
            if partType[cyc] == 4 { // impact
                bb.EntityColor(part[cyc], bb.Rnd(90, 110), bb.Rnd(70, 90), bb.Rnd(40, 60)) //250,Rnd(100,200),0
                partFlight[cyc] = 0.15 // : partSize[cyc]=Rnd(2.0,6.0)
                partGravity[cyc] = bb.Rnd(0.5, 1.0)
                partAlpha[cyc] = bb.Rnd(0.6, 0.8)
                partFade[cyc] = 0.035
            }
            if partType[cyc] == 5 { // dust
                bb.EntityColor(part[cyc], 100, 80, 50)
                partAlpha[cyc] = bb.Rnd(0.2, 0.5)
                partSize[cyc] = bb.Rnd(1.0, 3.0)
                partGravity[cyc] = 0.5
            }
            if partType[cyc] == 6 { // water
                bb.EntityColor(part[cyc], 40, 60, 80)
                partFlight[cyc] = 0.3
                partSize[cyc] = bb.Rnd(2.0, 6.0)
                partGravity[cyc] = bb.Rnd(0.0, 1.0)
                partAlpha[cyc] = bb.Rnd(0.3, 0.7)
                partFade[cyc] = 0.02
            }
            if partType[cyc] == 7 { // small fire
                bb.EntityColor(part[cyc], 220, bb.Rnd(0, 100), 0)
                partSize[cyc] = bb.Rnd(0.1, 1.0)
                partGravity[cyc] = 0
                partFade[cyc] = 0.1
            }
            if partType[cyc] == 8 { // multi-coloured
                bb.EntityColor(part[cyc], bb.Rnd(100, 250), bb.Rnd(100, 250), bb.Rnd(100, 250))
            }
            if partType[cyc] == 9 { // green mist
                bb.EntityColor(part[cyc], 0, bb.Rnd(100, 180), 0)
                partGravity[cyc] = bb.Rnd(0.75, 1.25)
                partFade[cyc] = 0.03
            }
            if partType[cyc] == 10 { // explosion (fire)
                bb.EntityColor(part[cyc], 220, bb.Rnd(0, 100), 0)
                partSize[cyc] = bb.Rnd(5.0, 10.0)
                partAlpha[cyc] = bb.Rnd(0.8, 1.0)
            }
            if partType[cyc] == 11 { // explosion (foam)
                randy := bb.Rnd(100, 200)
                bb.EntityColor(part[cyc], randy, randy, randy)
                partSize[cyc] = bb.Rnd(5.0, 10.0)
                partAlpha[cyc] = bb.Rnd(0.6, 0.8)
            }
            if partType[cyc] == 12 { // explosion (water)
                bb.EntityColor(part[cyc], 40, 80, 120)
                partSize[cyc] = bb.Rnd(5.0, 10.0)
                partAlpha[cyc] = bb.Rnd(0.7, 0.9)
            }
            if partType[cyc] == 13 { // explosion (beer)
                bb.EntityColor(part[cyc], bb.Rnd(50, 150), 50, 0)
                partSize[cyc] = bb.Rnd(5.0, 10.0)
                partAlpha[cyc] = bb.Rnd(0.7, 0.9)
            }
            if partType[cyc] == 14 { // beer (small)
                bb.EntityColor(part[cyc], bb.Rnd(50, 150), 50, 0)
                partSize[cyc] = bb.Rnd(0.5, 2.0)
                partFlight[cyc] = 0
                partGravity[cyc] = 0
            }
            // reset & show
            partTim[cyc] = 0
            partState[cyc] = 1
            bb.ShowEntity(part[cyc])
            bb.PositionEntity(part[cyc], partX[cyc], partY[cyc], partZ[cyc])
            bb.RotateEntity(part[cyc], 0.0, partA[cyc], 0.0)
            bb.ScaleSprite(part[cyc], partSize[cyc], partSize[cyc])
            bb.EntityAlpha(part[cyc], partAlpha[cyc])
        }
    }
}

CreateSpurt :: proc(x, y, z, spread: f32, density, style: i32) {
    density := density
    if optFX > 0 {
        // reduce density
        if optFX <= 1 do density /= 2
        // deliver particles
        for count in 1..=density {
            if style < 99 {
                CreateParticle(x + bb.Rnd(-spread, spread), y + bb.Rnd(-spread, spread), z + bb.Rnd(-spread, spread), style)
            }
            if style == 99 {
                CreateParticle(x + bb.Rnd(-spread, spread), y + bb.Rnd(-spread, spread), z + bb.Rnd(-spread, spread), 4)
                CreateParticle(x + bb.Rnd(-spread, spread), y + bb.Rnd(-spread, spread), z + bb.Rnd(-spread, spread), 3)
            }
        }
    }
}

ParticleCycle :: proc() {
    for cyc in 1..=no_particles {
        if partState[cyc] > 0 {
            if partType[cyc] != 7 {
                // gravity
                if partGravity[cyc] > -3.0 do partGravity[cyc] -= 0.05
                if partType[cyc] == 2 && partGravity[cyc] < 0.1 do partGravity[cyc] = 0.1
                if partType[cyc] == 14 && partGravity[cyc] < -0.1 do partGravity[cyc] = -0.1
                partY[cyc] += partGravity[cyc]
                // flight
                bb.MoveEntity(part[cyc], 0.0, 0.0, partFlight[cyc])
                partX[cyc] = bb.EntityX(part[cyc])
                partZ[cyc] = bb.EntityZ(part[cyc])
            }
            // update properties
            bb.PositionEntity(part[cyc], partX[cyc], partY[cyc], partZ[cyc])
            bb.RotateEntity(part[cyc], 0.0, partA[cyc], 0.0)
            bb.ScaleSprite(part[cyc], partSize[cyc], partSize[cyc])
            // transparency
            partAlpha[cyc] -= partFade[cyc]
            bb.EntityAlpha(part[cyc], partAlpha[cyc])
            // clock
            partTim[cyc] += 1
            if partAlpha[cyc] <= 0.0 || partTim[cyc] > 1000 do partState[cyc] = 0
        }
        // remove
        if partState[cyc] == 0 do bb.HideEntity(part[cyc])
    }
}

//-----------------------------------------------------------------
/////////////////////////// EXPLOSIONS ////////////////////////////
//-----------------------------------------------------------------

CreateExplosion :: proc(source, entity: i32, x, y, z: f32, style: i32) {
    if optFX > 0 {
        // find empty slot
        cyc: i32 = 0
        for count in 1..=no_explodes {
            if exTim[count] == 0 do cyc = i32(count)
        }
        if cyc == 0 do cyc = bb.Rnd(1, no_explodes)
        // initiate explosion
        if exType[cyc] >= 11 {
            ProduceSound(entity, sExplosion, 0, 0.5)
            ProduceSound(entity, sSplash, 22050, 0)
        } else {
            ProduceSound(entity, sExplosion, 0, 1.0)
        }
        exSource[cyc] = f32(source)
        exType[cyc] = style
        exTim[cyc] = 20
        exX[cyc] = x
        exY[cyc] = y
        exZ[cyc] = z
        for v in 1..=no_plays {
            exHurt[cyc][v] = 0
        }
        // alert guards
        for count in 1..=no_plays {
            if charRole[pChar[count]] == 1 {
                pAgenda[count] = 1
                pExploreX[count] = x
                pExploreY[count] = pY[count]
                pExploreZ[count] = z
                pSubX[count] = 9999.0
                pSubZ[count] = 9999.0
            }
        }
    }
}

ExplosionCycle :: proc() {
    for cyc in 1..=no_explodes {
        if exTim[cyc] > 0 {
            // blaze
            if exTim[cyc] == 20 || exTim[cyc] == 15 || exTim[cyc] == 10 || exTim[cyc] == 5 {
                density: i32 = 25
                if optFX <= 1 do density = 12
                for count in 1..=density {
                    CreateParticle(exX[cyc] + bb.Rnd(-15.0, 15.0), bb.Rnd(exY[cyc] - 5.0, exY[cyc] + 10.0), exZ[cyc] + bb.Rnd(-15.0, 15.0), exType[cyc])
                }
                density = 15
                if optFX <= 1 do density = 7
                for count in 1..=density {
                    CreateParticle(exX[cyc] + bb.Rnd(-10.0, 10.0), bb.Rnd(exY[cyc] - 5.0, exY[cyc] + 5.0), exZ[cyc] + bb.Rnd(-10.0, 10.0), exType[cyc])
                }
                density = 5
                if optFX <= 1 do density = 2
                for count in 1..=density {
                    CreateParticle(exX[cyc] + bb.Rnd(-5.0, 5.0), exY[cyc], exZ[cyc] + bb.Rnd(-5.0, 5.0), exType[cyc])
                }
                density = 10
                if optFX <= 1 do density = 5
                for count in 1..=density {
                    CreateParticle(exX[cyc] + bb.Rnd(-10.0, 10.0), bb.Rnd(exY[cyc], exY[cyc] + 5.0), exZ[cyc] + bb.Rnd(-10.0, 10.0), 2)
                }
            }
            // mess
            if exTim[cyc] == 10 && exType[cyc] >= 11 {
                CreatePool(exX[cyc], 12.0, exZ[cyc], bb.Rnd(10.0, 15.0), 1, exType[cyc] - 9)
            }
            // human damage
            if exTim[cyc] >= 5 && exTim[cyc] <= 18 {
                for v in 1..=no_plays {
                    if BlastProximity(cyc, pX[v], pY[v], pZ[v], 40.0) do pDazed[v] = bb.Rnd(100, 300)
                    if exHurt[cyc][v] == 0 && BlastProximity(cyc, pX[v], pY[v], pZ[v], 30.0) {
                        charAttacker[pChar[v]] = pChar[i32(exSource[cyc])]
                        if exType[cyc] == 10 {
                            ProduceSound(p[v], sBlaze, 22050, 0.5)
                            if pHealth[v] > 0 do ProduceSound(p[v], sPain[bb.Rnd(1, 8)], 22050, 0)
                            CreateSpurt(pX[v], bb.EntityY(pLimb[v][1], 1), pZ[v], 5.0, 10, 2)
                            CreatePool(pX[v], pGround[v], pZ[v], bb.Rnd(5.0, 10.0), 3, 1)
                            ScarArea(v, 0, 0, 0, 1)
                            RiskInjury(v, 25)
                            pHealth[v] -= 10
                        }
                        pHealth[v] -= 10
                        pHP[v] = 0
                        if AttackViable(v) != 3 do pDT[v] = (150 - cast(i32)pHealth[v]) * 2
                        if AttackViable(v) >= 1 && AttackViable(v) <= 2 do ChangeAnim(v, 70)
                        if AttackViable(v) == 3 do GroundReaction(v)
                        if BlastProximity(cyc, pX[v], pY[v], pZ[v], 15.0) {
                            randy: i32 = bb.Rnd(1, 3)
                            if randy == 1 && pHealth[v] > 0 do ChangeAnim(v, 80)
                            if randy == 2 && pHealth[v] > 0 do ChangeAnim(v, 83)
                            if randy == 3 && pHealth[v] > 0 do ChangeAnim(v, 86)
                            if exType[cyc] == 10 {
                                ScarArea(v, 0, 0, 0, 1)
                                RiskInjury(v, 25)
                                pHealth[v] -= 10
                            }
                            if AttackViable(v) != 3 do pDT[v] = (200 - cast(i32)pHealth[v]) * 2
                        }
                        if exSource[cyc] > 0 {
                            RiskAnger(i32(exSource[cyc]), v)
                            DamageRep(i32(exSource[cyc]), v, 1)
                            if exType[cyc] == 10 do DamageRep(i32(exSource[cyc]), v, 1)
                            if i32(exSource[cyc]) == gamPlayer[slot] && gamMission[slot] != 11 && gamMission[slot] != 12 {
                                for count in 1..=no_plays {
                                    if charRole[pChar[count]] == 1 && Friendly(count, gamPlayer[slot]) == 0 && charBribeTim[pChar[count]] == 0 && AttackViable(count) >= 1 && AttackViable(count) <= 2 {
                                        if InLine(count, p[gamPlayer[slot]], 60.0) || InLine(count, p[v], 60.0) {
                                            randy := bb.Rnd(0, 20)
                                            if exType[cyc] == 10 do randy = bb.Rnd(0, 5)
                                            if randy == 0 && gamWarrant[slot] < 4 {
                                                gamWarrant[slot] = 4
                                                gamItem[slot] = pWeapon[cyc] // prosecuted for carrying
                                            }
                                            if randy == 1 && gamWarrant[slot] < 10 {
                                                gamWarrant[slot] = 10
                                                gamItem[slot] = pWeapon[cyc] // prosecuted for assault
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        exHurt[cyc][v] = 1
                    }
                }
            }
            // expire
            exTim[cyc] -= 1
        }
    }
}



/*

*/
