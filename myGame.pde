Player p1;

int screen_state;
static final int MENU_SCREEN = 0;
static final int GAME_SCREEN = 1;
static final int STORY_SCREEN = 2;
static final int WIN_SCREEN = 3;

World castle;
Macroarea currentArea;
Level currentLevel;

float proximityThreshold = 1.0; // Soglia di prossimità consentita
String actualLevel;

Button startButton;
Button optionButton;
Button exitButton;

String gameTitle = "dungeon game";

PFont myFont;

// Variabili per la posizione della camera
float cameraX = 0;
float cameraY = 0;
float zoom = 1.0;    // dimensione ideale
float easing = 0.1;

int cellX;
int cellY;

void setup() {
  // dimensioni schermo
  size(1280, 720);

  // create world
  castle = new World();
  currentArea = castle.getCurrentMacroarea();
  currentArea.initLevels();
  currentLevel = currentArea.getCurrentLevel();

  System.out.println(currentArea.getName());
  actualLevel = currentArea.getName() + " - " + currentLevel.getName();

  // load font
  myFont = createFont("data/font/Minecraft.ttf", 20);
  textFont(myFont);

  screen_state = MENU_SCREEN;

  startButton = new Button(width / 2 - 100, height / 2, 200, 80, "Start");
  optionButton = new Button(width / 2 - 100, height / 2 + 100, 200, 80, "Option");
  exitButton = new Button(width / 2 - 100, height / 2 + 200, 200, 80, "Exit");

  p1 = new Player(1, 50, "data/player.png");
  p1.setPosition(currentLevel.getStartRoom());
}

void draw() {
  background(0); // Cancella lo schermo

  switch(screen_state) {
  case MENU_SCREEN:
    // show menu
    drawMenu();
    break;

  case STORY_SCREEN:
    // show story
    drawStory(currentArea.getStory());
    break;

  case GAME_SCREEN:
    // show game screen
    drawGame();
    break;

  case WIN_SCREEN:
    drawWin();
    break;
  }
}

void drawMenu() {
  // draw title
  fill(255);
  textSize(80);
  textAlign(CENTER, CENTER);
  text(gameTitle, width / 2, height / 2 - 100);

  // show buttons
  startButton.display();
  optionButton.display();
  exitButton.display();

  if (startButton.isPressed()) {
    screen_state = STORY_SCREEN;
  } else if (optionButton.isPressed()) {
  } else if (exitButton.isPressed()) {
    System.exit(0);
  }
}

void drawGame() {
  float targetCameraX = p1.getPosition().x * currentLevel.getTileSize() * zoom - width / 2;
  float targetCameraY = p1.getPosition().y * currentLevel.getTileSize() * zoom - height / 2;

  // Limita la telecamera in modo che non esca dalla mappa
  targetCameraX = constrain(targetCameraX, 0, currentLevel.getCols() * currentLevel.getTileSize() * zoom - width);
  targetCameraY = constrain(targetCameraY, 0, currentLevel.getRows() * currentLevel.getTileSize() * zoom - height);

  // Interpolazione per rendere il movimento della camera più fluido
  cameraX += (targetCameraX - cameraX) * easing;
  cameraY += (targetCameraY - cameraY) * easing;

  // Imposta la telecamera alla nuova posizione e applica il fattore di scala
  translate(-cameraX, -cameraY);
  scale(zoom);

  // Disegna la mappa del livello corrente
  currentLevel.display();
  
  // nome del livello
  fill(255); 
  textAlign(LEFT, TOP); // Allinea il testo a sinistra e in alto
  textSize(24); 
  text(actualLevel, 20, 20); 

  // Gestione del movimento del giocatore
  // da migliorare
  handlePlayerMovement(currentLevel);

  // mostra il player
  p1.displayPlayer(currentLevel.getTileSize());

  if (dist(p1.getPosition().x, p1.getPosition().y, currentLevel.getEndRoomPosition().x, currentLevel.getEndRoomPosition().y) < proximityThreshold) {
    // se il livello dell'area è l'ultimo passa alla prossima area
    if (currentLevel.getLevelIndex() == currentArea.getNumbLevels()-1) {
      // controlla se è l'area finale
      if (currentArea.isFinal()) {
        // winGame()
        screen_state = WIN_SCREEN;
      } else if (currentArea.getAreaIndex() == castle.getMacroareas().size() - 1) {
        screen_state = MENU_SCREEN;
        resetGame();
      } else {
        currentArea = castle.getMacroareas().get(currentArea.getAreaIndex() + 1);
        System.out.println(currentArea.getStory());
        currentArea.initLevels();
        currentLevel = currentArea.getCurrentLevel();
        actualLevel = currentArea.getName() + " - " + currentLevel.getName();
        p1.setPosition(currentLevel.getStartRoom());

        screen_state = STORY_SCREEN;
      }
    } else {
      // Il giocatore è abbastanza vicino al punto di accesso, quindi passa al livello successivo
      currentLevel = currentArea.getLevels().get(currentLevel.getLevelIndex() + 1);
      actualLevel = currentArea.getName() + " - " + currentLevel.getName();
      p1.setPosition(currentLevel.getStartRoom());
    }
  }

  // da fixare
  // Rileva la posizione del mouse rispetto alle celle
  cellX = floor(mouseX / (currentLevel.getTileSize() * zoom));
  cellY = floor(mouseY / (currentLevel.getTileSize() * zoom));
  System.out.println("Mouse cell coordinates: (" + cellX + "," + cellY);

  // Verifica se il mouse è sopra una casella valida
  if (cellX >= 0 && cellX < currentLevel.getCols() && cellY >= 0 && cellY < currentLevel.getRows()) {
    // Disegna i bordi della casella in bianco
    drawCellBorders(cellX, cellY, currentLevel);
  }

  String  objectAtMouse = currentLevel.getObjectAtCell(cellX, cellY);
  if (objectAtMouse != null) {
    fill(255); // Colore del testo (bianco)
    textAlign(LEFT, LEFT); // Allinea il testo a sinistra e in alto
    textSize(24); // Imposta la dimensione del testo
    text(objectAtMouse, 20, 20); // Disegna il testo a una posizione desiderata (es. 20, 20)
  }

  //float fps = frameRate;
  //System.out.println(fps);
}

void drawWin() {
  screen_state = MENU_SCREEN;
}

void resetGame() {
  // resetta mondo e variabili
  // reimpostare currentArea e richiamare la initLevels
  // reimposta la posizione del giocatore e tutti i suoi parametri
  currentArea = castle.getMacroareas().get(0);
  currentArea.initLevels();
  currentLevel = currentArea.getCurrentLevel();
  p1.setPosition(currentLevel.getStartRoom());
}
