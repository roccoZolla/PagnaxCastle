public class Enemy {
  PVector spritePosition;
  float spriteSpeed = 0.1;
  PImage sprite;
  
  private static final long ATTACK_COOLDOWN = 3500; // Tempo di cooldown in millisecondi (3 secondi)
  private long lastAttackTime = 0;
  
  int enemyHP;
  int damage;
  Item dropItem;    // oggetto droppato dal nemico che puo essere un cuore, meta cuore o altro
  String name;
  int scoreValue;

  Enemy(int enemyHP, String name, int damage) {
    this.enemyHP = enemyHP;
    this.name = name;
    this.damage = damage;
    this.scoreValue = 20;
  }

  void display(PGraphics layer) {
    // hitbox nemico
    // layer.rectMode(CENTER);
    layer.noFill(); // Nessun riempimento
    layer.stroke(255, 0, 240); // Colore del bordo bianco
    layer.rect(spritePosition.x * currentLevel.tileSize, spritePosition.y * currentLevel.tileSize, sprite.width, sprite.height);
    
    layer.image(sprite, spritePosition.x * currentLevel.tileSize, spritePosition.y * currentLevel.tileSize, sprite.width, sprite.height);
  }
  
  void move() {
    // Ottieni la posizione del giocatore
    PVector playerPosition = p1.spritePosition;

    // distanza tra il nemico e il giocatore
    float distance = dist(this.spritePosition.x, this.spritePosition.y, playerPosition.x, playerPosition.y);

    // distanza minima 
    float threshold = 4;

    // Verifica se il giocatore è abbastanza vicino
    if (distance <= threshold) {
      // Calcola la direzione verso il giocatore
      PVector direction = PVector.sub(playerPosition, this.spritePosition);
      direction.normalize();

      // Calcola il movimento in base alla direzione
      float newX = this.spritePosition.x + direction.x * spriteSpeed;
      float newY = this.spritePosition.y + direction.y * spriteSpeed;
      
      int roundedX = 0, roundedY = 0;
      
      roundedX = round(newX);
      roundedY = round(newY);

      if (isValidMove(roundedX, roundedY)) {
        // Aggiorna la posizione del nemico
        this.spritePosition.x = newX;
        this.spritePosition.y = newY;
      }
    } else {
      // Il giocatore non è nelle vicinanze, quindi il nemico si muove casualmente
      float randomDirection = int(random(4)); // 0: su, 1: giù, 2: sinistra, 3: destra
      
      float newX = this.spritePosition.x;
      float newY = this.spritePosition.y;
      
      int roundedX = 0, roundedY = 0;

      if (randomDirection == 0) {
        newY -= spriteSpeed;
      } else if (randomDirection == 1) {
        newY += spriteSpeed;
      } else if (randomDirection == 2) {
        newX -= spriteSpeed;
      } else if (randomDirection == 3) {
        newX += spriteSpeed;
      }
      
      // Verifica se la nuova posizione è valida
      roundedX = round(newX);
      roundedY = round(newY);

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
        spritesLayer.textFont(myFont);
        spritesLayer.fill(255, 0, 0);
        spritesLayer.textSize(15);
        spritesLayer.text(damage, (p1.spritePosition.x * currentLevel.tileSize), (p1.spritePosition.y * currentLevel.tileSize) - 10);

        if(p1.playerHP < 0) {
          p1.playerHP = 0;
        }

        // Aggiorna il tempo dell'ultimo attacco
        lastAttackTime = currentTime;
    }
  }
  
  // verifica collisione
  // stesso metodo della chest 
  // si ferma ai bordi della hitbox
  boolean playerCollide(Player aPlayer) {
    if( aPlayer.spritePosition.x * currentLevel.tileSize <= (spritePosition.x * currentLevel.tileSize) + sprite.width  &&
        (aPlayer.spritePosition.x * currentLevel.tileSize) + aPlayer.sprite.width >= spritePosition.x * currentLevel.tileSize && 
        aPlayer.spritePosition.y * currentLevel.tileSize <= (spritePosition.y * currentLevel.tileSize) + sprite.height && 
        (aPlayer.spritePosition.y * currentLevel.tileSize) + aPlayer.sprite.height >= spritePosition.y * currentLevel.tileSize) {
            return true;
    }
    
    return false;
  }
}
