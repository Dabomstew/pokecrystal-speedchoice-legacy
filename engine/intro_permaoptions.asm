IntroPermaOptions::
	xor a
	ld hl, PermanentOptions
	ld [hli], a
	ld [hl], a
	ld hl, PleaseSetOptions
	call PrintText
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
	ret
	
PrintPermaOptionsToScreen::
	ld de, SelectedOptionsText
	coord hl, 2, 0
	call PlaceString
	ld a, [PermanentOptions]
	ld b, a
; rocketless
	coord hl, 1, 2
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
	ld b, a
	ld a, [PermanentOptions]
	xor b
	ld b, a
	ld a, [PermanentOptions+1]
	xor b
	ld b, a
; upper nibble
	swap a
	and $0F
	cp $A
	jr nc, .printHexInstead
	call .printNumber
	jr .lowerNibble
.printHexInstead
	call .printHex
.lowerNibble
; lower nibble
	ld a, b
	and $0F
	cp $A
	jr c, .printNumber
	jr .printHex
.printNumber
	add "G"
.doPrint
	ld [hli], a
	ret
.printHex
	add "A" - $A
	jr .doPrint
	
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
NormalEncountersText::
	db "NORMAL ENC SLOTS@"
BetterEncountersText::
	db "BETTER ENC SLOTS@"
ShowGenderText::
	db "SHOW GENDER@"
HideGenderText::
	db "HIDE GENDER@"


PleaseSetOptions::
	text_jump _PleaseSetOptions
	db "@"
	
AreOptionsAcceptable::
	text_jump _AreOptionsAcceptable
	db "@"

CheckValue:: ; to be filled in by the randomizer
	ds 4
CheckValueEnd::

