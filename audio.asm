INCLUDE "includes.asm"

SECTION "Audio", ROMX

INCLUDE "audio/engine.asm"

Music:
	dba Music_Nothing ;align line numbers with constants
INCLUDE "audio/music_pointers.asm"

INCLUDE "audio/music/nothing.asm"

IF !DEF(GBS)
; Tracks that play when a trainer engages in battle with you
INCLUDE "audio/trainer_encounters.asm"

Cries:
INCLUDE "audio/cry_pointers.asm"

SFX:
INCLUDE "audio/sfx_pointers.asm"
ENDC

SECTION "Songs 1", ROMX
INCLUDE "audio/music/dungeon/kalospowerplant.asm"
INCLUDE "audio/music/town/lilycovecity.asm"
INCLUDE "audio/music/battle/trainer/naljo.asm"

SECTION "Songs 2", ROMX
; linked, do not separate
INCLUDE "audio/music/battle/libhoennbattle.asm"
INCLUDE "audio/music/battle/wild/tunod.asm"
INCLUDE "audio/music/battle/trainer/tunod.asm"
; end of linked section

SECTION "Songs 3", ROMX
INCLUDE "audio/music/battle/gym/naljo.asm"
INCLUDE "audio/music/battle/wild/naljo.asm"
INCLUDE "audio/music/battle/boss/palette.asm"
INCLUDE "audio/music/battle/legendary/kanto.asm"
INCLUDE "audio/music/dungeon/clathritetunnel.asm"
INCLUDE "audio/music/battle/encounter/swimmerf.asm"
INCLUDE "audio/music/battle/legendary/hooh.asm"
INCLUDE "audio/music/battle/legendary/lugia.asm"
INCLUDE "audio/music/dungeon/silphco.asm"
INCLUDE "audio/music/route/route36.asm"
INCLUDE "audio/music/credits.asm"
INCLUDE "audio/music/postcredits.asm"
INCLUDE "audio/music/route/route30.asm"

SECTION "Songs 4", ROMX
INCLUDE "audio/music/route/route203.asm"
INCLUDE "audio/music/route/route209.asm"
INCLUDE "audio/music/route/route210.asm"
INCLUDE "audio/music/route/route216.asm"
INCLUDE "audio/music/dungeon/eternaforest.asm"
INCLUDE "audio/music/location/shop/johto.asm"
INCLUDE "audio/music/location/gym/kanto.asm"
INCLUDE "audio/music/dungeon/espoforest.asm"

SECTION "Songs 5", ROMX
INCLUDE "audio/music/battle/boss/rival.asm"
INCLUDE "audio/music/battle/boss/rocket.asm"
INCLUDE "audio/music/location/elmslab.asm"
INCLUDE "audio/music/dungeon/darkcave.asm"
INCLUDE "audio/music/battle/gym/johto.asm"
INCLUDE "audio/music/battle/boss/champion.asm"
INCLUDE "audio/music/location/ssaqua.asm"
INCLUDE "audio/music/town/newbarktown.asm"
INCLUDE "audio/music/town/goldenrodcity.asm"
INCLUDE "audio/music/town/vermilioncity.asm"
INCLUDE "audio/music/titlescreen.asm"
INCLUDE "audio/music/location/gym/heath.asm"
INCLUDE "audio/music/battle/encounter/pokemaniac.asm"

SECTION "Songs 6", ROMX
INCLUDE "audio/music/route/route1.asm"
INCLUDE "audio/music/route/route3.asm"
INCLUDE "audio/music/battle/gym/rijon.asm"
INCLUDE "audio/music/battle/trainer/rijon.asm"
INCLUDE "audio/music/battle/wild/rijon.asm"
INCLUDE "audio/music/location/pokecenter/johto.asm"
INCLUDE "audio/music/battle/encounter/twins.asm"
INCLUDE "audio/music/battle/encounter/officer.asm"
INCLUDE "audio/music/route/route2.asm"
INCLUDE "audio/music/dungeon/mtmoon.asm"
INCLUDE "audio/music/location/gamecorner.asm"
INCLUDE "audio/music/battle/encounter/sage.asm"
INCLUDE "audio/music/dungeon/lighthouse.asm"
INCLUDE "audio/music/town/rijonleague.asm"
INCLUDE "audio/music/route/route37.asm"
INCLUDE "audio/music/dungeon/rockethideout.asm"
INCLUDE "audio/music/dungeon/miloscatacombs.asm"
INCLUDE "audio/music/battle/encounter/beauty.asm"
INCLUDE "audio/music/route/route26.asm"
INCLUDE "audio/music/town/ecruteakcity.asm"
INCLUDE "audio/music/location/magnettrain.asm"
INCLUDE "audio/music/town/lavendertown.asm"
INCLUDE "audio/music/location/dancinghall.asm"
INCLUDE "audio/music/town/oreburghcity.asm"
INCLUDE "audio/music/location/pokecenter/kanto.asm"

SECTION "Songs 7", ROMX
INCLUDE "audio/music/dungeon/mtmoonsquare.asm"
INCLUDE "audio/music/location/gym/johto.asm"
INCLUDE "audio/music/town/pallettown.asm"
INCLUDE "audio/music/battle/encounter/rival.asm"
INCLUDE "audio/music/surf.asm"
INCLUDE "audio/music/location/nationalpark.asm"
INCLUDE "audio/music/town/azaleatown.asm"
INCLUDE "audio/music/town/cherrygrovecity.asm"
INCLUDE "audio/music/dungeon/unioncave.asm"
INCLUDE "audio/music/battle/encounter/youngster.asm"
INCLUDE "audio/music/battle/encounter/hiker.asm"
INCLUDE "audio/music/route/seviisouth.asm"

SECTION "Songs 8", ROMX
INCLUDE "audio/music/bicycle.asm"
INCLUDE "audio/music/battle/wild/johto.asm"
INCLUDE "audio/music/battle/trainer/johto.asm"
INCLUDE "audio/music/dungeon/sprouttower.asm"
INCLUDE "audio/music/dungeon/burnedtower.asm"
INCLUDE "audio/music/mom.asm"
INCLUDE "audio/music/dungeon/victoryroad.asm"
INCLUDE "audio/music/battle/librocket.asm"
INCLUDE "audio/music/battle/encounter/rocket.asm"
INCLUDE "audio/music/battle/encounter/kimonogirl.asm"
INCLUDE "audio/music/location/bugcatchingcontest.asm"
INCLUDE "audio/music/battle/encounter/mysticalman.asm"
INCLUDE "audio/music/battle/legendary/suicune.asm"
INCLUDE "audio/music/location/battletower/battleroom.asm"
INCLUDE "audio/music/location/battletower/lobby.asm"
INCLUDE "audio/music/location/pokecenter/naljo.asm"
INCLUDE "audio/music/town/ceruleancity.asm"
INCLUDE "audio/music/town/cinnabarisland.asm"

SECTION "Songs 9", ROMX
INCLUDE "audio/music/battle/trainer/kanto.asm"
INCLUDE "audio/music/battle/gym/kanto.asm"
INCLUDE "audio/music/battle/victory/gymleader.asm"
INCLUDE "audio/music/route/unovaroute4.asm"
INCLUDE "audio/music/route/route47.asm"
INCLUDE "audio/music/route/route119.asm"
INCLUDE "audio/music/town/evergrandecity.asm"
INCLUDE "audio/music/town/petalburgcity.asm"
INCLUDE "audio/music/town/oldaletown.asm"
INCLUDE "audio/music/town/anvilletown.asm"
INCLUDE "audio/music/town/lentimastown.asm"
INCLUDE "audio/music/town/slateportcity.asm"
INCLUDE "audio/music/location/gym/hoenn.asm"
INCLUDE "audio/music/battle/gym/tunod.asm"

SECTION "Songs 10", ROMX
INCLUDE "audio/music/location/pokecenter/hoenn.asm"
INCLUDE "audio/music/route/route104.asm"
INCLUDE "audio/music/location/shop/hoenn.asm"
INCLUDE "audio/music/battle/wild/sevii.asm"
INCLUDE "audio/music/dungeon/mtember.asm"
INCLUDE "audio/music/route/kindleroad.asm"
INCLUDE "audio/music/dungeon/farawayisland.asm"
INCLUDE "audio/music/town/indigoplateau.asm"
INCLUDE "audio/music/battle/encounter/magma.asm"
INCLUDE "audio/music/battle/boss/magma.asm"
INCLUDE "audio/music/battle/boss/worldchampion.asm"
INCLUDE "audio/music/battle/boss/hoennchampion.asm"
INCLUDE "audio/music/battle/trainer/sevii.asm"
INCLUDE "audio/music/route/route120.asm"

SECTION "Songs small 1", ROMX
INCLUDE "audio/music/battle/encounter/tough.asm"
INCLUDE "audio/music/battle/victory/trainer.asm"

SECTION "Songs small 2", ROMX
INCLUDE "audio/music/halloffame.asm"

SECTION "Songs small 3", ROMX
INCLUDE "audio/music/evolution.asm"
INCLUDE "audio/music/printer.asm"
INCLUDE "audio/music/location/dreamsequence.asm"

SECTION "Songs small 4", ROMX
INCLUDE "audio/music/battle/encounter/dubious.asm"

SECTION "Songs small 5", ROMX
INCLUDE "audio/music/dungeon/saxifrageprison.asm"

SECTION "Songs small 6", ROMX
INCLUDE "audio/music/battle/trainer/battlearcade.asm"
INCLUDE "audio/music/mobileadapter.asm"

SECTION "Songs small 7", ROMX
INCLUDE "audio/music/location/battlearcade.asm"
INCLUDE "audio/music/battle/boss/towertycoon.asm"

SECTION "Songs small 8", ROMX
INCLUDE "audio/music/dungeon/hauntedforest.asm"

SECTION "Songs small 9", ROMX
INCLUDE "audio/music/route/route25.asm"
INCLUDE "audio/music/town/viridiancityRBY.asm"

SECTION "Songs small 10", ROMX
INCLUDE "audio/music/town/viridiancity.asm"
INCLUDE "audio/music/town/celadoncity.asm"
INCLUDE "audio/music/battle/victory/wild.asm"

SECTION "Songs small 11", ROMX
INCLUDE "audio/music/location/gym/naljo.asm"

SECTION "Songs small 12", ROMX
INCLUDE "audio/music/battle/legendary/hoenn.asm"

SECTION "Songs small 13", ROMX
INCLUDE "audio/music/dungeon/tintower.asm"

SECTION "Songs small 14", ROMX
INCLUDE "audio/music/battle/encounter/lass.asm"

IF !DEF(GBS)
SECTION "Sound Effects 1", ROMX
INCLUDE "audio/sfx.asm"
INCLUDE "audio/sfx_crystal.asm"

SECTION "Sound Effects 2", ROMX
INCLUDE "audio/prismsfx.asm"

SECTION "Cries", ROMX

CryHeaders:: INCLUDE "audio/cry_headers.asm"

INCLUDE "audio/cries.asm"

SECTION "DED", ROMX
INCLUDE "audio/ded.asm"

INCLUDE "audio/ded/files.asm"
ENDC
