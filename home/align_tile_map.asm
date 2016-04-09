AlignTileMap::
	ld a, [rSVBK]
	push af
	ld a, 4
	ld [rSVBK], a
	ld a, [hBGMapMode]
	bit 0, a
	ld hl, TileMap
	jr nz, .loadSP
	ld hl, AttrMap
.loadSP
	ld [hSPBuffer], sp
	ld sp, hl
; load hl with tilemap buffer
	ld hl, AlignedTileMap
; do stack copy similar to AutoBGMapTransfer
	ld bc, 32 - (20 - 1)
	ld a, 18
	
TransferBgRowsHBL:
	rept 20 / 2 - 1
	pop de
	ld [hl], e
	inc l
	ld [hl], d
	inc l
	endr

	pop de
	ld [hl], e
	inc l
	ld [hl], d

	add hl, bc
	dec a
	jr nz, TransferBgRowsHBL

	ld a, [hSPBuffer]
	ld l, a
	ld a, [hSPBuffer + 1]
	ld h, a
	ld sp, hl
	pop af
	ld [rSVBK], a
	ld a, 1
	ld [hHasAlignedBGMap], a
	ret
