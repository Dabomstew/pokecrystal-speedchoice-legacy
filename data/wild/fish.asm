FishGroups: ; 92488
	dbwww 50 percent + 1, FishGroupShore_Old,            FishGroupShore_Good,            FishGroupShore_Super
	dbwww 50 percent + 1, FishGroupOcean_Old,            FishGroupOcean_Good,            FishGroupOcean_Super
	dbwww 50 percent + 1, FishGroupLake_Old,             FishGroupLake_Good,             FishGroupLake_Super
	dbwww 50 percent + 1, FishGroupPond_Old,             FishGroupPond_Good,             FishGroupPond_Super
	dbwww 50 percent + 1, FishGroupDratini_Old,          FishGroupDratini_Good,          FishGroupDratini_Super
	dbwww 50 percent + 1, FishGroupQwilfish_Swarm_Old,   FishGroupQwilfish_Swarm_Good,   FishGroupQwilfish_Swarm_Super
	dbwww 50 percent + 1, FishGroupRemoraid_Swarm_Old,   FishGroupRemoraid_Swarm_Good,   FishGroupRemoraid_Swarm_Super
	dbwww 50 percent + 1, FishGroupGyarados_Old,         FishGroupGyarados_Good,         FishGroupGyarados_Super
	dbwww 50 percent + 1, FishGroupDratini_2_Old,        FishGroupDratini_2_Good,        FishGroupDratini_2_Super
	dbwww 50 percent + 1, FishGroupWhirlIslands_Old,     FishGroupWhirlIslands_Good,     FishGroupWhirlIslands_Super
	dbwww 50 percent + 1, FishGroupQwilfish_Old,         FishGroupQwilfish_Good,         FishGroupQwilfish_Super
	dbwww 50 percent + 1, FishGroupRemoraid_Old,         FishGroupRemoraid_Good,         FishGroupRemoraid_Super
	dbwww 50 percent + 1, FishGroupQwilfish_NoSwarm_Old, FishGroupQwilfish_NoSwarm_Good, FishGroupQwilfish_NoSwarm_Super

FishGroupShore_Old:: ; 924e3
	db  70 percent + 1, MAGIKARP,   10
	db  85 percent + 1, MAGIKARP,   10
	db 100 percent,     KRABBY,     10
FishGroupShore_Good: ; 924ec
	db  35 percent,     MAGIKARP,   20
	db  70 percent,     KRABBY,     20
	db  90 percent + 1, KRABBY,     20
	db 100 percent,     0, 0
FishGroupShore_Super: ; 924f8
	db  40 percent,     KRABBY,     40
	db  70 percent,     0, 1
	db  90 percent + 1, KRABBY,     40
	db 100 percent,     KINGLER,    40

FishGroupOcean_Old: ; 92504
	db  70 percent + 1, MAGIKARP,   10
	db  85 percent + 1, MAGIKARP,   10
	db 100 percent,     TENTACOOL,  10
FishGroupOcean_Good: ; 9250d
	db  35 percent,     MAGIKARP,   20
	db  70 percent,     TENTACOOL,  20
	db  90 percent + 1, CHINCHOU,   20
	db 100 percent,     0, 2
FishGroupOcean_Super: ; 92519
	db  40 percent,     CHINCHOU,   40
	db  70 percent,     0, 3
	db  90 percent + 1, TENTACRUEL, 40
	db 100 percent,     LANTURN,    40

FishGroupLake_Old: ; 92525
	db  70 percent + 1, MAGIKARP,   10
	db  85 percent + 1, MAGIKARP,   10
	db 100 percent,     GOLDEEN,    10
FishGroupLake_Good: ; 9252e
	db  35 percent,     MAGIKARP,   20
	db  70 percent,     GOLDEEN,    20
	db  90 percent + 1, GOLDEEN,    20
	db 100 percent,     0, 4
FishGroupLake_Super: ; 9253a
	db  40 percent,     GOLDEEN,    40
	db  70 percent,     0, 5
	db  90 percent + 1, MAGIKARP,   40
	db 100 percent,     SEAKING,    40

FishGroupPond_Old: ; 92546
	db  70 percent + 1, MAGIKARP,   10
	db  85 percent + 1, MAGIKARP,   10
	db 100 percent,     POLIWAG,    10
FishGroupPond_Good: ; 9254f
	db  35 percent,     MAGIKARP,   20
	db  70 percent,     POLIWAG,    20
	db  90 percent + 1, POLIWAG,    20
	db 100 percent,     0, 6
FishGroupPond_Super: ; 9255b
	db  40 percent,     POLIWAG,    40
	db  70 percent,     0, 7
	db  90 percent + 1, MAGIKARP,   40
	db 100 percent,     POLIWAG,    40

FishGroupDratini_Old: ; 92567
	db  70 percent + 1, MAGIKARP,   10
	db  85 percent + 1, MAGIKARP,   10
	db 100 percent,     MAGIKARP,   10
FishGroupDratini_Good: ; 92570
	db  35 percent,     MAGIKARP,   20
	db  70 percent,     MAGIKARP,   20
	db  90 percent + 1, MAGIKARP,   20
	db 100 percent,     0, 8
FishGroupDratini_Super: ; 9257c
	db  40 percent,     MAGIKARP,   40
	db  70 percent,     0, 9
	db  90 percent + 1, MAGIKARP,   40
	db 100 percent,     DRAGONAIR,  40

FishGroupQwilfish_Swarm_Old: ; 92588
	db  70 percent + 1, MAGIKARP,   5
	db  85 percent + 1, MAGIKARP,   5
	db 100 percent,     QWILFISH,   5
FishGroupQwilfish_Swarm_Good: ; 92591
	db  35 percent,     MAGIKARP,   20
	db  70 percent,     QWILFISH,   20
	db  90 percent + 1, QWILFISH,   20
	db 100 percent,     0, 10
FishGroupQwilfish_Swarm_Super: ; 9259d
	db  40 percent,     QWILFISH,   40
	db  70 percent,     0, 11
	db  90 percent + 1, QWILFISH,   40
	db 100 percent,     QWILFISH,   40

FishGroupRemoraid_Swarm_Old: ; 925a9
	db  70 percent + 1, MAGIKARP,   10
	db  85 percent + 1, MAGIKARP,   10
	db 100 percent,     REMORAID,   10
FishGroupRemoraid_Swarm_Good: ; 925b2
	db  35 percent,     MAGIKARP,   20
	db  70 percent,     REMORAID,   20
	db  90 percent + 1, REMORAID,   20
	db 100 percent,     0, 12
FishGroupRemoraid_Swarm_Super: ; 925be
	db  40 percent,     REMORAID,   40
	db  70 percent,     0, 13
	db  90 percent + 1, REMORAID,   40
	db 100 percent,     REMORAID,   40

FishGroupGyarados_Old: ; 925ca
	db  70 percent + 1, MAGIKARP,   10
	db  85 percent + 1, MAGIKARP,   10
	db 100 percent,     MAGIKARP,   10
FishGroupGyarados_Good: ; 925d3
	db  35 percent,     MAGIKARP,   20
	db  70 percent,     MAGIKARP,   20
	db  90 percent + 1, MAGIKARP,   20
	db 100 percent,     0, 14
FishGroupGyarados_Super: ; 925df
	db  40 percent,     MAGIKARP,   40
	db  70 percent,     0, 15
	db  90 percent + 1, MAGIKARP,   40
	db 100 percent,     MAGIKARP,   40

FishGroupDratini_2_Old: ; 925eb
	db  70 percent + 1, MAGIKARP,   10
	db  85 percent + 1, MAGIKARP,   10
	db 100 percent,     MAGIKARP,   10
FishGroupDratini_2_Good: ; 925f4
	db  35 percent,     MAGIKARP,   10
	db  70 percent,     MAGIKARP,   10
	db  90 percent + 1, MAGIKARP,   10
	db 100 percent,     0, 16
FishGroupDratini_2_Super: ; 92600
	db  40 percent,     MAGIKARP,   10
	db  70 percent,     0, 17
	db  90 percent + 1, MAGIKARP,   10
	db 100 percent,     DRAGONAIR,  10

FishGroupWhirlIslands_Old: ; 9260c
	db  70 percent + 1, MAGIKARP,   10
	db  85 percent + 1, MAGIKARP,   10
	db 100 percent,     KRABBY,     10
FishGroupWhirlIslands_Good: ; 92615
	db  35 percent,     MAGIKARP,   20
	db  70 percent,     KRABBY,     20
	db  90 percent + 1, KRABBY,     20
	db 100 percent,     0, 18
FishGroupWhirlIslands_Super: ; 92621
	db  40 percent,     KRABBY,     40
	db  70 percent,     0, 19
	db  90 percent + 1, KINGLER,    40
	db 100 percent,     SEADRA,     40

FishGroupQwilfish_NoSwarm_Old:
FishGroupQwilfish_Old: ; 9262d
	db  70 percent + 1, MAGIKARP,   10
	db  85 percent + 1, MAGIKARP,   10
	db 100 percent,     TENTACOOL,  10
FishGroupQwilfish_NoSwarm_Good:
FishGroupQwilfish_Good: ; 92636
	db  35 percent,     MAGIKARP,   20
	db  70 percent,     TENTACOOL,  20
	db  90 percent + 1, TENTACOOL,  20
	db 100 percent,     0, 20
FishGroupQwilfish_NoSwarm_Super:
FishGroupQwilfish_Super: ; 92642
	db  40 percent,     TENTACOOL,  40
	db  70 percent,     0, 21
	db  90 percent + 1, MAGIKARP,   40
	db 100 percent,     QWILFISH,   40

FishGroupRemoraid_Old: ; 9264e
	db  70 percent + 1, MAGIKARP,   10
	db  85 percent + 1, MAGIKARP,   10
	db 100 percent,     POLIWAG,    10
FishGroupRemoraid_Good: ; 92657
	db  35 percent,     MAGIKARP,   20
	db  70 percent,     POLIWAG,    20
	db  90 percent + 1, POLIWAG,    20
	db 100 percent,     0, 6
FishGroupRemoraid_Super: ; 92663
	db  40 percent,     POLIWAG,    40
	db  70 percent,     0, 7
	db  90 percent + 1, MAGIKARP,   40
	db 100 percent,     REMORAID,   40
; 9266f


TimeFishGroups: ; 9266f
	;  day              nite
	db CORSOLA,    20,  STARYU,     20
	db CORSOLA,    40,  STARYU,     40
	db SHELLDER,   20,  SHELLDER,   20
	db SHELLDER,   40,  SHELLDER,   40
	db GOLDEEN,    20,  GOLDEEN,    20
	db GOLDEEN,    40,  GOLDEEN,    40
	db POLIWAG,    20,  POLIWAG,    20
	db POLIWAG,    40,  POLIWAG,    40
	db DRATINI,    20,  DRATINI,    20
	db DRATINI,    40,  DRATINI,    40
	db QWILFISH,   20,  QWILFISH,   20
	db QWILFISH,   40,  QWILFISH,   40
	db REMORAID,   20,  REMORAID,   20
	db REMORAID,   40,  REMORAID,   40
	db GYARADOS,   20,  GYARADOS,   20
	db GYARADOS,   40,  GYARADOS,   40
	db DRATINI,    10,  DRATINI,    10
	db DRATINI,    10,  DRATINI,    10
	db HORSEA,     20,  HORSEA,     20
	db HORSEA,     40,  HORSEA,     40
	db TENTACOOL,  20,  TENTACOOL,  20
	db TENTACOOL,  40,  TENTACOOL,  40
; 926c7
