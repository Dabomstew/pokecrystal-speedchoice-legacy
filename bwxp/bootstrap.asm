BWXP_Bootstrap::
    push hl
    push bc
    ld hl, BWXP_EXPCalculation
    ld a, BANK(BWXP_EXPCalculation)
    rst FarCall
    pop bc
    pop hl
    jp BWXP_MainReturnPoint

