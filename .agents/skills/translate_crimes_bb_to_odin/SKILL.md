---
name: translate_crimes_bb_to_odin
description: Instructions for translating BlitzBasic Crimes.bb (Court Case) into Odin code. Focuses on the CourtCase function and its many conditional scenarios.
---

# Translating Crimes.bb to Odin
When translating the `CourtCase` function and related logic from `Crimes.bb` to Odin, follow these specific guidelines:

## General
- CellName is not in bb.
- weapName is not in bb.
- PlaySound is part of bb
- `gamMoney[slot] = gamMoney[slot] - promoCash` -> `gamMoney[slot] -= promoCash`

## Function Structure
`Crimes.bb` is primarily one large function. In Odin, wrap the entire logic in `CourtCase :: proc()`.

## Variable Conversions
- `pChar(cyc)` -> `pChar[cyc]` (Use square brackets for arrays/slices).
- `camX#`, `pX#(1)` -> `camX`, `pX[1]` (Remove `#` suffix for floats).
- `sentence$` -> `sentence` (Remove `$` suffix for strings).
- `gamMoney(slot)` -> `gamMoney[slot]` (Many global state variables are arrays).

## Common Crimes.bb Functions
These functions are available in the `main` package or `bb` package:
- `Outline(text, x, y, r1, g1, b1, r2, g2, b2)` -> `Outline(text, x, y, r1, g1, b1, r2, g2, b2)`
- `Speak(char, expression)` -> `Speak(char, expression)`
- `Dig$(val, 10)` -> `Dig(val, 10)`
- `CellName$(...)` -> `bb.CellName(...)`
- `DescribeLimb$(...)` -> `bb.DescribeLimb(...)`
- `weapName$(...)` -> `bb.weapName[...]` (Likely an array access).
- `textCrime$(...)` -> `bb.textCrime[...]` (Likely an array access).
- `rX#(val)` -> `rX(val)`
- `rY#(val)` -> `rY(val)`
- `PercentOf#(val, pct)` -> `PercentOf(val, pct)`
- `Lower$(str)` -> `bb.Lower(str)`

## String Formatting (Crucial)
`Crimes.bb` uses many concatenated strings in `Outline` calls. Use `fmt.tprint` for these:
- `Outline("Prisoner " + CellName$(pChar(1)), ...)` -> `Outline(fmt.tprint("Prisoner", bb.CellName(pChar[1])), ...)`
- Use `strings.clone(str)` when assigning a temporary string to a persistent variable if it needs to outlive the frame (though usually not needed within `CourtCase` for local labels).

## Main Loop
The `While go=0` loop translates to `for go == 0`.
- Inside the loop, `WaitTimer(timer)` maps to `bb.WaitTimer(timer)`.
- Use `for framer in 1 ..= frames` for the inner frame loop.

## Conditional Blocks
`Crimes.bb` has many `If gamWarrant(slot)=X` blocks.
- `If cond Then statement` -> `if cond do statement`
- `If cond { ... }` for multi-line blocks.
- `And` -> `&&`, `Or` -> `||`, `=` -> `==`, `<>` -> `!=`.
- Do not add space between the equal sign in for loops
- Do not add spaces between lines

## BlitzBasic to Odin Mapping (Specific)
- `Rnd(0.1, 0.3)` -> `bb.RndF(0.1, 0.3)`
- `Rnd(1, 14)` -> `bb.RndI(1, 14)`
- `EntityTexture FindChild(world,"Crowd"+Dig$(count,10)),tCrowd,Rnd(0,3)` -> `bb.EntityTexture(bb.FindChild(world, fmt.tprint("Crowd", Dig(count, 10))), tCrowd, 0, bb.RndI(0, 3))`
- `PositionEntity p(cyc),pX#(cyc),pY#(cyc),pZ#(cyc)` -> `bb.PositionEntity(p[cyc], pX[cyc], pY[cyc], pZ[cyc])`
- `rX(400)` -> `i32(rX(400))`
