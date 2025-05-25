Special_SpurgeMartBank:
	ldh a, [hInMenu]
	push af
	ld a, 1
	ldh [hInMenu], a
	ld hl, .welcome_text
	call PrintText
	call SpurgeBank_CheckIfBankInitialized
	call SpurgeBank_AccessBank
	ld hl, .logout_text
	call PrintText
	pop af
	ldh [hInMenu], a
	ret

.welcome_text
	ctxt "Welcome to the"
	line "Spurge Bank ATM."
	prompt

.logout_text
	ctxt "Logging out<...>"
	done

SpurgeBank_CheckIfBankInitialized:
	ld hl, wBankSavingMoney
	bit 7, [hl]
	set 7, [hl]
	ret nz
	ld hl, .explanation
	call PrintText
	call EnableOrDisableDirectDepositing
	ld hl, .created
	call PrintText
	ld de, SFX_SAVE
	jp PlayWaitSFX

.explanation
	ctxt "We offer direct"
	line "deposit of battle"
	cont "winnings."

	para "If enabled, up to"
	line "25 percent of the"
	para "money you win in"
	line "battle will be"
	para "automatically sent"
	line "to your account."

	para "But first, let's"
	line "set up an account."

	para "Would you like to"
	line "enable direct"
	para "deposit for your"
	line "account?"
	done

.created
	ctxt "Your account has"
	line "been created."
	prompt

SpurgeBank_AccessBank:
	ld hl, .prompt_text
	call PrintText
	ld hl, SpurgeBankMenuHeader
	call LoadMenuHeader
	call VerticalMenu
	call CloseWindow
	ret c
	ld a, [wMenuCursorY]
	cp 4
	ret nc
	dec a
	jr z, .deposit
	dec a
	jr z, .withdraw
	ld hl, .enable_direct_deposit_text
	call PrintText
	call EnableOrDisableDirectDepositing
	jr SpurgeBank_AccessBank

.deposit
	call SpurgeBank_DepositMoney
	jr .continue

.withdraw
	call SpurgeBank_WithdrawMoney
.continue
	ld hl, .cancelled_text
	jp nc, PrintText
	ld hl, .completed_text
	call PrintText
	ld de, SFX_TRANSACTION
	call PlayWaitSFX
	jr SpurgeBank_AccessBank

.prompt_text
	ctxt "What would you"
	line "like to do?"
	done

.enable_direct_deposit_text
	ctxt "Do you want to"
	line "enable direct"
	cont "depositing?"
	done

.completed_text
	ctxt "Transaction"
	line "completed."
	done

.cancelled_text
	ctxt "Transaction"
	line "cancelled."
	prompt

SpurgeBankMenuHeader:
	db $40 ; flags
	db 00, 00 ; start coords
	db 09, 10 ; end coords
	dw .MenuData2
	db 1 ; default option

.MenuData2:
	db $80 ; flags
	db 4 ; items
SpurgeBank_DepositString:
	db "Deposit@"
SpurgeBank_WithdrawString:
	db "Withdraw@"
	db "Change@"
	db "Cancel@"

SpurgeBank_DepositMoney:
	ld hl, wBankMoney + 2
	ld bc, wMoney
	call SpurgeBank_Compare999999MinusHLAndBC
	ld de, SpurgeBank_DepositString
	ld hl, .howmuch
	ld bc, .zero
	call SpurgeBank_DoBankInterface
	; end of function

	ld de, wMoney
	ld bc, wStringBuffer2
	callba CompareMoney
	ld hl, .notenough
	ret c
	call BackupSpurgeBankHandledMoney
	ld bc, wBankMoney
	ld de, wStringBuffer2
	callba GiveMoney
	ld hl, .toomuch
	jr c, SpurgeBank_RestoreBackupMoney
	ld de, wMoney
	ld bc, wBankMoney
	and a
	ret

.howmuch
	ctxt "How much do you"
	line "want to deposit?"
	done

.zero
	ctxt "You can't deposit"
	line "nothing."
	prompt

.notenough
	ctxt "You don't have"
	line "enough money."
	prompt

.toomuch
	ctxt "The amount would"
	line "exceed your bank"
	cont "account's limit."
	prompt

SpurgeBank_RestoreBackupMoney:
	push hl
	ld hl, wStringBuffer2 + 3
	ld de, wStringBuffer2
	ld bc, 3
	rst CopyBytes
	pop hl
	ret

SpurgeBank_WithdrawMoney:
	ld hl, wMoney + 2
	ld bc, wBankMoney
	call SpurgeBank_Compare999999MinusHLAndBC
	ld de, SpurgeBank_WithdrawString
	ld hl, .howmuch
	ld bc, .zero
	call SpurgeBank_DoBankInterface
	; end of function

	call BackupSpurgeBankHandledMoney
	ld de, wBankMoney
	ld bc, wStringBuffer2
	callba CompareMoney
	ld hl, .notenough
	jr c, SpurgeBank_RestoreBackupMoney
	ld bc, wMoney
	ld de, wStringBuffer2
	callba GiveMoney
	ld hl, .toomuch
	ret c
	ld de, wBankMoney
	ld bc, wMoney
	and a
	ret

.howmuch
	ctxt "How much do you"
	line "want to withdraw?"
	done

.zero
	ctxt "You can't withdraw"
	line "nothing."
	prompt

.notenough
	ctxt "You don't have"
	line "enough money in"
	cont "your account."
	prompt

.toomuch
	ctxt "You can't hold that"
	line "much money in your"
	cont "wallet."
	prompt

SpurgeBank_Compare999999MinusHLAndBC:
	ld de, wStringBuffer2 + 8
	push de
	ld a, 9999999 % $100
	sub [hl]
	ld [de], a
	dec de
	dec hl
	ld a, (9999999 / $100) % $100
	sbc [hl]
	ld [de], a
	dec de
	dec hl
	ld a, 9999999 / $10000
	sbc [hl]
	ld [de], a
	ld h, b
	ld l, c
	ld bc, 3
	push hl
	push bc
	call StringCmp
	pop bc
	pop hl
	pop de
	ret c
	ret z
	rst CopyBytes
	ret

BackupSpurgeBankHandledMoney:
	ld hl, wStringBuffer2
	ld de, wStringBuffer2 + 3
	ld bc, 3
	rst CopyBytes
	ret

EnableOrDisableDirectDepositing:
	call YesNoBox
	ld hl, wBankSavingMoney
	jr c, .disable
	ld de, .en
	set 0, [hl]
	jr .print

.disable
	ld de, .dis
	res 0, [hl]
.print
	push af
	call CopyName1
	ld hl, .status_change_text
	call PrintText
	pop af
	ret c
	ld hl, .explanation
	jp PrintText

.dis
	db "dis@"
.en
	db "en@"

.status_change_text
	ctxt "Direct depositing"
	line "has been <STRBF2>abled."
	prompt

.explanation
	ctxt "25 percent of the"
	line "money you earn in"
	para "battles will be"
	line "automatically"
	cont "deposited."
	prompt

SpurgeBank_DoBankInterface:
	push bc
	push hl
	push de
	xor a
	ld hl, wStringBuffer2
	ld [hli], a
	ld [hli], a
	ld [hl], a
	ld a, 6
	ld [wMomBankDigitCursorPosition], a
	ld hl, BankInterfacePseudoMenuHeader
	call LoadMenuHeader
	xor a
	ldh [hBGMapMode], a
	hlcoord 0, 0
	lb bc, 6, 18
	call TextBox
	hlcoord 1, 2
	ld de, .SavedString
	call PlaceText
	hlcoord 11, 2
	ld de, wBankMoney
	lb bc, PRINTNUM_MONEY | 3, 7
	call PrintNum
	hlcoord 1, 4
	ld de, .HeldString
	call PlaceText
	hlcoord 11, 4
	ld de, wMoney
	lb bc, PRINTNUM_MONEY | 3, 7
	call PrintNum
	pop de
	hlcoord 1, 6
	call PlaceString
	hlcoord 11, 6
	ld de, wStringBuffer2
	lb bc, PRINTNUM_MONEY | PRINTNUM_LEADINGZEROS | 3, 7
	call PrintNum
	call ApplyTilemap
	call UpdateSprites
	pop hl
	pop bc
	pop de
.loop
	push bc
	push hl
	push de
	call PrintInstantText
	call BankJoypadLoop
	jr c, .cancel
	ld hl, wStringBuffer2
	ld a, [hli]
	or [hl]
	inc hl
	or [hl]
	jr z, .amountzero
	pop hl
	push hl
	call _hl_
	jr nc, .apply
.show_error
	call PrintText
	pop de
	pop hl
	pop bc
	jr .loop

.amountzero
	ld hl, sp + 4
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jr .show_error

.apply
	push bc
	ld bc, wStringBuffer2 + 3
	callba TakeMoney
	pop de
	ld hl, wStringBuffer2
	ld bc, 3
	rst CopyBytes
	add sp, 6
	scf
	jr .close

.cancel
	add sp, 6
	and a
.close
	jp CloseWindow

.SavedString
	text "Saved"
	done

.HeldString
	text "Held"
	done

BankInterfacePseudoMenuHeader:
	db $40 ; tile backup
	db 0, 0 ; start coords
	db 7, 19 ; end coords
	dw 0
	db 1 ; default option

BankJoypadLoop:
.loop
	call JoyTextDelay
	ld hl, hJoyPressed
	ld a, [hl]
	and B_BUTTON
	jr nz, .pressedB
	ld a, [hl]
	and A_BUTTON
	jr nz, .pressedA
	call .DPadAction
	xor a
	ldh [hBGMapMode], a
	hlcoord 12, 5
	ld bc, 7
	ld a, " "
	call ByteFill
	hlcoord 11, 6
	ld de, wStringBuffer2
	lb bc, PRINTNUM_MONEY | PRINTNUM_LEADINGZEROS | 3, 7
	call PrintNum
	hlcoord 12, 5
	ld a, [wMomBankDigitCursorPosition]
	add l
	ld l, a
	adc h
	sub l
	ld h, a
	ld [hl], "▼"
	call ApplyTilemapInVBlank
	jr .loop

.pressedB
	scf
	ret

.pressedA
	and a
	ret

.DPadAction:
	ld hl, hJoyLast
	ld a, [hl]
	rlca
	jr c, .decrementdigit
	rlca
	jr c, .incrementdigit
	rlca
	jr c, .movecursorleft
	rlca
	ret nc

; move cursor right
	ld hl, wMomBankDigitCursorPosition
	ld a, [hl]
	cp 6
	ret nc
	inc [hl]
	ret

.movecursorleft
	ld hl, wMomBankDigitCursorPosition
	ld a, [hl]
	and a
	ret z
	dec [hl]
	ret

.incrementdigit
	call .getdigitquantity
	callba GiveMoney
	ld de, wStringBuffer2
	ld hl, wStringBuffer2 + 6
	ld bc, 3
	push hl
	push de
	push bc
	call StringCmp
	pop bc
	pop de
	pop hl
	ret c
	rst CopyBytes
	ret

.decrementdigit
	call .getdigitquantity
	jpba TakeMoney

.getdigitquantity
	ld hl, .DigitQuantities
	ld a, [wMomBankDigitCursorPosition]
	ld bc, 3
	rst AddNTimes
	ld b, h
	ld c, l
	ld de, wStringBuffer2
	ret

.DigitQuantities
	dt 1000000
	dt 100000
	dt 10000
	dt 1000
	dt 100
	dt 10
	dt 1
