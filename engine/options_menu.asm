PermaOptionsMenu:
	push de
	ld a, 3
	ld hl, PermaOptionsString
	ld de, PermaOptionsPointers
	call StoreOptionsMenuConfig
	pop de
	jr OptionsMenuCommon
	
OptionsMenu:
	push de
	ld a, 7
	ld hl, MainOptionsString
	ld de, MainOptionsPointers
	call StoreOptionsMenuConfig
	pop de
	; fallthrough

OptionsMenuCommon:: ; e41d0
	ld hl, hInMenu
	ld a, [hl]
	push af
	ld [hl], $1
	call ClearBGPalettes
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
	ld a, [wOptionsMenuCount]
	ld c, a ; number of items on the menu

.print_text_loop ; this next will display the settings of each option when the menu is opened
	push bc
	xor a
	ld [hJoyLast], a
	call GetOptionPointer
	pop bc
	ld hl, wJumptableIndex
	inc [hl]
	dec c
	jr nz, .print_text_loop

	call LoadFontsExtra
	xor a
	ld [wJumptableIndex], a
	inc a
	ld [hBGMapMode], a
	call WaitBGMap
	ld b, SCGB_08
	call GetSGBLayout
	call SetPalettes

.joypad_loop
	call JoyTextDelay
	ld a, [hJoyPressed]
	and START | B_BUTTON
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
	ld de, SFX_TRANSACTION
	call PlaySFX
	call WaitSFX
	pop af
	ld [hInMenu], a
	ret
; e4241

StoreOptionsMenuConfig::
	ld [wOptionsMenuCount], a
	ld a, l
	ld [wOptionsStringPtr], a
	ld a, h
	ld [wOptionsStringPtr+1], a
	ld a, e
	ld [wOptionsJumptablePtr], a
	ld a, d
	ld [wOptionsJumptablePtr+1], a
	ret

GetOptionPointer: ; e42d6
	ld a, [wJumptableIndex] ; load the cursor position to a
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
	jp [hl] ; jump to the code of the current highlighted item
; e42e5

Options_Cancel: ; e4520
	ld a, [hJoyPressed]
	and A_BUTTON
	jr nz, .Exit
	and a
	ret

.Exit
	scf
	ret
; e452a

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
	ld c, a
	ld a, [wOptionsMenuCount]
	cp c ; maximum number of items in option menu
	jr nz, .Increase
	ld [hl], $0
	scf
	ret

.Increase
	inc [hl]
	scf
	ret

.UpPressed
	ld a, [hl]
	and a
	jr nz, .Decrease
	ld a, [wOptionsMenuCount]
	inc a
	ld [hl], a ; number of option items +1

.Decrease
	dec [hl]
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
INCLUDE "engine/options/perma_options.asm"
