// gestione comandi //<>// //<>// //<>//
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
      game.moveATCK = true;
      break;

    case 'k':
    case 'K':
      p1.moveINTR = true;
      game.moveINTR = true;
      break;

    case 'l':
    case 'L':
      p1.moveUSE = true;
      game.moveUSE = true;
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
      game.moveATCK = false;
      break;

    case 'k':
    case 'K':
      p1.moveINTR = false;
      game.moveINTR = false;
      break;

    case 'l':
    case 'L':
      p1.moveUSE = false;
      game.moveUSE = false;
      break;
    }
  }
}

// per quanto riguarda menuscreen, storyscreen e tutorial schermi questi non hanno
// un proprio layer di cui si devono aggiornare le dimensioni
void windowResized() {
  menu.updateScreen();
  render.updateWindowsScreen();
  ui.updateScreen();
  pauseMenu.updateScreen();
  optionMenu.updateScreen();
  commandScreen.updateScreen();
  creditScreen.updateScreen();
}


// calcola la posizione di uno sprite all'interno della scena di gioco
// se lo sprite si trova al di fuori della scena lo sprite non viene renderizzato
//boolean isInVisibleArea(PVector spritePosition) {
//  // Calcola il rettangolo visibile
//  int tileSize = currentLevel.tileSize;

//  int startX = floor((camera.x / (tileSize * camera.zoom)));
//  int startY = floor((camera.y / (tileSize * camera.zoom)));
//  int endX = ceil((camera.x + width) / (tileSize * camera.zoom));
//  int endY = ceil((camera.y + height) / (tileSize * camera.zoom));

//  return (spritePosition.x >= startX && spritePosition.x <= endX && spritePosition.y >= startY && spritePosition.y <= endY);
//}

boolean isInVisibleArea(PVector boxPosition) {
  // Calcola il rettangolo visibile
  int tileSize = 16;

  int startX = floor((camera.x / (tileSize * camera.zoom)));
  int startY = floor((camera.y / (tileSize * camera.zoom)));
  int endX = ceil((camera.x + width) / (tileSize * camera.zoom));
  int endY = ceil((camera.y + height) / (tileSize * camera.zoom));

  // Calcola le coordinate del centro del box rispetto alle coordinate del tile
  int boxTileX = floor(boxPosition.x / tileSize);
  int boxTileY = floor(boxPosition.y / tileSize);

  // Controlla se il centro del box è all'interno del rettangolo visibile
  return (boxTileX >= startX && boxTileX <= endX && boxTileY >= startY && boxTileY <= endY);
}


// controlla che le coordinate si trovino all'interno della mappa
//boolean isWithinMapBounds(int x, int y) {
//  return x >= 0 && x < level.cols && y >= 0 && y < level.rows;
//}

// controlla se la posizione che si vuole raggiungere è un muro
// da sistemare
//boolean isWall(int x, int y) {
//  if (level.map[x][y] == Utils.WALL_PERIMETER_TILE_TYPE ||
//    level.map[x][y] == Utils.BACKGROUND_TILE_TYPE ||
//    level.map[x][y] == Utils.CHEST_TILE_TYPE)
//  {
//    return true;
//  } else {
//    return false;
//  }
//}

class Utils {
  // tile types for level
  static final int TILE_SIZE = 16;
  static final int BACKGROUND_TILE_TYPE = 0;
  static final int FLOOR_TILE_TYPE = 1;
  static final int START_ROOM_TILE_TYPE = 2;
  static final int STAIRS_TILE_TYPE = 3;
  static final int WALL_PERIMETER_TILE_TYPE = 4;
  static final int HALLWAY_TILE_TYPE = 5;
  static final int CHEST_TILE_TYPE = 6;
  static final int PEAKS_TILE_TYPE = 7;

  // for the writer function
  static final int typingSpeed = 1; // Velocità di scrittura 2 quella ideale

  // fps rate
  static final int SCREEN_FPS_CAP = 240;

  // tick rate
  static final int TICK_RATE = 70;
}
