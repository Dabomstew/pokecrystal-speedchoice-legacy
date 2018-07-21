PermaOptionsString:: ; e4241
	db "PRESET (A: SET)<LNBRK>"
	db "        :<LNBRK>"
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
	db "#MON GENDER<LNBRK>"
	db "        :@"
; e42d6

PermaOptionsPointers::
	dw Options_Preset
	dw Options_Rocketless
	dw Options_Spinners
	dw Options_TrainerVision
	dw Options_NerfHMs
	dw Options_BetterEncSlots
	dw Options_Gender
	dw Options_PermaOptionsPage

PermaOptionsPresets:
	; Vanilla
	dw (2 << RACE_GOAL) , Preset_VanillaName
	; Bingo
	dw (1 << ROCKETLESS) | (1 << SPINNERS) | (1 << BETTER_ENC_SLOTS) | (1 << BW_XP) | (1 << BETTER_MARTS), Preset_BingoName
	; 251
	dw (1 << ROCKETLESS) | (1 << SPINNERS) | (1 << BETTER_ENC_SLOTS) | (1 << BW_XP) | (1 << BETTER_MARTS) | (2 << RACE_GOAL), Preset_CEAName
PermaOptionsPresetsEnd:

Preset_VanillaName:
	db "VANILLA @"
Preset_BingoName:
	db "BINGO   @"
Preset_CEAName:
	db "251 RACE@"

Options_Preset::
	ld hl, wOptionsMenuPreset
	ld c, [hl]
	bit D_LEFT_F, a
	jr nz, .decr
	bit D_RIGHT_F, a
	jr nz, .incr
	bit A_BUTTON_F, a
	jr z, .print
	call .get_pointer
	ld de, wPermanentOptions
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hl]
	ld [de], a
	ld de, SFX_TRANSACTION
	call PlaySFX
	call WaitSFX
	call DrawOptionsMenuLagless_
	and a
	ret

.incr
	inc c
	ld a, c
	cp (PermaOptionsPresetsEnd - PermaOptionsPresets) / 4
	jr c, .okay
	ld c, 0
	jr .okay

.decr
	ld a, c
	dec c
	and a
	jr nz, .okay
	ld c, (PermaOptionsPresetsEnd - PermaOptionsPresets) / 4 - 1
.okay
	ld [hl], c
.print
	call .get_pointer
	inc hl
	inc hl
	ld a, [hli]
	ld d, [hl]
	ld e, a
	hlcoord 11, 3
	call PlaceString
	and a
	ret

.get_pointer
	ld b, 0
	ld hl, PermaOptionsPresets
	add hl, bc
	add hl, bc
	add hl, bc
	add hl, bc
	ret

Options_Rocketless:
	ld hl, wPermanentOptions
	and (1 << D_LEFT_F) | (1 << D_RIGHT_F)
	ld a, [hl]
	jr z, .GetText
	xor (1 << ROCKETLESS)
	ld [hl], a
.GetText
	bit ROCKETLESS, a
	ld de, .Off
	jr z, .Display
	ld de, .On
.Display
	hlcoord 11, 5
	call PlaceString
	and a
	ret
	
.Off
	db "NORMAL@"
.On
	db "PURGE @"
	
Options_Spinners: ; e44fa
	ld hl, wPermanentOptions
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
	hlcoord 11, 7
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
	ld hl, wPermanentOptions
	and (1 << D_LEFT_F) | (1 << D_RIGHT_F)
	ld a, [hl]
	jr z, .GetText
	xor (1 << MAX_RANGE)
	ld [hl], a
.GetText
	bit MAX_RANGE, a
	ld de, .Off
	jr z, .Display
	ld de, .On
.Display
	hlcoord 11, 9
	call PlaceString
	and a
	ret
	
.Off
	db "NORMAL@"
.On
	db "MAX   @"
	
Options_NerfHMs:
	ld hl, wPermanentOptions
	ld a, [RandomizedMovesStatus]
	dec a
	jr z, .normalCase
	dec a
	jr z, .randomizedMoves
; must check whether move data is randomized
	ld hl, MovesHMNerfs
	ld a, BANK(MovesHMNerfs)
	ld bc, 7
	ld de, StringBuffer5
	call FarCopyBytes
	ld hl, .PoundUnchanged
	ld de, StringBuffer5
	ld c, 7
	call StringCmp
	ld a, 1
	jr z, .write
	inc a
.write
	ld [RandomizedMovesStatus], a
	jr Options_NerfHMs
.normalCase
	ld a, [hJoyPressed]
	and (1 << D_LEFT_F) | (1 << D_RIGHT_F)
	ld a, [hl]
	jr z, .GetText
	xor (1 << NERF_HMS)
	ld [hl], a
.GetText
	bit NERF_HMS, a
	ld de, .Off
	jr z, .Display
	ld de, .On
.Display
	hlcoord 11, 11
.doDisplay
	call PlaceString
	and a
	ret
.randomizedMoves
	set NERF_HMS, [hl]
	ld de, .Randomized
	hlcoord 2, 9
	jr .doDisplay
.Off
	db "NO @"
.On
	db "YES@"
.Randomized
	db "RANDOMIZED MOVES!@"
.PoundUnchanged
	move POUND,        EFFECT_NORMAL_HIT,         40, NORMAL,   100, 35,   0
	
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
	hlcoord 11, 13
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
	hlcoord 11, 15
	call PlaceString
	and a
	ret
	
.Off
	db "SHOW@"
.On
	db "HIDE@"

