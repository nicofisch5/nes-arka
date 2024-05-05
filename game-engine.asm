GameEngine:
  LDA gamestate
  CMP #GAMESTATE_PLAYING
  BEQ GameEnginePlaying
  CMP #GAMESTATE_TITLE
  ;BEQ GameEngineTitle
  BEQ GameEngineEndLevel
  CMP #GAMESTATE_ENDLEVEL
  BEQ GameEngineEndLevel
  CMP #GAMESTATE_GAMEOVER
  BEQ GameEngineGameover

  GameEngineEndLevel:
    LDA #%00001010   ; disable sprites, enable background, no clipping on left side
    STA PPUMASK

    ; Check for start pressed
    JSR ReadController1
    LDA joypad1        ; Load controller state
    AND #BUTTON_START
    BNE StartNewLevel
    JMP EndGameEngine
  EndGameEngineEndLevel:

  GameEngineGameover:
    LDA #%00001010   ; disable sprites, enable background, no clipping on left side
    STA PPUMASK
    ; TODO check for start pressed

    JMP EndGameEngine
  EndGameEngineGameover:

  StartNewLevel:
    LDA #GAMESTATE_PLAYING
    STA gamestate

    lda #%00000000 ; disable NMI
    sta $2000
    lda #%00000000 ; disable rendering
    sta $2001

    INC level
    LDA level
    CMP #$01
    BEQ LoadLevel1
    CMP #$02
    BEQ LoadLevel2

    LoadLevel1:
      LDA #LOW(BGLevel1)
      STA pointerLo
      LDA #HIGH(BGLevel1)
      STA pointerHi

      LDA #LOW(bricksMaskLevel1)
      STA pointerLoMask
      LDA #HIGH(bricksMaskLevel1)
      STA pointerHiMask

      JSR PutBallOnStick
      JSR LoadBG
      JMP GameEnginePlaying
    EndLoadLevel1:

    LoadLevel2:
      LDA #LOW(BGLevel2)
      STA pointerLo
      LDA #HIGH(BGLevel2)
      STA pointerHi

      LDA #LOW(bricksMaskLevel2)
      STA pointerLoMask
      LDA #HIGH(bricksMaskLevel2)
      STA pointerHiMask

      JSR PutBallOnStick
      JSR LoadBG
      JMP GameEnginePlaying
    EndLoadLevel2:

  EndStartNewLevel:

  GameEnginePlaying:
