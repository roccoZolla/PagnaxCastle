// option screen
class Option {
  ArrayList<Button> buttons;
  PGraphics optionLayer;

  String difficultyLevel = "vacante";

  int effectsVolume;
  int musicVolume;

  Option() {
    optionLayer = createGraphics(width, height);
    buttons = new ArrayList();

    buttons.add(new Button(width - 100, 150, 50, 50, "effectsUp", "+", ""));    // selettore effetti sonori
    buttons.add(new Button(width - 290, 150, 50, 50, "effectsDown", "-", ""));    // (width - 290, 150
    buttons.add(new Button(width - 100, 210, 50, 50, "musicUp", "+", ""));   // selettore volume musica
    buttons.add(new Button(width - 290, 210, 50, 50, "musicDown", "-", ""));
    buttons.add(new Button(width - 100, 280, 50, 50, "difficultyRight", ">", ""));    // selettore difficolta
    buttons.add(new Button(width - 290, 280, 50, 50, "difficultyLeft", "<", ""));
    buttons.add(new Button(100, 420, 200, 80, "commands", "Comandi", ""));
    buttons.add(new Button(width - 250, height - 150, 200, 80, "back", "Back", ""));

    // updateDifficultyText();

    effectsVolume = 0;
    musicVolume = 0;
  }

  void display() {
    optionLayer.beginDraw();
    // cancella lo schermo
    optionLayer.background(0);

    // disegna la scritta opzioni
    optionLayer.textFont(myFont);
    optionLayer.fill(255);
    optionLayer.textSize(36);
    optionLayer.textAlign(CENTER, CENTER);
    optionLayer.text("OPTIONS", 135, 50);

    // linea che parte dalla scritta opzioni e chiudere la pagina
    optionLayer.stroke(255);
    optionLayer.line(235, 50, width - 50, 50);

    // ----- AUDIO -----
    optionLayer.fill(255);
    optionLayer.textSize(30);
    optionLayer.textAlign(LEFT, CENTER);
    optionLayer.text("Audio: ", 100, 100);

    // ----- EFFETTI SONORI -----
    optionLayer.fill(255);
    optionLayer.textSize(30);
    optionLayer.textAlign(LEFT, CENTER);
    optionLayer.text("Effetti sonori: ", 200, 160);

    optionLayer.fill(255);
    optionLayer.textSize(30);
    optionLayer.textAlign(LEFT, CENTER);
    effectsVolume = (int) (volumeEffectsLevel * 10);
    optionLayer.text(effectsVolume, width - 180, 175);

    // ----- MUSICA -----
    optionLayer.fill(255);
    optionLayer.textSize(30);
    optionLayer.textAlign(LEFT, CENTER);
    optionLayer.text("Musica: ", 200, 220);

    optionLayer.fill(255);
    optionLayer.textSize(30);
    optionLayer.textAlign(LEFT, CENTER);
    int musicVolume = (int) (volumeMusicLevel * 10);
    optionLayer.text(musicVolume, width - 180, 235);

    // ----- DIFFICOLTA -----
    optionLayer.fill(255);
    optionLayer.textSize(30);
    optionLayer.textAlign(LEFT, CENTER);
    optionLayer.text("Difficolta: ", 100, 290);

    optionLayer.fill(255);
    optionLayer.textSize(30);
    optionLayer.textAlign(LEFT, CENTER);
    optionLayer.text(difficultyLevel, width - 230, 305);

    // linea che parte dal pulsante back a chiudere a la pagina
    optionLayer.stroke(255);
    optionLayer.line(50, height - 100, width - 270, height - 100);

    for (Button button : buttons) {
      if (button.isClicked()) {
        switch(button.name) {
        case "effectsUp":
          volumeEffectsLevel += 0.1;

          if (volumeEffectsLevel > 1.0) volumeEffectsLevel = 1.0;

          updateEffectsVolume(volumeEffectsLevel);
          break;

        case "effectsDown":
          volumeEffectsLevel -= 0.1;

          if (volumeEffectsLevel < 0.0) volumeEffectsLevel = 0.0;

          updateEffectsVolume(volumeEffectsLevel);
          break;

        case "musicUp":
          volumeMusicLevel += 0.1;

          if (volumeMusicLevel > 1.0) volumeMusicLevel = 1.0;

          updateMusicVolume(volumeMusicLevel);
          break;

        case "musicDown":
          volumeMusicLevel -= 0.1;

          if (volumeMusicLevel < 0.0) volumeMusicLevel = 0.0;
          updateMusicVolume(volumeMusicLevel);
          break;

        case "difficultyRight":
          // changeDifficulty(true);
          break;

        case "difficultyLeft":
          // changeDifficulty(false);
          break;

        case "commands":
          // previous_state = screen_state;
          screen_state = ScreenState.TUTORIAL_SCREEN;
          break;

        case "back":
          if (previous_state == ScreenState.MENU_SCREEN) {
            // salva lo stato
            previous_state = screen_state;

            // torna al menu
            screen_state = ScreenState.MENU_SCREEN;
          } else if (previous_state == ScreenState.PAUSE_SCREEN) {
            // salva lo stato
            previous_state = screen_state;

            // torna alla schermata di pausa
            screen_state = ScreenState.PAUSE_SCREEN;
          }
          break;
        }
      }

      button.update();
      button.display(optionLayer);
    }

    optionLayer.endDraw();
    image(optionLayer, 0, 0);
  }

  void updateScreen() {
    optionLayer = createGraphics(width, height);

    // aggiorna posizione dei bottoni
    buttons.get(0).updatePosition(width - 100, 150, 50, 50);  // effects up
    buttons.get(1).updatePosition(width - 290, 150, 50, 50);  // effect down
    buttons.get(2).updatePosition(width - 100, 210, 50, 50);  // music up
    buttons.get(3).updatePosition(width - 290, 210, 50, 50);  // music down
    buttons.get(4).updatePosition(width - 100, 280, 50, 50);  // difficulty right
    buttons.get(5).updatePosition(width - 290, 280, 50, 50);  // difficulty left
    buttons.get(6).updatePosition(100, 420, 200, 80);  // commands
    buttons.get(7).updatePosition(width - 250, height - 150, 200, 80);  // back
  }

  void updateEffectsVolume(float volumeEffectsLevel) {
    click.amp(volumeEffectsLevel);
    pickupCoin.amp(volumeEffectsLevel);
    chest_open.amp(volumeEffectsLevel);
    drinkPotion.amp(volumeEffectsLevel);
    swordAttack.amp(volumeEffectsLevel);
    hurt_sound.amp(volumeEffectsLevel);
    enemy_death_sound.amp(volumeEffectsLevel);
  }

  void updateMusicVolume(float volumeMusicLevel) {
    menu_background.amp(volumeMusicLevel);
    dungeon_background.amp(volumeMusicLevel);
  }

  // aggiorna il testo da mostrare in base alla difficolta corrente
  void updateDifficultyText() {
    switch(game.difficultyLevel) {
    case FACILE:
      difficultyLevel = "Facile";
      break;

    case NORMALE:
      difficultyLevel = "Normale";
      break;

    case DIFFICILE:
      difficultyLevel = "Difficile";
      break;
    }
  }

  // incrementa o decrementa il livello di difficolta
  void changeDifficulty(boolean increases) {
    if (game.difficultyLevel == DifficultyLevel.DIFFICILE && increases) {
      // se il livello di difficolta è massimo non fare niente
      return;
    } else if (game.difficultyLevel == DifficultyLevel.FACILE && !increases) {
      // se il livello di difficolta è il minimo non fare niente
      return;
    }

    if (increases) {
      game.difficultyLevel = DifficultyLevel.values()[(game.difficultyLevel.ordinal() + 1) % DifficultyLevel.values().length];
    } else {
      game.difficultyLevel = DifficultyLevel.values()[(game.difficultyLevel.ordinal() - 1 + DifficultyLevel.values().length) % DifficultyLevel.values().length];
    }

    updateDifficultyText();
  }
}
