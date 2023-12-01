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

    p1 = new Player(50, 100, 5, 5, 5);
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
        
        // rilevi collisione attacca
        if(enemy.playerCollide(p1)) {
          // attacca il player
          // aggiungere cool down es: attacca ogni 3 sec
          enemy.attack();
        } else {
          // altrimenti muovi il nemico
          enemy.move(currentLevel);
        }
      }
    }


    // ----- CHEST -----
    // disegna solo le chest visibili
    for (Chest chest : currentLevel.treasures) {
      if (isInVisibleArea(chest.spritePosition)) {
        chest.display(spritesLayer);
        if(chest.playerCollide(p1) && !chest.isOpen()) {
          float letterImageX = (chest.spritePosition.x * currentLevel.tileSize);
          float letterImageY = (chest.spritePosition.y * currentLevel.tileSize) - 20; // Regola l'offset verticale a tuo piacimento
          spritesLayer.image(letter_k, letterImageX, letterImageY);
          
          // se il giocatore preme il tasto interazione e la cassa non è stata aperta
          if (p1.moveINTR && (!p1.moveUSE && !p1.moveATCK) ) {
            if (chest.isRare()) {    // se la cassa è rara
              if (p1.numberOfGoldenKeys > 0) {
                if (chest.getOpenWith().equals(p1.golden_keys)) {
                  // imposta la cassa come aperta
                  chest.setIsOpen(true);
                  specialChestOpen.play();
                  chest.sprite = loadImage("data/object/special_chest_open.png");
    
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
                if (chest.getOpenWith().equals(p1.silver_keys)) {
                  // imposta la cassa come aperta
                  chest.setIsOpen(true);
                  normalChestOpen.play();
                  chest.sprite = loadImage("data/object/chest_open.png");
    
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
        }
      }
    }

    // ----- COIN -----
    for (Coin coin : currentLevel.coins) {
      if (isInVisibleArea(coin.spritePosition)) {   
        if (!coin.isCollected()) {    // se la moneta non è stata raccolta disegnala
          coin.display(spritesLayer);
          coin.playerCollide(p1);
        }
      }
    }

    // Gestione del movimento del giocatore
    // da migliorare
    // mostra il player
    p1.display(spritesLayer);
    p1.move();

    if (p1.moveATCK && (!p1.moveUSE && !p1.moveINTR)) {
      drawPlayerWeapon();
      p1.attack();
    }

    // usa le pozioni
    if (p1.moveUSE && (!p1.moveATCK && !p1.moveINTR) && p1.numberOfPotion > 0 && !isUsingPotion) {
       isUsingPotion = true;
      
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

    spritesLayer.endDraw();

    // passa al livello successivo
    // aggiungere collider
    if (currentLevel.playerCollide(p1)) {
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
  
  void updateScene() {

  }
}
