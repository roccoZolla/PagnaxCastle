import processing.sound.*;
import java.util.Iterator;

Player p1;
PImage spriteRight;
PImage spriteLeft;
Weapon little_sword;
Weapon sword;
Item silver_key;
Item golden_key;
// Item torch;
// Item dungeon_map;
Healer redPotion;
Healer greenPotion;

// Chest selectedChest;

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

PImage coin_sprite;
PImage torch_sprite;
PImage dungeon_map_sprite;
PImage chest_close_sprite;
PImage chest_open_sprite;
PImage special_chest_close_sprite;
PImage special_chest_open_sprite;
PImage rat_enemy_sprite;

PImage heart_sprite;
PImage half_heart_sprite;
PImage empty_heart_sprite;

PImage up_buff;
PImage down_buff;

// sound effect
// float volumeMenuLevel;
float volumeMusicLevel;
float volumeEffectsLevel;    // oscilla tra 0.0 e 1.0

SoundFile click;
SoundFile pickupCoin;
SoundFile normalChestOpen;
SoundFile specialChestOpen;
SoundFile drinkPotion;
SoundFile swordAttack;
SoundFile playerHurt;

SoundFile soundtrack;
boolean isSoundtrackPlaying;

enum ScreenState {
  MENU_SCREEN,
  GAME_SCREEN,
  STORY_SCREEN,
  WIN_SCREEN,
  LOSE_SCREEN,
  PAUSE_SCREEN,
  OPTION_SCREEN,
  TUTORIAL_SCREEN
}

// stato dello schermo
ScreenState screen_state;
ScreenState previous_state;  // salva lo stato precedente


World castle;
Zone currentZone;
Level currentLevel;

float proximityThreshold = 0.5; // Soglia di prossimità consentita per le scale
String actualLevel;

// titolo del gioco
String gameTitle = "rangeon game";
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
  screen_state = ScreenState.MENU_SCREEN;
  previous_state = screen_state;

  menu = new Menu();
  game = new Game();
  pauseMenu = new Pause();
  optionMenu = new Option();
  tutorial = new Tutorial();
  ui = new UI();
  
  // setup items (PROVVISORIO)
  setupItems();

  // setup image
  setupImages();

  // setup sound
  setupSounds();

  // selectedChest = null;
}

void setupItems() {
  golden_key = new Item(2, "golden_key");
  silver_key = new Item(4, "silver_key");
  
  // oggetti per il giocatore
  little_sword = new Weapon("little_sword", 10);
  sword = new Weapon("sword", 20);
  
  redPotion = new Healer("red_potion", 20);
  greenPotion = new Healer("green_potion", 100);
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
  
  coin_sprite = loadImage("data/coin.png");
  
  chest_close_sprite = loadImage("data/object/chest_close.png");
  chest_open_sprite = loadImage("data/object/chest_open.png");
  special_chest_close_sprite = loadImage("data/object/special_chest_close.png");
  special_chest_open_sprite = loadImage("data/object/special_chest_open.png");
  
  rat_enemy_sprite = loadImage("data/npc/rat_enemy.png");
  
  golden_key.sprite = loadImage("data/golden_key.png");
  silver_key.sprite = loadImage("data/silver_key.png");
  
  little_sword.sprite = loadImage("data/little_sword.png");
  sword.sprite = loadImage("data/sword.png");
  
  // healers
  redPotion.sprite = loadImage("data/object/red_potion.png");
  greenPotion.sprite = loadImage("data/object/green_potion.png");
  
  heart_sprite = loadImage("data/heartFull.png");
  half_heart_sprite = loadImage("data/halfHeart.png");
  empty_heart_sprite = loadImage("data/emptyHeart.png");
  
  torch_sprite = loadImage("data/torch.png");
  dungeon_map_sprite = loadImage("data/dungeon_map.png");
  
  up_buff = loadImage("data/up_buff.png");
  down_buff = loadImage("data/down_buff.png");
}

void setupSounds() {
  // volumeMenuLevel = 0.5;
  volumeMusicLevel = 0.0;
  volumeEffectsLevel = 0.0;
  
  // click = new SoundFile(this, "data/sound/click.wav");
  pickupCoin = new SoundFile(this, "data/sound/pickupCoin.wav");
  normalChestOpen = new SoundFile(this, "data/sound/normal_chest_open.wav");
  specialChestOpen = new SoundFile(this, "data/sound/special_chest_open.wav");
  drinkPotion = new SoundFile(this, "data/sound/drink_potion.wav");
  
  swordAttack = new SoundFile(this, "data/sound/swordAttack.wav");
  playerHurt = new SoundFile(this, "data/sound/player_hurt.wav");

  soundtrack = new SoundFile(this, "data/sound/background/dungeon_soundtrack.wav");
  isSoundtrackPlaying = false;
  
  // click.amp(volumeMenuLevel);
  
  pickupCoin.amp(volumeEffectsLevel);
  normalChestOpen.amp(volumeEffectsLevel);
  specialChestOpen.amp(volumeEffectsLevel);
  drinkPotion.amp(volumeEffectsLevel);
  swordAttack.amp(volumeEffectsLevel);
  playerHurt.amp(volumeEffectsLevel);

  soundtrack.amp(volumeMusicLevel);
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
  writer("hai perso merda!");
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
