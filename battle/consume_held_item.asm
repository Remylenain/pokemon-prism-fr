ConsumeHeldItem:
	push hl
	push de
	push bc
	call .ConsumeHeldItem
	pop bc
	pop de
	pop hl
	ret

.ConsumeHeldItem:
	ldh a, [hBattleTurn]
	and a
	ld bc, wOTPartyMon1Item
	ld hl, wEnemyMonItem
	ld de, wEnemyAbility
	ld a, [wCurOTMon]
	jr z, .theirturn
	ld bc, wPartyMon1Item
	ld hl, wBattleMonItem
	ld de, wPlayerAbility
	ld a, [wCurBattleMon]

.theirturn
	push bc
	push af
	push hl
	call GetItemHeldEffect
	ld a, b
	ld hl, .ConsumableEffects
	call IsInSingularArray
	jr nc, .nonConsumable
	pop hl
	ld [hl], 0
	pop af
	pop hl
	push de
	call GetPartyLocation
	pop bc
	ldh a, [hBattleTurn]
	and a
	jr nz, .ourturn
	ld a, [wBattleMode]
	dec a
	ret z

.ourturn
	ld [hl], 0
	ret

.nonConsumable
	add sp, 6
	ret

.ConsumableEffects
; Consumable items?
	db HELD_BERRY
	db HELD_HEAL_POISON
	db HELD_HEAL_FREEZE
	db HELD_HEAL_BURN
	db HELD_HEAL_SLEEP
	db HELD_HEAL_PARALYZE
	db HELD_HEAL_STATUS
	db HELD_ESCAPE
	db HELD_CRITICAL_UP
	db HELD_POWER_HERB
	db $ff
