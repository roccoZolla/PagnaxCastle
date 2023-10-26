import processing.sound.*;

Player p1;
Item weapon;
Item silver_key;
Item golden_key;
Item redPotion;
Chest selectedChest;

//
Menu menu;
Pause pauseMenu;
Option optionMenu;
UI ui;

// ui
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
Zone currentZone;
Level currentLevel;

float proximityThreshold = 0.5; // Soglia di prossimità consentita per le scale
float coinCollectionThreshold = 0.5; // soglia di prossimita per il raccoglimento delle monete
String actualLevel;

// titolo del gioco
String gameTitle = "dungeon game";
PFont myFont;  // font del gioco

Camera camera;

PGraphics gameScene;
PGraphics spritesLayer;

void setup() {
  // dimensioni schermo
  // frameRate(60);
  size(1280, 720);

  gameScene = createGraphics(width, height);
  spritesLayer = createGraphics(width, height);

  // load font
  myFont = createFont("data/font/Minecraft.ttf", 20);
  textFont(myFont);

  // schermata iniziale
  screen_state = MENU_SCREEN;
  previous_state = screen_state;

  menu = new Menu();
  pauseMenu = new Pause();
  optionMenu = new Option();
  ui = new UI();

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

  selectedChest = null;
}

void setupImages() {
  letter_k = loadImage("data/letter_k.png");
  coins = loadImage("data/coin.png");
}

void setupSounds() {
  volumeMusicLevel = 0.0;
  volumeEffectsLevel = 0.0;

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

  currentZone = castle.currentZone;
  currentLevel = currentZone.currentLevel;
  currentLevel.init();

  actualLevel = currentZone.zoneName + " - " + currentLevel.levelName;

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

  camera = new Camera();
}

void draw() {
  // cambia il titolo della finestra e mostra il framerate
  surface.setTitle(String.format("%.1f", frameRate));

  switch(screen_state) {
  case MENU_SCREEN:
    // show menu
    menu.display();
    break;

  case STORY_SCREEN:
    // show story
    storyScreen(currentZone.storyText);
    break;

  case GAME_SCREEN:
    if (!isSoundtrackPlaying) {
      soundtrack.play();
      isSoundtrackPlaying = true;
    }

    // show game screen
    gameScreen();

    image(gameScene, 0, 0);
    image(spritesLayer, 0, 0);
    ui.display();
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
    pauseMenu.display();
    break;

  case OPTION_SCREEN:
    optionMenu.display();
    break;

  default:
    System.out.println("errore");
  }
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
  p1.move();

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

  // mostra il player
  p1.display(spritesLayer);
  spritesLayer.endDraw();


  // passa al livello successivo
  if (dist(p1.spritePosition.x, p1.spritePosition.y, currentLevel.getEndRoomPosition().x, currentLevel.getEndRoomPosition().y) < proximityThreshold) {
    // se il livello dell'area è l'ultimo passa alla prossima area
    if (currentLevel.levelIndex == currentZone.numLevels - 1) {
      // controlla se è l'area finale
      if (currentZone.isFinal()) {
        screen_state = WIN_SCREEN;
      } else {
        // passa alla prossima macroarea
        currentZone = castle.zones.get(currentZone.zoneIndex + 1);
        // currentArea.initLevels();
        currentLevel = currentZone.currentLevel;
        currentLevel.init();
        actualLevel = currentZone.zoneName + " - " + currentLevel.levelName;
        p1.spritePosition = currentLevel.getStartRoom();

        // aggiorna lo score del player
        p1.playerScore +=  200;
        screen_state = STORY_SCREEN;
      }
    } else {
      // passa al livello successivo - stessa macro area
      // Il giocatore è abbastanza vicino al punto di accesso, quindi passa al livello successivo
      currentLevel = currentZone.levels.get(currentLevel.levelIndex + 1);
      currentLevel.init();
      actualLevel = currentZone.zoneName + " - " + currentLevel.levelName;
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
