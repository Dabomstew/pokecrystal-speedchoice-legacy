STATTYPE_2BYTE EQU $1
STATTYPE_4BYTE EQU $2
STATTYPE_MONEY EQU $3
STATTYPE_TIMER EQU $4
NUM_STAT_SCREENS EQU 7

PlaythroughStatsScreen::
    xor a
    ld [wOptionsMenuID], a
; stop stats (mainly frame counter) actually being counted
    inc a
    ld [hStatsDisabled], a
; Open SRAM for stats
    ld a, BANK(sStatsStart)
    call OpenSRAM
    ld hl, hInMenu
	ld a, [hl]
	push af
	ld [hl], $1
	call ClearBGPalettes
.pageLoad
	call RetrievePlaythroughStatsConfig
	hlcoord 0, 0
	ld b, 16
	ld c, 18
	call TextBox
; render title
    ld hl, wPlayStatsStringPtr
	ld a, [hli]
	ld e, a
	ld d, [hl]
	hlcoord 2, 2
	call PlaceString
    call RenderStats
; render page display
    hlcoord 1, 16
    ld [hl], "←"
    hlcoord 18, 16
    ld [hl], "→"
    hlcoord 4, 16
    ld de, PSPageStartString
    call PlaceString
    ld a, [wOptionsMenuID]
    add a, "1"
    hlcoord 9, 16
    ld [hli], a
    inc hl
    ld de, PSPageOfString
    call PlaceString
    hlcoord 14, 16
    ld a, NUM_STAT_SCREENS + "0"
    ld [hl], a
    call LoadFontsExtra
    ld a, 1
	ld [hBGMapMode], a
	call WaitBGMap
	ld b, SCGB_08
	call GetSGBLayout
	call SetPalettes
.joypad_loop
    call JoyTextDelay
    ld a, [hJoyPressed]
    ld b, a
    and D_LEFT
    jr nz, .scrollLeft
    ld a, b
    and D_RIGHT
    jr nz, .scrollRight
    ld a, b
    and START
    jr z, .joypad_loop
	pop af
	ld [hInMenu], a
	ld de, SFX_TRANSACTION
	call PlaySFX
	call WaitSFX
    call CloseSRAM
	ret
.scrollLeft
    ld a, [wOptionsMenuID]
    and a
    jr nz, .decreasePage
    ld a, NUM_STAT_SCREENS
.decreasePage
    dec a
.scrollDone
    ld [wOptionsMenuID], a
    jp .pageLoad
.scrollRight
    ld a, [wOptionsMenuID]
    inc a
    cp NUM_STAT_SCREENS
    jr nz, .scrollDone
    xor a
    jr .scrollDone
    
RenderStats::
; render stats themselves
    ld hl, wPlayStatsConfigPtr
    ld a, [hli]
    ld h, [hl]
    ld l, a
    xor a
    ld [wPlayStatsStatNum], a
.loop
    ld a, [hli]
    ld e, a
    ld a, [hli]
    ld d, a
    or e
    ret z
    push hl
    hlcoord 1, 4
    ld a, [wPlayStatsStatNum]
    sla a
    ld bc, SCREEN_WIDTH
    call AddNTimes
    push hl
    push bc
    call PlaceString
    pop bc
    pop hl
    add hl, bc
    ld d, h
    ld e, l
    pop hl
    ld a, [hli]
    ld [wStoredJumptableIndex], a
    cp STATTYPE_2BYTE
    push hl
    call z, Copy2ByteValueIntoPrintScratch
    call nz, Copy4ByteValueIntoPrintScratch
    pop hl
    ld a, [wStoredJumptableIndex]
    cp STATTYPE_2BYTE
    jr nz, .check_4byte
; print 2byte
    push hl
    ld h, d
    ld l, e
    ld bc, (SCREEN_WIDTH - 1 - 5 - 1)
    add hl, bc
    lb bc, 2, 5
    ld de, Buffer3
    call PrintNum
    pop hl
    jr .next_loop
.check_4byte
    cp STATTYPE_4BYTE
    jr nz, .check_money
; print 4byte
    push hl
    ld h, d
    ld l, e
    ld bc, (SCREEN_WIDTH - 1 - 7 - 1)
    add hl, bc
    lb bc, 3, 7
    ld de, Buffer2
    call PrintNum
    pop hl
    jr .next_loop
.check_money
    cp STATTYPE_MONEY
    jr nz, .print_timer
; print money (if only)
    push hl
    ld h, d
    ld l, e
    ld bc, (SCREEN_WIDTH - 1 - 8 - 1)
    add hl, bc
    lb bc, (PRINTNUM_MONEY | 3), 7
    ld de, Buffer2
    call PrintNum
    pop hl
    jr .next_loop
.print_timer
; print timer
    call PrintTimer
.next_loop
    inc hl
    inc hl
    ld a, [wPlayStatsStatNum]
    inc a
    ld [wPlayStatsStatNum], a
    jp .loop
    
PrintTimer:
    push hl
    ld h, d
    ld l, e
; frames/milliseconds part
; copy buffer1-4 into dividend
    ld a, [Buffer1]
    ld [hDividend], a
    ld a, [Buffer2]
    ld [hDividend+1], a
    ld a, [Buffer3]
    ld [hDividend+2], a
    ld a, [Buffer4]
    ld [hDividend+3], a
; divide by 60
    ld a, 60
    ld [hDivisor], a
    ld b, 4
    call Divide
; backup the result (seconds) for now
    ld a, [hDividend]
    push af
    ld a, [hQuotient]
    push af
    ld a, [hQuotient+1]
    push af
    ld a, [hQuotient+2]
    push af
; multiply remainder (frames) by 100
; hRemainder == hMultiplier so skip copying that
    xor a
    ld [hMultiplicand], a
    ld [hMultiplicand+1], a
    ld a, 100
    ld [hMultiplicand+2], a
    call Multiply
; divide by 60 to get a rough ms value
    ld a, 60
    ld [hDivisor], a
    ld b, 4
    call Divide
; move the result elsewhere since printnum uses the same hram
    ld a, [hQuotient+2]
    ld [Buffer1], a
; print the result (ms)
    ld bc, (SCREEN_WIDTH - 1 - 2 - 1)
    add hl, bc
    lb bc, (PRINTNUM_LEADINGZEROS | 1), 2
    ld de, Buffer1
    call PrintNum
; now for seconds onwards
; from here on out we just straight up print either the quotient or the remainder
; start by restoring the quotient
    pop af
    ld [hQuotient+2], a
    pop af
    ld [hQuotient+1], a
    pop af
    ld [hQuotient], a
    pop af
    ld [hDividend], a
; divide by 60 again for seconds
    ld a, 60
    ld [hDivisor], a
    ld b, 4
    call Divide
; backup the result again since printnum and multiply/divide share memory
    ld a, [hQuotient]
    push af
    ld a, [hQuotient+1]
    push af
    ld a, [hQuotient+2]
    push af
; move the printed number elsewhere
    ld a, [hRemainder]
    ld [Buffer1], a
; print seconds
    ld bc, -5
    add hl, bc
    lb bc, (PRINTNUM_LEADINGZEROS | 1), 2
    ld de, Buffer1
    call PrintNum
    ld [hl], "."
; restore result
    pop af
    ld [hQuotient+2], a
    pop af
    ld [hQuotient+1], a
    pop af
    ld [hQuotient], a
    xor a
    ld [hDividend], a
; divide by 60 again for minutes
    ld a, 60
    ld [hDivisor], a
    ld b, 4
    call Divide
; move the result elsewhere
    ld a, [hRemainder]
    ld [Buffer1], a
    ld a, [hQuotient+1]
    ld [Buffer2], a
    ld a, [hQuotient+2]
    ld [Buffer3], a
; print minutes from Buffer1
    ld bc, -5
    add hl, bc
    lb bc, (PRINTNUM_LEADINGZEROS | 1), 2
    ld de, Buffer1
    call PrintNum
    ld [hl], ":"
; print hours from Buffer2-3
    ld bc, -8
    add hl, bc
    lb bc, 2, 5
    ld de, Buffer2
    call PrintNum
    ld [hl], ":"
    pop hl
    ret
    
    
Copy2ByteValueIntoPrintScratch:
    xor a
    ld [Buffer1], a
    ld [Buffer2], a
    ld a, [hli]
    ld h, [hl]
    ld l, a
    ld a, [hli]
    ld [Buffer4], a
    ld a, [hl]
    ld [Buffer3], a
    ret

Copy4ByteValueIntoPrintScratch:
    ld a, [hli]
    ld h, [hl]
    ld l, a
    ld a, [hli]
    ld [Buffer4], a
    ld a, [hli]
    ld [Buffer3], a
    ld a, [hli]
    ld [Buffer2], a
    ld a, [hl]
    ld [Buffer1], a
    ret
    
    
    
RetrievePlaythroughStatsConfig::
	ld a, [wOptionsMenuID]
	ld hl, PlaythroughStatsScreens
	ld bc, wPlayStatsConfigEnds - wPlayStatsStringPtr
	call AddNTimes
	ld de, wPlayStatsStringPtr
	jp CopyBytes
    
stat_screen: MACRO
	dw (\1) ; title string
	dw (\2) ; pointer to config for entries on this page
ENDM

stat_screen_entry: MACRO
    dw (\1) ; description string
    db (\3) ; data type
    dw (\2) ; sram address
ENDM
    
PlaythroughStatsScreens::
    stat_screen PSTimersTitleString, PSTimersConfig
    stat_screen PSMovementTitleString, PSMovementConfig
    stat_screen PSBattle1TitleString, PSBattle1Config
    stat_screen PSBattle2TitleString, PSBattle2Config
    stat_screen PSBattle3TitleString, PSBattle3Config
    stat_screen PSMoneyItemsTitleString, PSMoneyItemsConfig
    stat_screen PSMiscTitleString, PSMiscConfig
    
PSTimersConfig::
    stat_screen_entry PSTimersOverallString, sStatsFrameCount, STATTYPE_TIMER
    stat_screen_entry PSTimersOverworldString, sStatsOWFrameCount, STATTYPE_TIMER
    stat_screen_entry PSTimersBattleString, sStatsBattleFrameCount, STATTYPE_TIMER
    stat_screen_entry PSTimersMenuString, sStatsMenuFrameCount, STATTYPE_TIMER
    stat_screen_entry PSTimersIntroString, sStatsIntrosFrameCount, STATTYPE_TIMER
    dw 0 ; end
    
PSMovementConfig::
    stat_screen_entry PSMovementTotalStepsString, sStatsStepCount, STATTYPE_4BYTE
    stat_screen_entry PSMovementStepsWalkedString, sStatsStepCountWalk, STATTYPE_4BYTE
    stat_screen_entry PSMovementStepsBikedString, sStatsStepCountBike, STATTYPE_4BYTE
    stat_screen_entry PSMovementStepsSurfedString, sStatsStepCountSurf, STATTYPE_4BYTE
    stat_screen_entry PSMovementBonksString, sStatsBonks, STATTYPE_2BYTE
    dw 0 ; end
    
PSBattle1Config::
    stat_screen_entry PSBattle1TotalBattlesString, sStatsBattles, STATTYPE_2BYTE
    stat_screen_entry PSBattle1WildBattlesString, sStatsWildBattles, STATTYPE_2BYTE
    stat_screen_entry PSBattle1TrainerBattlesString, sStatsTrainerBattles, STATTYPE_2BYTE
    stat_screen_entry PSBattle1BattlesFledFromString, sStatsBattlesFled, STATTYPE_2BYTE
    stat_screen_entry PSBattle1FailedEscapesString, sStatsFailedRuns, STATTYPE_2BYTE
    dw 0 ; end
    
PSBattle2Config::
    stat_screen_entry PSBattle2EnemyPKMNFaintedString, sStatsEnemyPokemonFainted, STATTYPE_2BYTE
    stat_screen_entry PSBattle2OwnPKMNFaintedString, sStatsPlayerPokemonFainted, STATTYPE_2BYTE
    stat_screen_entry PSBattle2SwitchoutsString, sStatsSwitchouts, STATTYPE_2BYTE
    stat_screen_entry PSBattle2BallsThrownString, sStatsBallsThrown, STATTYPE_2BYTE
    stat_screen_entry PSBattle2PokemonCaughtString, sStatsPokemonCaughtInBalls, STATTYPE_2BYTE
    dw 0 ; end
    
PSBattle3Config::
    stat_screen_entry PSBattle3TotalDmgDealtString, sStatsTotalDamageDealt, STATTYPE_4BYTE
    stat_screen_entry PSBattle3RealDmgDealtString, sStatsActualDamageDealt, STATTYPE_4BYTE
    stat_screen_entry PSBattle3TotalDmgTakenString, sStatsTotalDamageTaken, STATTYPE_4BYTE
    stat_screen_entry PSBattle3RealDmgTakenString, sStatsActualDamageTaken, STATTYPE_4BYTE
    dw 0
    
PSMoneyItemsConfig::
    stat_screen_entry PSMIMoneyMadeString, sStatsMoneyMade, STATTYPE_MONEY
    stat_screen_entry PSMIMoneySpentString, sStatsMoneySpent, STATTYPE_MONEY
    stat_screen_entry PSMIMoneyLostString, sStatsMoneyLost, STATTYPE_MONEY
    stat_screen_entry PSMIItemsPickedUpString, sStatsItemsPickedUp, STATTYPE_2BYTE
    stat_screen_entry PSMIItemsBoughtString, sStatsItemsBought, STATTYPE_2BYTE
    stat_screen_entry PSMIItemsSoldString, sStatsItemsSold, STATTYPE_2BYTE
    dw 0
    
PSMiscConfig::
    stat_screen_entry PSMiscSavesString, sStatsSaveCount, STATTYPE_2BYTE
    stat_screen_entry PSMiscReloadsString, sStatsReloadCount, STATTYPE_2BYTE
    stat_screen_entry PSMiscClockResetsString, sStatsClockResetCount, STATTYPE_2BYTE
    dw 0
    
PSTimersTitleString:
    db "TIMERS@"
PSTimersOverallString:
    db "TOTAL TIME:@"
PSTimersOverworldString:
    db "OVERWORLD TIME:@"
PSTimersBattleString:
    db "TIME IN BATTLE:@"
PSTimersMenuString:
    db "TIME IN MENUS:@"
PSTimersIntroString:
    db "TIME IN INTROS:@"
    
PSMovementTitleString:
    db "MOVEMENT@"
PSMovementTotalStepsString:
    db "TOTAL STEPS:@"
PSMovementStepsWalkedString:
    db "STEPS WALKED:@"
PSMovementStepsBikedString:
    db "STEPS BIKED:@"
PSMovementStepsSurfedString:
    db "STEPS SURFED:@"
PSMovementBonksString:
    db "BONKS:@"
    
PSBattle1TitleString:
    db "BATTLE 1@"
PSBattle1TotalBattlesString:
    db "TOTAL BATTLES:@"
PSBattle1WildBattlesString:
    db "WILD BATTLES:@"
PSBattle1TrainerBattlesString:
    db "TRAINER BATTLES:@"
PSBattle1BattlesFledFromString:
    db "BATTLES FLED FROM:@"
PSBattle1FailedEscapesString:
    db "FAILED ESCAPES:@"
    
PSBattle2TitleString:
    db "BATTLE 2@"
PSBattle2EnemyPKMNFaintedString:
    db "ENEMY <PK><MN> FAINTED:@"
PSBattle2OwnPKMNFaintedString:
    db "OWN <PK><MN> FAINTED:@"
PSBattle2SwitchoutsString:
    db "NUM. SWITCHOUTS:@"
PSBattle2BallsThrownString:
    db "BALLS THROWN:@"
PSBattle2PokemonCaughtString:
    db "<PK><MN> CAPTURED:@"
    
PSBattle3TitleString:
    db "BATTLE 3@"
PSBattle3TotalDmgDealtString:
    db "TOTAL DMG. DEALT:@"
PSBattle3RealDmgDealtString:
    db "REAL DMG. DEALT:@"
PSBattle3TotalDmgTakenString:
    db "TOTAL DMG. TAKEN:@"
PSBattle3RealDmgTakenString:
    db "REAL DMG. TAKEN:@"
    
PSMoneyItemsTitleString:
    db "MONEY & ITEMS@"
PSMIMoneyMadeString:
    db "MONEY MADE:@"
PSMIMoneySpentString:
    db "MONEY SPENT:@"
PSMIMoneyLostString:
    db "MONEY LOST:@"
PSMIItemsPickedUpString:
    db "ITEMS PICKED UP:@"
PSMIItemsBoughtString:
    db "ITEMS BOUGHT:@"
PSMIItemsSoldString:
    db "ITEMS SOLD:@"
    
    
PSMiscTitleString:
    db "MISC.@"
PSMiscSavesString:
    db "TIMES SAVED:@"
PSMiscReloadsString:
    db "SAVE RELOADS:@"
PSMiscClockResetsString:
    db "CLOCK RESETS:@"

PSPageStartString:
    db "PAGE@"
PSPageOfString:
    db "OF@"