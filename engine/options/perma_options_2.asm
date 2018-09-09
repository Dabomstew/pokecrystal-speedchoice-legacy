PermaOptionsP2String:: ; e4241
	db "BETTER ENC. SLOTS<LNBRK>"
	db "        :<LNBRK>"
	db "#MON GENDER<LNBRK>"
	db "        :<LNBRK>"
	db "B/W EXP SYSTEM<LNBRK>"
	db "        :<LNBRK>"
	db "BETTER MARTS<LNBRK>"
	db "        :<LNBRK>"
	db "GOOD EARLY WILDS<LNBRK>"
	db "        :<LNBRK>"
	db "RACE GOAL<LNBRK>"
	db "        :<LNBRK>"
	db "KANTO ACCESS<LNBRK>"
	db "        :@"
; e42d6

PermaOptionsP2Pointers::
	dw Options_BetterEncSlots
	dw Options_Gender
	dw Options_BWXP
	dw Options_BetterMartsOption
	dw Options_GoodEarlyWildsOption
	dw Options_RaceGoalOption
	dw Options_KantoAccessOption
	dw Options_PermaOptionsPage

Options_BetterEncSlots:
	ld hl, wPermanentOptions
	and (1 << D_LEFT_F) | (1 << D_RIGHT_F)
	ld a, [hl]
	jr z, .GetText
	xor (1 << BETTER_ENC_SLOTS)
	ld [hl], a
.GetText
	bit BETTER_ENC_SLOTS, a
	ld de, .Off
	jr z, .Display
	ld de, .On
.Display
	hlcoord 11, 3
	call PlaceString
	and a
	ret
	
.Off
	db "OFF@"
.On
	db "ON @"
	
Options_Gender:
	ld hl, wPermanentOptions
	and (1 << D_LEFT_F) | (1 << D_RIGHT_F)
	ld a, [hl]
	jr z, .GetText
	xor (1 << DISABLE_GENDER)
	ld [hl], a
.GetText
	bit DISABLE_GENDER, a
	ld de, .Off
	jr z, .Display
	ld de, .On
.Display
	hlcoord 11, 5
	call PlaceString
	and a
	ret
	
.Off
	db "SHOW@"
.On
	db "HIDE@"

Options_BWXP:
	ld hl, wPermanentOptions
	and (1 << D_LEFT_F) | (1 << D_RIGHT_F)
	ld a, [hl]
	jr z, .GetText
	xor (1 << BW_XP)
	ld [hl], a
.GetText
	bit BW_XP, a
	ld de, .Off
	jr z, .Display
	ld de, .On
.Display
	hlcoord 11, 7
	call PlaceString
	and a
	ret
	
.Off
	db "OFF@"
.On
	db "ON @"

Options_BetterMartsOption:
	ld hl, wPermanentOptions2
	and (1 << D_LEFT_F) | (1 << D_RIGHT_F)
	ld a, [hl]
	jr z, .GetText
	xor (1 << BETTER_MARTS_F)
	ld [hl], a
.GetText
	bit BETTER_MARTS_F, a
	ld de, .Off
	jr z, .Display
	ld de, .On
.Display
	hlcoord 11, 9
	call PlaceString
	and a
	ret
	
.Off
	db "OFF@"
.On
	db "ON @"
	
Options_GoodEarlyWildsOption:
	ld hl, wPermanentOptions2
	and (1 << D_LEFT_F) | (1 << D_RIGHT_F)
	ld a, [hl]
	jr z, .GetText
	xor (1 << EVOLVED_EARLY_WILDS_F)
	ld [hl], a
.GetText
	bit EVOLVED_EARLY_WILDS_F, a
	ld de, .Off
	jr z, .Display
	ld de, .On
.Display
	hlcoord 11, 11
	call PlaceString
	and a
	ret
	
.Off
	db "OFF@"
.On
	db "ON @"
	
Options_RaceGoalOption: ; e44fa
	ld hl, wPermanentOptions2
	bit D_LEFT_F, a
	jr nz, .LeftPressed
	bit D_RIGHT_F, a
	jr nz, .RightPressed
	jr .UpdateDisplay

.RightPressed
	call .GetRaceGoalVal
	inc a
	jr .Save

.LeftPressed
	call .GetRaceGoalVal
	dec a

.Save
	cp $ff
	jr z, .writehigh
	cp $03
	jr nz, .dowrite
; low
	xor a
	jr .dowrite
.writehigh
	ld a, $2
.dowrite
	sla a
	sla a
	ld b, a
	ld a, [hl]
	and GOAL_MASK ^ $FF
	or b
	ld [hl], a
	
.UpdateDisplay: ; e4512
	call .GetRaceGoalVal
	ld c, a
	ld b, 0
	ld hl, .Strings
rept 2
	add hl, bc
endr
	ld e, [hl]
	inc hl
	ld d, [hl]
	hlcoord 11, 13
	call PlaceString
	and a
	ret
	
.GetRaceGoalVal:
	ld a, [hl]
	and GOAL_MASK
	srl a
	srl a
	ret
	
.Strings:
	dw .Manual
	dw .E4
	dw .Red
	
	
.Manual
	db "MANUAL@"
.E4
	db "E4    @"
.Red
	db "RED   @"


Options_KantoAccessOption:
	ld hl, wPermanentOptions2
	and (1 << D_LEFT_F) | (1 << D_RIGHT_F)
	ld a, [hl]
	jr z, .GetText
	xor (1 << EARLY_KANTO_F)
	ld [hl], a
.GetText
	bit EARLY_KANTO_F, a
	ld de, .Off
	jr z, .Display
	ld de, .On
.Display
	hlcoord 11, 15
	call PlaceString
	and a
	ret
	
.Off
	db "NORMAL@"
.On
	db "EARLY @"

