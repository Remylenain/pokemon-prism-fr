SpriteHeaders:
; Format:
;	Address
;	Length, Bank
;	Type, Palette

MACRO sprite_header
; pointer, length, type, palette
	dw \1
	db \2 * 4 tiles, BANK(\1)
	db \3, \4
ENDM

Player0Sprite:
	sprite_header Player0SpriteGFX, 3, WALKING_SPRITE, PAL_OW_PLAYER

Player0BikeSprite:
	sprite_header Player0BikeSpriteGFX, 3, WALKING_SPRITE, PAL_OW_PLAYER

GameboyKidSprite:
	sprite_header GameboyKidSpriteGFX, 3, STANDING_SPRITE, PAL_OW_GREEN

SilverSprite:
	sprite_header SilverSpriteGFX, 3, WALKING_SPRITE, PAL_OW_RED

OakSprite:
	sprite_header OakSpriteGFX, 3, WALKING_SPRITE, PAL_OW_BROWN

RedSprite:
	sprite_header RedSpriteGFX, 3, WALKING_SPRITE, PAL_OW_RED

BlueSprite:
	sprite_header BlueSpriteGFX, 3, WALKING_SPRITE, PAL_OW_RED

BillSprite:
	sprite_header BillSpriteGFX, 3, WALKING_SPRITE, PAL_OW_RED

ElderSprite:
	sprite_header ElderSpriteGFX, 3, WALKING_SPRITE, PAL_OW_BROWN

MuraSprite:
	sprite_header MuraSpriteGFX, 3, WALKING_SPRITE, PAL_OW_BROWN

KurtSprite:
	sprite_header KurtSpriteGFX, 3, WALKING_SPRITE, PAL_OW_BROWN

MomSprite:
	sprite_header MomSpriteGFX, 3, WALKING_SPRITE, PAL_OW_RED

BlaineSprite:
	sprite_header JoeSpriteGFX, 3, WALKING_SPRITE, PAL_OW_RED

RedsMomSprite:
	sprite_header RedsMomSpriteGFX, 3, WALKING_SPRITE, PAL_OW_RED

DaisySprite:
	sprite_header DaisySpriteGFX, 3, WALKING_SPRITE, PAL_OW_PURPLE

ElmSprite:
	sprite_header ElmSpriteGFX, 3, WALKING_SPRITE, PAL_OW_RED

SoraSprite:
	sprite_header SoraSpriteGFX, 3, STANDING_SPRITE, PAL_OW_BROWN

FalknerSprite:
	sprite_header FalknerSpriteGFX, 3, WALKING_SPRITE, PAL_OW_RED

WhitneySprite:
	sprite_header WhitneySpriteGFX, 3, WALKING_SPRITE, PAL_OW_RED

BugsySprite:
	sprite_header BugsySpriteGFX, 3, WALKING_SPRITE, PAL_OW_GREEN

MortySprite:
	sprite_header MortySpriteGFX, 3, WALKING_SPRITE, PAL_OW_BROWN

ChuckSprite:
	sprite_header AndreSpriteGFX, 3, WALKING_SPRITE, PAL_OW_BROWN

JasmineSprite:
	sprite_header JasmineSpriteGFX, 3, WALKING_SPRITE, PAL_OW_BLUE

PryceSprite:
	sprite_header PryceSpriteGFX, 3, WALKING_SPRITE, PAL_OW_RED

ClairSprite:
	sprite_header ClairSpriteGFX, 3, WALKING_SPRITE, PAL_OW_BLUE

KarpmanSprite:
	sprite_header KarpmanSpriteGFX, 3, WALKING_SPRITE, PAL_OW_BLUE

YukiSprite:
	sprite_header YukiSpriteGFX, 3, WALKING_SPRITE, PAL_OW_BLUE

DaichiSprite:
	sprite_header DaichiSpriteGFX, 3, WALKING_SPRITE, PAL_OW_BROWN

LilySprite:
	sprite_header LilySpriteGFX, 3, WALKING_SPRITE, PAL_OW_BLUE

LanceSprite:
	sprite_header LanceSpriteGFX, 3, WALKING_SPRITE, PAL_OW_RED

SparkySprite:
	sprite_header SparkySpriteGFX, 3, WALKING_SPRITE, PAL_OW_BROWN

LoisSprite:
	sprite_header LoisSpriteGFX, 3, WALKING_SPRITE, PAL_OW_GREEN

KojiSprite:
	sprite_header KojiSpriteGFX, 3, WALKING_SPRITE, PAL_OW_BROWN

SabrinaSprite:
	sprite_header SabrinaSpriteGFX, 3, WALKING_SPRITE, PAL_OW_RED

CooltrainerMSprite:
	sprite_header CooltrainerMSpriteGFX, 3, WALKING_SPRITE, PAL_OW_BLUE

CooltrainerFSprite:
	sprite_header CooltrainerFSpriteGFX, 3, WALKING_SPRITE, PAL_OW_BLUE

BugCatcherSprite:
	sprite_header BugCatcherSpriteGFX, 3, WALKING_SPRITE, PAL_OW_BLUE

TwinSprite:
	sprite_header TwinSpriteGFX, 3, WALKING_SPRITE, PAL_OW_RED

YoungsterSprite:
	sprite_header YoungsterSpriteGFX, 3, WALKING_SPRITE, PAL_OW_BLUE

LassSprite:
	sprite_header LassSpriteGFX, 3, WALKING_SPRITE, PAL_OW_RED

TeacherSprite:
	sprite_header TeacherSpriteGFX, 3, WALKING_SPRITE, PAL_OW_RED

BuenaSprite:
	sprite_header BuenaSpriteGFX, 3, WALKING_SPRITE, PAL_OW_BLUE

SuperNerdSprite:
	sprite_header SuperNerdSpriteGFX, 3, WALKING_SPRITE, PAL_OW_BROWN

RockerSprite:
	sprite_header RockerSpriteGFX, 3, WALKING_SPRITE, PAL_OW_GREEN

PokefanMSprite:
	sprite_header PokefanMSpriteGFX, 3, WALKING_SPRITE, PAL_OW_BROWN

PokefanFSprite:
	sprite_header PokefanFSpriteGFX, 3, WALKING_SPRITE, PAL_OW_BROWN

GrampsSprite:
	sprite_header GrampsSpriteGFX, 3, WALKING_SPRITE, PAL_OW_BROWN

GrannySprite:
	sprite_header GrannySpriteGFX, 3, WALKING_SPRITE, PAL_OW_BROWN

SwimmerGuySprite:
	sprite_header SwimmerGuySpriteGFX, 3, WALKING_SPRITE, PAL_OW_BLUE

SwimmerGirlSprite:
	sprite_header SwimmerGirlSpriteGFX, 3, WALKING_SPRITE, PAL_OW_BLUE

BigSnorlaxSprite:
	sprite_header BigSnorlaxSpriteGFX, 3, STANDING_SPRITE, PAL_OW_BLUE

SurfingPikachuSprite:
	sprite_header SurfingPikachuSpriteGFX, 3, WALKING_SPRITE, PAL_OW_RED

RocketSprite:
	sprite_header RocketSpriteGFX, 3, WALKING_SPRITE, PAL_OW_BROWN

RocketGirlSprite:
	sprite_header RocketGirlSpriteGFX, 3, WALKING_SPRITE, PAL_OW_BROWN

NurseSprite:
	sprite_header NurseSpriteGFX, 3, STANDING_SPRITE, PAL_OW_RED

LinkReceptionistSprite:
	sprite_header LinkReceptionistSpriteGFX, 3, WALKING_SPRITE, PAL_OW_RED

ClerkSprite:
	sprite_header ClerkSpriteGFX, 3, WALKING_SPRITE, PAL_OW_GREEN

FisherSprite:
	sprite_header FisherSpriteGFX, 3, WALKING_SPRITE, PAL_OW_BLUE

FishingGuruSprite:
	sprite_header FishingGuruSpriteGFX, 3, WALKING_SPRITE, PAL_OW_BLUE

ScientistSprite:
	sprite_header ScientistSpriteGFX, 3, WALKING_SPRITE, PAL_OW_BLUE

KimonoGirlSprite:
	sprite_header KimonoGirlSpriteGFX, 3, WALKING_SPRITE, PAL_OW_RED

SageSprite:
	sprite_header SageSpriteGFX, 3, WALKING_SPRITE, PAL_OW_BROWN

GoldSprite:
	sprite_header GoldSpriteGFX, 3, WALKING_SPRITE, PAL_OW_RED

GentlemanSprite:
	sprite_header GentlemanSpriteGFX, 3, WALKING_SPRITE, PAL_OW_BLUE

BlackBeltSprite:
	sprite_header BlackBeltSpriteGFX, 3, WALKING_SPRITE, PAL_OW_BROWN

ReceptionistSprite:
	sprite_header ReceptionistSpriteGFX, 3, WALKING_SPRITE, PAL_OW_BLUE

OfficerSprite:
	sprite_header OfficerSpriteGFX, 3, WALKING_SPRITE, PAL_OW_BLUE

CalSprite:
	sprite_header CalSpriteGFX, 3, WALKING_SPRITE, PAL_OW_BROWN

SlowpokeSprite:
	sprite_header SlowpokeSpriteGFX, 1, STILL_SPRITE, PAL_OW_RED

CaptainSprite:
	sprite_header CaptainSpriteGFX, 3, WALKING_SPRITE, PAL_OW_BROWN

BigLaprasSprite:
	sprite_header BigLaprasSpriteGFX, 3, STANDING_SPRITE, PAL_OW_BLUE

GymGuySprite:
	sprite_header GymGuySpriteGFX, 3, WALKING_SPRITE, PAL_OW_BLUE

SailorSprite:
	sprite_header SailorSpriteGFX, 3, WALKING_SPRITE, PAL_OW_BLUE

BikerSprite:
	sprite_header BikerSpriteGFX, 3, WALKING_SPRITE, PAL_OW_BROWN

PharmacistSprite:
	sprite_header PharmacistSpriteGFX, 3, WALKING_SPRITE, PAL_OW_BLUE

MonsterSprite:
	sprite_header MonsterSpriteGFX, 3, WALKING_SPRITE, PAL_OW_RED

FairySprite:
	sprite_header FairySpriteGFX, 3, WALKING_SPRITE, PAL_OW_RED

BirdSprite:
	sprite_header BirdSpriteGFX, 3, WALKING_SPRITE, PAL_OW_RED

DragonSprite:
	sprite_header DragonSpriteGFX, 3, WALKING_SPRITE, PAL_OW_RED

BigOnixSprite:
	sprite_header BigOnixSpriteGFX, 3, STANDING_SPRITE, PAL_OW_BROWN

N64Sprite:
	sprite_header N64SpriteGFX, 1, STILL_SPRITE, PAL_OW_BROWN

SudowoodoSprite:
	sprite_header SudowoodoSpriteGFX, 3, WALKING_SPRITE, PAL_OW_GREEN

SurfSprite:
	sprite_header SurfSpriteGFX, 3, WALKING_SPRITE, PAL_OW_BLUE

PokeBallSprite:
	sprite_header PokeBallSpriteGFX, 1, STILL_SPRITE, PAL_OW_RED

PokedexSprite:
	sprite_header PokedexSpriteGFX, 1, STILL_SPRITE, PAL_OW_BROWN

PaperSprite:
	sprite_header PaperSpriteGFX, 1, STILL_SPRITE, PAL_OW_BLUE

VirtualBoySprite:
	sprite_header VirtualBoySpriteGFX, 1, STILL_SPRITE, PAL_OW_RED

OldLinkReceptionistSprite:
	sprite_header OldLinkReceptionistSpriteGFX, 3, STANDING_SPRITE, PAL_OW_RED

RockSprite:
	sprite_header RockSpriteGFX, 1, STILL_SPRITE, PAL_OW_BROWN

BoulderSprite:
	sprite_header BoulderSpriteGFX, 1, STILL_SPRITE, PAL_OW_BROWN

SnesSprite:
	sprite_header SnesSpriteGFX, 1, STILL_SPRITE, PAL_OW_BLUE

FamicomSprite:
	sprite_header FamicomSpriteGFX, 1, STILL_SPRITE, PAL_OW_RED

FruitTreeSprite:
	sprite_header FruitTreeSpriteGFX, 1, STILL_SPRITE, PAL_OW_GREEN

GoldTrophySprite:
	sprite_header GoldTrophySpriteGFX, 1, STILL_SPRITE, PAL_OW_BROWN

SilverTrophySprite:
	sprite_header SilverTrophySpriteGFX, 1, STILL_SPRITE, PAL_OW_SILVER

Player1Sprite:
	sprite_header Player1SpriteGFX, 3, WALKING_SPRITE, PAL_OW_PLAYER

Player1BikeSprite:
	sprite_header Player1BikeSpriteGFX, 3, WALKING_SPRITE, PAL_OW_PLAYER

KurtOutsideSprite:
	sprite_header KurtOutsideSpriteGFX, 3, STANDING_SPRITE, PAL_OW_BROWN

SuicuneSprite:
	sprite_header SuicuneSpriteGFX, 1, STILL_SPRITE, PAL_OW_BLUE

EnteiSprite:
	sprite_header EnteiSpriteGFX, 1, STILL_SPRITE, PAL_OW_RED

RaikouSprite:
	sprite_header RaikouSpriteGFX, 1, STILL_SPRITE, PAL_OW_RED

StandingYoungsterSprite:
	sprite_header StandingYoungsterSpriteGFX, 3, STANDING_SPRITE, PAL_OW_BLUE

FireSprite:
	sprite_header FireSpriteGFX, 3, WALKING_SPRITE, PAL_OW_RED
MagikarpWalk:
	sprite_header MagikarpWalkGFX, 3, WALKING_SPRITE, PAL_OW_RED

;player

Player0SurfSprite:
	sprite_header Player0SurfSpriteGFX, 3, WALKING_SPRITE, PAL_OW_PLAYER
Player1SurfSprite:
	sprite_header Player1SurfSpriteGFX, 3, WALKING_SPRITE, PAL_OW_PLAYER
Player2Sprite:
	sprite_header Player2SpriteGFX, 3, WALKING_SPRITE, PAL_OW_PLAYER
Player2BikeSprite:
	sprite_header Player2BikeSpriteGFX, 3, WALKING_SPRITE, PAL_OW_PLAYER
Player2SurfSprite:
	sprite_header Player2SurfSpriteGFX, 3, WALKING_SPRITE, PAL_OW_PLAYER
Player3Sprite:
	sprite_header Player3SpriteGFX, 3, WALKING_SPRITE, PAL_OW_PLAYER
Player3BikeSprite:
	sprite_header Player3BikeSpriteGFX, 3, WALKING_SPRITE, PAL_OW_PLAYER
Player3SurfSprite:
	sprite_header Player3SurfSpriteGFX, 3, WALKING_SPRITE, PAL_OW_PLAYER
Player4Sprite:
	sprite_header Player4SpriteGFX, 3, WALKING_SPRITE, PAL_OW_PLAYER
Player4BikeSprite:
	sprite_header Player4BikeSpriteGFX, 3, WALKING_SPRITE, PAL_OW_PLAYER
Player4SurfSprite:
	sprite_header Player4SurfSpriteGFX, 3, WALKING_SPRITE, PAL_OW_PLAYER
Player5Sprite:
	sprite_header Player5SpriteGFX, 3, WALKING_SPRITE, PAL_OW_PLAYER
Player5BikeSprite:
	sprite_header Player5BikeSpriteGFX, 3, WALKING_SPRITE, PAL_OW_PLAYER
Player5SurfSprite:
	sprite_header Player5SurfSpriteGFX, 3, WALKING_SPRITE, PAL_OW_PLAYER
Player6Sprite:
	sprite_header Player6SpriteGFX, 3, WALKING_SPRITE, PAL_OW_PLAYER
Player6BikeSprite:
	sprite_header Player6BikeSpriteGFX, 3, WALKING_SPRITE, PAL_OW_PLAYER
Player6SurfSprite:
	sprite_header Player6SurfSpriteGFX, 3, WALKING_SPRITE, PAL_OW_PLAYER
Player7Sprite:
	sprite_header Player7SpriteGFX, 3, WALKING_SPRITE, PAL_OW_PLAYER
Player7BikeSprite:
	sprite_header Player7BikeSpriteGFX, 3, WALKING_SPRITE, PAL_OW_PLAYER
Player7SurfSprite:
	sprite_header Player7SurfSpriteGFX, 3, WALKING_SPRITE, PAL_OW_PLAYER
Player8Sprite:
	sprite_header Player8SpriteGFX, 3, WALKING_SPRITE, PAL_OW_PLAYER
Player8BikeSprite:
	sprite_header Player8BikeSpriteGFX, 3, WALKING_SPRITE, PAL_OW_PLAYER
Player8SurfSprite:
	sprite_header Player8SurfSpriteGFX, 3, WALKING_SPRITE, PAL_OW_PLAYER
Player9Sprite:
	sprite_header Player9SpriteGFX, 3, WALKING_SPRITE, PAL_OW_PLAYER
Player9BikeSprite:
	sprite_header Player9BikeSpriteGFX, 3, WALKING_SPRITE, PAL_OW_PLAYER
Player9SurfSprite:
	sprite_header Player9SurfSpriteGFX, 3, WALKING_SPRITE, PAL_OW_PLAYER
Player10Sprite:
	sprite_header Player10SpriteGFX, 3, WALKING_SPRITE, PAL_OW_PLAYER
Player10BikeSprite:
	sprite_header Player10BikeSpriteGFX, 3, WALKING_SPRITE, PAL_OW_PLAYER
Player10SurfSprite:
	sprite_header Player10SurfSpriteGFX, 3, WALKING_SPRITE, PAL_OW_PLAYER
Player11Sprite:
	sprite_header Player11SpriteGFX, 3, WALKING_SPRITE, PAL_OW_PLAYER
Player11BikeSprite:
	sprite_header Player11BikeSpriteGFX, 3, WALKING_SPRITE, PAL_OW_PLAYER
Player11SurfSprite:
	sprite_header Player11SurfSpriteGFX, 3, WALKING_SPRITE, PAL_OW_PLAYER

;new trainers
BoarderSprite:
	sprite_header BoarderSpriteGFX, 3, WALKING_SPRITE, PAL_OW_BLUE

PsychicSprite:
	sprite_header PsychicSpriteGFX, 3, WALKING_SPRITE, PAL_OW_PURPLE

SchoolboySprite:
	sprite_header SchoolboySpriteGFX, 3, WALKING_SPRITE, PAL_OW_BLUE

JugglerSprite:
	sprite_header JugglerSpriteGFX, 3, WALKING_SPRITE, PAL_OW_BLUE

BeautySprite:
	sprite_header BeautySpriteGFX, 3, WALKING_SPRITE, PAL_OW_BLUE

PokemaniacSprite:
	sprite_header PokemaniacSpriteGFX, 3, WALKING_SPRITE, PAL_OW_PURPLE

FirebreatherSprite:
	sprite_header FirebreatherSpriteGFX, 3, WALKING_SPRITE, PAL_OW_RED

HikerSprite:
	sprite_header HikerSpriteGFX, 3, WALKING_SPRITE, PAL_OW_BLUE

PicnickerSprite:
	sprite_header PicnickerSpriteGFX, 3, WALKING_SPRITE, PAL_OW_GREEN

CamperSprite:
	sprite_header CamperSpriteGFX, 3, WALKING_SPRITE, PAL_OW_GREEN

BirdkeeperSprite:
	sprite_header BirdkeeperSpriteGFX, 3, WALKING_SPRITE, PAL_OW_BLUE

;remade Gen 1
R_BeautySprite:
	sprite_header R_BeautySpriteGFX, 3, WALKING_SPRITE, PAL_OW_BLUE

R_BikerSprite:
	sprite_header R_BikerSpriteGFX, 3, WALKING_SPRITE, PAL_OW_BROWN

R_BirdkeeperSprite:
	sprite_header R_BirdkeeperSpriteGFX, 3, WALKING_SPRITE, PAL_OW_RED

R_BlackbeltSprite:
	sprite_header R_BlackbeltSpriteGFX, 3, WALKING_SPRITE, PAL_OW_RED

R_BugcatcherSprite:
	sprite_header R_BugcatcherSpriteGFX, 3, WALKING_SPRITE, PAL_OW_GREEN

R_BurglarSprite:
	sprite_header R_BurglarSpriteGFX, 3, WALKING_SPRITE, PAL_OW_GREEN

R_ChannelerSprite:
	sprite_header R_ChannelerSpriteGFX, 3, WALKING_SPRITE, PAL_OW_PURPLE

R_CooltrainerFSprite:
	sprite_header R_CooltrainerFSpriteGFX, 3, WALKING_SPRITE, PAL_OW_BLUE

R_CooltrainerMSprite:
	sprite_header R_CooltrainerMSpriteGFX, 3, WALKING_SPRITE, PAL_OW_BLUE

R_CueballSprite:
	sprite_header R_CueballSpriteGFX, 3, WALKING_SPRITE, PAL_OW_RED

R_EngineerSprite:
	sprite_header R_EngineerSpriteGFX, 3, WALKING_SPRITE, PAL_OW_BLUE

R_GentlemanSprite:
	sprite_header R_GentlemanSpriteGFX, 3, WALKING_SPRITE, PAL_OW_RED

R_FisherSprite:
	sprite_header R_FisherSpriteGFX, 3, WALKING_SPRITE, PAL_OW_GREEN

R_GamblerSprite:
	sprite_header R_GamblerSpriteGFX, 3, WALKING_SPRITE, PAL_OW_BROWN

R_HikerSprite:
	sprite_header R_HikerSpriteGFX, 3, WALKING_SPRITE, PAL_OW_GREEN

R_JrTrainerFSprite:
	sprite_header R_JrTrainerFSpriteGFX, 3, WALKING_SPRITE, PAL_OW_BROWN

R_JrTrainerMSprite:
	sprite_header R_JrTrainerMSpriteGFX, 3, WALKING_SPRITE, PAL_OW_BROWN

R_JugglerSprite:
	sprite_header R_JugglerSpriteGFX, 3, WALKING_SPRITE, PAL_OW_PURPLE

R_LassSprite:
	sprite_header R_LassSpriteGFX, 3, WALKING_SPRITE, PAL_OW_BLUE

R_ManiacSprite:
	sprite_header R_ManiacSpriteGFX, 3, WALKING_SPRITE, PAL_OW_GREEN

R_NerdSprite:
	sprite_header R_NerdSpriteGFX, 3, WALKING_SPRITE, PAL_OW_BLUE

R_PsychicSprite:
	sprite_header R_PsychicSpriteGFX, 3, WALKING_SPRITE, PAL_OW_BLUE

R_RockerSprite:
	sprite_header R_RockerSpriteGFX, 3, WALKING_SPRITE, PAL_OW_RED

R_SailorSprite:
	sprite_header R_SailorSpriteGFX, 3, WALKING_SPRITE, PAL_OW_BLUE

R_ScientistSprite:
	sprite_header R_ScientistSpriteGFX, 3, WALKING_SPRITE, PAL_OW_BLUE

R_SwimmerSprite:
	sprite_header R_SwimmerSpriteGFX, 3, WALKING_SPRITE, PAL_OW_BROWN

R_TamerSprite:
	sprite_header R_TamerSpriteGFX, 3, WALKING_SPRITE, PAL_OW_GREEN

R_YoungsterSprite:
	sprite_header R_YoungsterSpriteGFX, 3, WALKING_SPRITE, PAL_OW_RED

;additional trainer classes

MinerSprite:
	sprite_header MinerSpriteGFX, 3, WALKING_SPRITE, PAL_OW_BLUE

GuitaristFSprite:
	sprite_header GuitaristFSpriteGFX, 3, WALKING_SPRITE, PAL_OW_RED

DelinquentMSprite:
	sprite_header DelinquentMSpriteGFX, 3, WALKING_SPRITE, PAL_OW_BLUE

DelinquentFSprite:
	sprite_header DelinquentFSpriteGFX, 3, WALKING_SPRITE, PAL_OW_BLUE

CheerleaderSprite:
	sprite_header CheerleaderSpriteGFX, 3, WALKING_SPRITE, PAL_OW_PURPLE

;additional leaders and trainers
SherylSprite:
	sprite_header SherylSpriteGFX, 3, WALKING_SPRITE, PAL_OW_PURPLE

BrownSprite:
	sprite_header BrownSpriteGFX, 3, WALKING_SPRITE, PAL_OW_BROWN

Player12BikeSprite:
	sprite_header Player12BikeSpriteGFX, 3, WALKING_SPRITE, PAL_OW_PLAYER

Player12SurfSprite:
	sprite_header Player12SurfSpriteGFX, 3, WALKING_SPRITE, PAL_OW_PLAYER

OWEggSprite:
	sprite_header MonIcon253, 1, WALKING_SPRITE, PAL_OW_YELLOW

BruceSprite:
	sprite_header BruceSpriteGFX, 3, WALKING_SPRITE, PAL_OW_BLUE

ErnestSprite:
	sprite_header ErnestSpriteGFX, 3, WALKING_SPRITE, PAL_OW_RED

AyakaSprite:
	sprite_header AyakaSpriteGFX, 3, WALKING_SPRITE, PAL_OW_BLUE

GiovanniSprite:
	sprite_header GiovanniSpriteGFX, 3, WALKING_SPRITE, PAL_OW_BROWN

KrisSprite:
	sprite_header KrisSpriteGFX, 3, WALKING_SPRITE, PAL_OW_BLUE

RinjiSprite:
	sprite_header RinjiSpriteGFX, 3, WALKING_SPRITE, PAL_OW_GREEN

BlancheSprite:
	sprite_header BlancheSpriteGFX, 3, WALKING_SPRITE, PAL_OW_BLUE

CadenceSprite:
	sprite_header CadenceSpriteGFX, 3, WALKING_SPRITE, PAL_OW_RED

CandelaSprite:
	sprite_header CandelaSpriteGFX, 3, WALKING_SPRITE, PAL_OW_RED

BrooklynSprite:
	sprite_header BrooklynSpriteGFX, 3, WALKING_SPRITE, PAL_OW_PURPLE

JosiahSprite:
	sprite_header JosiahSpriteGFX, 3, WALKING_SPRITE, PAL_OW_RED

SilverLeaderSprite:
	sprite_header SilverLeaderSpriteGFX, 3, WALKING_SPRITE, PAL_OW_RED

EdisonSprite:
	sprite_header EdisonSpriteGFX, 3, WALKING_SPRITE, PAL_OW_BLUE
