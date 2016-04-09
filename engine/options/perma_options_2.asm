PermaOptionsP2String:: ; e4241
	db "ESCAPE OPTION<LNBRK>"
	db "        :@"
; e42d6

PermaOptionsP2Pointers::
	dw Options_EscapeOption
	dw Options_PermaOptionsPage
	
Options_EscapeOption:
	ld hl, wPermanentOptions2
	and (1 << D_LEFT_F) | (1 << D_RIGHT_F)
	ld a, [hl]
	jr z, .GetText
	xor (1 << ESCAPE_OPTION_F)
	ld [hl], a
.GetText
	bit ESCAPE_OPTION_F, a
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

