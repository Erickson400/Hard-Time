# Hard-Time
Modern source port of the 2007 prison sim game Hard Time by MDickie.
Ported using Odin + SDL3 to recreate the classic Blitz3D API.

### Goals
Make the game's source and assets readily available for fans and modders. Preserving it for decades to come.

The project has phases. The current phase is to make a functional translation from BlitzBasic to Odin. Next phase is to create the Blitz3D API with SDL3 and make it run. The final phase will be to refactor the code and rewrite it to be shorter and optimized for quality of life features.

### Source Translation Checklist as of Mar 6, 2026
| Script name     | Last time checked | Accuracy | BB Line Count |
|-----------------|-------------------|----------|---------------|
| Text.bb         | Feb 13, 2026      | 10/10    | 460           |
| Values.bb       | Feb 20, 2026      | 10/10    | 1157          |
| Data.bb         | Feb 15, 2026      | 10/10    | 774           |
| Functions.bb    | Feb 16, 2026      | 10/10    | 289           |
| Menus.bb        | Feb 18, 2026      | 10/10    | 731           |
| Editor.bb       | Feb 19, 2026      | 10/10    | 702           |
| World.bb        | Feb 21, 2026      | 10/10    | 1172          |
| Weapons.bb      | Feb 22, 2026      | 10/10    | 625           |
| Particles.bb    | Feb 23, 2026      | 10/10    | 367           |
| Players.bb      | Feb 23, 2026      | 10/10    | 635           |
| Anims.bb        | Feb 25, 2026      | 10/10    | 2055          |
| Moves.bb        | Mar 16, 2026      | 10/10    | 482           |
| AI.bb           | Mar 20, 2026      | 10/10    | 1094          |
| Promos.bb       | Mar 16, 2026      |  8/10    | 4890          |
| Crimes.bb       | Apr 16, 2026      | 10/10    | 1384          |
| Missions.bb     | Apr 13, 2026      | 10/10    | 941           |
| Credits.bb      | Apr 16, 2026      | 10/10    | 752           |
| Gameplay.bb     | Apr 20, 2026      | 10/10    | 899           |

Copilot and Antigravity were used to help with the first translation pass. Then a second or third manual read is done line by line to confirm the code is accurate. The Accuracy column is how confident I am that the code is functionaly accurate to the original.

### Blitz3D API status
There're only placeholder functions without implementations - for building without compile errors.
Check the `todo_API.txt` file for the API functions that Hard Time uses.