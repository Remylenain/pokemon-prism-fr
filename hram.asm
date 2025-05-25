SECTION "HRAM", HRAM

hPushOAM:: ds 5

hScriptVar:: db
hScriptHalfwordVar:: dw

hBankswitchLoadRoutine:: dw

hROMBankBackup:: db
hBuffer:: db
hLYOverrideStackCopyAmount:: db

hRTCDayHi:: db
hRTCDayLo:: db
hRTCHours:: db
hRTCMinutes:: db
hRTCSeconds:: db

	ds 2

hRTC::
hHours:: db
	ds 1
hMinutes:: db
	ds 1
hSeconds:: db
	ds 1
hRTCEnd::

	ds 1

hVBlankCounter:: db

	ds 1

hROMBank:: db
hVBlank:: db
hMapEntryMethod:: db
hMenuReturn:: db

	ds 1

hJoypadReleased:: db
hJoypadPressed:: db
hJoypadDown:: db
hJoypadSum:: db
hJoyReleased:: db
hJoyPressed:: db
hJoyDown:: db
hJoyLast:: db
hInMenu:: db

hDigitsFlags::
hScriptBuffer:: db

UNION
hPrinter:: db
hGraphicStartTile:: db
hMoveMon:: db
hMapObjectIndexBuffer:: db
hObjectStructIndexBuffer:: db
NEXTU
	ds 1
hMapBorderBlock:: db
hMapWidthPlus6:: db
hConnectionStripLength:: db
hConnectedMapWidth:: db
ENDU

UNION
; can only use the bytes reserved for hPredefTemp in contained functions, unless you know what you're doing
hPredefTemp:: dw
NEXTU
hBuffer2:: db
hBuffer3:: db
NEXTU
hLZAddress:: dw
NEXTU
hMonToStore:: db
hMonToCopy:: db
ENDU

UNION
hDividend:: ; length in b register, before 'predef Divide' (max 4 bytes)
hLongQuotient:: ; 4-byte result
hProduct:: db ; result (4 bytes long)
hMultiplicand:: ; 3 bytes long
hQuotient:: ds 3 ; result (3 bytes long)

hMultiplier:: ; 1 byte long
hDivisor:: ; 1 byte long (or 2 for DivideLong)
hRemainder:: dw ; 1 byte long after Divide, 2 bytes long after Divide16/DivideLong

hMathBuffer:: ds 4

NEXTU
hMetatileCountWidth:: db
hMetatileCountHeight:: db

NEXTU
	ds 1
hCurBitStream:: db
hCurSampVal:: db
hDEDNR51Mask:: db

NEXTU
hPrintNum1:: db
hPrintNum2:: db
hPrintNum3:: db
hPrintNum4:: db
hPrintNum5:: db
hPrintNum6:: db
hPrintNum7:: db
hPrintNum8:: db
hPrintNum9:: db
hPrintNum10:: db

NEXTU
	ds 6
hTitleCloudSCX:: db

NEXTU
	ds 6
hOriginBank:: db
hDestinationBank:: db
ENDU

UNION
hUsedSpriteIndex:: db
hUsedSpriteTile:: db
NEXTU
hCurSpriteXCoord:: db
hCurSpriteYCoord:: db
ENDU

UNION
hCurSpriteXPixel:: db
hCurSpriteYPixel:: db
hCurSpriteTile:: db
hCurSpriteOAMFlags:: db
NEXTU
hLoopCounter:: db
ENDU

hMoneyTemp:: ds 3

hCompressedTextBank:: db

hLYOverridesStart:: db
hLYOverridesEnd:: db
hTemp:: db

hSerialReceivedNewData:: db
hSerialConnectionStatus:: db
hSerialIgnoringInitialData:: db
hSerialSend:: db
hSerialReceive:: db

hSCX:: db
hSCY:: db
hWX:: db
hWY:: db
hTilesPerCycle:: db
hBGMapMode:: db
hBGMapHalf:: db
hBGMapAddress:: dw

hOAMUpdate:: db
hSPBuffer:: dw

hBGMapUpdate:: db
hBGMapTileCount:: db

	ds 1

hMapAnims:: db
hTileAnimFrame:: db

hLastTalked:: db

hRandom::
hRandomAdd:: db
hRandomSub:: db

hSecondsBackup:: db

hBattleTurn:: db

hCGBPalUpdate:: db
hCGB:: db

	ds 1

hDMATransfer:: db

hFarCallSavedA::
hHeldA:: db
hDelayFrameLY:: db
hClockResetTrigger:: db

hCrashRST:: db

	ds 3

hVBlankSavedA:: db

hRequested2bpp:: db
hRequested1bpp:: db
hRequestedVTileDest:: dw
hRequestedVTileSource:: dw

hDEDCryFlag:: db
hRunPicAnim:: db

; all used in vblank
hCrashSavedErrorCode::
hCrashSavedHL:: dw

hCrashSP:: dw

hCrashSavedA:: db
hPalTrick:: db
