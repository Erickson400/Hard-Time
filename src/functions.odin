package main

import "core:fmt"
import "core:strings"
import bb "blitzbasic3d"


////////////////////////////////////////////////////////////////////////////////
//--------------------------- UNIVERSAL FUNCTIONS ------------------------------
////////////////////////////////////////////////////////////////////////////////


// Produce Variant Sound
ProduceSound :: proc(entity, sound, pitch: i32, vol: f32) {
	vol := vol
	// fluctuate pitch
	range1 := pitch - (pitch / 8)
	range2 := pitch + (pitch / 16)
	pitcher := bb.Rnd(range1, range2)
	// fluctuate volume
	if vol == 0.0 do vol = bb.Rnd(0.4, 1.2)
	// deliver sound
	if sound > 0 && (gotim > 0 || screen != 50) {
		if pitch > 0 do bb.SoundPitch(sound, pitcher)
		bb.SoundVolume(sound, vol)
		if entity > 0 do bb.EmitSound(sound, entity)
		if entity == 0 do bb.EmitSound(sound, cam)
		// reset
		if pitch > 0 do bb.SoundPitch(sound, pitch)
		bb.SoundVolume(sound, 1.0)
	}
}

//---------------------------------------------------------------------------
/////////////////////////////// GRAPHICAL ///////////////////////////////////
//---------------------------------------------------------------------------

// Outline
Outline :: proc(script: string, x, y, r1, g1, b1, r2, g2, b2: i32) {
	// outline
	if r1 != r2 || g1 != g2 || b1 != b2 {
		bb.Color(r1, g1, b1)
		bb.Text(x + 2, y + 2, script, 1, 1)
		bb.Text(x + 1, y, script, 1, 1)
		bb.Text(x - 1, y, script, 1, 1)
		bb.Text(x, y + 1, script, 1, 1)
		bb.Text(x, y - 1, script, 1, 1)
	}
	// core
	bb.Color(r2, g2, b2)
	bb.Text(x, y, script, 1, 1)
}


// Outline Straight
OutlineStraight :: proc(script: string, x, y: i32, r1, g1, b1, r2, g2, b2: i32) {
	// outline
	if r1 != r2 || g1 != g2 || b1 != b2 {
		bb.Color(r1, g1, b1)
		bb.Text(x + 2, y + 2, script, 0, 1)
		bb.Text(x + 1, y, script, 0, 1)
		bb.Text(x - 1, y, script, 0, 1)
		bb.Text(x, y + 1, script, 0, 1)
		bb.Text(x, y - 1, script, 0, 1)
	}
	// core
	bb.Color(r2, g2, b2)
	bb.Text(x, y, script, 0, 1)
}


// Plot Bold Line
DrawLine :: proc(startX, startY, endX, endY, r, g, b: i32) {
	// outline
	bb.Color(0, 0, 0)
	bb.Line(startX - 1, startY, endX - 1, endY)
	bb.Line(startX + 1, startY, endX + 1, endY)
	bb.Line(startX, startY - 1, endX, endY - 1)
	bb.Line(startX, startY + 1, endX, endY + 1)
	// coloured line
	bb.Color(r, g, b)
	bb.Line(startX, startY, endX, endY)
}


// Resolution X Fix
rX :: proc(x: f32) -> f32 {
	factor := 800.0 / f32(bb.GraphicsWidth())
	newX := x / factor
	return newX
}


// Resolution Y Fix
rY :: proc(y: f32) -> f32 {
	factor := 600.0 / f32(bb.GraphicsHeight())
	newY := y / factor
	return newY
}


//---------------------------------------------------------------------------
////////////////////////////// MATHEMATICAL /////////////////////////////////
//---------------------------------------------------------------------------

// CALCULATE CENTRE (of any 2 numbers)
GetHeight :: proc(value: i32) -> string {
	feet := value / 12
	inches := value - (feet * 12)
	ft := fmt.aprintf("%s'", feet + 5)
	inch := fmt.aprintf("%s''", inches)
	figure := strings.concatenate({ft, inch})
	delete(ft)
	delete(inch)
	return figure
}


// CALCULATE 1'000'000 FIGURE
GetFigure :: proc(value: i32) -> string {
	value := value
	minus := 0
	if value < 0 {
		minus = 1
		value -= (value * 2)
	}
	// get segments
	hundreds, thousands, millions: i32 = 0, 0, 0
	millions = value / 1000000
	if millions < 0 do millions = 0
	thousands = (value - (millions * 1000000)) / 1000
	if thousands < 0 do thousands = 0
	hundreds = value - ((millions * 1000000) + (thousands * 1000))
	if hundreds < 0 do hundreds = 0
	// piece together

	hun, tho, mil: strings.Builder
	strings.builder_init(&hun)
	strings.builder_init(&tho)
	strings.builder_init(&mil)
	if thousands > 0 do fmt.sbprintf(&tho, "%s", thousands)
	if millions > 0 do fmt.sbprintf(&mil, "%s", millions)
	if thousands > 0 || millions > 0 do fmt.sbprintf(&hun, "'%s", hundreds)
	if (thousands > 0 || millions > 0) && hundreds < 100 do fmt.sbprintf(&hun, "'0%s", hundreds)
	if (thousands > 0 || millions > 0) && hundreds < 10 do fmt.sbprintf(&hun, "'00%s", hundreds)
	if millions > 0 do fmt.sbprintf(&tho, "'%s", thousands)
	if millions > 0 && thousands < 100 do fmt.sbprintf(&tho, "'0%s", thousands)
	if millions > 0 && thousands < 10 do fmt.sbprintf(&tho, "'00%s", thousands)
	// return
	figure: strings.Builder
	strings.builder_init(&figure)
	if minus == 0 do fmt.sbprint(&figure, mil, tho, hun)
	if minus == 1 do fmt.sbprint(&figure, "-", mil, tho, hun)
	strings.builder_destroy(&hun)
	strings.builder_destroy(&tho)
	strings.builder_destroy(&mil)
	return strings.to_string(figure)
}


// FORMAT DIGITS (to 2 or 3 digits with leading zeros)
Dig :: proc(value, degree: i32) -> string {
	if value == 0 && degree == 10 do return "00"
	if value == 0 && degree == 100 do return "000"
	if value < degree {
		if value < degree / 10 {
			return fmt.aprintf("00%s", value)
		} else {
			return fmt.aprintf("0%s", value)
		}
	}
	return fmt.aprintf("%s", value)
}


// ROUND OFF (to nearest degree)
RoundOff :: proc(value, degree: i32) -> i32 {
	floater := f32(value) / f32(degree)
	inty := i32(floater)
	returner := inty * degree
	return returner
}


// reached value?
Reached :: proc(curr, dest: f32, range: i32) -> i32 {	
	value: i32= 0
	if curr > dest - f32(range) && curr < dest + f32(range) do value = 1
	return value
}


// Reached Co-ordinate?
ReachedCord :: proc(currX, currZ, destX, destZ: f32, range: i32) -> i32 {
	value: i32 = 0
	if currX > destX - f32(range) && currX < destX + f32(range) && currZ > destZ - f32(range) && currZ < destZ + f32(range) do value = 1
	return value
}


// CLEAN GIVEN ANGLE
CleanAngle :: proc(angle: f32) -> f32 {
	angle := angle
	its := 0
	for {
		if angle < 0 do angle += 360
		if angle > 360 do angle -= 360
		its += 1
		if (angle >= 0 && angle <= 360) || its > 100 do break
	}
	return angle
}


// Find Best Angle Route
ReachAngle :: proc(sA, tA, speed: f32) -> f32 {
	sA := sA
	tA := tA
	// clean angles
	sA = CleanAngle(sA)
	tA = CleanAngle(tA)
	// get negative route
	neg: i32 = 0
	checkA := sA
	for {
		neg += 1
		checkA -= 1
		if checkA < 0 do checkA = 360
		if checkA >= tA - 1 && checkA <= tA + 1 do break
	}
	// get positive route
	pos: i32 = 0
	checkA = sA
	for {
		pos += 1
		checkA += 1
		if checkA > 360 do checkA = 0
		if checkA >= tA - 1 && checkA <= tA + 1 do break
	}
	// return shortest route
	if neg < pos do return -speed
	return speed
}


// SATISFIED TARGET ANGLE?
SatisfiedAngle :: proc(sA, tA: f32, range: i32) -> i32 {
	value: i32 = 0
	// scan clockwise
	angler := sA
	for count in 1..=range {
		if angler >= tA - 1 && angler <= tA + 1 do value = 1
		angler += 1
		if angler > 360 do angler = 0
	}
	// scan counter-clockwise
	angler = sA
	for count in 1..=range {
		if angler >= tA - 1 && angler <= tA + 1 do value = 1
		angler -= 1
		if angler < 0 do angler = 360
	}
	return value
}


// CALCULATE DIFFERENCE (between any 2 numbers)
GetDiff :: proc(source, dest: f32) -> f32 {
	diff := dest - source
	if diff < 0 {
		diff = MakePositive(diff)
	}
	return diff
}


// CALCULATE CENTRE (of any 2 numbers)
GetCentre :: proc(source, dest: f32) -> f32 {
	return source + (GetDiff(source, dest) / 2)
}


// CALCULATE DISTANCE (between any 2 co-ordinates)
GetDistance :: proc(sourceX, sourceZ, destX, destZ: f32) -> f32 {
	diffX := GetDiff(sourceX, destX)
	diffZ := GetDiff(sourceZ, destZ)
	if diffX > diffZ {
		return diffX
	}
	return diffZ
}


// CALCULATE HIGHEST VALUE
HighestValue :: proc(valueA, valueB: f32) -> f32 {
	if valueB > valueA {
		return valueB
	}
	return valueA
}


// CALCULATE LOWEST VALUE
LowestValue :: proc(valueA, valueB: f32) -> f32 {
	if valueB < valueA {
		return valueB
	}
	return valueA
}


// SMOOTH TRAVELLING SPEEDS
GetSmoothSpeeds :: proc(x, tX, y, tY, z, tZ: f32, factor: i32) {
	// calculate differences & identify leader
	diffX := GetDiff(x, tX)
	lead := diffX
	leader: i32 = 1
	diffY := GetDiff(y, tY)
	if diffY > lead {
		lead = diffY
		leader = 2
	}
	diffZ := GetDiff(z, tZ)
	if diffZ > lead {
		lead = diffZ
		leader = 3
	}
	// avoid divide-by-zero
	if lead == 0 {
		speedX, speedY, speedZ = 0.0, 0.0, 0.0
		return
	}
	// make anchor speed from leading difference
	anchor := lead / f32(factor)
	// calculate respective speeds
	if leader == 1 {
		speedX = anchor
	} else {
		speedX = anchor * (diffX / lead)
	}
	if leader == 2 {
		speedY = anchor
	} else {
		speedY = anchor * (diffY / lead)
	}
	if leader == 3 {
		speedZ = anchor
	} else {
		speedZ = anchor * (diffZ / lead)
	}
}


// FORCE MINUS INTO POSITIVE
MakePositive :: proc(value: f32) -> f32 {
	if value < 0 {
		return value - (value * 2)
	}
	return value
}


// CALCULATE PERCENTAGE OF VALUE
PercentOf :: proc(valueA, percent: f32) -> f32 {
	return (valueA / 100.0) * percent
}


// CALCULATE VALUE AS PERCENT
GetPercent :: proc(valueA, valueB: f32) -> f32 {
	if valueB == 0 do return 0.0
	return (valueA / valueB) * 100.0
}

