enum DifficultyLevel {
  FACILE,
    NORMALE,
    DIFFICILE
}

class Game {
  // layer della scena di gioco
  PGraphics gameScene;
  PGraphics spritesLayer;
  PGraphics maskLayer;

  DifficultyLevel difficultyLevel; // livello di difficolta del gioco
  Boss boss;    // boss del gioco
  boolean isBossLevel;  // indica se ci troviamo nel livello finale, di base è false
  float holeRadius; // raggio della maschera

  boolean isTorchDropped;       // indica se la torcia è stata droppata, di base false
  boolean isMapDropped;         // indica se la mappa è stata droppata, di base false
  boolean isMasterSwordDropped; // indica se la spada suprema è stata droppata, di base false

  ConcreteDamageHandler damageTileHandler;

  Game() {
    gameScene = createGraphics(width, height);
    spritesLayer = createGraphics(width, height);
    maskLayer = createGraphics(width, height);

    // di default la difficolta del gioco è impostata su normale
    difficultyLevel = DifficultyLevel.NORMALE;

    isBossLevel = false;

    isTorchDropped = false;
    isMapDropped = false;
    isMasterSwordDropped = false;

    // raggio della maschera
    holeRadius = 60;

    camera = new Camera();
  }

  // aggiorna la finestra di gioco con le nuove dimensioni 
  void updateScreen() {
    gameScene = createGraphics(width, height);
    spritesLayer = createGraphics(width, height);
    maskLayer = createGraphics(width, height);
  }

  // reimposta le variabili di gioco
  void resetGame() {
    isBossLevel = false;

    isTorchDropped = false;
    isMapDropped = false;
    isMasterSwordDropped = false;

    // reimposta lo stato della mappa, disattivo
    ui.deactivateMap();
    ui.deactivateBossUI();
  }

  void init() {
    // da togliere di qua
    golden_key = new Item(null, null, "golden_key");
    silver_key = new Item(null, null, "silver_key");

    // create world
    castle = new World();

    damageTileHandler = new ConcreteDamageHandler();

    currentZone = castle.currentZone;

    // caricamento delle immagini
    currentZone.loadAssetsZone();

    // inizializzo un livello per volta
    currentLevel = currentZone.currentLevel;
    currentLevel.loadAssetsLevel();
    currentLevel.init();

    actualLevel = currentZone.zoneName + " - " + currentLevel.levelName;

    // inizializza il player
    p1 = new Player(new PVector(0, 0), 100, 100, 1, 0, 3, damageTileHandler);
    p1.updatePosition(currentLevel.getStartPosition());

    p1.golden_key = golden_key;
    p1.silver_key = silver_key;

    resetGame();

    // avvia i timer
    //fps_timer.timerStart();
    //tick_timer.timerStart();

    //fps_clock.timerStart();
    //tick_clock.timerStart();
  }

  void initBossBattle() {
    // crea il livello finale
    currentLevel = currentZone.createBossLevel();

    // inizializza il livello del boss
    currentLevel.isFinalLevel = true;
    currentLevel.loadAssetsLevel();
    currentLevel.initBossLevel();

    // posizione il giocatore nel punto di spawn
    p1.updatePosition(currentLevel.getStartPosition());

    // aggiorna il testo relativo al livello attuale
    actualLevel = currentZone.zoneName + " - Livello Finale";

    // crea il boss
    PVector spawn_boss_position = new PVector(currentLevel.getStartPosition().x, currentLevel.getStartPosition().y);
    // velocita di base boss 0.1
    boss = new Boss(spawn_boss_position, boss_sprite, 0.07, "Stregone Pagnax", 100, 100);

    ui.game_target = "Sconfiggi Pagnax!";

    ui.activateBossUI();
    ui.deactivateMap();
  }

  void display() {
    // aggiorna la camera
    camera.update();

    // disegna il game layer
    // mappa di gioco
    drawGameLayer();

    // disegna lo sprites layer
    // giocatore, nemici, casse
    drawSpritesLayer();

    // disegna il mask layer se non ci troviamo nel livello finale
    // maschera
    if (!isBossLevel) drawMaskLayer();
  }

  // funzione che gestisce tutti gli eventi in input relativi al giocatore
  // e alle altre entita
  void handleEvents() {
    // gestione controlli player
    // handlePlayerDeath();
    p1.update();
    // p1.attack();
    // p1.usePotion();

    if (!isBossLevel) {
      // gestione livello successivo
      handleNextLevel();
    
      // gestione azione nemici
      handleEnemyActions();

      // gestione casse
      handleChest();

      // gestione monete
      handleCoin();
    } else {
      handlePlayerVictory();
      // gestione azioni boss
      boss.update(p1);
    }
  }

  void drawGameLayer() {
    // disegna il game layer
    gameScene.beginDraw();
    gameScene.background(0);
    // Imposta la telecamera alla nuova posizione e applica il fattore di scala
    gameScene.translate(-camera.x, -camera.y);
    gameScene.scale(camera.zoom);
    gameScene.imageMode(CENTER);  // imposto l'image mode a center

    // Disegna la mappa del livello corrente
    currentLevel.display(gameScene); // renderizza il 4,6 % della mappa

    gameScene.endDraw();

    image(gameScene, 0, 0);
  }

  void drawSpritesLayer() {
    spritesLayer.beginDraw();
    spritesLayer.background(255, 0);
    spritesLayer.translate(-camera.x, -camera.y);
    spritesLayer.scale(camera.zoom);
    spritesLayer.imageMode(CENTER);

    // aggiorna lo stato corrente del gioco
    // non deve trovarsi qui
    update();

    p1.display(spritesLayer);

    if (!isBossLevel) {
      displayEnemies();
      displayChests();
      displayCoins();
    } else {
      boss.display(spritesLayer);
    }

    spritesLayer.endDraw();
    image(spritesLayer, 0, 0);
  }

  void drawMaskLayer() {
    maskLayer.beginDraw();
    maskLayer.background(0, 255);
    maskLayer.blendMode(REPLACE);

    maskLayer.translate(-camera.x, -camera.y);
    maskLayer.scale(camera.zoom);

    float centerX = p1.getPosition().x * currentLevel.tileSize + currentLevel.tileSize/ 2;
    float centerY = p1.getPosition().y * currentLevel.tileSize + currentLevel.tileSize/ 2;

    maskLayer.fill(255, 0);
    maskLayer.ellipseMode(RADIUS);
    maskLayer.ellipse(centerX, centerY, holeRadius, holeRadius);

    maskLayer.endDraw();

    image(maskLayer, 0, 0);
  }

  void update() {
    // da sistemare
    handleDropItems();
  }

  // gestisce la vittoria del giocatore
  void handlePlayerVictory() {
    if (boss.HP <= 0) {
      p1.updateScore(1000);
      screen_state = ScreenState.WIN_SCREEN;
    }
  }

  // gestisce la morte del giocatore
  void handlePlayerDeath() {
    if (p1.playerHP <= 0) {
      screen_state = ScreenState.LOSE_SCREEN;
    }
  }

  // gestisce il passaggio al livello successivo
  void handleNextLevel() {
    // passa al livello successivo
    // aggiungere collider
    if (currentLevel.stairsNextFloor.sprite_collision(p1)) {
      // se il livello dell'area è l'ultimo passa alla prossima area
      if (currentLevel.levelIndex == currentZone.levels.size() - 1) {
        println("E' L'ULTIMO LIVELLO DELLA ZONA...");
        // controlla se è l'area finale
        if (currentZone.isFinal()) {
          initBossBattle();
          isBossLevel = true;
        } else {
          // passa alla prossima macroarea
          currentZone = castle.zones.get(currentZone.zoneIndex + 1);
          currentLevel = currentZone.currentLevel;
          currentLevel.loadAssetsLevel();
          currentLevel.init();
          actualLevel = currentZone.zoneName + " - " + currentLevel.levelName;
          p1.updatePosition(currentLevel.getStartPosition());

          // aggiorna lo score del player
          p1.updateScore(200);
          screen_state = ScreenState.STORY_SCREEN;
        }
      } else {
        // passa al livello successivo - stessa macro area
        currentLevel = currentZone.levels.get(currentLevel.levelIndex + 1);
        currentLevel.loadAssetsLevel();
        currentLevel.init();
        actualLevel = currentZone.zoneName + " - " + currentLevel.levelName;
        p1.updatePosition(currentLevel.getStartPosition());

        // aggiorna lo score del player
        p1.updateScore(100);
      }
    }
  }

  // gestisce le azioni del nemico
  void handleEnemyActions() {
    Iterator<Enemy> iterator = currentLevel.enemies.iterator();

    while (iterator.hasNext()) {
      Enemy enemy = iterator.next();

      if (isInVisibleArea(enemy.getPosition())) {
        if (enemy.enemyHP > 0) {
          enemy.update();
          // enemy.display(spritesLayer);

          // attacca solo se c'è collisione
          if (enemy.sprite_collision(p1)) {
            // enemy.displayHitbox(spritesLayer);
            enemy.attack(p1);
          } else {
            enemy.first_attack = true;
          }
        } else {
          enemy.death();
          p1.updateScore(enemy.scoreValue);
          iterator.remove();
        }
      }
    }
  }

  void displayEnemies() {
    Iterator<Enemy> iterator = currentLevel.enemies.iterator();

    while (iterator.hasNext()) {
      Enemy enemy = iterator.next();

      if (isInVisibleArea(enemy.getPosition())) {
        if (enemy.enemyHP > 0) {
          enemy.display(spritesLayer);
        }
      }
    }
  }

  // gestione delle chest
  // da migliorare
  void handleChest() {
    // ----- CHEST -----
    // disegna solo le chest visibili
    for (Chest chest : currentLevel.treasures) {
      if (isInVisibleArea(chest.getPosition())) {
        if (chest.sprite_collision(p1) && !chest.isOpen()) {
          // println("collsione cassa giocatore");
          chest.displayHitbox(spritesLayer);

          float letterImageX = (chest.getPosition().x * currentLevel.tileSize + (p1.sprite.width / 2));
          float letterImageY = (chest.getPosition().y * currentLevel.tileSize + (p1.sprite.height / 2)) - 20; // Regola l'offset verticale a tuo piacimento
          spritesLayer.image(letter_k, letterImageX, letterImageY);

          // se il giocatore preme il tasto interazione e la cassa non è stata aperta
          if (p1.moveINTR && (!p1.moveUSE && !p1.moveATCK)) {
            if (!p1.isInteracting) {
              p1.isInteracting = true;
              if (chest.isRare()) {    // se la cassa è rara
                // CASSA RARA
                if (p1.numberOfGoldenKeys > 0) {
                  if (chest.getOpenWith().equals(p1.golden_key)) {
                    // imposta la cassa come aperta
                    chest.setIsOpen(true);
                    chest_open.play();
                    // per migliorare prestazioni, carico questo immagine all'inizio e l'assegno quando mi serve
                    chest.sprite = special_chest_open_sprite;

                    p1.numberOfGoldenKeys -= 1;
                    p1.updateScore(50);

                    chest.dropItemSpecialChest();
                  }
                } else {
                  float crossImageX = (p1.getPosition().x * currentLevel.tileSize + (chest.sprite.width / 2));
                  float crossImageY = (p1.getPosition().y * currentLevel.tileSize + (chest.sprite.height / 2)) - 20; // Regola l'offset verticale a tuo piacimento
                  spritesLayer.image(cross_sprite, crossImageX, crossImageY);
                }
              } else {  // se la cassa è normale
                // CASSA NORMALE
                if (p1.numberOfSilverKeys > 0) {
                  if (chest.getOpenWith().equals(p1.silver_key)) {
                    // imposta la cassa come aperta
                    chest.setIsOpen(true);
                    chest_open.play();
                    // per migliorare prestazioni, carico questo immagine all'inizio e l'assegno quando mi serve
                    chest.sprite = chest_open_sprite;

                    p1.numberOfSilverKeys -= 1;
                    p1.updateScore(30);

                    // metodo per drop item casuale
                    chest.dropItemNormalChest();
                  }
                } else {
                  float crossImageX = (p1.getPosition().x * currentLevel.tileSize + (p1.sprite.width / 2));
                  float crossImageY = (p1.getPosition().y * currentLevel.tileSize + (p1.sprite.height / 2)) - 20; // Regola l'offset verticale a tuo piacimento
                  spritesLayer.image(cross_sprite, crossImageX, crossImageY);
                }
              }
            }
          } else {
            // resettta la variabile
            p1.isInteracting = false;
          }
        }
      }
    }
  }

  void displayChests() {
    for (Chest chest : currentLevel.treasures) {
      if (isInVisibleArea(chest.getPosition())) {
        // mostra le chest nell'area visibile
        chest.display(spritesLayer);
      }
    }
  }

  // gestisce le monete
  void handleCoin() {
    // ----- COIN -----
    for (Coin coin : currentLevel.coins) {
      if (isInVisibleArea(coin.getPosition())) {
        // mostra le monete nell'area visibile
        if (!coin.isCollected()) {
          if (coin.sprite_collision(p1)) {
            coin.collect();  // raccogli la moneta
            p1.collectCoin();
            pickupCoin.play();
            p1.updateScore(coin.scoreValue);
          }
        }
      }
    }
  }

  void displayCoins() {
    for (Coin coin : currentLevel.coins) {
      if (isInVisibleArea(coin.getPosition())) {
        // mostra le monete nell'area visibile
        if (!coin.isCollected()) {    // se la moneta non è stata raccolta disegnala
          coin.display(spritesLayer);
        }
      }
    }
  }

  // gestisce gli oggetti rilasciati dai nemici e dalle casse
  void handleDropItems() {
    // ----- DROP ITEMS -----
    Iterator<Item> iterator = currentLevel.dropItems.iterator();

    while (iterator.hasNext()) {
      Item item = iterator.next();

      // controlla che gli elementi droppati siano visibili
      if (isInVisibleArea(item.getPosition())) {
        item.display(spritesLayer);

        if (item.sprite_collision(p1)) {
          item.displayHitbox(spritesLayer);

          float letterImageX = (item.getPosition().x * currentLevel.tileSize + (item.sprite.width / 2));
          float letterImageY = (item.getPosition().y * currentLevel.tileSize + (item.sprite.height / 2)) - 20; // Regola l'offset verticale a tuo piacimento
          spritesLayer.image(letter_k, letterImageX, letterImageY);

          if (item instanceof Weapon) {
            Weapon temp = (Weapon) item;

            if (temp.damage > p1.weapon.damage) {
              float imageX = (item.getPosition().x * currentLevel.tileSize + (item.sprite.width / 2) - 20);
              float imageY = (item.getPosition().y * currentLevel.tileSize + (item.sprite.height / 2)) - 20; // Regola l'offset verticale a tuo piacimento
              spritesLayer.image(up_buff, imageX, imageY);
            } else if (temp.damage < p1.weapon.damage) {
              float imageX = (item.getPosition().x * currentLevel.tileSize + (item.sprite.width / 2) - 20);
              float imageY = (item.getPosition().y * currentLevel.tileSize + (item.sprite.height / 2)) - 20; // Regola l'offset verticale a tuo piacimento
              spritesLayer.image(down_buff, imageX, imageY);
            }
          }

          if (p1.moveINTR && (!p1.moveUSE && !p1.moveATCK)) {
            if (!p1.isInteracting) {
              p1.isInteracting = true;

              if (item instanceof Healer) { // verifico prima che sia un oggetto curativo
                if (item.name.equals("dropPotion")) {  // se è un pozione aggiungila
                  p1.numberOfPotion++;
                  iterator.remove();
                } else {  // se è un cuore recupera la vita istantaneamente
                  if (p1.playerHP < p1.playerMaxHP) { // verifico che la salute del giocatore sia minore della salute massima
                    Healer healerItem = (Healer) item;

                    p1.takeHP(healerItem.getBonusHp());

                    // una volta che è stato utilizzato l'oggetto viene rimosso dalla lista
                    iterator.remove();
                  } else {
                    TextDisplay healthFull = new TextDisplay(p1.getPosition(), "Salute al massimo", color(255));
                    healthFull.display(spritesLayer);
                  }
                }
              } else if (item instanceof Weapon) {
                // una volta scambiata l'arma non è piu possibile recuperare quella vecchia
                // assegna arma a terra al giocatore
                p1.weapon = (Weapon) item;
                // rimuovi l'oggetto droppato a terra
                iterator.remove();
              } else if (item.isCollectible && item.name.equals("dropSilverKey")) {
                // aumenta il numero delle chiavi d'argento
                p1.takeSilverKey();
                iterator.remove();
              } else if (item.isCollectible && item.name.equals("dropGoldenKey")) {
                // aumenta il numero delle chiavi d'oro
                p1.takeGoldenKey();
                iterator.remove();
              } else if (item.isCollectible && item.name.equals("dropTorch")) {
                // aumenta il raggio della maschera
                holeRadius += 50;
                iterator.remove();
              } else if (item.isCollectible && item.name.equals("dropMap")) {
                // attiva la minimappa per tutti i livelli
                ui.activateMap();
                iterator.remove();
              }
            }
          } else {
            // resetta la variabile di stato
            p1.isInteracting = false;
          }
        }
      }
    }
  }
}
