class Game {
  void init() {
    // create world
    castle = new World();

    currentZone = castle.currentZone;
    currentLevel = currentZone.currentLevel;
    currentLevel.init();

    actualLevel = currentZone.zoneName + " - " + currentLevel.levelName;

    p1 = new Player(50, 100, 0, 5, 5);
    p1.spritePosition = currentLevel.getStartPosition();
    p1.sprite = spriteRight;
    p1.redPotion = redPotion;
    p1.greenPotion = greenPotion;
    
    p1.weapon = sword;
    p1.weapon.spritePosition = p1.spritePosition;
    println(p1.weapon.spritePosition);
    
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
          screen_state = WIN_SCREEN;
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
          screen_state = STORY_SCREEN;
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

    image(gameScene, 0, 0);
    image(spritesLayer, 0, 0);
  }
  
  void updateGame() {
    handlePlayerMovement();
    handlePlayerAttack();
    handlePotionUse();
    handleEnemyActions();
    handleChest();
    handleCoin();
    handleDropItems();
  }
  
  // gestisce il movimento del player
  void handlePlayerMovement() {
    p1.display(spritesLayer);
    p1.move();
  }
  
  // gestisce l'attacco del giocatore
  void handlePlayerAttack() {
    if (p1.moveATCK && (!p1.moveUSE && !p1.moveINTR) && !isAttacking) {
      p1.drawPlayerWeapon();
      isAttacking = true;
    }
  }
  
  
  // gestisce l'uso delle pozioni 
  void handlePotionUse() {
    if (p1.moveUSE && (!p1.moveATCK && !p1.moveINTR) && p1.numberOfPotion > 0 && !isUsingPotion) {
      isUsingPotion = true;
      if (p1.playerHP < p1.playerMaxHP) {
        drinkPotion.play();
        p1.playerHP += p1.redPotion.getBonusHp();

        if (p1.playerHP > p1.playerMaxHP) p1.playerHP = p1.playerMaxHP;

        p1.numberOfPotion -= 1;
      } else {
        spritesLayer.textFont(myFont);
        spritesLayer.fill(255);
        spritesLayer.textSize(10);
        spritesLayer.text("Cuori al massimo!", (p1.spritePosition.x * currentLevel.tileSize) - 30, (p1.spritePosition.y * currentLevel.tileSize) - 5);
      }
    }
  }
  
  // gestisce le azioni del nemico 
  void handleEnemyActions() {
    Iterator<Enemy> iterator = currentLevel.enemies.iterator();
    
    while (iterator.hasNext()) {
      Enemy enemy = iterator.next();
  
      if (isInVisibleArea(enemy.spritePosition)) {
        if (enemy.enemyHP > 0) {
          enemy.display(spritesLayer);
        }
  
        if (isAttacking) {
          if (p1.collidesWith(enemy)) {
            // riproduci il suono di hit
            // attackHit.play();
            
            // vita meno danno dell'arma
            enemy.enemyHP -= p1.weapon.getDamage();
            
            spritesLayer.textFont(myFont);
            spritesLayer.fill(255, 0, 0);
            spritesLayer.textSize(15);
            spritesLayer.text(p1.weapon.getDamage(), (enemy.spritePosition.x * currentLevel.tileSize), (enemy.spritePosition.y * currentLevel.tileSize) - 10);
  
            // il nemico muore, rimuovilo dalla lista dei nemici del livello
            // aggiungi un certo valore allo score del giocatore 
            // possibilita di droppare l'oggetto
            if (enemy.enemyHP <= 0) {
                p1.playerScore += enemy.scoreValue;
            
                // numero casuale
                double randomValue = Math.random();
                println("random value:" + randomValue);
            
                // probabilità che il nemico droppi qualcosa
                // in questo caso 40 %
                double dropProbability = 0.4;
            
                if (randomValue <= dropProbability) {
                    // Il nemico ha superato la probabilità di drop, crea e aggiungi un oggetto alla lista
                    Healer dropHeart = new Healer("dropHeart", 10);
                    dropHeart.sprite = heart.sprite;
                    dropHeart.spritePosition = enemy.spritePosition;
                    currentLevel.dropItems.add(dropHeart);
                }
            
                iterator.remove();  // Rimuovi il nemico dalla lista
            }
          }
        }
  
        if (enemy.playerCollide(p1)) {
          // attacca il giocatore
          println("collsione nemico giocatore");
          enemy.attack();
        } else {
          // muovi il nemico
          // enemy.move();
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
        chest.display(spritesLayer);
        
        if(chest.playerCollide(p1) && !chest.isOpen()) {
          println("collsione cassa giocatore");
          spritesLayer.noFill(); // Nessun riempimento
          spritesLayer.stroke(255); // Colore del bordo bianco
          spritesLayer.rect(chest.spritePosition.x * currentLevel.tileSize + (chest.sprite.width/2), chest.spritePosition.y * currentLevel.tileSize + (chest.sprite.height / 2), chest.sprite.width, chest.sprite.height);
          
          float letterImageX = (chest.spritePosition.x * currentLevel.tileSize + (chest.sprite.width / 2));
          float letterImageY = (chest.spritePosition.y * currentLevel.tileSize + (chest.sprite.height / 2)) - 20; // Regola l'offset verticale a tuo piacimento
          spritesLayer.image(letter_k, letterImageX, letterImageY);
          
          // se il giocatore preme il tasto interazione e la cassa non è stata aperta
          if (p1.moveINTR && (!p1.moveUSE && !p1.moveATCK)) {
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
                // da adattare alla rectmode Center
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
                // da adattare alla rectmode Center
                spritesLayer.text("Non hai piu chiavi!", (p1.spritePosition.x * currentLevel.tileSize) - 50, (p1.spritePosition.y * currentLevel.tileSize) - 10);
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
          coin.display(spritesLayer);
          
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
  
  // gestisce gli oggetti rilasciati dai nemici 
  void handleDropItems() {
    // ----- DROP ITEMS -----
    Iterator<Item> iterator = currentLevel.dropItems.iterator();
    
    while(iterator.hasNext()) {
      Item item = iterator.next();
      
      if(isInVisibleArea(item.spritePosition)) {
        item.display(spritesLayer);
        
        if(item.playerCollide(p1)) {
          spritesLayer.noFill(); // Nessun riempimento
          spritesLayer.stroke(255); // Colore del bordo bianco
          spritesLayer.rect(item.spritePosition.x * currentLevel.tileSize + (item.sprite.width/2), item.spritePosition.y * currentLevel.tileSize + (item.sprite.height / 2), item.sprite.width, item.sprite.height);
          
          float letterImageX = (item.spritePosition.x * currentLevel.tileSize + (item.sprite.width / 2));
          float letterImageY = (item.spritePosition.y * currentLevel.tileSize + (item.sprite.height / 2)) - 20; // Regola l'offset verticale a tuo piacimento
          spritesLayer.image(letter_k, letterImageX, letterImageY);
          
          if (p1.moveINTR && (!p1.moveUSE && !p1.moveATCK)) {
            if (item instanceof Healer) { // verifico prima che sia un oggetto curativo 
              Healer healerItem = (Healer) item;
              
              p1.playerHP += healerItem.getBonusHp();
              
              if (p1.playerHP > p1.playerMaxHP) p1.playerHP = p1.playerMaxHP;
              
              // una volta che è stato utilizzato l'oggetto viene rimosso dalla lista
              iterator.remove();
            }
          }
        }
      }
    }
  }
}
