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
screen := 0
oldScreen :: 0 // Unused
screenSource := 0
screenAgenda := 0
screenCall := 0
callX := 0
callY := 0
go := 0
gotim := 0
foc := 0
subfoc := 0 // Unused
timer := 0
keytim := 0
file := 0
saver := 0 // Unused
loader := 0 // Unused
tester := 0 // Unused

////////////////////////////////////////////////////////
//------------------- PROGRESS -------------------------
////////////////////////////////////////////////////////
// Progress
slot := 1
oldLocation: int
gamPoints: int
gamPointLimit: int
gamPause: int
gamFile: int
gamDoor: int
gamEnded: int
gamName: [4]string
gamPhoto: [4]bb.ImageHandle
gamChar: [4]string
gamPlayer: [4]string
gamLocation: [4]string
gamMoney: [4]int
gamSpeed: [4]int
gamSecs: [4]int
gamMins: [4]int
gamHours: [4]int
// handles
gamWarrant: [4]int
gamVictim: [4]int
gamItem: [4]int
gamArrival: [4]int
gamFatality: [4]int
gamRelease: [4]int
gamEscape: [4]int
gamGrowth: [4]int
gamBlackout: [4]int
gamBombThreat: [4]int
// missions
gamMission: [4]int
gamClient: [4]int
gamTarget: [4]int
gamDeadline: [4]int
gamReward: [4]int
// stat highlighters (1=strength, 2=agility, 3=intell, 4=rep, 5=time, 6=sentence, 7=money)
statTim: [11]int
// promos
gamPromo: int
no_promos :: 300
promoTim: int
promoStage := 0 // 0=intro, 1=option, 2=positive response, 3=negative response
promoEffect: int
promoVariable: int
promoAccuser: int
promoVerdict: int
promoCash: int
optionB: string
optionA: string
promoActor: [3]int
promoReact: [11]int
promoUsed: [no_promos + 1]int
// phones
phoneRing: int
phoneTim: int
phonePromo: int
phoneX: [5]f32
phoneY: [5]f32
phoneZ: [5]f32
// outro
endChar: [11]int
endFate: [11]int

////////////////////////////////////////////////////////
//------------------- OPTIONS --------------------------
////////////////////////////////////////////////////////
// constants
optPlayLim :: 50
optCharLim :: 200
optWeapLim :: 100
optPopulation := 60
// preferences
optRes := 2
optFog := 1
optFX := 1
optShadows := 2
optGore := 3 // 0=none, 1=scars, 2=pools, 3=limbs
// keys & buttons
keyAttack := 30
keyDefend := 44
keyThrow := 31
keyPickUp := 45
buttAttack := 1
buttDefend := 3
buttThrow := 2
buttPickUp := 4

/////////////////////////////////////////////////////////
//----------------------- SOUND -------------------------
/////////////////////////////////////////////////////////
// music & atmosphere
sTheme: int
chTheme: int
musicVol: f32
chAtmos: int
sAtmos: int
chPhone: int
chAlarm: int
// menu effects
sMenuBrowse: bb.SoundHandle
sMenuSelect: bb.SoundHandle
sMenuGo: bb.SoundHandle
sMenuBack: bb.SoundHandle
sVoid: bb.SoundHandle
sTrash: bb.SoundHandle
sCamera: bb.SoundHandle
sComputer: bb.SoundHandle
sCash: bb.SoundHandle
sPaper: bb.SoundHandle
// court reactions
sMurmur: bb.SoundHandle
sJury: [3]bb.SoundHandle
// world
sDoor: [4]bb.SoundHandle
sBuzzer: bb.SoundHandle
sBell: bb.SoundHandle
sRing: bb.SoundHandle
sAlarm: bb.SoundHandle
sTanoy: bb.SoundHandle
sBasket: bb.SoundHandle
// movements
sFall: bb.SoundHandle
sThud: bb.SoundHandle
sShuffle: [4]bb.SoundHandle
sStep: [7]bb.SoundHandle
// pain
chDeath: int
sDeath: bb.SoundHandle
sChoke: bb.SoundHandle
sSnore: bb.SoundHandle
sBreakdown: bb.SoundHandle
sPain: [11]bb.SoundHandle
sAgony: [6]bb.SoundHandle
// impacts
sSwing: bb.SoundHandle
sBleed: bb.SoundHandle
sStab: bb.SoundHandle
sEat: bb.SoundHandle
sDrink: bb.SoundHandle
sImpact: [7]bb.SoundHandle
// weapons
sGeneric: bb.SoundHandle
sBlade: bb.SoundHandle
sMetal: bb.SoundHandle
sWood: bb.SoundHandle
sCane: bb.SoundHandle
sString: bb.SoundHandle
sRock: bb.SoundHandle
sAxe: bb.SoundHandle
sBall: bb.SoundHandle
sPhone: bb.SoundHandle
sCigar: bb.SoundHandle
sSyringe: bb.SoundHandle
sBottle: bb.SoundHandle
sSplash: bb.SoundHandle
// technology
sShot: [6]bb.SoundHandle
sRicochet: [6]bb.SoundHandle
sReload: bb.SoundHandle
sGun: bb.SoundHandle
sMine: bb.SoundHandle
sExplosion: bb.SoundHandle
sBlaze: bb.SoundHandle
sLaser: bb.SoundHandle

////////////////////////////////////////////////////////
//-------------------- PLAYERS -------------------------
////////////////////////////////////////////////////////
no_plays: int
p: [optPlayLim + 1]bb.EntityHandle
pPivot: [optPlayLim + 1]bb.EntityHandle
pMovePivot: [optPlayLim + 1]bb.EntityHandle
pFoc: [optPlayLim + 1]bb.EntityHandle
pX: [optPlayLim + 1]f32
pY: [optPlayLim + 1]f32
pZ: [optPlayLim + 1]f32
pOldX: [optPlayLim + 1]f32
pOldY: [optPlayLim + 1]f32
pOldZ: [optPlayLim + 1]f32
pA: [optPlayLim + 1]f32
pTA: [optPlayLim + 1]f32
pGrappling: [optPlayLim + 1]bool
pGrappler: [optPlayLim + 1]int
pCollisions: [optPlayLim + 1]bool
pOldMoveX: [optPlayLim + 1]f32
pOldMoveZ: [optPlayLim + 1]f32
// scenery interaction
pPhone: [optPlayLim + 1]bool
pBed: [optPlayLim + 1]bool
pSeat: [optPlayLim + 1]bool
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
pFoodTim: [optPlayLim + 1]int
// physics
pGround: [optPlayLim + 1]f32
pHurtA: [optPlayLim + 1]f32
pStagger: [optPlayLim + 1]bool
pSpeed: [optPlayLim + 1]f32
pGravity: [optPlayLim + 1]f32
pCharge: [optPlayLim + 1]f32
// status
pSting: [optPlayLim + 1]bool
pMultiSting: [optPlayLim + 1][optPlayLim + 1]bool
pHealth: [optPlayLim + 1]f32
pHealthLimit: [optPlayLim + 1]f32
pOldHealth: [optPlayLim + 1]f32
pInjured: [optPlayLim + 1]bool
pDazed: [optPlayLim + 1]bool
pHP: [optPlayLim + 1]int
pDT: [optPlayLim + 1]int
pWeapon: [optPlayLim + 1]int
pWeaponTim: [optPlayLim + 1][optWeapLim + 1]int
// input
pControl: [optPlayLim + 1]bool
cUp: [optPlayLim + 1]bool
cDown: [optPlayLim + 1]bool
cLeft: [optPlayLim + 1]bool
cRight: [optPlayLim + 1]bool
cAttack: [optPlayLim + 1]bool
cDefend: [optPlayLim + 1]bool
cThrow: [optPlayLim + 1]bool
cPickUp: [optPlayLim + 1]bool
pFireTim: [optPlayLim + 1]int
// AI
pAgenda: [optPlayLim + 1]int
pOldAgenda: [optPlayLim + 1]int
pTarget: [optPlayLim + 1]int
pTX: [optPlayLim + 1]f32
pTY: [optPlayLim + 1]f32
pTZ: [optPlayLim + 1]f32
pExploreX: [optPlayLim + 1]f32
pExploreY: [optPlayLim + 1]f32
pExploreZ: [optPlayLim + 1]f32
pSubX: [optPlayLim + 1]f32
pSubZ: [optPlayLim + 1]f32
pExploreRange: [optPlayLim + 1]f32
pSatisfied: [optPlayLim + 1]bool
pNowhere: [optPlayLim + 1]bool
pRunTim: [optPlayLim + 1]int
pFollowFoc: [optPlayLim + 1]bool
pWeapFoc: [optPlayLim + 1]bool
pInteract: [optPlayLim + 1][optPlayLim + 1]bool
// animation
pSeq: [optPlayLim + 1][621]int
pState: [optPlayLim + 1]int
pPromoState: [optPlayLim + 1]int
pAnim: [optPlayLim + 1]int
pOldAnim: [optPlayLim + 1]int
pAnimTim: [optPlayLim + 1]int
pAnimSpeed: [optPlayLim + 1]f32
pStepTim: [optPlayLim + 1]int
// appearance
pChar: [optPlayLim + 1]int
pEyes: [optPlayLim + 1]int
pOldEyes: [optPlayLim + 1]int
pMouth: [optPlayLim + 1]int
pSpeaking: [optPlayLim + 1]bool
pShadow: [optPlayLim + 1][41]bb.EntityHandle
pControlTim: [optPlayLim + 1]int
pTag: [3]string
pHighlight: [3]string

/////////////////////////////////////////////////////////
//----------------------- LIMBS -------------------------
/////////////////////////////////////////////////////////
// status
pLimb: [optPlayLim][41]bb.EntityHandle
pScar: [optPlayLim][41]bb.EntityHandle
pOldScar: [optPlayLim][41]bb.EntityHandle
// heirarchy
limbPrecede: [41]int
limbSource: [41]int

/////////////////////////////////////////////////////////
//--------------------- CHARACTERS ----------------------
/////////////////////////////////////////////////////////
no_chars: int
no_costumes := 8
no_models := 5
no_hairstyles := 31
no_specs := 4
// appearance
charModel: [optCharLim + 1]int
charHeight: [optCharLim + 1]f32
charSpecs: [optCharLim + 1]int
charAccessory: [optCharLim + 1]int // 1-6=gangs, 7=warden hat
charHairStyle: [optCharLim + 1]int
charHair: [optCharLim + 1]int
charFace: [optCharLim + 1]int
charCostume: [optCharLim + 1]int // 0=bare-chested, 1=tight vest, 2=baggy vest, 3=tight t-shirt, 4=baggy t-shirt, 5=tight short sleeve, 6=baggy short sleeve, 7=tight long sleeve, 8=baggy long sleeve
charScar: [optCharLim + 1][41]bb.EntityHandle
// attributes
charHealth: [optCharLim + 1]f32
charHP: [optCharLim + 1]int
charStrength: [optCharLim + 1]int
charAgility: [optCharLim + 1]int
charHappiness: [optCharLim + 1]int
charBreakdown: [optCharLim + 1]int
charIntelligence: [optCharLim + 1]int
charReputation: [optCharLim + 1]int
charOldStrength: [optCharLim + 1]int
charOldAgility: [optCharLim + 1]int
charOldIntelligence: [optCharLim + 1]int
charOldReputation: [optCharLim + 1]int
charExperience: [optCharLim + 1]int
// status
charPlayer: [optCharLim + 1]bool
charName: [optCharLim + 1]string
charPhoto: [optCharLim + 1]string
charSnapped: [optCharLim + 1]bool
charRole: [optCharLim + 1]int // 0=prisoner, 1=warden
charSentence: [optCharLim + 1]int
charCrime: [optCharLim + 1]string
charLocation: [optCharLim + 1]int // 0=dead, 1=north block, 2=yard, 3=east block, 4=study, 5=south block, 6=hospital, 7=west block, 8=kitchen, 9=hall, 10=workshop, 11=toilet
charBlock: [optCharLim + 1]int // 1=north, 2=east, 3=south, 4=west
charCell: [optCharLim + 1]int
charGang: [optCharLim + 1]int
charGangHistory: [optCharLim + 1][7]int
charRelation: [optCharLim + 1][optCharLim + 1]int // 0=none, -1=enemy, 1=friend
charAngerTim: [optCharLim + 1][optCharLim + 1]int
charAttacker: [optCharLim + 1]int
charWitness: [optCharLim + 1]int
charFollowTim: [optCharLim + 1]int
charBribeTim: [optCharLim + 1]int
charX: [optCharLim + 1]f32
charY: [optCharLim + 1]f32
charZ: [optCharLim + 1]f32
charA: [optCharLim + 1]f32
charInjured: [optCharLim + 1]bool
charWeapon: [optCharLim + 1]int
charWeapHistory: [optCharLim + 1][31]int
charPromo: [optCharLim + 1][optCharLim + 1]int
charPromoRef: [optCharLim + 1]int

/////////////////////////////////////////////////////////
//--------------------- GRAPHICS ------------------------
/////////////////////////////////////////////////////////
// Images
// Variables
font: [11]bb.FontHandle
fontTest: [11]bb.FontHandle
fontNumber: bb.FontHandle
fontComputer: bb.FontHandle
fontMoney: bb.FontHandle
fontClock: bb.FontHandle
gLogo: [4]bb.ImageHandle
gMenu: [11]bb.ImageHandle
gTile: bb.ImageHandle
gMDickie: bb.ImageHandle
gHealth: bb.ImageHandle
gHappiness: bb.ImageHandle
gMoney: bb.ImageHandle
gPhoto: bb.ImageHandle
gMap: bb.ImageHandle
gMarker: bb.ImageHandle

/////////////////////////////////////////////////////////
//--------------------- TEXTURES ------------------------
/////////////////////////////////////////////////////////
no_hairs: int
no_faces: int
no_bodies: int
no_arms: int
no_legs: int

// World variables
tSign: [21]bb.TextureHandle
tBlock: [5]bb.TextureHandle
tCell: [21]bb.TextureHandle
tFence: bb.TextureHandle
tNet: bb.TextureHandle
tShower: bb.TextureHandle
tCrowd: bb.AnimTextureHandle
tScreen: [11]bb.TextureHandle
tTray: [11]bb.TextureHandle
// Weapon variables
tMachine: bb.TextureHandle
tPistol: bb.TextureHandle
// Character variables
tShaved: bb.TextureHandle
tEars: bb.TextureHandle
tSeverEars: bb.TextureHandle
tEyes: [4]bb.TextureHandle
tMouth: [6]bb.TextureHandle
tSpecs: [4]bb.TextureHandle
tHair: [201]bb.TextureHandle
tFace: [101]bb.TextureHandle
tBody: [101]bb.TextureHandle
tArm: [101]bb.TextureHandle
tLegs: [101]bb.TextureHandle
tBodyShade: [11]bb.TextureHandle
tArmShade: [11]bb.TextureHandle
tFaceScar: [6]bb.TextureHandle
tBodyScar: [6]bb.TextureHandle
tArmScar: [6]bb.TextureHandle
tLegScar: [6]bb.TextureHandle
tSeverBody: [4]bb.TextureHandle
tSeverArm: [4]bb.TextureHandle
tSeverLegs: [4]bb.TextureHandle
tTattooBody: [7]bb.TextureHandle
tTattooVest: [7]bb.TextureHandle
tTattooArm: [7]bb.TextureHandle
tTattooTee: [7]bb.TextureHandle
tTattooSleeve: [7]bb.TextureHandle

/////////////////////////////////////////////////////////
//--------------------- WEAPONS -------------------------
/////////////////////////////////////////////////////////
no_weaps := 100
weapList :: 25
// state
weap: [optWeapLim + 1]bb.EntityHandle
weapType: [optWeapLim + 1]int
weapCarrier: [optWeapLim + 1]int
weapThrower: [optWeapLim + 1]int
weapSting: [optWeapLim + 1][optPlayLim + 1]int
weapClip: [optWeapLim + 1]int
weapAmmo: [optWeapLim + 1]int
weapScar: [optWeapLim + 1]bb.EntityHandle
weapOldScar: [optWeapLim + 1]bb.EntityHandle
weapState: [optWeapLim + 1]int
weapLocation: [optWeapLim + 1]int
// physics
weapWall: [optWeapLim + 1]bool
weapGround: [optWeapLim + 1]bool
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
weapBounce: [optWeapLim + 1]int
// type
weapName: [weapList + 1]string
weapFile: [weapList + 1]string
weapSound: [weapList + 1]bb.SoundHandle
weapTex: [weapList + 1]bb.TextureHandle
weapSize: [weapList + 1]f32
weapWeight: [weapList + 1]f32
weapValue: [weapList + 1]int
weapRange: [weapList + 1]f32
weapDamage: [weapList + 1]int
weapShiny: [weapList + 1]f32
weapStyle: [weapList + 1]int // 0=hand, 1=sword, 2=shield, 3=pistol, 4=rifle, 5=???, 6=TNT, 7=stab
weapHabitat: [weapList + 1]int
weapCreate: [weapList + 1]int
// creation kits
kit: [7]bb.EntityHandle
kitType: [7]int
kitState: [7]int

/////////////////////////////////////////////////////////
//----------------------- WORLD -------------------------
/////////////////////////////////////////////////////////
world: int
no_chairs, no_beds, no_doors: int
wScreen, wOldScreen: int
// Food trays
trayState: [51]int
trayOldState: [51]int
// Camera
camListener, dummy: int
camType, camTim: int
cam, camPivot: int
camFoc, camOldFoc: int
camX, camY, camZ: f32 = 0, 75, 0
camTX, camTY, camTZ: f32
camPivX, camPivY, camPivZ: f32 = 0, 100, 0
camPivTX, camPivTY, camPivTZ: f32
camRectify: int
camMouseX, camMouseY: f32
// Smooth co-ordination
speedX, speedY, speedZ: f32
// Camera presets
camShortcut := [11]int{0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 0}
// Lighting
light: [11]int
no_lights: int
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
cellLocked: [16][21]int
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
fader: int
fadeAlpha: f32
fadeTraget: f32
// Particles
no_particles := 500
part: [1001]int
partType: [1001]int
partX: [1001]f32
partY: [1001]f32
partZ: [1001]f32
partA: [1001]f32
partGravity: [1001]f32
partFlight: [1001]f32
partSize: [1001]f32
partAlpha: [1001]f32
partFade: [1001]f32
partTim: [1001]int
partState: [1001]int
// Explotions
no_explodes :: 20
exType: [no_explodes + 1]int
exX: [no_explodes + 1]f32
exY: [no_explodes + 1]f32
exZ: [no_explodes + 1]f32
exTim: [no_explodes + 1]f32
exSource: [no_explodes + 1]f32
exHurt: [no_explodes + 1][optPlayLim + 1]int
// Pools
// This variable is assigned again in Gameplay.bb (probably a bug), 
// so I have to manually set the arrays below to a length of 51
no_pools := 50
pool: [51]int
poolType: [51]int
poolX: [51]f32
poolY: [51]f32
poolZ: [51]f32
poolA: [51]f32
poolSize: [51]f32
poolAlpha: [51]f32
poolState: [51]int
// Bullets
no_bullets :: 40
bullet: [no_bullets + 1]int
bulletX: [no_bullets + 1]f32
bulletY: [no_bullets + 1]f32
bulletZ: [no_bullets + 1]f32
bulletXA: [no_bullets + 1]f32
bulletYA: [no_bullets + 1]f32
bulletZA: [no_bullets + 1]f32
bulletState: [no_bullets + 1]int
bulletTim: [no_bullets + 1]int
bulletShooter: [no_bullets + 1]int


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
	for count in 1..=3 {
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
	for count in 1..=3 {
		sShuffle[count] = bb.Load3DSound(fmt.tprintf("Sound/Movement/Shuffle0%d.wav", count))
	}
	for count in 1..=4 {
		sStep[count] = bb.Load3DSound(fmt.tprintf("Sound/Movement/Step0%d.wav", count))
	}
	// pain
	sDeath = bb.Load3DSound("Sound/Pain/Death.wav")
	sChoke = bb.Load3DSound("Sound/Pain/Choke.wav")
	sSnore = bb.Load3DSound("Sound/Pain/Snoring.wav")
	sBreakdown = bb.Load3DSound("Sound/Pain/Breakdown.wav")
	for count in 1..=8 {
		sPain[count] = bb.Load3DSound(fmt.tprintf("Sound/Pain/Pain0%d.wav", count))
	}
	for count in 1..=3 {
		sAgony[count] = bb.Load3DSound(fmt.tprintf("Sound/Pain/Agony0%d.wav", count))
	}
	// impacts
	sSwing = bb.Load3DSound("Sound/Movement/Swing.wav")
	sBleed = bb.Load3DSound("Sound/Props/Bleed.wav")
	sStab = bb.Load3DSound("Sound/Props/Stab.wav")
	sEat = bb.Load3DSound("Sound/Props/Eat.wav")
	sDrink = bb.Load3DSound("Sound/Props/Drink.wav")
	for count in 1..=6 {
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
	for count in 1..=2 {
		sShot[count] = bb.Load3DSound(fmt.tprintf("Sound/Props/Shot0%d.wav", count))
	}
	for count in 1..=3 {
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
	for b in 1..=8 {
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
	for count in 1..=3 {
		gLogo[count] = bb.LoadImage(fmt.tprintf("Graphics/Logo0%d.png", count))
		bb.MaskImage(gLogo[count], 255, 0, 255)
	}
	gMDickie = bb.LoadImage("Graphics/MDickie.png")
	bb.MaskImage(gMDickie, 255, 0, 255)

	// menu boxes
	for count in 1..=4 {
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
	for count in 1..=3 {
		gamPhoto[count] = bb.LoadImage(fmt.tprintf("Data/Slot0%d/Photos/Game.bmp", count))
		if gamPhoto[count] > 0 {
			bb.MaskImage(gamPhoto[count], 255, 0, 255)
		}
	}
}


texture_loading :: proc() {
	count_texture_files :: proc(path, all_caps_prefix: string, counter: ^int) {
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
	for count in 1..=11 {
		tSign[count - 1] = bb.LoadTexture(fmt.tprintf("World/Signs/Sign%s.png", Dig(count, 10)))
	}
	for count in 1..=4 {
		tBlock[count - 1] = bb.LoadTexture(fmt.tprintf("Characters/Numbers/Block%s.png", Dig(count, 10)))
	}
	for count in 1..=20 {
		tCell[count - 1] = bb.LoadTexture(fmt.tprintf("Characters/Numbers/Cell%s.png", Dig(count, 10)))
	}
	// video screens
	for count in 0..=10 {
		tScreen[count] = bb.LoadTexture(fmt.tprintf("World/Screens/Screen%s.JPG", Dig(count, 10)))
	}
	// food trays
	for count in 0..=7 {
		tTray[count] = bb.LoadTexture(fmt.tprintf("World/Sprites/Tray%s.JPG", Dig(count, 10)))
	}
	// world
	tFence = bb.LoadTexture("World/Sprites/Fence.png", bb.TextureFlag.MASKED)
	tNet = bb.LoadTexture("World/Sprites/Net.png", bb.TextureFlag.MASKED)
	tShower = bb.LoadTexture("World/Sprites/Shower.png", bb.TextureFlag.MASKED)
	tCrowd = bb.LoadAnimTexture("World/Sprites/Crowd.png", bb.TextureFlag.MASKED, 512, 128, 0, 4)
	// weapons
	tMachine = bb.LoadTexture("Weapons/Textures/Machine.png", bb.TextureFlag.MASKED)
	tPistol = bb.LoadTexture("Weapons/Textures/Pistol.png", bb.TextureFlag.MASKED)
	// facial expressions
	Loader("Please Wait", "Loading Expressions")
	tEars = bb.LoadTexture("Characters/Expressions/Ears.JPG")
	for count in 1..=3 {
		tEyes[count - 1] = bb.LoadTexture(fmt.tprintf("Characters/Expressions/Eyes0%d.JPG", count))
	}
	for count in 0..=5 {
		tMouth[count] = bb.LoadTexture(fmt.tprintf("Characters/Expressions/Mouth0%d.JPG", count))
	}
	// costume variations
	tShaved = bb.LoadTexture("Characters/Hair/Shaved.JPG")
	for count in 1..=3 {
		tSpecs[count - 1] = bb.LoadTexture(fmt.tprintf("Characters/Specs/Specs%s.JPG", Dig(count, 10)))
	}
	for count in 1..=no_hairs {
		tHair[count - 1] = bb.LoadTexture(fmt.tprintf("Characters/Hair/Hair%s.png", Dig(count, 10)), bb.TextureFlag.MASKED)
	}
	for count in 1..=no_faces {
		Loader("Please Wait", fmt.tprintf("Loading Face %s of %s", Dig(count, 10), no_faces))
		tFace[count - 1] = bb.LoadTexture(fmt.tprintf("Characters/Faces/Face%s.JPG", Dig(count, 10)))
	}
	for count in 1..=no_bodies {
		Loader("Please Wait", fmt.tprintf("Loading Body %s of %s", Dig(count, 10), no_bodies))
		tBody[count - 1] = bb.LoadTexture(fmt.tprintf("Characters/Bodies/Body%s.JPG", Dig(count, 10)))
	}
	for count in 1..=no_arms {
		Loader("Please Wait", fmt.tprintf("Loading Arm %s of %s", Dig(count, 10), no_arms))
		tArm[count - 1] = bb.LoadTexture(fmt.tprintf("Characters/Arms/Arm%s.JPG", Dig(count, 10)))
	}
	for count in 1..=no_legs {
		Loader("Please Wait", fmt.tprintf("Loading Legs %s of %s", Dig(count, 10), no_legs))
		tLegs[count - 1] = bb.LoadTexture(fmt.tprintf("Characters/Legs/Legs%s.JPG", Dig(count, 10)))
	}
	// racial shades
	Loader("Please Wait", "Loading Shades")
	for count in 1..=4 {
		tBodyShade[count - 1] = bb.LoadTexture(fmt.tprintf("Characters/Shading/Body%s.png", Dig(count, 10)))
	}
	for count in 1..=8 {
		tArmShade[count - 1] = bb.LoadTexture(fmt.tprintf("Characters/Shading/Arm%s.png", Dig(count, 10)))
	}
	// scarring
	Loader("Please Wait", "Loading Scars")
	for count in 0..=5 {
		tFaceScar[count] = bb.LoadTexture(fmt.tprintf("Characters/Scarring/Face%s.JPG", Dig(count, 10)))
	}
	for count in 0..=4 {
		tBodyScar[count] = bb.LoadTexture(fmt.tprintf("Characters/Scarring/Body%s.JPG", Dig(count, 10)))
	}
	for count in 0..=4 {
		tArmScar[count] = bb.LoadTexture(fmt.tprintf("Characters/Scarring/Arm%s.JPG", Dig(count, 10)))
	}
	for count in 0..=4 {
		tLegScar[count] = bb.LoadTexture(fmt.tprintf("Characters/Scarring/Legs%s.JPG", Dig(count, 10)))
	}
	// wounds
	tSeverEars = bb.LoadTexture("Characters/Scarring/Wounds/Ears.JPG")
	for count in 1..=3 {
		tSeverBody[count - 1] = bb.LoadTexture(fmt.tprintf("Characters/Scarring/Wounds/Body%s.JPG", Dig(count, 10)))
	}
	for count in 1..=3 {
		tSeverArm[count - 1] = bb.LoadTexture(fmt.tprintf("Characters/Scarring/Wounds/Arm%s.JPG", Dig(count, 10)))
	}
	for count in 1..=3 {
		tSeverLegs[count - 1] = bb.LoadTexture(fmt.tprintf("Characters/Scarring/Wounds/Legs%s.JPG", Dig(count, 10)))
	}
	// tattoos
	for count in 1..=6 {
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



