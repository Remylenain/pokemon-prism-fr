; These functions check if the current opponent is a gym leader or one of a
; few other special trainers.

; Note: KantoGymLeaders is a subset of JohtoGymLeaders. If you wish to
; differentiate between the two, call IsKantoGymLeader first.

; The Lance and Red entries are unused for music checks; those trainers are
; accounted for elsewhere.

; Arguments:
; [wOtherTrainerClass]
; Returns:
; c if in array

IsKantoGymLeader:
	ld hl, KantoGymLeaders
	jr IsGymLeaderCommon

IsJohtoGymLeader:
	ld hl, JohtoGymLeaders
	jr IsGymLeaderCommon

IsRijonGymLeader:
	ld hl, RijonGymLeaders
	jr IsGymLeaderCommon

IsNaljoGymLeader:
	ld hl, NaljoGymLeaders
IsGymLeaderCommon:
	push de
	ld a, [wOtherTrainerClass]
	call IsInSingularArray
	pop de
	ret

JohtoGymLeaders:
	db BUGSY
	db WHITNEY
	db GOLD

; TunodGymLeaders:
	db ERNEST

NaljoGymLeaders:
	db JOSIAH
	db BROOKLYN
	db RINJI
	db EDISON
	db AYAKA
	db CADENCE
	db ANDRE
	db BRUCE
	db YUKI
	db SORA
	db MURA
	db DAICHI
; fallthrough
; these two entries are unused
	db CHAMPION
	db RED
; fallthrough
RijonGymLeaders:
	db KARPMAN
	db LILY
	db SPARKY
	db LOIS
	db KOJI
	db SHERYL
	db JOE
	db SILVER

KantoGymLeaders:
	db SABRINA
	db BLUE
	db BROWN
	db -1
