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
  void move() {
    // Genera una direzione casuale
    int randomDirection = int(random(4)); // 0: su, 1: giù, 2: sinistra, 3: destra

    // Imposta la velocità del movimento
    float speed = 1.0;

    // Aggiorna la posizione del nemico in base alla direzione casuale
    if (randomDirection == 0) {
      this.spritePosition.y -= speed;
    } else if (randomDirection == 1) {
      this.spritePosition.y += speed;
    } else if (randomDirection == 2) {
      this.spritePosition.x -= speed;
    } else if (randomDirection == 3) {
      this.spritePosition.x += speed;
    }
  }
}
