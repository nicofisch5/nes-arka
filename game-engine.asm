GameEngine:
  LDA gamestate
  CMP #GAMESTATE_PLAYING
  BEQ GameEnginePlaying
  CMP #GAMESTATE_TITLE
  BEQ GameEngineTitle
  CMP #GAMESTATE_ENDLEVEL
  BEQ GameEngineEndLevel
  CMP #GAMESTATE_GAMEOVER
  BEQ GameEngineGameover

  GameEngineTitle:
    LDA #%00001010   ; disable sprites, enable background, no clipping on left side
    STA PPUMASK

    ; Check for start pressed
    JSR ReadController1
    LDA joypad1        ; Load controller state
    AND #BUTTON_START
    BNE StartGame
    JMP EndGameEngine
  EndGameEngineTitle:

  GameEngineEndLevel:
    LDA #%00001010   ; disable sprites, enable background, no clipping on left side
    STA PPUMASK
    ; TODO check for start pressed

    JMP EndGameEngine
  EndGameEngineEndLevel:

  GameEngineGameover:
    LDA #%00001010   ; disable sprites, enable background, no clipping on left side
    STA PPUMASK
    ; TODO check for start pressed

    JMP EndGameEngine
  EndGameEngineGameover:


  StartGame:
    LDA #GAMESTATE_PLAYING
    STA gamestate

    lda #%00000000 ; disable NMI
    sta $2000
    lda #%00000000 ; disable rendering
    sta $2001

    LDA #LOW(BG)
    STA pointerLo
    LDA #HIGH(BG)
    STA pointerHi
    JSR LoadBG

    JMP GameEnginePlaying
  EndStartGame:

  GameEnginePlaying:
