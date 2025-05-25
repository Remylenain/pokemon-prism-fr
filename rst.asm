SECTION "RSTs", ROM0

	assert @ == 0 ; rst $00
NULL::
	di
	ldh [hCrashSavedA], a
	ld a, 0 ; because xor a destroys f
	jp Crash

FarCall::
	jp StackFarCall

DrawBattleHPBar::
; Draw an HP bar d tiles long at hl
; Fill it up to e pixels
	jpba _DrawBattleHPBar

GenericDummyText::
	text ""
	done

GenericBankswitch::
	jp _GenericBankswitch

IsAPokemon::
; Return carry if species a is not a Pokemon.
; since every ID other than $00 and $FF is valid, we can simplify this function
IsValidID::
; check if an ID is not $00 or $FF; identical to IsAPokemon as long as all IDs $01-$FE are valid mons
	inc a
	cp 2
	dec a
	ret

AddNTimes::
	jp _AddNTimes

GetFarByteAndIncrement::
	call GetFarByte
	inc hl
GenericDummyFunction::
	ret

Predef::
	jp _Predef

BattleCommand_MoveDelay:
	ld c, 40
	jp DelayFrames

JumpTable::
	jp Jumptable

LoadStandardFont::
	jpba _LoadStandardFont

GenericDummyScript::
	end

CopyBytes::
	jp _CopyBytes

SetEnemyTurn::
	ld a, 1
	ldh [hBattleTurn], a
	ret

	assert @ == $38 ; rst $38
	di
	ldh [hCrashSavedA], a
	ld a, 1
	jp Crash
