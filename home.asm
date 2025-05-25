INCLUDE "rst.asm"
INCLUDE "interrupts.asm"

SECTION "High Home", ROM0
INCLUDE "home/highhome.asm"
INCLUDE "home/crash.asm"

	ds 1

SECTION "Version", ROM0
BuildNumber:: bigdw BUILD_NUMBER
VersionNumber::
	db VERSION_MAJOR
	db VERSION_MINOR

SECTION "Header", ROM0

Start::
	ldh [hCGB], a
	jr Init

	rept ($150 - $104)
		db $00 ; zero-filling the header for rgbfix, since it clashes with $ff padding otherwise
	endr

SECTION "Home", ROM0

INCLUDE "home/init.asm"

INCLUDE "home/predef.asm" ;keep close to farcall (within reach of jr)
INCLUDE "home/farcall.asm"

INCLUDE "home/array.asm"
INCLUDE "home/audio.asm"
INCLUDE "home/bankswitch.asm"
INCLUDE "home/battle.asm"
INCLUDE "home/copy.asm"
INCLUDE "home/count_events.asm"
INCLUDE "home/cry.asm"
INCLUDE "home/decompress.asm"
INCLUDE "home/ded.asm"
INCLUDE "home/delay.asm"
INCLUDE "home/fade.asm"
INCLUDE "home/flag.asm"
INCLUDE "home/game_time.asm"
INCLUDE "home/get_names.asm"
INCLUDE "home/handshake.asm"
INCLUDE "home/hp_pal.asm"
INCLUDE "home/item.asm"
INCLUDE "home/joypad.asm"
INCLUDE "home/jumptable.asm"
INCLUDE "home/lcd.asm"
INCLUDE "home/map.asm"
INCLUDE "home/map_objects.asm"
INCLUDE "home/math.asm"
INCLUDE "home/menu.asm"
INCLUDE "home/movement.asm"
INCLUDE "home/palettes.asm"
INCLUDE "home/pokedex_flags.asm"
INCLUDE "home/pokemon_data.asm"
INCLUDE "home/print_text.asm"
INCLUDE "home/random.asm"
INCLUDE "home/rtc.asm"
INCLUDE "home/screen.asm"
INCLUDE "home/scripting.asm"
INCLUDE "home/serial.asm"
INCLUDE "home/sine.asm"
INCLUDE "home/sprites.asm"
INCLUDE "home/stone_queue.asm"
INCLUDE "home/stopwatch.asm"
INCLUDE "home/string.asm"
INCLUDE "home/text.asm"
INCLUDE "home/tilemap.asm"
INCLUDE "home/time.asm"
INCLUDE "home/trainer.asm"
INCLUDE "home/vblank.asm"
INCLUDE "home/video.asm"
INCLUDE "home/vwf.asm"
INCLUDE "home/weekday.asm"
INCLUDE "home/window.asm"
