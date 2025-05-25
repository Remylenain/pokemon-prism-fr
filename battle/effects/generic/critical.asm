BattleCommand_Critical:
; critical

; Determine whether this attack's hit will be critical.

	xor a
	ld [wCriticalHitOrOHKO], a

; Moves with no base power can never crit
	ld a, BATTLE_VARS_MOVE_POWER
	call GetBattleVar
	and a
	ret z

; Battle Armor prevents crits
	call GetTargetAbility
	cp ABILITY_BATTLE_ARMOR
	ret z

; Check held items that increase the crit level (stored in c)
	ldh a, [hBattleTurn]
	and a
	ld hl, wEnemyMonItem
	ld a, [wEnemyMonSpecies]
	jr nz, .Item
	ld hl, wBattleMonItem
	ld a, [wBattleMonSpecies]

.Item
	ld c, 0

	cp CHANSEY
	jr nz, .FocusEnergy
	ld a, [hl]
	cp LUCKY_PUNCH
	jr nz, .FocusEnergy

; +2 critical level
	ld c, 2

.FocusEnergy
; Focus Energy increases the crit level
	ld a, BATTLE_VARS_SUBSTATUS4
	call GetBattleVar
	bit SUBSTATUS_FOCUS_ENERGY, a
	jr z, .CheckCritical

; +2 critical level
	inc c
	inc c

.CheckCritical
	ld a, BATTLE_VARS_MOVE_ANIM
	call GetBattleVar
	ld hl, .Criticals
	push bc
	call IsInSingularArray
	pop bc
	jr nc, .ScopeLens

; +1 critical level
	inc c

.ScopeLens
	push bc
	call GetUserItem
	ld a, b
	cp HELD_CRITICAL_UP ; Increased critical chance. Only Scope Lens has this.
	pop bc
	jr nz, .SuperLuck

; +1 critical level
	inc c
.SuperLuck
	call GetUserAbility
	cp ABILITY_SUPER_LUCK
	jr nz, .Tally

; +1 critical level
	inc c
.Tally
	ld a, c
	cp 3
	jr nc, .always
	ld hl, .Chances
	ld b, 0
	add hl, bc
	call BattleRandom
	and [hl]
	ret nz
.always
	ld a, 1
	ld [wCriticalHitOrOHKO], a
	ret

.Criticals
	db KARATE_CHOP, RAZOR_LEAF, SLASH, AEROBLAST, CROSS_CHOP, SKY_ATTACK, SHADOW_CLAW, NIGHT_SLASH, PSYCHO_CUT, $ff
.Chances
	; chance for each critical level is 1 in 2^n, where n is the amount of set bits in the value below
	; using upper bits for slightly better randomness
	db $f0, $e0, $80 ;1/16 (6.25%), 1/8 (12.5%), 1/2 (50%)
