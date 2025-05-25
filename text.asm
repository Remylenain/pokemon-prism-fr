INCLUDE "includes.asm"

INCLUDE "text/common.asm"

SECTION "Pokedex Entries 001-064", ROMX
PokedexEntries1:: INCLUDE "data/pokedex/entries_1.asm"

SECTION "Pokedex Entries 065-254", ROMX
PokedexEntries2:: INCLUDE "data/pokedex/entries_2.asm"
PokedexEntries3:: INCLUDE "data/pokedex/entries_3.asm"
PokedexEntries4:: INCLUDE "data/pokedex/entries_4.asm"

SECTION "Standard Text", ROMX
INCLUDE "text/stdtext.asm"

SECTION "Judge Text", ROMX
INCLUDE "text/judge.asm"

SECTION "Battle Text", ROMX
INCLUDE "text/battle.asm"
