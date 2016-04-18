PermaOptionsP2String:: ; e4241
	db "BETTER MARTS<LNBRK>"
	db "        :<LNBRK>"
	db "GOOD EARLY WILDS<LNBRK>"
	db "        :@"
; e42d6

PermaOptionsP2Pointers::
	dw Options_BetterMartsOption
	dw Options_GoodEarlyWildsOption
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

