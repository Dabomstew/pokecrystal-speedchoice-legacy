; LCD handling

LCD:: ; 552
	push af
	ld a, [hFFC6]
	and a
	jr nz, LYOverrideCode
	ld a, [Requested2bpp]
	and a
	jr nz, _Serve2bppRequestHB
	ld a, [Requested1bpp]
	and a
	jr nz, _Serve1bppRequestHB
	ld a, [hBGMapMode]
	and a
	jr z, LCDDone
	ld a, [rLY]
	cp $80
	jr nz, LCDDone
	push hl
	push de
	push bc
	call AlignTileMap
	pop bc
	pop de
	pop hl
	jr LCDDone

; At this point it's assumed we're in WRAM bank 5!
LYOverrideCode::
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
; 568

_Serve2bppRequestHB:
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
	jr nz, RequestDone
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
	jr nz, RequestDone
	ld [hl], 4
	ld hl, Requested2bpp
	dec [hl]
RequestDone::
	pop de
	pop hl
	jr LCDDone
	
_Serve1bppRequestHB:
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
	jr nz, RequestDone
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
	ld a, [rSTAT]
	and a
	cp 3
	jr z, RequestDone
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
	jr nz, RequestDone
	ld [hl], 4
	ld hl, Requested1bpp
	dec [hl]
	jr RequestDone
	
Wait2bpp::
	ld a, [hFFC6]
	push af
	xor a
	ld [hFFC6], a
.loop
	halt
	nop
	ld a, [Requested2bpp]
	and a
	jr nz, .loop
	pop af
	ld [hFFC6], a
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
