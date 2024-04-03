; Check the state of the Left and Right button
CheckLeftbutton:
  LDY #0
  LDX #0
  LDA joypad1        ; Load controller state
  AND #BUTTON_LEFT   ; AND with LEFT button mask
  BNE CheckCollisionLeftWall
  RTS                ; Dont't do more

CheckCollisionLeftWall:   ; Stick is moving on the left, we check if collision with the wall
  LDA SPR_STICK_ADDR+3
  CMP #WALL_LIMIT_LEFT
  BEQ EndCheckLeftbutton  ; no code, just no move

MoveStickLeftLoop:        ; Stick is moving on the left
  LDA SPR_STICK_ADDR+3,y  ; load sprite X position
  SEC                     ; make sure the carry flag is clear
  SBC #$01                ; A = A - 1 ; One position left
  STA SPR_STICK_ADDR+3,y  ; save sprite X position
  INY                     ; add the offset of 4
  INY
  INY
  INY                     ; (one sprite is 4 bytes)
  INX
  CPX #$05                ; loop 5 times because of 5 sprites to move
  BNE MoveStickLeftLoop
  RTS                     ; Dont't do more

EndCheckLeftbutton:

CheckRightbutton:
  LDY #0
  LDX #0
  LDA joypad1         ; Load controller state
  AND #BUTTON_RIGHT   ; AND with RIGHT button mask
  BNE CheckCollisionRightWall
  RTS                 ; Dont't do more

CheckCollisionRightWall:   ; Stick is moving on the right, we check if collision with the wall
  LDA SPR_STICK_ADDR+3       ; load sprite X position
  CMP #(WALL_LIMIT_RIGHT-SPR_STICK_SIZE)    ; the stick is large, we check the wall with the right border by adding its size
  BEQ EndCheckRightbutton  ; no code, just no move

MoveStickRightLoop:
  LDA SPR_STICK_ADDR+3,y  ; load sprite X position
  CLC                     ; make sure the carry flag is clear
  ADC #$01                ; A = A + 1 ; One position right
  STA SPR_STICK_ADDR+3,y  ; save sprite X position
  INY                     ; add the offset of 4
  INY
  INY
  INY                     ; (one sprite is 4 bytes)
  INX
  CPX #$05                ; loop 5 time because of 5 sprites to move
  BNE MoveStickRightLoop
  RTS                     ; Dont't do more

EndCheckRightbutton:
  ; no code, just no move for the stick
