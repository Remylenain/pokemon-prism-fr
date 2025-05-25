OlcanChineEntrance_MapScriptHeader:
;trigger count
	db 0
;callback count
	db 0

OlcanChineEntrance_MapEventHeader:: db 0, 0

.Warps
	db 4
	warp_def 15,  8, 1, TUNOD_WATERWAY
	warp_def  1,  4, 1, OLCAN_ISLE
	warp_def 21,  2, 1, OLCAN_CHINE
	warp_def  9,  6, 2, OLCAN_CHINE

.CoordEvents
	db 0

.BGEvents
	db 0

.ObjectEvents
	db 0
