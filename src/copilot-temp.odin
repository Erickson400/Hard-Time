package main

// import "core:fmt"
import bb "blitzbasic3d"

TEMP_RiskPromo :: proc(cyc, v: i32) {
    { // REMOVE THIS SCOPE

        // internal gang issues
        randy = SuperiorDice(cyc, v)
        if charGang[pChar[v]] > 0 && charGang[pChar[v]] == charGang[pChar[cyc]] \
        && cast(bool)InProximity(cyc, v, 30) {
            if cast(bool)InLine(cyc, p[v], talkRange) {
                if randy == 0 && gamMoney[slot] > 100 do charPromo[pChar[cyc]][pChar[v]] = 95 // kick up
                if promoUsed[96] == 0 {
                    if charGang[pChar[v]] == 1 && (charHairStyle[pChar[v]] > 1 || charSpecs[pChar[v]] != 4) {
                        charPromo[pChar[cyc]][pChar[v]] = 96 // conform to Suns
                    }
                    if charGang[pChar[v]] == 5 && charCostume[pChar[v]] > 2 {
                        charPromo[pChar[cyc]][pChar[v]] = 96 // conform to Gladiators
                    }
                }
            }
        }
        // asks to join your gang
        // START HERE------->




    }

}



/*
;asks to join your gang
  randy=InferiorDice(cyc,v)
  If randy=0 And charGang(pChar(v))>0 And charGang(pChar(v))<>charGang(pChar(cyc)) And charGangHistory(pChar(cyc),charGang(pChar(v)))=0 And charRelation(pChar(cyc),pChar(v))=>0 And charAngerTim(pChar(cyc),pChar(v))=0 And InProximity(cyc,v,30)
   If InLine(cyc,p(v),talkRange) And (GetRace(pChar(v))=GetRace(pChar(cyc)) Or charGang(pChar(v))=>4)
    charPromo(pChar(cyc),pChar(v))=92 
   EndIf
  EndIf
  ;gang rivalry
  randy=SuperiorDice(cyc,v)
  If randy=0 And charGang(pChar(cyc))>0 And charGang(pChar(v))>0 And charGang(pChar(v))<>charGang(pChar(cyc)) And charGang(pChar(cyc))<>6 And Friendly(cyc,v)=0 And InProximity(cyc,v,30)
   If InLine(cyc,p(v),talkRange) Then charPromo(pChar(cyc),pChar(v))=225
  EndIf
  ;asks to bury the hatchet
  randy=InferiorDice(cyc,v)
  If randy=0 And charRelation(pChar(cyc),pChar(v))<0 And charAngerTim(pChar(cyc),pChar(v))=0 And InProximity(cyc,v,30)
   If InLine(cyc,p(v),talkRange) Then charPromo(pChar(cyc),pChar(v))=97
  EndIf
  ;witness blackmails
  If gamWarrant(slot)>0 And gamMoney(slot)>0 And pChar(cyc)=charWitness(pChar(v)) And Friendly(cyc,v)=0 And InProximity(cyc,v,50)
   If InLine(cyc,p(v),talkRange) And promoUsed(55)=0 Then charPromo(pChar(cyc),pChar(v))=55 
  EndIf
  ;offers to take blame
  randy=InferiorDice(cyc,v)
  If gamWarrant(slot)>0 And gamMoney(slot)>0 And charRelation(pChar(cyc),pChar(v))=>0 And charAngerTim(pChar(cyc),pChar(v))=0 And InProximity(cyc,v,30)
   If InLine(cyc,p(v),talkRange)
    If randy=0 Or (randy=1 And Friendly(cyc,v)) Then charPromo(pChar(cyc),pChar(v))=56 
   EndIf
  EndIf
  ;asks you to take blame
  randy=Rnd(0,10000)
  If gamWarrant(slot)=0 And charRelation(pChar(cyc),pChar(v))=>0 And charAngerTim(pChar(cyc),pChar(v))=0 And InProximity(cyc,v,30)
   If InLine(cyc,p(v),talkRange)
    If randy=0 Or (randy=1 And Friendly(cyc,v)) Then charPromo(pChar(cyc),pChar(v))=57 
   EndIf
  EndIf
  ;offers protection
  randy=SuperiorDice(cyc,v)
  If randy=0 And gamWarrant(slot)=0 And gamMoney(slot)>0 And charRelation(pChar(cyc),pChar(v))=>0 And charAngerTim(pChar(cyc),pChar(v))=0 And charFollowTim(pChar(cyc))=0 And InProximity(cyc,v,30)
   If InLine(cyc,p(v),talkRange) Then charPromo(pChar(cyc),pChar(v))=74
  EndIf
  If charFollowTim(pChar(cyc))=>1 And charFollowTim(pChar(cyc))=<100 Then charPromo(pChar(cyc),pChar(v))=76
  ;offers to attack enemy
  randy=SuperiorDice(cyc,v)
  If randy=0 And gamMoney(slot)>0 And charRelation(pChar(cyc),pChar(v))=>0 And charAngerTim(pChar(cyc),pChar(v))=0 And InProximity(cyc,v,30)
   charPromoRef(pChar(cyc))=0 : its=0
   Repeat
    charPromoRef(pChar(cyc))=pChar(Rnd(1,no_plays))
    its=its+1
    If its>100 Then charPromoRef(pChar(cyc))=0
   Until charPromoRef(pChar(cyc))=0 Or charRelation(pChar(v),charPromoRef(pChar(cyc)))<0 
   If charPromoRef(pChar(cyc))>0 And InLine(cyc,p(v),talkRange) Then charPromo(pChar(cyc),pChar(v))=81
  EndIf
  ;friend of a friend
  randy=InferiorDice(cyc,v)
  If randy=0 And charRelation(pChar(cyc),pChar(v))=>0 And charAngerTim(pChar(cyc),pChar(v))=0 And InProximity(cyc,v,30)
   charPromoRef(pChar(cyc))=0 : its=0
   Repeat
    charPromoRef(pChar(cyc))=Rnd(4,no_chars)
    its=its+1
    If its>100 Then charPromoRef(pChar(cyc))=0
   Until charPromoRef(pChar(cyc))=0 Or (charRelation(pChar(cyc),charPromoRef(pChar(cyc)))>0 And charRelation(pChar(v),charPromoRef(pChar(cyc)))>0)
   If charPromoRef(pChar(cyc))>0 And InLine(cyc,p(v),talkRange) Then charPromo(pChar(cyc),pChar(v))=84
  EndIf 
  ;enemy by association
  randy=SuperiorDice(cyc,v)
  If randy=0 And charRelation(pChar(cyc),pChar(v))=>0 And charAngerTim(pChar(cyc),pChar(v))=0 And InProximity(cyc,v,30)
   charPromoRef(pChar(cyc))=0 : its=0
   Repeat
    charPromoRef(pChar(cyc))=Rnd(4,no_chars)
    its=its+1
    If its>100 Then charPromoRef(pChar(cyc))=0
   Until charPromoRef(pChar(cyc))=0 Or (charRelation(pChar(cyc),charPromoRef(pChar(cyc)))>0 And charRelation(pChar(v),charPromoRef(pChar(cyc)))<0)
   If charPromoRef(pChar(cyc))>0 And InLine(cyc,p(v),talkRange) Then charPromo(pChar(cyc),pChar(v))=85
  EndIf
  ;asked to give up friend
  randy=SuperiorDice(cyc,v)
  If randy=0 And charRelation(pChar(cyc),pChar(v))=>0 And charAngerTim(pChar(cyc),pChar(v))=0 And InProximity(cyc,v,30)
   charPromoRef(pChar(cyc))=0 : its=0
   Repeat
    charPromoRef(pChar(cyc))=Rnd(4,no_chars)
    its=its+1
    If its>100 Then charPromoRef(pChar(cyc))=0
   Until charPromoRef(pChar(cyc))=0 Or (charRelation(pChar(cyc),charPromoRef(pChar(cyc)))<0 And charRelation(pChar(v),charPromoRef(pChar(cyc)))>0)
   If charPromoRef(pChar(cyc))>0 And InLine(cyc,p(v),talkRange) Then charPromo(pChar(cyc),pChar(v))=86
  EndIf 
  ;assign mission
  If charGang(pChar(v))>0 And charGang(pChar(v))=charGang(pChar(cyc)) Then gang=1 Else gang=0
  If gamMission(slot)=0 And charRelation(pChar(cyc),pChar(v))=>0 And charAngerTim(pChar(cyc),pChar(v))=0 And InProximity(cyc,v,30)
   If InLine(cyc,p(v),talkRange)
    If gang=1 Then randy=Rnd(0,10000) Else randy=Rnd(0,20000)
    If gang=1
     If randy=1 And charStrength(pChar(v))=<80 Then charPromo(pChar(cyc),pChar(v))=141 ;acquire strength
     If randy=2 And charAgility(pChar(v))=<80 Then charPromo(pChar(cyc),pChar(v))=142 ;acquire agility
     If randy=3 And charIntelligence(pChar(v))=<80 Then charPromo(pChar(cyc),pChar(v))=143 ;acquire intelligence
     If randy=4 And charReputation(pChar(v))=<80 And charGang(pChar(v))<>6 Then charPromo(pChar(cyc),pChar(v))=144 ;acquire reputation
     If randy=5 And charReputation(pChar(v))=>70 And charGang(pChar(v))=6 Then charPromo(pChar(cyc),pChar(v))=145 ;reduce reputation
     If randy=7 And gamMoney(slot)=>0 And gamMoney(slot)=<1000 Then charPromo(pChar(cyc),pChar(v))=147 ;acquire money
     If randy=8 And charHairStyle(pChar(v))>1 And charHairStyle(pChar(v))<>charHairStyle(pChar(cyc)) Then charPromo(pChar(cyc),pChar(v))=148 ;change hairstyle
     If randy=9 And charCostume(pChar(v))<>charCostume(pChar(cyc)) Then charPromo(pChar(cyc),pChar(v))=149 ;change costume
     If randy=<9 And gamMoney(slot)<0 Then charPromo(pChar(cyc),pChar(v))=146 ;get out of debt 
     If randy=19 And gamWarrant(slot)=0 And charGang(pChar(v))<>6 Then charPromo(pChar(cyc),pChar(v))=159 ;get arrested
    EndIf    
    If randy=10 Then charPromo(pChar(cyc),pChar(v))=150 ;bring item
    If randy=11 And pWeapon(cyc)>0 Then charPromo(pChar(cyc),pChar(v))=151 ;deliver given item
    If randy=12 Then charPromo(pChar(cyc),pChar(v))=152 ;find & deliver item 
    If randy=13 And charGang(pChar(cyc))<>6 Then charPromo(pChar(cyc),pChar(v))=153 ;kill character
    If randy=14 And charGang(pChar(cyc))<>6 Then charPromo(pChar(cyc),pChar(v))=154 ;injure character
    If randy=15 And charGang(pChar(cyc))<>6 Then charPromo(pChar(cyc),pChar(v))=155 ;assault character
    If randy=16 Then charPromo(pChar(cyc),pChar(v))=156 ;meet character
    If randy=17 Then charPromo(pChar(cyc),pChar(v))=157 ;identify character
    If randy=18 And gamHours(slot)=<20 Then charPromo(pChar(cyc),pChar(v))=158 ;guard character
    If randy=20 And charGang(pChar(v))=0 Then charPromo(pChar(cyc),pChar(v))=160 ;join gang
   EndIf
  EndIf
  ;mission reminder
  If gamMission(slot)>0 And pChar(cyc)=gamClient(slot) And InProximity(cyc,v,50) 
   If InLine(cyc,p(v),talkRange) And promoUsed(171)=0 Then charPromo(pChar(cyc),pChar(v))=171
  EndIf
 EndIf
 ;//////////////////// UNIVERSAL ISSUES ////////////////////
*/
