import processing.sound.*;

Player p1;
Item weapon;
Item silver_key;
Item golden_key;
Item redPotion;
Chest selectedChest;

// ui
PImage heartFull; // Immagine del cuore pieno
PImage halfHeart; // Immagine del cuore meta
PImage emptyHeart; // Immagine del cuore vuoto
int maxHearts;
int heartWidth = 20; // Larghezza di un cuore
int heartHeight = 20; // Altezza di un cuore
PImage letter_k;
PImage coins;

// sound effect
float volumeMusicLevel;
float volumeEffectsLevel;    // oscilla tra 0.0 e 1.0

SoundFile pickupCoin;
SoundFile normalChestOpen;
SoundFile specialChestOpen;
SoundFile drinkPotion;

SoundFile soundtrack;
boolean isSoundtrackPlaying;

// stato dello schermo
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

float proximityThreshold = 0.5; // Soglia di prossimità consentita per le scale
float coinCollectionThreshold = 0.5; // soglia di prossimita per il raccoglimento delle monete
String actualLevel;

// bottoni
Button startButton;
Button optionButton;
Button exitButton;

Button pauseButton;
Button resumeButton;
Button backMenuButton;

Button effectsPlusButton;
Button effectsMinusButton;
Button musicPlusButton;
Button musicMinusButton;
Button backOptionButton;

// titolo del gioco
String gameTitle = "dungeon game";
PFont myFont;  // font del gioco

Camera camera;

PGraphics gameScene;
PGraphics uiLayer;    // questo layer si deve trovare sul layer del scena del gioco
PGraphics spritesLayer;
PGraphics pauseLayer; // layer della schermata di pausa -> evitiamo conflitti tra bottoni che si trovano nella stessa posizione
PGraphics optionScene;

void setup() {
  // dimensioni schermo
  size(1280, 720);

  gameScene = createGraphics(width, height);
  spritesLayer = createGraphics(width, height);
  uiLayer = createGraphics(width, height);
  pauseLayer = createGraphics(width, height);
  optionScene = createGraphics(width, height);

  // load font
  myFont = createFont("data/font/Minecraft.ttf", 20);
  textFont(myFont);

  // schermata iniziale
  screen_state = MENU_SCREEN;
  previous_state = screen_state;

  // setup dei bottoni
  setupButtons();

  // setup image
  setupImages();

  // setup sound
  setupSounds();

  // setup items (PROVVISORIO)
  golden_key = new Item(2, "golden_key");
  silver_key = new Item(4, "silver_key");
  weapon = new Item(1, "sword");
  redPotion = new Item(3, "Red Potion");
  
  golden_key.sprite = loadImage("data/golden_key.png");
  silver_key.sprite = loadImage("data/silver_key.png");
  weapon.sprite = loadImage("data/little_sword.png");
  redPotion.sprite = loadImage("data/object/red_potion.png");

  camera = new Camera();

  selectedChest = null;
}

void setupButtons() {
  // menu
  startButton = new Button(width / 2 - 100, height / 2, 200, 80, "Start", "");
  optionButton = new Button(width / 2 - 100, height / 2 + 100, 200, 80, "Option", "");
  exitButton = new Button(width / 2 - 100, height / 2 + 200, 200, 80, "Exit", "");

  // uiLayer
  pauseButton = new Button(width - 50, 20, 40, 40, "", "data/ui/Pause.png");

  // pause scene
  resumeButton = new Button(width / 2 - 100, height / 2, 200, 80, "Resume", "");
  backMenuButton = new Button(width / 2 - 100, pauseLayer.height / 2 + 200, 200, 80, "Back to menu", "");

  // options screen
  effectsPlusButton = new Button(width - 100, 120, 50, 50, "+", "");
  effectsMinusButton = new Button(width - 250, 120, 50, 50, "-", "");

  musicPlusButton = new Button(width - 100, 200, 50, 50, "+", "");
  musicMinusButton = new Button(width - 250, 200, 50, 50, "-", "");

  backOptionButton = new Button(width - 250, height - 150, 200, 80, "Back to menu", "");
}

void setupImages() {
  heartFull = loadImage("data/heartFull.png");
  halfHeart = loadImage("data/halfHeart.png");
  emptyHeart = loadImage("data/emptyHeart.png");
  letter_k = loadImage("data/letter_k.png");
  coins = loadImage("data/coin.png");
}

void setupSounds() {
  volumeMusicLevel = 0.1;
  volumeEffectsLevel = 0.1;

  pickupCoin = new SoundFile(this, "data/sound/pickupCoin.wav");
  normalChestOpen = new SoundFile(this, "data/sound/normal_chest_open.wav");
  specialChestOpen = new SoundFile(this, "data/sound/special_chest_open.wav");
  drinkPotion = new SoundFile(this, "data/sound/drink_potion.wav");

  soundtrack = new SoundFile(this, "data/sound/dungeon_soundtrack.wav");
  isSoundtrackPlaying = false;

  pickupCoin.amp(volumeEffectsLevel);
  normalChestOpen.amp(volumeEffectsLevel);
  specialChestOpen.amp(volumeEffectsLevel);
  drinkPotion.amp(volumeEffectsLevel);

  soundtrack.amp(volumeMusicLevel);
}

// inizializza il mondo di gioco
// una volta premuto il tasto start
void setupGame() {
  // create world
  castle = new World();

  currentArea = castle.getCurrentMacroarea();
  currentLevel = currentArea.getCurrentLevel();
  currentLevel.init();

  actualLevel = currentArea.areaName + " - " + currentLevel.levelName;

  redPotion.setTakeable(true);    // si puo prendere
  redPotion.setUseable(true);    // si puo usare
  redPotion.setHealerable(true);  // restitusce vita
  redPotion.setBonusHP(20);

  p1 = new Player(80, 100, 5, 5, 5);
  p1.spritePosition = currentLevel.getStartRoom();
  p1.sprite = loadImage("data/player.png");
  p1.healer = redPotion;
  p1.weapon = weapon;
  p1.golden_keys = golden_key;
  p1.silver_keys = silver_key;
}

void draw() {
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

    if (!isSoundtrackPlaying) {
      soundtrack.play();
      isSoundtrackPlaying = true;
    }

    // show game screen
    gameScreen();
    drawUI();

    image(gameScene, 0, 0);
    image(spritesLayer, 0, 0);
    image(uiLayer, 0, 0);
    break;

  case WIN_SCREEN:
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

    effectsPlusButton.setEnabled(true);
    effectsMinusButton.setEnabled(true);

    musicPlusButton.setEnabled(true);
    musicMinusButton.setEnabled(true);

    // show option screen
    optionScreen();

    image(optionScene, 0, 0);
    break;

  default:
    System.out.println("errore");
  }
}

void menuScreen() {
  background(0); // Cancella lo schermo

  // draw title
  fill(255);
  textSize(80);
  textAlign(CENTER, CENTER);
  text(gameTitle, width / 2, height / 2 - 100);

  if (startButton.isClicked() && startButton.isEnabled()) {
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
  }

  if (optionButton.isClicked() && optionButton.isEnabled()) {
    // salva lo stato
    previous_state = screen_state;

    // cambia lo stato
    screen_state = OPTION_SCREEN;

    // disabilita i bottoni
    startButton.setEnabled(false);
    optionButton.setEnabled(false);
    exitButton.setEnabled(false);
  }

  if (exitButton.isClicked() && exitButton.isEnabled()) {
    System.exit(0);
  }

  // update buttons
  startButton.update();
  optionButton.update();
  exitButton.update();

  // show buttons
  startButton.display();
  optionButton.display();
  exitButton.display();
}

void gameScreen() {
  gameScene.beginDraw();
  // cancella lo schermo
  gameScene.background(0);

  // aggiorna la camera
  camera.update();

  // Imposta la telecamera alla nuova posizione e applica il fattore di scala
  gameScene.translate(-camera.x, -camera.y);
  gameScene.scale(camera.zoom);

  // Disegna la mappa del livello corrente
  currentLevel.display(); // renderizza il 4,6 % della mappa

  spritesLayer.beginDraw();
  spritesLayer.background(255, 0);
  spritesLayer.translate(-camera.x, -camera.y);
  spritesLayer.scale(camera.zoom);

  // ----- ENEMY -----
  for (Enemy enemy : currentLevel.enemies) {
    enemy.display(spritesLayer);
    enemy.move(currentLevel);
  }


  // ----- CHEST -----
  for (Chest chest : currentLevel.treasures) {
    chest.display(spritesLayer);

    // Calcola la distanza tra il giocatore e la cassa
    float distanceToChest = dist(p1.spritePosition.x, p1.spritePosition.y, chest.spritePosition.x, chest.spritePosition.y);

    // Imposta una soglia per la distanza in cui il giocatore può interagire con la cassa
    float interactionThreshold = 1.5; // Puoi regolare questa soglia a tuo piacimento

    if (distanceToChest < interactionThreshold) {
      // Il giocatore è abbastanza vicino alla cassa per interagire
      selectedChest = chest;
      println("chest selezionata");
    } else {
      selectedChest = null;
    }
  }

  if (selectedChest != null) {
    // Calcola le coordinate x e y per il testo in modo che sia centrato sopra la cassa
    float letterImageX = (selectedChest.spritePosition.x * currentLevel.tileSize);
    float letterImageY = (selectedChest.spritePosition.y * currentLevel.tileSize) - 20; // Regola l'offset verticale a tuo piacimento

    // da fixare deve apparire nel ui layer
    spritesLayer.image(letter_k, letterImageX, letterImageY);

    if (moveINTR && !selectedChest.isOpen()) {
      if (selectedChest.isRare()) {    // se la cassa è rara
        if (p1.numberOfGoldenKeys > 0) {
          if (selectedChest.getOpenWith().equals(p1.golden_keys)) {
            // imposta la cassa come aperta
            selectedChest.setIsOpen(true);
            specialChestOpen.play();
            selectedChest.sprite = loadImage("data/object/special_chest_open.png");

            p1.numberOfGoldenKeys -= 1;
            p1.playerScore += 50;
          }
        } else {
          spritesLayer.textFont(myFont);
          spritesLayer.fill(255);
          spritesLayer.textSize(15);
          spritesLayer.text("Non hai piu chiavi!", (p1.spritePosition.x * currentLevel.tileSize) - 50, (p1.spritePosition.y * currentLevel.tileSize) - 10);
        }
      } else {  // se la cassa è normale
        if (p1.numberOfSilverKeys > 0) {
          if (selectedChest.getOpenWith().equals(p1.silver_keys)) {
            // imposta la cassa come aperta
            selectedChest.setIsOpen(true);
            normalChestOpen.play();
            selectedChest.sprite = loadImage("data/object/chest_open.png");

            p1.numberOfSilverKeys -= 1;
            p1.playerScore += 30;
          }
        } else {
          spritesLayer.textFont(myFont);
          spritesLayer.fill(255);
          spritesLayer.textSize(15);
          spritesLayer.text("Non hai piu chiavi!", (p1.spritePosition.x * currentLevel.tileSize) - 50, (p1.spritePosition.y * currentLevel.tileSize) - 10);
        }
      }
    }
  } else {
    println("chest null");
  }

  // ----- COIN -----
  for (Coin coin : currentLevel.coins) {
    if (!coin.isCollected()) {    // se la moneta non è stata raccolta disegnala
      if (PVector.dist(p1.spritePosition, coin.spritePosition) < coinCollectionThreshold) {
        coin.collect();  // raccogli la moneta
        p1.collectCoin();
        pickupCoin.play();
        p1.playerScore = coin.scoreValue;
      } else {
        coin.display(spritesLayer);
      }
    }
  }

  // Gestione del movimento del giocatore
  // da migliorare
  handlePlayerMovement(currentLevel);

  // mostra il player
  p1.display(spritesLayer);
  if (moveATCK) {
    drawPlayerWeapon();
  }

  // usa le pozioni
  if (moveUSE && p1.numberOfPotion > 0) {
    if (p1.playerHP < p1.playerMaxHP) {
      drinkPotion.play();
      p1.playerHP += redPotion.bonusHP;

      if (p1.playerHP > p1.playerMaxHP) p1.playerHP = p1.playerMaxHP;

      p1.numberOfPotion -= 1;
    } else {
      spritesLayer.textFont(myFont);
      spritesLayer.fill(255);
      spritesLayer.textSize(10);
      spritesLayer.text("Cuori al massimo!", (p1.spritePosition.x * currentLevel.tileSize) - 30, (p1.spritePosition.y * currentLevel.tileSize) - 5);
    }
  }
  spritesLayer.endDraw();


  // passa al livello successivo
  if (dist(p1.spritePosition.x, p1.spritePosition.y, currentLevel.getEndRoomPosition().x, currentLevel.getEndRoomPosition().y) < proximityThreshold) {
    // se il livello dell'area è l'ultimo passa alla prossima area
    if (currentLevel.levelIndex == currentArea.numLevels - 1) {
      // controlla se è l'area finale
      if (currentArea.isFinal()) {
        screen_state = WIN_SCREEN;
      } else {
        // passa alla prossima macroarea
        currentArea = castle.getMacroareas().get(currentArea.getAreaIndex() + 1);
        // currentArea.initLevels();
        currentLevel = currentArea.currentLevel;
        currentLevel.init();
        actualLevel = currentArea.areaName + " - " + currentLevel.levelName;
        p1.spritePosition = currentLevel.getStartRoom();

        // aggiorna lo score del player
        p1.playerScore +=  200;
        screen_state = STORY_SCREEN;
      }
    } else {
      // passa al livello successivo - stessa macro area
      // Il giocatore è abbastanza vicino al punto di accesso, quindi passa al livello successivo
      currentLevel = currentArea.getLevels().get(currentLevel.levelIndex + 1);
      currentLevel.init();
      actualLevel = currentArea.areaName + " - " + currentLevel.levelName;
      p1.spritePosition = currentLevel.getStartRoom();

      // aggiorna lo score del player
      p1.playerScore += 100;
    }
  }

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

  if (resumeButton.isClicked() && resumeButton.isEnabled()) {
    // prima di cambiare stato salvalo
    previous_state = screen_state;

    // torna al gioco
    screen_state = GAME_SCREEN;

    soundtrack.play();

    // disablita i bottoni
    resumeButton.setEnabled(false);
    optionButton.setEnabled(false);
    backMenuButton.setEnabled(false);
  }

  if (optionButton.isClicked() && optionButton.isEnabled()) {
    // salva lo stato
    previous_state = screen_state;

    // opzioni di gioco
    screen_state = OPTION_SCREEN;

    // disabilita i bottoni
    resumeButton.setEnabled(false);
    optionButton.setEnabled(false);
    backMenuButton.setEnabled(false);
  }

  if (backMenuButton.isClicked() && backMenuButton.isEnabled()) {
    // salva lo stato
    previous_state = screen_state;

    // torna al menu
    screen_state = MENU_SCREEN;

    soundtrack.stop();

    resumeButton.setEnabled(false);
    optionButton.setEnabled(false);
    backMenuButton.setEnabled(false);
  }

  // update buttons
  resumeButton.update();
  optionButton.update();
  backMenuButton.update();

  // shows buttons
  resumeButton.display(pauseLayer);
  optionButton.display(pauseLayer);
  backMenuButton.display(pauseLayer);

  pauseLayer.endDraw();
}

void optionScreen() {
  optionScene.beginDraw();
  // cancella lo schermo
  optionScene.background(0);

  // disegna la scritta opzioni
  optionScene.textFont(myFont);
  optionScene.fill(255);
  optionScene.textSize(36);
  optionScene.textAlign(CENTER, CENTER);
  optionScene.text("OPTIONS", 100, 50);

  optionScene.stroke(255);
  optionScene.line(200, 50, width - 50, 50);

  // ----- AUDIO -----
  optionScene.fill(255);
  optionScene.textSize(30);
  optionScene.textAlign(LEFT, CENTER);
  optionScene.text("Audio: ", 100, 100);

  // ----- EFFETTI SONORI -----
  optionScene.fill(255);
  optionScene.textSize(30);
  optionScene.textAlign(LEFT, CENTER);
  optionScene.text("Effetti sonori: ", 200, 150);
  optionScene.fill(255);
  optionScene.textSize(30);
  optionScene.textAlign(LEFT, CENTER);
  optionScene.text(volumeEffectsLevel, width - 200, 150);

  // ----- MUSICA -----
  optionScene.fill(255);
  optionScene.textSize(30);
  optionScene.textAlign(LEFT, CENTER);
  optionScene.text("Musica: ", 200, 200);

  optionScene.fill(255);
  optionScene.textSize(30);
  optionScene.textAlign(LEFT, CENTER);
  optionScene.text(volumeMusicLevel, width - 200, 225);

  // scritta difficolta
  optionScene.fill(255);
  optionScene.textSize(30);
  optionScene.textAlign(LEFT, CENTER);
  optionScene.text("Difficolta: ", 100, 250);

  // scritta lingua
  optionScene.fill(255);
  optionScene.textSize(30);
  optionScene.textAlign(LEFT, CENTER);
  optionScene.text("Lingua: ", 100, 300);

  optionScene.stroke(255);
  optionScene.line(50, height - 100, width - 270, height - 100);

  if (backOptionButton.isClicked() && backOptionButton.isEnabled()) {
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
    effectsPlusButton.setEnabled(false);
    effectsMinusButton.setEnabled(false);
    musicPlusButton.setEnabled(false);
    musicMinusButton.setEnabled(false);
  }

  // effects sound button
  if (effectsPlusButton.isClicked() && effectsPlusButton.isEnabled()) {
    volumeEffectsLevel += 0.1;

    if (volumeEffectsLevel > 1.0) volumeEffectsLevel = 1.0;

    updateEffectsVolume(volumeEffectsLevel);
  }

  if (effectsMinusButton.isClicked() && effectsMinusButton.isEnabled()) {
    volumeEffectsLevel -= 0.1;

    if (volumeEffectsLevel < 0.0) volumeEffectsLevel = 0.0;

    updateEffectsVolume(volumeEffectsLevel);
  }

  // music button
  if (musicPlusButton.isClicked() && musicPlusButton.isEnabled()) {
    volumeMusicLevel += 0.1;

    if (volumeMusicLevel > 1.0) volumeMusicLevel = 1.0;

    updateMusicVolume(volumeMusicLevel);
  }

  if (musicMinusButton.isClicked() && musicMinusButton.isEnabled()) {
    volumeMusicLevel -= 0.1;

    if (volumeMusicLevel < 0.0) volumeMusicLevel = 0.0;
    updateMusicVolume(volumeMusicLevel);
  }

  // ----- BACK BUTTON -----
  // update buttons
  backOptionButton.update();
  effectsPlusButton.update();
  effectsMinusButton.update();
  musicPlusButton.update();
  musicMinusButton.update();

  // show buttons
  backOptionButton.display(optionScene);
  effectsPlusButton.display(optionScene);
  effectsMinusButton.display(optionScene);
  musicPlusButton.display(optionScene);
  musicMinusButton.display(optionScene);

  optionScene.endDraw();
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
  if (pauseButton.isClicked() && pauseButton.isEnabled()) {
    // il gioco viene messo in pausa
    screen_state = PAUSE_SCREEN;
    soundtrack.pause();
  }

  // update button
  pauseButton.update();

  // show button
  pauseButton.display(uiLayer);

  // ------ CUORI GIOCATORE ------
  // Calcola quanti cuori pieni mostrare in base alla vita del giocatore
  int heartsToDisplay = p1.playerHP / 10; // Supponiamo che ogni cuore rappresenti 10 HP
  int heartY = 50;
  maxHearts = p1.playerMaxHP / 10;
  boolean isHalfHeart = p1.playerHP % 10 >= 5; // Controlla se c'è un cuore a metà

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

  // ------ SCORE GIOCATORE ------
  uiLayer.fill(255);
  uiLayer.textSize(24);
  uiLayer.text("Score: " + p1.playerScore, uiLayer.width - 200, 20);

  // ------ CHIAVI ARGENTO GIOCATORE ------
  uiLayer.fill(255);
  uiLayer.textAlign(LEFT, TOP); // Allinea il testo a sinistra e in alto
  uiLayer.textSize(18);
  uiLayer.text(p1.numberOfSilverKeys, 50, 80);
  uiLayer.image(silver_key.sprite, 20, 80, 20, 20);

  // ------ CHIAVI ORO GIOCATORE ------
  uiLayer.fill(255);
  uiLayer.textAlign(LEFT, TOP); // Allinea il testo a sinistra e in alto
  uiLayer.textSize(18);
  uiLayer.text(p1.numberOfGoldenKeys, 100, 80);
  uiLayer.image(golden_key.sprite, 70, 80, 20, 20);

  // ------ MONETE GIOCATORE ------
  uiLayer.fill(255);
  uiLayer.textAlign(LEFT, TOP); // Allinea il testo a sinistra e in alto
  uiLayer.textSize(18);
  uiLayer.text(p1.coins, 50, 110);
  uiLayer.image(coins, 20, 110, 20, 20);

  // ------ POZIONE GIOCATORE ------
  uiLayer.fill(255);
  uiLayer.textAlign(LEFT, TOP); // Allinea il testo a sinistra e in alto
  uiLayer.textSize(18);
  uiLayer.text(p1.numberOfPotion, 50, 140);
  uiLayer.image(redPotion.sprite, 20, 140, 20, 20);

  // ------- MINIMAPPA ------
  float miniMapSize = 300; // Imposta la dimensione desiderata per la minimappa
  float miniMapX = 20; // Posizione X desiderata nell'angolo in basso a sinistra
  float miniMapY = uiLayer.height - miniMapSize - 10; // Posizione Y desiderata nell'angolo in basso a sinistra

  // Disegna la minimappa nell'angolo in basso a sinistra
  uiLayer.noFill(); // Nessun riempimento
  uiLayer.stroke(255); // Colore del bordo bianco

  // Disegna i bordi delle stanze sulla minimappa come una linea continua
  uiLayer.stroke(255); // Colore del bordo bianco

  for (int x = 0; x < currentLevel.cols; x++) {
    for (int y = 0; y < currentLevel.rows; y++) {
      int tileType = currentLevel.map[x][y];

      // Controlla se il tile è una parete o un corridoio (bordo della stanza)
      if (tileType == 4 || tileType == 5) {
        // Mappa i tile della minimappa nel rettangolo
        float miniMapTileX = map(x, 0, currentLevel.cols, miniMapX, miniMapX + miniMapSize);
        float miniMapTileY = map(y, 0, currentLevel.rows, miniMapY, miniMapY + miniMapSize);

        // Disegna il bordo della stanza sulla minimappa
        uiLayer.point(miniMapTileX, miniMapTileY);
      }
    }
  }

  float playerMiniMapX = map(p1.spritePosition.x, 0, currentLevel.cols, miniMapX, miniMapX + miniMapSize);
  float playerMiniMapY = map(p1.spritePosition.y, 0, currentLevel.rows, miniMapY, miniMapY + miniMapSize);

  uiLayer.fill(255, 0, 0); // Colore rosso per il giocatore
  uiLayer.noStroke();
  uiLayer.ellipse(playerMiniMapX, playerMiniMapY, 5, 5);

  // Disegna i nemici sulla minimappa come pallini gialli
  uiLayer.fill(255, 255, 0); // Colore giallo per i nemici
  uiLayer.noStroke();

  for (Enemy enemy : currentLevel.enemies) {
    float enemyMiniMapX = map(enemy.spritePosition.x, 0, currentLevel.cols, miniMapX, miniMapX + miniMapSize);
    float enemyMiniMapY = map(enemy.spritePosition.y, 0, currentLevel.rows, miniMapY, miniMapY + miniMapSize);
    uiLayer.ellipse(enemyMiniMapX, enemyMiniMapY, 5, 5);
  }

  // ------ ARMA GIOCATORE -----
  uiLayer.noFill(); // Nessun riempimento
  uiLayer.stroke(255); // Colore del bordo bianco
  uiLayer.rect(width / 2, height - 100, 50, 50);

  float scaleFactor = 3.0;

  if (p1.weapon.sprite != null) {

    float imgWidth = p1.weapon.sprite.width * scaleFactor;
    float imgHeight = p1.weapon.sprite.height * scaleFactor;

    float imgX = uiLayer.width / 2 + (50 - imgWidth) / 2;  // Calcola la posizione X dell'immagine al centro
    float imgY = uiLayer.height - 100 + (50 - imgHeight) / 2; // Calcola la posizione Y dell'immagine al centro

    uiLayer.image(p1.weapon.sprite, imgX, imgY, imgWidth, imgHeight);
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

//void resetGame() {
//  // resetta mondo e variabili
//  // reimpostare currentArea e richiamare la initLevels
//  // reimposta la posizione del giocatore e tutti i suoi parametri
//  currentArea = castle.getMacroareas().get(0);
//  currentArea.initLevels();
//  currentLevel = currentArea.getCurrentLevel();
//  p1.setPosition(currentLevel.getStartRoom());
//}
