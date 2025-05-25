SendOutPkmnText:
	CheckEngine ENGINE_POKEMON_MODE
	ret nz

	ld a, [wLinkMode]
	and a
	jr z, .not_linked

	ld hl, JumpText_GoPkmn ; If we're in a LinkBattle print just "Go <PlayerMon>"
	ld a, [wBattleHasJustStarted] ; unless we're in the middle of the battle
	and a
	jr nz, .skip_to_textbox

.not_linked
; Depending on the HP of the enemy Pkmn, the game prints a different text
	ld hl, wEnemyMonHP
	ld a, [hli]
	or [hl]
	ld hl, JumpText_GoPkmn
	jr z, .skip_to_textbox

	; compute enemy health remaining as a percentage
	xor a
	ldh [hMultiplicand], a
	ld hl, wEnemyMonHP
	ld a, [hli]
	ld [wEnemyHPAtTimeOfPlayerSwitch], a
	ldh [hMultiplicand + 1], a
	ld a, [hl]
	ld [wEnemyHPAtTimeOfPlayerSwitch + 1], a
	ldh [hMultiplicand + 2], a
	ld a, 100
	ldh [hMultiplier], a
	predef Multiply
	ld hl, wEnemyMonMaxHP
	ld a, [hli]
	ldh [hDivisor], a
	ld a, [hl]
	ldh [hDivisor + 1], a
	predef DivideLong

	ldh a, [hLongQuotient + 3]
	ld hl, JumpText_GoPkmn
	cp 70
	jr nc, .skip_to_textbox

	ld hl, JumpText_DoItPkmn
	cp 40
	jr nc, .skip_to_textbox

	ld hl, JumpText_GoForItPkmn
	cp 10
	jr nc, .skip_to_textbox

	ld hl, JumpText_YourFoesWeakGetmPkmn
.skip_to_textbox
	jp BattleTextBox

WithdrawPkmnText:
	ld hl, .text
	jp BattleTextBox

.text
	text_far Text_BattleMonNickComma
	start_asm
; Print text to withdraw Pkmn
; depending on HP the message is different
	push de
	push bc
	ld hl, wEnemyMonHP + 1
	ld de, wEnemyHPAtTimeOfPlayerSwitch + 1
	ld b, [hl]
	dec hl
	ld a, [de]
	sub b
	ldh [hMultiplicand + 2], a
	dec de
	ld b, [hl]
	ld a, [de]
	sbc b
	ldh [hMultiplicand + 1], a
	sbc a ; sign-extend the value, so negative numbers give a huge result
	ldh [hMultiplicand], a
	ld a, 100
	ldh [hMultiplier], a
	predef Multiply
	ld a, [hli]
	ldh [hDivisor], a
	ld a, [hl]
	ldh [hDivisor + 1], a
	predef DivideLong
	pop bc
	pop de
	ldh a, [hLongQuotient + 2] ; negative differences give huge results when dividing, that overflow one byte
	ld hl, TextJump_ThatsEnoughComeBack
	and a
	ret nz
	ldh a, [hLongQuotient + 3]
	and a
	ret z

	ld hl, TextJump_ComeBack
	cp 30
	ret c

	ld hl, TextJump_OKComeBack
	cp 70
	ret c

	ld hl, TextJump_GoodComeBack
	ret

GetEnemyFaintedText:
	ld hl, BattleText_EnemyPkmnFainted
	ld a, [wBattleMode]
	dec a
	ret nz
	ld hl, BattleText_WildPkmnFainted
	ret

EmptyBattleTextBox:
	ld hl, GenericDummyString
	jp BattleTextBox

Function_BattleTextEnemySentOut:
	callba Battle_GetTrainerName
	ld hl, BattleText_EnemySentOut
	call StdBattleTextBox
	jp ApplyTilemapInVBlank
