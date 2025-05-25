Facings:
	dw FacingDownStanding ; 0
	dw FacingDownWalking1
	dw FacingDownStanding
	dw FacingDownWalking2
	dw FacingUpStanding
	dw FacingUpWalking1
	dw FacingUpStanding
	dw FacingUpWalking2
	dw FacingLeftStanding ; 8
	dw FacingLeftWalking
	dw FacingLeftStanding
	dw FacingLeftWalking
	dw FacingRightStanding
	dw FacingRightWalking
	dw FacingRightStanding
	dw FacingRightWalking
	dw FacingFishDown1 ; 10
	dw FacingFishUp1
	dw FacingFishLeft1
	dw FacingFishRight1
	dw FacingEmote
	dw FacingShadow
	dw FacingBigDoll
	dw FacingBigDollSnorlaxLapras
	dw FacingDownStanding ; 18
	dw FacingWeirdTree1
	dw FacingDownStanding
	dw FacingWeirdTree3
	dw FacingBoulderDust1
	dw FacingBoulderDust2
	dw FacingGrass1
	dw FacingGrass2
	dw FacingFishDown2 ; 20
	dw FacingFishUp2
	dw FacingFishLeft2
	dw FacingFishRight2
	dw FacingSnow1
	dw FacingSnow2
FacingsEnd: dw 0

NUM_FACINGS EQU (FacingsEnd - Facings) / 2


; Tables used as a reference to transform OAM data.

; Format:
;	db y, x, attributes, tile index

; Attributes:
X_FLIP    EQU 1 << OAM_X_FLIP
Y_FLIP    EQU 1 << OAM_Y_FLIP
BEHIND_BG EQU 1 << OAM_PRIORITY


FacingDownStanding:
	db 4 ; #
	db  0,  0, 0, $00
	db  0,  8, 0, $01
	db  8,  0, 2, $02
	db  8,  8, 2, $03

FacingDownWalking1:
	db 4 ; #
	db  0,  0, 0, $80
	db  0,  8, 0, $81
	db  8,  0, 2, $82
	db  8,  8, 2, $83

FacingDownWalking2:
	db 4 ; #
	db  0,  8, X_FLIP, $80
	db  0,  0, X_FLIP, $81
	db  8,  8, 2 | X_FLIP, $82
	db  8,  0, 2 | X_FLIP, $83

FacingUpStanding:
	db 4 ; #
	db  0,  0, 0, $04
	db  0,  8, 0, $05
	db  8,  0, 2, $06
	db  8,  8, 2, $07

FacingUpWalking1:
	db 4 ; #
	db  0,  0, 0, $84
	db  0,  8, 0, $85
	db  8,  0, 2, $86
	db  8,  8, 2, $87

FacingUpWalking2:
	db 4 ; #
	db  0,  8, X_FLIP, $84
	db  0,  0, X_FLIP, $85
	db  8,  8, 2 | X_FLIP, $86
	db  8,  0, 2 | X_FLIP, $87

FacingLeftStanding:
	db 4 ; #
	db  0,  0, 0, $08
	db  0,  8, 0, $09
	db  8,  0, 2, $0a
	db  8,  8, 2, $0b

FacingRightStanding:
	db 4 ; #
	db  0,  8, X_FLIP, $08
	db  0,  0, X_FLIP, $09
	db  8,  8, 2 | X_FLIP, $0a
	db  8,  0, 2 | X_FLIP, $0b

FacingLeftWalking:
	db 4 ; #
	db  0,  0, 0, $88
	db  0,  8, 0, $89
	db  8,  0, 2, $8a
	db  8,  8, 2, $8b

FacingRightWalking:
	db 4 ; #
	db  0,  8, X_FLIP, $88
	db  0,  0, X_FLIP, $89
	db  8,  8, 2 | X_FLIP, $8a
	db  8,  0, 2 | X_FLIP, $8b

FacingEmote:
	db 4 ; #
	db  0,  0, 4, $f8
	db  0,  8, 4, $f9
	db  8,  0, 4, $fa
	db  8,  8, 4, $fb

FacingShadow:
	db 2 ; #
	db  0,  0, 4, $fc
	db  0,  8, 4 | X_FLIP, $fc

FacingBigDollSnorlaxLapras:
	db 16 ; #
	db  0,  0, 0, $00
	db  0,  8, 0, $01
	db  8,  0, 0, $02
	db  8,  8, 0, $03
	db 16,  0, 0, $04
	db 16,  8, 0, $05
	db 24,  0, 0, $06
	db 24,  8, 0, $07
	db  0, 24, X_FLIP, $00
	db  0, 16, X_FLIP, $01
	db  8, 24, X_FLIP, $02
	db  8, 16, X_FLIP, $03
	db 16, 24, X_FLIP, $04
	db 16, 16, X_FLIP, $05
	db 24, 24, X_FLIP, $06
	db 24, 16, X_FLIP, $07

FacingWeirdTree1:
	db 4 ; #
	db  0,  0, 0, $04
	db  0,  8, 0, $05
	db  8,  0, 0, $06
	db  8,  8, 0, $07

FacingWeirdTree3:
	db 4 ; #
	db  0,  8, X_FLIP, $04
	db  0,  0, X_FLIP, $05
	db  8,  8, X_FLIP, $06
	db  8,  0, X_FLIP, $07

FacingBigDoll:
	db 14 ; #
	db  0,  0, 0, $00
	db  0,  8, 0, $01
	db  8,  0, 0, $04
	db  8,  8, 0, $05
	db 16,  8, 0, $07
	db 24,  8, 0, $0a
	db  0, 24, 0, $03
	db  0, 16, 0, $02
	db  8, 24, X_FLIP, $02
	db  8, 16, 0, $06
	db 16, 24, 0, $09
	db 16, 16, 0, $08
	db 24, 24, X_FLIP, $04
	db 24, 16, 0, $0b

FacingBoulderDust1:
	db 4 ; #
	db  0,  0, 4, $fe
	db  0,  8, 4, $fe
	db  8,  0, 4, $fe
	db  8,  8, 4, $fe

FacingBoulderDust2:
	db 4 ; #
	db  0,  0, 4, $ff
	db  0,  8, 4, $ff
	db  8,  0, 4, $ff
	db  8,  8, 4, $ff

FacingGrass1:
	db 2 ; #
	db  8,  0, 4, $fe
	db  8,  8, 4 | X_FLIP, $fe

FacingGrass2:
	db 2 ; #
	db  9, -1, 4, $fe
	db  9,  9, 4 | X_FLIP, $fe

FacingSnow1:
	db 2 ; #
	db  8,  0, 4, $ff
	db  8,  8, 4 | X_FLIP, $ff

FacingSnow2:
	db 2 ; #
	db  9, -1, 4, $ff
	db  9,  9, 4 | X_FLIP, $ff

FacingFishDown1:
; Facing down, frame 1
	db 6
	db  0, 0, 0, $00
	db  0, 8, 0, $01
	db  8, 0, 0, $02
	db  8, 8, 0, $03
	db -8, 0, 0, $7c
	db -8, 8, 0, $7d

FacingFishDown2:
; Facing down, frame 2
	db 6
	db  0, 0, 0, $80
	db  0, 8, 0, $81
	db  8, 0, 0, $82
	db  8, 8, 0, $83
	db 16, 0, Y_FLIP, $7c
	db 16, 8, Y_FLIP, $7d

FacingFishUp1:
; Facing up, frame 1
	db 5
	db  0, 0, 0, $04
	db  0, 8, 0, $05
	db  8, 0, 0, $06
	db  8, 8, 0, $07
	db -8, 0, 0, $7e

FacingFishUp2:
; Facing up, frame 2
	db 5
	db  0, 0, 0, $84
	db  0, 8, 0, $85
	db  8, 0, 0, $86
	db  8, 8, 0, $87
	db -8, 0, 0, $7c

FacingFishLeft1:
; Facing left, frame 1
	db 6
	db  0, 0, 0, $08
	db  0, 8, 0, $09
	db  8, 0, 0, $0a
	db  8, 8, 0, $0b
	db -8, 0, X_FLIP, $7d
	db -8, 8, X_FLIP, $7c

FacingFishLeft2:
; Facing left, frame 2
	db 5
	db  0,  0, 0, $88
	db  0,  8, 0, $89
	db  8,  0, 0, $8a
	db  8,  8, 0, $8b
	db  0, -8, 0, $7f

FacingFishRight1:
; Facing left, frame 1
	db 6
	db  0, 0, X_FLIP, $09
	db  0, 8, X_FLIP, $08
	db  8, 0, X_FLIP, $0b
	db  8, 8, X_FLIP, $0a
	db -8, 0, 0, $7c
	db -8, 8, 0, $7d

FacingFishRight2:
; Facing left, frame 2
	db 5
	db  0,  0, X_FLIP, $89
	db  0,  8, X_FLIP, $88
	db  8,  0, X_FLIP, $8b
	db  8,  8, X_FLIP, $8a
	db  0, 16, X_FLIP, $7f
