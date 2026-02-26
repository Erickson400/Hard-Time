# Hard-Time
Modern source port of the 2007 prison sim game Hard Time by MDickie.
Ported using Odin + SDL3 to recreate the classic Blitz3D API.

### Goals
Make the game's source and assets readily available for fans and modders. Preserving it for decades to come. 

The project has phases. The current phase is to make a literal translation from BlitzBasic to Odin. Next phase is to create the Blitz3D API with SDL3 and make it run. The final phase will be to refactor the code and rewrite it to be shorter and optimized for quality of life features. 

### Source Translation Checklist as of Feb 26, 2026
| Script name     | Last time checked | Accuracy | BB Line Count |
|-----------------|-------------------|----------|---------------|
| Text.bb         | Feb 13, 2026      | 10/10    | 460           |
| Values.bb       | Dec 12, 2025      | 10/10    | 1157          |
| Data.bb         | Feb 15, 2026      | 10/10    | 774           |
| Functions.bb    | Feb 16, 2026      | 10/10    | 289           |
| Menus.bb        | Feb 18, 2026      | 10/10    | 731           |
| Editor.bb       | Feb 19, 2026      | 10/10    | 702           |
| World.bb        | Feb 21, 2026      | 10/10    | 1172          |
| Weapons.bb      | Feb 22, 2026      | 10/10    | 625           |
| Particles.bb    | Feb 23, 2026      | 10/10    | 367           |
| Players.bb      | Feb 23, 2026      | 10/10    | 635           |
| Anims.bb        | Feb 25, 2026      | 10/10    | 2055          |
| Moves.bb        | Feb 26, 2026      | 9/10     | 482           |
| AI.bb           |     .., 2026      | ./10     | 1094          |
| Promos.bb       |     .., 2026      | ./10     | 4890          |
| Crimes.bb       |     .., 2026      | ./10     | 1384          |
| Missions.bb     |     .., 2026      | ./10     | 941           |
| Credits.bb      |     .., 2026      | ./10     | 752           |
| Gameplay.bb     |     .., 2026      | ./10     | 899           |

**46.20%** of lines translated, **49.09%** of those lines are functionally accurate.

Copilot was used to help with the repetitive copy pasting.

### Blitz3D API status
There're only placeholder functions without implementations - for building without compile errors.
Check the `todo_API.txt` file for the API functions that Hard Time uses.