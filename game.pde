enum DifficultyLevel {
  FACILE,
    NORMALE,
    DIFFICILE
}

// contiene le logiche di gioco
class Game {
  DifficultyLevel difficultyLevel; // livello di difficolta del gioco
  Boss boss;    // boss del gioco

  boolean isBossLevel;  // indica se ci troviamo nel livello finale, di base è false
  boolean isTorchDropped;       // indica se la torcia è stata droppata, di base false
  boolean isMapDropped;         // indica se la mappa è stata droppata, di base false
  boolean isMasterSwordDropped; // indica se la spada suprema è stata droppata, di base false

  ConcreteDamageHandler damageTileHandler;

  Game() {
  }

  void init() {
    difficultyLevel = DifficultyLevel.NORMALE;

    isBossLevel = false;

    isTorchDropped = false;
    isMapDropped = false;
    isMasterSwordDropped = false;

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
    fps_timer.timerStart();
    tick_timer.timerStart();

    fps_clock.timerStart();
    tick_clock.timerStart();

    println("game system inizializzato correttamente!");
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

  // funzione che gestisce tutti gli eventi in input relativi al giocatore
  // e alle altre entita
  void update() {
    // gestione controlli player
    // handlePlayerDeath();
    p1.update();
    p1.attack();
    //p1.usePotion(spritesLayer);

    if (!isBossLevel) {
      // gestione azione nemici
      handleEnemyActions();

      // gestione casse
      handleChest();

      // gestion drop items
      handleDropItems();

      // gestione monete
      handleCoin();
      
      // gestione livello successivo
      handleNextLevel();
    } else {
      handlePlayerVictory();
      // gestione azioni boss
      boss.update(p1);
    }
  }

  // gestisce la vittoria del giocatore - OK
  void handlePlayerVictory() {
    if (boss.HP <= 0) {
      p1.updateScore(1000);
      screen_state = ScreenState.WIN_SCREEN;
    }
  }

  // gestisce la morte del giocatore - OK
  void handlePlayerDeath() {
    if (p1.playerHP <= 0) {
      screen_state = ScreenState.LOSE_SCREEN;
    }
  }

  // gestisce il passaggio al livello successivo - DA SISTEMARE
  void handleNextLevel() {
    // passa al livello successivo
    // aggiungere collider
    // if (currentLevel.stairsNextFloor.sprite_collision(p1))
    if(collision.sprite_collision(currentLevel.stairsNextFloor, p1)) 
    {
      // se il livello dell'area è l'ultimo passa alla prossima area
      if (currentLevel.levelIndex == currentZone.levels.size() - 1) {
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

  // gestisce le azioni del nemico - DA RIVEDERE
  void handleEnemyActions() {
    Iterator<Enemy> iterator = currentLevel.enemies.iterator();

    while (iterator.hasNext()) {
      Enemy enemy = iterator.next();

      if (isInVisibleArea(enemy.getPosition())) {
        if (enemy.enemyHP > 0) {
          enemy.update();

          // attacca solo se c'è collisione
          // if (enemy.sprite_collision(p1)) 
          if(collision.sprite_collision(enemy, p1)) {
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

  // gestione delle chest - DA SISTEMARE
  // da migliorare
  void handleChest() {
    // ----- CHEST -----
    // disegna solo le chest visibili
    for (Chest chest : currentLevel.treasures) {
      if (isInVisibleArea(chest.getPosition())) {
        // if (chest.sprite_collision(p1) && !chest.isOpen()) 
        if(collision.sprite_collision(chest, p1) && !chest.isOpen()) 
        {
          // println("collsione cassa giocatore");
          render.canOpenChest = true;

          // se il giocatore preme il tasto interazione e la cassa non è stata aperta
          if (p1.moveINTR && (!p1.moveUSE && !p1.moveATCK)) {
            if (!p1.isInteracting) {
              p1.isInteracting = true;
              if (chest.isRare())
              {    // se la cassa è rara
                // CASSA RARA
                if (p1.numberOfGoldenKeys > 0)
                {
                  if (chest.getOpenWith().equals(p1.golden_key))
                  {
                    // imposta la cassa come aperta
                    chest.setIsOpen(true);
                    chest_open.play();
                    // per migliorare prestazioni, carico questo immagine all'inizio e l'assegno quando mi serve
                    chest.sprite = special_chest_open_sprite;

                    p1.numberOfGoldenKeys -= 1;
                    p1.updateScore(50);

                    chest.dropItemSpecialChest();
                  }
                } else
                {
                  render.canOpenChest = false;
                }
              } else
              {  // se la cassa è normale
                // CASSA NORMALE
                if (p1.numberOfSilverKeys > 0)
                {
                  if (chest.getOpenWith().equals(p1.silver_key))
                  {
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
                } else
                {
                  render.canOpenChest = false;
                }
              }
            }
          } else
          {
            // resettta la variabile
            p1.isInteracting = false;
          }
        }
      }
    }
  }

  // gestisce le monete - OK ???
  void handleCoin() {
    // ----- COIN -----
    for (Coin coin : currentLevel.coins) {
      if (isInVisibleArea(coin.getPosition())) {
        // mostra le monete nell'area visibile
        if (!coin.isCollected()) {
          // if (coin.sprite_collision(p1))
          if (collision.sprite_collision(coin, p1)) 
          {
            coin.collect();  // raccogli la moneta
            p1.collectCoin();
            pickupCoin.play();
            p1.updateScore(coin.scoreValue);
          }
        }
      }
    }
  }

  // gestisce gli oggetti rilasciati dai nemici e dalle casse
  // da riscrivere completamente
  void handleDropItems() {
    // ----- DROP ITEMS -----
    Iterator<Item> iterator = currentLevel.dropItems.iterator();

    while (iterator.hasNext()) {
      Item item = iterator.next();

      // controlla che gli elementi droppati siano visibili
      if (isInVisibleArea(item.getPosition()))
      {
        // item.display(spritesLayer);

        render.drawInteractableLetter = false;

        // if (item.sprite_collision(p1))
        if (collision.sprite_collision(item, p1)) 
        {
          render.drawInteractableLetter = true;

          if (item.isWeapon())
          {
            render.drawUpBuff = false;
            render.drawDownBuff = false;

            Item temp = item;

            // mostra se un'arma è piu forte o debole rispetto a quella del giocatore
            if (temp.damage > p1.weapon.damage)
            {
              render.drawUpBuff = true;
            } else if (temp.damage < p1.weapon.damage)
            {
              render.drawDownBuff = true;
            }
          }

          if (p1.moveINTR && (!p1.moveUSE && !p1.moveATCK))
          {
            if (!p1.isInteracting)
            {
              p1.isInteracting = true;

              // if (item instanceof Healer)
              if (item.isHealer())
              { // verifico prima che sia un oggetto curativo
                if (item.name.equals("dropPotion"))
                {  // se è un pozione aggiungila
                  p1.numberOfPotion++;
                  iterator.remove();
                } else
                {  // se è un cuore recupera la vita istantaneamente
                  if (p1.playerHP < p1.playerMaxHP)
                  { // verifico che la salute del giocatore sia minore della salute massima
                    // Healer healerItem = (Healer) item;
                    Item healerItem = item;

                    p1.takeHP(healerItem.getBonusHp());

                    // una volta che è stato utilizzato l'oggetto viene rimosso dalla lista
                    iterator.remove();
                  } else
                  {
                    // da togliere di qua e mettere nel metodo di render
                    // TextDisplay healthFull = new TextDisplay(p1.getPosition(), "Salute al massimo", color(255));
                    // healthFull.display(spritesLayer);
                  }
                }
              }

              // else if (item instanceof Weapon)
              else if (item.isWeapon())
              {
                // una volta scambiata l'arma non è piu possibile recuperare quella vecchia
                // assegna arma a terra al giocatore
                // p1.weapon = (Weapon) item;
                p1.weapon = item;
                // rimuovi l'oggetto droppato a terra
                iterator.remove();
              } else if (item.isCollectible && item.name.equals("dropSilverKey"))
              {
                // aumenta il numero delle chiavi d'argento
                p1.takeSilverKey();
                iterator.remove();
              } else if (item.isCollectible && item.name.equals("dropGoldenKey"))
              {
                // aumenta il numero delle chiavi d'oro
                p1.takeGoldenKey();
                iterator.remove();
              } else if (item.isCollectible && item.name.equals("dropTorch"))
              {
                // aumenta il raggio della maschera
                // holeRadius += 50;
                iterator.remove();
              } else if (item.isCollectible && item.name.equals("dropMap"))
              {
                // attiva la minimappa per tutti i livelli
                ui.activateMap();
                iterator.remove();
              }
            }
          } else
          {
            // resetta la variabile di stato
            p1.isInteracting = false;
          }
        }
      }
    }
  }
}
