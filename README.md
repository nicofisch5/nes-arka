# arka

Arkanoid like, my NES first game and also the first time I am using Assembly since 20 years and my computer sciences training.

To compile use NESASM.

## Features

- Stick, which is a metasprite, located at the bottom of the screen
- Stick can move left & right
- Background is 2 walls left & right
- Stick can move left and right inside bounds
- Ball bouces on stick and walls
- First levels with bricks
- Ball bouces on bricks
- Ball get out of the bottom bounds
- End of level when all bricks have been collided
- States management: start, level, game over
- Start position of the ball is on the stick
- Second level

## What's next

- New levels
- Transition between levels
- Options (global)
  - an option is falling from a brick - needs to store which brick(s) contains an option
  - if collision between stick and option then event
- Option ballx3
  - 2 more balls are launched from the stick
  - a life is lost only when the last ball goes out of bounds
  - zefzef
- Option laser
