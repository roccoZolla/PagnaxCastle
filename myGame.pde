Player p1;
Map map;

PImage player;

int screen_state;
static final int MENU_SCREEN = 0;
static final int GAME_SCREEN = 1;
static final int STORY_SCREEN = 2;

World castle;
Macroarea currentArea;
Level currentLevel;
float proximityThreshold = 1.0; // Soglia di prossimità consentita

String actualLevel;

Button startButton;
Button optionButton;
Button exitButton;

String gameTitle = "dungeon game";
String storyText;
int letterIndex = 0; // Indice della lettera corrente
boolean isTyping = true; // Indica se il testo sta ancora venendo digitato
int typingSpeed = 2; // Velocità di scrittura (puoi regolarla)

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
  currentLevel = currentArea.getCurrentLevel();

  System.out.println(currentArea.getName());
  actualLevel = currentArea.getName() + " - " + currentLevel.getName();

  // load font
  myFont = createFont("data/font/Minecraft.ttf", 20);
  textFont(myFont);

  storyText = "La principessa Chela è in pericolo. È stata rapita da un cattivone.\n" +
    "Vai al castello del cattivone ma vieni subito scoperto e mandato nelle cantine del castello.\n" +
    "Devi risalire il castello fino alle sale reali per sconfiggere il cattivone di turno.\n";

  screen_state = MENU_SCREEN;

  startButton = new Button(width / 2 - 100, height / 2, 200, 80, "Start");
  optionButton = new Button(width / 2 - 100, height / 2 + 100, 200, 80, "Option");
  exitButton = new Button(width / 2 - 100, height / 2 + 200, 200, 80, "Exit");
}

void draw() {
  background(0); // Cancella lo schermo
  if (screen_state == MENU_SCREEN) {
    // show menu
    drawMenu();
  } else if (screen_state == STORY_SCREEN) {
    // show story
    drawStory();
  } else if (screen_state == GAME_SCREEN) {
    // show game screen
    drawGame();
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
    // the game is initialized when the start button is clicked
    setupGame();
    screen_state = STORY_SCREEN;
  } else if (optionButton.isPressed()) {
  } else if (exitButton.isPressed()) {
    System.exit(0);
  }
}

void setupGame() {
  player = loadImage("data/tile_0088.png");

  p1 = new Player(1, 50, player);
  p1.setPosition(currentLevel.getStartRoom());
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
  fill(255); // Colore del testo (bianco)
  textAlign(LEFT, TOP); // Allinea il testo a sinistra e in alto
  textSize(24); // Imposta la dimensione del testo
  text(actualLevel, 20, 20); // Disegna il testo a una posizione desiderata (es. 20, 20)
    
  // Gestione del movimento del giocatore
  handlePlayerMovement(currentLevel);

  // mostra il player
  p1.displayPlayer(currentLevel.getTileSize());

  if (dist(p1.getPosition().x, p1.getPosition().y, currentLevel.getEndRoomPosition().x, currentLevel.getEndRoomPosition().y) < proximityThreshold) {
    // Il giocatore è abbastanza vicino al punto di accesso, quindi passa al livello successivo
    currentLevel = currentArea.getLevels().get(currentLevel.getLevelIndex() + 1);
    actualLevel = currentArea.getName() + " - " + currentLevel.getName();
    p1.setPosition(currentLevel.getStartRoom());
  }

  // da fixare
  // Rileva la posizione del mouse rispetto alle celle
  //cellX = floor(mouseX / (map.getTileSize() * zoom));
  //cellY = floor(mouseY / (map.getTileSize() * zoom));
  //System.out.println("Mouse cell coordinates: (" + cellX + "," + cellY);

  //// Verifica se il mouse è sopra una casella valida
  //if (cellX >= 0 && cellX < map.getCols() && cellY >= 0 && cellY < map.getRows()) {
  //  // Disegna i bordi della casella in bianco
  //  drawCellBorders(cellX, cellY);
  //}

  //String  objectAtMouse = map.getObjectAtCell(cellX, cellY);
  //if (objectAtMouse != null) {
  //  fill(255); // Colore del testo (bianco)
  //  textAlign(LEFT, TOP); // Allinea il testo a sinistra e in alto
  //  textSize(24); // Imposta la dimensione del testo
  //  text(objectAtMouse, 20, 20); // Disegna il testo a una posizione desiderata (es. 20, 20)
  //}

  //float fps = frameRate;
  //System.out.println(fps);
}

void drawStory() {
  // Mostra il testo narrativo con l'effetto macchina da scrivere
  fill(255);
  textAlign(CENTER, CENTER);
  textSize(24);
  text(storyText.substring(0, letterIndex), width / 2, height / 2);

  if (isTyping) {
    // Continua a scrivere il testo
    if (frameCount % typingSpeed == 0) {
      if (letterIndex < storyText.length()) {
        letterIndex++;
      } else {
        isTyping = false;
      }
    }
  } else {
    textSize(16);
    text("\nPremi un tasto per continuare", width / 2, height - 50);
  }
}

void keyPressed() {
  if (screen_state == STORY_SCREEN && !isTyping) {
    screen_state = GAME_SCREEN;
  }
}
