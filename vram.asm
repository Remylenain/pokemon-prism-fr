SECTION "VRAM0", VRAM, BANK [0]
vObjTiles:: ds $800
vFontTiles:: ds $800
vBGTiles:: ds $800

UNION ; 1: 9800
vBGMap:: ds $400
vWindowMap:: ds $400
NEXTU ; 1: 9800
	ds BG_MAP_WIDTH * SCREEN_HEIGHT
vCrashScreenTileMap:: ds SCREEN_WIDTH * SCREEN_HEIGHT
ENDU ; 1: 9800


SECTION "VRAM1", VRAM, BANK [1]
vStandingFrameTiles:: ds $800
vWalkingFrameTiles:: ds $800
vBGTiles2:: ds $800
vBGAttrs:: ds $400
vWindowAttrs:: ds $400
VRAM_End::
