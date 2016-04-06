MainOptionsPointers::
	dw Options_TextSpeed
	dw Options_HoldToMash
	dw Options_BattleScene
	dw Options_BattleStyle
	dw Options_Sound
	dw Options_MenuAccount
	dw Options_Frame
	dw Options_Cancel
; e42f5

Options_TextSpeed: ; e42f5
	call GetTextSpeed
	ld a, [hJoyPressed]
	bit D_LEFT_F, a
	jr nz, .LeftPressed
	bit D_RIGHT_F, a
	jr z, .NonePressed
	ld a, c ; right pressed
	cp SLOW_TEXT
	jr c, .Increase
	ld c, INST_TEXT +- 1

.Increase
	inc c
	ld a, e
	jr .Save

.LeftPressed
	ld a, c
	and a
	jr nz, .Decrease
	ld c, SLOW_TEXT + 1

.Decrease
	dec c
	ld a, d

.Save
	ld b, a
	ld a, [Options]
	and $f0
	or b
	ld [Options], a

.NonePressed
	ld b, 0
	ld hl, .Strings
rept 2
	add hl, bc
endr
	ld e, [hl]
	inc hl
	ld d, [hl]
	hlcoord 11, 3
	call PlaceString
	and a
	ret
; e4331

.Strings
	dw .Inst
	dw .Fast
	dw .Mid
	dw .Slow
	
.Inst
	db "INST@"

.Fast
	db "FAST@"
.Mid
	db "MID @"
.Slow
	db "SLOW@"
; e4346


GetTextSpeed: ; e4346
	ld a, [Options] ; This converts the number of frames, to 0, 1, 2, 3 representing speed
	and 7
	jr z, .inst ; 0 frames of delay is instant
	cp 5 ; 5 frames of delay is slow
	jr z, .slow
	cp 1 ; 1 frame of delay is fast
	jr z, .fast
	ld c, MED_TEXT ; set it to mid if not one of the above
	lb de, 1, 5
	ret
	
.inst
	ld c, INST_TEXT
	lb de, 5, 1
	ret

.slow
	ld c, SLOW_TEXT
	lb de, 3, 0
	ret

.fast
	ld c, FAST_TEXT
	lb de, 0, 3
	ret
; e4365


Options_BattleScene: ; e4365
	ld hl, Options
	ld a, [hJoyPressed]
	and (1 << D_LEFT_F) | (1 << D_RIGHT_F)
	jr nz, .ButtonPressed
	bit BATTLE_SCENE, [hl]
	jr z, .ToggleOn
	jr .ToggleOff

.ButtonPressed
	bit BATTLE_SCENE, [hl]
	jr z, .ToggleOff
	
.ToggleOn
	res BATTLE_SCENE, [hl]
	ld de, .On
	jr .Display

.ToggleOff
	set BATTLE_SCENE, [hl]
	ld de, .Off

.Display
	hlcoord 11, 7
	call PlaceString
	and a
	ret
; e4398

.On
	db "ON @"
.Off
	db "OFF@"
; e43a0


Options_BattleStyle: ; e43a0
	ld hl, Options
	ld a, [hJoyPressed]
	and (1 << D_LEFT_F) | (1 << D_RIGHT_F)
	jr nz, .ButtonPressed
	bit BATTLE_SHIFT, [hl]
	jr nz, .ToggleSet
	jr .ToggleShift

.ButtonPressed
	bit BATTLE_SHIFT, [hl]
	jr z, .ToggleSet

.ToggleShift
	res BATTLE_SHIFT, [hl]
	ld de, .Shift
	jr .Display

.ToggleSet
	set BATTLE_SHIFT, [hl]
	ld de, .Set

.Display
	hlcoord 11, 9
	call PlaceString
	and a
	ret
; e43d1

.Shift
	db "SHIFT@"
.Set
	db "SET  @"
; e43dd


Options_Sound: ; e43dd
	ld hl, Options
	ld a, [hJoyPressed]
	and (1 << D_LEFT_F) | (1 << D_RIGHT_F)
	jr nz, .ButtonPressed
	bit STEREO, [hl]
	jr nz, .ToggleStereo
	jr .ToggleMono

.ButtonPressed
	bit STEREO, [hl]
	jr z, .SetStereo

.SetMono
	res STEREO, [hl]
	call RestartMapMusic

.ToggleMono
	ld de, .Mono
	jr .Display

.SetStereo
	set STEREO, [hl]
	call RestartMapMusic

.ToggleStereo
	ld de, .Stereo

.Display
	hlcoord 11, 11
	call PlaceString
	and a
	ret
; e4416

.Mono
	db "MONO  @"
.Stereo
	db "STEREO@"
; e4424

Options_HoldToMash: ; e44c1
	ld hl, Options2
	ld a, [hJoyPressed]
	and (1 << D_LEFT_F) | (1 << D_RIGHT_F)
	jr nz, .ButtonPressed
	bit HOLD_TO_MASH, [hl]
	jr z, .ToggleOff
	jr nz, .ToggleOn

.ButtonPressed
	bit HOLD_TO_MASH, [hl]
	jr z, .ToggleOn

.ToggleOff
	res HOLD_TO_MASH, [hl]
	ld de, .Off
	jr .Display

.ToggleOn
	set HOLD_TO_MASH, [hl]
	ld de, .On

.Display
	hlcoord 11, 5
	call PlaceString
	and a
	ret
; e44f2

.Off
	db "OFF@"
.On
	db "ON @"
; e44fa

Options_MenuAccount: ; e44c1
	ld hl, Options2
	ld a, [hJoyPressed]
	and (1 << D_LEFT_F) | (1 << D_RIGHT_F)
	jr nz, .ButtonPressed
	bit MENU_ACCOUNT, [hl]
	jr nz, .ToggleOn
	jr .ToggleOff

.ButtonPressed
	bit MENU_ACCOUNT, [hl]
	jr z, .ToggleOn

.ToggleOff
	res MENU_ACCOUNT, [hl]
	ld de, .Off
	jr .Display

.ToggleOn
	set MENU_ACCOUNT, [hl]
	ld de, .On

.Display
	hlcoord 11, 13
	call PlaceString
	and a
	ret
; e44f2

.Off
	db "OFF@"
.On
	db "ON @"
; e44fa


Options_Frame: ; e44fa
	ld hl, TextBoxFrame
	ld a, [hJoyPressed]
	bit D_LEFT_F, a
	jr nz, .LeftPressed
	bit D_RIGHT_F, a
	jr nz, .RightPressed
	jr .UpdateFrame

.RightPressed
	ld a, [hl]
	inc a
	jr .Save

.LeftPressed
	ld a, [hl]
	dec a

.Save
	and $7
	ld [hl], a
	call LoadFontsExtra
	
.UpdateFrame: ; e4512
	ld a, [TextBoxFrame]
	hlcoord 16, 15 ; where on the screen the number is drawn
	add "1"
	ld [hl], a
	and a
	ret
; e4520

