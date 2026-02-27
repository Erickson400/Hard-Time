package main

// import "core:fmt"
import bb "blitzbasic3d"

RiskPromo :: proc(cyc, v: i32) {
    
}


/*
Function RiskPromo(cyc,v)
 ;expand range when seated
 talkRange=60
 If pSeat(cyc)>0 Then talkRange=100
 ;//////////////////// LAW ENFORCEMENT ////////////////////
 If charPromo(pChar(cyc),pChar(v))=0 And pChar(v)=gamChar(slot) And charRole(pChar(v))=0 And charRole(pChar(cyc))=1 And gamBlackout(slot)=0 And AttackViable(cyc)=>1 And AttackViable(cyc)=<2 And pDazed(cyc)=0
  ;welcome to location
  If charExperience(pChar(v))=<2 And gamWarrant(slot)=0 And charRelation(pChar(cyc),pChar(v))=>0 And charAngerTim(pChar(cyc),pChar(v))=0 And InProximity(cyc,v,30)
   If gamLocation(slot)=2 And promoUsed(210)=0 Then charPromo(pChar(cyc),pChar(v))=210
   If gamLocation(slot)=4 And promoUsed(211)=0 Then charPromo(pChar(cyc),pChar(v))=211
   If gamLocation(slot)=6 And promoUsed(212)=0 Then charPromo(pChar(cyc),pChar(v))=212
   If gamLocation(slot)=8 And promoUsed(213)=0 Then charPromo(pChar(cyc),pChar(v))=213
   If gamLocation(slot)=10 And promoUsed(215)=0 Then charPromo(pChar(cyc),pChar(v))=215
  EndIf
  ;remind about dinner time
  If gamHours(slot)=13 And gamMins(slot)>20 And gamLocation(slot)<>8 And InProximity(cyc,v,30) And charAngerTim(pChar(cyc),pChar(v))=0 And pAnim(v)<>12 And pAnim(v)<>13
   If promoUsed(6)=0 Then charPromo(pChar(cyc),pChar(v))=6
  EndIf
  ;out of block during lock down
  If LockDown() And GetBlock(gamLocation(slot))<>charBlock(pChar(v)) And InProximity(cyc,v,50)
   If charBribeTim(pChar(cyc))=0 And promoUsed(2)=0 Then charPromo(pChar(cyc),pChar(v))=2
  EndIf
  ;out of cell during lock down
  If LockDown() And GetBlock(gamLocation(slot))=charBlock(pChar(v)) And InsideCell(pX#(v),pY#(v),pZ#(v))<>charCell(pChar(v)) And InProximity(cyc,v,50) And pAnim(v)<>12 And pAnim(v)<>13
   If charBribeTim(pChar(cyc))=0 And promoUsed(3)=0 Then charPromo(pChar(cyc),pChar(v))=3
  EndIf
  ;told off for sleeping in
  If LockDown()=0 And pAnim(v)=103 And gamLocation(slot)<>6 And InProximity(cyc,v,100) And CellVisible(pX#(cyc),pY#(cyc),pZ#(cyc),InsideCell(pX#(v),pY#(v),pZ#(v)))
   If charBribeTim(pChar(cyc))=0 And promoUsed(11)=0 Then charPromo(pChar(cyc),pChar(v))=11
  EndIf
  ;told off for being in foreign cell
  If GetBlock(gamLocation(slot))>0 And InsideCell(pX#(v),pY#(v),pZ#(v))>0 And InProximity(cyc,v,100) And CellVisible(pX#(cyc),pY#(cyc),pZ#(cyc),InsideCell(pX#(v),pY#(v),pZ#(v)))
   If InsideCell(pX#(v),pY#(v),pZ#(v))<>charCell(pChar(v)) Or GetBlock(gamLocation(slot))<>charBlock(pChar(v))
    If charBribeTim(pChar(cyc))=0 And promoUsed(12)=0 Then charPromo(pChar(cyc),pChar(v))=12
   EndIf
  EndIf
  ;caught carrying weapon
  If pWeapon(v)>0 And weapHabitat(weapType(pWeapon(v)))<99 And weapHabitat(weapType(pWeapon(v)))<>gamLocation(slot) And InProximity(cyc,v,weapSize#(weapType(pWeapon(v)))*5) And charBribeTim(pChar(cyc))=0
   If InLine(cyc,p(v),talkRange)
    If gamLocation(slot)=10 And weapCreate(weapType(pWeapon(v)))>0 And pWeapon(v)<>charWeapon(pChar(v)) And promoUsed(53)=0
     charPromo(pChar(cyc),pChar(v))=53
    Else
     If weapHabitat(weapType(pWeapon(v)))=0 And promoUsed(1)=0 Then charPromo(pChar(cyc),pChar(v))=1
     If weapHabitat(weapType(pWeapon(v)))>0 And promoUsed(18)=0 Then charPromo(pChar(cyc),pChar(v))=18
    EndIf
   EndIf
  EndIf
  ;confront about gang membership
  randy=Rnd(0,10000)
  If randy=0 And charGang(pChar(v))>0 And InProximity(cyc,v,30) And charBribeTim(pChar(cyc))=0
   If InLine(cyc,p(v),talkRange) Then charPromo(pChar(cyc),pChar(v))=51
  EndIf
  ;offers/threats
  randy=Rnd(0,10000)
  If gamWarrant(slot)=0 And gamMoney(slot)>0 And charBribeTim(pChar(cyc))=0 And InProximity(cyc,v,30)
   If InLine(cyc,p(v),talkRange)
    If randy=0 And Friendly(cyc,v)=0 Then charPromo(pChar(cyc),pChar(v))=58 ;invent charge
    If charRelation(pChar(cyc),pChar(v))=>0 And charAngerTim(pChar(cyc),pChar(v))=0
     If randy=1 Then charPromo(pChar(cyc),pChar(v))=73 ;offer immunity
     If randy=2 Then charPromo(pChar(cyc),pChar(v))=74 ;offer protection
     If randy=3 And charSentence(pChar(v))>0 Then charPromo(pChar(cyc),pChar(v))=245 ;offer day off
    EndIf
   EndIf
  EndIf
  ;appeals to your intelligence
  randy=Rnd(0,10000)
  If randy=0 And gamWarrant(slot)=0 And charIntelligence(pChar(v))>charIntelligence(pChar(cyc)) And charRelation(pChar(cyc),pChar(v))=>0 And charAngerTim(pChar(cyc),pChar(v))=0 And InProximity(cyc,v,30)
   If InLine(cyc,p(v),talkRange) Then charPromo(pChar(cyc),pChar(v))=244
  EndIf
  ;praised for working
  If (pAnim(v)=102 And (pState(v)=102 Or pState(v)=104 Or pState(v)=108)) Or pAnim(v)=92
   randy=Rnd(0,10000)
   If randy=0 And gamWarrant(slot)=0 And charRelation(pChar(cyc),pChar(v))=>0 And charAngerTim(pChar(cyc),pChar(v))=0 And InProximity(cyc,v,30) 
    If InLine(cyc,p(v),talkRange) Then charPromo(pChar(cyc),pChar(v))=246
   EndIf
  EndIf
  ;working is futile
  If (pAnim(v)=102 And pState(v)=104) Or pAnim(v)=92
   If LockDown() And gamWarrant(slot)=0 And InProximity(cyc,v,50) 
    If InLine(cyc,p(v),talkRange) And promoUsed(248)=0 Then charPromo(pChar(cyc),pChar(v))=248
   EndIf
  EndIf
  ;cell change
  randy=Rnd(0,10000)
  If randy=0 And gamWarrant(slot)=0 And charBribeTim(pChar(cyc))=0 And InProximity(cyc,v,30)
   If InLine(cyc,p(v),talkRange) Then charPromo(pChar(cyc),pChar(v))=205
  EndIf 
  ;told to clean scars
  chance=(20-CountScars(v))*100
  If chance<500 Then chance=500
  randy=Rnd(0,chance)
  If randy=0 And CountScars(v)>2 And gamLocation(slot)<>11 And gamWarrant(slot)=0 And charBribeTim(pChar(cyc))=0 And InProximity(cyc,v,30)
   If InLine(cyc,p(v),talkRange) Then charPromo(pChar(cyc),pChar(v))=257
  EndIf
  ;give yourself in
  randy=Rnd(0,100)
  If randy=0 And gamWarrant(slot)>0 And ChannelPlaying(chAlarm) And Friendly(cyc,v)=0 And charBribeTim(pChar(cyc))=0 And InProximity(cyc,v,50)
   If InLine(cyc,p(v),talkRange) Then charPromo(pChar(cyc),pChar(v))=59 
  EndIf
  ;assign mission
  If gamWarrant(slot)=0 And gamMission(slot)=0 And charSentence(pChar(v))>0 And InProximity(cyc,v,30)
   If InLine(cyc,p(v),talkRange)
    randy=Rnd(0,10000)
    If randy=1 And charStrength(pChar(v))=<80 Then charPromo(pChar(cyc),pChar(v))=141 ;acquire strength
    If randy=2 And charAgility(pChar(v))=<80 Then charPromo(pChar(cyc),pChar(v))=142 ;acquire agility
    If randy=3 And charIntelligence(pChar(v))=<80 Then charPromo(pChar(cyc),pChar(v))=143 ;acquire intelligence
    If randy=5 And charReputation(pChar(v))=>70 Then charPromo(pChar(cyc),pChar(v))=145 ;reduce reputation
    If randy=7 And gamMoney(slot)=>0 And gamMoney(slot)=<1000 Then charPromo(pChar(cyc),pChar(v))=147 ;acquire money
    If randy=8 And charHairStyle(pChar(v))>1 And charHairStyle(pChar(v))<>charHairStyle(pChar(cyc)) Then charPromo(pChar(cyc),pChar(v))=148 ;change hairstyle
    If randy=9 And charCostume(pChar(v))<>charCostume(pChar(cyc)) Then charPromo(pChar(cyc),pChar(v))=149 ;change costume
    If randy=<10 And gamMoney(slot)<0 Then charPromo(pChar(cyc),pChar(v))=146 ;get out of debt
   EndIf
  EndIf
  ;mission reminder
*/