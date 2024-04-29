enum Language {
  ITALIAN,
    ENGLISH
}

enum Controller {
  KEYPAD,
    GAMEPAD
}

enum Difficulty {
  FACILE,
    NORMALE,
    DIFFICILE
}

//enum TypeButton {
//  EFFECTSUP,
//    EFFECTSDOWN,
//    MUSICUP,
//    MUSICDOWN,
//    DIFFICULTYRIGHT,
//    DIFFICULTYLEFT,
//    CONTROLLERRIGHT,
//    CONTROLLERLEFT,
//    LANGUAGERIGHT,
//    LANGUAGELEFT,
//    COMMANDS,
//    CREDITS,
//    BACK
//}

// option screen
class Option {
  ArrayList<Button> buttons;
  PGraphics optionLayer;

  HashMap<String, String> strings;

  // title
  String title = "";

  // audio
  String audio = "";
  String sound_effects = "";
  String music = "";

  String difficultyText = "";

  String languageText = "";

  String controllerText = "";

  String commands = "";

  String credits = "";

  String back = "";


  // da togliere
  String difficultyLevel = "";
  String typeController = "";
  String languageType = "";

  int effectsVolume = 0;
  int musicVolume = 0;

  Option() {
    optionLayer = createGraphics(width, height);
    buttons = new ArrayList();

    buttons.add(new Button(width - 100, 150, 50, 50, "effectsUp", "+", ""));    // selettore effetti sonori
    buttons.add(new Button(width - 290, 150, 50, 50, "effectsDown", "-", ""));    // (width - 290, 150

    buttons.add(new Button(width - 100, 210, 50, 50, "musicUp", "+", ""));   // selettore volume musica
    buttons.add(new Button(width - 290, 210, 50, 50, "musicDown", "-", ""));

    buttons.add(new Button(width - 100, 280, 50, 50, "difficultyRight", ">", ""));    // selettore difficolta
    buttons.add(new Button(width - 290, 280, 50, 50, "difficultyLeft", "<", ""));

    // selettore tipo comandi
    buttons.add(new Button(width - 100, 350, 50, 50, "controllerRight", ">", ""));
    buttons.add(new Button(width - 290, 350, 50, 50, "controllerLeft", "<", ""));

    // selettore lingua
    buttons.add(new Button(width - 100, 420, 50, 50, "languageRight", ">", ""));
    buttons.add(new Button(width - 290, 420, 50, 50, "languageLeft", "<", ""));

    buttons.add(new Button(100, 540, 200, 80, "commands", commands, ""));

    buttons.add(new Button(200, 540, 200, 80, "credits", credits, ""));

    buttons.add(new Button(width - 250, height - 120, 200, 80, "back", back, ""));  // back button

    // updateDifficultyText();
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
    optionLayer.text(title, 135, 50);

    // linea che parte dalla scritta opzioni e chiudere la pagina
    optionLayer.stroke(255);
    optionLayer.line(235, 50, width - 50, 50);

    // ----- AUDIO -----
    optionLayer.fill(255);
    optionLayer.textSize(30);
    optionLayer.textAlign(LEFT, CENTER);
    optionLayer.text(audio + ": ", 100, 100);

    // ----- EFFETTI SONORI -----
    optionLayer.fill(255);
    optionLayer.textSize(30);
    optionLayer.textAlign(LEFT, CENTER);
    optionLayer.text(sound_effects + ": ", 200, 160);

    optionLayer.fill(255);
    optionLayer.textSize(30);
    optionLayer.textAlign(LEFT, CENTER);
    effectsVolume = (int) (volumeEffectsLevel * 10);
    optionLayer.text(effectsVolume, width - 180, 175);

    // ----- MUSICA -----
    optionLayer.fill(255);
    optionLayer.textSize(30);
    optionLayer.textAlign(LEFT, CENTER);
    optionLayer.text(music + ": ", 200, 220);

    optionLayer.fill(255);
    optionLayer.textSize(30);
    optionLayer.textAlign(LEFT, CENTER);
    int musicVolume = (int) (volumeMusicLevel * 10);
    optionLayer.text(musicVolume, width - 180, 235);

    // ----- DIFFICOLTA -----
    optionLayer.fill(255);
    optionLayer.textSize(30);
    optionLayer.textAlign(LEFT, CENTER);
    optionLayer.text(difficultyText + ": ", 100, 290);

    optionLayer.fill(255);
    optionLayer.textSize(30);
    optionLayer.textAlign(LEFT, CENTER);
    optionLayer.text(difficultyLevel, width - 230, 305);

    // ----- CONTROLLER -----
    optionLayer.fill(255);
    optionLayer.textSize(30);
    optionLayer.textAlign(LEFT, CENTER);
    optionLayer.text(controllerText + ": ", 100, 360);

    optionLayer.fill(255);
    optionLayer.textSize(30);
    optionLayer.textAlign(LEFT, CENTER);
    optionLayer.text(typeController, width - 230, 375);


    // ----- LINGUA -----
    optionLayer.fill(255);
    optionLayer.textSize(30);
    optionLayer.textAlign(LEFT, CENTER);
    optionLayer.text(languageText + ": ", 100, 430);

    optionLayer.fill(255);
    optionLayer.textSize(30);
    optionLayer.textAlign(LEFT, CENTER);
    optionLayer.text(languageType, width - 230, 445);  // da cambiare

    // linea che parte dal pulsante back a chiudere a la pagina
    optionLayer.stroke(255);
    optionLayer.line(50, height - 80, width - 270, height - 80);

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

          // difficolta
        case "difficultyRight":
          // println("tasto difficolta destro");
          changeDifficulty(true);
          break;

        case "difficultyLeft":
          changeDifficulty(false);
          break;

          // controlli
        case "controllerRight":
          changeController(true);
          break;

        case "controllerLeft":
          changeController(false);
          break;

          // lingua
        case "languageRight":
          changeLanguage(true);
          break;

        case "languageLeft":
          changeLanguage(false);
          break;

        case "commands":
          // previous_state = screen_state;
          screen_state = ScreenState.COMMAND_SCREEN;
          break;

        case "credits":
          screen_state = ScreenState.CREDIT_SCREEN;
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
    buttons.get(6).updatePosition(width - 100, 350, 50, 50);  // controller right
    buttons.get(7).updatePosition(width - 290, 350, 50, 50);  // controller left
    buttons.get(8).updatePosition(width - 100, 420, 50, 50);  // language right
    buttons.get(9).updatePosition(width - 290, 420, 50, 50);  // language left
    buttons.get(10).updatePosition(100, 490, 200, 80);  // commands
    buttons.get(11).updatePosition(400, 490, 200, 80);  // credits
    buttons.get(12).updatePosition(width - 250, height - 120, 200, 80);  // back
  }

  private void updateEffectsVolume(float volumeEffectsLevel) {
    click.amp(volumeEffectsLevel);
    pickupCoin.amp(volumeEffectsLevel);
    chest_open.amp(volumeEffectsLevel);
    drinkPotion.amp(volumeEffectsLevel);
    swordAttack.amp(volumeEffectsLevel);
    hurt_sound.amp(volumeEffectsLevel);
    enemy_death_sound.amp(volumeEffectsLevel);
  }

  private void updateMusicVolume(float volumeMusicLevel) {
    menu_background.amp(volumeMusicLevel);
    dungeon_background.amp(volumeMusicLevel);
  }

  // incrementa o decrementa il livello di difficolta
  private void changeDifficulty(boolean increases) {
    if (difficulty == Difficulty.DIFFICILE && increases) {
      // se il livello di difficolta è massimo non fare niente
      return;
    } else if (difficulty == Difficulty.FACILE && !increases) {
      // se il livello di difficolta è il minimo non fare niente
      return;
    }

    if (increases) {
      difficulty = Difficulty.values()[(difficulty.ordinal() + 1) % Difficulty.values().length];
    } else {
      difficulty = Difficulty.values()[(difficulty.ordinal() - 1 + Difficulty.values().length) % Difficulty.values().length];
    }

    updateDifficultyText();

    // udpate della difficolta di gioco
  }

  private void updateDifficultyText() {
    switch(difficulty)
    {
      // DA RIVEDERE
    case FACILE:
      if (languageSystem.language == Language.ITALIAN) difficultyLevel = bundleITA.getJSONObject("menu").getJSONObject("options").getString("easy");
      else if (languageSystem.language == Language.ENGLISH) difficultyLevel = bundleENG.getJSONObject("menu").getJSONObject("options").getString("easy");
      break;

    case NORMALE:
      if (languageSystem.language == Language.ITALIAN) difficultyLevel = bundleITA.getJSONObject("menu").getJSONObject("options").getString("normal");
      else if (languageSystem.language == Language.ENGLISH) difficultyLevel = bundleENG.getJSONObject("menu").getJSONObject("options").getString("normal");
      break;

    case DIFFICILE:
      if (languageSystem.language == Language.ITALIAN) difficultyLevel = bundleITA.getJSONObject("menu").getJSONObject("options").getString("hard");
      else if (languageSystem.language == Language.ENGLISH) difficultyLevel = bundleENG.getJSONObject("menu").getJSONObject("options").getString("hard");
      break;
    }
  }

  private void changeLanguage(boolean increases) {
    Language language = languageSystem.language;

    if (language == Language.ITALIAN && increases)
    {
      // se il livello di difficolta è massimo non fare niente
      return;
    } else if (language == Language.ENGLISH && !increases)
    {
      // se il livello di difficolta è il minimo non fare niente
      return;
    }

    if (increases) {
      language = Language.values()[(language.ordinal() + 1) % Language.values().length];
    } else {
      language = Language.values()[(language.ordinal() - 1 + Language.values().length) % Language.values().length];
    }

    // fare in modo che la modifica della lingua si propaghi su tutte le altre schermate
    languageSystem.setLanguage(language);
    languageSystem.update();
  }

  private void changeController(boolean increases) {
    if (controller == Controller.KEYPAD && increases)
    {
      // se il livello di difficolta è massimo non fare niente
      return;
    } else if (controller == Controller.GAMEPAD && !increases)
    {
      // se il livello di difficolta è il minimo non fare niente
      return;
    }

    if (increases)
    {
      controller = Controller.values()[(controller.ordinal() + 1) % Controller.values().length];
    } else {
      controller = Controller.values()[(controller.ordinal() - 1 + Controller.values().length) % Controller.values().length];
    }

    // update controlli di gioco
    updateControllerText();
  }

  private void updateControllerText() {
    Language language = languageSystem.language;

    switch(controller) {
    case KEYPAD:
      if (language == Language.ITALIAN) typeController = bundleITA.getJSONObject("menu").getJSONObject("options").getString("keypad");
      else if (language == Language.ENGLISH) typeController = bundleENG.getJSONObject("menu").getJSONObject("options").getString("keypad");
      break;

    case GAMEPAD:
      if (language == Language.ITALIAN) typeController = bundleITA.getJSONObject("menu").getJSONObject("options").getString("gamepad");
      else if (language == Language.ENGLISH) typeController = bundleENG.getJSONObject("menu").getJSONObject("options").getString("gamepad");
      break;
    }
  }

  // metodo migliore rispetto al mio
  // piu rapido e modulare
  void updateLanguage(Language language) {
    strings = getStringsForLanguage(language);
    updateUI();
  }

  void updateUI() {
    title = strings.get("title");

    audio = strings.get("audio");
    sound_effects = strings.get("soundEffect");
    music = strings.get("music");

    difficultyText = strings.get("difficulty");
    difficultyLevel = strings.get("difficultyLevel");
    controllerText = strings.get("controller");
    typeController = strings.get("typeController");
    languageText = strings.get("language");
    languageType = strings.get("languageType");
    commands = strings.get("commands");
    buttons.get(10).setLabel(commands);
    credits = strings.get("credits");
    buttons.get(11).setLabel(credits);
    back = strings.get("back");
    buttons.get(12).setLabel(back);
  }

  HashMap<String, String> getStringsForLanguage(Language language) {
    HashMap<String, String> languageStrings = new HashMap<String, String>();
    JSONObject bundle = null;
    if (language == Language.ITALIAN) {
      bundle = bundleITA.getJSONObject("menu").getJSONObject("options");
    } else if (language == Language.ENGLISH) {
      bundle = bundleENG.getJSONObject("menu").getJSONObject("options");
    }

    languageStrings.put("title", bundle.getString("title")); // rimane invariato

    languageStrings.put("audio", bundle.getString("audio"));
    languageStrings.put("soundEffect", bundle.getString("soundEffect"));
    languageStrings.put("music", bundle.getString("music"));

    languageStrings.put("difficulty", bundle.getString("difficulty"));
    switch(difficulty)
    {
    case DIFFICILE:
      languageStrings.put("difficultyLevel", bundle.getString("hard"));
      break;

    case NORMALE:
      languageStrings.put("difficultyLevel", bundle.getString("normal"));
      break;

    case FACILE:
      languageStrings.put("difficultyLevel", bundle.getString("easy"));
      break;
    }

    languageStrings.put("controller", bundle.getString("controller"));
    if (controller == Controller.KEYPAD)
    {
      languageStrings.put("typeController", bundle.getString("keypad"));
    } else if (controller == Controller.GAMEPAD)
    {
      languageStrings.put("typeController", bundle.getString("gamepad"));
    }

    languageStrings.put("language", bundle.getString("language"));
    switch(language)
    {
    case ITALIAN:
      languageStrings.put("languageType", bundle.getString("italian"));
      break;

    case ENGLISH:
      languageStrings.put("languageType", bundle.getString("english"));
      break;
    }

    languageStrings.put("commands", bundle.getString("commands"));
    languageStrings.put("credits", bundle.getString("credits"));
    languageStrings.put("back", bundle.getString("back"));

    return languageStrings;
  }
}
