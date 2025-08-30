package main
////////////////////////////////////////////////////////////////////////////////
//----------------------------- GRASS ROOTS: TEXTS -----------------------------
//////////////////////////////////////////////////////////////////////////////////

// Key names
Key: [256]string

////////////////////////////////////////////////////////
//-------------------- STATUS --------------------------
////////////////////////////////////////////////////////
// Unused
//weeks
textWeek :: [5]string{"?", "1st week", "2nd week", "3rd week", "4th week"}
// Unused
//months
textMonth :: [13]string{"?", "January", "February", "March", "April",
						"May", "June", "July", "August",
						"September", "October", "November", "December"}
//blocks
textBlock :: [5]string{"?", "North", "East", "South", "West"}
//locations
textLocation :: [16]string{"None", "North Block", "Exercise Yard", "East Block",
							"Study", "South Block", "Hospital", "West Block",
							"Canteen", "Main Hall", "Workshop", "Bathroom",
							"?", "?", "?", "?"}
//warrants
textWarrant :: [21]string{"None", "Dissent", "Gang Membership", "Trying To Escape",
							"Carrying An Illegal Item", "Drug Abuse", "Dealing",
							"Stealing", "Assault", "Assaulting A Warden",
							"Assault With A Weapon", "Grievous Bodily Harm",
							"Attempted Murder", "Murder", "Serial Murder",
							"?", "?", "?", "?", "?", "?"}
//crimes
textCrime :: [21]string{"None", "Fraud", "Prostitution", "Drug Abuse",
						"Drug Dealing", "Theft", "Armed Robbery",
						"Vandalism", "Assault", "Child Abuse",
						"Rape", "Grievous Bodily Harm", "Attempted Murder",
						"Manslaughter", "Murder", "Terrorism",
						"?", "?", "?", "?", "?"}
//gangs
textGang :: [7]string{"None", "The Suns Of God", "The Avatars Of Allah",
						"The Dark Side", "The Powers That Be", "The Gladiators",
						"The Peaks"}
// Unused
//gang member
textMember :: [7]string{"None", "a Sun Of God", "an Avatar Of Allah",
						"a Dark Force", "a Power", "a Gladiator", "a Peak"}

////////////////////////////////////////////////////////
//------------------- OPTIONS --------------------------
////////////////////////////////////////////////////////
textOnOff :: [2]string{"Off", "On"} // on/off
textResX :: [6]string{"320", "640", "800", "1024", "1280", "1280"} // resolution X
textResY :: [6]string{"240", "480", "600", "768", "1024", "800"} // resolution Y
textGore :: [6]string{"None", "Scars Only", "Scars & Pools", "Scars, Pools, & Limb Loss", "?", "?"} // gore
textFX :: [4]string{"None", "Minimal", "Maximum", "?"} // particle effects
textShadows :: [4]string{"None", "Minimal", "Maximum", "?"} // shadows

////////////////////////////////////////////////////////
//---------------- CHARACTERIZATION --------------------
////////////////////////////////////////////////////////
//hair references
hairFile :: [16]string{"?", "Hair_Bald", "Hair_Thin", "Hair_Short", "Hair_Raise",
						"Hair_Quiff", "Hair_Mop", "Hair_Thick", "Hair_Full",
						"Hair_Curl", "Hair_Afro", "Hair_Spike", "Hair_Punk",
						"Hair_Rolls", "Hair_Pony", "Hair_Long"}
//hair styles
textHair :: [41]string{"Bald", "Shaved", "Balding", "Receding", "Short", "Raised",
						"Quiff", "Fringe", "Thick", "Full", "Small Afro", "Big Afro",
						"Spikey", "Mohican", "Corn Rows", "Balding w/Ponytail",
						"Receding w/Ponytail", "Short w/Ponytail", "Raised w/Ponytail",
						"Quiff w/Ponytail", "Fringe w/Ponytail", "Thick w/Ponytail",
						"Afro w/Ponytail", "Mohican w/Ponytail", "Rows w/Ponytail",
						"Balding w/Length", "Receding w/Length", "Short w/Length", "Raised w/Length",
						"Quiff w/Length", "Fringe w/Length", "Thick w/Length", 
						"?", "?", "?", "?", "?", "?", "?", "?", "?"}
//eyewear
textSpecs :: [6]string{"None", "Gold Frames", "Silver Frames", "Dark Frames", "Sunglasses", "?"}
//models
textModel :: [11]string{"?", "Slim", "Normal", "Muscular", "Chubby", "Fat", "?", "?", "?", "?", "?"}
//costumes
textCostume :: [11]string{"Bare Chest", "Tight Vest", "Baggy Vest", "Tight T-Shirt",
							"Baggy T-Shirt", "Tight Short Sleeve", "Baggy Short Sleeve",
							"Tight Long Sleeve", "Baggy Long Sleeve", "?", "?"}
// Races
textRace :: [4]string{"white", "Asian", "black", "?"}

////////////////////////////////////////////////////////
//------------------------ NAMES -----------------------
////////////////////////////////////////////////////////
//first names
textFirstName :: [101]string {0  = "Vic", 1  = "Eddie", 2  = "Matt", 3  = "Liam", 4  = "Stuart",
							5  = "Scott", 6  = "Mike", 7  = "Gez", 8  = "Adam", 9  = "Joe",
							10 = "Lee", 11 = "Alan", 12 = "Dennis", 13 = "Peter", 14 = "Leon",
							15 = "Andy", 16 = "Theo", 17 = "Dan", 18 = "Henry", 19 = "Grant",
							20 = "Anton", 21 = "Des", 22 = "Arnie", 23 = "Tom", 24 = "Paul",
							25 = "Tony", 26 = "Nick", 27 = "Steve", 28 = "Vince", 29 = "John",
							30 = "Gordon", 31 = "Chris", 32 = "Rob", 33 = "Ray", 34 = "Mick",
							35 = "Rick", 36 = "Abe", 37 = "Nate", 38 = "Dave", 39 = "David",
							40 = "Ian", 41 = "Trent", 42 = "Fred", 43 = "Kanye", 44 = "Sean",
							45 = "Shawn", 46 = "Nasir", 47 = "George", 48 = "Obie",
							49 = "Robin", 50 = "Keith", 51 = "Sgt", 52 = "Dr", 53 = "Mr",
							54 = "Tim", 55 = "Jerry", 56 = "Larry", 57 = "Ted", 58 = "Lance",
							59 = "Gaz", 60 = "Kevin", 61 = "Frank", 62 = "Bruce", 63 = "Gavin",
							64 = "Cody", 65 = "Noel", 66..=100="?"}
//surnames
textSurName :: [101]string{0  = "Aceveda", 1  = "Sanders", 2  = "Grimm", 3  = "Clark", 4  = "Evans",
						5  = "Bryant", 6  = "Madison", 7  = "Jackson", 8  = "Mackey",
						9  = "Rooney", 10 = "Gaunt", 11 = "Collins", 12 = "Dickin",
						13 = "Loveday", 14 = "Atkins", 15 = "Luther", 16 = "Walsch",
						17 = "Vessey", 18 = "Osborne", 19 = "Diaz", 20 = "Sipowicz",
						21 = "Taylor", 22 = "Jones", 23 = "Smith", 24 = "McCall",
						25 = "Neeson", 26 = "Samson", 27 = "Simpson", 28 = "McMahon",
						29 = "Hardass", 30 = "Compton", 31 = "Clapson", 32 = "Walker",
						33 = "Kiljoy", 34 = "Cameron", 35 = "Blair", 36 = "Hawksbee",
						37 = "Galloway", 38 = "Madden", 39 = "Austin", 40 = "Simmons",
						41 = "Medavoy", 42 = "Lister", 43 = "Rimmer", 44 = "Bishop",
						45 = "Hogan", 46 = "Duggan", 47 = "Lawler", 48 = "Brown",
						49 = "Keaton", 50 = "Steiner", 51 = "Combs", 52 = "Carter",
						53 = "Bush", 54 = "Nixon", 55 = "Mathers", 56 = "Schwarz",
						57 = "Rajah", 58 = "Foster", 59 = "Robson", 60 = "Manson",
						61 = "Pearce", 62 = "Epton", 63 = "Dearden", 64 = "Mitchell",
						65 = "Mendoza", 66..=100="?"}

// nicknames
textNickName :: [101]string{0  = "Lemonhead",  1  = "Sugar Tits", 2  = "Hat Trick", 3  = "Deep Throat",
							4  = "Big Hit", 5  = "Super Lucha", 6  = "Machoman",
							7  = "Heavyweight", 8  = "Thug Angel", 9  = "God's Son",
							10 = "Escobar", 11 = "Young Boy", 12 = "Wide Boy",
							13 = "Mr Tickle", 14 = "Handyman", 15 = "Lyracist",
							16 = "Maitreya", 17 = "Piston Pecker", 18 = "Kampas Krismas",
							19 = "Baby Bull", 20 = "Fast Eddie", 21 = "Slick Rick",
							22 = "Toadfish", 23 = "Octogon", 24 = "Riverside",
							25 = "Wussy Lee", 26 = "Scotbird", 27 = "Thunder Lips",
							28 = "Agony Aunt", 29 = "Downtown", 30 = "Boomtown",
							31 = "Voodoo Child", 32 = "Little Voice", 33 = "Brother Bear",
							34 = "Maverick", 35 = "Sure Shank", 36 = "Needles",
							37 = "Iceman", 38 = "Crazy Jew", 39 = "Scally",
							40 = "Wise Len", 41 = "Sunshine", 42 = "Terminator",
							43 = "Safe Hands", 44 = "Fairytale", 45 = "Original G",
							46 = "Deep Impact", 47 = "Road Pig", 48 = "X-Factor",
							49 = "Spacker", 50 = "Fabulous M", 51 = "Menace",
							52 = "Nasty Nas", 53 = "King Carter", 54 = "Sure Shot",
							55 = "Major Merc", 56 = "Messiah", 57 = "King Sin",
							58 = "Farrenheit", 59 = "Roughcock", 60 = "Syntax Error",
							61 = "Muhammad", 62 = "Zansibar", 63 = "Bent Rat",
							64 = "Kid Gloves", 65 = "Third Eye", 66 = "Tin Ear",
							67 = "Iron Mic", 68 = "Ghetto Child", 69 = "Bang Bang",
							70 = "Apocolypto", 71 = "Warrior", 72 = "Big Pussy",
							73 = "Duke Nukem", 74 = "Body Bag", 75 = "Cum Bucket",
							76 = "Steroid Roy", 77 = "Bulletproof", 78 = "Stone Malone",
							79 = "Assassin", 80 = "Nightmare", 81..=100 = "?"}


init_texts :: proc() {
	//------------------- KEY NAMES ------------------------
	////////////////////////////////////////////////////////
	for i in 0..=255 {
		Key[i] = "?"
	}
	{ // Thang too long to scroll
		Key[2] = "1"
		Key[3] = "2"
		Key[4] = "3"
		Key[5] = "4"
		Key[6] = "5"
		Key[7] = "6"
		Key[8] = "7"
		Key[9] = "8"
		Key[10] = "9" 
		Key[11] = "0"
		Key[12] = "-"
		Key[13] = "+"
		Key[14] = "Backspace"
		Key[15] = "Tab"
		Key[16] = "Q"
		Key[17] = "W"
		Key[18] = "E"
		Key[19] = "R"
		Key[20] = "T"
		Key[21] = "Y"
		Key[22] = "U"
		Key[23] = "I"
		Key[24] = "O"
		Key[25] = "P"
		Key[26] = "["
		Key[27] = "]"
		Key[29] = "Left Ctrl"
		Key[30] = "A"
		Key[31] = "S"
		Key[32] = "D"
		Key[33] = "F"
		Key[34] = "G"
		Key[35] = "H"
		Key[36] = "J"
		Key[37] = "K"
		Key[38] = "L"
		Key[39] = ";"
		Key[40] = "'"
		Key[41] = "#"
		Key[42] = "Left Shift"
		Key[43] = "\b" // Backslash
		Key[44] = "Z"
		Key[45] = "X"
		Key[46] = "C"
		Key[47] = "V"
		Key[48] = "B"
		Key[49] = "N"
		Key[50] = "M"
		Key[51] = ","
		Key[52] = "."
		Key[53] = "/"
		Key[54] = "Right Shift"
		Key[56] = "Left Alt"
		Key[57] = "Space"
		Key[157] = "Right Ctrl" 
		Key[184] = "Right Alt"
		Key[200] = "Cursor Up" 
		Key[208] = "Cursor Down" 
		Key[203] = "Cursor Left" 
		Key[205] = "Cursor Right"
	}
}
