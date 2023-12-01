public class Enemy {
  PVector spritePosition;
  float spriteSpeed = 0.1;
  PImage sprite;
  
  private static final long ATTACK_COOLDOWN = 3000; // Tempo di cooldown in millisecondi (3 secondi)
  private long lastAttackTime = 0;
  
  int enemyHP;
  int damage;
  Item dropItem;    // oggetto droppato dal nemico che puo essere un cuore, meta cuore o altro
  String name;

  Enemy(int enemyHP, String name, int damage) {
    this.enemyHP = enemyHP;
    this.name = name;
    this.damage = damage;
  }

  void display(PGraphics layer) {
    // hitbox nemico
    layer.noFill(); // Nessun riempimento
    layer.stroke(255, 0, 240); // Colore del bordo bianco
    layer.rect(spritePosition.x * currentLevel.tileSize, spritePosition.y * currentLevel.tileSize, sprite.width, sprite.height);
    
    layer.image(sprite, spritePosition.x * currentLevel.tileSize, spritePosition.y * currentLevel.tileSize, sprite.width, sprite.height);
  }
  
  void move(Level currentLevel) {
    // Ottieni la posizione del giocatore
    PVector playerPosition = p1.spritePosition;

    // Calcola la distanza tra il nemico e il giocatore
    float distance = dist(this.spritePosition.x, this.spritePosition.y, playerPosition.x, playerPosition.y);

    // Imposta la soglia (ad esempio, 3 celle di distanza)
    float threshold = 4;

    // Verifica se il giocatore è abbastanza vicino
    if (distance <= threshold) {
      // Calcola la direzione verso il giocatore
      PVector direction = PVector.sub(playerPosition, this.spritePosition);
      direction.normalize();

      // Calcola il movimento in base alla direzione
      float newX = this.spritePosition.x + direction.x * spriteSpeed;
      float newY = this.spritePosition.y + direction.y * spriteSpeed;

      if (checkEnemyMove(newX, newY, currentLevel)) {
        // Aggiorna la posizione del nemico
        this.spritePosition.x = newX;
        this.spritePosition.y = newY;
      }
    } else {
      // Il giocatore non è nelle vicinanze, quindi il nemico si muove casualmente
      float randomDirection = int(random(4)); // 0: su, 1: giù, 2: sinistra, 3: destra
      
      float newX = this.spritePosition.x;
      float newY = this.spritePosition.y;

      if (randomDirection == 0) {
        newY -= spriteSpeed;
      } else if (randomDirection == 1) {
        newY += spriteSpeed;
      } else if (randomDirection == 2) {
        newX -= spriteSpeed;
      } else if (randomDirection == 3) {
        newX += spriteSpeed;
      }

      if(checkEnemyMove(newX, newY, currentLevel)) {
        // Aggiorna la posizione del nemico in modo casuale
        this.spritePosition.x = newX;
        this.spritePosition.y = newY;
      }
    }
  }
  
  boolean checkEnemyMove(float newX, float newY, Level currentLevel) {
    // Verifica se la nuova posizione è valida
    PVector playerPosition = p1.spritePosition;
    int roundedX = round(newX);
    int roundedY = round(newY);
  
    if (roundedX == round(playerPosition.x) && roundedY == round(playerPosition.y)) {
      return false; // Il nemico non può andare nella stessa posizione del giocatore
    }
  
    if (roundedX >= 0 && roundedX < currentLevel.cols && roundedY >= 0 && roundedY < currentLevel.rows &&
      currentLevel.map[roundedX][roundedY] != 0 &&
      currentLevel.map[roundedX][roundedY] != 4 &&
      currentLevel.map[roundedX][roundedY] != 6 &&
      currentLevel.map[roundedX][roundedY] != 3) {
      return true;
    }
  
    return false;
  }
  
  // attacca il giocatore
  // da migliorare
  void attack() {
    println("attacco subito");
    long currentTime = System.currentTimeMillis();

        // Verifica se è passato abbastanza tempo dall'ultimo attacco
      if (currentTime - lastAttackTime >= ATTACK_COOLDOWN) {
          // Esegui l'attacco
            p1.playerHP -= damage;
  
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
            spritesLayer.textFont(myFont);
            spritesLayer.fill(255);
            spritesLayer.textSize(15);
            spritesLayer.text("rat", (spritePosition.x * currentLevel.tileSize) - 50, (spritePosition.y * currentLevel.tileSize) - 10);
            
            return true;
    }
    
    return false;
  }
}
