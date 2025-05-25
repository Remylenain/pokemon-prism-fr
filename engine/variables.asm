_GetVarAction::
	ld a, c
	cp NUM_VARS
	jr c, .valid
	xor a
.valid
	ld c, a
	ld b, 0
	ld hl, .VarActionTable
	add hl, bc
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld b, [hl]
	ld a, b
	and RETVAR_EXECUTE
	jp nz, _de_
	ld a, b
	and RETVAR_ADDR_DE
	ret nz
	ld a, [de]
	jp .loadstringbuffer2

.VarActionTable
; $00: copy [de] to wStringBuffer2
; $40: return address in de
; $80: call function
	dwb wStringBuffer2,                 RETVAR_STRBUF2
	dwb wPartyCount,                    RETVAR_STRBUF2
	dwb .BattleResult,                  RETVAR_EXECUTE
	dwb wBattleType,                    RETVAR_ADDR_DE
	dwb wTimeOfDay,                     RETVAR_STRBUF2
	dwb .CountCaughtMons,               RETVAR_EXECUTE
	dwb .CountSeenMons,                 RETVAR_EXECUTE
	dwb .CountBadges,                   RETVAR_EXECUTE
	dwb wPlayerState,                   RETVAR_ADDR_DE
	dwb .PlayerFacing,                  RETVAR_EXECUTE
	dwb hHours,                         RETVAR_STRBUF2
	dwb .DayOfWeek,                     RETVAR_EXECUTE
	dwb wMapGroup,                      RETVAR_STRBUF2
	dwb wMapNumber,                     RETVAR_STRBUF2
	dwb wPermission,                    RETVAR_STRBUF2
	dwb .BoxFreeSpace,                  RETVAR_EXECUTE
	dwb wXCoord,                        RETVAR_STRBUF2
	dwb wYCoord,                        RETVAR_STRBUF2
	dwb wRespawnableEventMonBaseIndex,  RETVAR_ADDR_DE

.CountCaughtMons
; Caught mons.
	ld hl, wPokedexCaught
	ld b, wEndPokedexCaught - wPokedexCaught
	jr .bits

.CountSeenMons
; Seen mons.
	ld hl, wPokedexSeen
	ld b, wEndPokedexSeen - wPokedexSeen
	jr .bits

.CountBadges
; Number of owned badges.
	ld hl, wBadges
	ld b, 3
.bits
	call CountSetBits
	ld a, [wd265]
	jr .loadstringbuffer2

.PlayerFacing
; The direction the player is facing.
	ld a, [wPlayerDirection]
	and $c
	rrca
	rrca
	jr .loadstringbuffer2

.DayOfWeek
; The day of the week.
	call GetWeekday
	jr .loadstringbuffer2

.BoxFreeSpace
; Remaining slots in the current box.
	sbk BANK(sBoxCount)
	ld hl, sBoxCount
	ld a, MONS_PER_BOX
	sub [hl]
	ld b, a
	scls
	ld a, b
	jr .loadstringbuffer2

.BattleResult
	ld a, [wBattleResult]
	and $3f
.loadstringbuffer2
	ld de, wStringBuffer2
	ld [de], a
	ret
