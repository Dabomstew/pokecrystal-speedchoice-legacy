SRAMStatsFrameCount::
    ld hl, SRAMStatsFrameCount_
    jp SRAMStatsStart

SRAMStatsFrameCount_::
    ld hl, sSpeedchoiceFrameCount
    call FourBitIncrement
    ld hl, sSpeedchoiceOWFrameCount
    ld a, [hTimerType]
    sla a
    sla a
    add l
    ld l, a
    jr nc, .noOverflow
    inc h
.noOverflow
    call FourBitIncrement
    jp SRAMStatsEnd
    
SRAMStatsIncrement2Bit::
    ld hl, SRAMStatsIncrement2Bit_
    jp SRAMStatsStart
    
SRAMStatsIncrement2Bit_::
    ld h, d
    ld l, e
    call TwoBitIncrement
    jp SRAMStatsEnd
    
SRAMStatsIncrement4Bit::
    ld hl, SRAMStatsIncrement4Bit_
    jp SRAMStatsStart
    
SRAMStatsIncrement4Bit_::
    ld h, d
    ld l, e
    call FourBitIncrement
    jp SRAMStatsEnd

    
    
SRAMStatsStart::
; takes return address in hl
; check enable
    ld a, [hStatsDisabled]
    and a
    ret nz
; enable sram for stat tracking
    ld a, SRAM_ENABLE
	ld [MBC3SRamEnable], a
; backup old sram bank
    ld a, [hSRAMBank]
    push af
; switch to correct bank
    ld a, BANK(sSpeedchoiceStatsStart)
    ld [hSRAMBank], a
    ld [MBC3SRamBank], a
; done, move to actual code
    push hl
    ret
    
SRAMStatsEnd::
; restore old sram bank
    pop af
    ld [hSRAMBank], a
    ld [MBC3SRamBank], a
    ret
    
FourBitIncrement::
; address in hl
    inc [hl]
    ret nz
    inc hl
    inc [hl]
    ret nz
    inc hl
TwoBitIncrement::
    inc [hl]
    ret nz
    inc hl
    inc [hl]
    ret
