BWXP_EXPAddition::
; copy back yield to multiplier fields
    ld a, [BWXP_SCRATCH5B_1 + 2]
    ld [hProduct + 3], a
    ld a, [BWXP_SCRATCH5B_1 + 1]
    ld [hProduct + 2], a
    ld a, [BWXP_SCRATCH5B_1]
    ld [hProduct + 1], a
    
; functions from original code, call them as is
    call AnimateExpBar
	
    push bc
    call LoadTileMapToTempTileMap
    pop bc
; set hl = 3rd byte of party mon exp value (+10 from current bc)
    ld hl, $a
    add hl, bc
; add new exp
    ld d, [hl]
    ld a, [hProduct + 3]
    add d
    ld [hld], a
    
    ld d, [hl]
    ld a, [hProduct + 2]
    adc d
    ld [hld], a
    
    ld d, [hl]
    ld a, [hProduct + 1]
    adc d
    ld [hl], a
    ret nc
; maxed exp, set it to FFFFFF
    ld a, $ff
    ld [hli], a
    ld [hli], a
    ld [hl], a
	ret

