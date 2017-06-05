PermaOptionsP2String:: ; e4241
	db "BETTER MARTS<LNBRK>"
	db "        :<LNBRK>"
	db "GOOD EARLY WILDS<LNBRK>"
	db "        :<LNBRK>"
	db "RACE GOAL<LNBRK>"
	db "        :@"
; e42d6

PermaOptionsP2Pointers::
	dw Options_BetterMartsOption
	dw Options_GoodEarlyWildsOption
	dw Options_RaceGoalOption
	dw Options_PermaOptionsPage
	
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
	hlcoord 11, 3
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
	hlcoord 11, 5
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
	hlcoord 11, 7
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

