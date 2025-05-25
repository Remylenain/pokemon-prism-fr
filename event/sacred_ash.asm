_SacredAsh:
	xor a
	ld [wItemEffectSucceeded], a
	call CheckAnyFaintedMon
	ret nc

	ld hl, SacredAshScript
	call QueueScript
	ld a, 1
	ld [wItemEffectSucceeded], a
	ret

CheckAnyFaintedMon:
	ld de, PARTYMON_STRUCT_LENGTH
	ld bc, wPartySpecies
	ld hl, wPartyMon1HP
	ld a, [wPartyCount]
	and a
	ret z

.loop
	push af
	push hl
	ld a, [bc]
	inc bc
	cp EGG
	jr z, .next

	ld a, [hli]
	or [hl]
	jr z, .done

.next
	pop hl
	add hl, de
	pop af
	dec a
	jr nz, .loop
	xor a
	ret

.done
	pop hl
	pop af
	scf
	ret

SacredAshScript:
	special HealParty
	reloadmappart
	playsound SFX_WARP_TO
	rept 3
		special FadeOutPalettes
		special FadeInPalettes
	endr
	waitsfx
	farwritetext SacredAshText
	playwaitsfx SFX_CAUGHT_MON
	endtext
