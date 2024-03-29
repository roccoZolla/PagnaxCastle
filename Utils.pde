int letterIndex = 0; // Indice della lettera corrente
boolean isTyping = true; // Indica se il testo sta ancora venendo digitato
int typingSpeed = 1; // Velocità di scrittura 2 quella ideale

// gestione comandi
void keyPressed() {
  if (screen_state == ScreenState.GAME_SCREEN) {
    switch(key) {
    case 'w':
    case 'W':
      p1.moveUP = true;
      break;

    case 's':
    case 'S':
      p1.moveDOWN = true;
      break;
    case 'a':
    case 'A':
      p1.moveLEFT = true;
      break;

    case 'd':
    case 'D':
      p1.moveRIGHT = true;
      break;

    case 'j':
    case 'J':
      p1.moveATCK = true;
      break;

    case 'k':
    case 'K':
      p1.moveINTR = true;
      break;

    case 'l':
    case 'L':
      p1.moveUSE = true;
      break;
    }
  } else {
    // premi qualsiasi tasto
    if (!isTyping) {
      switch(previous_state) {
      case STORY_SCREEN:
        screen_state = ScreenState.GAME_SCREEN;
        break;

      case GAME_SCREEN:
        screen_state = ScreenState.GAME_SCREEN;
        break;

      case WIN_SCREEN:
        screen_state = ScreenState.MENU_SCREEN;
        break;

      case LOSE_SCREEN:
        screen_state = ScreenState.MENU_SCREEN;
        break;
      }

      // reimposta le variabili
      letterIndex = 0;
      isTyping = true;
    }
  }
}

void keyReleased() {
  if (screen_state == ScreenState.GAME_SCREEN) {
    switch(key) {
    case 'w':
    case 'W':
      p1.moveUP = false;
      break;

    case 's':
    case 'S':
      p1.moveDOWN = false;
      break;
    case 'a':
    case 'A':
      p1.moveLEFT = false;
      break;

    case 'd':
    case 'D':
      p1.moveRIGHT = false;

    case 'j':
    case 'J':
      p1.moveATCK = false;
      break;

    case 'k':
    case 'K':
      p1.moveINTR = false;
      break;

    case 'l':
    case 'L':
      p1.moveUSE = false;
      break;
    }
  }
}

// per quanto riguarda menuscreen, storyscreen e tutorial schermi questi non hanno
// un proprio layer di cui si devono aggiornare le dimensioni
void windowResized() {
  menu.updateScreen();
  game.updateScreen();
  ui.updateScreen();
  pauseMenu.updateScreen();
  optionMenu.updateScreen();
  tutorial.updateScreen();
}

// calcola la posizione di uno sprite all'interno della scena di gioco
// se lo sprite si trova al di fuori della scena lo sprite non viene renderizzato
boolean isInVisibleArea(PVector spritePosition) {
  // Calcola il rettangolo visibile
  int tileSize = currentLevel.tileSize;

  int startX = floor((camera.x / (tileSize * camera.zoom)));
  int startY = floor((camera.y / (tileSize * camera.zoom)));
  int endX = ceil((camera.x + width) / (tileSize * camera.zoom));
  int endY = ceil((camera.y + height) / (tileSize * camera.zoom));


  return (spritePosition.x >= startX && spritePosition.x <= endX && spritePosition.y >= startY && spritePosition.y <= endY);
}

// controlla che le coordinate si trovino all'interno della mappa
boolean isWithinMapBounds(int x, int y) {
  return x >= 0 && x < currentLevel.cols && y >= 0 && y < currentLevel.rows;
}

// controlla se la posizione che si vuole raggiungere è un muro
boolean isWall(int x, int y) {
  // println("valore casella mappa: " + currentLevel.map[x][y]);
  if(currentLevel.map[x][y] == 4 || currentLevel.map[x][y] == 0 || currentLevel.map[x][y] == 6) {
    return true;
  } else {
    return false;
  }
}
