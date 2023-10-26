class UI {
  ArrayList<Button> buttons;
  PGraphics uiLayer;

  // ------ CUORI GIOCATORE ------
  PImage heartFull;
  PImage halfHeart;
  PImage emptyHeart;

  int heartsToDisplay;
  int heartY;
  int heartWidth = 20; // Larghezza di un cuore
  int heartHeight = 20; // Altezza di un cuore
  int maxHearts;
  boolean isHalfHeart;

  // ----- MINIMAPPA -----
  float miniMapSize;
  float miniMapX;
  float miniMapY;

  float miniMapTileX;
  float miniMapTileY;

  float playerMiniMapX;
  float playerMiniMapY;

  float enemyMiniMapX;
  float enemyMiniMapY;

  UI() {
    uiLayer = createGraphics(width, height);

    heartFull = loadImage("data/heartFull.png");
    halfHeart = loadImage("data/halfHeart.png");
    emptyHeart = loadImage("data/emptyHeart.png");

    miniMapSize = 300;
    miniMapX = 20;
    miniMapY = uiLayer.height - miniMapSize - 10;

    buttons = new ArrayList();
    
    buttons.add(new Button(width - 50, 20, 40, 40, "", "data/ui/Pause.png"));
  }

  void update() {
  }

  void display() {
    uiLayer.beginDraw();
    uiLayer.background(255, 0);
    // nome del livello
    uiLayer.textFont(myFont);
    uiLayer.fill(255);
    uiLayer.textAlign(LEFT, TOP); // Allinea il testo a sinistra e in alto
    uiLayer.textSize(24);
    uiLayer.text(actualLevel, 20, 20);

    // pause button
    if(buttons.get(0).isClicked()) {
      screen_state = PAUSE_SCREEN;
      soundtrack.pause();
    }
    
    buttons.get(0).update();
    buttons.get(0).display(uiLayer);

    // ------ CUORI GIOCATORE ------
    // Calcola quanti cuori pieni mostrare in base alla vita del giocatore
    heartsToDisplay = p1.playerHP / 10; // Supponiamo che ogni cuore rappresenti 10 HP
    heartY = 50;
    maxHearts = p1.playerMaxHP / 10;
    isHalfHeart = p1.playerHP % 10 >= 5; // Controlla se c'è un cuore a metà

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
          miniMapTileX = map(x, 0, currentLevel.cols, miniMapX, miniMapX + miniMapSize);
          miniMapTileY = map(y, 0, currentLevel.rows, miniMapY, miniMapY + miniMapSize);

          // Disegna il bordo della stanza sulla minimappa
          uiLayer.point(miniMapTileX, miniMapTileY);
        }
      }
    }

    playerMiniMapX = map(p1.spritePosition.x, 0, currentLevel.cols, miniMapX, miniMapX + miniMapSize);
    playerMiniMapY = map(p1.spritePosition.y, 0, currentLevel.rows, miniMapY, miniMapY + miniMapSize);

    uiLayer.fill(255, 0, 0); // Colore rosso per il giocatore
    uiLayer.noStroke();
    uiLayer.ellipse(playerMiniMapX, playerMiniMapY, 5, 5);

    // Disegna i nemici sulla minimappa come pallini gialli
    uiLayer.fill(255, 255, 0); // Colore giallo per i nemici
    uiLayer.noStroke();

    for (Enemy enemy : currentLevel.enemies) {
      enemyMiniMapX = map(enemy.spritePosition.x, 0, currentLevel.cols, miniMapX, miniMapX + miniMapSize);
      enemyMiniMapY = map(enemy.spritePosition.y, 0, currentLevel.rows, miniMapY, miniMapY + miniMapSize);
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
    image(uiLayer, 0, 0);
  }
}
