package main

import bb "blitzbasic3d"

////////////////////////////////////////////////////////////////////////////////
//---------------------------- HARD TIME: ANIMATIONS ---------------------------
////////////////////////////////////////////////////////////////////////////////

//-----------------------------------------------------------------
////////////////// LOAD ANIMATION SEQUENCES ///////////////////////
//-----------------------------------------------------------------
LoadSequences :: proc(cyc: i32) {
    // source files
    pSeq[cyc][601] = bb.LoadAnimSeq(p[cyc], "Characters/Sequences/Standard01.3ds")
    pSeq[cyc][602] = bb.LoadAnimSeq(p[cyc], "Characters/Sequences/Standard02.3ds")
    pSeq[cyc][603] = bb.LoadAnimSeq(p[cyc], "Characters/Sequences/Standard03.3ds")
    pSeq[cyc][604] = bb.LoadAnimSeq(p[cyc], "Characters/Sequences/Standard04.3ds")
    pSeq[cyc][610] = bb.LoadAnimSeq(p[cyc], "Characters/Sequences/Move_Execute.3ds")
    pSeq[cyc][611] = bb.LoadAnimSeq(p[cyc], "Characters/Sequences/Move_Receive.3ds")
    // 0-10: stances
    pSeq[cyc][1] = bb.ExtractAnimSeq(p[cyc], 0, 40, pSeq[cyc][601]) // standing (bare hands)
    pSeq[cyc][2] = bb.ExtractAnimSeq(p[cyc], 1145, 1185, pSeq[cyc][601]) // kneeling (bare hands)
    pSeq[cyc][3] = bb.ExtractAnimSeq(p[cyc], 925, 965, pSeq[cyc][602]) // injured stance
    pSeq[cyc][4] = bb.ExtractAnimSeq(p[cyc], 1065, 1105, pSeq[cyc][602]) // dazed stance
    pSeq[cyc][5] = bb.ExtractAnimSeq(p[cyc], 1980, 2020, pSeq[cyc][603]) // ball stance
    // 10-20: movement
    pSeq[cyc][10] = bb.ExtractAnimSeq(p[cyc], 140, 220, pSeq[cyc][601]) // standing turn
    pSeq[cyc][11] = bb.ExtractAnimSeq(p[cyc], 1195, 1275, pSeq[cyc][601]) // kneeling turn
    pSeq[cyc][12] = bb.ExtractAnimSeq(p[cyc], 915, 995, pSeq[cyc][603]) // walking
    pSeq[cyc][13] = bb.ExtractAnimSeq(p[cyc], 50, 130, pSeq[cyc][601]) // running
    pSeq[cyc][14] = bb.ExtractAnimSeq(p[cyc], 975, 1055, pSeq[cyc][602]) // injured movement
    pSeq[cyc][15] = bb.ExtractAnimSeq(p[cyc], 1115, 1195, pSeq[cyc][602]) // dazed movement
    pSeq[cyc][16] = bb.ExtractAnimSeq(p[cyc], 75, 155, pSeq[cyc][603]) // weapon movement
    pSeq[cyc][17] = bb.ExtractAnimSeq(p[cyc], 30, 110, pSeq[cyc][604]) // ball walk
    pSeq[cyc][18] = bb.ExtractAnimSeq(p[cyc], 120, 200, pSeq[cyc][604]) // ball run
    // 20-30: weapon interaction
    pSeq[cyc][20] = bb.ExtractAnimSeq(p[cyc], 1985, 2045, pSeq[cyc][601]) // pick-up weapon
    pSeq[cyc][21] = bb.ExtractAnimSeq(p[cyc], 65, 75, pSeq[cyc][602]) // drop weapon
    pSeq[cyc][22] = bb.ExtractAnimSeq(p[cyc], 205, 275, pSeq[cyc][602]) // throw weapon
    pSeq[cyc][23] = bb.ExtractAnimSeq(p[cyc], 255, 325, pSeq[cyc][603]) // snatch weapon
    pSeq[cyc][24] = bb.ExtractAnimSeq(p[cyc], 165, 245, pSeq[cyc][603]) // examine weapon
    pSeq[cyc][25] = bb.ExtractAnimSeq(p[cyc], 1860, 1900, pSeq[cyc][603]) // handover
    pSeq[cyc][26] = bb.ExtractAnimSeq(p[cyc], 1910, 1970, pSeq[cyc][603]) // basketball throw
    pSeq[cyc][27] = bb.ExtractAnimSeq(p[cyc], 400, 440, pSeq[cyc][604]) // phone pick-up
    // 30-40: hand-2-hand attacks
    pSeq[cyc][30] = bb.ExtractAnimSeq(p[cyc], 250, 320, pSeq[cyc][601]) // upper punch
    pSeq[cyc][31] = bb.ExtractAnimSeq(p[cyc], 1060, 1135, pSeq[cyc][601]) // lower kick
    pSeq[cyc][32] = bb.ExtractAnimSeq(p[cyc], 1405, 1455, pSeq[cyc][601]) // stomp
    pSeq[cyc][33] = bb.ExtractAnimSeq(p[cyc], 1675, 1745, pSeq[cyc][601]) // big attack
    pSeq[cyc][34] = bb.ExtractAnimSeq(p[cyc], 1775, 1875, pSeq[cyc][601]) // rear attack
    pSeq[cyc][35] = bb.ExtractAnimSeq(p[cyc], 105, 175, pSeq[cyc][602]) // rising attack
    // 40-50: weapon swings
    pSeq[cyc][40] = bb.ExtractAnimSeq(p[cyc], 305, 375, pSeq[cyc][602]) // upper swing
    pSeq[cyc][41] = bb.ExtractAnimSeq(p[cyc], 405, 485, pSeq[cyc][602]) // lower swing
    pSeq[cyc][42] = bb.ExtractAnimSeq(p[cyc], 745, 815, pSeq[cyc][602]) // ground swing
    pSeq[cyc][43] = bb.ExtractAnimSeq(p[cyc], 515, 585, pSeq[cyc][602]) // big swing
    pSeq[cyc][44] = bb.ExtractAnimSeq(p[cyc], 615, 715, pSeq[cyc][602]) // rear swing
    // 50-60: weapon stabs
    pSeq[cyc][51] = bb.ExtractAnimSeq(p[cyc], 335, 425, pSeq[cyc][603]) // quick stab
    pSeq[cyc][52] = bb.ExtractAnimSeq(p[cyc], 555, 625, pSeq[cyc][603]) // ground stab
    pSeq[cyc][53] = bb.ExtractAnimSeq(p[cyc], 455, 525, pSeq[cyc][603]) // big stab
    // 60-70: gun fire
    pSeq[cyc][60] = bb.ExtractAnimSeq(p[cyc], 1405, 1445, pSeq[cyc][602]) // rifle stance
    pSeq[cyc][61] = bb.ExtractAnimSeq(p[cyc], 1005, 1085, pSeq[cyc][603]) // rifle walk
    pSeq[cyc][62] = bb.ExtractAnimSeq(p[cyc], 1455, 1535, pSeq[cyc][602]) // rifle running
    pSeq[cyc][63] = bb.ExtractAnimSeq(p[cyc], 1545, 1585, pSeq[cyc][602]) // rifle fire
    pSeq[cyc][64] = bb.ExtractAnimSeq(p[cyc], 1735, 1795, pSeq[cyc][602]) // pistol fire
    pSeq[cyc][65] = bb.ExtractAnimSeq(p[cyc], 1645, 1725, pSeq[cyc][602]) // reload
    // 70-80: hurting & blocking
    pSeq[cyc][70] = bb.ExtractAnimSeq(p[cyc], 340, 390, pSeq[cyc][601]) // upper hurt
    pSeq[cyc][71] = bb.ExtractAnimSeq(p[cyc], 1320, 1380, pSeq[cyc][601]) // lower hurt
    pSeq[cyc][72] = bb.ExtractAnimSeq(p[cyc], 1490, 1550, pSeq[cyc][601]) // ground hurt (on back)
    pSeq[cyc][73] = bb.ExtractAnimSeq(p[cyc], 1575, 1645, pSeq[cyc][601]) // ground hurt (on front)
    pSeq[cyc][74] = bb.ExtractAnimSeq(p[cyc], 1885, 1925, pSeq[cyc][601]) // upper block
    pSeq[cyc][75] = bb.ExtractAnimSeq(p[cyc], 1935, 1975, pSeq[cyc][601]) // lower block
    pSeq[cyc][76] = bb.ExtractAnimSeq(p[cyc], 825, 865, pSeq[cyc][602]) // upper weapon block
    pSeq[cyc][77] = bb.ExtractAnimSeq(p[cyc], 875, 915, pSeq[cyc][602]) // lower weapon block
    pSeq[cyc][78] = bb.ExtractAnimSeq(p[cyc], 450, 595, pSeq[cyc][604]) // die (on back)
    pSeq[cyc][79] = bb.ExtractAnimSeq(p[cyc], 610, 760, pSeq[cyc][604]) // die (on front)
    // 80-90: falling & rising
    pSeq[cyc][80] = bb.ExtractAnimSeq(p[cyc], 415, 500, pSeq[cyc][601]) // fall onto back
    pSeq[cyc][81] = bb.ExtractAnimSeq(p[cyc], 510, 550, pSeq[cyc][601]) // lying on back
    pSeq[cyc][82] = bb.ExtractAnimSeq(p[cyc], 560, 670, pSeq[cyc][601]) // get up off back
    pSeq[cyc][83] = bb.ExtractAnimSeq(p[cyc], 695, 780, pSeq[cyc][601]) // fall onto front (turn)
    pSeq[cyc][84] = bb.ExtractAnimSeq(p[cyc], 790, 830, pSeq[cyc][601]) // lying on front
    pSeq[cyc][85] = bb.ExtractAnimSeq(p[cyc], 840, 910, pSeq[cyc][601]) // get up off front
    pSeq[cyc][86] = bb.ExtractAnimSeq(p[cyc], 935, 1030, pSeq[cyc][601]) // fall onto front (direct)
    pSeq[cyc][87] = bb.ExtractAnimSeq(p[cyc], 635, 675, pSeq[cyc][603]) // falling from a height
    pSeq[cyc][88] = bb.ExtractAnimSeq(p[cyc], 685, 745, pSeq[cyc][603]) // landing from a fall
    // 90-100: standing gestures
    pSeq[cyc][90] = bb.ExtractAnimSeq(p[cyc], 755, 835, pSeq[cyc][603]) // open door
    pSeq[cyc][91] = bb.ExtractAnimSeq(p[cyc], 1095, 1135, pSeq[cyc][603]) // friendly wave
    pSeq[cyc][92] = bb.ExtractAnimSeq(p[cyc], 260, 340, pSeq[cyc][604]) // sweeping
    pSeq[cyc][93] = bb.ExtractAnimSeq(p[cyc], 950, 990, pSeq[cyc][604]) // smoking
    pSeq[cyc][94] = bb.ExtractAnimSeq(p[cyc], 1000, 1040, pSeq[cyc][604]) // injecting
    pSeq[cyc][95] = bb.ExtractAnimSeq(p[cyc], 1050, 1090, pSeq[cyc][604]) // drinking
    pSeq[cyc][96] = bb.ExtractAnimSeq(p[cyc], 1120, 1370, pSeq[cyc][604]) // breakdown
    pSeq[cyc][97] = bb.ExtractAnimSeq(p[cyc], 1380, 1440, pSeq[cyc][604]) // comb hair
    pSeq[cyc][98] = bb.ExtractAnimSeq(p[cyc], 1450, 1510, pSeq[cyc][604]) // admire reflection
    // 100-120: seated gestures
    pSeq[cyc][100] = bb.ExtractAnimSeq(p[cyc], 1145, 1155, pSeq[cyc][603]) // static
    pSeq[cyc][101] = bb.ExtractAnimSeq(p[cyc], 1385, 1425, pSeq[cyc][603]) // slouching
    pSeq[cyc][102] = bb.ExtractAnimSeq(p[cyc], 1215, 1255, pSeq[cyc][603]) // reading
    pSeq[cyc][103] = bb.ExtractAnimSeq(p[cyc], 1265, 1375, pSeq[cyc][603]) // eating
    pSeq[cyc][104] = bb.ExtractAnimSeq(p[cyc], 1435, 1475, pSeq[cyc][603]) // building
    pSeq[cyc][105] = bb.ExtractAnimSeq(p[cyc], 1485, 1515, pSeq[cyc][603]) // lie down
    pSeq[cyc][106] = bb.ExtractAnimSeq(p[cyc], 1515, 1555, pSeq[cyc][603]) // sleeping
    pSeq[cyc][107] = bb.ExtractAnimSeq(p[cyc], 1565, 1620, pSeq[cyc][603]) // get off bed
    pSeq[cyc][108] = bb.ExtractAnimSeq(p[cyc], 1810, 1850, pSeq[cyc][603]) // weight-lifting
    pSeq[cyc][109] = bb.ExtractAnimSeq(p[cyc], 210, 250, pSeq[cyc][604]) // typing
    // 120-130: speaking stances
    pSeq[cyc][120] = bb.ExtractAnimSeq(p[cyc], 350, 390, pSeq[cyc][604]) // holding phone
    pSeq[cyc][121] = bb.ExtractAnimSeq(p[cyc], 755, 835, pSeq[cyc][603]) // hand gestures
    pSeq[cyc][122] = bb.ExtractAnimSeq(p[cyc], 770, 850, pSeq[cyc][604]) // hands on hips
    pSeq[cyc][123] = bb.ExtractAnimSeq(p[cyc], 860, 940, pSeq[cyc][604]) // folded arms
    // 130-200: additional
    pSeq[cyc][130] = bb.ExtractAnimSeq(p[cyc], 1520, 1600, pSeq[cyc][604]) // body changed
    pSeq[cyc][131] = bb.ExtractAnimSeq(p[cyc], 1610, 1650, pSeq[cyc][604]) // mourning
    pSeq[cyc][132] = bb.ExtractAnimSeq(p[cyc], 1660, 1720, pSeq[cyc][604]) // dumbbell curl
    // 200: moves
    LoadMoveSequences(cyc)
}

//----------------------------------------------------------------
//////////////////// MANAGE ANIMATIONS ///////////////////////////
//----------------------------------------------------------------
Animations :: proc(cyc: i32) {

}



/*
// TODO: Animations.bb will be divided into 4 parts. When one is done then paste it here.
Since its all in one function I'll have to hope there are no errors when it comes to
scope.
1574 lines in function. 393 per part.
Part 1: 123 - 516
Part 2: 517 - 910
Part 3: 911 - 1304
Part 4: 1305 - 1574
*/
