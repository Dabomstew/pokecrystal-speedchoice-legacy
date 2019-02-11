FIRST_OPTIONS_PAGEID EQU 0
NUM_OPTIONS_PAGES EQU 2

FIRST_PERMAOPTIONS_PAGEID EQU 2
NUM_PERMAOPTIONS_PAGES EQU 3

PermaOptionsMenu:
	ld a, FIRST_PERMAOPTIONS_PAGEID
	jr OptionsMenuCommon

OptionsMenu:
	xor a
	; fallthrough

OptionsMenuCommon:: ; e41d0
	ld [wOptionsMenuID], a
	xor a
	ld [wStoredJumptableIndex], a
	ld [wOptionsMenuPreset], a
	ld hl, hInMenu
	ld a, [hl]
	push af
	ld [hl], $1
	call ClearBGPalettes
.pageLoad
	call DrawOptionsMenu
.joypad_loop
	call JoyTextDelay
	ld a, [hJoyPressed]
	ld b, a
	ld a, [wOptionsExitButtons]
	and b
	jr nz, .ExitOptions
	call OptionsControl
	jr c, .dpad
	call GetOptionPointer
	jr c, .ExitOptions

.dpad
	call Options_UpdateCursorPosition
	ld c, 3
	call DelayFrames
	jr .joypad_loop

.ExitOptions
	ld a, [wOptionsNextMenuID]
	cp $FF
	jr z, .doExit
	ld [wOptionsMenuID], a
	jr .pageLoad
.doExit
	ld a, [wOptionsMenuID]
	cp FIRST_PERMAOPTIONS_PAGEID
	jr c, .exit
	ld a, [PlayerName]
	cp "@"
	jr nz, .exit
	ld a, [Options2]
	push af
	and $ff ^ (1 << HOLD_TO_MASH)
	ld [Options2], a
	ld hl, NameNotSetText
	call PrintText
	pop af
	ld [Options2], a
	jr .pageLoad
.exit
	pop af
	ld [hInMenu], a
	ld de, SFX_TRANSACTION
	call PlaySFX
	call WaitSFX
	ret
; e4241

DrawOptionsMenu:
	call DrawOptionsMenuLagless
	call LoadFontsExtra
	ld a, [wStoredJumptableIndex]
	ld [wJumptableIndex], a
	xor a
	ld [wStoredJumptableIndex], a
	inc a
	ld [hBGMapMode], a
	call WaitBGMap
	ld b, SCGB_08
	call GetSGBLayout
	call SetPalettes
	ret

DrawOptionsMenuLagless_::
	ld a, [wJumptableIndex]
	push af
	call DrawOptionsMenuLagless
	pop af
	ld [wJumptableIndex], a
	ret

DrawOptionsMenuLagless::
	call RetrieveOptionsMenuConfig
	hlcoord 0, 0
	ld b, 16
	ld c, 18
	call TextBox
	ld hl, wOptionsStringPtr
	ld a, [hli]
	ld e, a
	ld d, [hl]
	hlcoord 2, 2
	call PlaceString
	xor a
	ld [wJumptableIndex], a
	dec a
	ld [wOptionsNextMenuID], a
	ld a, [wOptionsMenuCount]
	inc a
	ld c, a ; number of items on the menu

.print_text_loop ; this next will display the settings of each option when the menu is opened
	push bc
	xor a
	ld [hJoyPressed], a
	call GetOptionPointer
	pop bc
	ld hl, wJumptableIndex
	inc [hl]
	dec c
	jr nz, .print_text_loop
	ret

RetrieveOptionsMenuConfig::
	ld a, [wOptionsMenuID]
	ld hl, OptionsMenuScreens
	ld bc, wOptionsNextMenuID - wOptionsMenuCount
	call AddNTimes
	ld de, wOptionsMenuCount
	jp CopyBytes
	
options_menu: MACRO
	db (\1) ; number of options except bottom option
	dw (\2) ; template string
	dw (\3) ; jumptable for options
	db (\4) ; buttons that can be pressed to exit
ENDM

OptionsMenuScreens:
	; default options page 1
	options_menu 7, MainOptionsString, MainOptionsPointers, (START | B_BUTTON)
	; default options page 2
	options_menu 1, MainOptionsP2String, MainOptionsP2Pointers, (START | B_BUTTON)
	; permaoptions page 1
	options_menu 7, PermaOptionsString, PermaOptionsPointers, START
	; permaoptions page 2
	options_menu 7, PermaOptionsP2String, PermaOptionsP2Pointers, START
	; permaoptions page 3
	options_menu 1, PermaOptionsP3String, PermaOptionsP3Pointers, START

GetOptionPointer: ; e42d6
	ld a, [wOptionsMenuCount]
	ld b, a
	ld a, [wJumptableIndex] ; load the cursor position to a
	cp b
	jr c, .doJump
	ld a, b ; if on the bottom option, use the last item in the jumptable
.doJump
	ld e, a ; copy it to de
	ld d, 0
	ld hl, wOptionsJumptablePtr
	ld a, [hli]
	ld h, [hl]
	ld l, a
rept 2
	add hl, de
endr
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [hJoyPressed] ; almost all options use this, so it's easier to just do it here
	jp [hl] ; jump to the code of the current highlighted item
; e42e5

Options_Cancel: ; e4520
	and A_BUTTON
	jr nz, Options_Exit
Options_NoFunc:
	and a
	ret

Options_Exit:
	scf
	ret
; e452a

Options_OptionsPage:
	lb bc, FIRST_OPTIONS_PAGEID, FIRST_OPTIONS_PAGEID + NUM_OPTIONS_PAGES - 1
	jr Options_Page

Options_PermaOptionsPage:
	lb bc, FIRST_PERMAOPTIONS_PAGEID, FIRST_PERMAOPTIONS_PAGEID + NUM_PERMAOPTIONS_PAGES - 1
Options_Page:
; assumes b = MenuID of first page, c = MenuID of last page
; also assumes all pages use sequential MenuIDs
	bit D_LEFT_F, a
	jr nz, .Decrease
	bit D_RIGHT_F, a
	jr nz, .Increase
	coord hl, 2, 16
	ld de, .PageString
	push bc
	call PlaceString
	pop bc
	ld a, [wOptionsMenuID]
	sub b
	add "1"
	coord hl, 8, 16
	ld [hl], a
	and a
	ret
.Decrease
	ld a, [wOptionsMenuID]
	cp b
	jr nz, .actuallyDecrease
	ld a, c
	jr .SaveAndChangePage
.actuallyDecrease
	dec a
	jr .SaveAndChangePage
.Increase
	ld a, [wOptionsMenuID]
	cp c
	jr nz, .actuallyIncrease
	ld a, b
	jr .SaveAndChangePage
.actuallyIncrease
	inc a
.SaveAndChangePage
	ld [wOptionsNextMenuID], a
	ld a, 7
	ld [wStoredJumptableIndex], a
	scf
	ret
.PageString
	db "PAGE:@"

OptionsControl: ; e452a
	ld hl, wJumptableIndex
	ld a, [hJoyLast]
	cp D_DOWN
	jr z, .DownPressed
	cp D_UP
	jr z, .UpPressed
	and a
	ret

.DownPressed
	ld a, [hl] ; load the cursor position to a
	cp 7
	jr nz, .clampToMenuTest
	ld [hl], $0
	scf
	ret
.clampToMenuTest
	ld c, a
	ld a, [wOptionsMenuCount]
	dec a
	cp c ; maximum index of item in real options menu
	jr nz, .Increase
	ld [hl], $6 ; bottom option minus 1

.Increase
	inc [hl]
	scf
	ret

.UpPressed
	ld a, [hl]
	cp 7
	jr z, .HandleBottomOption
	and a
	jr nz, .Decrease
	ld a, 8
	ld [hl], a ; move to bottom option

.Decrease
	dec [hl]
	scf
	ret
	
.HandleBottomOption
; move to bottommost regular option
	ld a, [wOptionsMenuCount]
	dec a
	ld [hl], a
	scf
	ret
; e455c

Options_UpdateCursorPosition: ; e455c
	hlcoord 1, 1
	ld de, SCREEN_WIDTH
	ld c, $10
.loop
	ld [hl], " "
	add hl, de
	dec c
	jr nz, .loop
	hlcoord 1, 2
	ld bc, 2 * SCREEN_WIDTH
	ld a, [wJumptableIndex]
	call AddNTimes
	ld [hl], "▶"
	ret
; e4579

INCLUDE "engine/options/main_options.asm"
INCLUDE "engine/options/main_options_2.asm"
INCLUDE "engine/options/perma_options.asm"
INCLUDE "engine/options/perma_options_2.asm"
INCLUDE "engine/options/perma_options_3.asm"

NameNotSetText::
	text "Please set your"
	line "name on page 1!@"
	start_asm
	ld de, SFX_WRONG
	call PlaySFX
	call WaitSFX
	ld hl, .done
	ret
.done
	text ""
	prompt
