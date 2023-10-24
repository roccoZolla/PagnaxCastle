public class Enemy extends Sprite {
  private int enemyHP;
  private String name;

  Enemy(int id, int enemyHP, String name, String dataPath) {
    this.id = id;
    this.enemyHP = enemyHP;
    this.name = name;
    this.img = loadImage(dataPath);
  }

  int getEnemyHP() {
    return enemyHP;
  }

  String getName() {
    return name;
  }

  void setEnemyHP(int enemyHP) {
    this.enemyHP = enemyHP;
  }

  void setName(String name) {
    this.name = name;
  }

  void displayEnemy(int tileSize) {
    display(tileSize);
  }

  // metodo che valuta se attaccare il player
  //void update(Player player) {
  //  // Calcola la distanza tra il nemico e il giocatore
  //  float distance = dist(this.x, this.y, player.x, player.y);

  //  // Se il giocatore è abbastanza vicino, attacca
  //  //  if (distance < raggio_dazione) {
  //  //  attacca(player);
  //  //}
  //}

  // muove in maniera randomica i nemici all'interno della mappa
  //void move(Level currentLevel) {
  //  println("Prima:");
  //  println("Nemico: " + this.id);
  //  println("posizione: " + this.spritePosition);
  //  // Genera una direzione casuale
  //  int randomDirection = int(random(4)); // 0: su, 1: giù, 2: sinistra, 3: destra
  //  println("direzione: " + randomDirection);

  //  // Imposta la velocità del movimento
  //  float speed = 1.0; // Ogni passo è di una cella

  //  // Calcola il movimento in base alla direzione casuale
  //  float newX = this.spritePosition.x;
  //  float newY = this.spritePosition.y;

  //  if (randomDirection == 0) {
  //    newY = -speed; // Sposta il nemico di una cella verso l'alto
  //  } else if (randomDirection == 1) {
  //    newY = +speed; // Sposta il nemico di una cella verso il basso
  //  } else if (randomDirection == 2) {
  //    newX = -speed; // Sposta il nemico di una cella a sinistra
  //  } else if (randomDirection == 3) {
  //    newX = +speed; // Sposta il nemico di una cella a destra
  //  }

  //  println("Checkmove_: " + checkEnemyMove(newX, newY, currentLevel));

  //  if (checkEnemyMove(newX, newY, currentLevel)) {
  //    // Aggiorna la posizione del nemico in base alla direzione casuale
  //    this.spritePosition.x = newX;
  //    this.spritePosition.y = newY;
  //  }

  //  println("Dopo");
  //  println("Nemico: " + this.id);
  //  println("posizione: " + this.spritePosition);
  //}

  void move(Level currentLevel) {
    // Ottieni la posizione del giocatore
    PVector playerPosition = p1.getPosition();

    // Calcola la distanza tra il nemico e il giocatore
    float distance = dist(this.spritePosition.x, this.spritePosition.y, playerPosition.x, playerPosition.y);

    // Imposta la soglia (ad esempio, 3 celle di distanza)
    float threshold = 4;

    // Verifica se il giocatore è abbastanza vicino
    if (distance <= threshold) {
      // Calcola la direzione verso il giocatore
      PVector direction = PVector.sub(playerPosition, this.spritePosition);
      direction.normalize();

      // Imposta la velocità del movimento
      float speed = 0.1; // Ogni passo è di una cella

      // Calcola il movimento in base alla direzione
      float newX = this.spritePosition.x + direction.x * speed;
      float newY = this.spritePosition.y + direction.y * speed;

      if (checkEnemyMove(newX, newY, currentLevel)) {
        // Aggiorna la posizione del nemico
        this.spritePosition.x = newX;
        this.spritePosition.y = newY;
      }
    } else {
      // Il giocatore non è nelle vicinanze, quindi il nemico si muove casualmente
      float randomDirection = int(random(4)); // 0: su, 1: giù, 2: sinistra, 3: destra

      float speed = 0.1; // Ogni passo è di una cella

      float newX = this.spritePosition.x;
      float newY = this.spritePosition.y;

      if (randomDirection == 0) {
        newY -= speed;
      } else if (randomDirection == 1) {
        newY += speed;
      } else if (randomDirection == 2) {
        newX -= speed;
      } else if (randomDirection == 3) {
        newX += speed;
      }

      if(checkEnemyMove(newX, newY, currentLevel)) {
        // Aggiorna la posizione del nemico in modo casuale
        this.spritePosition.x = newX;
        this.spritePosition.y = newY;
      }
    }
  }
}
