Player p1;
Item weapon;

PImage heartFull; // Immagine del cuore pieno
PImage halfHeart; // Immagine del cuore meta
PImage emptyHeart; // Immagine del cuore vuoto
int maxHearts;
int heartWidth = 20; // Larghezza di un cuore
int heartHeight = 20; // Altezza di un cuore

static int screen_state;
static final int MENU_SCREEN = 0;
static final int GAME_SCREEN = 1;
static final int STORY_SCREEN = 2;
static final int WIN_SCREEN = 3;
static final int PAUSE_SCREEN = 4;
static final int OPTION_SCREEN = 5;

World castle;
Macroarea currentArea;
Level currentLevel;

float proximityThreshold = 1.0; // Soglia di prossimità consentita
String actualLevel;

Button startButton;
Button optionButton;
Button exitButton;

Button pauseButton;
Button resumeButton;
Button backMenuButton;

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

  startButton = new Button(width / 2 - 100, height / 2, 200, 80, "Start", "");
  optionButton = new Button(width / 2 - 100, height / 2 + 100, 200, 80, "Option", "");
  exitButton = new Button(width / 2 - 100, height / 2 + 200, 200, 80, "Exit", "");

  pauseButton = new Button(width - 50, 20, 40, 40, "", "data/ui/Pause.png");
  resumeButton = new Button(width / 2 - 100, height / 2, 200, 80, "Resume", "");
  backMenuButton = new Button(width / 2 - 100, height / 2 + 200, 200, 80, "Back to menu", "");

  p1 = new Player(1, 30, "data/player.png");
  p1.setPosition(currentLevel.getStartRoom());
  weapon = new Item(1, "sword", "data//little_sword.png");

  p1.setPlayerWeapon(weapon);

  heartFull = loadImage("data/heartFull.png");
  halfHeart = loadImage("data/halfHeart.png");
  emptyHeart = loadImage("data/emptyHeart.png");
}

void draw() {
  System.out.println("screen state: " + screen_state);
  switch(screen_state) {
  case MENU_SCREEN:
    System.out.println("case MENUSCREEN");
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
    // show win screen
    drawWin();
    break;

  case PAUSE_SCREEN:
    // show pause screen
    drawPause();
    break;

  case OPTION_SCREEN:
    // show option screen
    drawOption();
    break;

  default:
    System.out.println("errore");
  }
}

void drawMenu() {
  System.out.println("drawMenu screen state" + screen_state);
  background(0); // Cancella lo schermo

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
    // far partire di qua la creazione dei livelli
    screen_state = STORY_SCREEN;
  } else if (optionButton.isPressed()) {
    screen_state = OPTION_SCREEN;
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

  drawUI(); 
  
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
    text(objectAtMouse, width / 2, 40); // Disegna il testo a una posizione desiderata (es. 20, 20)
  }

  //float fps = frameRate;
  //System.out.println(fps);
}

void drawWin() {
  screen_state = MENU_SCREEN;
}

void drawPause() {
  // trovare modo per opacizzare lo sfondo
  background(0);

  // disegna la scritta pausa
  fill(255);
  textSize(36);
  textAlign(CENTER, CENTER);
  text("PAUSA", width / 2, height / 2 - 100);

  resumeButton.display();
  optionButton.display();
  backMenuButton.display();

  if (resumeButton.isPressed()) {
    // torna al gioco
    screen_state = GAME_SCREEN;
  } else if (optionButton.isPressed()) {
    // opzioni di gioco
    screen_state = OPTION_SCREEN;
  } else if (backMenuButton.isPressed()) {
    // torna al menu
    screen_state = MENU_SCREEN;
    // resetGame();
  }
}

void drawOption() {
  //
  background(0);

  // disegna la scritta pausa
  fill(255);
  textSize(36);
  textAlign(CENTER, CENTER);
  text("OPTIONS", width / 2, height / 2 - 100);

  backMenuButton.display();

  if (backMenuButton.isPressed()) {
    screen_state = MENU_SCREEN;
  }
}

void drawUI() {
  // nome del livello
  fill(255);
  textAlign(LEFT, TOP); // Allinea il testo a sinistra e in alto
  textSize(24);
  text(actualLevel, 20, 20);

  // pause button
  pauseButton.display();

  if (pauseButton.isPressed()) {
    // il gioco viene messo in pausa
    screen_state = PAUSE_SCREEN;
  }

  // cuori
  // Calcola quanti cuori pieni mostrare in base alla vita del giocatore
  int heartsToDisplay = p1.getPlayerHP() / 10; // Supponiamo che ogni cuore rappresenti 10 HP
  int heartY = 50;
  maxHearts = p1.getPlayerHP() / 10;
  boolean isHalfHeart = p1.getPlayerHP() % 10 >= 5; // Controlla se c'è un cuore a metà

  // Disegna i cuori pieni
  for (int i = 0; i < heartsToDisplay; i++) {
    image(heartFull, 20 + i * (heartWidth + 5), heartY, heartWidth, heartHeight);
  }

  // Disegna il cuore a metà se necessario
  if (isHalfHeart) {
    image(halfHeart, 20 + heartsToDisplay * (heartWidth + 5), heartY, heartWidth, heartHeight / 2);
  }

  // Disegna i cuori vuoti per completare il numero massimo di cuori
  for (int i = heartsToDisplay + (isHalfHeart ? 1 : 0); i < maxHearts; i++) {
    image(emptyHeart, 20 + i * (heartWidth + 5), heartY, heartWidth, heartHeight);
  }

  // all'interno del riquadro verra inserita l'arma corrente
  noFill(); // Nessun riempimento
  stroke(255); // Colore del bordo bianco
  rect(width - 75, height - 100, 50, 50);

  float scaleFactor = 3.0;

  if (p1.getPlayerWeapon().getSprite() != null) {

    float imgWidth = p1.getPlayerWeapon().getSprite().width * scaleFactor;
    float imgHeight = p1.getPlayerWeapon().getSprite().height * scaleFactor;

    float imgX = width - 75 + (50 - imgWidth) / 2;  // Calcola la posizione X dell'immagine al centro
    float imgY = height - 100 + (50 - imgHeight) / 2; // Calcola la posizione Y dell'immagine al centro

    image(p1.getPlayerWeapon().getSprite(), imgX, imgY, imgWidth, imgHeight);
  }
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
