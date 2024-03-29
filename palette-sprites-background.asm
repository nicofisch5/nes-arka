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
  .db $10, $03, %00000000, $20   ;ball
  ;There are 4 bytes per sprite, each on one line.

  ;Sprite Attributes
  ;76543210
  ;|||   ||
  ;|||   ++- Color Palette of sprite
  ;|||
  ;||+------ Priority (0: in front of background; 1: behind background)
  ;|+------- Flip sprite horizontally
  ;+-------- Flip sprite vertically

;background:
;  .db $00,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff  ;;row 1
;  .db $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$02,$ff,$ff,$ff,$ff,$ff,$ff,$00  ;;row 1

;attribute:
;  .db %00000000, %00000000, %00000000, %00000000
;  .db %00000000, %00000000, %00000000, %10101010


background:
  .db $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff  ;;row 1
  .db $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff  ;; usually invisible

  .db $00,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$03,$03,$ff  ;;row 2
  .db $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$02,$02,$00

  .db $00,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$03,$03,$ff  ;;row 3
  .db $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$02,$02,$00

  .db $00,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff  ;;row 4
  .db $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$00

  .db $00,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff  ;;row 5
  .db $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$00

  .db $00,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff  ;;row 6
  .db $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$02,$ff,$ff,$ff,$ff,$ff,$ff,$00

  .db $00,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff  ;;row 7
  .db $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$02,$ff,$ff,$ff,$ff,$ff,$ff,$00

  .db $00,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff  ;;row 8
  .db $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$02,$ff,$ff,$ff,$ff,$ff,$ff,$00

  .db $00,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff  ;;row 9
  .db $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$02,$ff,$ff,$ff,$ff,$ff,$ff,$00

  .db $00,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff  ;;row 10
  .db $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$02,$ff,$ff,$ff,$ff,$ff,$ff,$00

  .db $00,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff  ;;row 11
  .db $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$02,$ff,$ff,$ff,$ff,$ff,$ff,$00

  .db $00,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff  ;;row 12
  .db $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$02,$ff,$ff,$ff,$ff,$ff,$ff,$00

  .db $00,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff  ;;row 13
  .db $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$02,$ff,$ff,$ff,$ff,$ff,$ff,$00

  .db $00,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff  ;;row 14
  .db $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$02,$ff,$ff,$ff,$ff,$ff,$ff,$00

  .db $00,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff  ;;row 15
  .db $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$02,$ff,$ff,$ff,$ff,$ff,$ff,$00

  .db $00,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff  ;;row 16
  .db $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$02,$ff,$ff,$ff,$ff,$ff,$ff,$00

  .db $00,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff  ;;row 17
  .db $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$02,$ff,$ff,$ff,$ff,$ff,$ff,$00

  .db $00,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff  ;;row 18
  .db $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$02,$ff,$ff,$ff,$ff,$ff,$ff,$00

  .db $00,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff  ;;row 19
  .db $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$02,$ff,$ff,$ff,$ff,$ff,$ff,$00

  .db $00,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff  ;;row 20
  .db $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$02,$ff,$ff,$ff,$ff,$ff,$ff,$00

  .db $00,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff  ;;row 21
  .db $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$02,$ff,$ff,$ff,$ff,$ff,$ff,$00

  .db $00,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff  ;;row 22
  .db $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$02,$ff,$ff,$ff,$ff,$ff,$ff,$00

  .db $00,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff  ;;row 23
  .db $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$02,$ff,$ff,$ff,$ff,$ff,$ff,$00

  .db $00,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff  ;;row 24
  .db $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$02,$ff,$ff,$ff,$ff,$ff,$ff,$00

  .db $00,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff  ;;row 25
  .db $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$02,$ff,$ff,$ff,$ff,$ff,$ff,$00

  .db $00,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff  ;;row 26
  .db $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$02,$ff,$ff,$ff,$ff,$ff,$ff,$00

  .db $00,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff  ;;row 27
  .db $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$02,$ff,$ff,$ff,$ff,$ff,$ff,$00

  .db $00,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff  ;;row 28
  .db $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$02,$ff,$ff,$ff,$ff,$ff,$ff,$00

  .db $00,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff  ;;row 29
  .db $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$02,$ff,$ff,$ff,$ff,$ff,$ff,$00

  .db $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff  ;;row 30
  .db $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff  ;; usually invisible




attribute:  ;8 x 8 = 64 bytes
  .db %11111111, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00011011 ; 8
  .db %00000000, %01010101, %00000000, %00000000, %00000000, %00000000, %00000000, %00111111 ; 16
  .db %01010101, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %10101010 ; 24
  .db %01010101, %00010000, %01010000, %00010000, %00000000, %00000000, %00000000, %00110000 ; 32
  .db %00000000, %00010000, %01010000, %00010000, %00000000, %00000000, %00000000, %00110000
  .db %00000000, %00010000, %01010000, %00010000, %00000000, %00000000, %00000000, %00110000
  .db %00000000, %00010000, %01010000, %00010000, %00000000, %00000000, %00000000, %00110000
  .db %00000000, %00010000, %01010000, %00010000, %00000000, %00000000, %00000000, %00110000
