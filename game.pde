class Game {
  float holeRadius; // raggio della maschera
  boolean isTorchDropped; // indica se la torcia è stata droppata
  boolean isMapDropped; // indica se la mappa è stata droppata
  
  void init() {
    // create world
    castle = new World();

    currentZone = castle.currentZone;
    currentLevel = currentZone.currentLevel;
    currentLevel.init();

    actualLevel = currentZone.zoneName + " - " + currentLevel.levelName;

    p1 = new Player(50, 100, 10, 15, 5);
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
    
    holeRadius = 100;
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
            TextDisplay damageHitText = new TextDisplay(enemy.spritePosition,  Integer.toString(p1.weapon.getDamage()), color(255, 0, 0), 1000);
            damageHitText.display();
  
            // il nemico muore, rimuovilo dalla lista dei nemici del livello
            // aggiungi un certo valore allo score del giocatore 
            // possibilita di droppare l'oggetto
            if (enemy.enemyHP <= 0) {
                p1.playerScore += enemy.scoreValue;
                
                // numero casuale
                double randomValue = Math.random();
                println("random value:" + randomValue);
            
                // probabilità che il nemico droppi qualcosa
                double dropNothingProbability = 0.1;
                double dropSilverKeyProbability = 0.2;
                double dropHeartProbability = 0.3;
                double dropHalfHeartProbability = 0.4;
                
                PVector dropPosition = enemy.spritePosition.copy();
            
                if (randomValue <= dropNothingProbability) {
                    // Nessun drop
                } else if (randomValue <= dropNothingProbability + dropSilverKeyProbability) {
                    // drop della chiave d'argento
                    Item dropSilverKey = new Item("dropSilverKey");
                    dropSilverKey.sprite = silver_key.sprite;
                    dropSilverKey.spritePosition = dropPosition;
                    dropSilverKey.isCollectible = true;
                    currentLevel.dropItems.add(dropSilverKey);
                } else if (randomValue <= dropNothingProbability + dropSilverKeyProbability + dropHeartProbability) {
                    // drop del cuore intero
                    Healer dropHeart = new Healer("dropHeart", 10); 
                    dropHeart.sprite = heart_sprite;
                    dropHeart.spritePosition =dropPosition;
                    currentLevel.dropItems.add(dropHeart);
                } else if (randomValue <= dropNothingProbability + dropSilverKeyProbability + dropHeartProbability + dropHalfHeartProbability) {
                    // drop del mezzocuore
                    Healer dropHalfHeart = new Healer("dropHalfHeart", 5); 
                    dropHalfHeart.sprite = half_heart_sprite;
                    dropHalfHeart.spritePosition = dropPosition;
                    currentLevel.dropItems.add(dropHalfHeart);
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
                  
                  // drop causale dell'item
                  double randomValue = Math.random();
                  println("random value:" + randomValue);
                  
                  // probabilità che la cassa speciale droppi qualcosa
                  double dropTorchProbability = 0.15;    // 15 % 
                  double dropMapProbability = 0.15;     // 15 %
                  double dropSuperSwordProbability = 0.3; // 30 %
                  double dropPotionProbability = 0.4;      // 40 %
                  
                  PVector dropPosition = chest.calculateDropPosition();
                  
                  if (randomValue <= dropTorchProbability && !isTorchDropped) {
                      println("torcia droppata");
                      // drop della torcia
                      Item dropTorch = new Item("dropTorch");
                      dropTorch.sprite = torch_sprite;
                      // da sistemare posizione
                      dropTorch.spritePosition = dropPosition;                    
                      dropTorch.isCollectible = true;
                      currentLevel.dropItems.add(dropTorch);
                      isTorchDropped = true;
                  } else if (randomValue > dropTorchProbability && randomValue <= dropTorchProbability + dropMapProbability && !isMapDropped) {
                      println("mappa droppata");
                      // drop della mappa
                      //Item dropMap = new Item("dropMap");
                      //dropMap.sprite = dungeon_map_sprite;
                      //// da sistemare posizione
                      //dropMap.spritePosition = dropPosition;                    
                      //dropMap.isCollectible = true;
                      //currentLevel.dropItems.add(dropMap);
                      isMapDropped = true;
                  } else if (randomValue > dropTorchProbability + dropMapProbability && randomValue <= dropTorchProbability + dropMapProbability + dropSuperSwordProbability) {
                      println("super spada droppata");
                      // drop della super spada
                      //Weapon dropSuperSword = new Weapon("dropSuperSword", 50); // Assumendo che una super spada valga 50 danni
                      //// dropSuperSword.sprite = super_sword.sprite;
                      //dropSuperSword.spritePosition = dropPosition;
                      //currentLevel.dropItems.add(dropSuperSword);
                  } else if (randomValue > dropTorchProbability + dropMapProbability + dropSuperSwordProbability &&
                             randomValue <= dropTorchProbability + dropMapProbability + dropSuperSwordProbability + dropPotionProbability) {
                      println("pozione droppata");
                      // drop della pozione
                      //Potion dropPotion = new Potion("dropPotion", 30); // Assumendo che una pozione aggiunga 30 punti vita
                      //dropPotion.sprite = potion.sprite;
                      //dropPotion.spritePosition = dropPosition;
                      //currentLevel.dropItems.add(dropPotion);
                  }
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
                  
                  // drop casuale dell'item
                  // numero casuale
                  double randomValue = Math.random();
                  println("random value:" + randomValue);
                  
                  // probabilità che la cassa droppi qualcosa
                  double dropHeartProbability = 0.4;
                  double dropSwordProbability = 0.4;
                  double dropGoldenKeyProbability = 0.2;
                  
                  PVector dropPosition = chest.calculateDropPosition();
                  
                  if (randomValue <= dropHeartProbability) {
                      println("cuore droppato");
                      // drop del cuore 
                      Healer dropHeart = new Healer("dropHeart", 10);
                      dropHeart.sprite = heart_sprite;
                      dropHeart.spritePosition = dropPosition;
                      currentLevel.dropItems.add(dropHeart);
                  } else if (randomValue > dropHeartProbability && randomValue <= dropHeartProbability + dropSwordProbability) {
                      println("spada droppata");
                      // drop della spada
                      Weapon dropSword = new Weapon("dropSword", 20); // Assumendo che una spada valga 20 danni
                      dropSword.sprite = sword.sprite;
                      dropSword.spritePosition = dropPosition;
                      currentLevel.dropItems.add(dropSword);
                  } else if (randomValue > dropHeartProbability + dropSwordProbability && randomValue <= dropHeartProbability + dropSwordProbability + dropGoldenKeyProbability) {
                      println("chiave oro droppata");
                      // drop della chiave d'oro
                      Item dropGoldenKey = new Item("dropGoldenKey");
                      dropGoldenKey.sprite = golden_key.sprite;
                      dropGoldenKey.spritePosition = dropPosition;
                      dropGoldenKey.isCollectible = true;
                      currentLevel.dropItems.add(dropGoldenKey);
                  } //<>//
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
  
  PVector calculateDropPosition(Chest chest) {
    float dropRadius = 2;
    PVector dropPosition = chest.spritePosition.copy();
  
    for (int i = 0; i < 10; i++) {
      float xOffset = random(-dropRadius, dropRadius);
      float yOffset = random(-dropRadius, dropRadius);
  
      dropPosition.add(xOffset, yOffset);
  
      if (!isCollisionTile((int) dropPosition.x, (int) dropPosition.y)) {
        break;
      } else {
        dropPosition = chest.spritePosition.copy();
      }
    }
  
    return dropPosition;
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
            } else if(item instanceof Weapon) {
              // avviene lo scambio tra l'arma a terra e l'arma equippagiata
              // da sistemare
              //PVector tempPosition = item.spritePosition;
              //Weapon temp = p1.weapon;
              //p1.weapon = (Weapon) item;
              //item = temp;
              //item.spritePosition = tempPosition;
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
            }
          }
        }
      }
    }
  }
}
