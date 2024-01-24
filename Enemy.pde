class Enemy implements Damageable {
  PVector spritePosition;
  float spriteSpeed = 0.1;
  PImage sprite;

  ConcreteDamageHandler damageTileHandler;

  private static final long ATTACK_COOLDOWN = 2000; // Tempo di cooldown in millisecondi (3 secondi)
  private long lastAttackTime = 0;
  boolean first_attack;    // di base è true

  int enemyHP;
  int damage;
  String name;
  int scoreValue;

  Enemy(int enemyHP, String name, int damage, ConcreteDamageHandler damageTileHandler) {
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

      if (isValidMove(roundedX, roundedY)) {
        damageTileHandler.handleDamageTiles(this, roundedX, roundedY);

        // Aggiorna la posizione del nemico
        this.spritePosition.x = newX;
        this.spritePosition.y = newY;
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

      float newX = spritePosition.x + deltaX;
      float newY = spritePosition.y + deltaY;

      int roundedX = 0, roundedY = 0;


      // Verifica se la nuova posizione è valida
      roundedX = round(newX);
      roundedY = round(newY);

      if (isValidMove(roundedX, roundedY)) {
        damageTileHandler.handleDamageTiles(this, roundedX, roundedY);

        // Aggiorna la posizione del nemico in modo casuale
        this.spritePosition.x = newX;
        this.spritePosition.y = newY;
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
    float playerRight = spritePosition.x * currentLevel.tileSize + (sprite.width / 2);
    float playerLeft = spritePosition.x * currentLevel.tileSize - (sprite.width / 2);
    float playerBottom = spritePosition.y * currentLevel.tileSize + (sprite.height / 2);
    float playerTop = spritePosition.y * currentLevel.tileSize - (sprite.height / 2);

    float tileRight = roundedX * currentLevel.tileSize + (sprite.width / 2);
    float tileLeft = roundedX * currentLevel.tileSize - (sprite.width / 2);
    float tileBottom = roundedY * currentLevel.tileSize + (sprite.height / 2);
    float tileTop = roundedY * currentLevel.tileSize - (sprite.height / 2);

    return playerRight >= tileLeft && playerLeft <= tileRight &&
      playerBottom >= tileTop && playerTop <= tileBottom;
  }


  // attacca il giocatore
  // da migliorare
  //void handleAttack() {
  //  if (first_attack) {
  //    attack();
  //    first_attack = false;
  //  }
  //  periodicAttack();
  //}

  void attack(Player player) {
    // Esegui l'attacco
    player.playerHP -= damage;

    // fare in modo che rimanga un po piu di tempo a schermo
    TextDisplay damageHitText = new TextDisplay(p1.getPosition(), Integer.toString(damage), color(255, 0, 0), 2000);
    damageHitText.display();

    // playerHurt.play();

    if (p1.playerHP < 0) {
      p1.playerHP = 0;
    }
  }


  void periodicAttack() {
    long currentTime = System.currentTimeMillis();

    // Verifica se è passato abbastanza tempo dall'ultimo attacco
    if (currentTime - lastAttackTime >= ATTACK_COOLDOWN) {
      // Esegui l'attacco
      p1.playerHP -= damage;

      // fare in modo che rimanga un po piu di tempo a schermo
      TextDisplay damageHitText = new TextDisplay(p1.getPosition(), Integer.toString(damage), color(255, 0, 0), 2000);
      damageHitText.display();

      // playerHurt.play();

      if (p1.playerHP < 0) {
        p1.playerHP = 0;
      }

      // Aggiorna il tempo dell'ultimo attacco
      lastAttackTime = currentTime;
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

    PVector dropPosition = spritePosition.copy();

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

    spritesLayer.imageMode(CENTER); // Imposta l'imageMode a center
    spritesLayer.image(sprite, centerX, centerY, sprite.width, sprite.height);
  }
  
  // metodo per il rilevamento delle collisioni adattato alla rectmode CENTER
  boolean playerCollide(Player aPlayer) {
    //if (aPlayer.spritePosition.x * currentLevel.tileSize + (aPlayer.sprite.width / 2) >= (spritePosition.x * currentLevel.tileSize) - (sprite.width / 2)  &&      // x1 + w1/2 > x2 - w2/2
    //  (aPlayer.spritePosition.x * currentLevel.tileSize) - (aPlayer.sprite.width / 2) <= spritePosition.x * currentLevel.tileSize + (sprite.width / 2) &&                               // x1 - w1/2 < x2 + w2/2
    //  aPlayer.spritePosition.y * currentLevel.tileSize + (aPlayer.sprite.height / 2) >= (spritePosition.y * currentLevel.tileSize) - (sprite.height / 2) &&                                      // y1 + h1/2 > y2 - h2/2
    //  (aPlayer.spritePosition.y * currentLevel.tileSize) - (aPlayer.sprite.height / 2) <= spritePosition.y * currentLevel.tileSize + (sprite.height / 2)) {                              // y1 - h1/2 < y2 + h2/2
    //  return true;
    //}

    return false;
  }
}
