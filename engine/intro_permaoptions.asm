IntroPermaOptions::
	xor a
	ld hl, wPermanentOptions
	ld [hli], a
	ld [hli], a
	ld [hl], a
	ld a, [Options2]
	push af
	and $ff ^ (1 << HOLD_TO_MASH)
	ld [Options2], a
	ld hl, PleaseSetOptions
	call PrintText
	pop af
	ld [Options2], a
	xor a
	ld [RandomizedMovesStatus], a
	ld a, "@"
	ld [PlayerName], a
	ld hl, PlayerGender
	set 0, [hl]
.setOptions
	callba PermaOptionsMenu
	call ClearTileMap
	call PrintPermaOptionsToScreen
	ld hl, AreOptionsAcceptable
	call PrintText
	lb bc, 14, 7
	call PlaceYesNoBox
	ld a, [wMenuCursorY]
	dec a
	jr nz, .setOptions
; setup stats now
    ld a, 1
    ld [hStatsDisabled], a
    ld a, BANK(sStatsStart)
    call OpenSRAM
    xor a
    ld hl, sStatsStart
    ld bc, sStatsEnd - sStatsStart
    call ByteFill
    call CloseSRAM
    ld [hStatsDisabled], a ; still 0 from above
	ret
	
PrintPermaOptionsToScreen::
	ld de, SelectedOptionsText
	coord hl, 2, 0
	call PlaceString
	ld a, [wPermanentOptions]
	ld b, a
; rocketless
	coord hl, 1, 1
	bit ROCKETLESS, b
	ld de, NormalRocketsText
	jr z, .placeRocketSetting
	ld de, RocketlessText
.placeRocketSetting
	call PlaceStringIncHL
; spinners
	ld a, b
	and %110
	push hl
	ld hl, .SpinnerOptionsStrings
	add l
	ld l, a
	jr nc, .loadPtr
	inc h
.loadPtr
	ld a, [hli]
	ld d, [hl]
	ld e, a
	pop hl
	call PlaceStringIncHL
; vision
	bit MAX_RANGE, b
	ld de, NormalVisionText
	jr z, .placeVisionSetting
	ld de, MaxVisionText
.placeVisionSetting
	call PlaceStringIncHL
; hms
	ld a, [RandomizedMovesStatus]
	cp 2 ; randomized
	jr nz, .normalTreatment
	ld de, RandomizedMovesText
	jr .placeHMSetting
.normalTreatment
	bit NERF_HMS, b
	ld de, NormalHMsText
	jr z, .placeHMSetting
	ld de, NerfedHMsText
.placeHMSetting
	call PlaceStringIncHL
; encs
	bit BETTER_ENC_SLOTS, b
	ld de, NormalEncountersText
	jr z, .placeEncSetting
	ld de, BetterEncountersText
.placeEncSetting
	call PlaceStringIncHL
; gender
	bit DISABLE_GENDER, b
	ld de, ShowGenderText
	jr z, .placeGenderSetting
	ld de, HideGenderText
.placeGenderSetting
	call PlaceStringIncHL
; bwxp
	bit BW_XP, b
	ld de, NormalEXPText
	jr z, .placeEXPSetting
	ld de, BWEXPText
.placeEXPSetting
	call PlaceStringIncHL
	ld a, [wPermanentOptions2]
	ld b, a
; marts
	bit BETTER_MARTS_F, b
	ld de, NormalMartsText
	jr z, .placeMartSetting
	ld de, BetterMartsText
.placeMartSetting
	call PlaceStringIncHL
; wilds
	bit EVOLVED_EARLY_WILDS_F, b
	ld de, NormalWildsText
	jr z, .placeWildsSetting
	ld de, BetterWildsText
.placeWildsSetting
	call PlaceStringIncHL
; kanto
	bit EARLY_KANTO_F, b
	ld de, NormalKantoText
	jr z, .placeKantoSetting
	ld de, EarlyKantoText
.placeKantoSetting
	call PlaceStringIncHL
; checkvalue stuff
	coord hl, 1, 11
	ld [hl], "C"
	inc hl
	ld [hl], "V"
	inc hl
	ld [hl], "<COLON>"
	inc hl
	inc hl
	ld de, CheckValue
	ld c, 4
.checkValueLoop
	ld a, [de]
	inc de
	call PrintHexValueXoredWithOptions
	dec c
	jr nz, .checkValueLoop
	ret
.SpinnerOptionsStrings
	dw NormalSpinnersText
	dw NoSpinnersText
	dw SpinnerHellText
	dw SuperSpinnerHellText
	
PlaceStringIncHL::
	push bc
	call PlaceString
	ld bc, SCREEN_WIDTH
	add hl, bc
	pop bc
	ret
	
PrintHexValueXoredWithOptions::
; a contains the value to be displayed
	push hl
	ld hl, wPermanentOptions
	xor [hl]
	inc hl
	xor [hl]
	ld b, a
	pop hl
; upper nibble
	swap b
	call .printNibble
	swap b
.printNibble
	ld a, b
	and $0F
	add "0"
	or $80
	ld [hli], a
	ret
	
SelectedOptionsText::
	db "SELECTED OPTIONS@"
NormalRocketsText::
	db "NORMAL ROCKETS@"
RocketlessText::
	db "ROCKETLESS@"
NormalSpinnersText::
	db "NORMAL SPINNERS@"
NoSpinnersText::
	db "SPINNERLESS@"
SpinnerHellText::
	db "SPINNER HELL@"
SuperSpinnerHellText::
	db "SUPER SPINNER HELL@"
NormalVisionText::
	db "NORMAL VISION@"
MaxVisionText::
	db "MAX VISION@"
NormalHMsText::
	db "NORMAL HMs@"
NerfedHMsText::
	db "NERFED HMs@"
RandomizedMovesText::
	db "RANDOMIZED MOVES@"
NormalEncountersText::
	db "NORMAL ENC SLOTS@"
BetterEncountersText::
	db "BETTER ENC SLOTS@"
ShowGenderText::
	db "SHOW GENDER@"
HideGenderText::
	db "HIDE GENDER@"
NormalEXPText::
	db "NORMAL EXP@"
BWEXPText::
	db "B/W EXP@"
NormalMartsText::
	db "NORM MARTS@"
BetterMartsText::
	db "GOOD MARTS@"
NormalWildsText::
	db "NORM WILDS@"
BetterWildsText::
	db "GOOD WILDS@"
NormalKantoText::
	db "NORM KANTO@"
EarlyKantoText::
	db "EARLY KANTO@"

PleaseSetOptions::
	text_jump _PleaseSetOptions
	db "@"

AreOptionsAcceptable::
	text_jump _AreOptionsAcceptable
	db "@"

