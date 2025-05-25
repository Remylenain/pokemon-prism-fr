PrintTempMonStats:
; Print wTempMon's stats at hl, with spacing bc.
	push bc
	push hl
	ld de, .StatNames
	call PlaceText
	pop hl
	pop bc
	add hl, bc
	ld bc, SCREEN_WIDTH
	ld de, wTempMonAttack
	add hl, bc
	lb bc, 2, 3
	call .PrintStat
	ld de, wTempMonDefense
	call .PrintStat
	ld de, wTempMonSpclAtk
	call .PrintStat
	ld de, wTempMonSpclDef
	call .PrintStat
	ld de, wTempMonSpeed
	jp PrintNum

.PrintStat:
	push hl
	call PrintNum
	pop hl
	ld de, SCREEN_WIDTH * 2
	add hl, de
	ret

.StatNames
	text "Attack"
	next "Defense"
	next "Sp. Atk"
	next "Sp. Def"
	next "Speed"
	done
