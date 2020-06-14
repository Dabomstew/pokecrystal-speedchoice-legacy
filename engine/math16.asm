DivideLong::
; divides 4-byte hDividend by 2-byte hDivisor
; stores quotient in 4-byte hLongQuotient (hDividend, hQuotient - 1, hProduct, etc) and remainder in 2-byte hRemainder
	push bc
	push de
	push hl
	ld hl, hDividend
	ld a, [hli]
	ld b, a
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld d, a
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld l, [hl]
	ld h, a
	or l
	jp z, .division_by_zero
	push hl
	; clear quotient and remainder
	xor a
	ld hl, hLongQuotient
	rept 6
	ld [hli], a
	endr
	pop hl
	ld a, 32
	ld [hLoopCounter], a
.loop
	sla e
	rl d
	rl c
	rl b
	ld a, [hRemainder + 1]
	rla
	ld [hRemainder + 1], a
	ld a, [hRemainder]
	rla
	ld [hRemainder], a
	jr c, .sub
	ld a, [hRemainder + 1]
	sub l
	ld a, [hRemainder]
	sbc h
	ccf
	jr nc, .done
.sub
	ld a, [hRemainder + 1]
	sub l
	ld [hRemainder + 1], a
	ld a, [hRemainder]
	sbc h
	ld [hRemainder], a
	scf
.done
	ld a, [hLongQuotient + 3]
	rla
	ld [hLongQuotient + 3], a
	ld a, [hLongQuotient + 2]
	rla
	ld [hLongQuotient + 2], a
	ld a, [hLongQuotient + 1]
	rla
	ld [hLongQuotient + 1], a
	ld a, [hLongQuotient]
	rla
	ld [hLongQuotient], a
	ld a, [hLoopCounter]
	dec a
	ld [hLoopCounter], a
	jr nz, .loop
	pop hl
	pop de
	pop bc
	ret

.division_by_zero
	pop hl
	pop de
	pop bc
	ret
