MainOptionsP2String::
	db "PARKBALL EFFECT<LNBRK>"
	db "        :@"

MainOptionsP2Pointers::
	dw Options_ParkBallEffect
	dw Options_OptionsPage

Options_ParkBallEffect:
	ld hl, Options2
	and (1 << D_LEFT_F) | (1 << D_RIGHT_F)
	ld a, [hl]
	jr z, .GetText
	xor (1 << PARKBALL_EFFECT)
	ld [hl], a
.GetText
	bit PARKBALL_EFFECT, a
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
