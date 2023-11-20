class Game {
  void init() {
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

  void display() {
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
    // disegna solo i nemici visibili
    for (Enemy enemy : currentLevel.enemies) {
      if (isInVisibleArea(enemy.spritePosition)) {
        enemy.display(spritesLayer);
        enemy.move(currentLevel);
      }
    }


    // ----- CHEST -----
    // disegna solo le chest visibili
    for (Chest chest : currentLevel.treasures) {
      if (isInVisibleArea(chest.spritePosition)) {
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
    }

    // da sistemare
    // funziona parzialemente
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
      if (isInVisibleArea(coin.spritePosition)) {
        if (!coin.isCollected()) {    // se la moneta non è stata raccolta disegnala
          if (PVector.dist(p1.spritePosition, coin.spritePosition) < coinCollectionThreshold) {
            coin.collect();  // raccogli la moneta
            p1.collectCoin();
            pickupCoin.play();
            p1.playerScore += coin.scoreValue;
          } else {
            coin.display(spritesLayer);
          }
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

    image(gameScene, 0, 0);
    image(spritesLayer, 0, 0);
  }
}
