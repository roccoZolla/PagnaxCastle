public class Enemy {
  PVector spritePosition;
  float spriteSpeed = 0.1;
  PImage sprite;
  
  int enemyHP;
  String name;

  Enemy(int enemyHP, String name) {
    this.enemyHP = enemyHP;
    this.name = name;
  }

  void display(PGraphics layer) {
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
}
