import processing.sound.*;
import java.util.Iterator;

Player p1;
PImage spriteRight;
PImage spriteLeft;
Weapon weapon;
Item silver_key;
Item golden_key;
Healer redPotion;

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

PImage cross_sprite;

PImage coin_sprite;
PImage torch_sprite;
PImage dungeon_map_sprite;
PImage chest_close_sprite;
PImage chest_open_sprite;
PImage special_chest_close_sprite;
PImage special_chest_open_sprite;
PImage rat_enemy_sprite;
PImage boss_sprite;
PImage orb_sprite;
PImage chela_sprite;

// weapons image
PImage sword_sprite;
PImage master_sword_sprite;

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
SoundFile chest_open;
SoundFile drinkPotion;
SoundFile swordAttack;
SoundFile hurt_sound;
SoundFile enemy_death_sound;

SoundFile menu_background;
boolean isMenuBackgroundPlaying;
SoundFile dungeon_background;
boolean isDungeonBackgroundPlaying;

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

String actualLevel;

// titolo del gioco
String gameTitle = "rangeon game";
PFont myFont;  // font del gioco

Camera camera;

void setup() {
  // dimensioni schermo
  frameRate(60);
  size(1280, 720, P2D);

  ((PGraphicsOpenGL)g).textureSampling(2);
  noSmooth();

  // load font
  myFont = createFont("data/font/minecraft.ttf", 30);
  textFont(myFont);

  // schermata iniziale
  screen_state = ScreenState.MENU_SCREEN;    // menu screen
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
}

void setupItems() {
  golden_key = new Item(null, null, "golden_key");
  silver_key = new Item(null, null, "silver_key");

  // oggetti per il giocatore
  weapon = new Weapon(null, null, "little_sword", 10);

  redPotion = new Healer(null, null, "red_potion", 20);
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
  boss_sprite = loadImage("data/npc/boss_sprite.png");
  orb_sprite = loadImage("data/orb_sprite.png");

  chela_sprite = loadImage("data/chela_sprite.png");

  // golden_key.sprite = loadImage("data/golden_key.png");
  golden_key.updateSprite(loadImage("data/golden_key.png"));
  // silver_key.sprite = loadImage("data/silver_key.png");
  silver_key.updateSprite(loadImage("data/silver_key.png"));

  //weapon.sprite = ;
  weapon.updateSprite(loadImage("data/little_sword.png"));
  sword_sprite = loadImage("data/sword.png");
  master_sword_sprite = loadImage("data/master_sword.png");

  // healers
  // redPotion.sprite = loadImage("data/object/red_potion.png");
  redPotion.updateSprite(loadImage("data/object/red_potion.png"));

  heart_sprite = loadImage("data/heartFull.png");
  half_heart_sprite = loadImage("data/halfHeart.png");
  empty_heart_sprite = loadImage("data/emptyHeart.png");

  torch_sprite = loadImage("data/torch.png");
  dungeon_map_sprite = loadImage("data/dungeon_map.png");

  up_buff = loadImage("data/up_buff.png");
  down_buff = loadImage("data/down_buff.png");
  cross_sprite = loadImage("data/cross.png");
}

void setupSounds() {
  volumeMusicLevel = 0.0;
  volumeEffectsLevel = 0.0;

  click = new SoundFile(this, "data/sound/click.wav");
  pickupCoin = new SoundFile(this, "data/sound/pickupCoin.wav");
  chest_open = new SoundFile(this, "data/sound/chest_open.wav");
  drinkPotion = new SoundFile(this, "data/sound/drink_potion.wav");

  swordAttack = new SoundFile(this, "data/sound/sword_hit.wav");
  hurt_sound = new SoundFile(this, "data/sound/hurt_sound.wav");

  enemy_death_sound = new SoundFile(this, "data/sound/enemy_death.wav");

  menu_background = new SoundFile(this, "data/sound/background/menu_background.wav");
  isMenuBackgroundPlaying = false;

  dungeon_background = new SoundFile(this, "data/sound/background/dungeon_background.wav");
  isDungeonBackgroundPlaying = false;

  click.amp(volumeEffectsLevel);

  pickupCoin.amp(volumeEffectsLevel);
  chest_open.amp(volumeEffectsLevel);
  drinkPotion.amp(volumeEffectsLevel);
  swordAttack.amp(volumeEffectsLevel);
  hurt_sound.amp(volumeEffectsLevel);
  enemy_death_sound.amp(volumeEffectsLevel);

  menu_background.amp(volumeMusicLevel);
  dungeon_background.amp(volumeMusicLevel);
}

void draw() {
  // cambia il titolo della finestra e mostra il framerate
  surface.setTitle("Dungeon Game - " + String.format("%.1f", frameRate));

  switch(screen_state) {
  case MENU_SCREEN:
    // show menu
    if (!isMenuBackgroundPlaying) {
      menu_background.play();
      isMenuBackgroundPlaying = true;
    }

    menu.display();
    break;

  case STORY_SCREEN:
    // show story
    if (isMenuBackgroundPlaying) {
      menu_background.stop();
      isMenuBackgroundPlaying = false;
    }

    storyScreen(currentZone.storyText);
    break;

  case TUTORIAL_SCREEN:
    // show tutorial
    tutorial.display();
    break;

  case GAME_SCREEN:
    if (!isDungeonBackgroundPlaying) {
      dungeon_background.play();
      isDungeonBackgroundPlaying = true;
    }

    // game.update();
    // ui.update();

    // show game screen
    game.display();
    // ui.display();
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
  if (isDungeonBackgroundPlaying) {
    dungeon_background.stop();
    isDungeonBackgroundPlaying = false;
  }

  // chiama la funzione
  writer("Finalmente lo stregone Pagnax e' stato sconfitto!\n" +
    "La principessa Chela e' in salvo e il nostro coraggioso cavaliere e' ora l'eroe del Regno.\n" +
    "Score totalizzato: " + p1.playerScore);

  image(spriteLeft, width / 2 + 50, height / 2 - 120, 64, 64);
  image(chela_sprite, width / 2 - 50, height / 2 - 120, 64, 64);
}

void loseScreen() {
  // salva lo stato precedente
  previous_state = screen_state;

  // stoppa la soundtrack
  if (isDungeonBackgroundPlaying) {
    dungeon_background.stop();
    isDungeonBackgroundPlaying = false;
  }

  // chiama la funzione
  writer("Hai perso!\n" +
    "Score totalizzato: " + p1.playerScore);
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
