// movements
boolean moveUP;
boolean moveDOWN;
boolean moveRIGHT;
boolean moveLEFT;

boolean moveATCK;    // attacco
boolean moveINTR;    // interazione
boolean moveUSE;     // utilizza

//
int letterIndex = 0; // Indice della lettera corrente
boolean isTyping = true; // Indica se il testo sta ancora venendo digitato
int typingSpeed = 1; // Velocità di scrittura 2 quella ideale

// gestione comandi
void keyPressed() {
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

// calcola la posizione di uno sprite all'interno della scena di gioco
// se lo sprite si trova al di fuori della scena lo sprite non viene renderizzato
boolean isInVisibleArea(PVector spritePosition) {
  // Calcola il rettangolo visibile
  int tileSize = currentLevel.tileSize;

  int startX = floor((camera.x / (tileSize * camera.zoom)));
  int startY = floor((camera.y / (tileSize * camera.zoom)));
  int endX = ceil((camera.x + gameScene.width) / (tileSize * camera.zoom));
  int endY = ceil((camera.y + gameScene.height) / (tileSize * camera.zoom));


  return (spritePosition.x >= startX && spritePosition.x <= endX && spritePosition.y >= startY && spritePosition.y <= endY);
}

void drawPlayerWeapon() {
  float weaponPosition = 10;
  if (moveRIGHT) weaponPosition = 10;
  else if (moveLEFT) weaponPosition = -10;

  PImage weaponImage = p1.weapon.sprite;
  float imageX = (p1.spritePosition.x * currentLevel.tileSize) + weaponPosition;
  float imageY = p1.spritePosition.y * currentLevel.tileSize;
  float imageWidth = p1.weapon.sprite.width;
  float imageHeight = p1.weapon.sprite.height;

  spritesLayer.image(weaponImage, imageX, imageY, imageWidth, imageHeight);
}
