---
name: translate_bb_to_odin
description: Instructions for translating BlitzBasic (.bb) source files into Odin code. Focuses on translating variables, string formatting, common functions, loops, and conditional blocks.
---

# Translating BlitzBasic to Odin
When translating logic from any BlitzBasic (`.bb`) file to Odin, follow these general guidelines:

## General
- Compound assignments should be updated: `gamMoney[slot] = gamMoney[slot] - promoCash` -> `gamMoney[slot] -= promoCash`
- `PlaySound` and many standard game functions are accessible via the `bb` package.
- Some arrays or functions like `CellName` and `weapName` or `textCrime` are not in `bb` but rather in the application code context, so call them normally or access them via their array mapping.
- Pass the temp allocator to CellName and GetFigure.
- Do not use {} for one liners, use `do` instead if its for one statement, but for multiple statements use {} in multiple lines.

## Function Structure
BlitzBasic scripts often take the form of large blocks of imperative code or large subroutines. In Odin, wrap the entire corresponding logic in cleanly delimited procedures (e.g. `TranslateFunction :: proc()`). Ensure loops and labels are correctly scoped.

## Variable Conversions
- Arrays/Slices: `pChar(cyc)` -> `pChar[cyc]` (Use square brackets).
- Floats: `camX#`, `pX#(1)` -> `camX`, `pX[1]` (Remove `#` suffix for floats).
- Strings: `sentence$` -> `sentence` (Remove `$` suffix for strings).
- Global State: `gamMoney(slot)` -> `gamMoney[slot]` (Many global state variables are arrays).

## Common BlitzBasic Functions
These functions are typical in the BlitzBasic codebase and should be mapped similar to this (often using the `bb` namespace or the `main` package):
- `Outline(text, x, y, r1, g1, b1, r2, g2, b2)` -> `Outline(text, i32(x), i32(y), r1, g1, b1, r2, g2, b2)`
- `Speak(char, expression)` -> `Speak(char, expression)`
- `Dig$(val, 10)` -> `Dig(val, 10)`
- `CellName$(...)` -> `CellName(...)` or `CellName[...]` depending on context
- `DescribeLimb$(...)` -> `DescribeLimb(...)`
- `weapName$(...)` -> `weapName[...]`  (Often an array access)
- `textCrime$(...)` -> `textCrime[...]` (Often an array access)
- `rX#(val)` -> `i32(rX(val))`
- `rY#(val)` -> `i32(rY(val))`
- `PercentOf#(val, pct)` -> `PercentOf(val, pct)`
- `Lower$(str)` -> `bb.Lower(str)`

## String Formatting (Crucial)
BlitzBasic uses many concatenated strings where types are mixed (`"str" + val`). Use `fmt.tprint` for these in Odin:
- `Outline("Text " + Var$(index), ...)` -> `Outline(fmt.tprint("Text", Var(index)), ...)`
- Use `strings.clone(str)` when assigning a temporary string to a persistent variable if it needs to outlive the current frame.

## Loops & Timing
The `While go=0` loop translates to `for go == 0 {}`.
- Inside the loop, `WaitTimer(timer)` maps to `bb.WaitTimer(timer)`.
- `For framer = 1 To frames` -> `for framer in 1..=frames {}`.

## Conditional Blocks
- `If cond Then statement` -> `if cond do statement`
- `If cond { ... }` or `If cond` .. `EndIf` for multi-line blocks -> `if cond { ... }`.
- `And` -> `&&`
- `Or` -> `||`
- `=` -> `==`
- `<>` -> `!=`
- Do not add spaces between lines unless they're on the original file.

## BlitzBasic to Odin Mapping (Specific examples)
- `Rnd(0.1, 0.3)` -> `bb.RndF(0.1, 0.3)`
- `Rnd(1, 14)` -> `bb.RndI(1, 14)`
- `EntityTexture FindChild(world,"Crowd"+Dig$(count,10)),tCrowd,Rnd(0,3)` -> `bb.EntityTexture(bb.FindChild(world, fmt.tprint("Crowd", Dig(count, 10))), tCrowd, 0, bb.RndI(0, 3))`
- `PositionEntity p(cyc),pX#(cyc),pY#(cyc),pZ#(cyc)` -> `bb.PositionEntity(p[cyc], pX[cyc], pY[cyc], pZ[cyc])`
- `rX(400)` -> `i32(rX(400))`
