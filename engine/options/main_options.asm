MainOptionsString:: ; e4241
	db "TEXT SPEED<LNBRK>"
	db "        :<LNBRK>"
	db "HOLD TO MASH<LNBRK>"
	db "        :<LNBRK>"
	db "BATTLE SCENE<LNBRK>"
	db "        :<LNBRK>"
	db "BATTLE STYLE<LNBRK>"
	db "        :<LNBRK>"
	db "SOUND<LNBRK>"
	db "        :<LNBRK>"
	db "MENU ACCOUNT<LNBRK>"
	db "        :<LNBRK>"
	db "FRAME<LNBRK>"
	db "        :TYPE<LNBRK>"
	db "CANCEL@"
; e42d6

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
	and (1 << D_LEFT_F) | (1 << D_RIGHT_F)
	ld a, [hl]
	jr z, .GetText
	xor (1 << BATTLE_SCENE)
	ld [hl], a
.GetText
	bit BATTLE_SCENE, a
	ld de, .On
	jr z, .Display
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
	and (1 << D_LEFT_F) | (1 << D_RIGHT_F)
	ld a, [hl]
	jr z, .GetText
	xor (1 << BATTLE_SHIFT)
	ld [hl], a
.GetText
	bit BATTLE_SHIFT, a
	ld de, .Shift
	jr z, .Display
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
	and (1 << D_LEFT_F) | (1 << D_RIGHT_F)
	ld a, [hl]
	jr z, .GetText
	xor (1 << STEREO)
	ld [hl], a
	call RestartMapMusic
.GetText
	bit STEREO, a
	ld de, .Mono
	jr z, .Display
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
	and (1 << D_LEFT_F) | (1 << D_RIGHT_F)
	ld a, [hl]
	jr z, .GetText
	xor (1 << HOLD_TO_MASH)
	ld [hl], a
.GetText
	bit HOLD_TO_MASH, a
	ld de, .Off
	jr z, .Display
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
	and (1 << D_LEFT_F) | (1 << D_RIGHT_F)
	ld a, [hl]
	jr z, .GetText
	xor (1 << MENU_ACCOUNT)
	ld [hl], a
.GetText
	bit MENU_ACCOUNT, a
	ld de, .Off
	jr z, .Display
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

