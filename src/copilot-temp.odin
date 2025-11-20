package main

import "core:fmt"
import bb "blitzbasic3d"


Part1 :: proc(cyc: i32) {
    //----------- 0-10: STANCES ----------
    //standing
    if pAnim[cyc] == 0 {
        anim: i32 = 1
        speeder := bb.Rnd(0.1, 0.3)
        if gamPromo > 0 && (cyc == promoActor[1] || cyc == promoActor[2]) && pSpeaking[cyc] == 1 {
            if pPromoState[cyc] > 0 {
                anim = 120 + pPromoState[cyc]
                speeder = bb.Rnd(0.25, 0.5)
            }
            if pPromoState[cyc] >= 2 && pPromoState[cyc] <= 3 {
                anim = 120 + pPromoState[cyc]
                speeder = bb.Rnd(0.1, 0.3)
            }
            if pWeapon[cyc] > 0 && pPromoState[cyc] >= 2 && pPromoState[cyc] <= 3 {
                anim = 121
                speeder = bb.Rnd(0.25, 0.5)
            }
        }
        if pWeapon[cyc] > 0 && weapStyle[weapType[pWeapon[cyc]]] == 4 {
            anim = 60
            speeder = bb.Rnd(0.1, 0.3)
        }
        if pInjured[cyc] > 0 || pHealth[cyc] < 10 do anim = 3
        if pDazed[cyc] > 0 {
            anim = 4
            speeder = bb.Rnd(0.3, 0.6)
        }
        if pPhone[cyc] > 0 {
            anim = 120
            speeder = bb.Rnd(0.1, 0.3)
        }
        relaxed := 0
        if (anim == 1 || anim == 122 || anim == 123) && (pState[cyc] == 1 || pState[cyc] == 122 || pState[cyc] == 123) {
            relaxed = 1
        }
        if pAnimTim[cyc] == 0 || (anim != pState[cyc] && relaxed == 0) {
            bb.Animate(p[cyc], 1, speeder, pSeq[cyc][anim], 10)
            pState[cyc] = anim
        }
        if gotim > 50 && pAnimTim[cyc] > 30 && pWeapon[cyc] > 0 && pPhone[cyc] == 0 && cyc != promoActor[1] && cyc != promoActor[2] {
            if weapName[weapType[pWeapon[cyc]]] == "Broom" {
                ChangeAnim(cyc, 92)
                pAgenda[cyc] = 0
                pTA[cyc] = pA[cyc]
            }
            if charRole[pChar[cyc]] == 0 && weapName[weapType[pWeapon[cyc]]] == "Cigarette" {
                ChangeAnim(cyc, 93)
                pAgenda[cyc] = 0
                pTA[cyc] = pA[cyc]
            }
            if charRole[pChar[cyc]] == 0 && weapName[weapType[pWeapon[cyc]]] == "Syringe" {
                ChangeAnim(cyc, 94)
                pAgenda[cyc] = 0
                pTA[cyc] = pA[cyc]
            }
            if charRole[pChar[cyc]] == 0 && weapName[weapType[pWeapon[cyc]]] == "Bottle" {
                ChangeAnim(cyc, 95)
                pAgenda[cyc] = 0
                pTA[cyc] = pA[cyc]
            }
            if weapName[weapType[pWeapon[cyc]]] == "Comb" {
                ChangeAnim(cyc, 97)
                pAgenda[cyc] = 0
                pTA[cyc] = pA[cyc]
            }
            if weapName[weapType[pWeapon[cyc]]] == "Mirror" {
                ChangeAnim(cyc, 98)
                pAgenda[cyc] = 0
                pTA[cyc] = pA[cyc]
            }
            if weapName[weapType[pWeapon[cyc]]] == "Dumbbell" {
                ChangeAnim(cyc, 132)
                pAgenda[cyc] = 0
                pTA[cyc] = pA[cyc]
            }
        }
    }
    //kneeling
    if pAnim[cyc] == 1 {
        anim: i32 = 2
        if pAnimTim[cyc] == 0 || anim != pState[cyc] {
            bb.Animate(p[cyc], 1, bb.Rnd(0.1, 0.3), pSeq[cyc][anim], 10)
            pState[cyc] = anim
        }
        if pAnimTim[cyc] > 5 {
            if DirPressed(cyc) || pDazed[cyc] > 0 || cyc == promoActor[1] || cyc == promoActor[2] {
                ChangeAnim(cyc, 0)
            }
        }
    }
    //----------- 10-20: MOVEMENT ----------
    //standing turn
    if pAnim[cyc] == 10 {
        anim: i32 = 10
        if pWeapon[cyc] > 0 && weapStyle[weapType[pWeapon[cyc]]] == 4 do anim = 61
        if pWeapon[cyc] > 0 && weapStyle[weapType[pWeapon[cyc]]] == 5 do anim = 17
        if pInjured[cyc] > 0 || pHealth[cyc] < 10 do anim = 14
        if pDazed[cyc] > 0 do anim = 15
        if pAnimTim[cyc] == 0 || anim != pState[cyc] {
            randy: i32 = bb.Rnd(-1, 1)
            if randy == -1 do bb.Animate(p[cyc], 1, -3.0, pSeq[cyc][anim], 5)
            if randy >= 0 do bb.Animate(p[cyc], 1, 3.0, pSeq[cyc][anim], 5)
            pState[cyc] = anim
        }
        if pDazed[cyc] > 0 {
            if cast(bool)cLeft[cyc] do pA[cyc] -= 5
            if cast(bool)cRight[cyc] do pA[cyc] += 5
        } else {
            if cast(bool)cLeft[cyc] do pA[cyc] += 10
            if cast(bool)cRight[cyc] do pA[cyc] -= 10
        }
        pA[cyc] = CleanAngle(pA[cyc])
        if pAnimTim[cyc] > 5 {
            if HorizontalPressed(cyc) == 0 || VerticalPressed(cyc) do ChangeAnim(cyc, 0)
        }
        pStepTim[cyc] += 1
    }
    // kneeling turn
    if pAnim[cyc] == 11 {
        anim: i32 = 11
        if pAnimTim[cyc] == 0 || anim != pState[cyc] {
            randy: i32 = bb.Rnd(-1, 1)
            if randy == -1 do bb.Animate(p[cyc], 1, -3.0, pSeq[cyc][anim], 5)
            if randy >= 0 do bb.Animate(p[cyc], 1, 3.0, pSeq[cyc][anim], 5)
            pState[cyc] = anim
        }
        if cast(bool)cLeft[cyc] do pA[cyc] += 5
        if cast(bool)cRight[cyc] do pA[cyc] -= 5
        pA[cyc] = CleanAngle(pA[cyc])
        if pAnimTim[cyc] > 5 {
            if HorizontalPressed(cyc) == 0 || VerticalPressed(cyc) || pDazed[cyc] > 0 {
                ChangeAnim(cyc, 1)
            }
        }
        pStepTim[cyc] += 1
    }
    // walking
    if pAnim[cyc] == 12 {
        anim: i32 = 12
        transition: i32 = 5
        speeder: f32 = pSpeed[cyc] * 2.0
        if pWeapon[cyc] > 0 && weapStyle[weapType[pWeapon[cyc]]] == 4 do anim = 61
        if pWeapon[cyc] > 0 && weapStyle[weapType[pWeapon[cyc]]] == 5 do anim = 17
        if pHealth[cyc] < 10 {
            anim = 14
            speeder = pSpeed[cyc] * 3.0
        }
        if pInjured[cyc] > 0 {
            anim = 14
            speeder = pSpeed[cyc] * 4.0
        }
        if pDazed[cyc] > 0 {
            anim = 15
            speeder = pSpeed[cyc] * 5.0
        }
        if speeder < 3.0 do speeder = 3.0
        if pOldAnim[cyc] == 1 || pOldAnim[cyc] == 11 do transition = 10
        if pAnimTim[cyc] == 0 || anim != pState[cyc] {
            bb.Animate(p[cyc], 1, speeder, pSeq[cyc][anim], transition)
            pState[cyc] = anim
        }
        ApplyMovement(cyc, pSpeed[cyc])
        if pAnimTim[cyc] > 5 {
            if VerticalPressed(cyc) == 0 do ChangeAnim(cyc, 0)
        }
        if cast(bool)cDefend[cyc] && pInjured[cyc] == 0 && pDazed[cyc] == 0 do ChangeAnim(cyc, 13)
        pStepTim[cyc] += 1
    }
    // running
    if pAnim[cyc] == 13 {
        anim: i32 = 13
        transition: i32 = 5
        speeder: f32 = pSpeed[cyc] * 3.0
        if pWeapon[cyc] > 0 do anim = 16
        if pWeapon[cyc] > 0 && weapStyle[weapType[pWeapon[cyc]]] == 4 do anim = 62
        if pWeapon[cyc] > 0 && weapStyle[weapType[pWeapon[cyc]]] == 5 do anim = 18
        if speeder < 3.0 do speeder = 3.0
        if pOldAnim[cyc] == 1 || pOldAnim[cyc] == 11 do transition = 10
        if pAnimTim[cyc] == 0 || anim != pState[cyc] {
            bb.Animate(p[cyc], 1, speeder, pSeq[cyc][anim], transition)
            pState[cyc] = anim
        }
        ApplyMovement(cyc, pSpeed[cyc] * 2)
        if pAnimTim[cyc] > 5 {
            if VerticalPressed(cyc) == 0 || cast(bool)cDefend[cyc] == false || pDazed[cyc] > 0 do ChangeAnim(cyc, 0)
        }
        pStepTim[cyc] += 2
    }
    //----------- 20-30: WEAPON INTERACTION ----------
    // pick up weapon
    if pAnim[cyc] == 20 {
        if pAnimTim[cyc] == 0 do bb.Animate(p[cyc], 3, 3.0, pSeq[cyc][20], 5)
        if pAnimTim[cyc] <= 11 && WeaponProximity(cyc, v, 5) == 0 {
            bb.RotateEntity(pPivot[cyc], 0, pA[cyc], 0)
            bb.MoveEntity(pPivot[cyc], 0, 0, 0.3)
            pStepTim[cyc] += bb.Rnd(0, 1)
        }
        if pAnimTim[cyc] == 5 do ProduceSound(p[cyc], sSwing, 22050, 0.1)
        if pAnimTim[cyc] == 11 && cast(bool)HandIntact(cyc, 17) {
            for v in 1..=no_weaps {
                range: f32 = weapSize[weapType[v]] + 5
                if weapLocation[v] == gamLocation[slot] && weapState[v] > 0 && pWeapon[cyc] == 0 && pWeaponTim[cyc][v] == 0 && weapCarrier[v] == 0 && pY[cyc] >= weapY[v] - 15 && pY[cyc] <= weapY[v] + 15 {
                    if cast(bool)LimbProximity(pLimb(cyc, 19), weapX[v], weapZ[v], range) || cast(bool)WeaponProximity(cyc, v, 5) {
                        ProduceSound(p[cyc], sShuffle(bb.Rnd(1, 3)), 22050, 0)
                        ProduceSound(p[cyc], weapSound[weapType[v]], 22050, 0.5)
                        CreateSpurt(weapX[v], weapY[v] + 1, weapZ[v], 2, 10, 5)
                        AttainWeapon(cyc, v)
                    }
                }
            }
        }
        if pAnimTim[cyc] > 20 {
            if pWeapon[cyc] > 0 && charWeapHistory[pChar[cyc]][weapType[pWeapon[cyc]]] == 0 {
                ChangeAnim(cyc, 24)
            } else {
                ChangeAnim(cyc, 0)
            }
        }
    }
    // drop weapon
    if pAnim[cyc] == 21 {
        if pAnimTim[cyc] == 0 do bb.Animate(p[cyc], 3, 2.0, pSeq[cyc][21], 10)
        if pAnimTim[cyc] == 4 do DropWeapon(cyc, 0)
        if pAnimTim[cyc] > 6 do ChangeAnim(cyc, 0)
    }
    // throw weapon
    if pAnimTim[cyc] == 22 {
        if pAnimTim[cyc] == 0 {
            bb.Animate(p[cyc], 3, 3.5, pSeq[cyc][22], 5)
            weapGravity[pWeapon[cyc]] = 1.0
        }
        if pAnimTim[cyc] == 6 do ProduceSound(p[cyc], sSwing, 22050, 0)
        if pAnimTim[cyc] <= 11 {
            if cast(bool)cThrow[cyc] || pControl[cyc] == 0 {
                weapGravity[pWeapon[cyc]] += 0.25
            }
        }
        if pAnimTim[cyc] == 11 do ThrowWeapon(cyc)
        if pAnimTim[cyc] > 21 do ChangeAnim(cyc, 0)
    }
    // snatch weapon





}



/*
 ;----------- 10-20: MOVEMENT ----------
 ;standing turn
 If pAnim(cyc)=10
  anim=10
  If pWeapon(cyc)>0 And weapStyle(weapType(pWeapon(cyc)))=4 Then anim=61
  If pWeapon(cyc)>0 And weapStyle(weapType(pWeapon(cyc)))=5 Then anim=17 
  If pInjured(cyc)>0 Or pHealth(cyc)<10 Then anim=14
  If pDazed(cyc)>0 Then anim=15
  If pAnimTim(cyc)=0 Or anim<>pState(cyc)
   randy=Rnd(-1,1)
   If randy=-1 Then Animate p(cyc),1,-3.0,pSeq(cyc,anim),5
   If randy=>0 Then Animate p(cyc),1,3.0,pSeq(cyc,anim),5
   pState(cyc)=anim
  EndIf
  If pDazed(cyc)>0
   If cLeft(cyc) Then pA#(cyc)=pA#(cyc)-5
   If cRight(cyc) Then pA#(cyc)=pA#(cyc)+5
  Else
   If cLeft(cyc) Then pA#(cyc)=pA#(cyc)+10
   If cRight(cyc) Then pA#(cyc)=pA#(cyc)-10
  EndIf
  pA#(cyc)=CleanAngle#(pA#(cyc))
  If pAnimTim(cyc)>5
   If HorizontalPressed(cyc)=0 Or VerticalPressed(cyc) Then ChangeAnim(cyc,0)
  EndIf
  pStepTim(cyc)=pStepTim(cyc)+1
 EndIf
 ;kneeling turn
 If pAnim(cyc)=11
  anim=11
  If pAnimTim(cyc)=0 Or anim<>pState(cyc)
   randy=Rnd(-1,1)
   If randy=-1 Then Animate p(cyc),1,-3.0,pSeq(cyc,anim),5
   If randy=>0 Then Animate p(cyc),1,3.0,pSeq(cyc,anim),5
   pState(cyc)=anim
  EndIf
  If cLeft(cyc) Then pA#(cyc)=pA#(cyc)+5
  If cRight(cyc) Then pA#(cyc)=pA#(cyc)-5
  pA#(cyc)=CleanAngle#(pA#(cyc))
  If pAnimTim(cyc)>5
   If HorizontalPressed(cyc)=0 Or VerticalPressed(cyc) Or pDazed(cyc)>0 Then ChangeAnim(cyc,1)
  EndIf
  pStepTim(cyc)=pStepTim(cyc)+1
 EndIf
 ;walking
 If pAnim(cyc)=12
  anim=12 : transition=5
  speeder#=pSpeed#(cyc)*2.0
  If pWeapon(cyc)>0 And weapStyle(weapType(pWeapon(cyc)))=4 Then anim=61
  If pWeapon(cyc)>0 And weapStyle(weapType(pWeapon(cyc)))=5 Then anim=17
  If pHealth(cyc)<10 Then anim=14 : speeder#=pSpeed#(cyc)*3.0
  If pInjured(cyc)>0 Then anim=14 : speeder#=pSpeed#(cyc)*4.0
  If pDazed(cyc)>0 Then anim=15 : speeder#=pSpeed#(cyc)*5.0
  If speeder#<3.0 Then speeder#=3.0
  If pOldAnim(cyc)=1 Or pOldAnim(cyc)=11 Then transition=10
  If pAnimTim(cyc)=0 Or anim<>pState(cyc)
   Animate p(cyc),1,speeder#,pSeq(cyc,anim),transition
   pState(cyc)=anim
  EndIf
  ApplyMovement(cyc,pSpeed#(cyc))
  If pAnimTim(cyc)>5 
   If VerticalPressed(cyc)=0 Then ChangeAnim(cyc,0)
  EndIf
  If cDefend(cyc) And pInjured(cyc)=0 And pDazed(cyc)=0 Then ChangeAnim(cyc,13)
  pStepTim(cyc)=pStepTim(cyc)+1
 EndIf
 ;running
 If pAnim(cyc)=13
  anim=13 : transition=5
  speeder#=pSpeed#(cyc)*3.0
  If pWeapon(cyc)>0 Then anim=16
  If pWeapon(cyc)>0 And weapStyle(weapType(pWeapon(cyc)))=4 Then anim=62
  If pWeapon(cyc)>0 And weapStyle(weapType(pWeapon(cyc)))=5 Then anim=18
  If speeder#<3.0 Then speeder#=3.0
  If pOldAnim(cyc)=1 Or pOldAnim(cyc)=11 Then transition=10
  If pAnimTim(cyc)=0 Or anim<>pState(cyc)
   Animate p(cyc),1,speeder#,pSeq(cyc,anim),transition
   pState(cyc)=anim
  EndIf
  ApplyMovement(cyc,pSpeed#(cyc)*2)
  If pAnimTim(cyc)>5 
   If VerticalPressed(cyc)=0 Or cDefend(cyc)=0 Or pDazed(cyc)>0 Then ChangeAnim(cyc,0)
  EndIf
  pStepTim(cyc)=pStepTim(cyc)+2
 EndIf
 ;----------- 20-30: WEAPON INTERACTION ----------
 ;pick up weapon
 If pAnim(cyc)=20
  If pAnimTim(cyc)=0 Then Animate p(cyc),3,3.0,pSeq(cyc,20),5
  If pAnimTim(cyc)=<11 And WeaponProximity(cyc,v,5)=0
   RotateEntity pPivot(cyc),0,pA#(cyc),0
   MoveEntity pPivot(cyc),0,0,0.3
   pStepTim(cyc)=pStepTim(cyc)+Rnd(0,1)
  EndIf
  If pAnimTim(cyc)=5 Then ProduceSound(p(cyc),sSwing,22050,0.1)
  If pAnimTim(cyc)=11 And HandIntact(cyc,17)
   For v=1 To no_weaps
    range=weapSize#(weapType(v))+5
    If weapLocation(v)=gamLocation(slot) And weapState(v)>0 And pWeapon(cyc)=0 And pWeaponTim(cyc,v)=0 And weapCarrier(v)=0 And pY#(cyc)=>weapY#(v)-15 And pY#(cyc)=<weapY#(v)+15
     If LimbProximity(pLimb(cyc,19),weapX#(v),weapZ#(v),range) Or WeaponProximity(cyc,v,5)
	  ProduceSound(p(cyc),sShuffle(Rnd(1,3)),22050,0)
	  ProduceSound(p(cyc),weapSound(weapType(v)),22050,0.5)
	  CreateSpurt(weapX#(v),weapY#(v)+1,weapZ#(v),2,10,5) 
	  AttainWeapon(cyc,v) 
	 EndIf
	EndIf
   Next
  EndIf
  If pAnimTim(cyc)>20
   If pWeapon(cyc)>0 And charWeapHistory(pChar(cyc),weapType(pWeapon(cyc)))=0
    ChangeAnim(cyc,24)
   Else
    ChangeAnim(cyc,0)
   EndIf
  EndIf
 EndIf
 ;drop weapon
 If pAnim(cyc)=21
  If pAnimTim(cyc)=0 Then Animate p(cyc),3,2.0,pSeq(cyc,21),10
  If pAnimTim(cyc)=4 Then DropWeapon(cyc,0)
  If pAnimTim(cyc)>6 Then ChangeAnim(cyc,0)
 EndIf
 ;throw weapon
 If pAnim(cyc)=22
  If pAnimTim(cyc)=0 
   Animate p(cyc),3,3.5,pSeq(cyc,22),5
   weapGravity#(pWeapon(cyc))=1.0
  EndIf
  If pAnimTim(cyc)=6 Then ProduceSound(p(cyc),sSwing,22050,0)
  If pAnimTim(cyc)=<11
   If cThrow(cyc)=1 Or pControl(cyc)=0 Then weapGravity#(pWeapon(cyc))=weapGravity#(pWeapon(cyc))+0.25 
  EndIf
  If pAnimTim(cyc)=11 Then ThrowWeapon(cyc)
  If pAnimTim(cyc)>21 Then ChangeAnim(cyc,0)
 EndIf
 ;snatch weapon
 If pAnim(cyc)=23
  If pAnimTim(cyc)=0 Then Animate p(cyc),3,3.5,pSeq(cyc,23),5 : pSting(cyc)=1
  If pAnimTim(cyc)=<15 And weapCarrier(NearestWeapon(cyc))>0
   FaceEntity(cyc,weap(NearestWeapon(cyc)),5)
   RotateEntity pPivot(cyc),0,pA#(cyc),0
   MoveEntity pPivot(cyc),0,0,0.5
   pStepTim(cyc)=pStepTim(cyc)+Rnd(0,1)
  EndIf                                                                    
  If pAnimTim(cyc)=6 Then ProduceSound(p(cyc),sSwing,22050,Rnd(0.2,0.5))
  If pAnimTim(cyc)=>9 And pAnimTim(cyc)=<13 And HandIntact(cyc,17) And pSting(cyc)=1
   For v=1 To no_plays
    w=pWeapon(v)
    If w>0 And cyc<>v And pWeapon(cyc)=0 And AttackViable(v)=>1 And AttackViable(v)=<2 And pY#(cyc)>pY#(v)-15 And pY#(cyc)<pY#(v)+15 And pSting(cyc)=1
     If LimbProximity(pLimb(cyc,19),EntityX(pLimb(v,19),1),EntityZ(pLimb(v,19),1),10) Or InRange(cyc,v,4)>0
      charAttacker(pChar(v))=pChar(cyc)
      ProduceSound(p(v),sImpact(Rnd(4,5)),22050,0)
      ProduceSound(p(v),sPain(Rnd(1,8)),22050,0)
      CreateSpurt(EntityX(pLimb(v,19),1),EntityY(pLimb(v,19),1)-5,EntityZ(pLimb(v,19),1),2,10,4)
      pHurtA#(v)=pA#(cyc) : pStagger#(v)=0.6
      ChangeAnim(v,71)   
      ProduceSound(p(cyc),sShuffle(Rnd(1,3)),22050,0)
	  ProduceSound(p(v),weapSound(weapType(w)),22050,0)
	  randy=Rnd(0,2)
      If randy=<1
       HideEntity FindChild(p(v),weapFile$(weapType(w)))
       AttainWeapon(cyc,w)
       pWeapon(v)=0 
      EndIf
      If randy=2 Then DropWeapon(v,0)
      If GetResponse(cyc,v,0)>0 And pChar(cyc)=gamChar(slot) And charPromo(pChar(v),pChar(cyc))=0
       charPromo(pChar(v),pChar(cyc))=17
       If charGang(pChar(v))=6 Then charPromo(pChar(v),pChar(cyc))=44
      EndIf 
      RiskAnger(cyc,v)
      DamageRep(cyc,v,2)
      pSting(cyc)=0
     EndIf
    EndIf
   Next
   For v=1 To no_weaps
    range=weapSize#(weapType(v))+5
    If weapLocation(v)=gamLocation(slot) And weapState(v)>0 And pWeapon(cyc)=0 And pWeaponTim(cyc,v)=0 And weapCarrier(v)=0 And pY#(cyc)=>weapY#(v)-40 And pY#(cyc)<weapY#(v)-10
     If LimbProximity(pLimb(cyc,19),weapX#(v),weapZ#(v),range) Or WeaponProximity(cyc,v,5)
	  ProduceSound(p(cyc),sShuffle(Rnd(1,3)),22050,0)
	  ProduceSound(p(cyc),weapSound(weapType(v)),22050,0.5)
	  CreateSpurt(weapX#(v),weapY#(v)+1,weapZ#(v),2,10,5) 
	  AttainWeapon(cyc,v) 
	 EndIf
	EndIf
   Next
  EndIf
  If pAnimTim(cyc)>20
   If pWeapon(cyc)>0 And charWeapHistory(pChar(cyc),weapType(pWeapon(cyc)))=0
    ChangeAnim(cyc,24)
   Else
    ChangeAnim(cyc,0)
   EndIf
  EndIf
 EndIf
 ;examine weapon
 If pAnim(cyc)=24
  If pAnimTim(cyc)=0 Then Animate p(cyc),3,Rnd(0.5,1.0),pSeq(cyc,24),15
  If pAnimTim(cyc)>10
   randy=Rnd(0,80)
   If Isolated(cyc,30)=0 Then randy=Rnd(0,40)
   If Isolated(cyc,20)=0 Then randy=Rnd(0,20)
   If Isolated(cyc,10)=0 Then randy=Rnd(0,10)
   If randy=0 Or pAnimTim(cyc)>80 Or charWeapHistory(pChar(cyc),weapType(pWeapon(cyc)))>0 Or pWeapon(cyc)=0
    If pWeapon(cyc)>0 Then charWeapHistory(pChar(cyc),weapType(pWeapon(cyc)))=1
    ChangeAnim(cyc,0)
   EndIf
  EndIf
  pEyes(cyc)=3 : pSpeaking(cyc)=1
 EndIf
 ;handover (execute)
 If pAnim(cyc)=25
  If pAnimTim(cyc)=0 Then Animate p(cyc),3,1.5,pSeq(cyc,25),5
  If pAnimTim(cyc)=13 And pWeapon(cyc)>0
   w=pWeapon(cyc)
   ProduceSound(p(cyc),sShuffle(Rnd(1,3)),22050,0)
   ProduceSound(p(cyc),weapSound(weapType(w)),22050,0.5)
   DropWeapon(cyc,0)
   If pWeapon(pFoc(cyc))=0 Then AttainWeapon(pFoc(cyc),w)
   TradingRisk(cyc,w)
  EndIf
  If pAnimTim(cyc)>26 Then ChangeAnim(cyc,0)
 EndIf
 ;handover (receive)
 If pAnim(cyc)=26
  If pAnimTim(cyc)=0 Then Animate p(cyc),3,1.5,pSeq(cyc,25),5 : DropWeapon(cyc,0)
  If pAnimTim(cyc)>26
   If pWeapon(cyc)>0 ;And charWeapHistory(pChar(cyc),weapType(pWeapon(cyc)))=0
    TradingRisk(cyc,pWeapon(cyc))
    ChangeAnim(cyc,24)
   Else
    ChangeAnim(cyc,0)
   EndIf
  EndIf
 EndIf
 ;basketball throw
 If pAnim(cyc)=27
  If pAnimTim(cyc)=0 
   Animate p(cyc),3,2.5,pSeq(cyc,26),10
   weapGravity#(pWeapon(cyc))=2.0
  EndIf
  If pAnimTim(cyc)=10 Then ProduceSound(p(cyc),sSwing,22050,0)
  If pAnimTim(cyc)=<16
   If cThrow(cyc)=1 Or pControl(cyc)=0 Then weapGravity#(pWeapon(cyc))=weapGravity#(pWeapon(cyc))+0.2
  EndIf
  If pAnimTim(cyc)=16 Then ThrowWeapon(cyc)
  If pAnimTim(cyc)=20
   ProduceSound(p(cyc),sThud,22050,0.5) : pStepTim(cyc)=99
   pHealth(cyc)=pHealth(cyc)-Rnd(0,1) 
   randy=Rnd(0,100)
   If randy=0 And gamGrowth(slot)=>0 Then gamGrowth(slot)=gamGrowth(slot)-1
  EndIf
  If pAnimTim(cyc)>28 Then ChangeAnim(cyc,0)
 EndIf
 ;phone pick-up
 If pAnim(cyc)=28
  If pAnimTim(cyc)=0 Then Animate p(cyc),3,3.0,pSeq(cyc,27),5
  If pAnimTim(cyc)=4 Then ProduceSound(p(cyc),sSwing,22050,Rnd(0.1,0.3))
  If pAnimTim(cyc)=8 And pScar(cyc,6)=<4 And pPhone(cyc)=0
   v=PhoneProximity(cyc)
   If v>0 And PhoneTaken(v)=0
    ProduceSound(p(cyc),sPhone,22050,0)
    HideEntity FindChild(world,"Phone"+Dig$(v,10))
    ShowEntity FindChild(p(cyc),"Phone")
    If phoneRing=v
     PositionEntity FindChild(world,"Phone"+Dig$(phoneRing,10)),phoneX#(phoneRing),phoneY#(phoneRing),phoneZ#(phoneRing)
     EntityColor FindChild(world,"Alarm"+Dig$(phoneRing,10)),5,0,0 
     EntityFX FindChild(world,"Alarm"+Dig$(phoneRing,10)),0
     StopChannel chPhone
     phoneRing=0 : phoneTim=0
     If pChar(cyc)=gamChar(slot) And phonePromo>0 Then TriggerPromo(-v,cyc,phonePromo) : phonePromo=0
    EndIf
    pPhone(cyc)=v
   EndIf
  EndIf
  If pAnimTim(cyc)>8 And pPhone(cyc)>0 Then ChangeAnim(cyc,0) : pAgenda(cyc)=0
  If pAnimTim(cyc)>15 Then ChangeAnim(cyc,0)
 EndIf
 ;phone put-down
 If pAnim(cyc)=29
  If pAnimTim(cyc)=0 Then Animate p(cyc),3,3.0,pSeq(cyc,27),5
  If pAnimTim(cyc)=4 Then ProduceSound(p(cyc),sSwing,22050,Rnd(0.1,0.3))
  If pAnimTim(cyc)=8 And pPhone(cyc)>0
   ProduceSound(p(cyc),sPhone,22050,0)
   HideEntity FindChild(p(cyc),"Phone")
   ShowEntity FindChild(world,"Phone"+Dig$(pPhone(cyc),10))
   pPhone(cyc)=0
  EndIf
  If pAnimTim(cyc)>15 Then ChangeAnim(cyc,0)
 EndIf
 ;----------- 30-40: HAND-2-HAND ATTACKS ----------
 ;upper punch
 If pAnim(cyc)=30
  If pAnimTim(cyc)=0 Then Animate p(cyc),3,4.0,pSeq(cyc,30),5 : pSting(cyc)=1
  If pAnimTim(cyc)=3 Then ProduceSound(p(cyc),sSwing,22050,Rnd(0.1,0.3))
  If pAnimTim(cyc)=<15
   FaceEntity(cyc,p(pFoc(cyc)),5)
   RotateEntity pPivot(cyc),0,pA#(cyc),0
   MoveEntity pPivot(cyc),0,0,0.5
   pStepTim(cyc)=pStepTim(cyc)+Rnd(0,1)
  EndIf
  If pAnimTim(cyc)=>4 And pAnimTim(cyc)=<10 And pScar(cyc,18)=<4 And pSting(cyc)=1
   For v=1 To no_plays
    range=pAnimTim(cyc)-3
    If cyc<>v And (Friendly(cyc,v)=0 Or v=pFoc(cyc)) And InProximity(cyc,v,15+range) And pY#(cyc)>pY#(v)-30 And pY#(cyc)<pY#(v)+5 And AttackViable(v)=>1 And AttackViable(v)=<2 And pSting(cyc)=1
     contact=InRange(cyc,v,range)
     If contact>0
      charAttacker(pChar(v))=pChar(cyc)
      blocked=0
      randy=Rnd(0,10)
      If randy=<5+BlockPower(v) And pAnim(v)=>74 And pAnim(v)=<75 And InLine(v,p(cyc),90) Then blocked=1
      If blocked=0
       ProduceSound(p(v),sImpact(Rnd(1,2)),22050,0)
       ProduceSound(p(v),sPain(Rnd(1,8)),22050,0)
       CreateSpurt(pX#(v),pY#(cyc)+22,pZ#(v),2,10,99)
       ScarLimb(v,1,10)
       ChangeAnim(v,70) : pDT(v)=(110-pHealth(v))*2
       pHealth(v)=pHealth(v)-GetPower(cyc) : pHP(v)=pHP(v)-GetPower(cyc)
      EndIf
      If blocked=1 
       If pWeapon(v)>0 Then ProduceSound(p(v),weapSound(weapType(pWeapon(v))),22050,0) : DropWeapon(v,10)
       ProduceSound(p(v),sImpact(Rnd(4,5)),22050,0)
       CreateSpurt(pX#(v),pY#(cyc)+22,pZ#(v),2,10,4)
       For limb=4 To 29
        If pWeapon(v)=0 Then ScarLimb(v,limb,10)
       Next
       pHP(v)=pHP(v)-Rnd(0,1)
      EndIf
      WeaponImpact(cyc,v,blocked)
      pHurtA#(v)=pA#(cyc) : pStagger#(v)=(8-contact)*0.2
      If pStagger#(v)<0.2 Then pStagger#(v)=0.2 
      RiskAnger(cyc,v)
      GainStrength(cyc,50)
      DamageRep(cyc,v,0)
      pSting(cyc)=0
     EndIf
    EndIf
   Next
  EndIf
  If pAnimTim(cyc)>18 Then ChangeAnim(cyc,0)
  If pWeapon(cyc)>0 And (weapStyle(weapType(pWeapon(cyc)))=1 Or weapStyle(weapType(pWeapon(cyc)))=7) Then ChangeAnim(cyc,40)
 EndIf
 ;lower kick
 If pAnim(cyc)=31
  If pAnimTim(cyc)=0 Then Animate p(cyc),3,3.5,pSeq(cyc,31),8 : pSting(cyc)=1
  If pAnimTim(cyc)=2 Then ProduceSound(p(cyc),sSwing,22050,Rnd(0.1,0.3))
  If pAnimTim(cyc)=<18
   FaceEntity(cyc,p(pFoc(cyc)),5)
   RotateEntity pPivot(cyc),0,pA#(cyc),0
   MoveEntity pPivot(cyc),0,0,0.5
   pStepTim(cyc)=pStepTim(cyc)+Rnd(0,1)
  EndIf
  If pAnimTim(cyc)=>4 And pAnimTim(cyc)=<10 And pScar(cyc,32)=<4 And pSting(cyc)=1
   
*/
