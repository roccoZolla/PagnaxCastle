// velocita sprite
float spriteSpeed = 1.0;

// movements
boolean moveUP;
boolean moveDOWN;
boolean moveRIGHT;
boolean moveLEFT;

boolean moveATCK;

int tilesize = 16;

//
int letterIndex = 0; // Indice della lettera corrente
boolean isTyping = true; // Indica se il testo sta ancora venendo digitato
int typingSpeed = 1; // Velocità di scrittura 2 quella ideale

// gestione comandi
void keyPressed() {
  if(key == 'z') {
    zoom = 5.0;
  }
  if (screen_state == GAME_SCREEN) {
    if (key == 'w' || key == 'W') {
      moveUP = true;
    } else if (key == 's' || key == 'S') {
      moveDOWN = true;
    } else if (key == 'a' || key == 'A') {
      moveLEFT = true;
    } else if (key == 'd' || key == 'D') {
      moveRIGHT = true;
    } else if (key == 'j' || key == 'J') {
      moveATCK = true;
    }
  } else {
    // premi qualsiasi tasto
    if (!isTyping) {
      switch(previous_state) {
      case STORY_SCREEN:
        screen_state = GAME_SCREEN;
        break;

      case GAME_SCREEN:
        screen_state = GAME_SCREEN;
        break;

      case WIN_SCREEN:
        screen_state = MENU_SCREEN;
        break;

      case LOSE_SCREEN:
        screen_state = MENU_SCREEN;
        break;
      }

      // reimposta le variabili
      letterIndex = 0;
      isTyping = true;
    }
  }
}

void keyReleased() {
  if (key == 'w' || key == 'W') {
    moveUP = false;
  } else if (key == 's' || key == 'S') {
    moveDOWN = false;
  } else if (key == 'a' || key == 'A') {
    moveLEFT = false;
  } else if (key == 'd' || key == 'D') {
    moveRIGHT = false;
  } else if (key == 'j' || key == 'J') {
    moveATCK = false;
  }
}

void handlePlayerMovement(Level currentLevel) {
  if (keyPressed) {
    float newX = p1.getPosition().x;
    float newY = p1.getPosition().y;

    if (moveUP) {
      newY -= spriteSpeed;
    }
    if (moveDOWN) {
      newY += spriteSpeed;
    }
    if (moveLEFT) {
      newX -= spriteSpeed;
    }
    if (moveRIGHT) {
      newX += spriteSpeed;
    }


    // Verifica se la nuova posizione è valida
    int roundedX = round(newX);
    int roundedY = round(newY);

    // check delle collisioni
    if (roundedX >= 0 && roundedX < currentLevel.getCols() && roundedY >= 0 && roundedY < currentLevel.getRows() &&
      currentLevel.getMap()[roundedX][roundedY] != 0 &&
      currentLevel.getMap()[roundedX][roundedY] != 4 &&
      currentLevel.getMap()[roundedX][roundedY] != 6 &&
      currentLevel.getMap()[roundedX][roundedY] != 7) {
      p1.getPosition().x = newX;
      p1.getPosition().y = newY;
    }
  }
}

void drawPlayerWeapon() {
  System.out.println("draw playerweapon");
  
  float weaponPosition = 0;
  if(moveRIGHT) weaponPosition = 10;
  else if(moveLEFT) weaponPosition = -10;
  
  PImage weaponImage = p1.getPlayerWeapon().getSprite();
  float imageX = (p1.getPosition().x * tilesize) + weaponPosition;
  float imageY = p1.getPosition().y * tilesize;
  float imageWidth = p1.getPlayerWeapon().getSprite().width;
  float imageHeight = p1.getPlayerWeapon().getSprite().height;
  
  
  gameScene.image(weaponImage, imageX, imageY, imageWidth, imageHeight);
}

// disegna i bordi delle celle su cui si trova il mouse
void drawCellBorders(float x, float y, Level currentLevel) {
  float leftX = x * currentLevel.getTileSize();
  float topY = y * currentLevel.getTileSize();
  float rightX = leftX + currentLevel.getTileSize();
  float bottomY = topY + currentLevel.getTileSize();

  noFill();
  if (currentLevel.getMap()[(int) x][(int) y] == 0) {
    stroke(255, 0, 0); // Rosso
  } else {
    stroke(255); // Bianco
  }
  rect(leftX, topY, rightX - leftX, bottomY - topY);
}
