enum DifficultyLevel {
  FACILE,
  NORMALE,
  DIFFICILE
}

class Game {
  DifficultyLevel difficultyLevel; // livello di difficolta del gioco
  float holeRadius; // raggio della maschera
  boolean isTorchDropped; // indica se la torcia è stata droppata
  boolean isMapDropped; // indica se la mappa è stata droppata
  ConcreteDamageHandler damageTileHandler;
  
  Game() {
    // di default la difficolta del gioco è impostata su normale
    difficultyLevel = DifficultyLevel.NORMALE;
  }
  
  void init() {
    // create world
    castle = new World();
    
    damageTileHandler = new ConcreteDamageHandler();

    currentZone = castle.currentZone;
    currentZone.loadAssetsZone();
    currentLevel = currentZone.currentLevel;
    // inizializzo un livello per volta
    currentLevel.init();

    actualLevel = currentZone.zoneName + " - " + currentLevel.levelName;
    
    // reimposta lo stato della mappa
    ui.deactivateMap();

    p1 = new Player(50, 100, 10, 15, 5, damageTileHandler);
    p1.spritePosition = currentLevel.getStartPosition();
    p1.sprite = spriteRight;
    p1.redPotion = redPotion;
    p1.greenPotion = greenPotion;
    
    p1.weapon = little_sword;
    p1.weapon.spritePosition = p1.spritePosition;
    println(p1.weapon.spritePosition);
    
    p1.golden_keys = golden_key;
    p1.silver_keys = silver_key;

    camera = new Camera();
    
    holeRadius = 50;
    isTorchDropped = false;
    isMapDropped = false;
  }

  void display() {   
    gameScene.beginDraw();
    gameScene.background(0);

    // aggiorna la camera
    camera.update();

    // Imposta la telecamera alla nuova posizione e applica il fattore di scala
    gameScene.translate(-camera.x, -camera.y);
    gameScene.scale(camera.zoom);

    // Disegna la mappa del livello corrente
    currentLevel.displayRooms();
    currentLevel.display(); // renderizza il 4,6 % della mappa

    spritesLayer.beginDraw();
    spritesLayer.background(255, 0);
    spritesLayer.translate(-camera.x, -camera.y);
    spritesLayer.scale(camera.zoom);
    
    // aggiorna lo stato corrente del gioco
    updateGame();

    spritesLayer.endDraw();

    // passa al livello successivo
    // aggiungere collider
    if (currentLevel.playerCollide(p1)) {
      // se il livello dell'area è l'ultimo passa alla prossima area
      if (currentLevel.levelIndex == currentZone.numLevels - 1) {
        // controlla se è l'area finale
        if (currentZone.isFinal()) {
          screen_state = ScreenState.WIN_SCREEN;
        } else {
          // passa alla prossima macroarea
          currentZone = castle.zones.get(currentZone.zoneIndex + 1);
          // currentArea.initLevels();
          currentLevel = currentZone.currentLevel;
          currentLevel.init();
          actualLevel = currentZone.zoneName + " - " + currentLevel.levelName;
          p1.spritePosition = currentLevel.getStartPosition();

          // aggiorna lo score del player
          p1.playerScore +=  200;
          screen_state = ScreenState.STORY_SCREEN;
        }
      } else {
        // passa al livello successivo - stessa macro area
        // Il giocatore è abbastanza vicino al punto di accesso, quindi passa al livello successivo
        currentLevel = currentZone.levels.get(currentLevel.levelIndex + 1);
        currentLevel.init();
        actualLevel = currentZone.zoneName + " - " + currentLevel.levelName;
        p1.spritePosition = currentLevel.getStartPosition();

        // aggiorna lo score del player
        p1.playerScore += 100;
      }
    }

    gameScene.endDraw();
    
    // mask layer
    maskLayer.beginDraw();
    maskLayer.background(0, 255);
    maskLayer.blendMode(REPLACE);
    
    maskLayer.translate(-camera.x, -camera.y);
    maskLayer.scale(camera.zoom);
    
    float centerX = p1.spritePosition.x * currentLevel.tileSize + currentLevel.tileSize/ 2;
    float centerY = p1.spritePosition.y * currentLevel.tileSize + currentLevel.tileSize/ 2;
    
    maskLayer.fill(255, 0);
    maskLayer.ellipseMode(RADIUS);
    maskLayer.ellipse(centerX, centerY, holeRadius, holeRadius);
    
    maskLayer.endDraw();

    image(gameScene, 0, 0);
    image(spritesLayer, 0, 0);
    // image(maskLayer, 0, 0);
  }
  
  void updateGame() {
    // handlePlayerDeath();
    handlePlayerMovement();
    handlePlayerAttack();
    handlePotionUse();
    handleEnemyActions();
    handleChest();
    handleCoin();
    handleDropItems();
  }
  
  // gestisce la morte del giocatore
  void handlePlayerDeath() {
    if(p1.playerHP <= 0) {
      screen_state = ScreenState.LOSE_SCREEN;
    }
  }
  
  // gestisce il movimento del player
  void handlePlayerMovement() {
    p1.display();
    p1.move();
  }
  
  // gestisce l'attacco del giocatore
  void handlePlayerAttack() {
    if (p1.moveATCK && !p1.moveUSE && !p1.moveINTR) {
      if (!isAttacking && !attackExecuted) {
        p1.drawPlayerWeapon();
        isAttacking = true;
      }
    } else {
      // Resetta la variabile di stato se il tasto relativo all'attacco viene rilasciato
      isAttacking = false;
      attackExecuted = false;
    }
  }

  
  // gestisce l'uso delle pozioni 
  void handlePotionUse() {
    if (p1.moveUSE && (!p1.moveATCK && !p1.moveINTR) && p1.numberOfPotion > 0) {
      if(!isUsingPotion) {
        isUsingPotion = true;
        
        if (p1.playerHP < p1.playerMaxHP) {
          drinkPotion.play();
          p1.playerHP += p1.redPotion.getBonusHp();
  
          if (p1.playerHP > p1.playerMaxHP) p1.playerHP = p1.playerMaxHP;
  
          p1.numberOfPotion -= 1;
        } else {
          TextDisplay healthFull = new TextDisplay(p1.spritePosition, "Salute al massimo", color(255), 1000);
          healthFull.display();
        }
      }
    } else {
      // resetta la variabile di stato
      isUsingPotion = false;
    }
  }
  
  // gestisce le azioni del nemico 
  void handleEnemyActions() {
    Iterator<Enemy> iterator = currentLevel.enemies.iterator();
    
    while (iterator.hasNext()) {
      Enemy enemy = iterator.next();
  
      if (isInVisibleArea(enemy.spritePosition)) {
        if (enemy.enemyHP > 0) {
          enemy.display();
        } else {
          // caso in cui i nemici si uccidono con le trappole
          iterator.remove();
        }
  
        if (isAttacking && !attackExecuted) {
          // da sistemare
          // swordAttack.play();
          if (p1.collidesWith(enemy)) {
            // riproduci il suono di hit del nemico
            // enemy_hurt.play();
            
            // vita meno danno dell'arma
            enemy.enemyHP -= p1.weapon.getDamage();
            
            // l'attacco è stato eseguito non continuare ad attaccare
            attackExecuted = true;
            
            // testo danno subito dal nemico
            TextDisplay damageHitText = new TextDisplay(enemy.spritePosition, Integer.toString(p1.weapon.damage), color(255, 0, 0), 2000);
            damageHitText.display();

            // il nemico muore, rimuovilo dalla lista dei nemici del livello
            // aggiungi un certo valore allo score del giocatore 
            // possibilita di droppare l'oggetto
            if (enemy.enemyHP <= 0) {
                p1.playerScore += enemy.scoreValue;
                
                // metodo per la generazione di un item casuale da droppare
                enemy.dropItem();
            
                iterator.remove();  // Rimuovi il nemico dalla lista
            }
          }
        }
  
        if (enemy.playerCollide(p1)) {
          // attacca il giocatore
          //println("---- COLLISIONE NEMICO GIOCATORE ----");
          //println("nemico: " + enemy.spritePosition);
          //println("giocatore: " + p1.spritePosition);
          enemy.handleAttack();
        } else {
          // muovi il nemico e resetta la first attack
          // da sistemare
          enemy.first_attack = true;
          enemy.move();
        }
      }
    }
  }
  
  // gestione delle chest
  void handleChest() {
  // ----- CHEST -----
    // disegna solo le chest visibili
    for (Chest chest : currentLevel.treasures) {
      if (isInVisibleArea(chest.spritePosition)) {
        // mostra le chest nell'area visibile
        chest.display();
        
        if(chest.playerCollide(p1) && !chest.isOpen()) {
          println("collsione cassa giocatore");
          chest.displayHitbox();
          
          float letterImageX = (chest.spritePosition.x * currentLevel.tileSize + (chest.sprite.width / 2));
          float letterImageY = (chest.spritePosition.y * currentLevel.tileSize + (chest.sprite.height / 2)) - 20; // Regola l'offset verticale a tuo piacimento
          spritesLayer.imageMode(CENTER);
          spritesLayer.image(letter_k, letterImageX, letterImageY);
          
          // se il giocatore preme il tasto interazione e la cassa non è stata aperta
          if (p1.moveINTR && (!p1.moveUSE && !p1.moveATCK)) {
            if (chest.isRare()) {    // se la cassa è rara
            // CASSA RARA
              if (p1.numberOfGoldenKeys > 0) {
                if (chest.getOpenWith().equals(p1.golden_keys)) {
                  // imposta la cassa come aperta
                  chest.setIsOpen(true);
                  specialChestOpen.play();
                  // per migliorare prestazioni, carico questo immagine all'inizio e l'assegno quando mi serve
                  chest.sprite = special_chest_open_sprite;
    
                  p1.numberOfGoldenKeys -= 1;
                  p1.playerScore += 50;
                  
                  chest.dropItemSpecialChest();
                }
              } else {
                TextDisplay noMoreKeyText = new TextDisplay(p1.spritePosition, "Non hai piu chiavi", color(255), 1000);
                noMoreKeyText.display();
              }
            } else {  // se la cassa è normale
            // CASSA NORMALE
              if (p1.numberOfSilverKeys > 0) {
                if (chest.getOpenWith().equals(p1.silver_keys)) {
                  // imposta la cassa come aperta
                  chest.setIsOpen(true);
                  normalChestOpen.play();
                  // per migliorare prestazioni, carico questo immagine all'inizio e l'assegno quando mi serve
                  chest.sprite = chest_open_sprite;
    
                  p1.numberOfSilverKeys -= 1;
                  p1.playerScore += 30;
                  
                  // metodo per drop item casuale
                  chest.dropItemNormalChest(); //<>//
                }
              } else {
                TextDisplay noMoreKeyText = new TextDisplay(p1.spritePosition, "Non hai piu chiavi", color(255), 1000);
                noMoreKeyText.display();
              }
            }
          }
        }
      }
    }
  }

  // gestisce le monete
  void handleCoin() {
    // ----- COIN -----
    for (Coin coin : currentLevel.coins) {
      if (isInVisibleArea(coin.spritePosition)) {   
        // mostra le monete nell'area visibile
        if (!coin.isCollected()) {    // se la moneta non è stata raccolta disegnala
          coin.display();
          
          if(coin.playerCollide(p1)) {
            println("collsione moneta giocatore");
            coin.collect();  // raccogli la moneta
            p1.collectCoin();
            pickupCoin.play();
            p1.playerScore += coin.scoreValue;
          }
        }
      }
    }
  }
  
  // gestisce gli oggetti rilasciati dai nemici e dalle casse
  void handleDropItems() {
    // ----- DROP ITEMS -----
    Iterator<Item> iterator = currentLevel.dropItems.iterator();
    
    while(iterator.hasNext()) {
      Item item = iterator.next();
      
      // controlla che gli elementi droppati siano visibili 
      if(isInVisibleArea(item.spritePosition)) {
        item.display();
        
        if(item.playerCollide(p1)) {
          item.displayHitbox();
          
          float letterImageX = (item.spritePosition.x * currentLevel.tileSize + (item.sprite.width / 2));
          float letterImageY = (item.spritePosition.y * currentLevel.tileSize + (item.sprite.height / 2)) - 20; // Regola l'offset verticale a tuo piacimento
          spritesLayer.imageMode(CENTER);
          spritesLayer.image(letter_k, letterImageX, letterImageY);
          
          if(item instanceof Weapon) {
            Weapon temp = (Weapon) item;
            
            if(temp.damage > p1.weapon.damage) {
              float imageX = (item.spritePosition.x * currentLevel.tileSize + (item.sprite.width / 2) - 20);
              float imageY = (item.spritePosition.y * currentLevel.tileSize + (item.sprite.height / 2)) - 20; // Regola l'offset verticale a tuo piacimento
              spritesLayer.imageMode(CENTER);
              spritesLayer.image(up_buff, imageX, imageY);
            } 
            
            else if(temp.damage < p1.weapon.damage) {
              float imageX = (item.spritePosition.x * currentLevel.tileSize + (item.sprite.width / 2) - 20);
              float imageY = (item.spritePosition.y * currentLevel.tileSize + (item.sprite.height / 2)) - 20; // Regola l'offset verticale a tuo piacimento
              spritesLayer.imageMode(CENTER);
              spritesLayer.image(down_buff, imageX, imageY);
            }
          }
          
          if (p1.moveINTR && (!p1.moveUSE && !p1.moveATCK)) {
            if (item instanceof Healer) { // verifico prima che sia un oggetto curativo 
              if(p1.playerHP < p1.playerMaxHP) { // verifico che la salute del giocatore sia minore della salute massima
                Healer healerItem = (Healer) item;
                p1.playerHP += healerItem.getBonusHp();
                
                if (p1.playerHP > p1.playerMaxHP) p1.playerHP = p1.playerMaxHP;
                
                // una volta che è stato utilizzato l'oggetto viene rimosso dalla lista
                iterator.remove();
              } else {
                TextDisplay healthFull = new TextDisplay(p1.spritePosition, "Salute al massimo", color(255), 1000);
                healthFull.display();
              }
            } else if (item instanceof Weapon) {
              // una volta scambiata l'arma non è piu possibile recuperare quella vecchia
              // assegna arma a terra al giocatore
              p1.weapon = (Weapon) item;
              
              // rimuovi l'oggetto droppato a terra
              iterator.remove();
              
            } else if(item.isCollectible && item.name.equals("dropSilverKey")) {
              // aumenta il numero delle chiavi d'argento
              p1.numberOfSilverKeys++;
              
              iterator.remove();
            } else if(item.isCollectible && item.name.equals("dropGoldenKey")) {
              // aumenta il numero delle chiavi d'argento
              p1.numberOfGoldenKeys++;
              
              iterator.remove();
            } else if (item.isCollectible && item.name.equals("dropTorch")) {
              // aumenta il raggio della maschera
              holeRadius += 50;
              iterator.remove();
            } else if (item.isCollectible && item.name.equals("dropMap")) {
              ui.activateMap();
              iterator.remove();
            }
          }
        }
      }
    }
  }
}
