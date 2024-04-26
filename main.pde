// per gestione del controller
//import net.java.games.input.*;
//import org.gamecontrolplus.*;
//import org.gamecontrolplus.gui.*;

import processing.sound.*;
import java.util.Iterator;

Player p1;

// trovare una soluzione
Item silver_key;
Item golden_key;

// lingue di gioco
JSONObject bundleITA;
JSONObject bundleENG;

//
Menu menu;
Pause pauseMenu;
Option optionMenu;
CommandScreen commandScreen;
UI ui;

// gioco, render e collision logic
Game game;
RenderSystem render;
CollisionSystem collision;
FisicoSystem fisico;

// logo screen
PImage studio_logo;

// ui
PImage letter_w;
PImage letter_a;
PImage letter_s;
PImage letter_d;
PImage letter_j;
PImage letter_k;
PImage letter_l;

PImage cross_sprite;

// items
PImage coin_sprite;
PImage torch_sprite;
PImage dungeon_map_sprite;
PImage chest_close_sprite;
PImage chest_open_sprite;
PImage special_chest_close_sprite;
PImage special_chest_open_sprite;
PImage golden_key_sprite;
PImage silver_key_sprite;
PImage red_potion_sprite;

PImage rat_enemy_sprite;

PImage orb_sprite;

PImage boss_sprite;
PImage chela_sprite;

// weapons image
PImage small_sword_sprite;
PImage sword_sprite;
PImage master_sword_sprite;

PImage heart_sprite;
PImage half_heart_sprite;
PImage empty_heart_sprite;

PImage up_buff;
PImage down_buff;

// sound effect
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

// test
Timer fps_timer;
Timer tick_timer;

Timer fps_clock;
Timer tick_clock;

int counted_frames = 0;
int counted_ticks = 0;
float avg_fps = 0;
float avg_trate = 0;

long logoScreenStartTime = 0;

enum ScreenState {
  LOGO_SCREEN,
    MENU_SCREEN,
    GAME_SCREEN,
    STORY_SCREEN,
    WIN_SCREEN,
    LOSE_SCREEN,
    PAUSE_SCREEN,
    OPTION_SCREEN,
    COMMAND_SCREEN
}

// stato dello schermo
ScreenState screen_state;
ScreenState previous_state;  // salva lo stato precedente

String actualLevel;

// for the writer function
int letterIndex = 0; // Indice della lettera corrente
boolean isTyping = true; // Indica se il testo sta ancora venendo digitato

PFont myFont;  // font del gioco

Language language;

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
  screen_state = ScreenState.LOGO_SCREEN;    // menu screen
  previous_state = screen_state;

  // lingua di default
  language = Language.ITALIAN;

  bundleITA = loadJSONObject("data/language/it_game.json");
  bundleENG = loadJSONObject("data/language/en_game.json");

  game = new Game();
  render = new RenderSystem();
  collision = new CollisionSystem();
  fisico = new FisicoSystem();

  menu = new Menu();
  pauseMenu = new Pause();
  optionMenu = new Option();
  commandScreen = new CommandScreen();
  ui = new UI();

  // crea gli oggetti relativi ai timer
  fps_timer = new Timer();
  tick_timer = new Timer();

  fps_clock = new Timer();
  tick_clock = new Timer();

  // setup image
  setupImages();

  // setup sound
  setupSounds();

  logoScreenStartTime = millis();
  
  menu.updateLanguage(language);
  pauseMenu.updateLanguage(language);
  optionMenu.updateLanguage(language);
  commandScreen.updateLanguage(language);
}

void setupImages() {
  // studio logo
  studio_logo = loadImage("data/studio_logo.jpeg");

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

  golden_key_sprite = loadImage("data/golden_key.png");
  silver_key_sprite = loadImage("data/silver_key.png");

  //weapon.sprite = ;
  small_sword_sprite = (loadImage("data/little_sword.png"));
  sword_sprite = loadImage("data/sword.png");
  master_sword_sprite = loadImage("data/master_sword.png");

  // healers
  red_potion_sprite = loadImage("data/object/red_potion.png");

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
  volumeMusicLevel = 0.1;
  volumeEffectsLevel = 0.3;

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
  surface.setTitle("Pagnax's Castle - " + String.format("%.1f", frameRate));

  switch(screen_state) {
    // da sistemare
    // si deve vedere per qualche secondo
    // aggiungere effetto blurrato
  case LOGO_SCREEN:
    background(241, 233, 220, 255);
    image(studio_logo, width / 2 - studio_logo.width/2, height / 2 - studio_logo.height/2);
    if (millis() - logoScreenStartTime >= 1500) {
      screen_state = ScreenState.MENU_SCREEN;
    }
    break;

  case MENU_SCREEN:
    // show menu
    if (!isMenuBackgroundPlaying && volumeMusicLevel > 0) {
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
    image(p1.right_side, width / 2, height / 2 - 130, 64, 64);
    break;

  case COMMAND_SCREEN:
    // show tutorial
    commandScreen.display();
    break;

  case GAME_SCREEN:
    if (!isDungeonBackgroundPlaying && volumeMusicLevel > 0) {
      dungeon_background.loop();
      isDungeonBackgroundPlaying = true;
    }

    // cercare altre soluzioni
    // show game screen
    // cercare di ridurre il numero di chiamate
    if (tick_clock.getTicks() > 1000.f / Utils.TICK_RATE) {
      // tick(tick_clock.getTicks());
      game.update();

      tick_clock.timerReset();
      tickStats();
    }

    // verifica se è il momento di eseguire il rendering della scena
    // render loop
    if (fps_clock.getTicks() > 1000.f / Utils.SCREEN_FPS_CAP) {
      collision.update();
      fisico.update();
      render.update();
      ui.update();

      renderStats();
      fps_clock.timerReset();
    }
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
    "La principessa Chela e' in salvo e il nostro coraggioso Cavaliere e' ora l'eroe del Regno.\n" +
    "Score totalizzato: " + p1.playerScore);

  image(p1.left_side, width / 2 + 50, height / 2 - 120, 64, 64);
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
  writer("Sei stato sconfitto Cavaliere!\n" +
    "Score totalizzato: " + p1.playerScore);

  image(boss_sprite, width / 2, height / 2 - 120, 64, 64);
}

void storyScreen(String storyText) {
  // salva lo stato precedente
  previous_state = screen_state;

  // chiama il writer
  writer(storyText);
}

void tickStats() {
  if (counted_ticks >= 20) {
    avg_trate = counted_ticks / (tick_timer.getTicks() / 1000.f);
    counted_ticks = 0;
    tick_timer.timerStart();
  }

  ++counted_ticks;
}

void renderStats() {
  if (counted_frames >= 10) {
    avg_fps = counted_frames / (fps_timer.getTicks() / 1000.f);
    counted_frames = 0;
    fps_timer.timerReset();
  }

  ++counted_frames;
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
    if (frameCount % Utils.typingSpeed == 0) {
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
