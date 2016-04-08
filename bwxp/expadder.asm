BWXP_EXPAdderHook::
; copy back yield to multiplier fields
    ld a, [(EnemyMonMoves) + 2]
    ld [hProduct + 3], a
    ld a, [(EnemyMonMoves) + 1]
    ld [hProduct + 2], a
    ld a, [(EnemyMonMoves)]
    ld [hProduct + 1], a
    
; functions from original code, call them as is
    pop bc
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
    jr nc, .done
; maxed exp, set it to FFFFFF
    ld a, $ff
    ld [hli], a
    ld [hli], a
    ld [hl], a

.done
    jp BWXP_EXPAdderReturnPoint
    