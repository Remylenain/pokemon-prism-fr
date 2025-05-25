PachisiToreniaTiles::
	db PACHISI_NOTHING
	db PACHISI_GRASS
	db PACHISI_FORWARDS
	db PACHISI_NOTHING
	db PACHISI_NOTHING
	db PACHISI_NOTHING
	db PACHISI_MONEY
	db PACHISI_CAVE
	db PACHISI_FORWARDS
	db PACHISI_HEAL
	db PACHISI_GRASS
	db PACHISI_MUNCHER
	db PACHISI_ITEM
	db PACHISI_MUNCHER
	db PACHISI_WATER
	db PACHISI_FORWARDS
	db PACHISI_BACKWARDS
	db PACHISI_NOTHING
	db PACHISI_DEATH
	db PACHISI_WATER
	db PACHISI_DICE
	db PACHISI_MUNCHER
	db PACHISI_GRASS
	db PACHISI_GRASS
	db PACHISI_CAVE
	db PACHISI_HEAL
	db PACHISI_NOTHING
	db PACHISI_NOTHING
	db PACHISI_WATER
	db PACHISI_FORWARDS
	db PACHISI_MUNCHER
	db PACHISI_MONEY
	db PACHISI_WATER
	db PACHISI_MUNCHER
	db PACHISI_DICE
	db PACHISI_NOTHING
	db PACHISI_RANDOM
	db PACHISI_CAVE
	db PACHISI_DEATH
	db PACHISI_WATER
	db PACHISI_ITEM
	db PACHISI_MONEY
PachisiToreniaWarp1::
	db PACHISI_WARP_TORENIA_1
	db PACHISI_CAVE
	db PACHISI_BACKWARDS
	db PACHISI_NOTHING
	db PACHISI_MUNCHER
	db PACHISI_ITEM
	db PACHISI_DICE
	db PACHISI_CAVE
	db PACHISI_MONEY
	db PACHISI_NOTHING
	db PACHISI_RANDOM
	db PACHISI_WATER
	db PACHISI_BACKWARDS
	db PACHISI_HEAL
	db PACHISI_MUNCHER
	db PACHISI_CAVE
	db PACHISI_GRASS
	db PACHISI_ITEM
	db PACHISI_ITEM
	db PACHISI_DEATH
	db PACHISI_MONEY
	db PACHISI_HEAL
	db PACHISI_BACKWARDS
	db PACHISI_GRASS
	db PACHISI_NOTHING
	db PACHISI_GRASS
	db PACHISI_FORWARDS
PachisiToreniaWarp2::
	db PACHISI_WARP_TORENIA_2
	db PACHISI_MUNCHER
	db PACHISI_NOTHING
	db PACHISI_DICE
	db PACHISI_MONEY
	db PACHISI_GRASS
	db PACHISI_MUNCHER
	db PACHISI_ITEM
	db PACHISI_NOTHING
	db PACHISI_NOTHING
	db PACHISI_NOTHING
	db PACHISI_FORWARDS
	db PACHISI_BACKWARDS
	db PACHISI_MONEY
	db PACHISI_MONEY
	db PACHISI_RANDOM
	db PACHISI_MUNCHER
	db PACHISI_DICE
	db PACHISI_DEATH
	db PACHISI_BACKWARDS
	db PACHISI_DEATH
	db PACHISI_FORWARDS
	db PACHISI_HEAL
	db PACHISI_GRASS
	db PACHISI_MUNCHER
	db PACHISI_ITEM
	db PACHISI_CAVE
	db PACHISI_RANDOM
	db PACHISI_DEATH
	db PACHISI_DEATH
	db PACHISI_DEATH
	db PACHISI_FINISH
PachisiToreniaTilesEnd::

PachisiBotanTiles::
	db PACHISI_NOTHING
	db PACHISI_GRASS
	db PACHISI_ITEM
	db PACHISI_MONEY
	db PACHISI_WARP_BOTAN_RANDOM
	db PACHISI_WATER
	db PACHISI_BACKWARDS
	db PACHISI_MUNCHER
	db PACHISI_GRASS
	db PACHISI_MONEY
	db PACHISI_RANDOM
	db PACHISI_CAVE
	db PACHISI_RANDOM
	db PACHISI_MONEY
	db PACHISI_MONEY
	db PACHISI_ITEM
	db PACHISI_DICE
	db PACHISI_GRASS
	db PACHISI_NOTHING
	db PACHISI_GRASS
	db PACHISI_RANDOM
	db PACHISI_NOTHING
	db PACHISI_WARP_BOTAN_SECTION_2

	; Abuse the previous tile's direction to stop
	; going backwards
PachisiBotanSection2::
	db PACHISI_NOTHING
	db PACHISI_HEAL
	db PACHISI_CAVE
	db PACHISI_NOTHING
	db PACHISI_FORWARDS
	db PACHISI_BACKWARDS
	db PACHISI_MUNCHER
	db PACHISI_GRASS
	db PACHISI_GRASS
	db PACHISI_MUNCHER
	db PACHISI_DICE
	db PACHISI_DEATH
	db PACHISI_MONEY
	db PACHISI_WATER
	db PACHISI_BACKWARDS
	db PACHISI_NOTHING
	db PACHISI_RANDOM
	db PACHISI_MONEY
	db PACHISI_DEATH
	db PACHISI_WATER
	db PACHISI_GRASS
	db PACHISI_GRASS
	db PACHISI_ITEM
	db PACHISI_ITEM
	db PACHISI_GRASS
	db PACHISI_NOTHING
	db PACHISI_FORWARDS
	db PACHISI_CAVE
	db PACHISI_FORWARDS
	db PACHISI_WARP_BOTAN_ITEMS
	db PACHISI_FORWARDS
	db PACHISI_NOTHING
	db PACHISI_DICE
	db PACHISI_NOTHING
	db PACHISI_FORWARDS
	db PACHISI_HEAL
	db PACHISI_RANDOM
	db PACHISI_NOTHING
	db PACHISI_DICE
	db PACHISI_ITEM
	db PACHISI_WARP_BOTAN_SECTION_3

PachisiBotanSection3::
	db PACHISI_NOTHING
	db PACHISI_DICE
	db PACHISI_ITEM
	db PACHISI_WATER
	db PACHISI_GRASS
	db PACHISI_CAVE
	db PACHISI_NOTHING
	db PACHISI_FORWARDS
	db PACHISI_CAVE
	db PACHISI_RANDOM
	db PACHISI_CAVE
	rept 4
		db PACHISI_GRASS
	endr
	db PACHISI_FORWARDS
	db PACHISI_WARP_BOTAN_SECTION_2
	db PACHISI_MUNCHER
	db PACHISI_DEATH
	db PACHISI_DEATH
	db PACHISI_ITEM
	db PACHISI_ITEM
	db PACHISI_DEATH
	db PACHISI_DEATH
	db PACHISI_NOTHING
	db PACHISI_FORWARDS
	db PACHISI_CAVE
	db PACHISI_GRASS
	db PACHISI_MUNCHER
	db PACHISI_ITEM
	db PACHISI_WARP_BOTAN_SECTION_4

	; Abuse the previous tile's direction to stop
	; going backwards
PachisiBotanSection4::
	db PACHISI_NOTHING
	db PACHISI_MONEY
	db PACHISI_ITEM
	db PACHISI_NOTHING
	db PACHISI_BACKWARDS
	db PACHISI_MUNCHER
	db PACHISI_ITEM
	db PACHISI_WATER
	db PACHISI_DEATH
	db PACHISI_HEAL
	db PACHISI_CAVE
	db PACHISI_ITEM
	db PACHISI_DICE
	db PACHISI_MONEY
	db PACHISI_DEATH
	db PACHISI_DEATH
	db PACHISI_WATER
	db PACHISI_MUNCHER
	db PACHISI_GRASS
	db PACHISI_ITEM
	db PACHISI_FORWARDS
	db PACHISI_HEAL
	db PACHISI_MONEY
	db PACHISI_CAVE
	db PACHISI_RANDOM
	db PACHISI_CAVE
	db PACHISI_GRASS
	db PACHISI_GRASS
	db PACHISI_ITEM
	db PACHISI_DEATH
	db PACHISI_DEATH
	db PACHISI_DEATH
	db PACHISI_FINISH

	; Abuse the previous tile's direction to stop
	; going backwards
PachisiBotanRandom::
	db PACHISI_NOTHING
	rept 35
		db PACHISI_RANDOM
	endr
	db PACHISI_WARP_BOTAN_SECTION_2

PachisiBotanItem::
	db PACHISI_NOTHING
	rept 14
		db PACHISI_ITEM
	endr
	db PACHISI_WARP_BOTAN_SECTION_3

PachisiBotanTilesEnd::

	; no movement_step_end needed here because it's not possible to go backwards near the start
PachisiToreniaDirections::
	rept 9
		db movement_big_step_up
	endr
	db movement_big_step_right
	db movement_big_step_right
	db movement_big_step_down
	rept 4
		db movement_big_step_right
	endr
	rept 7
		db movement_big_step_up
	endr
	db movement_big_step_right
	db movement_big_step_right
	db movement_big_step_up
	db movement_big_step_up
	db movement_big_step_left
	db movement_big_step_left
	db movement_big_step_left
	db movement_big_step_down
	db movement_big_step_left
	db movement_big_step_left
	db movement_big_step_left
	rept 7
		db movement_big_step_up
	endr
	rept 2
		db movement_big_step_left
		db movement_big_step_left
		db movement_big_step_left
		db movement_big_step_down
		db movement_big_step_down
	endr
	rept 5
		db movement_big_step_left
	endr
	db movement_big_step_down
	db movement_big_step_left
	db movement_big_step_left
	db movement_big_step_left
	db movement_big_step_down
	db movement_big_step_left
	db movement_big_step_left
	db movement_big_step_down
	db movement_big_step_down
	db movement_big_step_left
	db movement_big_step_down
	db movement_big_step_down
	db movement_big_step_right
	rept 4
		db movement_big_step_down
	endr
	db movement_big_step_right
	db movement_big_step_right
	rept 5
		db movement_big_step_down
	endr
	db movement_big_step_left
	db movement_big_step_down
	db movement_big_step_down
	db movement_big_step_right
	db movement_big_step_down
	db movement_big_step_down
	db movement_big_step_right
	db movement_big_step_right
	db movement_big_step_up
	db movement_big_step_up
	db movement_big_step_up
	db movement_big_step_right
	db movement_big_step_right
	db movement_big_step_down
	db movement_big_step_down
	db movement_big_step_down
	rept 4
		db movement_big_step_right
	endr
	db movement_step_end
PachisiToreniaDirectionsEnd::

	; no movement_step_end needed here because it's not possible to go backwards near the start
PachisiBotanDirections::
	db movement_big_step_up
	db movement_big_step_up
	db movement_big_step_up
	rept 6
		db movement_big_step_left
	endr
	db movement_big_step_up
	db movement_big_step_up
	db movement_big_step_up
	db movement_big_step_left
	db movement_big_step_up
	db movement_big_step_left
	db movement_big_step_left
	db movement_big_step_up
	db movement_big_step_up
	rept 4
		db movement_big_step_right
	endr
	db movement_step_end

	; Abuse the previous db movement_step_end to stop
	; going backwards
PachisiBotanDirectionsSection2::
	db movement_big_step_left
	db movement_big_step_left
	db movement_big_step_left
	db movement_big_step_down
	db movement_big_step_left
	db movement_big_step_left
	rept 5
		db movement_big_step_down
	endr
	rept 6
		db movement_big_step_left
	endr
	rept 5
		db movement_big_step_up
	endr
	rept 2
		db movement_big_step_right
		db movement_big_step_right
		db movement_big_step_right
		db movement_big_step_up
	endr
	rept 5
		db movement_big_step_up
	endr
	rept 5
		db movement_big_step_right
	endr
	db movement_step_end

PachisiBotanDirectionsSection3::
	db movement_big_step_right
	db movement_big_step_right
	db movement_big_step_right
	db movement_big_step_down
	db movement_big_step_right
	db movement_big_step_right
	db movement_big_step_up
	db movement_big_step_right
	rept 6
		db movement_big_step_up
	endr
	db movement_big_step_right
	db movement_big_step_right
	db movement_big_step_down
	rept 7
		db movement_big_step_right
	endr
	db movement_big_step_up
	db movement_big_step_right
	db movement_big_step_right
	db movement_big_step_right
	db movement_big_step_down
	db movement_big_step_down
	db movement_step_end

	; Abuse the previous db movement_step_end to stop going backwards
PachisiBotanDirectionsSection4::
	db movement_big_step_right
	rept 8
		db movement_big_step_down
	endr
	rept 4
		db movement_big_step_left
	endr
	db movement_big_step_up
	rept 6
		db movement_big_step_left
	endr
	rept 8
		db movement_big_step_up
	endr
	rept 4
		db movement_big_step_right
	endr
	db movement_step_end

	; Abuse the previous db movement_step_end to stop going backwards
PachisiBotanDirectionsSectionRandom::
	db movement_big_step_up
	db movement_big_step_left
	db movement_big_step_left
	db movement_big_step_up
	db movement_big_step_up
	db movement_big_step_right
	db movement_big_step_up
	db movement_big_step_right
	db movement_big_step_up
	db movement_big_step_up
	rept 5
		db movement_big_step_right
	endr
	db movement_big_step_down
	db movement_big_step_right
	db movement_big_step_right
	db movement_big_step_right
	rept 7
		db movement_big_step_down
	endr
	db movement_big_step_left
	db movement_big_step_down
	db movement_big_step_left
	db movement_big_step_left
	db movement_big_step_left
	rept 5
		db movement_big_step_down
	endr
	db movement_step_end

PachisiBotanDirectionsSectionItem::
	db movement_big_step_up
	rept 13
		db movement_big_step_left
	endr
	db movement_big_step_down
	db movement_step_end

PachisiBotanDirectionsEnd::

assert (PachisiToreniaDirectionsEnd - PachisiToreniaDirections) == (PachisiToreniaTilesEnd - PachisiToreniaTiles)
assert (PachisiBotanDirectionsSection2 - PachisiBotanDirections) == (PachisiBotanSection2 - PachisiBotanTiles)
assert (PachisiBotanDirectionsSection3 - PachisiBotanDirections) == (PachisiBotanSection3 - PachisiBotanTiles)
assert (PachisiBotanDirectionsSection4 - PachisiBotanDirections) == (PachisiBotanSection4 - PachisiBotanTiles)
assert (PachisiBotanDirectionsSectionRandom - PachisiBotanDirections) == (PachisiBotanRandom - PachisiBotanTiles)
assert (PachisiBotanDirectionsSectionItem - PachisiBotanDirections) == (PachisiBotanItem - PachisiBotanTiles)
assert (PachisiBotanDirectionsEnd - PachisiBotanDirections) == (PachisiBotanTilesEnd - PachisiBotanTiles)

PachisiGrassPokemon::
	db TAILLOW
	db TAILLOW
	db TAILLOW
	rept 2
		db EXEGGCUTE
		db WEEPINBELL
		db PIDGEOTTO
		db PARAS
	endr
	db VULPIX
	db GROWLITHE
	db LUXIO
	db SCYTHER
	db ABSOL

PachisiWaterPokemon::
	rept 4
		db MAGIKARP
	endr
	db SLOWPOKE
	db SLOWPOKE
	db SLOWPOKE
	rept 2
		db GOLDEEN
		db TENTACOOL
		db SURSKIT
	endr
	db LOTAD
	db LOMBRE
	db GYARADOS

PachisiCavePokemon::
	rept 4
		db ZUBAT
	endr
	db GEODUDE
	db GEODUDE
	db GEODUDE
	rept 2
		db VULPIX
		db KOFFING
		db ONIX
		db RHYHORN
	endr
	db TORKOAL

PachisiItems:
	rept 5
		db POTION
	endr
	rept 6
		db SUPER_POTION
	endr
	db MOOMOO_MILK
	db SACRED_ASH
	rept 5
		db POKE_BALL
	endr
	db GREAT_BALL
	db GREAT_BALL
	db GREAT_BALL
	db ULTRA_BALL
	db ULTRA_BALL
	db TIMER_BALL
	db DIVE_BALL
	db FAST_BALL
	db FRIEND_BALL
	db QUICK_BALL
	rept 2
		db ANTIDOTE
		db BURN_HEAL
		db ICE_HEAL
		db AWAKENING
		db PARLYZ_HEAL
	endr
	db FULL_HEAL
	rept 2
		db X_ATTACK
		db X_DEFEND
		db X_SPEED
		db X_SP_ATK
	endr
	db ORAN_BERRY
	db SITRUS_BERRY
	db CHERI_BERRY
	db ASPEAR_BERRY
	db RAWST_BERRY
	db PERSIM_BERRY
	db CHESTO_BERRY
	db LUM_BERRY
	db LEPPA_BERRY
	db RARE_CANDY
	db THUNDERSTONE
	db THUNDERSTONE
	db LEAF_STONE
	db FIRE_STONE
	db WATER_STONE
	db GOLD_DUST
	db GOLD_DUST
