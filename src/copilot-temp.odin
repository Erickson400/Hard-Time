package main

import bb "blitzbasic3d"
import "core:fmt"
import "core:strings"

TEMP_DisplayPromo :: proc() {

}


/*
;92. INMATE ASKS TO JOIN GANG
 If gamPromo=92
  ;intro
  optionA$="Yes, recruit member..." : optionB$="No, forget it!" 
  If promoStage=0 And promoTim>25 And promoTim<325
   Speak(cyc,3)
   Outline("Are you a member of "+textGang$(charGang(pChar(v)))+"?",rX#(400),rY#(520),30,30,30,250,250,250)
   Outline("I've always wanted to join that gang!",rX#(400),rY#(560),30,30,30,250,250,250)
  EndIf
  If promoStage=0 And promoTim>350 And promoTim<650
   Speak(cyc,3)
   Outline("Do you think you could find a place for me?",rX#(400),rY#(520),30,30,30,250,250,250)
   Outline("I'm sure i'd be a great asset to the cause...",rX#(400),rY#(560),30,30,30,250,250,250)
  EndIf
  If promoStage=0 And promotim>650 Then camFoc=v
  If promoStage=0 And promoTim>675 Then promoStage=1 : foc=1 : keytim=20
  ;responses
  If promoStage=2 And promoTim>325 And promoTim<625
   Speak(cyc,3)
   If promoEffect=0 
    charHappiness(pChar(v))=charHappiness(pChar(v))+5
    ChangeRelationship(pChar(cyc),pChar(v),1) 
    ChangeGang(pChar(cyc),charGang(pChar(v)))
    For char=1 To no_chars
     suitable=1
     If charGang(char)=>1 And charGang(char)=<3 And GetRace(pChar(cyc))+1<>charGang(char) Then suitable=0
     If charGang(char)=4 And charIntelligence(pChar(cyc))<70 Then suitable=0
     If charGang(char)=5 And (charStrength(pChar(cyc))+charAgility(pChar(cyc))<140 Or charModel(pChar(cyc))=>4) Then suitable=0
     If charGang(char)=charGang(pChar(v)) And char<>pChar(cyc) And char<>pChar(v) And charPromo(char,gamChar(slot))=0
      If suitable=0 Then charPromo(char,gamChar(slot))=264
      If suitable=1 Then charPromo(char,gamChar(slot))=265
     EndIf
    Next
    promoEffect=1
   EndIf
   Outline("Great! You won't regret this, i promise!",rX#(400),rY#(520),30,30,30,250,250,250)
   Outline("I'll do anything for "+textGang$(charGang(pChar(v)))+"...",rX#(400),rY#(560),30,30,30,250,250,250)
  EndIf
  If promoStage=3 And promoTim>325 And promoTim<625
   Speak(cyc,1)
   If promoEffect=0 Then DamageRelationship(pChar(cyc),pChar(v),-1) : promoEffect=1
   Outline("Who wants to join your pathetic club anyway?!",rX#(400),rY#(520),30,30,30,250,250,250)
   Outline("Everybody knows you're a laughing stock here...",rX#(400),rY#(560),30,30,30,250,250,250)
  EndIf
  If promoStage=>2 And promoTim>625 And promoTim<9975 Then promoTim=9975 : promoUsed(gamPromo)=1
 EndIf
 ;93. PAY YOUR WAY INTO GANG

*/