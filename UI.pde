class UI {
  ArrayList<Button> buttons;
  PGraphics uiLayer;

  HashMap<String, String> strings;

  String score = "";
  String boss_name = "";
  String game_target = "";   // indica al giocatore l'obiettivo
  String game_target_boss = "";
  String levelText = "";

  // ----- CUORI BOSS -----
  boolean isBossBattle;  // indica se il giocatore si trova nel livello finale

  // ------ CUORI GIOCATORE ------
  PImage heartFull;
  PImage halfHeart;
  PImage emptyHeart;

  int heartsToDisplay;
  int heartX;
  int heartY;
  int heartWidth = 20; // Larghezza di un cuore
  int heartHeight = 20; // Altezza di un cuore
  int maxHearts;
  boolean isHalfHeart;

  // ----- MINIMAPPA -----
  boolean isMapActive; // di base false
  float miniMapWidth;
  float miniMapHeight;
  float miniMapX;
  float miniMapY;

  float miniMapTileX;
  float miniMapTileY;

  float playerMiniMapX;
  float playerMiniMapY;

  float chestMiniMapX;
  float chestMiniMapY;

  UI() {
    uiLayer = createGraphics(width, height);

    heartFull = loadImage("data/ui/heartFull.png");
    halfHeart = loadImage("data/ui/halfHeart.png");
    emptyHeart = loadImage("data/ui/emptyHeart.png");

    miniMapWidth = 230;
    miniMapHeight = 210;
    miniMapX = 20;
    miniMapY = uiLayer.height - miniMapHeight;

    isBossBattle = false;    // di base, false
    isMapActive = false;    // di base, false, si attiva con la minimappa trovata nei livelli

    buttons = new ArrayList();

    buttons.add(new Button(width - 70, 20, 50, 50, "pause", "", "data/ui/Pause.png"));
  }

  void update() {
    uiLayer.beginDraw();
    uiLayer.background(255, 0);

    // nome del livello
    uiLayer.textFont(myFont);
    uiLayer.fill(255);
    uiLayer.textAlign(LEFT, TOP); // Allinea il testo a sinistra e in alto
    uiLayer.textSize(24);
    uiLayer.text(levelText + game.levelIndex, 20, 20);

    uiLayer.fill(255);
    uiLayer.textAlign(CENTER, TOP); // Allinea il testo a sinistra e in alto
    uiLayer.textSize(24);
    uiLayer.text(game_target, width / 2, 20);

    uiLayer.fill(255);
    uiLayer.textAlign(CENTER, TOP); // Allinea il testo a sinistra e in alto
    uiLayer.textSize(24);
    uiLayer.text("fps timer: " + fps_timer.getTicks(), width / 2, 40);

    uiLayer.fill(255);
    uiLayer.textAlign(CENTER, TOP); // Allinea il testo a sinistra e in alto
    uiLayer.textSize(24);
    uiLayer.text("tick timer: " + tick_timer.getTicks(), width / 2, 60);

    /////

    // pause button
    if (buttons.get(0).isClicked()) {
      screen_state = ScreenState.PAUSE_SCREEN;
      dungeon_background.pause();
    }

    buttons.get(0).update();
    buttons.get(0).display(uiLayer);

    // ------ CUORI GIOCATORE ------
    displayPlayerHearts();

    // ------ SCORE GIOCATORE ------
    uiLayer.fill(255);
    uiLayer.textAlign(RIGHT, TOP); // Allinea il testo a destra e in alto
    uiLayer.textSize(24);
    uiLayer.text(score + p1.playerScore, uiLayer.width - 80, 20); // vicino al pulsante pausa

    // ------ CHIAVI ARGENTO GIOCATORE ------
    uiLayer.fill(255);
    uiLayer.textAlign(LEFT, TOP); // Allinea il testo a sinistra e in alto
    uiLayer.textSize(18);
    uiLayer.text(p1.numberOfSilverKeys, 50, 80);
    uiLayer.image(silver_key_sprite, 20, 80, 20, 20);

    // ------ CHIAVI ORO GIOCATORE ------
    uiLayer.fill(255);
    uiLayer.textAlign(LEFT, TOP); // Allinea il testo a sinistra e in alto
    uiLayer.textSize(18);
    uiLayer.text(p1.numberOfGoldenKeys, 100, 80);
    uiLayer.image(golden_key_sprite, 70, 80, 20, 20);

    // ------ MONETE GIOCATORE ------
    uiLayer.fill(255);
    uiLayer.textAlign(LEFT, TOP); // Allinea il testo a sinistra e in alto
    uiLayer.textSize(18);
    uiLayer.text(p1.coins, 50, 140);
    uiLayer.image(coin_sprite, 20, 140, 20, 20);

    // ------ POZIONE GIOCATORE ------
    uiLayer.fill(255);
    uiLayer.textAlign(LEFT, TOP); // Allinea il testo a sinistra e in alto
    uiLayer.textSize(18);
    uiLayer.text(p1.numberOfPotion, 50, 110);
    uiLayer.image(red_potion_sprite, 20, 110, 20, 20);

    // ------- MINIMAPPA ------
    // if (isMapActive) displayMinimap();

    // ------ ARMA GIOCATORE -----
    uiLayer.noFill(); // Nessun riempimento
    uiLayer.stroke(255); // Colore del bordo bianco
    // uiLayer.rect(width - 70, height - 70, 50, 50);
    uiLayer.rect(20, height - 70, 50, 50);

    float scaleFactor = 3.0;

    if (p1.weapon.sprite != null) {
      float imgWidth = p1.weapon.sprite.width * scaleFactor;
      float imgHeight = p1.weapon.sprite.height * scaleFactor;

      //float imgX = (uiLayer.width - 70) + (50 - imgWidth) / 2;  // Calcola la posizione X dell'immagine al centro
      //float imgY = uiLayer.height - 70 + (50 - imgHeight) / 2; // Calcola la posizione Y dell'immagine al centro

      float imgX = 20 + (50 - imgWidth) / 2;  // Calcola la posizione X dell'immagine al centro
      float imgY = (height - 70) + (50 - imgHeight) / 2; // Calcola la posizione Y dell'immagine al centro

      uiLayer.image(p1.weapon.sprite, imgX, imgY, imgWidth, imgHeight);
    }

    uiLayer.fill(255);
    uiLayer.textAlign(LEFT, LEFT); // Allinea il testo a sinistra e in alto
    uiLayer.textSize(20);
    float offset = uiLayer.textWidth(p1.weapon.name);
    // uiLayer.text(p1.weapon.name, width - offset - 80, height - 20);
    uiLayer.text(p1.weapon.name, offset - 60, height - 20);

    // se il giocatore si trova nel livello del boss mostra i cuori del boss
    if (isBossBattle) displayBossHearts();

    uiLayer.endDraw();

    image(uiLayer, 0, 0);
  }

  void displayPlayerHearts()
  {
    // Calcola quanti cuori pieni mostrare in base alla vita del giocatore
    heartsToDisplay = p1.hp / 10; // Supponiamo che ogni cuore rappresenti 10 HP
    heartX = 20;
    heartY = 50;
    maxHearts = p1.playerMaxHP / 10;
    isHalfHeart = p1.hp % 10 >= 5; // Controlla se c'è un cuore a metà

    // Disegna i cuori pieni
    for (int i = 0; i < heartsToDisplay; i++) {
      uiLayer.image(heartFull, heartX + i * (heartWidth + 5), heartY, heartWidth, heartHeight);
    }

    // Disegna il cuore a metà se necessario
    if (isHalfHeart) {
      uiLayer.image(halfHeart, heartX + heartsToDisplay * (heartWidth + 5), heartY, heartWidth, heartHeight);
    }

    // Disegna i cuori vuoti per completare il numero massimo di cuori
    for (int i = heartsToDisplay + (isHalfHeart ? 1 : 0); i < maxHearts; i++) {
      uiLayer.image(emptyHeart, heartX + i * (heartWidth + 5), heartY, heartWidth, heartHeight);
    }
  }

  void setBossLevelUI()
  {
    isBossBattle = true;
  }

  void resetBossLevelUI()
  {
    isBossBattle = false;
  }

  // da sistemare
  void displayBossHearts() {
    // Calcola quanti cuori pieni mostrare in base alla vita del giocatore
    heartsToDisplay = game.boss.hp / 10; // Supponiamo che ogni cuore rappresenti 10 HP
    // da sistemare si deve trovare esattamente al centro
    heartX = uiLayer.width / 2 - 100;
    heartY = uiLayer.height - 100;
    maxHearts = game.boss.maxHP / 10;
    isHalfHeart = game.boss.hp % 10 >= 5; // Controlla se c'è un cuore a metà

    // uiLayer.textFont(myFont);
    uiLayer.fill(255);
    // uiLayer.textAlign(LEFT, TOP); // Allinea il testo a sinistra e in alto
    uiLayer.textSize(30);
    uiLayer.text(boss_name, heartX, heartY - 30);

    // Disegna i cuori pieni
    for (int i = 0; i < heartsToDisplay; i++) {
      uiLayer.image(heartFull, heartX + i * (heartWidth + 15), heartY, heartWidth + 10, heartHeight + 10);
    }

    // Disegna il cuore a metà se necessario
    if (isHalfHeart) {
      uiLayer.image(halfHeart, heartX + heartsToDisplay * (heartWidth + 15), heartY, heartWidth + 10, heartHeight + 10);
    }

    // Disegna i cuori vuoti per completare il numero massimo di cuori
    for (int i = heartsToDisplay + (isHalfHeart ? 1 : 0); i < maxHearts; i++) {
      uiLayer.image(emptyHeart, heartX + i * (heartWidth + 15), heartY, heartWidth + 10, heartHeight + 10);
    }
  }

  void activateMap() {
    isMapActive = true;
  }

  void deactivateMap() {
    isMapActive = false;
  }

  //void setActualLevelText(String actualLevel) {
  //  this.actualLevel = actualLevel;
  //}

  //void displayMinimap() {
  //  // ------- MINIMAPPA ------
  //  // Disegna la minimappa nell'angolo in basso a sinistra
  //  uiLayer.noFill(); // Nessun riempimento

  //  for (int x = 0; x < currentLevel.cols; x++) {
  //    for (int y = 0; y < currentLevel.rows; y++) {
  //      int tileType = currentLevel.map[x][y];

  //      // Controlla se il tile è una parete o un corridoio (bordo della stanza)
  //      if (tileType == 4 || tileType == 5) {
  //        // Mappa i tile della minimappa nel rettangolo
  //        miniMapTileX = map(x, 0, currentLevel.cols, miniMapX, miniMapX + miniMapWidth);
  //        miniMapTileY = map(y, 0, currentLevel.rows, miniMapY, miniMapY + miniMapHeight);

  //        // Disegna il bordo della stanza sulla minimappa
  //        uiLayer.stroke(255); // Colore del bordo bianco
  //        uiLayer.point(miniMapTileX, miniMapTileY);
  //      } else if (tileType == 3) {
  //        // ----- SCALE QUADRATO AZZURO -----
  //        miniMapTileX = map(x, 0, currentLevel.cols, miniMapX, miniMapX + miniMapWidth);
  //        miniMapTileY = map(y, 0, currentLevel.rows, miniMapY, miniMapY + miniMapHeight);

  //        uiLayer.noFill();
  //        uiLayer.stroke(0, 127, 255);
  //        uiLayer.rect(miniMapTileX, miniMapTileY, miniMapWidth / currentLevel.cols, miniMapHeight / currentLevel.rows);
  //      }
  //    }
  //  }

  //  // ----- PLAYER PALLINO ROSSO -----
  //  playerMiniMapX = map(p1.getPosition().x, 0, currentLevel.cols, miniMapX, miniMapX + miniMapWidth);
  //  playerMiniMapY = map(p1.getPosition().y, 0, currentLevel.rows, miniMapY, miniMapY + miniMapHeight);

  //  uiLayer.fill(255, 0, 0); // Colore rosso per il giocatore
  //  uiLayer.noStroke();
  //  uiLayer.ellipse(playerMiniMapX, playerMiniMapY, 5, 5);

  //  // ----- NEMICI PALLINI GIALLI -----
  //  uiLayer.fill(255, 255, 0); // Colore giallo per i nemici
  //  uiLayer.noStroke();

  //  for (Chest chest : currentLevel.treasures) {
  //    chestMiniMapX = map(chest.getPosition().x, 0, currentLevel.cols, miniMapX, miniMapX + miniMapWidth);
  //    chestMiniMapY = map(chest.getPosition().y, 0, currentLevel.rows, miniMapY, miniMapY + miniMapHeight);
  //    uiLayer.ellipse(chestMiniMapX, chestMiniMapY, 5, 5);
  //  }
  //}
  
  void updateScreen() {
    uiLayer = createGraphics(width, height);

    miniMapY = uiLayer.height - miniMapHeight;

    // aggiorna posizione bottone
    buttons.get(0).updatePosition(width - 70, 20, 50, 50);  // pause
  }

  // metodo migliore rispetto al mio
  // piu rapido e modulare
  void updateLanguage(Language language) {
    strings = getStringsForLanguage(language);
    updateUI();
  }

  void updateUI() {
    score = strings.get("score");
    boss_name = strings.get("bossname");
    game_target = strings.get("gametarget");
    game_target_boss = strings.get("gametargetboss");
    levelText = strings.get("level");
  }

  HashMap<String, String> getStringsForLanguage(Language language) {
    HashMap<String, String> languageStrings = new HashMap<String, String>();
    JSONObject bundle = null;

    switch(language) {
    case ITALIAN:
      bundle = bundleITA.getJSONObject("game").getJSONObject("ui");
      break;

    case ENGLISH:
      bundle = bundleENG.getJSONObject("game").getJSONObject("ui");
      break;

    case SPANISH:
      bundle = bundleESP.getJSONObject("game").getJSONObject("ui");;
      break;
    }

    languageStrings.put("score", bundle.getString("score"));
    languageStrings.put("bossname", bundle.getString("bossname"));
    languageStrings.put("gametarget", bundle.getString("gametarget"));
    languageStrings.put("gametargetboss", bundle.getString("gametargetboss"));
    languageStrings.put("level", bundle.getString("level"));

    return languageStrings;
  }
}
