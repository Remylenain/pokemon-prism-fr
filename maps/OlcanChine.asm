OlcanChine_MapScriptHeader:
;trigger count
	db 0
;callback count
	db 0

OlcanChine_MapEventHeader:: db 0, 0

.Warps
	db 2
	warp_def 23, 13, 3, OLCAN_CHINE_ENTRANCE
	warp_def  3,  5, 4, OLCAN_CHINE_ENTRANCE

.CoordEvents
	db 0

.BGEvents
	db 0

.ObjectEvents
	db 1
	person_event SPRITE_POKE_BALL, 17,  9, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_RED, PERSONTYPE_ITEMBALL, 1, CARBOS, EVENT_OLCAN_CHINE_ITEM_1
