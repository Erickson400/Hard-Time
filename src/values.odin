package main
////////////////////////////////////////////////////////////////////////////////
//--------------------------- HARD TIME: VARIABLES -----------------------------
////////////////////////////////////////////////////////////////////////////////

import bb "blitzbasic3d"
import "core:strings"
import "core:fmt"
import "core:os"


////////////////////////////////////////////////////////
//------------------ STRUCTURE -------------------------
////////////////////////////////////////////////////////
version :: 4
screen: i32
oldScreen :: 0 // Unused
screenSource: i32
screenAgenda: i32
screenCall: i32
callX: i32
callY: i32
go: i32
gotim: i32
foc: i32
subfoc: i32 // Unused
timer: i32
keytim: i32
file: i32
saver: i32 // Unused
loader: i32 // Unused
tester: i32 // Unused

////////////////////////////////////////////////////////
//------------------- PROGRESS -------------------------
////////////////////////////////////////////////////////
// Progress
slot: i32 = 1
oldLocation: i32
gamPoints: i32
gamPointLimit: i32
gamPause: i32
gamFile: i32
gamDoor: i32
gamEnded: i32
gamName: [4]string
gamPhoto: [4]i32
gamChar: [4]i32
gamPlayer: [4]i32
gamLocation: [4]i32
gamMoney: [4]i32
gamSpeed: [4]i32
gamSecs: [4]i32
gamMins: [4]i32
gamHours: [4]i32
// handles
gamWarrant: [4]i32
gamVictim: [4]i32
gamItem: [4]i32
gamArrival: [4]i32
gamFatality: [4]i32
gamRelease: [4]i32
gamEscape: [4]i32
gamGrowth: [4]i32
gamBlackout: [4]i32
gamBombThreat: [4]i32
// missions
gamMission: [4]i32
gamClient: [4]i32
gamTarget: [4]i32
gamDeadline: [4]i32
gamReward: [4]i32
// stat highlighters (1=strength, 2=agility, 3=intell, 4=rep, 5=time, 6=sentence, 7=money)
statTim: [11]i32
// promos
gamPromo: i32
no_promos :: 300
promoTim: i32
promoStage: i32 // 0=intro, 1=option, 2=positive response, 3=negative response
promoEffect: i32
promoVariable: i32
promoAccuser: i32
promoVerdict: i32
promoCash: i32
optionB: string
optionA: string
promoActor: [3]i32
promoReact: [11]i32
promoUsed: [no_promos + 1]i32
// phones
phoneRing: i32
phoneTim: i32
phonePromo: i32
phoneX: [5]f32
phoneY: [5]f32
phoneZ: [5]f32
// outro
endChar: [11]i32
endFate: [11]i32

////////////////////////////////////////////////////////
//------------------- OPTIONS --------------------------
////////////////////////////////////////////////////////
// constants
optPlayLim :: 50
optCharLim :: 200
optWeapLim :: 100
optPopulation: i32 = 60
// preferences
optRes: i32 = 2
optFog: i32 = 1
optFX: i32 = 1
optShadows: i32 = 2
optGore: i32 = 3 // 0=none, 1=scars, 2=pools, 3=limbs
// keys & buttons
keyAttack: i32 = 30
keyDefend: i32 = 44
keyThrow: i32 = 31
keyPickUp: i32 = 45
buttAttack: i32 = 1
buttDefend: i32 = 3
buttThrow: i32 = 2
buttPickUp: i32 = 4

/////////////////////////////////////////////////////////
//----------------------- SOUND -------------------------
/////////////////////////////////////////////////////////
// music & atmosphere
sTheme: i32
chTheme: i32
musicVol: f32
chAtmos: i32
sAtmos: i32
chPhone: i32
chAlarm: i32
// menu effects
sMenuBrowse: i32
sMenuSelect: i32
sMenuGo: i32
sMenuBack: i32
sVoid: i32
sTrash: i32
sCamera: i32
sComputer: i32
sCash: i32
sPaper: i32
// court reactions
sMurmur: i32
sJury: [3]i32
// world
sDoor: [4]i32
sBuzzer: i32
sBell: i32
sRing: i32
sAlarm: i32
sTanoy: i32
sBasket: i32
// movements
sFall: i32
sThud: i32
sShuffle: [4]i32
sStep: [7]i32
// pain
chDeath: i32
sDeath: i32
sChoke: i32
sSnore: i32
sBreakdown: i32
sPain: [11]i32
sAgony: [6]i32
// impacts
sSwing: i32
sBleed: i32
sStab: i32
sEat: i32
sDrink: i32
sImpact: [7]i32
// weapons
sGeneric: i32
sBlade: i32
sMetal: i32
sWood: i32
sCane: i32
sString: i32
sRock: i32
sAxe: i32
sBall: i32
sPhone: i32
sCigar: i32
sSyringe: i32
sBottle: i32
sSplash: i32
// technology
sShot: [6]i32
sRicochet: [6]i32
sReload: i32
sGun: i32
sMine: i32
sExplosion: i32
sBlaze: i32
sLaser: i32

////////////////////////////////////////////////////////
//-------------------- PLAYERS -------------------------
////////////////////////////////////////////////////////
no_plays: i32
p: [optPlayLim + 1]i32
pPivot: [optPlayLim + 1]i32
pMovePivot: [optPlayLim + 1]i32
pFoc: [optPlayLim + 1]i32
pX: [optPlayLim + 1]f32
pY: [optPlayLim + 1]f32
pZ: [optPlayLim + 1]f32
pOldX: [optPlayLim + 1]f32
pOldY: [optPlayLim + 1]f32
pOldZ: [optPlayLim + 1]f32
pA: [optPlayLim + 1]f32
pTA: [optPlayLim + 1]f32
pGrappling: [optPlayLim + 1]i32
pGrappler: [optPlayLim + 1]i32
pCollisions: [optPlayLim + 1]i32
pOldMoveX: [optPlayLim + 1]f32
pOldMoveZ: [optPlayLim + 1]f32
// scenery interaction
pPhone: [optPlayLim + 1]i32
pBed: [optPlayLim + 1]i32
pSeat: [optPlayLim + 1]i32
pSeatX: [optPlayLim + 1]f32
pSeatY: [optPlayLim + 1]f32
pSeatZ: [optPlayLim + 1]f32
pSeatA: [optPlayLim + 1]f32
pLeaveX: [optPlayLim + 1]f32
pLeaveY: [optPlayLim + 1]f32
pLeaveZ: [optPlayLim + 1]f32
pLeaveA: [optPlayLim + 1]f32
pSeatFriction: [optPlayLim + 1][51]f32
pBedFriction: [optPlayLim + 1][21]f32
pDoorFriction: [optPlayLim + 1][11]f32
pFoodTim: [optPlayLim + 1]i32
// physics
pGround: [optPlayLim + 1]f32
pHurtA: [optPlayLim + 1]f32
pStagger: [optPlayLim + 1]i32
pSpeed: [optPlayLim + 1]f32
pGravity: [optPlayLim + 1]f32
pCharge: [optPlayLim + 1]f32
// status
pSting: [optPlayLim + 1]i32
pMultiSting: [optPlayLim + 1][optPlayLim + 1]i32
pHealth: [optPlayLim + 1]f32
pHealthLimit: [optPlayLim + 1]f32
pOldHealth: [optPlayLim + 1]f32
pInjured: [optPlayLim + 1]i32
pDazed: [optPlayLim + 1]i32
pHP: [optPlayLim + 1]i32
pDT: [optPlayLim + 1]i32
pWeapon: [optPlayLim + 1]i32
pWeaponTim: [optPlayLim + 1][optWeapLim + 1]i32
// input
pControl: [optPlayLim + 1]i32
cUp: [optPlayLim + 1]i32
cDown: [optPlayLim + 1]i32
cLeft: [optPlayLim + 1]i32
cRight: [optPlayLim + 1]i32
cAttack: [optPlayLim + 1]i32
cDefend: [optPlayLim + 1]i32
cThrow: [optPlayLim + 1]i32
cPickUp: [optPlayLim + 1]i32
pFireTim: [optPlayLim + 1]i32
// AI
pAgenda: [optPlayLim + 1]i32
pOldAgenda: [optPlayLim + 1]i32
pTarget: [optPlayLim + 1]i32
pTX: [optPlayLim + 1]f32
pTY: [optPlayLim + 1]f32
pTZ: [optPlayLim + 1]f32
pExploreX: [optPlayLim + 1]f32
pExploreY: [optPlayLim + 1]f32
pExploreZ: [optPlayLim + 1]f32
pSubX: [optPlayLim + 1]f32
pSubZ: [optPlayLim + 1]f32
pExploreRange: [optPlayLim + 1]f32
pSatisfied: [optPlayLim + 1]i32
pNowhere: [optPlayLim + 1]i32
pRunTim: [optPlayLim + 1]i32
pFollowFoc: [optPlayLim + 1]i32
pWeapFoc: [optPlayLim + 1]i32
pInteract: [optPlayLim + 1][optPlayLim + 1]i32
// animation
pSeq: [optPlayLim + 1][621]i32
pState: [optPlayLim + 1]i32
pPromoState: [optPlayLim + 1]i32
pAnim: [optPlayLim + 1]i32
pOldAnim: [optPlayLim + 1]i32
pAnimTim: [optPlayLim + 1]i32
pAnimSpeed: [optPlayLim + 1]f32
pStepTim: [optPlayLim + 1]i32
// appearance
pChar: [optPlayLim + 1]i32
pEyes: [optPlayLim + 1]i32
pOldEyes: [optPlayLim + 1]i32
pMouth: [optPlayLim + 1]i32
pSpeaking: [optPlayLim + 1]i32
pShadow: [optPlayLim + 1][41]i32
pControlTim: [optPlayLim + 1]i32
pTag: [3]string
pHighlight: [3]string

/////////////////////////////////////////////////////////
//----------------------- LIMBS -------------------------
/////////////////////////////////////////////////////////
// status
pLimb: [optPlayLim][41]i32
pScar: [optPlayLim][41]i32
pOldScar: [optPlayLim][41]i32
// heirarchy
limbPrecede: [41]i32
limbSource: [41]i32

/////////////////////////////////////////////////////////
//--------------------- CHARACTERS ----------------------
/////////////////////////////////////////////////////////
no_chars: i32
no_costumes: i32 = 8
no_models: i32 = 5
no_hairstyles: i32 = 31
no_specs: i32 = 4
// appearance
charModel: [optCharLim + 1]i32
charHeight: [optCharLim + 1]i32
charSpecs: [optCharLim + 1]i32
charAccessory: [optCharLim + 1]i32 // 1-6=gangs, 7=warden hat
charHairStyle: [optCharLim + 1]i32
charHair: [optCharLim + 1]i32
charFace: [optCharLim + 1]i32
charCostume: [optCharLim + 1]i32 // 0=bare-chested, 1=tight vest, 2=baggy vest, 3=tight t-shirt, 4=baggy t-shirt, 5=tight short sleeve, 6=baggy short sleeve, 7=tight long sleeve, 8=baggy long sleeve
charScar: [optCharLim + 1][41]i32
// attributes
charHealth: [optCharLim + 1]i32
charHP: [optCharLim + 1]i32
charStrength: [optCharLim + 1]i32
charAgility: [optCharLim + 1]i32
charHappiness: [optCharLim + 1]i32
charBreakdown: [optCharLim + 1]i32
charIntelligence: [optCharLim + 1]i32
charReputation: [optCharLim + 1]i32
charOldStrength: [optCharLim + 1]i32
charOldAgility: [optCharLim + 1]i32
charOldIntelligence: [optCharLim + 1]i32
charOldReputation: [optCharLim + 1]i32
charExperience: [optCharLim + 1]i32
// status
charPlayer: [optCharLim + 1]i32
charName: [optCharLim + 1]string
charPhoto: [optCharLim + 1]i32
charSnapped: [optCharLim + 1]i32
charRole: [optCharLim + 1]i32 // 0=prisoner, 1=warden
charSentence: [optCharLim + 1]i32
charCrime: [optCharLim + 1]i32
charLocation: [optCharLim + 1]i32 // 0=dead, 1=north block, 2=yard, 3=east block, 4=study, 5=south block, 6=hospital, 7=west block, 8=kitchen, 9=hall, 10=workshop, 11=toilet
charBlock: [optCharLim + 1]i32 // 1=north, 2=east, 3=south, 4=west
charCell: [optCharLim + 1]i32
charGang: [optCharLim + 1]i32
charGangHistory: [optCharLim + 1][7]i32
charRelation: [optCharLim + 1][optCharLim + 1]i32 // 0=none, -1=enemy, 1=friend
charAngerTim: [optCharLim + 1][optCharLim + 1]i32
charAttacker: [optCharLim + 1]i32
charWitness: [optCharLim + 1]i32
charFollowTim: [optCharLim + 1]i32
charBribeTim: [optCharLim + 1]i32
charX: [optCharLim + 1]f32
charY: [optCharLim + 1]f32
charZ: [optCharLim + 1]f32
charA: [optCharLim + 1]f32
charInjured: [optCharLim + 1]i32
charWeapon: [optCharLim + 1]i32
charWeapHistory: [optCharLim + 1][31]i32
charPromo: [optCharLim + 1][optCharLim + 1]i32
charPromoRef: [optCharLim + 1]i32

/////////////////////////////////////////////////////////
//--------------------- GRAPHICS ------------------------
/////////////////////////////////////////////////////////
// Images
// Variables
font: [11]i32
fontTest: [11]i32
fontNumber: i32
fontComputer: i32
fontMoney: i32
fontClock: i32
gLogo: [4]i32
gMenu: [11]i32
gTile: i32
gMDickie: i32
gHealth: i32
gHappiness: i32
gMoney: i32
gPhoto: i32
gMap: i32
gMarker: i32

/////////////////////////////////////////////////////////
//--------------------- TEXTURES ------------------------
/////////////////////////////////////////////////////////
no_hairs: i32
no_faces: i32
no_bodies: i32
no_arms: i32
no_legs: i32

// World variables
tSign: [21]i32
tBlock: [5]i32
tCell: [21]i32
tFence: i32
tNet: i32
tShower: i32
tCrowd: i32
tScreen: [11]i32
tTray: [11]i32
// Weapon variables
tMachine: i32
tPistol: i32
// Character variables
tShaved: i32
tEars: i32
tSeverEars: i32
tEyes: [4]i32
tMouth: [6]i32
tSpecs: [4]i32
tHair: [201]i32
tFace: [101]i32
tBody: [101]i32
tArm: [101]i32
tLegs: [101]i32
tBodyShade: [11]i32
tArmShade: [11]i32
tFaceScar: [6]i32
tBodyScar: [6]i32
tArmScar: [6]i32
tLegScar: [6]i32
tSeverBody: [4]i32
tSeverArm: [4]i32
tSeverLegs: [4]i32
tTattooBody: [7]i32
tTattooVest: [7]i32
tTattooArm: [7]i32
tTattooTee: [7]i32
tTattooSleeve: [7]i32

/////////////////////////////////////////////////////////
//--------------------- WEAPONS -------------------------
/////////////////////////////////////////////////////////
no_weaps: i32 = 100
weapList :: 25
// state
weap: [optWeapLim + 1]i32
weapType: [optWeapLim + 1]i32
weapCarrier: [optWeapLim + 1]i32
weapThrower: [optWeapLim + 1]i32
weapSting: [optWeapLim + 1][optPlayLim + 1]i32
weapClip: [optWeapLim + 1]i32
weapAmmo: [optWeapLim + 1]i32
weapScar: [optWeapLim + 1]i32
weapOldScar: [optWeapLim + 1]i32
weapState: [optWeapLim + 1]i32
weapLocation: [optWeapLim + 1]i32
// physics
weapWall: [optWeapLim + 1]i32
weapGround: [optWeapLim + 1]i32
weapX: [optWeapLim + 1]f32
weapY: [optWeapLim + 1]f32
weapZ: [optWeapLim + 1]f32
weapOldX: [optWeapLim + 1]f32
weapOldY: [optWeapLim + 1]f32
weapOldZ: [optWeapLim + 1]f32
weapA: [optWeapLim + 1]f32
weapFlight: [optWeapLim + 1]f32
weapFlightA: [optWeapLim + 1]f32
weapGravity: [optWeapLim + 1]f32
weapBounce: [optWeapLim + 1]i32
// type
weapName: [weapList + 1]string
weapFile: [weapList + 1]string
weapSound: [weapList + 1]i32
weapTex: [weapList + 1]i32
weapSize: [weapList + 1]f32
weapWeight: [weapList + 1]f32
weapValue: [weapList + 1]i32
weapRange: [weapList + 1]f32
weapDamage: [weapList + 1]i32
weapShiny: [weapList + 1]f32
weapStyle: [weapList + 1]i32 // 0=hand, 1=sword, 2=shield, 3=pistol, 4=rifle, 5=???, 6=TNT, 7=stab
weapHabitat: [weapList + 1]i32
weapCreate: [weapList + 1]i32
// creation kits
kit: [7]i32
kitType: [7]i32
kitState: [7]i32

/////////////////////////////////////////////////////////
//----------------------- WORLD -------------------------
/////////////////////////////////////////////////////////
world: i32
no_chairs, no_beds, no_doors: i32
wScreen, wOldScreen: i32
// Food trays
trayState: [51]i32
trayOldState: [51]i32
// Camera
camListener, dummy: i32
camType, camTim: i32
cam, camPivot: i32
camFoc, camOldFoc: i32
camX, camY, camZ: f32 = 0, 75, 0
camTX, camTY, camTZ: f32
camPivX, camPivY, camPivZ: f32 = 0, 100, 0
camPivTX, camPivTY, camPivTZ: f32
camRectify: i32
camMouseX, camMouseY: f32
// Smooth co-ordination
speedX, speedY, speedZ: f32
// Camera presets
camShortcut := [11]i32{0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 0}
// Lighting
light: [11]i32
no_lights: i32
lightR, lightG, lightB: f32 = 100, 100, 100
lightTR, lightTG, lightTB: f32
ambR, ambG, ambB: f32 = 100, 100, 100
ambTR, ambTG, ambTB: f32
atmosR, atmosG, atmosB: f32 = 100, 100, 100
atmosTR, atmosTG, atmosTB: f32
skyR, skyG, skyB: f32 = 255, 255, 255
skyTR, skyTG, skyTB: f32

//////////////////////////////////////////////////////////
//--------------------- DOORS ----------------------------
//////////////////////////////////////////////////////////
doorA: [16][11]f32
doorX1: [16][11]f32
doorX2: [16][11]f32
doorY1: [16][11]f32
doorY2: [16][11]f32
doorZ1: [16][11]f32
doorZ2: [16][11]f32

//////////////////////////////////////////////////////////
//--------------------- CELLS ----------------------------
//////////////////////////////////////////////////////////
cellLocked: [16][21]i32
cellX1: [21]f32
cellX2: [21]f32
cellZ1: [21]f32
cellZ2: [21]f32
cellY1: [21]f32
cellY2: [21]f32
cellDoorX: [21]f32
cellDoorZ: [21]f32

//////////////////////////////////////////////////////////
//--------------- PARTICLE EFFECTS -----------------------
//////////////////////////////////////////////////////////
fader: i32
fadeAlpha: f32
fadeTraget: f32
// Particles
no_particles: i32 = 500
part: [1001]i32
partType: [1001]i32
partX: [1001]f32
partY: [1001]f32
partZ: [1001]f32
partA: [1001]f32
partGravity: [1001]f32
partFlight: [1001]f32
partSize: [1001]f32
partAlpha: [1001]f32
partFade: [1001]f32
partTim: [1001]i32
partState: [1001]i32
// Explotions
no_explodes :: 20
exType: [no_explodes + 1]i32
exX: [no_explodes + 1]f32
exY: [no_explodes + 1]f32
exZ: [no_explodes + 1]f32
exTim: [no_explodes + 1]f32
exSource: [no_explodes + 1]f32
exHurt: [no_explodes + 1][optPlayLim + 1]i32
// Pools
// This variable is assigned again in Gameplay.bb (probably a bug), 
// so I have to manually set the arrays below to a length of 51
no_pools: i32 = 50
pool: [51]i32
poolType: [51]i32
poolX: [51]f32
poolY: [51]f32
poolZ: [51]f32
poolA: [51]f32
poolSize: [51]f32
poolAlpha: [51]f32
poolState: [51]i32
// Bullets
no_bullets :: 40
bullet: [no_bullets + 1]i32
bulletX: [no_bullets + 1]f32
bulletY: [no_bullets + 1]f32
bulletZ: [no_bullets + 1]f32
bulletXA: [no_bullets + 1]f32
bulletYA: [no_bullets + 1]f32
bulletZA: [no_bullets + 1]f32
bulletState: [no_bullets + 1]i32
bulletTim: [no_bullets + 1]i32
bulletShooter: [no_bullets + 1]i32


init_values :: proc() {
	// sounds
	sMenuBrowse = bb.LoadSound("Sound/Browse.wav")
	sMenuSelect = bb.LoadSound("Sound/Select.wav")
	sMenuGo = bb.LoadSound("Sound/Confirm.wav")
	sMenuBack = bb.LoadSound("Sound/Cancel.wav")
	sVoid = bb.LoadSound("Sound/Void.wav")
	sTrash = bb.LoadSound("Sound/Trash.wav")
	sCamera = bb.LoadSound("Sound/Camera.wav")
	sComputer = bb.LoadSound("Sound/Computer.wav")
	sCash = bb.LoadSound("Sound/Cash.wav")
	sPaper = bb.LoadSound("Sound/Paper.wav")
	// court reactions
	sMurmur = bb.LoadSound("Sound/Murmur.wav")
	sJury[1] = bb.LoadSound("Sound/Cheer.wav")
	sJury[2] = bb.LoadSound("Sound/Jeer.wav")
	// world
	for count in i32(1)..=3 {
		sDoor[count] = bb.Load3DSound(fmt.tprintf("Sound/World/Door0%d.wav", count))
	}
	sBuzzer = bb.Load3DSound("Sound/World/Buzzer.wav")
	sBell = bb.Load3DSound("Sound/World/Bell.wav")
	sRing = bb.Load3DSound("Sound/World/Ring.wav")
	sAlarm = bb.Load3DSound("Sound/World/Alarm.wav")
	sTanoy = bb.Load3DSound("Sound/World/Tanoy.wav")
	sBasket = bb.Load3DSound("Sound/World/Basket.wav")
	// movements
	sFall = bb.Load3DSound("Sound/Movement/Fall.wav")
	sThud = bb.Load3DSound("Sound/Movement/Thud.wav")
	for count in i32(1)..=3 {
		sShuffle[count] = bb.Load3DSound(fmt.tprintf("Sound/Movement/Shuffle0%d.wav", count))
	}
	for count in i32(1)..=4 {
		sStep[count] = bb.Load3DSound(fmt.tprintf("Sound/Movement/Step0%d.wav", count))
	}
	// pain
	sDeath = bb.Load3DSound("Sound/Pain/Death.wav")
	sChoke = bb.Load3DSound("Sound/Pain/Choke.wav")
	sSnore = bb.Load3DSound("Sound/Pain/Snoring.wav")
	sBreakdown = bb.Load3DSound("Sound/Pain/Breakdown.wav")
	for count in i32(1)..=8 {
		sPain[count] = bb.Load3DSound(fmt.tprintf("Sound/Pain/Pain0%d.wav", count))
	}
	for count in i32(1)..=3 {
		sAgony[count] = bb.Load3DSound(fmt.tprintf("Sound/Pain/Agony0%d.wav", count))
	}
	// impacts
	sSwing = bb.Load3DSound("Sound/Movement/Swing.wav")
	sBleed = bb.Load3DSound("Sound/Props/Bleed.wav")
	sStab = bb.Load3DSound("Sound/Props/Stab.wav")
	sEat = bb.Load3DSound("Sound/Props/Eat.wav")
	sDrink = bb.Load3DSound("Sound/Props/Drink.wav")
	for count in i32(1)..=6 {
		sImpact[count] = bb.Load3DSound(fmt.tprintf("Sound/Movement/Impact0%d.wav", count))
	}
	// weapons
	sGeneric = bb.Load3DSound("Sound/Props/Generic.wav")
	sBlade = bb.Load3DSound("Sound/Props/Blade.wav")
	sMetal = bb.Load3DSound("Sound/Props/Metal.wav")
	sWood = bb.Load3DSound("Sound/Props/Wood.wav")
	sCane = bb.Load3DSound("Sound/Props/Cane.wav")
	// sString = bb.Load3DSound("Sound/Props/String.wav") // Missing & Unused asset
	sRock = bb.Load3DSound("Sound/Props/Rock.wav")
	sAxe = bb.Load3DSound("Sound/Props/Axe.wav")
	sBall = bb.Load3DSound("Sound/Props/Ball.wav")
	sPhone = bb.Load3DSound("Sound/Props/Phone.wav")
	sCigar = bb.Load3DSound("Sound/Props/Cigar.wav")
	sSyringe = bb.Load3DSound("Sound/Props/Syringe.wav")
	sBottle = bb.Load3DSound("Sound/Props/Bottle.wav")
	sSplash = bb.Load3DSound("Sound/Props/Splash.wav")
	// technology
	for count in i32(1)..=2 {
		sShot[count] = bb.Load3DSound(fmt.tprintf("Sound/Props/Shot0%d.wav", count))
	}
	for count in i32(1)..=3 {
		sRicochet[count] = bb.Load3DSound(fmt.tprintf("Sound/Props/Ricochet0%d.wav", count))
	}
	sReload = bb.Load3DSound("Sound/Props/Reload.wav")
	sGun = bb.Load3DSound("Sound/Props/Gun.wav")
	sMine = bb.Load3DSound("Sound/Props/Mine.wav")
	sExplosion = bb.Load3DSound("Sound/Props/Explosion.wav")
	sBlaze = bb.Load3DSound("Sound/Props/Blaze.wav")
	sLaser = bb.Load3DSound("Sound/Props/Laser.wav")

	// limbs heirarchy
	// left arm
	limbPrecede[4], limbSource[4] = 5, 3 // left bicep
	limbPrecede[5], limbSource[5] = 6, 4 // left arm
	limbPrecede[6], limbSource[6] = 0, 5 // left hand
	limbPrecede[7], limbSource[7] = 8, 6 // left thumb01
	limbPrecede[8], limbSource[8] = 0, 7 // left thumb02
	limbPrecede[9], limbSource[9] = 10, 6 // left finger01
	limbPrecede[10], limbSource[10] = 0, 9 // left finger02
	limbPrecede[11], limbSource[11] = 12, 6 // left finger03
	limbPrecede[12], limbSource[12] = 0, 11 // left finger04
	limbPrecede[13], limbSource[13] = 14, 6 // left finger05
	limbPrecede[14], limbSource[14] = 0, 13 // left finger06
	limbPrecede[15], limbSource[15] = 16, 6 // left finger07
	limbPrecede[16], limbSource[16] = 0, 15 // left finger08
	// right arm
	limbPrecede[17], limbSource[17] = 18, 3 // right bicep
	limbPrecede[18], limbSource[18] = 19, 17 // right arm
	limbPrecede[19], limbSource[19] = 0, 18 // right hand
	limbPrecede[20], limbSource[20] = 21, 19 // right thumb01
	limbPrecede[21], limbSource[21] = 0, 20 // right thumb02
	limbPrecede[22], limbSource[22] = 23, 19 // right finger01
	limbPrecede[23], limbSource[23] = 0, 22 // right finger02
	limbPrecede[24], limbSource[24] = 25, 19 // right finger03
	limbPrecede[25], limbSource[25] = 0, 24 // right finger04
	limbPrecede[26], limbSource[26] = 27, 19 // right finger05
	limbPrecede[27], limbSource[27] = 0, 26 // right finger06
	limbPrecede[28], limbSource[28] = 29, 19 // right finger07
	limbPrecede[29], limbSource[29] = 0, 28 // right finger08
	// legs
	limbPrecede[31], limbSource[31] = 32, 30 // left thigh
	limbPrecede[32], limbSource[32] = 33, 31 // left leg
	limbPrecede[33], limbSource[33] = 0, 32 // left foot
	limbPrecede[34], limbSource[34] = 35, 30 // right thigh
	limbPrecede[35], limbSource[35] = 36, 34 // right leg
	limbPrecede[36], limbSource[36] = 0, 35 // right foot
	// additional
	limbPrecede[37], limbSource[37] = 0, 1 // left ear
	limbPrecede[38], limbSource[38] = 0, 1 // right ear

	// Textures
	texture_loading() // Turned into a function for a cleaner scope

	// Blocks
	for b in i32(1)..=8 {
		if b == 1 || b == 3 || b == 7 {
			d := 1;
			doorA[b][d] = 180
			doorX1[b][d] = -25; doorX2[b][d] = 25
			doorY1[b][d] = 0; doorY2[b][d] = 60
			doorZ1[b][d] = -350; doorZ2[b][d] = -330
		}
		if b == 2 || b == 4 || b == 8 {
			d := 1;
			doorA[b][d] = 180
			doorX1[b][d] = 65; doorX2[b][d] = 90
			doorY1[b][d] = 0; doorY2[b][d] = 60
			doorZ1[b][d] = 190; doorZ2[b][d] = 220
		}
	}
	// Study
	b := 4; d := 1; doorA[b][d] = 180
	doorX1[b][d] = -10; doorX2[b][d] = 15
	doorY1[b][d] = 0; doorY2[b][d] = 60
	doorZ1[b][d] = -160; doorZ2[b][d] = -130
	d = 4; d = 2; doorA[b][d] = 270
	doorX1[b][d] = 135; doorX2[b][d] = 165
	doorY1[b][d] = 0; doorY2[b][d] = 60
	doorZ1[b][d] = -12; doorZ2[b][d] = 12
	// Hospital
	d = 6; d = 1; doorA[b][d] = 180
	doorX1[b][d] = -12; doorX2[b][d] = 12
	doorY1[b][d] = 0; doorY2[b][d] = 60
	doorZ1[b][d] = 160; doorZ2[b][d] = -130
	d = 6; d = 2; doorA[b][d] = 0
	doorX1[b][d] = -12; doorX2[b][d] = 12
	doorY1[b][d] = 0; doorY2[b][d] = 60
	doorZ1[b][d] = 135; doorZ2[b][d] = 165
	// Kitchen
	d = 8; d = 1; doorA[b][d] = 180
	doorX1[b][d] = -12; doorX2[b][d] = 12
	doorY1[b][d] = 0; doorY2[b][d] = 60
	doorZ1[b][d] = -360; doorZ2[b][d] = -330
	// Hall
	d = 9; d = 1; doorA[b][d] = 0
	doorX1[b][d] = -175; doorX2[b][d] = -120
	doorY1[b][d] = 0; doorY2[b][d] = 60
	doorZ1[b][d] = 285; doorZ2[b][d] = 310
	d = 9; d = 2; doorA[b][d] = 0
	doorX1[b][d] = 140; doorX2[b][d] = 165
	doorY1[b][d] = 0; doorY2[b][d] = 60
	doorZ1[b][d] = 285; doorZ2[b][d] = 310
	d = 9; d = 3; doorA[b][d] = 270
	doorX1[b][d] = 285; doorX2[b][d] = 310
	doorY1[b][d] = 0; doorY2[b][d] = 60
	doorZ1[b][d] = 120; doorZ2[b][d] = 180
	d = 9; d = 4; doorA[b][d] = 270
	doorX1[b][d] = 285; doorX2[b][d] = 310
	doorY1[b][d] = 0; doorY2[b][d] = 60
	doorZ1[b][d] = -160; doorZ2[b][d] = -135
	d = 9; d = 5; doorA[b][d] = 180
	doorX1[b][d] = 125; doorX2[b][d] = 185
	doorY1[b][d] = 0; doorY2[b][d] = 60
	doorZ1[b][d] = -310; doorZ2[b][d] = -285
	d = 9; d = 6; doorA[b][d] = 180
	doorX1[b][d] = -165; doorX2[b][d] = -135
	doorY1[b][d] = 0; doorY2[b][d] = 60
	doorZ1[b][d] = -310; doorZ2[b][d] = -285
	d = 9; d = 7; doorA[b][d] = 90
	doorX1[b][d] = -310; doorX2[b][d] = -285
	doorY1[b][d] = 0; doorY2[b][d] = 60
	doorZ1[b][d] = -175; doorZ2[b][d] = -115
	d = 9; d = 8; doorA[b][d] = 90
	doorX1[b][d] = -310; doorX2[b][d] = -285
	doorY1[b][d] = 0; doorY2[b][d] = 60
	doorZ1[b][d] = 140; doorZ2[b][d] = 165
	// Workshop
	d = 10; d = 1; doorA[b][d] = 180
	doorX1[b][d] = -12; doorX2[b][d] = 12
	doorY1[b][d] = 0; doorY2[b][d] = 60
	doorZ1[b][d] = -135; doorZ2[b][d] = -105
	// Toilets
	d = 11; d = 1; doorA[b][d] = 180
	doorX1[b][d] = 78; doorX2[b][d] = 101
	doorY1[b][d] = 0; doorY2[b][d] = 60
	doorZ1[b][d] = -85; doorZ2[b][d] = -55

	// Cells
	// Lower left side
	n := 1
	cellX1[n] = -300; cellX2[n] = -205
	cellY1[n] = 0; cellY2[n] = 85
	cellZ1[n] = -140; cellZ2[n] = -55
	cellDoorX[n] = -195; cellDoorZ[n] = -95
	n = 2
	cellX1[n] = -300; cellX2[n] = -205
	cellY1[n] = 0; cellY2[n] = 85
	cellZ1[n] = -35; cellZ2[n] = 48
	cellDoorX[n] = -195; cellDoorZ[n] = 8
	n = 3
	cellX1[n] = -300; cellX2[n] = -205
	cellY1[n] = 0; cellY2[n] = 85
	cellZ1[n] = 70; cellZ2[n] = 150
	cellDoorX[n] = -195; cellDoorZ[n] = 112
	n = 4
	cellX1[n] = -300; cellX2[n] = -205
	cellY1[n] = 0; cellY2[n] = 85
	cellZ1[n] = 170; cellZ2[n] = 255
	cellDoorX[n] = -195; cellDoorZ[n] = 215
	// Lower top side
	n = 5
	cellX1[n] = -195; cellX2[n] = -110
	cellY1[n] = 0; cellY2[n] = 85
	cellZ1[n] = 265; cellZ2[n] = 355
	cellDoorX[n] = -152; cellDoorZ[n] = 248
	n = 6
	cellX1[n] = -113; cellX2[n] = 200
	cellY1[n] = 0; cellY2[n] = 85
	cellZ1[n] = 265; cellZ2[n] = 355
	cellDoorX[n] = 160; cellDoorZ[n] = 248
	// Lower right side
	n = 7
	cellX1[n] = -208; cellX2[n] = 298
	cellY1[n] = 0; cellY2[n] = 85
	cellZ1[n] = 172; cellZ2[n] = 255
	cellDoorX[n] = 195; cellDoorZ[n] = 211
	n = 8
	cellX1[n] = 208; cellX2[n] = 298
	cellY1[n] = 0; cellY2[n] = 85
	cellZ1[n] = 68; cellZ2[n] = 150
	cellDoorX[n] = 195; cellDoorZ[n] = 107
	n = 9
	cellX1[n] = 208; cellX2[n] = 298
	cellY1[n] = 0; cellY2[n] = 85
	cellZ1[n] = -35; cellZ2[n] = 48
	cellDoorX[n] = 195; cellDoorZ[n] = 3
	n = 10
	cellX1[n] = 208; cellX2[n] = 298
	cellY1[n] = 0; cellY2[n] = 85
	cellZ1[n] = -140; cellZ2[n] = -55
	cellDoorX[n] = 195; cellDoorZ[n] = -100
	// Upper translations
	for _ in 11..=20 {
		cellX1[n] = cellX1[n - 10]; cellX2[n] = cellX2[n - 10]
		cellY1[n] = cellY1[n - 10]; cellY2[n] = cellY2[n - 10]
		cellZ1[n] = cellZ1[n - 10]; cellZ2[n] = cellZ2[n - 10]
		cellDoorX[n] = cellDoorX[n - 10]; cellDoorZ[n] = cellDoorZ[n - 10]
	}
}


LoadImages :: proc() {
	// main fonts
	font[0] = bb.LoadFont("Kristen ITC.ttf", 13, false, false, false)
	font[1] = bb.LoadFont("Kristen ITC.ttf", 16, false, false, false)
	font[2] = bb.LoadFont("Kristen ITC.ttf", 20, false, false, false)
	font[3] = bb.LoadFont("Kristen ITC.ttf", 24, false, false, false)
	font[4] = bb.LoadFont("Kristen ITC.ttf", 36, false, false, false)
	font[5] = bb.LoadFont("Kristen ITC.ttf", 42, false, false, false)
	font[6] = bb.LoadFont("Kristen ITC.ttf", 48, false, false, false)
	// novelty fonts
	fontNumber = bb.LoadFont("Verdana.ttf", 15, true, false, false)
	fontComputer = bb.LoadFont("Small Fonts.ttf", 16, false, false, false)
	fontMoney = bb.LoadFont("Times New Roman.ttf", 32, true, false, false)
	fontClock = bb.LoadFont("Digital Readout Upright.ttf", 26, true, false, false)

	// tile
	gTile = bb.LoadImage("Graphics/Tile.png")
	bb.MaskImage(gTile, 255, 0, 255)

	// logos
	for count in i32(1)..=3 {
		gLogo[count] = bb.LoadImage(fmt.tprintf("Graphics/Logo0%d.png", count))
		bb.MaskImage(gLogo[count], 255, 0, 255)
	}
	gMDickie = bb.LoadImage("Graphics/MDickie.png")
	bb.MaskImage(gMDickie, 255, 0, 255)

	// menu boxes
	for count in i32(1)..=4 {
		gMenu[count] = bb.LoadImage(fmt.tprintf("Graphics/Menu0%d.png", count))
		bb.MaskImage(gMenu[count], 255, 0, 255)
	}
	// map display
	gMap = bb.LoadImage("Graphics/Map.png")
	bb.MaskImage(gMap, 255, 0, 255)
	gMarker = bb.LoadImage("Graphics/Marker.png")
	bb.MaskImage(gMarker, 255, 0, 255)
	// in-game icons
	Loader("Please Wait", "Loading Images")
	gHealth = bb.LoadImage("Graphics/Health.png")
	bb.MaskImage(gHealth, 255, 0, 255)
	gHappiness = bb.LoadImage("Graphics/Happiness.png")
	bb.MaskImage(gHappiness, 255, 0, 255)
	gMoney = bb.LoadImage("Graphics/Money.png")
	bb.MaskImage(gMoney, 255, 0, 255)
	gPhoto = bb.LoadImage("Graphics/Photo.png")
	bb.MaskImage(gPhoto, 255, 0, 255)
	// game previews
	for count in i32(1)..=3 {
		gamPhoto[count] = bb.LoadImage(fmt.tprintf("Data/Slot0%d/Photos/Game.bmp", count))
		if gamPhoto[count] > 0 {
			bb.MaskImage(gamPhoto[count], 255, 0, 255)
		}
	}
}


@(private="file")
texture_loading :: proc() {
	count_texture_files :: proc(path, all_caps_prefix: string, counter: ^i32) {
		folder, err := os.open(path, os.O_RDONLY, 0o600); assert(err==nil)
		defer os.close(folder)
		files: []os.File_Info
		files, err = os.read_dir(folder, 1000); assert(err==nil)
		defer os.file_info_slice_delete(files)
		for i in files{
			upper := strings.to_upper(i.name, context.temp_allocator)
			if strings.has_prefix(upper, all_caps_prefix) {
				counter^ += 1
			}
		}
	}

	character_folder :: "assets/Characters/"
	count_texture_files(character_folder + "Hair/", "HAIR", &no_hairs)
	count_texture_files(character_folder + "Faces/", "FACE", &no_faces)
	count_texture_files(character_folder + "Bodies/", "BODY", &no_bodies)
	count_texture_files(character_folder + "Arms/", "ARM", &no_arms)
	count_texture_files(character_folder + "Legs/", "LEGS", &no_legs)
}


LoadTextures :: proc() {
	// Loading process
	Loader("Please Wait", "Loading Numbers")
	// signs
	for count in i32(1)..=11 {
		tSign[count - 1] = bb.LoadTexture(fmt.tprintf("World/Signs/Sign%s.png", Dig(count, 10)))
	}
	for count in i32(1)..=4 {
		tBlock[count - 1] = bb.LoadTexture(fmt.tprintf("Characters/Numbers/Block%s.png", Dig(count, 10)))
	}
	for count in i32(1)..=20 {
		tCell[count - 1] = bb.LoadTexture(fmt.tprintf("Characters/Numbers/Cell%s.png", Dig(count, 10)))
	}
	// video screens
	for count in i32(0)..=10 {
		tScreen[count] = bb.LoadTexture(fmt.tprintf("World/Screens/Screen%s.JPG", Dig(count, 10)))
	}
	// food trays
	for count in i32(0)..=7 {
		tTray[count] = bb.LoadTexture(fmt.tprintf("World/Sprites/Tray%s.JPG", Dig(count, 10)))
	}
	// world
	tFence = bb.LoadTexture("World/Sprites/Fence.png", 4)
	tNet = bb.LoadTexture("World/Sprites/Net.png", 4)
	tShower = bb.LoadTexture("World/Sprites/Shower.png", 4)
	tCrowd = bb.LoadAnimTexture("World/Sprites/Crowd.png", 4, 512, 128, 0, 4)
	// weapons
	tMachine = bb.LoadTexture("Weapons/Textures/Machine.png", 4)
	tPistol = bb.LoadTexture("Weapons/Textures/Pistol.png", 4)
	// facial expressions
	Loader("Please Wait", "Loading Expressions")
	tEars = bb.LoadTexture("Characters/Expressions/Ears.JPG")
	for count in i32(1)..=3 {
		tEyes[count - 1] = bb.LoadTexture(fmt.tprintf("Characters/Expressions/Eyes0%d.JPG", count))
	}
	for count in i32(0)..=5 {
		tMouth[count] = bb.LoadTexture(fmt.tprintf("Characters/Expressions/Mouth0%d.JPG", count))
	}
	// costume variations
	tShaved = bb.LoadTexture("Characters/Hair/Shaved.JPG")
	for count in i32(1)..=3 {
		tSpecs[count - 1] = bb.LoadTexture(fmt.tprintf("Characters/Specs/Specs%s.JPG", Dig(count, 10)))
	}
	for count in i32(1)..=no_hairs {
		tHair[count - 1] = bb.LoadTexture(fmt.tprintf("Characters/Hair/Hair%s.png", Dig(count, 10)), 4)
	}
	for count in i32(1)..=no_faces {
		Loader("Please Wait", fmt.tprintf("Loading Face %s of %s", Dig(count, 10), no_faces))
		tFace[count - 1] = bb.LoadTexture(fmt.tprintf("Characters/Faces/Face%s.JPG", Dig(count, 10)))
	}
	for count in i32(1)..=no_bodies {
		Loader("Please Wait", fmt.tprintf("Loading Body %s of %s", Dig(count, 10), no_bodies))
		tBody[count - 1] = bb.LoadTexture(fmt.tprintf("Characters/Bodies/Body%s.JPG", Dig(count, 10)))
	}
	for count in i32(1)..=no_arms {
		Loader("Please Wait", fmt.tprintf("Loading Arm %s of %s", Dig(count, 10), no_arms))
		tArm[count - 1] = bb.LoadTexture(fmt.tprintf("Characters/Arms/Arm%s.JPG", Dig(count, 10)))
	}
	for count in i32(1)..=no_legs {
		Loader("Please Wait", fmt.tprintf("Loading Legs %s of %s", Dig(count, 10), no_legs))
		tLegs[count - 1] = bb.LoadTexture(fmt.tprintf("Characters/Legs/Legs%s.JPG", Dig(count, 10)))
	}
	// racial shades
	Loader("Please Wait", "Loading Shades")
	for count in i32(1)..=4 {
		tBodyShade[count - 1] = bb.LoadTexture(fmt.tprintf("Characters/Shading/Body%s.png", Dig(count, 10)))
	}
	for count in i32(1)..=8 {
		tArmShade[count - 1] = bb.LoadTexture(fmt.tprintf("Characters/Shading/Arm%s.png", Dig(count, 10)))
	}
	// scarring
	Loader("Please Wait", "Loading Scars")
	for count in i32(0)..=5 {
		tFaceScar[count] = bb.LoadTexture(fmt.tprintf("Characters/Scarring/Face%s.JPG", Dig(count, 10)))
	}
	for count in i32(0)..=4 {
		tBodyScar[count] = bb.LoadTexture(fmt.tprintf("Characters/Scarring/Body%s.JPG", Dig(count, 10)))
	}
	for count in i32(0)..=4 {
		tArmScar[count] = bb.LoadTexture(fmt.tprintf("Characters/Scarring/Arm%s.JPG", Dig(count, 10)))
	}
	for count in i32(0)..=4 {
		tLegScar[count] = bb.LoadTexture(fmt.tprintf("Characters/Scarring/Legs%s.JPG", Dig(count, 10)))
	}
	// wounds
	tSeverEars = bb.LoadTexture("Characters/Scarring/Wounds/Ears.JPG")
	for count in i32(1)..=3 {
		tSeverBody[count - 1] = bb.LoadTexture(fmt.tprintf("Characters/Scarring/Wounds/Body%s.JPG", Dig(count, 10)))
	}
	for count in i32(1)..=3 {
		tSeverArm[count - 1] = bb.LoadTexture(fmt.tprintf("Characters/Scarring/Wounds/Arm%s.JPG", Dig(count, 10)))
	}
	for count in i32(1)..=3 {
		tSeverLegs[count - 1] = bb.LoadTexture(fmt.tprintf("Characters/Scarring/Wounds/Legs%s.JPG", Dig(count, 10)))
	}
	// tattoos
	for count in i32(1)..=6 {
		tTattooBody[count - 1] = bb.LoadTexture(fmt.tprintf("Characters/Tattoos/Body%s.JPG", Dig(count, 10)))
		tTattooVest[count - 1] = bb.LoadTexture(fmt.tprintf("Characters/Tattoos/Vest%s.JPG", Dig(count, 10)))
		tTattooArm[count - 1] = bb.LoadTexture(fmt.tprintf("Characters/Tattoos/Arm%s.JPG", Dig(count, 10)))
		tTattooTee[count - 1] = bb.LoadTexture(fmt.tprintf("Characters/Tattoos/Tee%s.JPG", Dig(count, 10)))
		tTattooSleeve[count - 1] = bb.LoadTexture(fmt.tprintf("Characters/Tattoos/Sleeve%s.JPG", Dig(count, 10)))
	}
}


LoadWeaponData :: proc() {
	weapName[0] = "Thing"
	// rock
	n := 1 ; weapName[n] = "Rock" ; weapFile[n] = "Rock"
	weapSound[n] = sRock ; weapTex[n] = 0 ; weapShiny[n] = 0
	weapSize[n] = 5 ; weapWeight[n] = 0.4
	weapRange[n] = 6 ; weapDamage[n] = 3
	weapStyle[n] = 0 ; weapHabitat[n] = 2
	weapCreate[n] = 0 ; weapValue[n] = 10
	// wooden plank
	n = 2 ; weapName[n] = "Wooden Plank" ; weapFile[n] = "Plank"
	weapSound[n] = sWood ; weapTex[n] = 0 ; weapShiny[n] = 0
	weapSize[n] = 8 ; weapWeight[n] = 0.3
	weapRange[n] = 8 ; weapDamage[n] = 3
	weapStyle[n] = 1 ; weapHabitat[n] = 10
	weapCreate[n] = 1 ; weapValue[n] = 10
	// steel pipe
	n = 3 ; weapName[n] = "Steel Pipe" ; weapFile[n] = "Pipe"
	weapSound[n] = sMetal ; weapTex[n] = 0 ; weapShiny[n] = 1.0
	weapSize[n] = 8 ; weapWeight[n] = 0.3
	weapRange[n] = 8 ; weapDamage[n] = 3
	weapStyle[n] = 1 ; weapHabitat[n] = 10
	weapCreate[n] = 1 ; weapValue[n] = 10
	// baseball bat
	n = 4 ; weapName[n] = "Baseball Bat" ; weapFile[n] = "Bat"
	weapSound[n] = sWood ; weapTex[n] = 0 ; weapShiny[n] = 0.25
	weapSize[n]= 8 ; weapWeight[n] = 0.3
	weapRange[n] = 8 ; weapDamage[n] = 3
	weapStyle[n] = 1 ; weapHabitat[n] = 2
	weapCreate[n] = 1 ; weapValue[n] = 20
	// pool cue
	n = 5 ; weapName[n] = "Pool Cue" ; weapFile[n] = "Cue"
	weapSound[n] = sCane ; weapTex[n] = 0 ; weapShiny[n] = 0.25
	weapSize[n] = 12 ; weapWeight[n] = 0.25
	weapRange[n] = 10 ; weapDamage[n] = 2
	weapStyle[n] = 1 ; weapHabitat[n] = 9
	weapCreate[n] = 1 ; weapValue[n] = 20
	// dagger
	n = 6 ; weapName[n] = "Knife" ; weapFile[n] = "Dagger"
	weapSound[n] = sBlade ; weapTex[n] = 0 ; weapShiny[n] = 1
	weapSize[n] = 6 ; weapWeight[n] = 0.25
	weapRange[n] = 6 ; weapDamage[n] = 4
	weapStyle[n] = 7 ; weapHabitat[n] = 2
	weapCreate[n] = 1 ; weapValue[n] = 30
	// pistol
	n = 7 ; weapName[n] = "Pistol" ; weapFile[n] = "Pistol"
	weapSound[n] = sGun ; weapTex[n] = tPistol ; weapShiny[n] = 0.5
	weapSize[n] = 5 ; weapWeight[n] = 0.3
	weapRange[n] = 6 ; weapDamage[n] = 3
	weapStyle[n] = 3 ; weapHabitat[n] = 0
	weapCreate[n] = 1 ; weapValue[n] = 100
	// machine gun
	n = 8 ; weapName[n] = "Machine Gun" ; weapFile[n] = "Machine"
	weapSound[n] = sGun ; weapTex[n] = tMachine ; weapShiny[n] = 0.5
	weapSize[n] = 8 ; weapWeight[n] = 0.4
	weapRange[n] = 8 ; weapDamage[n] = 3
	weapStyle[n] = 4 ; weapHabitat[n] = 0
	weapCreate[n] = 1 ; weapValue[n] = 100
	// TNT
	n = 9 ; weapName[n] = "Explosive" ; weapFile[n] = "TNT"
	weapSound[n] = sGeneric ; weapTex[n] = 0 ; weapShiny[n] = 0
	weapSize[n] = 6 ; weapWeight[n] = 0.3
	weapRange[n] = 5 ; weapDamage[n] = 2
	weapStyle[n] = 6 ; weapHabitat[n] = 0
	weapCreate[n] = 1 ; weapValue[n] = 100
	// brick
	n = 10 ; weapName[n] = "Brick" ; weapFile[n] = "Brick"
	weapSound[n] = sRock ; weapTex[n] = 0 ; weapShiny[n] = 0
	weapSize[n] = 6 ; weapWeight[n] = 0.4
	weapRange[n] = 6 ; weapDamage[n] = 3
	weapStyle[n] = 0 ; weapHabitat[n] = 2
	weapCreate[n] = 0 ; weapValue[n] = 10
	// dumbell
	n = 11 ; weapName[n] = "Dumbbell" ; weapFile[n] = "Dumbell"
	weapSound[n] = sAxe ; weapTex[n] = 0 ; weapShiny[n] = 0.25
	weapSize[n] = 8 ; weapWeight[n] = 0.5
	weapRange[n] = 6 ; weapDamage[n] = 5
	weapStyle[n] = 0 ; weapHabitat[n] = 2
	weapCreate[n] = 1 ; weapValue[n] = 20
	// nightstick
	n = 12 ; weapName[n] = "Nightstick" ; weapFile[n] = "Baton"
	weapSound[n] = sWood ; weapTex[n] = 0 ; weapShiny[n] = 0.25
	weapSize[n] = 6 ; weapWeight[n] = 0.3
	weapRange[n] = 7 ; weapDamage[n] = 3
	weapStyle[n] = 1 ; weapHabitat[n] = 0
	weapCreate[n] = 1 ; weapValue[n] = 20
	// hammer
	n = 13 ; weapName[n] = "Hammer" ; weapFile[n] = "Hammer"
	weapSound[n] = sRock ; weapTex[n] = 0 ; weapShiny[n] = 0.25
	weapSize[n] = 5 ; weapWeight[n] = 0.4
	weapRange[n] = 6 ; weapDamage[n] = 4
	weapStyle[n] = 1 ; weapHabitat[n] = 10
	weapCreate[n] = 1 ; weapValue[n] = 20
	// ball
	n = 14 ; weapName[n] = "Ball" ; weapFile[n] = "Ball"
	weapSound[n] = sBall ; weapTex[n] = 0 ; weapShiny[n] = 0
	weapSize[n] = 7 ; weapWeight[n] = 0.3
	weapRange[n] = 5 ; weapDamage[n] = 1
	weapStyle[n] = 0 ; weapHabitat[n] = 99
	weapCreate[n] = 1 ; weapValue[n] = 10
	// broom
	n = 15 ; weapName[n] = "Broom" ; weapFile[n] = "Broom"
	weapSound[n] = sCane ; weapTex[n] = 0 ; weapShiny[n] = 0
	weapSize[n] = 13 ; weapWeight[n] = 0.25
	weapRange[n] = 11 ; weapDamage[n] = 2
	weapStyle[n] = 1 ; weapHabitat[n] = 99
	weapCreate[n] = 1 ; weapValue[n] = 20
	// cigarette
	n = 16 ; weapName[n] = "Cigarette" ; weapFile[n] = "Cigar"
	weapSound[n] = sCigar ; weapTex[n] = 0 ; weapShiny[n] = 0
	weapSize[n] = 4 ; weapWeight[n] = 0.15
	weapRange[n] = 6 ; weapDamage[n] = 1
	weapStyle[n] = 5 ; weapHabitat[n] = 99
	weapCreate[n] = 1 ; weapValue[n] = 5
	// syringe
	n = 17 ; weapName[n] = "Syringe" ; weapFile[n] = "Syringe"
	weapSound[n] = sSyringe ; weapTex[n] = 0 ; weapShiny[n] = 0.5
	weapSize[n] = 4 ; weapWeight[n] = 0.1
	weapRange[n] = 5 ; weapDamage[n] = 1
	weapStyle[n] = 5 ; weapHabitat[n] = 99
	weapCreate[n] = 1 ; weapValue[n] = 5
	// beer bottle
	n = 18 ; weapName[n] = "Bottle" ; weapFile[n] = "Bottle"
	weapSound[n] = sBottle ; weapTex[n] = 0 ; weapShiny[n] = 0.5
	weapSize[n] = 6 ; weapWeight[n] = 0.3
	weapRange[n] = 6 ; weapDamage[n] = 2
	weapStyle[n] = 0 ; weapHabitat[n] = 99
	weapCreate[n] = 1 ; weapValue[n] = 10
	// fire extinguisher
	n = 19 ; weapName[n] = "Extinguisher" ; weapFile[n] = "Extinguisher"
	weapSound[n] = sMetal ; weapTex[n] = 0 ; weapShiny[n] = 1.0
	weapSize[n] = 10 ; weapWeight[n] = 0.5
	weapRange[n] = 8 ; weapDamage[n] = 2
	weapStyle[n] = 1 ; weapHabitat[n] = 10
	weapCreate[n] = 1 ; weapValue[n] = 50
	// screwdriver
	n = 20 ; weapName[n] = "Screwdriver" ; weapFile[n] = "Screw"
	weapSound[n] = sBlade ; weapTex[n] = 0 ; weapShiny[n] = 1
	weapSize[n] = 5 ; weapWeight[n] = 0.25
	weapRange[n] = 6 ; weapDamage[n] = 3
	weapStyle[n] = 7 ; weapHabitat[n] = 10
	weapCreate[n] = 1 ; weapValue[n] = 10
	// scissors
	n = 21 ; weapName[n] = "Scissor" ; weapFile[n] = "Scissors"
	weapSound[n] = sBlade ; weapTex[n] = 0 ; weapShiny[n] = 1
	weapSize[n] = 5 ; weapWeight[n] = 0.25
	weapRange[n] = 6 ; weapDamage[n] = 4
	weapStyle[n] = 7 ; weapHabitat[n] = 4
	weapCreate[n] = 1 ; weapValue[n] = 10
	// meat cleaver
	n = 22 ; weapName[n] = "Meat Cleaver" ; weapFile[n] = "Cleaver"
	weapSound[n] = sBlade ; weapTex[n] = 0 ; weapShiny[n] = 1
	weapSize[n] = 8 ; weapWeight[n] = 0.3
	weapRange[n] = 8 ; weapDamage[n] = 5
	weapStyle[n] = 1 ; weapHabitat[n] = 8
	weapCreate[n] = 1 ; weapValue[n] = 20
	// samurai sword
	n = 23 ; weapName[n] = "Sword" ; weapFile[n] = "Samurai"
	weapSound[n] = sBlade ; weapTex[n] = 0 ; weapShiny[n] = 1
	weapSize[n] = 8 ; weapWeight[n] = 0.3
	weapRange[n] = 10 ; weapDamage[n] = 5
	weapStyle[n] = 1 ; weapHabitat[n] = 0
	weapCreate[n] = 1 ; weapValue[n] = 50
	// comb
	n = 24 ; weapName[n] = "Comb" ; weapFile[n] = "Comb"
	weapSound[n] = sCigar ; weapTex[n] = 0 ; weapShiny[n] = 0.25
	weapSize[n] = 5 ; weapWeight[n] = 0.2
	weapRange[n] = 6 ; weapDamage[n] = 1
	weapStyle[n] = 0 ; weapHabitat[n] = 99
	weapCreate[n] = 0 ; weapValue[n] = 10
	// mirror
	n = 25 ; weapName[n] = "Mirror" ; weapFile[n] = "Mirror"
	weapSound[n] = sGeneric ; weapTex[n] = 0 ; weapShiny[n] = 0.5
	weapSize[n] = 8 ; weapWeight[n] = 0.25
	weapRange[n] = 7 ; weapDamage[n] = 2
	weapStyle[n] = 1 ; weapHabitat[n] = 99
	weapCreate[n] = 1 ; weapValue[n] = 20
}



