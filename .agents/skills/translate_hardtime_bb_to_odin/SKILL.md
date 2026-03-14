---
name: translate_hardtime_promos_bb_to_odin
description: Instructions for translating BlitzBasic Hard-Time promos and events into Odin code. primarily using the copilot-temp.odin file as a workspace with commented blitz code.
---

# Translating BlitzBasic Promos to Odin
When translating the `Promos.bb` code snippet from BlitzBasic to Odin for the Hard-Time project, follow these general guidelines:

## General
- Do not add spaces between lines.
- Use Tab indentation.
- Do not run the program or fix lint errors.
- `charHappiness[pChar[v]] = charHappiness[pChar[v]] + 5` should be `charHappiness[pChar[v]] += 5`.

## Array Indexing
BlitzBasic uses parentheses for arrays, e.g., `gamMoney(slot)`.
Odin uses square brackets, e.g., `gamMoney[slot]`. Pay close attention to nested arrays like `charAngerTim(pChar(count),pChar(cyc))` -> `charAngerTim[pChar[count]][pChar[cyc]]`.

## String Concatenation and Formatting
BlitzBasic uses `+` for string concatenation: `"Hello " + name$`.
In Odin, use `fmt.tprint` and clone strings if they are assigned to `optionA` or `optionB`.
```odin
// BlitzBasic
optionA$="Yes, pay $"+GetFigure$(promoCash)+"..."

// Odin
figure := GetFigure(promoCash, context.temp_allocator)
optionA = strings.clone(fmt.tprint("Yes, pay $", figure, "..."))
```
When `fmt.tprint` result is passed directly to `Outline()`, cloning is not needed:
```odin
// BlitzBasic
Outline("Hey, "+charName$(pChar(v))+", i saw what you did!",rX#(400),rY#(520),30,30,30,250,250,250)

// Odin
Outline(fmt.tprint("Hey, ", charName[pChar[v]], ", i saw what you did!"), i32(rX(400)), i32(rY(520)), 30, 30, 30, 250, 250, 250)
```
Note the casting to `i32()` on coordinates when passing them to functions like `Outline()`.

## Function Changes
- Remove floating-point suffixes (`rX#` -> `rX`).
- Remove string-returning suffixes (`GetFigure$` -> `GetFigure`).
- `Rnd(1,14)` becomes `bb.RndI(1, 14)` for integers. `bb.RndF(1.0, 14.0)` for floats.
- `Lower$(str)` becomes `strings.to_lower(str, context.temp_allocator)`.
- `PlaySound sCash` becomes `bb.PlaySound(sCash)`.
- `StopChannel chAlarm` becomes `bb.StopChannel(chAlarm)`.
- `ChannelPlaying(chAlarm)` becomes `bb.ChannelPlaying(chAlarm)`.
- `CellName(pChar(v))` becomes `CellName(pChar[v], context.temp_allocator)`.

## Memory Allocation for Temporary Strings
Whenever dealing with BlitzBasic functions that returned temporary strings (like `GetFigure$`), pass `context.temp_allocator` when translating to Odin. Store these intermediate temporary strings if you are going to use them in a `fmt.tprint` to avoid nested allocator calls inside variadic functions:
```odin
figure := GetFigure(promoCash, context.temp_allocator)
Outline(fmt.tprint("may be willing to forget what i saw for $", figure, "?"), ...)
```

## Loops
BlitzBasic `For count=1 To no_plays` translates to Odin `for count in 1..=no_plays`.
Repeat Until loops are just Odin infinite loops with a break condition at the end.

## Control Flow
BlitzBasic `If ... Then ... : ...`
Translate to Odin:
```odin
if condition {
    statement1
    statement2
}
```
Or for simple statements:
```odin
if condition do statement
```
