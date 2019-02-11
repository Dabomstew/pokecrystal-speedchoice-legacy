PermaOptionsP3String::
	db "EASY TIN TOWER<LNBRK>"
	db "        :<LNBRK>"
	db "@"

PermaOptionsP3Pointers::
	dw Options_EasyTinTower
	dw Options_PermaOptionsPage

Options_EasyTinTower:
	ld hl, wPermanentOptions2
	and (1 << D_LEFT_F) | (1 << D_RIGHT_F)
	ld a, [hl]
	jr z, .GetText
	xor (1 << EASY_TIN_TOWER_F)
	ld [hl], a
.GetText
	bit EASY_TIN_TOWER_F, a
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
