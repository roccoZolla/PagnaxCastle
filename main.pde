import processing.sound.*;
import java.util.Iterator;

Player p1;
PImage spriteRight;
PImage spriteLeft;
Weapon sword;
Item silver_key;
Item golden_key;
Healer redPotion;
Healer greenPotion;
Healer heart;
Chest selectedChest;

//
Menu menu;
Pause pauseMenu;
Option optionMenu;
Tutorial tutorial;
UI ui;
Game game;

// ui
PImage letter_w;
PImage letter_a;
PImage letter_s;
PImage letter_d;
PImage letter_j;
PImage letter_k;
PImage letter_l;

PImage coins;
PImage torch_sprite;
PImage dungeon_map_sprite;
PImage chest_open_sprite;
PImage special_chest_open_sprite;

// sound effect
float volumeMusicLevel;
float volumeEffectsLevel;    // oscilla tra 0.0 e 1.0

SoundFile pickupCoin;
SoundFile normalChestOpen;
SoundFile specialChestOpen;
SoundFile drinkPotion;
SoundFile attackHit;

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
final int TUTORIAL_SCREEN = 7;

World castle;
Zone currentZone;
Level currentLevel;

float proximityThreshold = 0.5; // Soglia di prossimità consentita per le scale
String actualLevel;

// titolo del gioco
String gameTitle = "dungeon game";
PFont myFont;  // font del gioco

Camera camera;

PGraphics gameScene;
PGraphics spritesLayer;
PGraphics maskLayer;

void setup() {
  // dimensioni schermo
  frameRate(60);
  size(1280, 720, P2D);

  ((PGraphicsOpenGL)g).textureSampling(2);
  noSmooth();

  gameScene = createGraphics(width, height);
  spritesLayer = createGraphics(width, height);
  maskLayer = createGraphics(width, height);

  // load font
  myFont = createFont("data/font/minecraft.ttf", 30);
  textFont(myFont);

  // schermata iniziale
  screen_state = MENU_SCREEN;
  previous_state = screen_state;

  menu = new Menu();
  pauseMenu = new Pause();
  optionMenu = new Option();
  tutorial = new Tutorial();
  ui = new UI();
  game = new Game();

  // setup image
  setupImages();

  // setup sound
  setupSounds();

  // setup items (PROVVISORIO)
  setupItems();

  selectedChest = null;
}

void setupImages() {
  // sprites player
  spriteRight = loadImage("data/playerRIGHT.png");
  spriteLeft = loadImage("data/playerLEFT.png");
  
  // movimento
  letter_w = loadImage("data/letter_w.png");
  letter_a = loadImage("data/letter_a.png");
  letter_s = loadImage("data/letter_s.png");
  letter_d = loadImage("data/letter_d.png");
  
  // interazione oggetti
  letter_k = loadImage("data/letter_k.png");
  
  // attcca
  letter_j = loadImage("data/letter_j.png");
  
  // utilizza oggetti
  letter_l = loadImage("data/letter_l.png");
  
  coins = loadImage("data/coin.png");
  
  chest_open_sprite = loadImage("data/object/chest_open.png");
  special_chest_open_sprite = loadImage("data/object/special_chest_open.png");
}

void setupSounds() {
  volumeMusicLevel = 0.0;
  volumeEffectsLevel = 0.0;

  pickupCoin = new SoundFile(this, "data/sound/pickupCoin.wav");
  normalChestOpen = new SoundFile(this, "data/sound/normal_chest_open.wav");
  specialChestOpen = new SoundFile(this, "data/sound/special_chest_open.wav");
  drinkPotion = new SoundFile(this, "data/sound/drink_potion.wav");
  // attackHit = new SoundFile(this, "data/sound/sword_hit.wav");

  soundtrack = new SoundFile(this, "data/sound/dungeon_soundtrack.wav");
  isSoundtrackPlaying = false;

  pickupCoin.amp(volumeEffectsLevel);
  normalChestOpen.amp(volumeEffectsLevel);
  specialChestOpen.amp(volumeEffectsLevel);
  drinkPotion.amp(volumeEffectsLevel);
  // attackHit.amp(volumeEffectsLevel);

  soundtrack.amp(volumeMusicLevel);
}

void setupItems() {
  golden_key = new Item(2, "golden_key");
  silver_key = new Item(4, "silver_key");
  
  // oggetiti per il giocatore
  sword = new Weapon("sword", 10);
  redPotion = new Healer("red_potion", 20);
  greenPotion = new Healer("green_potion", 100);
  
  // drop items
  heart = new Healer("heart", 10);

  golden_key.sprite = loadImage("data/golden_key.png");
  silver_key.sprite = loadImage("data/silver_key.png");
  sword.sprite = loadImage("data/little_sword.png");
  redPotion.sprite = loadImage("data/object/red_potion.png");
  greenPotion.sprite = loadImage("data/object/green_potion.png");
  heart.sprite = loadImage("data/heartFull.png");
  torch_sprite = loadImage("data/torch.png");
  // dungeon_map_sprite = loadImage("data/dungeon_map_sprite.png");
}

void draw() {
  // cambia il titolo della finestra e mostra il framerate
  surface.setTitle("Dungeon Game - " + String.format("%.1f", frameRate));

  switch(screen_state) {
  case MENU_SCREEN:
    // show menu
    menu.display();
    break;

  case STORY_SCREEN:
    // show story
    storyScreen(currentZone.storyText);
    break;
    
    case TUTORIAL_SCREEN:
    // show tutorial
    tutorial.display();
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
  
  // stoppa la soundtrack
  if (isSoundtrackPlaying) {
    soundtrack.stop();
    isSoundtrackPlaying = false;
  }

  // chiama la funzione
  writer("Hai vinto!\n" +
         "Score totalizzato: " + p1.playerScore);
}

void loseScreen() {
  // salva lo stato precedente
  previous_state = screen_state;
  
  // stoppa la soundtrack
  if (isSoundtrackPlaying) {
    soundtrack.stop();
    isSoundtrackPlaying = false;
  }

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
