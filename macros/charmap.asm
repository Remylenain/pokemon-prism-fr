MACRO ctxtmap
x = \2
___huffman_data_{02X:x} EQU %\3
___huffman_length_{02X:x} EQU strlen("\3")
	charmap \1, \2
ENDM

; Special compressed character prefixes
SPECIAL_16_HEADER EQUS "00010011010110101"
SPECIAL_64_HEADER EQUS "000100110101100"

; Control characters
LEAST_CONTROL_CHAR EQU $44

	ctxtmap "<EMON>",   $44, 10100100
	ctxtmap "<STRBF1>", $45, 00000111001000
	ctxtmap "<STRBF2>", $46, 00000111001001
	ctxtmap "<STRBF3>", $47, 1010011110010
	ctxtmap "<STRBF4>", $48, 1010011110011
	ctxtmap "<ENEMY>",  $49, 000101111
	ctxtmap "<BMON>",   $4a, 00101101
	ctxtmap "<PKMN>",   $4b, 1010011110000110
	ctxtmap "<SCROLL>", $4c, {SPECIAL_16_HEADER}0000
	ctxtmap "<POKE>",   $4d, 1010011110000111
	ctxtmap "<NEXT>",   $4e, 101001111000010
	ctxtmap "<LINE>",   $4f, 011110

	ctxtmap "@",        $50, 011100110000
	ctxtmap "<PARA>",   $51, 0000000
	ctxtmap "<PLAYER>", $52, 10100111100011
	ctxtmap "<RIVAL>",  $53, 000100110101111
	ctxtmap "#",        $54, 0000011100101
	ctxtmap "<CONT>",   $55, 0101010
	ctxtmap "<SDONE>",  $56, 10100111100010
	ctxtmap "<DONE>",   $57, 101001101
	ctxtmap "<PROMPT>", $58, 000001110011
	ctxtmap "<TARGET>", $59, 00010100
	ctxtmap "<USER>",   $5a, 01101100
	ctxtmap "<MINB>",   $5b, 011100110001
	ctxtmap "<......>", $5c, {SPECIAL_64_HEADER}000000
	ctxtmap "<TRNER>",  $5d, {SPECIAL_64_HEADER}000001
	ctxtmap "<ROCKET>", $5e, {SPECIAL_64_HEADER}000010
	ctxtmap "<LNBRK>",  $5f, {SPECIAL_64_HEADER}000011

LEAST_PLACEABLE_CHAR EQU $60

; Actual characters
; (values below LEAST_PLACEABLE_CHAR should not be passed to PlaceString,
;  since they will be considered control characters)

	; gfx/misc/stats_tiles.2bpp
	charmap "<BOLDP>",  $3e
	charmap "<NOPKRS>", $3f

	; gfx/font/battle_extra.1bpp
	charmap "<LV>",     $6e
	charmap "◀",        $71
	charmap "<ID>",     $73
	charmap "№",        $74
	charmap "_",        $76

	; engine/trainer_card.asm
	charmap "<THIN0>",  $c6
	charmap "<THIN1>",  $c7
	charmap "<THIN2>",  $c8
	charmap "<THIN3>",  $c9
	charmap "<THIN4>",  $ca
	charmap "<THIN5>",  $cb
	charmap "<THIN6>",  $cc
	charmap "<THIN7>",  $cd
	charmap "<THIN8>",  $ce
	charmap "<THIN9>",  $cf

; Actual characters
; (values below LEAST_TEXT_CHAR should not go in textboxes,
;  since sprites will appear through them)

LEAST_TEXT_CHAR EQU $7f

	; gfx/frames/space.2bpp
	ctxtmap " ",        $7f, 100

; Standard font characters

	ctxtmap "A",        $80, 101011
	ctxtmap "B",        $81, 00010010
	ctxtmap "C",        $82, 01101101
	ctxtmap "D",        $83, 11100000
	ctxtmap "E",        $84, 000101110
	ctxtmap "F",        $85, 01010011
	ctxtmap "G",        $86, 011000010
	ctxtmap "H",        $87, 0110001
	ctxtmap "I",        $88, 0111010
	ctxtmap "J",        $89, 00010011001
	ctxtmap "K",        $8a, 00010011000
	ctxtmap "L",        $8b, 11000111
	ctxtmap "M",        $8c, 00010101
	ctxtmap "N",        $8d, 000001111
	ctxtmap "O",        $8e, 0111011
	ctxtmap "P",        $8f, 11100001
	ctxtmap "Q",        $90, 0001001101010
	ctxtmap "R",        $91, 011100100
	ctxtmap "S",        $92, 0101000
	ctxtmap "T",        $93, 001010
	ctxtmap "U",        $94, 011100111
	ctxtmap "V",        $95, 00000111000
	ctxtmap "W",        $96, 0110111
	ctxtmap "X",        $97, 0001001101011011
	ctxtmap "Y",        $98, 011100101
	ctxtmap "Z",        $99, 000100110101110

	ctxtmap "(",        $9a, 1010000
	ctxtmap ")",        $9b, 1010001
	ctxtmap ":",        $9c, 01110001
	ctxtmap ";",        $9d, 00101111
	ctxtmap "[",        $9e, 011000011
	ctxtmap "]",        $9f, 011100000

	ctxtmap "a",        $a0, 1101
	ctxtmap "b",        $a1, 0101011
	ctxtmap "c",        $a2, 011001
	ctxtmap "d",        $a3, 11001
	ctxtmap "e",        $a4, 0011
	ctxtmap "f",        $a5, 110000
	ctxtmap "g",        $a6, 111001
	ctxtmap "h",        $a7, 01001
	ctxtmap "i",        $a8, 00011
	ctxtmap "j",        $a9, 1010011100
	ctxtmap "k",        $aa, 01010010
	ctxtmap "l",        $ab, 11101
	ctxtmap "m",        $ac, 011111
	ctxtmap "n",        $ad, 00100
	ctxtmap "o",        $ae, 00001
	ctxtmap "p",        $af, 0001000
	ctxtmap "q",        $b0, 00010110011
	ctxtmap "r",        $b1, 01011
	ctxtmap "s",        $b2, 01000
	ctxtmap "t",        $b3, 1011
	ctxtmap "u",        $b4, 011010
	ctxtmap "v",        $b5, 00000110
	ctxtmap "w",        $b6, 101010
	ctxtmap "x",        $b7, 1010011101
	ctxtmap "y",        $b8, 0000010
	ctxtmap "z",        $b9, 00010011011

	ctxtmap "…",        $ba, 10100111100000
	charmap "<...>",    $ba
	ctxtmap "<@>",      $bb, {SPECIAL_64_HEADER}000100
	ctxtmap "♥",        $bc, {SPECIAL_64_HEADER}000101
	ctxtmap "♦",        $bd, {SPECIAL_64_HEADER}000110
	ctxtmap "♠",        $be, {SPECIAL_64_HEADER}000111
	ctxtmap "♣",        $bf, {SPECIAL_64_HEADER}001000

	ctxtmap "<BLACK>",  $c0, {SPECIAL_64_HEADER}001001
	ctxtmap "<``>",     $c1, {SPECIAL_64_HEADER}001010
	ctxtmap "<''>",     $c2, {SPECIAL_64_HEADER}001011
	ctxtmap "<BOLDV>",  $c3, {SPECIAL_64_HEADER}001100 ; only used in battle/trainer_huds.asm
	ctxtmap "<BOLDS>",  $c4, {SPECIAL_64_HEADER}001101 ; only used in battle/trainer_huds.asm

	ctxtmap "< >",      $c5, {SPECIAL_64_HEADER}001110 ; for VWF text: narrow space

	; gfx/frames/*.1bpp
	charmap "┌",        $c5
	ctxtmap "─",        $c6, {SPECIAL_64_HEADER}001111
	ctxtmap "┐",        $c7, {SPECIAL_64_HEADER}010000
	ctxtmap "│",        $c8, {SPECIAL_64_HEADER}010001
	ctxtmap "└",        $c9, {SPECIAL_64_HEADER}010010
	ctxtmap "┘",        $ca, {SPECIAL_64_HEADER}010011

	; used in maps/PhanceroRoom.asm
	ctxtmap "<BOLDB>",  $cb, {SPECIAL_64_HEADER}010100
	ctxtmap "<DOT>",    $cc, {SPECIAL_64_HEADER}010101

	ctxtmap "'d",       $d0, 11000110
	ctxtmap "'l",       $d1, 011100001
	ctxtmap "'m",       $d2, 00101100
	ctxtmap "'r",       $d3, 00101110
	ctxtmap "'s",       $d4, 1100010
	ctxtmap "'t",       $d5, 101001100
	ctxtmap "'v",       $d6, 01100000

	ctxtmap "<9>",      $d7, {SPECIAL_16_HEADER}0001 ; necessary for trainer names, since "9" is $ff
	ctxtmap "<BLANK>",  $d8, {SPECIAL_16_HEADER}0010
	ctxtmap "▲",        $d9, {SPECIAL_16_HEADER}0011
	ctxtmap "%",        $da, 00010011010110100 ; unused?
	ctxtmap "+",        $db, {SPECIAL_64_HEADER}010110
	ctxtmap "<MINUS>",  $dc, {SPECIAL_64_HEADER}010111 ; unused?
	ctxtmap "<DOWN>",   $dd, {SPECIAL_64_HEADER}011000
	ctxtmap "<UP>",     $de, {SPECIAL_64_HEADER}011001
	ctxtmap "<LEFT>",   $df, {SPECIAL_64_HEADER}011010
	ctxtmap "'",        $e0, {SPECIAL_64_HEADER}011011
	charmap "<'>",      $e0
	ctxtmap "<PK>",     $e1, {SPECIAL_64_HEADER}011100
	ctxtmap "<MN>",     $e2, {SPECIAL_64_HEADER}011101
	ctxtmap "-",        $e3, 0000001

	ctxtmap "<PO>",     $e4, {SPECIAL_16_HEADER}0100
	ctxtmap "<KE>",     $e5, {SPECIAL_16_HEADER}0101

	ctxtmap "?",        $e6, 10100101
	ctxtmap "!",        $e7, 1110001
	ctxtmap ".",        $e8, 11110
	ctxtmap "&",        $e9, 000100111

	ctxtmap "é",        $ea, {SPECIAL_16_HEADER}0110
	ctxtmap "<RIGHT>",  $eb, {SPECIAL_16_HEADER}0111
	ctxtmap "▷",        $ec, {SPECIAL_16_HEADER}1000
	ctxtmap "▶",        $ed, {SPECIAL_16_HEADER}1001
	ctxtmap "▼",        $ee, {SPECIAL_16_HEADER}1010
	ctxtmap "♂",        $ef, {SPECIAL_16_HEADER}1011
	ctxtmap "¥",        $f0, {SPECIAL_16_HEADER}1100
	ctxtmap "×",        $f1, {SPECIAL_16_HEADER}1101
	ctxtmap "<SHINY>",  $f2, {SPECIAL_16_HEADER}1110
	ctxtmap "/",        $f3, 0000011101
	ctxtmap ",",        $f4, 11111
	ctxtmap "♀",        $f5, {SPECIAL_16_HEADER}1111

	ctxtmap "0",        $f6, 0001011000
	ctxtmap "1",        $f7, 0001011010
	ctxtmap "2",        $f8, 0111001101
	ctxtmap "3",        $f9, 00010110010
	ctxtmap "4",        $fa, 10100111111
	ctxtmap "5",        $fb, 0001011011
	ctxtmap "6",        $fc, 000100110100
	ctxtmap "7",        $fd, 10100111101
	ctxtmap "8",        $fe, 10100111110
	ctxtmap "9",        $ff, 01110011001
