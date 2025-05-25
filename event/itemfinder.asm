ItemfinderFunction:
	callba CheckForHiddenItems
	and a
	ld hl, .found
	jr z, .got_script_pointer
	dec a
	ld hl, .mapempty
	jr z, .got_script_pointer
	ld hl, .notfound
.got_script_pointer
	call QueueScript
	ld a, 1
	ld [wItemEffectSucceeded], a
	ret

.found
	reloadmappart
	special UpdateTimePals
	callasm .sound
	jumptext .found_text

.found_text
	ctxt "Yes! Item Finder"
	line "indicates there's"
	cont "an item nearby."
	prompt

.sound
	ld c, 4
.sfx_loop
	push bc
	ld de, SFX_SECOND_PART_OF_ITEMFINDER
	call WaitPlaySFX
	ld de, SFX_TRANSACTION
	call WaitPlaySFX
	pop bc
	dec c
	jr nz, .sfx_loop
	ret

.notfound
	reloadmappart
	special UpdateTimePals
	jumptext .notfound_text

.notfound_text
	ctxt "Nope! Item Finder"
	line "can't find any"
	cont "items nearby."
	prompt

.mapempty
	reloadmappart
	special UpdateTimePals
	jumptext .mapempty_text

.mapempty_text
	ctxt "Nope! Item Finder"
	line "can't find any"
	cont "items in the area."
	prompt
