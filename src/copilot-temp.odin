package main

import "core:fmt"
import bb "blitzbasic3d"


RiskAnger :: proc(cyc, v: i32) {
	randy: i32
	if pChar[cyc] == gamChar[slot] &&
	   charPromo(pChar[v], pChar[cyc]) == 0 {
		if GetResponse(cyc, v, 0) > 0 &&
		   charRole(pChar[v]) == 1 &&
		   (pWeapon[cyc] == 0 || promoUsed[1] != 0) {
			charPromo(pChar[v], pChar[cyc]) = 5
		}
		if GetResponse(cyc, v, 0) > 0 &&
		   charRole(pChar[v]) == 0 &&
		   charAngerTim[pChar[v]][pChar[cyc]] == 0 &&
		   charRelation[pChar[v]][pChar[cyc]] >= 0 {
			charPromo(pChar[v], pChar[cyc]) = 14
			if charGang[pChar[v]] > 0 &&
			   charGang[pChar[v]] != 6 &&
			   charGang[pChar[v]] !=
				   charGang[pChar[cyc]] {
				charPromo(pChar[v], pChar[cyc]) = 40
			}
			if charGang[pChar[v]] > 0 &&
			   charGang[pChar[v]] != 6 &&
			   charGang[pChar[v]] ==
				   charGang[pChar[cyc]] {
				charPromo(pChar[v], pChar[cyc]) = 41
			}
			if charRelation[pChar[v]][pChar[cyc]] > 0 {
				charPromo(pChar[v], pChar[cyc]) = 80
			}
			if charGang[pChar[v]] == 6 {
				charPromo(pChar[v], pChar[cyc]) = 43
			}
		}
		if GetResponse(cyc, v, 0) > 0 &&
		   pSeat[v] > 0 && charGang[pChar[v]] != 6 {
			charPromo(pChar[v], pChar[cyc]) = 9
		}
		if GetResponse(cyc, v, 0) > 0 &&
		   pBed[v] > 0 && charGang[pChar[v]] != 6 {
			charPromo(pChar[v], pChar[cyc]) = 10
		}
		randy = bb.RndI(0, 20)
		if randy == 0 && charRole(pChar[v]) == 1 &&
		   gamWarrant(slot) < 9 &&
		   charBribeTim[pChar[v]] == 0 {
			gamWarrant(slot) = 9
		}
		// beg for mercy
		if charReputation(pChar[v]) <
		   charReputation(pChar[cyc]) &&
		   promoUsed[258] == 0 {
			randy = bb.RndI(0, pHealth[v] * 2)
			if randy == 0 && pHealth[v] > 0 &&
			   pHealth[v] < 20 {
				charPromo(pChar[v], pChar[cyc]) = 258
			}
			randy = bb.RndI(0,
						 charHappiness(pChar[v]) * 2)
			if randy == 0 &&
			   charHappiness(pChar[v]) > 0 &&
			   charHappiness(pChar[v]) < 20 {
				charPromo(pChar[v], pChar[cyc]) = 258
			}
		}
		// response to intervening
		for count in 1..=no_plays {
			if count != cyc && count != v &&
			   charPromo[pChar[count]][pChar[cyc]] == 0 &&
			   charAttacker(pChar[count]) ==
				   pChar[v] &&
			   charAngerTim[pChar[count]][pChar[cyc]] == 0 &&
			   charAngerTim(pChar[cyc],
							pChar[v]) == 0 &&
			   charAngerTim[pChar[v]][pChar[cyc]] == 0 {
				if charAngerTim(pChar[count],
								pChar[v]) > 0 ||
				   charAngerTim(pChar[v],
								pChar[count]) > 0 {
					if InProximity(count, cyc, 30) != 0 ||
					   InProximity(count, v, 30) != 0 {
						randy = bb.RndI(0, 6)
						if randy == 0 ||
						   (randy == 1 &&
							charRelation[pChar[count]][
										 pChar[cyc]] > 0) {
							charPromo(pChar[count],
									  pChar[cyc]) = 78
						}
						if (randy == 2 &&
							charRelation[pChar[count]][
										 pChar[cyc]] <= 0) ||
						   (randy == 3 &&
							charRelation[pChar[count]][
										 pChar[cyc]] < 0) {
							charPromo(pChar[count],
									  pChar[cyc]) = 79
						}
						charPromoRef(pChar[count]) =
							pChar[v]
					}
				}
			}
		}
	}
	// offer mercy
	if pChar[v] == gamChar[slot] &&
	   gamMoney(slot) > 0 &&
	   charPromo(pChar[cyc], pChar[v]) == 0 &&
	   charReputation(pChar[v]) <
		   charReputation(pChar[cyc]) &&
	   promoUsed[259] == 0 {
		randy = bb.RndI(0, pHealth[v] * 2)
		if randy == 0 && pHealth[v] > 0 &&
		   pHealth[v] < 20 {
			charPromo(pChar[cyc], pChar[v]) = 259
		}
		randy = bb.RndI(0, charHappiness(pChar[v]) * 2)
		if randy == 0 &&
		   charHappiness(pChar[v]) > 0 &&
		   charHappiness(pChar[v]) < 20 {
			charPromo(pChar[cyc], pChar[v]) = 259
		}
	}
	// anger victim
	if charGang[pChar[v]] != 6 {
		reaction := (charStrength(pChar[v]) - 30) +
					(100 - charIntelligence(pChar[v])) +
					(charReputation(pChar[v]) - 30)
		charAngerTim[pChar[v]][pChar[cyc]] =
			bb.RndI(reaction/2, reaction*4)
		pAgenda[v] = 2
		pFollowFoc[v] = cyc
		pSubX[v] = 9999
		pSubZ[v] = 9999
		randy = bb.RndI(0, 10)
		if randy == 0 &&
		   charRelation[pChar[v]][
						pChar[cyc]] >= 0 {
			ChangeRelationship(pChar[v],
							   pChar[cyc], -1)
		}
	}
	// reset witnesses
	charWitness(pChar[cyc]) = 0
	if charRole(pChar[v]) == 1 && pHealth[v] > 0 {
		charWitness(pChar[cyc]) = pChar[v]
	}
	// affect others
	for count in 1..=no_plays {
		if count != cyc && count != v &&
		   pChar[count] != gamChar[slot] &&
		   gamBlackout(slot) == 0 {
			// find witnesses
			if charWitness(pChar[cyc]) == 0 &&
			   (Friendly(count, cyc) == 0 ||
				Friendly(count, v) != 0) &&
			   charBribeTim[pChar[count]] == 0 &&
			   InProximity(count, cyc, 100) != 0 &&
			   AttackViable(count) >= 1 &&
			   AttackViable(count) <= 2 &&
			   pDazed[count] == 0 {
				if InLine(count, p[cyc], 60) != 0 ||
				   InLine(count, p[v], 60) != 0 {
					charWitness(pChar[cyc]) = pChar[v]
				}
			}
			// include friends
			if Friendly(count, v) != 0 &&
			   Friendly(count, cyc) == 0 &&
			   AttackViable(count) >= 1 &&
			   AttackViable(count) <= 2 &&
			   pDazed[count] == 0 {
				if InLine(count, p[cyc], 60) != 0 ||
				   InLine(count, p[v], 60) != 0 {
					if charAngerTim(pChar[count],
									pChar[cyc]) == 0 {
						charAngerTim(pChar[count],
									 pChar[cyc]) =
							charAngerTim(pChar[v],
										 pChar[cyc]) / 2
					}
					if charRole(pChar[cyc]) == 0 &&
					   charRole(pChar[count]) == 1 {
						charAngerTim(pChar[count],
									 pChar[cyc]) =
							charAngerTim(pChar[count],
										 pChar[cyc]) / 2
					}
					if pFollowFoc[count] != cyc {
						pSubX[count] = 9999
						pSubZ[count] = 9999
					}
					pAgenda[count] = 2
					pFollowFoc[count] = cyc
					if GetResponse(cyc, count, 0) > 0 &&
					   pChar[cyc] == gamChar[slot] &&
					   charPromo(pChar[count],
								 pChar[cyc]) == 0 &&
					   charGang[pChar[count]] != 6 {
						if charRelation[pChar[count]][
										pChar[v]] == 1 {
							charPromo(pChar[count],
									  pChar[cyc]) = 15
						}
						if charGang[pChar[v]] > 0 &&
						   charGang[pChar[v]] ==
							   charGang[pChar[count]] {
							charPromo(pChar[count],
									  pChar[cyc]) = 39
						}
						charPromoRef(pChar[count]) =
							pChar[v]
					}
					if GetResponse(cyc, count, 0) > 0 &&
					   pChar[v] == gamChar[slot] &&
					   charPromo(pChar[count],
								 pChar[v]) == 0 &&
					   charGang[pChar[count]] != 6 {
						charPromo(pChar[count],
								  pChar[v]) = 77
						charPromoRef(pChar[count]) =
							pChar[cyc]
					}
				}
			}
			// clock civil war
			if charGang[pChar[count]] > 0 &&
			   charGang[pChar[cyc]] ==
				   charGang[pChar[count]] &&
			   charGang[pChar[v]] ==
				   charGang[pChar[count]] &&
			   AttackViable(count) >= 1 &&
			   AttackViable(count) <= 2 &&
			   pDazed[count] == 0 {
				if InLine(count, p[cyc], 60) != 0 ||
				   InLine(count, p[v], 60) != 0 {
					if charAngerTim(pChar[count],
									pChar[cyc]) == 0 {
						charAngerTim(pChar[count],
									 pChar[cyc]) =
							charAngerTim(pChar[v],
										 pChar[cyc]) / 2
					}
					if pFollowFoc[count] != cyc {
						pSubX[count] = 9999
						pSubZ[count] = 9999
					}
					pAgenda[count] = 2
					pFollowFoc[count] = cyc
					if GetResponse(cyc, count, 0) > 0 &&
					   pChar[cyc] == gamChar[slot] &&
					   charPromo(pChar[count],
								 pChar[cyc]) == 0 &&
					   charGang[pChar[count]] != 6 {
						charPromo(pChar[count],
								  pChar[cyc]) = 41
						charPromoRef(pChar[count]) =
							pChar[v]
					}
				}
			}
			// include guards
			if charRole(pChar[count]) == 1 &&
			   charRole(pChar[cyc]) == 0 &&
			   (Friendly(count, cyc) == 0 ||
				Friendly(count, v) != 0) &&
			   charBribeTim[pChar[count]] == 0 &&
			   AttackViable(count) >= 1 &&
			   AttackViable(count) <= 2 &&
			   pDazed[count] == 0 {
				if InLine(count, p[cyc], 60) != 0 ||
				   InLine(count, p[v], 60) != 0 {
					if charAngerTim(pChar[count],
									pChar[cyc]) < 100 {
						charAngerTim(pChar[count],
									 pChar[cyc]) = 100
					}
					if pFollowFoc[count] != cyc {
						pSubX[count] = 9999
						pSubZ[count] = 9999
					}
					pAgenda[count] = 2
					pFollowFoc[count] = cyc
					if pChar[cyc] == gamChar[slot] &&
					   charPromo(pChar[count],
								 pChar[cyc]) == 0 &&
					   charBribeTim[pChar[count]] == 0 {
						if GetResponse(cyc, count, 0) > 0 {
							if charRole(pChar[v]) == 0 {
								charPromo(pChar[count],
										  pChar[cyc]) = 4
							}
							if charRole(pChar[v]) == 1 {
								charPromo(pChar[count],
										  pChar[cyc]) = 5
							}
							if pWeapon[cyc] > 0 &&
							   promoUsed[72] == 0 {
								charPromo(pChar[count],
										  pChar[cyc]) = 72
								charPromoRef(pChar[count]) =
									pChar[v]
							}
						}
						randy = bb.RndI(0, 50)
						if randy <= 1 &&
						   charRole(pChar[v]) == 1 &&
						   gamWarrant(slot) < 9 {
							gamWarrant(slot) = 9
						}
						if randy == 2 &&
						   charRole(pChar[v]) == 0 &&
						   gamWarrant(slot) < 8 {
							gamWarrant(slot) = 8
							gamItem(slot) = pWeapon[cyc]
						}
						if pWeapon[cyc] > 0 &&
						   pAnim[cyc] != 23 &&
						   gamMission[slot] != 11 &&
						   gamMission[slot] != 12 {
							randy = bb.RndI(0, 50)
							if ((weapType[pWeapon[cyc]] >= 7 &&
								 weapType[pWeapon[cyc]] <= 9) ||
								weapType[pWeapon[cyc]] == 23) {
								randy = bb.RndI(0, 25)
							}
							if randy <= 1 &&
							   gamWarrant(slot) < 10 {
								gamWarrant(slot) = 10
								gamItem(slot) = pWeapon[cyc]
							}
							if randy == 2 &&
							   gamWarrant(slot) < 4 {
								gamWarrant(slot) = 4
								gamItem(slot) = pWeapon[cyc]
							}
						}
						randy = bb.RndI(0, 5)
						if randy == 0 &&
						   pAnim[cyc] == 23 &&
						   pWeapon[cyc] > 0 &&
						   gamMission[slot] != 11 &&
						   gamMission[slot] != 12 {
							if gamWarrant(slot) < 7 {
								gamWarrant(slot) = 7
								gamItem(slot) = pWeapon[cyc]
							}
						}
					}
				}
			}
		}
		// friend asks for help
		if count != cyc && count != v &&
		   pChar[count] == gamChar[slot] &&
		   Friendly(count, v) != 0 &&
		   charAngerTim(pChar[count],
						pChar[cyc]) == 0 &&
		   charAngerTim(pChar[cyc],
						pChar[count]) == 0 &&
		   InProximity(count, v, 50) != 0 &&
		   gamBlackout(slot) == 0 {
			randy = bb.RndI(0, 5)
			if randy == 0 &&
			   charPromo(pChar[v], pChar[count]) == 0 &&
			   promoUsed[249] == 0 {
				charPromo(pChar[v], pChar[count]) = 249
				charPromoRef(pChar[v]) = pChar[cyc]
			}
		}
		// calm down after intervention
		if charRole(pChar[cyc]) == 1 &&
		   charRole(pChar[v]) == 0 {
			charAngerTim[pChar[v]][ count] =
				charAngerTim[pChar[v]][ count] / 2
		}
	}

	// pursue warrant
	if charRole(pChar[cyc]) == 1 &&
	   gamWarrant(slot) > 0 &&
	   charBribeTim[pChar[cyc]] == 0 {
		if pAgenda[cyc] != 2 {
			pSubX[cyc] = 9999
			pSubZ[cyc] = 9999
		}
		pAgenda[cyc] = 2
		pFollowFoc[cyc] = gamPlayer[slot]
		if charAngerTim(pChar[cyc],
						gamChar[slot]) < 10 {
			charAngerTim(pChar[cyc],
						 gamChar[slot]) = 10
		}
	}
	// promo override
	if gamPromo > 0 {
		if cyc == promoActor[1] && promoActor[2] > 0 {
			pFoc[cyc] = promoActor[2]
		}
		if cyc == promoActor[2] && promoActor[1] > 0 {
			pFoc[cyc] = promoActor[1]
		}
	}
}

/*
Function RiskAnger(cyc,v)
 ;pre-anger promos
 If pChar(cyc)=gamChar(slot) And charPromo(pChar(v),pChar(cyc))=0 
  If GetResponse(cyc,v,0)>0 And charRole(pChar(v))=1 And (pWeapon(cyc)=0 Or promoUsed(1))
   charPromo(pChar(v),pChar(cyc))=5 ;assaulted officer
  EndIf
  If GetResponse(cyc,v,0)>0 And charRole(pChar(v))=0 And charAngerTim(pChar(v),pChar(cyc))=0 And charRelation(pChar(v),pChar(cyc))=>0
   charPromo(pChar(v),pChar(cyc))=14 ;unprovoked attack
   If charGang(pChar(v))>0 And charGang(pChar(v))<>6 And charGang(pChar(v))<>charGang(pChar(cyc)) Then charPromo(pChar(v),pChar(cyc))=40 ;rival gang member
   If charGang(pChar(v))>0 And charGang(pChar(v))<>6 And charGang(pChar(v))=charGang(pChar(cyc)) Then charPromo(pChar(v),pChar(cyc))=41 ;fellow gang member
   If charRelation(pChar(v),pChar(cyc))>0 Then charPromo(pChar(v),pChar(cyc))=80 ;fall out with friend
   If charGang(pChar(v))=6 Then charPromo(pChar(v),pChar(cyc))=43 ;forgiven for attack
  EndIf
  If GetResponse(cyc,v,0)>0 And pSeat(v)>0 And charGang(pChar(v))<>6 Then charPromo(pChar(v),pChar(cyc))=9 ;lost seat
  If GetResponse(cyc,v,0)>0 And pBed(v)>0 And charGang(pChar(v))<>6 Then charPromo(pChar(v),pChar(cyc))=10 ;lost bed
  randy=Rnd(0,20)
  If randy=0 And charRole(pChar(v))=1 And gamWarrant(slot)<9 And charBribeTim(pChar(v))=0 Then gamWarrant(slot)=9 ;assault officer warrantt 
  ;beg for mercy
  If charReputation(pChar(v))<charReputation(pChar(cyc)) And promoUsed(258)=0
   randy=Rnd(0,pHealth(v)*2)
   If randy=0 And pHealth(v)>0 And pHealth(v)<20 Then charPromo(pChar(v),pChar(cyc))=258
   randy=Rnd(0,charHappiness(pChar(v))*2)
   If randy=0 And charHappiness(pChar(v))>0 And charHappiness(pChar(v))<20 Then charPromo(pChar(v),pChar(cyc))=258
  EndIf
  ;response to intervening
  For count=1 To no_plays
   If count<>cyc And count<>v And charPromo(pChar(count),pChar(cyc))=0 And charAttacker(pChar(count))=pChar(v) And charAngerTim(pChar(count),pChar(cyc))=0 And charAngerTim(pChar(cyc),pChar(v))=0 And charAngerTim(pChar(v),pChar(cyc))=0
    If charAngerTim(pChar(count),pChar(v))>0 Or charAngerTim(pChar(v),pChar(count))>0
     If InProximity(count,cyc,30) Or InProximity(count,v,30)
      randy=Rnd(0,6)
      If randy=0 Or (randy=1 And charRelation(pChar(count),pChar(cyc))>0) Then charPromo(pChar(count),pChar(cyc))=78
      If (randy=2 And charRelation(pChar(count),pChar(cyc))=<0) Or (randy=3 And charRelation(pChar(count),pChar(cyc))<0) Then charPromo(pChar(count),pChar(cyc))=79
      charPromoRef(pChar(count))=pChar(v)
     EndIf
    EndIf  
   EndIf
  Next
 EndIf
 ;offer mercy
 If pChar(v)=gamChar(slot) And gamMoney(slot)>0 And charPromo(pChar(cyc),pChar(v))=0 And charReputation(pChar(v))<charReputation(pChar(cyc)) And promoUsed(259)=0
  randy=Rnd(0,pHealth(v)*2)
  If randy=0 And pHealth(v)>0 And pHealth(v)<20 Then charPromo(pChar(cyc),pChar(v))=259
  randy=Rnd(0,charHappiness(pChar(v))*2)
  If randy=0 And charHappiness(pChar(v))>0 And charHappiness(pChar(v))<20 Then charPromo(pChar(cyc),pChar(v))=259
 EndIf 
 ;anger victim 
 If charGang(pChar(v))<>6
  reaction=(charStrength(pChar(v))-30)+(100-charIntelligence(pChar(v)))+(charReputation(pChar(v))-30)
  charAngerTim(pChar(v),pChar(cyc))=Rnd(reaction/2,reaction*4)
  pAgenda(v)=2 : pFollowFoc(v)=cyc
  pSubX#(v)=9999 : pSubZ#(v)=9999 
  randy=Rnd(0,10)
  If randy=0 And charRelation(pChar(v),pChar(cyc))=>0 Then ChangeRelationship(pChar(v),pChar(cyc),-1)
 EndIf
 ;reset witnesses
 charWitness(pChar(cyc))=0
 If charRole(pChar(v))=1 And pHealth(v)>0 Then charWitness(pChar(cyc))=pChar(v)
 ;affect others
 For count=1 To no_plays
  If count<>cyc And count<>v And pChar(count)<>gamChar(slot) And gamBlackout(slot)=0
   ;find witnesses
   If charWitness(pChar(cyc))=0 And (Friendly(count,cyc)=0 Or Friendly(count,v)) And charBribeTim(pChar(count))=0 And InProximity(count,cyc,100) And AttackViable(count)=>1 And AttackViable(count)=<2 And pDazed(count)=0
    If InLine(count,p(cyc),60) Or InLine(count,p(v),60) Then charWitness(pChar(cyc))=pChar(v)
   EndIf
   ;include friends
   If Friendly(count,v) And Friendly(count,cyc)=0 And AttackViable(count)=>1 And AttackViable(count)=<2 And pDazed(count)=0
    If InLine(count,p(cyc),60) Or InLine(count,p(v),60) ;Or InProximity(count,cyc,30) Or InProximity(count,v,30)
     If charAngerTim(pChar(count),pChar(cyc))=0 Then charAngerTim(pChar(count),pChar(cyc))=charAngerTim(pChar(v),pChar(cyc))/2
     If charRole(pChar(cyc))=1 And charRole(pChar(count))=0 Then charAngerTim(pChar(count),pChar(cyc))=charAngerTim(pChar(count),pChar(cyc))/2
     If pFollowFoc(count)<>cyc Then pSubX#(count)=9999 : pSubZ#(count)=9999
     pAgenda(count)=2 : pFollowFoc(count)=cyc 
     If GetResponse(cyc,count,0)>0 And pChar(cyc)=gamChar(slot) And charPromo(pChar(count),pChar(cyc))=0 And charGang(pChar(count))<>6
      If charRelation(pChar(count),pChar(v))=1 Then charPromo(pChar(count),pChar(cyc))=15
      If charGang(pChar(v))>0 And charGang(pChar(v))=charGang(pChar(count)) Then charPromo(pChar(count),pChar(cyc))=39
      charPromoRef(pChar(count))=pChar(v)
     EndIf
     If GetResponse(cyc,count,0)>0 And pChar(v)=gamChar(slot) And charPromo(pChar(count),pChar(v))=0 And charGang(pChar(count))<>6
      charPromo(pChar(count),pChar(v))=77
      charPromoRef(pChar(count))=pChar(cyc)
     EndIf
    EndIf
   EndIf
   ;clock civil war
   If charGang(pChar(count))>0 And charGang(pChar(cyc))=charGang(pChar(count)) And charGang(pChar(v))=charGang(pChar(count)) And AttackViable(count)=>1 And AttackViable(count)=<2 And pDazed(count)=0
    If InLine(count,p(cyc),60) Or InLine(count,p(v),60) ;Or InProximity(count,cyc,30) Or InProximity(count,v,30)
     If charAngerTim(pChar(count),pChar(cyc))=0 Then charAngerTim(pChar(count),pChar(cyc))=charAngerTim(pChar(v),pChar(cyc))/2
     If pFollowFoc(count)<>cyc Then pSubX#(count)=9999 : pSubZ#(count)=9999
     pAgenda(count)=2 : pFollowFoc(count)=cyc 
     If GetResponse(cyc,count,0)>0 And pChar(cyc)=gamChar(slot) And charPromo(pChar(count),pChar(cyc))=0 And charGang(pChar(count))<>6
      charPromo(pChar(count),pChar(cyc))=41
      charPromoRef(pChar(count))=pChar(v)
     EndIf
    EndIf
   EndIf
   ;include guards
   If charRole(pChar(count))=1 And charRole(pChar(cyc))=0 And (Friendly(count,cyc)=0 Or Friendly(count,v)) And charBribeTim(pChar(count))=0 And AttackViable(count)=>1 And AttackViable(count)=<2 And pDazed(count)=0
    If InLine(count,p(cyc),60) Or InLine(count,p(v),60) ;Or InProximity(count,cyc,30) Or InProximity(count,v,30) 
     If charAngerTim(pChar(count),pChar(cyc))<100 Then charAngerTim(pChar(count),pChar(cyc))=100 
     If pFollowFoc(count)<>cyc Then pSubX#(count)=9999 : pSubZ#(count)=9999
     pAgenda(count)=2 : pFollowFoc(count)=cyc
     If pChar(cyc)=gamChar(slot) And charPromo(pChar(count),pChar(cyc))=0 And charBribeTim(pChar(count))=0
      If GetResponse(cyc,count,0)>0
       If charRole(pChar(v))=0 Then charPromo(pChar(count),pChar(cyc))=4 
       If charRole(pChar(v))=1 Then charPromo(pChar(count),pChar(cyc))=5
       If pWeapon(cyc)>0 And promoUsed(72)=0 Then charPromo(pChar(count),pChar(cyc))=72 : charPromoRef(pChar(count))=pChar(v)
      EndIf
      randy=Rnd(0,50)
      If randy=<1 And charRole(pChar(v))=1 And gamWarrant(slot)<9 Then gamWarrant(slot)=9 ;assault officer warrant
      If randy=2 And charRole(pChar(v))=0 And gamWarrant(slot)<8 Then gamWarrant(slot)=8 ;assault warrant
      If pWeapon(cyc)>0 And pAnim(cyc)<>23 And gamMission(slot)<>11 And gamMission(slot)<>12 
       randy=Rnd(0,50)
       If (weapType(pWeapon(cyc))=>7 And weapType(pWeapon(cyc))=<9) Or weapType(pWeapon(cyc))=23 Then randy=Rnd(0,25)
       If randy=<1 And gamWarrant(slot)<10 Then gamWarrant(slot)=10 : gamItem(slot)=pWeapon(cyc) ;assault w/ weapon
       If randy=2 And gamWarrant(slot)<4 Then gamWarrant(slot)=4 : gamItem(slot)=pWeapon(cyc) ;carrying weapon
      EndIf
      randy=Rnd(0,5)
      If randy=0 And pAnim(cyc)=23 And pWeapon(cyc)>0 And gamMission(slot)<>11 And gamMission(slot)<>12 
       If gamWarrant(slot)<7 Then gamWarrant(slot)=7 : gamItem(slot)=pWeapon(cyc) ;caught stealing 
      EndIf
     EndIf
    EndIf
   EndIf
  EndIf
  ;friend asks for help
  If count<>cyc And count<>v And pChar(count)=gamChar(slot) And Friendly(count,v) And charAngerTim(pChar(count),pChar(cyc))=0 And charAngerTim(pChar(cyc),pChar(count))=0 And InProximity(count,v,50) And gamBlackout(slot)=0
   randy=Rnd(0,5)
   If randy=0 And charPromo(pChar(v),pChar(count))=0 And promoUsed(249)=0 Then charPromo(pChar(v),pChar(count))=249 : charPromoRef(pChar(v))=pChar(cyc)
  EndIf
  ;calm down after intervention
  If charRole(pChar(cyc))=1 And charRole(pChar(v))=0
   charAngerTim(pChar(v),count)=charAngerTim(pChar(v),count)/2
  EndIf
 Next
End Function

;RISK RESPONSE (v to cyc)
Function GetResponse(cyc,v,chance)
 ;establish likelihood
 If chance=0
  chance=(charReputation(pChar(cyc))/5)-(charReputation(pChar(v))/5)
  If chance<1 Or charRelation(pChar(v),pChar(cyc))=-1 Or charRole(pChar(v))=1 Then chance=1
 EndIf
 ;risk response
 response=0
 randy=Rnd(0,chance)
 If randy=0 Then response=1
 Return response
End Function

;TRADING RISK
Function TradingRisk(cyc,weapon)
 For v=1 To no_plays
  If charRole(pChar(v))=1 And v<>pFoc(cyc) And Friendly(v,cyc)=0 And charBribeTim(pChar(v))=0 And gamBlackout(slot)=0 And AttackViable(v)=>1 And AttackViable(v)=<2 And pDazed(v)=0 And InProximity(v,cyc,50)
   If InLine(v,p(cyc),60)
    randy=Rnd(0,5)
    If randy=0 And pChar(cyc)=gamChar(slot) And gamMission(slot)<>11 And gamMission(slot)<>12 
     If gamWarrant(slot)<6 Then gamWarrant(slot)=6 : gamItem(slot)=weapon
    EndIf
    pAgenda(v)=4 : pWeapFoc(v)=weapon
    pSubX#(v)=9999 : pSubZ#(v)=9999
   EndIf
  EndIf
 Next
End Function

;ASSESS RELATIONSHIPS
Function AssessRelationships(cyc)
 If FocViable(cyc)
  ;look at nearest by default
  pFoc(cyc)=NearestEnemy(cyc)
  ;consider relationships
  For v=1 To no_plays
   ;guarantee racial friction
   If pChar(cyc)<>gamChar(slot)
    If charGang(pChar(cyc))=>1 And charGang(pChar(cyc))=<3 And charGang(pChar(cyc))<>charGang(pChar(v)) And GetRace(pChar(cyc))<>GetRace(pChar(v)) And Friendly(cyc,v)=0
     charRelation(pChar(cyc),pChar(v))=-1
    EndIf
   EndIf
   ;calm down
   If gamPromo=0 
    charAngerTim(pChar(cyc),pChar(v))=charAngerTim(pChar(cyc),pChar(v))-1
    If AttackViable(cyc)=3 Or AttackViable(v)=3 Then charAngerTim(pChar(cyc),pChar(v))=charAngerTim(pChar(cyc),pChar(v))-1
    If charRole(pChar(cyc))=0 And charRole(pChar(v))=0 And charReputation(pChar(cyc))<charReputation(pChar(v)) Then charAngerTim(pChar(cyc),pChar(v))=charAngerTim(pChar(cyc),pChar(v))-1
    If charRole(pChar(cyc))=0 And charRole(pChar(v))=1 And InProximity(cyc,v,100) Then charAngerTim(pChar(cyc),pChar(v))=charAngerTim(pChar(cyc),pChar(v))-1
   EndIf
   If charAngerTim(pChar(cyc),pChar(v))<0 Then charAngerTim(pChar(cyc),pChar(v))=0
   ;spontaneous anger
   If charAngerTim(pChar(cyc),pChar(v))=0
    randy=Rnd(0,10000)
    If randy=0 And charRelation(pChar(cyc),pChar(v))=0 Then charAngerTim(pChar(cyc),pChar(v))=10
    If randy=<5 And charRelation(pChar(cyc),pChar(v))=-1 Then charAngerTim(pChar(cyc),pChar(v))=10
   EndIf
   ;law enforcement
   If charRole(pChar(cyc))=1 And charRole(pChar(v))=0 And Friendly(cyc,v)=0 And charBribeTim(pChar(cyc))=0 And gamBlackout(slot)=0 And AttackViable(cyc)=>1 And AttackViable(cyc)=<2 And pDazed(cyc)=0
    ;confiscate weapons
    If pWeapon(v)>0 And weapHabitat(weapType(pWeapon(v)))<99 And weapHabitat(weapType(pWeapon(v)))<>gamLocation(slot) And InProximity(cyc,v,weapSize#(weapType(pWeapon(v)))*5)
     If InLine(cyc,p(v),60)
      randy=Rnd(0,100)
      If randy=0 Or pChar(v)=gamChar(slot)
       If pAgenda(cyc)<>4 Then pSubX#(cyc)=9999 : pSubZ#(cyc)=9999
       pAgenda(cyc)=4 : pWeapFoc(cyc)=pWeapon(v)
       If charAngerTim(pChar(cyc),pChar(v))<10 Then charAngerTim(pChar(cyc),pChar(v))=10
      EndIf
      randy=Rnd(0,1000)
      If (weapType(pWeapon(v))=>7 And weapType(pWeapon(v))=<9) Or weapType(pWeapon(v))=23 Then randy=Rnd(0,500)
      If randy=0 Or (randy=1 And weapHabitat(weapType(pWeapon(v)))=0)
       If pChar(v)=gamChar(slot) And gamPromo=0 And gamMission(slot)<>11 And gamMission(slot)<>12 
        If gamWarrant(slot)<4 Then gamWarrant(slot)=4 : gamItem(slot)=pWeapon(v)
       EndIf
      EndIf
     EndIf
    EndIf
    ;clock drug abuse
    If pAnim(v)=>93 And pAnim(v)=<95 And weapHabitat(weapType(pWeapon(v)))<>gamLocation(slot) And InProximity(cyc,v,50)
     If InLine(cyc,p(v),60)
      randy=Rnd(0,100)
      If randy=0 Or pChar(v)=gamChar(slot)
       If pAgenda(cyc)<>4 Then pSubX#(cyc)=9999 : pSubZ#(cyc)=9999
       pAgenda(cyc)=4 : pWeapFoc(cyc)=pWeapon(v)
       If charAngerTim(pChar(cyc),pChar(v))<10 Then charAngerTim(pChar(cyc),pChar(v))=10
      EndIf
      randy=Rnd(0,500)
      If randy=<1 And pChar(v)=gamChar(slot) And gamWarrant(slot)<5 And gamPromo=0 Then gamWarrant(slot)=5
     EndIf
    EndIf
    ;clock gang membership
    If pChar(v)=gamChar(slot) And charGang(pChar(v))>0 And InProximity(cyc,v,30)
     If InLine(cyc,p(v),60)
      randy=Rnd(0,5000)
      If randy=0 And gamWarrant(slot)<2 And gamPromo=0 Then gamWarrant(slot)=2
     EndIf
    EndIf
    ;out of block during lock down
    If LockDown() And pChar(v)=gamChar(slot) And GetBlock(gamLocation(slot))<>charBlock(pChar(v))
     If InLine(cyc,p(v),60)
      If pAgenda(cyc)<>2 Then pSubX#(cyc)=9999 : pSubZ#(cyc)=9999
      pAgenda(cyc)=2 : pFollowFoc(cyc)=v
      randy=Rnd(0,100)
      If randy=0 And charAngerTim(pChar(cyc),pChar(v))<10 Then charAngerTim(pChar(cyc),pChar(v))=10
      randy=Rnd(0,5000)
      If randy=0 And InProximity(cyc,v,100) And (gamHours(slot)>22 Or gamHours(slot)<7) And gamWarrant(slot)<1 And gamPromo=0 Then gamWarrant(slot)=1
      If randy=<50 And InProximity(cyc,v,100) And gamEscape(slot)=1 And gamWarrant(slot)<3 And gamPromo=0 Then gamWarrant(slot)=3
     EndIf
    EndIf
    ;out of cell during lock down
    If LockDown() And pChar(v)=gamChar(slot) And GetBlock(gamLocation(slot))=charBlock(pChar(v)) And InsideCell(pX#(v),pY#(v),pZ#(v))<>charCell(pChar(v)) And pAnim(v)<>12 And pAnim(v)<>13
     If InLine(cyc,p(v),60)
      If pAgenda(cyc)<>2 Then pSubX#(cyc)=9999 : pSubZ#(cyc)=9999
      pAgenda(cyc)=2 : pFollowFoc(cyc)=v
      randy=Rnd(0,100)
      If randy=0 And charAngerTim(pChar(cyc),pChar(v))<10 Then charAngerTim(pChar(cyc),pChar(v))=10
      randy=Rnd(0,5000)
      If randy=0 And InProximity(cyc,v,100) And (gamHours(slot)>22 Or gamHours(slot)<7) And gamWarrant(slot)<1 And gamPromo=0 Then gamWarrant(slot)=1
     EndIf
    EndIf
   EndIf
   ;wave to friends
   cellConflict=0 : cell=InsideCell(pX#(v),pY#(v),pZ#(v))
   If cell>0 And CellVisible(pX#(cyc),pY#(cyc),pZ#(cyc),cell)=0 Then cellConflict=1
   If cellConflict=0 And cyc<>v And InProximity(cyc,v,100) And pInteract(cyc,v)=0 And Friendly(cyc,v) And Friendly(v,cyc) And pAnim(cyc)<20 And pAnim(v)<20 And pDazed(cyc)=0 And pDazed(v)=0 And v<>promoActor(1) And v<>promoActor(2)
    If (charFollowTim(pChar(cyc))=0 Or v<>gamPlayer(slot)) And (charFollowTim(pChar(v))=0 Or cyc<>gamPlayer(slot)) 
     If InLine(cyc,p(v),60) And InLine(v,p(cyc),60)
      pFoc(cyc)=v : ChangeAnim(cyc,91)
      pFoc(v)=cyc : ChangeAnim(v,91)
      pInteract(cyc,v)=1 : pInteract(v,cyc)=1
     EndIf
    EndIf
   EndIf
   ;trigger promos
   If charPromo(pChar(cyc),pChar(v))=>202 And charPromo(pChar(cyc),pChar(v))=<204
    If GetBlock(gamLocation(slot))<>charBlock(pChar(cyc)) Or InsideCell(pX#(cyc),pY#(cyc),pZ#(cyc))<>charCell(pChar(cyc)) Or InsideCell(pX#(v),pY#(v),pZ#(v))<>charCell(pChar(v))
     cellConflict=1
    EndIf
   EndIf
   If gotim>50 And gamPromo=0 And promoTim=0 And cellConflict=0 And cyc<>v And pHealth(cyc)>0 And pHealth(v)>0 And pPhone(cyc)=0 And pPhone(v)=0 And pAnim(v)<>90
    oldPromo=charPromo(pChar(cyc),pChar(v))
    RiskPromo(cyc,v)
    If charPromo(pChar(cyc),pChar(v))>0
     If InProximity(cyc,v,50) Or (InProximity(cyc,v,100) And oldPromo<>charPromo(pChar(cyc),pChar(v)))
      TriggerPromo(cyc,v,charPromo(pChar(cyc),pChar(v)))
      charPromo(pChar(cyc),pChar(v))=0
     EndIf
    EndIf
   EndIf
  Next
 EndIf
 ;pursue warrant
 If charRole(pChar(cyc))=1 And gamWarrant(slot)>0 And charBribeTim(pChar(cyc))=0  
  If pAgenda(cyc)<>2 Then pSubX#(cyc)=9999 : pSubZ#(cyc)=9999
  pAgenda(cyc)=2 : pFollowFoc(cyc)=gamPlayer(slot)
  If charAngerTim(pChar(cyc),gamChar(slot))<10 Then charAngerTim(pChar(cyc),gamChar(slot))=10
 EndIf
 ;promo override
 If gamPromo>0
  If cyc=promoActor(1) And promoActor(2)>0 Then pFoc(cyc)=promoActor(2)
  If cyc=promoActor(2) And promoActor(1)>0 Then pFoc(cyc)=promoActor(1)
 EndIf
End Function
*/
