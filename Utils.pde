// velocita sprite
float spriteSpeed = 1.0;

// movements
boolean moveUP;
boolean moveDOWN;
boolean moveRIGHT;
boolean moveLEFT;

boolean moveATCK;    // attacco
boolean moveINTR;    // interazione
boolean moveUSE;     // utilizza

int tilesize = 16;

//
int letterIndex = 0; // Indice della lettera corrente
boolean isTyping = true; // Indica se il testo sta ancora venendo digitato
int typingSpeed = 1; // Velocità di scrittura 2 quella ideale

// gestione comandi
void keyPressed() {
  if (key == 'z') {
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
    } else if (key == 'k' || key == 'K') {
      moveINTR = true;
    } else if (key == 'l' || key == 'L') {
      moveUSE = true;
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
  } else if (key == 'k' || key == 'K') {
    moveINTR = false;
  } else if (key == 'l' || key == 'L') {
    moveUSE = false;
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

boolean checkEnemyMove(float newX, float newY, Level currentLevel) {
  // Verifica se la nuova posizione è valida
  PVector playerPosition = p1.getPosition();
  int roundedX = round(newX);
  int roundedY = round(newY);

  if (roundedX == round(playerPosition.x) && roundedY == round(playerPosition.y)) {
    return false; // Il nemico non può andare nella stessa posizione del giocatore
  }

  if (roundedX >= 0 && roundedX < currentLevel.getCols() && roundedY >= 0 && roundedY < currentLevel.getRows() &&
    currentLevel.getMap()[roundedX][roundedY] != 0 &&
    currentLevel.getMap()[roundedX][roundedY] != 4 &&
    currentLevel.getMap()[roundedX][roundedY] != 6 &&
    currentLevel.getMap()[roundedX][roundedY] != 3) {
    return true;
  }

  return false;
}

void drawPlayerWeapon() {
  float weaponPosition = 10;
  if (moveRIGHT) weaponPosition = 10;
  else if (moveLEFT) weaponPosition = -10;

  PImage weaponImage = p1.getPlayerWeapon().getSprite();
  float imageX = (p1.getPosition().x * tilesize) + weaponPosition;
  float imageY = p1.getPosition().y * tilesize;
  float imageWidth = p1.getPlayerWeapon().getSprite().width;
  float imageHeight = p1.getPlayerWeapon().getSprite().height;

  spritesLayer.image(weaponImage, imageX, imageY, imageWidth, imageHeight);
}
