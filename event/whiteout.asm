Script_BattleWhiteout:: ; 0x124c1
	callasm BattleBGMap
	jump Script_Whiteout
; 0x124c8

Script_OverworldWhiteout:: ; 0x124c8
	refreshscreen $0
	callasm OverworldBGMap

Script_Whiteout: ; 0x124ce
	writetext .WhitedOutText
	waitbutton
	special FadeOutPalettes
	pause 40
	special HealParty
	checkflag ENGINE_BUG_CONTEST_TIMER
	iftrue .bug_contest
	callasm HalveMoney
	callasm GetWhiteoutSpawn
	farscall Script_AbortBugContest
	special WarpToSpawnPoint
	newloadmap MAPSETUP_WARP
	end_all

.bug_contest
	jumpstd bugcontestresultswarp
; 0x124f5

.WhitedOutText: ; 0x124f5
	; is out of useable #MON!  whited out!
	text_jump UnknownText_0x1c0a4e
	db "@"
; 0x124fa

OverworldBGMap: ; 124fa
	call ClearPalettes
	call ClearScreen
	call WaitBGMap2
	call HideSprites
	call RotateThreePalettesLeft
	ret
; 1250a

BattleBGMap: ; 1250a
	ld b, SCGB_BATTLE_GRAYSCALE
	call GetSGBLayout
	call SetPalettes
	ret
; 12513

HalveMoney: ; 12513

; Halve the player's money.
; log old money
    ld hl, Money + 2
    ld de, Buffer3
    ld a, [hld]
    ld [de], a
    dec de
    ld a, [hld]
    ld [de], a
    dec de
    ld a, [hl]
    ld [de], a
; actually take the money - hl = Money right now
	ld a, [hl]
	srl a
	ld [hli], a
	ld a, [hl]
	rra
	ld [hli], a
	ld a, [hl]
	rra
	ld [hl], a
; calculate difference
; hl = Money+2 again
    ld a, [Buffer3]
    sub [hl]
    ld [Buffer3], a
    dec hl
    ld a, [Buffer2]
    sbc [hl]
    ld [Buffer2], a
    dec hl
    ld a, [Buffer1]
    sbc [hl]
    ld [Buffer1], a
    callba SRAMStatsBlackoutMoneyLoss
	ret
; 12527


GetWhiteoutSpawn: ; 12527
	ld a, [wLastSpawnMapGroup]
	ld d, a
	ld a, [wLastSpawnMapNumber]
	ld e, a
	callba IsSpawnPoint
	ld a, c
	jr c, .yes
	xor a ; SPAWN_HOME

.yes
	ld [wd001], a
	ret
; 1253d
