RepelWoreOffScript::
	opentext
	writetext .RepelsEffectWoreOffText
	sif false
		endtext
	yesorno
	sif true
		callasm DoItemEffect
	closetextend

.RepelsEffectWoreOffText
	; REPEL's effect wore off.
	text_far Text_RepelWoreOff
	start_asm
	xor a
	ldh [hScriptVar], a
	ld [wWhichIndexSet], a
	CheckEngine ENGINE_POKEMON_MODE
	jr nz, .nope
	ld a, [wLastRepelUsed]
	and a
	jr z, .nope
	ld [wCurItem], a
	ld hl, wNumItems
	call CheckItem
	jr nc, .nope
	ld a, 1
	ldh [hScriptVar], a
	ld hl, .UseAnotherText
	ret

.nope
	ld hl, .Terminator
	ret

.UseAnotherText:
	text_far UseAnotherRepelText
.Terminator
	db "@"
