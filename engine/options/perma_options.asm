PermaOptionsString:: ; e4241
	db "ROCKET SECTIONS<LNBRK>"
	db "        :<LNBRK>"
	db "SPINNERS<LNBRK>"
	db "        :<LNBRK>"
	db "TRAINER VISION<LNBRK>"
	db "        :<LNBRK>"
	db "NERF HMs<LNBRK>"
	db "        :<LNBRK>"
	db "BETTER ENC. SLOTS<LNBRK>"
	db "        :<LNBRK>"
	db "DONE@"
; e42d6

PermaOptionsPointers::
	dw Options_Rocketless
	dw Options_Spinners
	dw Options_TrainerVision
	dw Options_NerfHMs
	dw Options_BetterEncSlots
	dw Options_Cancel

Options_Rocketless:
	ld hl, PermanentOptions
	ld a, [hJoyPressed]
	and (1 << D_LEFT_F) | (1 << D_RIGHT_F)
	jr nz, .ButtonPressed
	bit ROCKETLESS, [hl]
	jr z, .ToggleOff
	jr nz, .ToggleOn

.ButtonPressed
	bit ROCKETLESS, [hl]
	jr z, .ToggleOn

.ToggleOff
	res ROCKETLESS, [hl]
	ld de, .Off
	jr .Display

.ToggleOn
	set ROCKETLESS, [hl]
	ld de, .On

.Display
	hlcoord 11, 3
	call PlaceString
	and a
	ret
	
.Off
	db "NORMAL@"
.On
	db "PURGE @"
	
Options_Spinners: ; e44fa
	ld hl, PermanentOptions
	ld a, [hJoyPressed]
	bit D_LEFT_F, a
	jr nz, .LeftPressed
	bit D_RIGHT_F, a
	jr nz, .RightPressed
	jr .UpdateDisplay

.RightPressed
	call .GetSpinnerVal
	inc a
	jr .Save

.LeftPressed
	call .GetSpinnerVal
	dec a

.Save
	and $3
	sla a
	ld b, a
	ld a, [hl]
	and %11111001
	or b
	ld [hl], a
	
.UpdateDisplay: ; e4512
	call .GetSpinnerVal
	ld c, a
	ld b, 0
	ld hl, .Strings
rept 2
	add hl, bc
endr
	ld e, [hl]
	inc hl
	ld d, [hl]
	hlcoord 11, 5
	call PlaceString
	and a
	ret
	
.GetSpinnerVal:
	ld a, [hl]
	and %110
	srl a
	ret
	
.Strings:
	dw .Normal
	dw .Purge
	dw .Hell
	dw .Why
	
.Normal
	db "NORMAL@"
.Purge
	db "PURGE @"
.Hell
	db "HELL  @"
.Why
	db "WHY   @"

Options_TrainerVision:
	ld hl, PermanentOptions
	ld a, [hJoyPressed]
	and (1 << D_LEFT_F) | (1 << D_RIGHT_F)
	jr nz, .ButtonPressed
	bit MAX_RANGE, [hl]
	jr z, .ToggleOff
	jr nz, .ToggleOn

.ButtonPressed
	bit MAX_RANGE, [hl]
	jr z, .ToggleOn

.ToggleOff
	res MAX_RANGE, [hl]
	ld de, .Off
	jr .Display

.ToggleOn
	set MAX_RANGE, [hl]
	ld de, .On

.Display
	hlcoord 11, 7
	call PlaceString
	and a
	ret
	
.Off
	db "NORMAL@"
.On
	db "MAX   @"
	
Options_NerfHMs:
	ld hl, PermanentOptions
	ld a, [hJoyPressed]
	and (1 << D_LEFT_F) | (1 << D_RIGHT_F)
	jr nz, .ButtonPressed
	bit NERF_HMS, [hl]
	jr z, .ToggleOff
	jr nz, .ToggleOn

.ButtonPressed
	bit NERF_HMS, [hl]
	jr z, .ToggleOn

.ToggleOff
	res NERF_HMS, [hl]
	ld de, .Off
	jr .Display

.ToggleOn
	set NERF_HMS, [hl]
	ld de, .On

.Display
	hlcoord 11, 9
	call PlaceString
	and a
	ret
	
.Off
	db "NO @"
.On
	db "YES@"
	
Options_BetterEncSlots:
	ld hl, PermanentOptions
	ld a, [hJoyPressed]
	and (1 << D_LEFT_F) | (1 << D_RIGHT_F)
	jr nz, .ButtonPressed
	bit BETTER_ENC_SLOTS, [hl]
	jr z, .ToggleOff
	jr nz, .ToggleOn

.ButtonPressed
	bit BETTER_ENC_SLOTS, [hl]
	jr z, .ToggleOn

.ToggleOff
	res BETTER_ENC_SLOTS, [hl]
	ld de, .Off
	jr .Display

.ToggleOn
	set BETTER_ENC_SLOTS, [hl]
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

