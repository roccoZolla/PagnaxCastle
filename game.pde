<<<<<<< HEAD
// contiene le logiche di gioco
class Game {
  // DifficultyLevel difficultyLevel; // livello di difficolta del gioco

  // game settings
  Level level;
  //  Zone zone;
  int numberOfZone = 1;    // numero delle zone che compongono il gioco
  int zoneIndex = 1;
  int numberOfLevels = 8;
  int levelIndex = 1;

  // provvisorio
  String dataPath =  "data/zone_1/";

  FWorld world; // va aggiornato ogni volta
=======
// da spostare nella classe game
// non definitivi
World castle;
Zone currentZone;
Level currentLevel;

// contiene le logiche di gioco
class Game {
  // DifficultyLevel difficultyLevel; // livello di difficolta del gioco
  Level level;
  int levelIndex = 1;

  // FWorld world; // va aggiornato ogni volta
>>>>>>> fix

  Boss boss;    // boss del gioco

  boolean moveATCK;    // attacco j
  boolean moveINTR;    // interazione k
  boolean moveUSE;     // utilizza l

  boolean isBossLevel;          // indica se ci troviamo nel livello finale, di base è false
  boolean isTorchDropped;       // indica se la torcia è stata droppata, di base false
  boolean isMapDropped;         // indica se la mappa è stata droppata, di base false
  boolean isMasterSwordDropped; // indica se la spada suprema è stata droppata, di base false

  ArrayList<Character> characters;
<<<<<<< HEAD
  ArrayList<Item> dropItems;    // lista degli oggetti caduti a terra
=======
>>>>>>> fix

  Game()
  {
    // zone = new Zone();
    level = new Level();

    // world physics settings
    world = new FWorld();
    world.setGrabbable(false);
    world.setGravity(0, 0);
    world.setEdges();
  }

<<<<<<< HEAD
  void init()
  {
    // difficultyLevel = DifficultyLevel.NORMALE;
    characters = new ArrayList<Character>();
    dropItems = new ArrayList<Item>();
=======
  void init() 
  {
    // difficultyLevel = DifficultyLevel.NORMALE;
    characters = new ArrayList<Character>();
>>>>>>> fix

    isBossLevel = false;
    isTorchDropped = false;
    isMapDropped = false;
    isMasterSwordDropped = false;

    // reimposta lo stato della mappa, disattivo
    ui.deactivateMap();
    ui.resetBossLevelUI();

    // da togliere di qua
    golden_key = new Item(null, "golden_key");
    silver_key = new Item(null, "silver_key");

    // carica una sola volta all'inizio gli assets del livello
    level.loadAssets(dataPath);
    level.init();

<<<<<<< HEAD
    // da togliere di qua
    // ui.setActualLevelText(zone.name + " - Livello " + levelIndex);

    // inizializza il player
    p1 = new Player(100, 100);
    p1.updatePosition(level.getStartPosition());
=======
    currentZone = castle.currentZone;

    // caricamento delle immagini
    currentZone.loadAssetsZone();

    // inizializzo un livello per volta
    currentLevel = currentZone.currentLevel;
    currentLevel.loadAssetsLevel();
    currentLevel.init();

    // carica una sola volta all'inizio gli assets del livello
    // level.loadAssetsLevel();
    // level.init();

    ui.setActualLevelText(currentZone.zoneName + " - " + currentLevel.levelName);


    // inizializza il player
    p1 = new Player(1000, 1000);
    p1.updatePosition(currentLevel.getStartPosition());
>>>>>>> fix
    println("player position: " + p1.getPosition());

    p1.golden_key = golden_key;
    p1.silver_key = silver_key;

    // avvia i timer
    fps_timer.timerStart();
    tick_timer.timerStart();

    fps_clock.timerStart();
    tick_clock.timerStart();

<<<<<<< HEAD
    // da sistemare
    world.add(p1.box);

    // da sistemare
    characters.add(p1);

    for (Enemy enemy : level.enemies)
=======
    //
    currentLevel.level.add(p1.box);

    //
    characters.add(p1);
    for (Enemy enemy : currentLevel.enemies)
>>>>>>> fix
    {
      characters.add(enemy);
    }

    println("game system inizializzato correttamente!");
  }

  private void initBossBattle()
  {
    // crea il livello finale
    world = new FWorld(); // ripulisci il mondo fisico
    world.setGrabbable(false);
    world.setGravity(0, 0);
    world.setEdges();

    level = new Level();
    level.loadAssets(dataPath);
    level.initBossLevel();

    characters = new ArrayList<Character>();

    // posizione il giocatore nel punto di spawn
    p1.createBox();
    p1.updatePosition(level.getStartPosition());

<<<<<<< HEAD
    boss = new Boss(boss_sprite, 200, 200);
    boss.updatePosition(level.getStartPosition().x, level.getStartPosition().y);
=======
    // aggiorna il testo relativo al livello attuale
    ui.setActualLevelText(currentZone.zoneName + " - Livello Finale");
>>>>>>> fix

    world.add(p1.box);
    // world.add(p1.getWeapon().box);  // aggiungi l'arma del giocatore al mondo fisico
    world.add(boss.box);

    characters.add(p1);
    characters.add(boss);

    // da sistemare
    ui.setBossLevelUI();

    ui.deactivateMap();
  }

  boolean IsBossLevel() {
    return isBossLevel;
  }

  void addDropItem(Item dropItem)
  {
    dropItems.add(dropItem);
    world.add(dropItem.box);
  }

  int getCols() {
    return level.cols;
  }
  
  int getRows() {
    return level.rows;
  }

  // funzione che gestisce tutti gli eventi in input relativi al giocatore
  // e alle altre entita
  void update()
  {
    // gestione controlli player
    // handlePlayerDeath();
<<<<<<< HEAD
=======
    // da sistemare
    currentLevel.level.step();
>>>>>>> fix

    p1.update();

<<<<<<< HEAD
    //if(moveATCK)
    //{
    //  p1.attack();
    //}
    // p1.attack();  // deve essere chiamata solo quando viene premuto il tasto
    //p1.usePotion(spritesLayer);  // deve essere chiamata solo quando viene premuto il tasto

    if (isBossLevel)
    {
      // aggiorna movimento boss
      // boss.update();

      // handlePlayerVictory();
    } else
    {
      // aggiorna movimento nemici
      // enemiesUpdate();
    }
=======
    //if (!isBossLevel) {
    //  // gestione azione nemici
    // handleEnemyActions();

    //  // gestione casse
    //  handleChest();

    //  // gestion drop items
    //  handleDropItems();

    //  // gestione monete
    //  // handleCoin(); metodo chiamato direttamente dal collider

    //  // gestione livello successivo
    //  // handleNextLevel(); metodo chiamato direttamente dal collider
    //} else {
    //  handlePlayerVictory();
    //  // gestione azioni boss
    //  boss.update(p1);
    //}
>>>>>>> fix
  }

  // handlers ------------------------------
  // gestisce la vittoria del giocatore - OK
  void handlePlayerVictory() {
<<<<<<< HEAD
    if (boss.IsDead())
    {
=======
    if (boss.IsDead()) {
>>>>>>> fix
      p1.updateScore(1000);
      screen_state = ScreenState.WIN_SCREEN;
    }
  }

  // gestisce la morte del giocatore - OK
<<<<<<< HEAD
  void handlePlayerDeath()
  {
=======
  void handlePlayerDeath() {
>>>>>>> fix
    if (p1.IsDead()) {
      screen_state = ScreenState.LOSE_SCREEN;
    }
  }

<<<<<<< HEAD
  // da sistemare
  // viene chiamata solo quando si collide con le scale
  void handleNextLevel()
  {
    // il livello corrisponde al livello finale della zona
    if (levelIndex == numberOfLevels)
    {
      println("levelIndex uguale a numberOfLevels");
      // verifica che la zona sia la zona finale
      // in caso positivo spostati nella sala del boss
      if (zoneIndex == numberOfZone)
      {
        println("zoneIndex uguale a numberOfZone");
        // inizializza la battaglia finale
        isBossLevel = true;
        initBossBattle();
      } else  // passa alla prossima zona
      {
        zoneIndex += 1;
        // resetta il level index a 1
        levelIndex = 1;
        // carica gli assets della nuova zona nel livello
        // specifica il datapath magari prendendelo dal json
        // level.loadAssestLevel();
        // una volta caricati quando di passa al livello successivo non ci sara bisogno di ricaricarli
        // inizializza il livello
        world = new FWorld(); // ripulisci il mondo fisico
        world.setGrabbable(false);
        world.setGravity(0, 0);
        world.setEdges();

        characters.clear();
        dropItems.clear();

        level.init();
        p1.createBox();
        p1.updatePosition(level.getStartPosition());
        // aggiorna lo score del player
        p1.updateScore(200);

        world.add(p1.box);

        // da sistemare
        characters.add(p1);

        for (Enemy enemy : level.enemies)
        {
          characters.add(enemy);
        }

        screen_state = ScreenState.STORY_SCREEN;
      }
    } else  // altrimenti passa al livello successivo della stessa zona
    {
      println("passa al livello successivo...");
      levelIndex += 1;

      world = new FWorld(); // ripulisci il mondo fisico
      world.setGrabbable(false);
      world.setGravity(0, 0);
      world.setEdges();

      characters.clear();
      dropItems.clear();
      // deve essere aggiornato anche characters
      // gli asset sono stati gia caricati
      level.init();
      p1.createBox();
      p1.updatePosition(level.getStartPosition());
      println("level get start position: " + level.getStartPosition());
      println("player start position: " + p1.getPosition());
      // aggiorna lo score del player
      p1.updateScore(100);

      // da sistemare
      world.add(p1.box);

      // da sistemare
      characters.add(p1);

      for (Enemy enemy : level.enemies)
      {
        characters.add(enemy);
      }
    }
  }
=======
  //
  void handleNextLevel()
  {
    if (levelIndex == currentZone.numberLevels)
    {
      // verifica che la zona sia la zona finale
      // in caso positivo spostati nella sala del boss
      if (currentZone.isFinal())
      {
      } else  // passa alla prossima macroarea
      {
        // zoneIndex += 1;
        // resetta il level index a 1
        // carica gli assets della nuova zona nel livello
        // level.loadAssestLevel();
        // una volta caricati quando di passa al livello successivo non ci sara bisogno di ricaricarli
        // inizializza il livello
        // world.clear();
        // level.init();
        // ui.setActualLevelText(currentZone.zoneName + " - " + currentLevel.levelName);
        // p1.updatePosition(currentLevel.getStartPosition());
        // // aggiorna lo score del player
        // p1.updateScore(200);
        // screen_state = ScreenState.STORY_SCREEN;
      }
    } else  // altrimenti passa al livello successivo della stessa zona
    {
      //levelIndex += 1;
      // gli asset sono stati gia caricati
      // world.clear
      // deve essere aggiornato anche characters
      // level.init();
      // ui.setActualLevelText(currentZone.zoneName + " - " + currentLevel.levelName);
      // p1.updatePosition(currentLevel.getStartPosition());
      // // aggiorna lo score del player
      // p1.updateScore(100);
    }
  }

  // gestisce il passaggio al livello successivo - DA SISTEMARE
  //void handleNextLevel()
  //{
  //  // se il livello dell'area è l'ultimo passa alla prossima area
  //  if (currentLevel.levelIndex == currentZone.levels.size() - 1)
  //  {
  //    // controlla se è l'area finale
  //    if (currentZone.isFinal())
  //    {
  //      initBossBattle();
  //      isBossLevel = true;
  //    } else
  //    {
  //      // passa alla prossima macroarea
  //      currentZone = castle.zones.get(currentZone.zoneIndex + 1);
  //      currentLevel = currentZone.currentLevel;
  //      currentLevel.loadAssetsLevel();
  //      currentLevel.init();
  //      actualLevel = currentZone.zoneName + " - " + currentLevel.levelName;
  //      p1.updatePosition(currentLevel.getStartPosition());

  //      // aggiorna lo score del player
  //      p1.updateScore(200);
  //      screen_state = ScreenState.STORY_SCREEN;
  //    }
  //  } else
  //  {
  //    // passa al livello successivo - stessa macro area
  //    currentLevel = currentZone.levels.get(currentLevel.levelIndex + 1);
  //    currentLevel.loadAssetsLevel();
  //    currentLevel.init();
  //    actualLevel = currentZone.zoneName + " - " + currentLevel.levelName;
  //    p1.updatePosition(currentLevel.getStartPosition());

  //    // aggiorna lo score del player
  //    p1.updateScore(100);
  //  }
  //}
>>>>>>> fix

  // gestisce l'attacco del nemico
  // da migliorare
  void handleEnemyAttack(FBody enemyBody)
  {
<<<<<<< HEAD
    // for (Enemy enemy : currentLevel.enemies)
    for (Enemy enemy : level.enemies)
=======
    for (Enemy enemy : currentLevel.enemies)
>>>>>>> fix
    {
      if (isInVisibleArea(enemy.getPosition()))
      {
        if (enemy.getBox() == enemyBody)
        {
          p1.takeDamage(enemy.getDamage());
          println("attacco subito: " + enemy.getDamage());
        }
      }
    }
  }

  // gestisce le azioni del nemico - DA RIVEDERE
  //void handleEnemyActions() {
  //  Iterator<Enemy> iterator = currentLevel.enemies.iterator();

  //  while (iterator.hasNext()) {
  //    Enemy enemy = iterator.next();

  //    if (isInVisibleArea(enemy.getPosition())) {
  //      if (enemy.hp > 0) {
  //        enemy.update();

  //        // attacca solo se c'è collisione
  //        // if (enemy.sprite_collision(p1))
  //        if (checkCollision(enemy, p1)) {
  //          enemy.attack(p1);
  //        } else {
  //          enemy.first_attack = true;
  //        }
  //      } else {
  //        enemy.death();
  //        // p1.updateScore(enemy.scoreValue);
  //        iterator.remove();
  //      }
  //    }
  //  }
  //}
<<<<<<< HEAD

  // gestione delle chest - DA SISTEMARE
  // da migliorare
  void handleChest(FBody chestBody)
  {
    for (Chest chest : level.treasures)
    {
      if (chest.getBox() == chestBody)
      {
        // println("collisione chest rilevata!");

        // aggiungere logica
        if (p1.moveINTR && (!p1.moveUSE && !p1.moveATCK))
        {
          if (!p1.isInteracting)
          {
            p1.isInteracting = true;
            if (chest.isRare())
            {    // se la cassa è rara
              // CASSA RARA
              if (p1.numberOfGoldenKeys > 0 && !chest.isOpen())
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
              }
            } else
            {  // se la cassa è normale
              // CASSA NORMALE
              if (p1.numberOfSilverKeys > 0 && !chest.isOpen())
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

  // gestisce le trappole
  // da migliorare ma ci siamo
  void handlePeaks(FBody trapBody, FBody characterBody)
  {
    // for (Trap trap : currentLevel.traps)
    for (Trap trap : level.traps)
    {
      if (trap.getBox() == trapBody)
      {
        for (Character character : characters)
        {
          if (!character.IsDead())
          {
            if (character.getBox() == characterBody)
            {
              if (character.IsDamageable())
              {
                character.takeDamage(trap.getDamage());
                println("danno subito: " + trap.getDamage());
=======

  // gestione delle chest - DA SISTEMARE
  // da migliorare
  void handleChest(FBody chestBody)
  {
    for (Chest chest : currentLevel.treasures)
    {
      if (isInVisibleArea(chest.getPosition()))
      {

        if (chest.getBox() == chestBody)
        {
          println("collisione chest rilevata!");

          // aggiungere logica
          if (p1.moveINTR && (!p1.moveUSE && !p1.moveATCK))
          {
            if (!p1.isInteracting)
            {
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
                  render.isPossibleToOpenChest = false;
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
                  render.isPossibleToOpenChest = false;
                }
>>>>>>> fix
              }
            }
          }
        }
      }
    }
  }

  // gestisce le monete - OK ???
  void handleCoin(FBody coinBody)
  {
    // for (Coin coin : currentLevel.coins)
    for (Coin coin : level.coins)
    {
      // mostra le monete nell'area visibile
      if (!coin.IsCollected()) {
        if (coin.getBox() == coinBody)
        {
          coin.collect();  // raccogli la moneta
          p1.collectCoin();
          pickupCoin.play();
          p1.updateScore(coin.scoreValue);
          world.remove(coin.getBox());
        }
      }
    }
  }

  // gestisce gli oggetti rilasciati dai nemici e dalle casse
  // da riscrivere completamente
  void handleDropItems(FBody dropItemBody) {
    for (Item dropItem : dropItems)
    {
      if (dropItem.getBox() == dropItemBody)
      {
        println("collisione item rilevata!");
        if (dropItem.IsCollectible() &&
          !dropItem.IsCollected())
        {
          // aggiungere logica
          if (p1.moveINTR && (!p1.moveUSE && !p1.moveATCK))
          {
            if (!p1.isInteracting)
            {
              p1.isInteracting = true;
              println("oggetto raccolto!");

              // aggiungere valori score

              // se l'oggetto è un'arma
              if (dropItem.IsWeapon())
              {
                world.remove(p1.getWeapon().box);
                // dropItem.setWeapon(true);
                p1.setWeapon(dropItem);
                world.add(p1.getWeapon().box);
              } else if (dropItem.IsHealer())
              {
                // se l'oggetto è una pozione
                // aumenta il numero di pozioni disponibili
                p1.numberOfPotion++;
              }
              // se l'oggetto è una chiave
              // aumenta il numero di chiavi
              else if (dropItem.getName().equals("dropSilverKey"))
              {
                p1.numberOfSilverKeys++;
              } else if (dropItem.getName().equals("dropGoldenKey"))
              {
                p1.numberOfGoldenKeys++;
              }
              // se l'oggetto è la torcia aumenta il raggio della maschera
              else if (dropItem.getName().equals("dropTorch"))
              {
                // aumenta il raggio della maschera
                render.applyTorchEffect();
              }
              //
              else if (dropItem.getName().equals("dropMap"))
              {
                // attiva la minimapp
                ui.activateMap();
              }

              // imposta l'oggetto come collezionato
              dropItem.setCollected();
              // rimuovi l'oggetto dal mondo fisico
              world.remove(dropItem.getBox());
            }
          } else
          {
            // resettta la variabile
            p1.isInteracting = false;
          }
        }
      }
    }

    // ----- CHEST -----
    // disegna solo le chest visibili
    //for (Chest chest : currentLevel.treasures) {
    //  if (isInVisibleArea(chest.getPosition())) {
    //    // if (chest.sprite_collision(p1) && !chest.isOpen())
    //    if (checkCollision(chest, p1) && !chest.isOpen())
    //    {
    //      // println("collsione cassa giocatore");
    //      render.canOpenChest = true;

    //      // se il giocatore preme il tasto interazione e la cassa non è stata aperta
    //if (p1.moveINTR && (!p1.moveUSE && !p1.moveATCK)) {
    //  if (!p1.isInteracting) {
    //    p1.isInteracting = true;
    //    if (chest.isRare())
    //    {    // se la cassa è rara
    //      // CASSA RARA
    //      if (p1.numberOfGoldenKeys > 0)
    //      {
    //        if (chest.getOpenWith().equals(p1.golden_key))
    //        {
    //          // imposta la cassa come aperta
    //          chest.setIsOpen(true);
    //          chest_open.play();
    //          // per migliorare prestazioni, carico questo immagine all'inizio e l'assegno quando mi serve
    //          chest.sprite = special_chest_open_sprite;

    //          p1.numberOfGoldenKeys -= 1;
    //          p1.updateScore(50);

    //          chest.dropItemSpecialChest();
    //        }
    //      } else
    //      {
    //        render.canOpenChest = false;
    //      }
    //    } else
    //    {  // se la cassa è normale
    //      // CASSA NORMALE
    //      if (p1.numberOfSilverKeys > 0)
    //      {
    //        if (chest.getOpenWith().equals(p1.silver_key))
    //        {
    //          // imposta la cassa come aperta
    //          chest.setIsOpen(true);
    //          chest_open.play();
    //          // per migliorare prestazioni, carico questo immagine all'inizio e l'assegno quando mi serve
    //          chest.sprite = chest_open_sprite;

    //          p1.numberOfSilverKeys -= 1;
    //          p1.updateScore(30);

    //          // metodo per drop item casuale
    //          chest.dropItemNormalChest();
    //        }
    //      } else
    //      {
    //        render.canOpenChest = false;
    //      }
    //    }
    //  }
    //} else
    //{
    //  // resettta la variabile
    //  p1.isInteracting = false;
    //}
    //    }
    //  }
    //}
  }

  // gestisce le trappole
  // da migliorare ma ci siamo
  void handlePeaks(FBody trapBody, FBody characterBody) {
    for (Trap trap : currentLevel.traps) {
      if (isInVisibleArea(trap.getPosition()))
      {
        if (trap.getBox() == trapBody)
        {
          for (Character character : characters)
          {
            if (!character.IsDead()) {
              if (character.getBox() == characterBody)
              {
                if (character.IsDamageable())
                {
                  character.takeDamage(trap.getDamage());
                  println("danno subito: " + trap.getDamage());
                }
              }
            }
          }
        }
      }
    }
  }
<<<<<<< HEAD
=======

  // gestisce le monete - OK ???
  void handleCoin(FBody coinBody) {
    for (Coin coin : currentLevel.coins) {
      if (isInVisibleArea(coin.getPosition())) {
        // mostra le monete nell'area visibile
        if (!coin.isCollected()) {
          if (coin.getBox() == coinBody)
          {
            coin.collect();  // raccogli la moneta
            p1.collectCoin();
            pickupCoin.play();
            p1.updateScore(coin.scoreValue);
            currentLevel.level.remove(coinBody);  // rimuovi la moneta dal mondo fisico
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
        //if (checkCollision(item, p1))
        //{
        //  render.drawInteractableLetter = true;

        //  if (item.isWeapon())
        //  {
        //    render.drawUpBuff = false;
        //    render.drawDownBuff = false;

        //    Item temp = item;

        //    // mostra se un'arma è piu forte o debole rispetto a quella del giocatore
        //    if (temp.damage > p1.weapon.damage)
        //    {
        //      render.drawUpBuff = true;
        //    } else if (temp.damage < p1.weapon.damage)
        //    {
        //      render.drawDownBuff = true;
        //    }
        //  }

        //  if (p1.moveINTR && (!p1.moveUSE && !p1.moveATCK))
        //  {
        //    if (!p1.isInteracting)
        //    {
        //      p1.isInteracting = true;

        //      // if (item instanceof Healer)
        //      if (item.isHealer())
        //      { // verifico prima che sia un oggetto curativo
        //        if (item.name.equals("dropPotion"))
        //        {  // se è un pozione aggiungila
        //          p1.numberOfPotion++;
        //          iterator.remove();
        //        } else
        //        {  // se è un cuore recupera la vita istantaneamente
        //          if (p1.hp < p1.playerMaxHP)
        //          { // verifico che la salute del giocatore sia minore della salute massima
        //            // Healer healerItem = (Healer) item;
        //            Item healerItem = item;

        //            p1.restoreHP(healerItem.getBonusHp());

        //            // una volta che è stato utilizzato l'oggetto viene rimosso dalla lista
        //            iterator.remove();
        //          } else
        //          {
        //            // da togliere di qua e mettere nel metodo di render
        //            // TextDisplay healthFull = new TextDisplay(p1.getPosition(), "Salute al massimo", color(255));
        //            // healthFull.display(spritesLayer);
        //          }
        //        }
        //      }

        //      // else if (item instanceof Weapon)
        //      else if (item.isWeapon())
        //      {
        //        // una volta scambiata l'arma non è piu possibile recuperare quella vecchia
        //        // assegna arma a terra al giocatore
        //        // p1.weapon = (Weapon) item;
        //        p1.weapon = item;
        //        // rimuovi l'oggetto droppato a terra
        //        iterator.remove();
        //      } else if (item.isCollectible && item.name.equals("dropSilverKey"))
        //      {
        //        // aumenta il numero delle chiavi d'argento
        //        p1.takeSilverKey();
        //        iterator.remove();
        //      } else if (item.isCollectible && item.name.equals("dropGoldenKey"))
        //      {
        //        // aumenta il numero delle chiavi d'oro
        //        p1.takeGoldenKey();
        //        iterator.remove();
        //      } else if (item.isCollectible && item.name.equals("dropTorch"))
        //      {
        //        // aumenta il raggio della maschera
        //        // holeRadius += 50;
        //        iterator.remove();
        //      } else if (item.isCollectible && item.name.equals("dropMap"))
        //      {
        //        // attiva la minimappa per tutti i livelli
        //        ui.activateMap();
        //        iterator.remove();
        //      }
        //    }
        //  } else
        //  {
        //    // resetta la variabile di stato
        //    p1.isInteracting = false;
        //  }
        //}
      }
    }
  }
>>>>>>> fix
}
