class Enemy implements Damageable{
  PVector spritePosition;
  float spriteSpeed = 0.1;
  PImage sprite;
  
  DamageHandler damageTileHandler;
  
  private static final long ATTACK_COOLDOWN = 3000; // Tempo di cooldown in millisecondi (3 secondi)
  private long lastAttackTime = 0;
  
  int enemyHP;
  int damage;
  String name;
  int scoreValue;

  Enemy(int enemyHP, String name, int damage, DamageHandler damageTileHandler) {
    this.enemyHP = enemyHP;
    this.name = name;
    this.damage = damage;
    this.scoreValue = 20;
    
    this.damageTileHandler = damageTileHandler;
  }
  
  void move() {
    // Ottieni la posizione del giocatore
    PVector playerPosition = p1.spritePosition;

    // distanza tra il nemico e il giocatore
    float distance = dist(spritePosition.x, spritePosition.y, playerPosition.x, playerPosition.y);

    // distanza minima 
    float threshold = 4;

    // Verifica se il giocatore è abbastanza vicino
    if (distance <= threshold) {
      // Calcola la direzione verso il giocatore
      PVector direction = PVector.sub(playerPosition, spritePosition);
      direction.normalize();

      // Calcola il movimento in base alla direzione
      float newX = spritePosition.x + direction.x * spriteSpeed;
      float newY = spritePosition.y + direction.y * spriteSpeed;
      
      int roundedX = 0, roundedY = 0;
      
      roundedX = round(newX);
      roundedY = round(newY);
      
      damageTileHandler.handleDamageTiles(this, roundedX, roundedY);

      if (isValidMove(roundedX, roundedY)) {
        // Aggiorna la posizione del nemico
        this.spritePosition.x = newX;
        this.spritePosition.y = newY;
      }
    } else {
      //  il giocatore non è nelle vicinanze, quindi il nemico si muove casualmente
      float randomDirection = random(1);
      
      float newX = spritePosition.x;
      float newY = spritePosition.y;
      
      int roundedX = 0, roundedY = 0;

      if (randomDirection < 0.25) {
        newX += spriteSpeed;
      } else if (randomDirection < 0.5) {
        newX -= spriteSpeed;
      } else if (randomDirection < 0.75) {
        newY += spriteSpeed;
      } else {
        newY -= spriteSpeed;
      }
      
      // Verifica se la nuova posizione è valida
      roundedX = round(newX);
      roundedY = round(newY);
      
      damageTileHandler.handleDamageTiles(this, roundedX, roundedY);

      if(isValidMove(roundedX, roundedY)) {
        // Aggiorna la posizione del nemico in modo casuale
        this.spritePosition.x = newX;
        this.spritePosition.y = newY;
      }
    }
  }
  
  //boolean isValidMove(int roundedX, int roundedY) {
  //  if(!isWithinMapBounds(roundedX, roundedY) && isCollisionTile(roundedX, roundedY)) {
  //    return false;
  //  }
    
  //  // verifica che due nemici non si sovrappongano
  //  for (Enemy otherEnemy : currentLevel.enemies) {
  //    if (otherEnemy != this) {
  //      if (roundedX < otherEnemy.spritePosition.x + otherEnemy.sprite.width &&
  //          roundedX + sprite.width > otherEnemy.spritePosition.x &&
  //          roundedY < otherEnemy.spritePosition.y + otherEnemy.sprite.height &&
  //          roundedY + sprite.height > otherEnemy.spritePosition.y) {
  //        return false; // Sovrapposizione con un altro nemico
  //      }
  //    }
  //  }
    
  //  return true;
  //}
  
  boolean isValidMove(int roundedX, int roundedY) {
    // il player si trova all'interno della mappa di gioco
    if(isWithinMapBounds(roundedX, roundedY)) {
      // il player si scontra con un tile di collisione
      if(isCollisionTile(roundedX, roundedY)) {
        if(spritePosition.x * currentLevel.tileSize <= (roundedX * currentLevel.tileSize) + currentLevel.tileSize ||
           (spritePosition.x * currentLevel.tileSize) + sprite.width<= roundedX * currentLevel.tileSize ||
           spritePosition.y * currentLevel.tileSize >= (roundedY * currentLevel.tileSize) + currentLevel.tileSize ||
           (spritePosition.y * currentLevel.tileSize) + sprite.height >= roundedY * currentLevel.tileSize) {
           // ritorna falso se il player cerca di attraversa il tile 
           return false;
        }
      }
      // ritorna vero se il player si trova all'interno della mappa e non si sta scontrando con un tile di collisione
      return true;
    }
    
    // falso altrimenti
    return false;
  }
  
  // attacca il giocatore
  // da migliorare
  void attack() {
    // println("attacco subito");
    long currentTime = System.currentTimeMillis();

      // Verifica se è passato abbastanza tempo dall'ultimo attacco
    if (currentTime - lastAttackTime >= ATTACK_COOLDOWN) {
        // Esegui l'attacco
        p1.playerHP -= damage;
        
        // fare in modo che rimanga un po piu di tempo a schermo
        TextDisplay damageHitText = new TextDisplay(p1.spritePosition, Integer.toString(damage), color(255, 0, 0), 2000);
        damageHitText.display();
        
        // playerHurt.play();

        if(p1.playerHP < 0) {
          p1.playerHP = 0;
        }

        // Aggiorna il tempo dell'ultimo attacco
        lastAttackTime = currentTime;
    }
  }
  
  // override dei metodi dell'interfaccia
  @Override
  public void receiveDamage(int damage) {
    enemyHP -= damage;
    if (enemyHP < 0) {
      enemyHP = 0;
    }
  }
  
  @Override
  PVector getPosition() {
    return spritePosition;
  }
  
  void display() {
    // hitbox giocatore
    spritesLayer.noFill(); // Nessun riempimento
    spritesLayer.stroke(255, 23, 23);
    
    float centerX = spritePosition.x * currentLevel.tileSize + sprite.width / 2;
    float centerY = spritePosition.y * currentLevel.tileSize + sprite.height / 2;
    
    // hitbox
    //layer.rectMode(CENTER); // Imposta il rectMode a center
    //layer.rect(centerX, centerY, sprite.width, sprite.height);
    
    //layer.stroke(60);
    //layer.point(centerX, centerY);
    
    spritesLayer.imageMode(CENTER); // Imposta l'imageMode a center
    spritesLayer.image(sprite, centerX, centerY, sprite.width, sprite.height);
    
    // layer.image(sprite, spritePosition.x * currentLevel.tileSize, spritePosition.y * currentLevel.tileSize, sprite.width, sprite.height);
  }
  
  // metodo per il rilevamento delle collisioni adattato alla rectmode CENTER
  boolean playerCollide(Player aPlayer) { 
    if(aPlayer.spritePosition.x * currentLevel.tileSize + (aPlayer.sprite.width / 2) >= (spritePosition.x * currentLevel.tileSize) - (sprite.width / 2)  &&      // x1 + w1/2 > x2 - w2/2
        (aPlayer.spritePosition.x * currentLevel.tileSize) - (aPlayer.sprite.width / 2) <= spritePosition.x * currentLevel.tileSize + (sprite.width / 2) &&                               // x1 - w1/2 < x2 + w2/2
        aPlayer.spritePosition.y * currentLevel.tileSize + (aPlayer.sprite.height / 2) >= (spritePosition.y * currentLevel.tileSize) - (sprite.height / 2) &&                                      // y1 + h1/2 > y2 - h2/2
        (aPlayer.spritePosition.y * currentLevel.tileSize) - (aPlayer.sprite.height / 2) <= spritePosition.y * currentLevel.tileSize + (sprite.height / 2)) {                              // y1 - h1/2 < y2 + h2/2
          return true;
    }
    
    return false;
  }
}
