; LCD handling

LCD:: ; 552
	push af
	ld a, [hFFC6]
	and a
	jr z, LCDTryServeRequests

; At this point it's assumed we're in WRAM bank 5!
	push bc
	ld a, [rLY]
	ld c, a
	ld b, LYOverrides >> 8
	ld a, [bc]
	ld b, a
	ld a, [hFFC6]
	ld c, a
	ld a, b
	ld [$ff00+c], a
	pop bc

LCDDone::
	pop af
	reti
	
LCDTryServeRequests
	call _Serve2bppRequestHB
	call _Serve1bppRequestHB
	jr LCDDone
; 568

_Serve2bppRequestHB:
	ld a, [Requested2bpp]
	and a
	ret z
	push hl
	push de
	ld hl, Requested2bppDest
	ld a, [hli]
	ld d, [hl]
	ld e, a
	ld hl, Requested2bppSource
	ld a, [hli]
	ld h, [hl]
	ld l, a
; Destination
	ld a, [rSTAT]
	and $3
	jr nz, .notDoneTile
rept 3
	ld a, [hli]
	ld [de], a
	inc e
endr
	ld a, [hli]
	ld [de], a
	inc de
	ld a, e
	ld [Requested2bppDest], a
	ld a, d
	ld [Requested2bppDest + 1], a
	ld a, l
	ld [Requested2bppSource], a
	ld a, h
	ld [Requested2bppSource + 1], a
	ld hl, Requested2bppQuarters
	dec [hl]
	jr nz, .notDoneTile
	ld [hl], 4
	ld hl, Requested2bpp
	dec [hl]
.notDoneTile
	pop de
	pop hl
	ret
	
_Serve1bppRequestHB:
	ld a, [Requested1bpp]
	and a
	ret z
	push hl
	push de
	ld hl, Requested1bppDest
	ld a, [hli]
	ld d, [hl]
	ld e, a
	ld hl, Requested1bppSource
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [rSTAT]
	and $3
	jr nz, .notDoneTile
; Destination
	ld a, [hli]
	ld [de], a
	inc e
	ld [de], a
	inc e
	ld a, [hli]
	ld [de], a
	inc e
	ld [de], a
	inc de
	ld a, e
	ld [Requested1bppDest], a
	ld a, d
	ld [Requested1bppDest + 1], a
	ld a, l
	ld [Requested1bppSource], a
	ld a, h
	ld [Requested1bppSource + 1], a
	ld hl, Requested1bppQuarters
	dec [hl]
	jr nz, .notDoneTile
	ld [hl], 4
	ld hl, Requested1bpp
	dec [hl]
.notDoneTile
	pop de
	pop hl
	ret
	


DisableLCD:: ; 568
; Turn the LCD off

; Don't need to do anything if the LCD is already off
	ld a, [rLCDC]
	bit 7, a ; lcd enable
	ret z

	xor a
	ld [rIF], a
	ld a, [rIE]
	ld b, a
	
; Disable VBlank
	res 0, a ; vblank
	ld [rIE], a

.wait
; Wait until VBlank would normally happen
	ld a, [rLY]
	cp 145
	jr nz, .wait

	ld a, [rLCDC]
	and %01111111 ; lcd enable off
	ld [rLCDC], a

	xor a
	ld [rIF], a
	ld a, b
	ld [rIE], a
	ret
; 58a


EnableLCD:: ; 58a
	ld a, [rLCDC]
	set 7, a ; lcd enable
	ld [rLCDC], a
	ret
; 591
