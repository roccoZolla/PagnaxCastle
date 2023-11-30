int letterIndex = 0; // Indice della lettera corrente
boolean isTyping = true; // Indica se il testo sta ancora venendo digitato
int typingSpeed = 1; // Velocità di scrittura 2 quella ideale

// gestione comandi
void keyPressed() {
  if (screen_state == GAME_SCREEN) {
    if (key == 'w' || key == 'W') {
      p1.moveUP = true;
    } else if (key == 's' || key == 'S') {
      p1.moveDOWN = true;
    } else if (key == 'a' || key == 'A') {
      p1.moveLEFT = true;
    } else if (key == 'd' || key == 'D') {
      p1.moveRIGHT = true;
    } else if (key == 'j' || key == 'J') {
      p1.moveATCK = true;
    } else if (key == 'k' || key == 'K') {
      p1.moveINTR = true;
    } else if (key == 'l' || key == 'L') {
      p1.moveUSE = true;
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
    p1.moveUP = false;
  } else if (key == 's' || key == 'S') {
    p1.moveDOWN = false;
  } else if (key == 'a' || key == 'A') {
    p1.moveLEFT = false;
  } else if (key == 'd' || key == 'D') {
    p1.moveRIGHT = false;
  } else if (key == 'j' || key == 'J') {
    p1.moveATCK = false;
  } else if (key == 'k' || key == 'K') {
    p1.moveINTR = false;
  } else if (key == 'l' || key == 'L') {
    p1.moveUSE = false;
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
  if (p1.moveRIGHT) weaponPosition = 10;
  else if (p1.moveLEFT) weaponPosition = -10;

  PImage weaponImage = p1.weapon.sprite;
  float imageX = (p1.spritePosition.x * currentLevel.tileSize) + weaponPosition;
  float imageY = p1.spritePosition.y * currentLevel.tileSize;
  float imageWidth = p1.weapon.sprite.width;
  float imageHeight = p1.weapon.sprite.height;
  
  spritesLayer.noFill(); // Nessun riempimento
  spritesLayer.stroke(255, 146, 240); // Colore del bordo bianco
  spritesLayer.rect(imageX, imageY, imageWidth, imageHeight);
  
  spritesLayer.image(weaponImage, imageX, imageY, imageWidth, imageHeight);
}

// controlla che le coordinate si trovino all'interno della mappa
boolean isWithinMapBounds(int x, int y) {
    return x >= 0 && x < currentLevel.cols && y >= 0 && y < currentLevel.rows;
}

// verifica se è un tile di collisione
boolean isCollisionTile(int x, int y) {
    int[] collisionValues = {0, 4, 6};
    
    for (int value : collisionValues) {
      println("collision value: " + value);
        if (currentLevel.map[x][y] == value) {
          println("tile di collisione");
            return true;
        }
    }
    return false;
}
