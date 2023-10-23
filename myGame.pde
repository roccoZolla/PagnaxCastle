Player p1;
Item weapon;

PImage heartFull; // Immagine del cuore pieno
PImage halfHeart; // Immagine del cuore meta
PImage emptyHeart; // Immagine del cuore vuoto
int maxHearts;
int heartWidth = 20; // Larghezza di un cuore
int heartHeight = 20; // Altezza di un cuore

static int screen_state;
static int previous_state;  // salva lo stato precedente
static final int MENU_SCREEN = 0;
static final int GAME_SCREEN = 1;
static final int STORY_SCREEN = 2;
static final int WIN_SCREEN = 3;
static final int LOSE_SCREEN = 4;
static final int PAUSE_SCREEN = 5;
static final int OPTION_SCREEN = 6;

World castle;
Macroarea currentArea;
Level currentLevel;

float proximityThreshold = 0.5; // Soglia di prossimità consentita
String actualLevel;

Button startButton;
Button optionButton;
Button exitButton;

Button pauseButton;
Button resumeButton;
Button backMenuButton;

Button backOptionButton;

String gameTitle = "dungeon game";

PFont myFont;

// Variabili per la posizione della camera
float cameraX = 0;
float cameraY = 0;
float zoom = 5.0;    // zoom ideale 5, in realta la camera deve seguire il giocatore
float easing = 0.7;

PGraphics gameScene;
PGraphics uiLayer;    // questo layer si deve trovare sul layer del scena del gioco
PGraphics pauseLayer; // layer della schermata di pausa -> evitiamo conflitti tra bottoni che si trovano nella stessa posizione

float oldPlayerX, oldPlayerY;
boolean firstDraw;

int celleDisegnateTotali;
int celleRenderizzate;

int cellX;
int cellY;

void setup() {
  // dimensioni schermo
  size(1280, 720);
  
  gameScene = createGraphics(width, height);
  uiLayer = createGraphics(width, height);
  pauseLayer = createGraphics(width, height);

  // load font
  myFont = createFont("data/font/Minecraft.ttf", 20);
  textFont(myFont);
  
  // schermata iniziale
  screen_state = MENU_SCREEN;
  previous_state = screen_state;

  // setup dei bottoni
  // menu
  startButton = new Button(width / 2 - 100, height / 2, 200, 80, "Start", "");
  optionButton = new Button(width / 2 - 100, height / 2 + 100, 200, 80, "Option", "");
  exitButton = new Button(width / 2 - 100, height / 2 + 200, 200, 80, "Exit", "");

  // uiLayer
  pauseButton = new Button(width - 50, 20, 40, 40, "", "data/ui/Pause.png");
  
  // pause scene
  resumeButton = new Button(width / 2 - 100, height / 2, 200, 80, "Resume", "");
  backMenuButton = new Button(width / 2 - 100, pauseLayer.height / 2 + 200, 200, 80, "Back to menu", "");

  backOptionButton = new Button(width - 250, height - 150, 200, 80, "Back to menu", "");

  heartFull = loadImage("data/heartFull.png");
  halfHeart = loadImage("data/halfHeart.png");
  emptyHeart = loadImage("data/emptyHeart.png");
}

// inizializza il mondo di gioco
// una volta premuto il tasto start
void setupGame() {
  // create world
  castle = new World();

  currentArea = castle.getCurrentMacroarea();
  // currentArea.initLevels();
  currentLevel = currentArea.getCurrentLevel();
  currentLevel.init();

  actualLevel = currentArea.getName() + " - " + currentLevel.getName();

  p1 = new Player(1, 100, "data/player.png");
  p1.setPosition(currentLevel.getStartRoom());
  weapon = new Item(1, "sword", "data/little_sword.png");

  p1.setPlayerWeapon(weapon);
}

void draw() {
  System.out.println("screen_state: " + screen_state);
   // cambia il titolo della finestra e mostra il framerate
  surface.setTitle(String.format("%.1f", frameRate));
  
  switch(screen_state) {
  case MENU_SCREEN:
    // attiva i bottoni
    startButton.setEnabled(true);
    optionButton.setEnabled(true);
    exitButton.setEnabled(true);

    // show menu
    menuScreen();
    break;

  case STORY_SCREEN:
    // show story
    storyScreen(currentArea.getStory());
    break;

  case GAME_SCREEN:
    // attiva il bottone di pausa
    pauseButton.setEnabled(true);

    // show game screen
    
    gameScreen();
    drawUI();
    
    image(gameScene, 0, 0);
    image(uiLayer, 0, 0);
    break;

  case WIN_SCREEN:
    System.out.println("entrato in win screen");
    // show win screen
    winScreen();
    break;

  case LOSE_SCREEN:
    // show loose screen
    loseScreen();
    break;

  case PAUSE_SCREEN:
    // disabilita il bottone di pausa
    pauseButton.setEnabled(false);

    // attivo i bottoni relativi al menu di pausa
    resumeButton.setEnabled(true);
    optionButton.setEnabled(true);
    backMenuButton.setEnabled(true);

    // show pause screen
    pauseScreen();
    image(pauseLayer, 0, 0);
    break;

  case OPTION_SCREEN:
    // attiva i bottoni relativi
    backOptionButton.setEnabled(true);

    // show option screen
    optionScreen();
    break;

  default:
    System.out.println("errore");
  }
}

void menuScreen() {
  System.out.println("drawMenu screen state: " + screen_state);
  System.out.println("exitButton: " + exitButton.isEnabled());
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

  if (startButton.isPressed() && startButton.isEnabled()) {
    System.out.println("start button is pressed");
    // salva lo stato
    previous_state = screen_state;

    // inizializza il mondo
    setupGame();

    // far partire di qua la creazione dei livelli
    screen_state = STORY_SCREEN;

    // disabilita i bottoni
    startButton.setEnabled(false);
    optionButton.setEnabled(false);
    exitButton.setEnabled(false);
  } else if (optionButton.isPressed() && optionButton.isEnabled()) {
    // salva lo stato
    previous_state = screen_state;

    // cambia lo stato
    screen_state = OPTION_SCREEN;

    // disabilita i bottoni
    startButton.setEnabled(false);
    optionButton.setEnabled(false);
    exitButton.setEnabled(false);
  } else if (exitButton.isPressed() && exitButton.isEnabled()) {
    System.out.println("exit button is pressed");
    System.exit(0);
  }
}

void updateCamera() {
  float targetCameraX = p1.getPosition().x * currentLevel.getTileSize() * zoom - gameScene.width / 2;
  float targetCameraY = p1.getPosition().y * currentLevel.getTileSize() * zoom - gameScene.height / 2;

  // Limita la telecamera in modo che non esca dalla mappa
  targetCameraX = constrain(targetCameraX, 0, currentLevel.getCols() * currentLevel.getTileSize() * zoom - gameScene.width);
  targetCameraY = constrain(targetCameraY, 0, currentLevel.getRows() * currentLevel.getTileSize() * zoom - gameScene.height);

  // Interpolazione per rendere il movimento della camera più fluido
  cameraX += (targetCameraX - cameraX) * easing;
  cameraY += (targetCameraY - cameraY) * easing;
}

void gameScreen() {  
  gameScene.beginDraw();
  // cancella lo schermo
  gameScene.background(0);

  // aggiorna la camera
  updateCamera();

  // Imposta la telecamera alla nuova posizione e applica il fattore di scala
  gameScene.translate(-cameraX, -cameraY);
  gameScene.scale(zoom);

  // Disegna la mappa del livello corrente
  currentLevel.display(gameScene); // renderizza il 4,6 % della mappa 

  // Gestione del movimento del giocatore
  // da migliorare
  handlePlayerMovement(currentLevel);

  // mostra il player
  p1.display(gameScene, currentLevel.getTileSize());
  // da sistemare pero almeno abbiamo attaccato
  if(moveATCK) {
      drawPlayerWeapon();
  }
  
  // passa al livello successivo
  if (dist(p1.getPosition().x, p1.getPosition().y, currentLevel.getEndRoomPosition().x, currentLevel.getEndRoomPosition().y) < proximityThreshold) {
    // se il livello dell'area è l'ultimo passa alla prossima area
    if (currentLevel.getLevelIndex() == currentArea.getNumbLevels()-1) {
      // controlla se è l'area finale
      if (currentArea.isFinal()) {
        screen_state = WIN_SCREEN;
      } /* else if (currentArea.getAreaIndex() == castle.getMacroareas().size() - 1) {
       //  screen_state = MENU_SCREEN;
       //} */
      else {
        currentArea = castle.getMacroareas().get(currentArea.getAreaIndex() + 1);
        // currentArea.initLevels();
        currentLevel = currentArea.getCurrentLevel();
        currentLevel.init();
        actualLevel = currentArea.getName() + " - " + currentLevel.getName();
        p1.setPosition(currentLevel.getStartRoom());

        screen_state = STORY_SCREEN;
      }
    } else {
      // Il giocatore è abbastanza vicino al punto di accesso, quindi passa al livello successivo
      currentLevel = currentArea.getLevels().get(currentLevel.getLevelIndex() + 1);
      currentLevel.init();
      actualLevel = currentArea.getName() + " - " + currentLevel.getName();
      p1.setPosition(currentLevel.getStartRoom());
    }
  }

  // da fixare
  // Rileva la posizione del mouse rispetto alle celle
  //cellX = floor(mouseX / (currentLevel.getTileSize() * zoom));
  //cellY = floor(mouseY / (currentLevel.getTileSize() * zoom));

  //// Verifica se il mouse è sopra una casella valida
  //if (cellX >= 0 && cellX < currentLevel.getCols() && cellY >= 0 && cellY < currentLevel.getRows()) {
  //  // Disegna i bordi della casella in bianco
  //  drawCellBorders(cellX, cellY, currentLevel);
  //}

  //String  objectAtMouse = currentLevel.getObjectAtCell(cellX, cellY);
  //if (objectAtMouse != null) {
  //  fill(255); // Colore del testo (bianco)
  //  textAlign(LEFT, LEFT); // Allinea il testo a sinistra e in alto
  //  textSize(24); // Imposta la dimensione del testo
  //  text(objectAtMouse, width / 2, 40); // Disegna il testo a una posizione desiderata (es. 20, 20)
  //}
  gameScene.endDraw();
}

void winScreen() {
  // salva lo stato precedente
  previous_state = screen_state;
  
  // chiama la funzione
  writer("hai vinto!");
}

void loseScreen() {
  // salva lo stato precedente
  previous_state = screen_state;
  
  // chiama la funzione
  writer("hai perso!");
}

void pauseScreen() {
  pauseLayer.beginDraw();
  // trovare modo per opacizzare lo sfondo
  pauseLayer.background(0);

  // disegna la scritta pausa
  pauseLayer.textFont(myFont);
  pauseLayer.fill(255);
  pauseLayer.textSize(36);
  pauseLayer.textAlign(CENTER, CENTER);
  pauseLayer.text("PAUSA", width / 2, height / 2 - 100);

  // shows buttons
  resumeButton.display(pauseLayer);
  optionButton.display(pauseLayer);
  backMenuButton.display(pauseLayer);

  if (resumeButton.isPressed() && resumeButton.isEnabled()) {
    // prima di cambiare stato salvalo
    previous_state = screen_state;

    // torna al gioco
    screen_state = GAME_SCREEN;

    // disablita i bottoni
    resumeButton.setEnabled(false);
    optionButton.setEnabled(false);
    backMenuButton.setEnabled(false);
  } else if (optionButton.isPressed() && optionButton.isEnabled()) {
    // salva lo stato
    previous_state = screen_state;

    // opzioni di gioco
    screen_state = OPTION_SCREEN;

    // disabilita i bottoni
    resumeButton.setEnabled(false);
    optionButton.setEnabled(false);
    backMenuButton.setEnabled(false);
  } else if (backMenuButton.isPressed() && backMenuButton.isEnabled()) {
    // salva lo stato
    previous_state = screen_state;

    // torna al menu
    screen_state = MENU_SCREEN;

    resumeButton.setEnabled(false);
    optionButton.setEnabled(false);
    backMenuButton.setEnabled(false);
  }
  pauseLayer.endDraw();
}

void optionScreen() {
  // cancella lo schermo
  background(0);

  // disegna la scritta pausa
  fill(255);
  textSize(36);
  textAlign(CENTER, CENTER);
  text("OPTIONS", 100, 50);

  backOptionButton.display();

  System.out.println("exit button: " + exitButton.isEnabled());

  if (backOptionButton.isPressed() && backOptionButton.isEnabled()) {
    if (previous_state == MENU_SCREEN) {
      // salva lo stato
      previous_state = screen_state;

      // torna al menu
      screen_state = MENU_SCREEN;
    } else if (previous_state == PAUSE_SCREEN) {
      // salva lo stato
      previous_state = screen_state;

      // torna alla schermata di pausa
      screen_state = PAUSE_SCREEN;
    }

    backOptionButton.setEnabled(false);
  }
}

void drawUI() {
  uiLayer.beginDraw();
  uiLayer.background(255, 0);
  // nome del livello
  uiLayer.textFont(myFont);
  uiLayer.fill(255);
  uiLayer.textAlign(LEFT, TOP); // Allinea il testo a sinistra e in alto
  uiLayer.textSize(24);
  uiLayer.text(actualLevel, 20, 20);

  // pause button
  pauseButton.display(uiLayer);

  if (pauseButton.isPressed() && pauseButton.isEnabled()) {
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
    uiLayer.image(heartFull, 20 + i * (heartWidth + 5), heartY, heartWidth, heartHeight);
  }

  // Disegna il cuore a metà se necessario
  if (isHalfHeart) {
    uiLayer.image(halfHeart, 20 + heartsToDisplay * (heartWidth + 5), heartY, heartWidth, heartHeight / 2);
  }

  // Disegna i cuori vuoti per completare il numero massimo di cuori
  for (int i = heartsToDisplay + (isHalfHeart ? 1 : 0); i < maxHearts; i++) {
    uiLayer.image(emptyHeart, 20 + i * (heartWidth + 5), heartY, heartWidth, heartHeight);
  }

  // all'interno del riquadro verra inserita l'arma corrente
  uiLayer.noFill(); // Nessun riempimento
  uiLayer.stroke(255); // Colore del bordo bianco
  uiLayer.rect(width / 2, height - 100, 50, 50);

  float scaleFactor = 3.0;

  if (p1.getPlayerWeapon().getSprite() != null) {

    float imgWidth = p1.getPlayerWeapon().getSprite().width * scaleFactor;
    float imgHeight = p1.getPlayerWeapon().getSprite().height * scaleFactor;

    float imgX = uiLayer.width / 2 + (50 - imgWidth) / 2;  // Calcola la posizione X dell'immagine al centro
    float imgY = uiLayer.height - 100 + (50 - imgHeight) / 2; // Calcola la posizione Y dell'immagine al centro

    uiLayer.image(p1.getPlayerWeapon().getSprite(), imgX, imgY, imgWidth, imgHeight);
  }
  uiLayer.endDraw();
}


void storyScreen(String storyText) {
  // salva lo stato precedente
  previous_state = screen_state;

  // chiama il writer
  writer(storyText);
}

void writer(String txt) {
  // cancella lo schermo
  background(0);

  // Mostra il testo narrativo con l'effetto macchina da scrivere
  fill(255);
  textAlign(CENTER, CENTER);
  textSize(24);
  text(txt.substring(0, letterIndex), width / 2, height / 2);

  if (isTyping) {
    // Continua a scrivere il testo
    if (frameCount % typingSpeed == 0) {
      if (letterIndex < txt.length()) {
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

void resetGame() {
  // resetta mondo e variabili
  // reimpostare currentArea e richiamare la initLevels
  // reimposta la posizione del giocatore e tutti i suoi parametri
  currentArea = castle.getMacroareas().get(0);
  currentArea.initLevels();
  currentLevel = currentArea.getCurrentLevel();
  p1.setPosition(currentLevel.getStartRoom());
}
