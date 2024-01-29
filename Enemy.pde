class Enemy extends Sprite implements Damageable {
  float spriteSpeed = 0.1;

  ConcreteDamageHandler damageTileHandler;

  private final int attack_interval = 60; // Tempo di cooldown in millisecondi (3 secondi)
  private long attack_timer = attack_interval;
  boolean first_attack;    // di base è true

  int enemyHP;
  int damage;
  String name;
  int scoreValue;

  Enemy(PVector position, PImage sprite, int enemyHP, String name, int damage, ConcreteDamageHandler damageTileHandler) {
    super(position, sprite);
    this.enemyHP = enemyHP;
    this.name = name;
    this.damage = damage;
    this.scoreValue = 20;

    first_attack = true;

    this.damageTileHandler = damageTileHandler;
  }

  // gestisce il movimento del nemico
  void update() {
    // Ottieni la posizione del giocatore
    PVector playerPosition = p1.getPosition();

    // distanza tra il nemico e il giocatore
    float distance = dist(position.x, position.y, playerPosition.x, playerPosition.y);

    // distanza minima
    float threshold = 4;

    // Verifica se il giocatore è abbastanza vicino
    if (distance <= threshold) {
      // Calcola la direzione verso il giocatore
      PVector direction = PVector.sub(playerPosition, position);
      direction.normalize();

      // Calcola il movimento in base alla direzione
      float newX = position.x + direction.x * spriteSpeed;
      float newY = position.y + direction.y * spriteSpeed;

      int roundedX = 0, roundedY = 0;

      roundedX = round(newX);
      roundedY = round(newY);

      if (isValidMove(roundedX, roundedY) && !sprite_collision(p1)) {
        damageTileHandler.handleDamageTiles(this, roundedX, roundedY);

        // Aggiorna la posizione del nemico
        this.position.x = newX;
        this.position.y = newY;
      }
    } else {
      // Calcolo delle nuove coordinate
      float newDirection = random(4);
      float moveDistance = spriteSpeed;

      float deltaX = 0;
      float deltaY = 0;

      if (newDirection < 1) {
        deltaX = moveDistance;
      } else if (newDirection < 2) {
        deltaX = -moveDistance;
      } else if (newDirection < 3) {
        deltaY = moveDistance;
      } else {
        deltaY = -moveDistance;
      }

      float newX = position.x + deltaX;
      float newY = position.y + deltaY;

      int roundedX = 0, roundedY = 0;


      // Verifica se la nuova posizione è valida
      roundedX = round(newX);
      roundedY = round(newY);

      if (isValidMove(roundedX, roundedY)) {
        damageTileHandler.handleDamageTiles(this, roundedX, roundedY);

        // Aggiorna la posizione del nemico in modo casuale
        this.position.x = newX;
        this.position.y = newY;
      }
    }
  }

  // collision detection
  boolean isValidMove(int roundedX, int roundedY) {
    if (!isWithinMapBounds(roundedX, roundedY)) {
      return false;
    }

    if (isCollisionTile(roundedX, roundedY) && isCollidingWithTile(roundedX, roundedY)) {
      return false;
    }

    return true;
  }

  boolean isCollidingWithTile(int roundedX, int roundedY) {
    float playerRight = position.x * currentLevel.tileSize + (sprite.width / 2);
    float playerLeft = position.x * currentLevel.tileSize - (sprite.width / 2);
    float playerBottom = position.y * currentLevel.tileSize + (sprite.height / 2);
    float playerTop = position.y * currentLevel.tileSize - (sprite.height / 2);

    float tileRight = roundedX * currentLevel.tileSize + (sprite.width / 2);
    float tileLeft = roundedX * currentLevel.tileSize - (sprite.width / 2);
    float tileBottom = roundedY * currentLevel.tileSize + (sprite.height / 2);
    float tileTop = roundedY * currentLevel.tileSize - (sprite.height / 2);

    return playerRight >= tileLeft && playerLeft <= tileRight &&
      playerBottom >= tileTop && playerTop <= tileBottom;
  }


  // attacca il giocatore
  void attack(Player player) {
    if (first_attack) {
      // Esegui l'attacco
      player.takeDamage(damage);

      // fare in modo che rimanga un po piu di tempo a schermo
      TextDisplay damageHitText = new TextDisplay(p1.getPosition(), Integer.toString(damage), color(255, 0, 0));
      damageHitText.display(game.spritesLayer);

      first_attack = false;
    } else {
      // parte l'attacco periodico
      attack_timer--;

      if (attack_timer <= 0) {
        // Esegui l'attacco periodico
        player.takeDamage(damage);

        // Reimposta il timer per il prossimo attacco
        attack_timer = attack_interval;
      }
    }
  }

  void death() {
    enemy_death_sound.play();
    dropItem();
  }

  private void dropItem() {
    // numero casuale
    double randomValue = Math.random();

    // dropRate degli oggetti droppati dai nemici
    double dropNothingProbability = 0.3;        // 30 %
    double dropSilverKeyProbability = 0.1;      // 10 %
    double dropHeartProbability = 0.3;          // 30 %
    double dropHalfHeartProbability = 0.3;      // 30 %

    PVector dropPosition = position.copy();

    if (randomValue <= dropNothingProbability) {
      // Nessun drop
    } else if (randomValue <= dropNothingProbability + dropSilverKeyProbability) {
      // drop della chiave d'argento
      Item dropSilverKey = new Item(dropPosition, silver_key.sprite, "dropSilverKey");
      dropSilverKey.isCollectible = true;
      currentLevel.dropItems.add(dropSilverKey);
    } else if (randomValue <= dropNothingProbability + dropSilverKeyProbability + dropHeartProbability) {
      // drop del cuore intero
      Healer dropHeart = new Healer(dropPosition, heart_sprite, "dropHeart", 10);
      currentLevel.dropItems.add(dropHeart);
    } else if (randomValue <= dropNothingProbability + dropSilverKeyProbability + dropHeartProbability + dropHalfHeartProbability) {
      // drop del mezzocuore
      Healer dropHalfHeart = new Healer(dropPosition, half_heart_sprite, "dropHalfHeart", 5);
      currentLevel.dropItems.add(dropHalfHeart);
    }
  }


  // override dei metodi dell'interfaccia
  @Override
    public void takeDamage(int damage) {
    enemyHP -= damage;

    // testo danno subito dal nemico
    TextDisplay damageHitText = new TextDisplay(position, Integer.toString(damage), color(255, 0, 0));
    damageHitText.display(game.spritesLayer);

    if (enemyHP < 0) {
      enemyHP = 0;
    }
  }

  @Override
    PVector getPosition() {
    return position;
  }
}
