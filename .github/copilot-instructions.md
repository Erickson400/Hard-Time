# Hard-Time Copilot Instructions

## Project Overview
**Hard-Time** is a faithful port of the 2007 Blitz3D prison simulator to **Odin + SDL3**. The project is in Phase 1: literal translation from BlitzBasic (.bb) to Odin (.odin), preserving the original game logic while replacing the Blitz API with Odin equivalents.

Your job is to translate Blitz code to Odin as instructed. Here is some detail on the how the project is structured and how to translate.

## Architecture & Module Organization

### Execution Flow
1. `main.odin`: Entry point with memory tracking (debug), file logging, and context initialization
2. `init_values()`: Initializes global game variables (happens once, uses temp_alloc exception)
3. `entry_point()`: Placeholder gameplay loop (currently renders gray screen with raylib)

### Original Module Structure (Gameplay.bb)
The build preserves the original file inclusion order—critical for initialization:
```
Texts.bb → Values.bb → Data.bb → Functions.bb → Menus.bb → Editor.bb 
→ World.bb → Weapons.bb → Particles.bb → Players.bb → Anims.bb 
→ Moves.bb → AI.bb → Promos.bb → Crimes.bb → Missions.bb → Credits.bb
```
Each .odin module corresponds to its .bb file. Files with no `init_*` function only define procedures; they have no global code execution.

### Blitz3D API Implementation (src/blitzbasic3d/)
- **api.odin**: Public Blitz API signatures (PascalCase: `LoadImage()`, `PlaySound()`, etc.)
See `misc/todo_API.txt` for a clean list of unimplemented API functions.

## Naming & Code Style Conventions

### Core Rule: Context-Based Naming
- **Game source code (values.odin, data.odin, etc.)**: `PascalCase` – preserves original Blitz style
- **Blitz API public functions**: `PascalCase` (e.g., `LoadImage`, `PlaySound`)
- **Odin centered code**: standard Odin `snake_case`

### Formatting Requirements
All code must pass: `odin build ./src -o:none -debug -vet -vet-tabs -strict-style`
- Comment out unused variables/functions with `// Unused` marker. You can do this after compiling unused errors, instead of searching the entire codebase.
- No comments between `package` and `import` statements
- Import statements immediately after package declaration

## Translation Patterns from BlitzBasic

### Long if statements
- Use logical operands below the if keyword for lines longer than 100 characters.
```odin
if cond \
&& cond1 \
&& cond2 {
}
```
- Use the `do` keyword for one liner if statements that fit within 100 characters. This is similar to the Blitz `Then` command. If it gets too long then make it into a normal bracket if statement.

### Array Declarations
- BlitzBasic only has 3 datatypes. i32, f32, and string.
- Always assume the code uses i32 instead of the int type. Only use int for odin specific code.
- BlitzBasic `Dim value[9]` → Odin `value: [10]Type` (size is inclusive upper bound + 1)

### Function Definition
- Function argument types and return types should be known. # for f32, $ for strings, and none for i32.
- You can infer the returned type by looking at the variable being returned.

### Loops
- BlitzBasic `For cyc = 1 to 99` → Odin `for cyc in 1..=99`
- BlitzBasic Repeat-Until loops are just odin `for {}` but with a break if statement at the end.

### Type Conversions
- BlitzBasic non-bool if statements → cast i32 to bool in Odin. Unless the blitz code specifically says `=0`
- Example: `if i32_value do { ... }` → `if cast(bool)i32_value do { ... }`
- If a BlitzBasic variable is being set to a different type, then in odin - cast it to its corresponding type using i32() or f32().

### Random Numbers
- BlitzBasic `Rnd()` → replaced with `RndI()` (integer) or `RndF()` (float) depending on context

### String Handling
- **Ownership rule**: Caller retains ownership of strings—functions don't free or reassign them
- Functions expect strings to be valid only during the call; caller must manage lifetimes
- The Dig function is the only exception to having an allocator as an argument.
- If you see any strings being concatenated, make a local variable set to it, then delete the string after using it.
- Be careful with variables charName, gamName, and weapName. They might need their strings freed before reassigned.

### Memory Allocation
- **Hard Time game code**: use `context.allocator` for all allocations. Create a local arena allocator if calling delete becomes too numerous in the scope. 
- **Exception**: `init_values()` uses `temp_alloc` (one-time setup, deferred cleanup)
- Strings are the biggest leakers, read the above String Handling section for further info.

### File Paths
- **Blitz file functions** (bb.LoadImage, bb.WriteFile): paths are relative to `assets/` folder in the backend.
- **Odin OS calls** (os.open, etc.): must prepend `"assets/"` prefix

### Bug report
- If you find an inconsistancy in the blitz code, or code that does not translate well to Odin. Then make a comment above the code section saying `// NOTE: Likely a bug. ... Mat's intentions might've been to ...` and explain the problem. 
- E.g. Anything related to Blitz's local variable function scope feature. Like reusing a loop index after exiting the loop.

## Key Files & Examples

### Values.odin (1257 lines)
Defines all global game state: progress, character data, options. Demonstrates PascalCase variable naming.
```odin
screen: i32
//oldScreen: i32 // Unused
gamName: [4]string
gamPoints: i32
```

### Data.odin (877 lines)
Implements save/load for options and progress. Example of Blitz file API usage:
```odin
SaveProgress :: proc() {
    filepath := fmt.aprintf("Data/Slot0%d/Progress.dat", slot)
    defer delete(filepath)
    file := bb.WriteFile(filepath)  // assets-relative path
    bb.WriteInt(file, no_chars)
    bb.CloseFile(file)
}
```

### src/blitzbasic3d/api.odin (202 lines)
Public Blitz API wrapping internal implementations. All game code imports `bb "blitzbasic3d"`.

## Build & Debugging

### Build Command
```bash
odin build ./src -o:none -debug -vet -vet-tabs -strict-style
```
- `-o:none`: No optimizations (keeps debug info)
- `-vet`: Strict code validation
- `-strict-style`: Enforces naming conventions
Feel free to use the `-max-error-count:<integer>` flag to not overwhelm the context window.

### Logging & Memory Tracking
- File logs written to `logs.txt` (Info level in debug, Error in release)
- Debug builds track memory allocations; leaked memory reported on exit
- Enabled via `mem.Tracking_Allocator` in main.odin
- No need for logging on the blitz code. Logging will be used for the blitzbasic3d package only.

## Common Workflows

### Translating a New Module
1. Copy the original .bb file logic to a matching .odin file in `src/`
2. Use the translation patterns above (arrays, loops, types)
3. Replace `Rnd` with `RndI`/`RndF` and Blitz API calls with `bb.*`
4. Go through `todo_API.txt` and prepend those functions with bb. if they appear on the list. 
5. Name all game-level functions `PascalCase` to match originals
6. Run build; fix `-vet` and `-strict-style` issues

### Adding New Blitz API Functions
- Do not add or modify the blitzbasic3d package. If there is an error of an unexisting bltizbasic3d function, then let me know.

### Debugging Translation Accuracy
- Compare original Blitz output with Odin output side-by-side
- Check assignment patterns, loop bounds, and type conversions carefully
- Use `-vet` output to catch unused variables (may indicate missed logic)

## Current State & Blockers
- **Gameplay loop**: Currently a placeholder raylib render loop; needs full Blitz3D API before game logic executes
- **Missing implementations**: ~100+ Blitz API functions still placeholders (see `todo_API.txt`)
- **Next phase**: Implement SDL3-based graphics/audio to replace raylib placeholder

## When Unsure
- **How big is this task?** Check line counts in README.md (e.g., Promos.bb = 4890 lines). If one function is too long then translate in chunks of 300 lines.
- **What's the original logic?** Find the corresponding .bb file in `original_hardtime_source_code/`
