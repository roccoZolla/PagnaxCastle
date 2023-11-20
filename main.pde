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
Game game;

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
int screen_state;
int previous_state;  // salva lo stato precedente
final int MENU_SCREEN = 0;
final int GAME_SCREEN = 1;
final int STORY_SCREEN = 2;
final int WIN_SCREEN = 3;
final int LOSE_SCREEN = 4;
final int PAUSE_SCREEN = 5;
final int OPTION_SCREEN = 6;

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
  frameRate(60);
  size(1280, 720, P2D);

  ((PGraphicsOpenGL)g).textureSampling(2);
  noSmooth();

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
  game = new Game();

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
    game.display();
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