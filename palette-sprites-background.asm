palette:
  .db $0F,$1C,$2B,$39,  $0F,$36,$17,$22,  $0F,$1C,$15,$14,  $0F,$27,$07,$12   ;;background palette
  .db $0F,$1C,$2B,$39,  $0F,$02,$38,$3C,  $0F,$1C,$15,$14,  $0F,$02,$38,$3C   ;;sprite palette

sprites:
  ;   vert tile attr       horiz
  .db $D4, $00, %00000000, $70   ;stick left
  .db $D4, $01, %00000000, $79   ;stick middle
  .db $D4, $01, %00000000, $82   ;stick middle
  .db $D4, $01, %00000000, $8B   ;stick middle
  .db $D4, $00, %01000000, $94   ;stick right
  .db $10, $03, %00000000, $1   ;ball
  ;There are 4 bytes per sprite, each on one line.

  ;Sprite Attributes
  ;76543210
  ;|||   ||
  ;|||   ++- Color Palette of sprite
  ;|||
  ;||+------ Priority (0: in front of background; 1: behind background)
  ;|+------- Flip sprite horizontally
  ;+-------- Flip sprite vertically

background:
  .db $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff  ;;row 1
  .db $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff  ;; usually invisible

  .db $00,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff  ;;row 2
  .db $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$00

  .db $00,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$02,$ff,$02,$ff  ;;row 3
  .db $02,$ff,$02,$ff,$02,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$00

  .db $00,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$02,$ff,$02,$ff  ;;row 4
  .db $02,$ff,$02,$ff,$02,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$00

  .db $00,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$02,$ff,$02,$ff  ;;row 5
  .db $02,$ff,$02,$ff,$02,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$00

  .db $00,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$05,$ff,$02,$ff  ;;row 6
  .db $02,$ff,$02,$ff,$02,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$00

  .db $00,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$02,$ff,$02,$ff  ;;row 7
  .db $02,$ff,$02,$ff,$02,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$00

  .db $00,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff  ;;row 8
  .db $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$00

  .db $00,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff  ;;row 9
  .db $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$00

  .db $00,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff  ;;row 10
  .db $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$00

  .db $00,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff  ;;row 11
  .db $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$00

  .db $00,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff  ;;row 12
  .db $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$00

  .db $00,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff  ;;row 13
  .db $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$00

  .db $00,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff  ;;row 14
  .db $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$00

  .db $00,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff  ;;row 15
  .db $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$00

  .db $00,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff  ;;row 16
  .db $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$00

  .db $00,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff  ;;row 17
  .db $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$00

  .db $00,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff  ;;row 18
  .db $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$00

  .db $00,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff  ;;row 19
  .db $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$00

  .db $00,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff  ;;row 20
  .db $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$00

  .db $00,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff  ;;row 21
  .db $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$00

  .db $00,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff  ;;row 22
  .db $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$00

  .db $00,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff  ;;row 23
  .db $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$00

  .db $00,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff  ;;row 24
  .db $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$00

  .db $00,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff  ;;row 25
  .db $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$00

  .db $00,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff  ;;row 26
  .db $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$00

  .db $00,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff  ;;row 27
  .db $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$00

  .db $00,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff  ;;row 28
  .db $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$00

  .db $00,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff  ;;row 29
  .db $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$00

  .db $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff  ;;row 30
  .db $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff  ;; usually invisible

; Bricks table
bricks_mask:
  .db %00000000,%00000000,%00000000,%00000000 ; ligne 0
  .db %00000000,%00000000,%00000000,%00000000 ; ligne 1
  .db %00000000,%00001010,%10101000,%00000000 ; ligne 2
  .db %00000000,%00001010,%10101000,%00000000 ; ligne 3
  .db %00000000,%00001010,%10101000,%00000000 ; ligne 4
  .db %00000000,%00001010,%10101000,%00000000 ; ligne 5
  .db %00000000,%00001010,%10101000,%00000000 ; ligne 6
  .db %00000000,%00000000,%00000000,%00000000 ; ligne 7
  .db %00000000,%00000000,%00000000,%00000000 ; ligne 8
  .db %00000000,%00000000,%00000000,%00000000 ; ligne 9
  .db %00000000,%00000000,%00000000,%00000000 ; ligne 10
  .db %00000000,%00000000,%00000000,%00000000 ; ligne 11
  .db %00000000,%00000000,%00000000,%00000000 ; ligne 12
  .db %00000000,%00000000,%00000000,%00000000 ; ligne 13
  .db %00000000,%00000000,%00000000,%00000000 ; ligne 14
  .db %00000000,%00000000,%00000000,%00000000 ; ligne 15
  .db %00000000,%00000000,%00000000,%00000000 ; ligne 16
  .db %00000000,%00000000,%00000000,%00000000 ; ligne 17
  .db %00000000,%00000000,%00000000,%00000000 ; ligne 18
  .db %00000000,%00000000,%00000000,%00000000 ; ligne 19
  .db %00000000,%00000000,%00000000,%00000000 ; ligne 20
  .db %00000000,%00000000,%00000000,%00000000 ; ligne 21
  .db %00000000,%00000000,%00000000,%00000000 ; ligne 22
  .db %00000000,%00000000,%00000000,%00000000 ; ligne 23
  .db %00000000,%00000000,%00000000,%00000000 ; ligne 24
  .db %00000000,%00000000,%00000000,%00000000 ; ligne 25
  .db %00000000,%00000000,%00000000,%00000000 ; ligne 26
  .db %00000000,%00000000,%00000000,%00000000 ; ligne 27
  .db %00000000,%00000000,%00000000,%00000000 ; ligne 28
  .db %00000000,%00000000,%00000000,%00000000 ; ligne 29
  .db %00000000,%00000000,%00000000,%00000000 ; ligne 30

bits:
  .db %10000000
  .db %01000000
  .db %00100000
  .db %00010000
  .db %00001000
  .db %00000100
  .db %00000010
  .db %00000001

attribute:  ;8 x 8 = 64 bytes
  .db %11111111, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00011011 ; 8
  .db %00000000, %01010101, %00000000, %00000000, %00000000, %00000000, %00000000, %00111111 ; 16
  .db %01010101, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %10101010 ; 24
  .db %01010101, %00010000, %01010000, %00010000, %00000000, %00000000, %00000000, %00110000 ; 32
  .db %00000000, %00010000, %01010000, %00010000, %00000000, %00000000, %00000000, %00110000
  .db %00000000, %00010000, %01010000, %00010000, %00000000, %00000000, %00000000, %00110000
  .db %00000000, %00010000, %01010000, %00010000, %00000000, %00000000, %00000000, %00110000
  .db %00000000, %00010000, %01010000, %00010000, %00000000, %00000000, %00000000, %00110000
