class Player extends Sprite implements Damageable { //<>//
  float spriteSpeed = 0.2;

  // movements
  boolean moveUP;
  boolean moveDOWN;
  boolean moveRIGHT;
  boolean moveLEFT;

  int direction;

  final int DIRECTION_LEFT = 0;
  final int DIRECTION_RIGHT = 1;

  boolean moveATCK;    // attacco j
  boolean moveINTR;    // interazione k
  boolean moveUSE;     // utilizza l

  boolean isMoving = false;
  boolean isUsingPotion = false;
  boolean isAttacking = false;
  boolean attackExecuted = false;
  boolean isInteracting = false;

  ConcreteDamageHandler damageTileHandler;

  // caratteristiche del player
  int playerMaxHP;
  int playerHP;
  int playerScore;
  int coins;      // numero di monete che ha il giocatore
  Weapon weapon;
  Healer redPotion;  // restituisce due - tre cuori
  Item golden_keys;
  Item silver_keys;
  int numberOfSilverKeys;
  int numberOfGoldenKeys;
  int numberOfPotion;

  Player(PVector position, PImage sprite, int playerHP, int maxHP, int numberOfSilverKeys, int numberOfGoldenKeys, int numberOfPotion, ConcreteDamageHandler damageTileHandler) {
    super(position, sprite);

    this.playerScore = 0;
    this.playerHP = playerHP;
    this.playerMaxHP = maxHP;
    this.coins = 0;
    this.numberOfSilverKeys = numberOfSilverKeys;
    this.numberOfGoldenKeys = numberOfGoldenKeys;
    this.numberOfPotion = numberOfPotion;

    this.damageTileHandler = damageTileHandler;

    this.moveUP = false;
    this.moveDOWN = false;
    this.moveRIGHT = false;
    this.moveLEFT = false;
  }

  void collectCoin() {
    this.coins++;
  }

  void takeGoldenKey() {
    this.numberOfGoldenKeys++;
  }

  void takeSilverKey() {
    this.numberOfSilverKeys++;
  }

  void updateScore(int score) {
    this.playerScore += score;
  }

  // aggiorna la vita del giocatore e
  // riproduci suono
  void takeHP(int HP) {
    drinkPotion.play();
    playerHP += HP;

    if (playerHP > playerMaxHP) playerHP = playerMaxHP;
  }

  // override dei metodi dell'interfaccia
  @Override
    public void takeDamage(int damage) {
    playerHP -= damage;

    TextDisplay damageHitText = new TextDisplay(position, Integer.toString(damage), color(255, 0, 0));
    damageHitText.display(game.spritesLayer);

    hurt_sound.play();

    if (playerHP < 0) {
      playerHP = 0;
    }
  }

  // aggiorna movimento del giocatore
  void update() {
    float x = position.x;
    float y = position.y;

    // cella superiore al giocatore
    if (moveUP && isWithinMapBounds(round(x), round(y - 1)) && !check_collision_wall(round(x), round(y - 1))) {      // y - 1
      y += -1 * spriteSpeed;
    }

    // cella inferiore al giocatore
    if (moveDOWN && isWithinMapBounds(round(x), round(y + 1)) && !check_collision_wall(round(x), round(y + 1))) {    // y + 1
      y += 1 * spriteSpeed;
    }

    // cella a sinistra del giocatore
    if (moveLEFT && isWithinMapBounds(round(x - 1), round(y)) && !check_collision_wall(round(x - 1), round(y))) {   // x - 1
      x += -1 * spriteSpeed;
      direction = DIRECTION_LEFT;
      sprite = spriteLeft;
    }

    // cella a destra del giocatore
    if (moveRIGHT && isWithinMapBounds(round(x + 1), round(y)) && !check_collision_wall(round(x + 1), round(y))) {  // x + 1
      x += 1 * spriteSpeed;
      direction = DIRECTION_RIGHT;
      sprite = spriteRight;
    }

    updatePosition(new PVector(x, y));
    damageTileHandler.handleDamageTiles(this, round(x), round(y));
  }

  boolean check_collision_wall(int x, int y) {
    // se è un muro controlla la possibile collisione con lo sprite
    if (isWall(x, y)) {
      println("è un muro...");
      game.spritesLayer.noFill(); // Nessun riempimento
      game.spritesLayer.stroke(255); // Colore del bordo bianco
      game.spritesLayer.rectMode(CENTER);
      game.spritesLayer.rect(x * currentLevel.tileSize + (sprite.width/2), y * currentLevel.tileSize + (sprite.height / 2), sprite.width, sprite.height);

      game.spritesLayer.stroke(255, 0, 0);
      game.spritesLayer.point(x * currentLevel.tileSize, y * currentLevel.tileSize);

      if (position.x * currentLevel.tileSize + (sprite.width / 2) >= (x * currentLevel.tileSize) - (sprite.width / 2)  &&      // x1 + w1/2 > x2 - w2/2
        (position.x * currentLevel.tileSize) - (sprite.width / 2) <= x * currentLevel.tileSize + (sprite.width / 2) &&                               // x1 - w1/2 < x2 + w2/2
        position.y * currentLevel.tileSize + (sprite.height / 2) >= (y * currentLevel.tileSize) - (sprite.height / 2) &&                                      // y1 + h1/2 > y2 - h2/2
        (position.y * currentLevel.tileSize) - (sprite.height / 2) <= y * currentLevel.tileSize + (sprite.height / 2)) {
        println("collisione rilevata...");
        return true;
      }
    }

    return false;
  }

  // da fixare
  void attack(PGraphics layer) {
    if (moveATCK && (!moveUSE && !moveINTR)) {
      // println("sta attaccando...");
      isAttacking = true;
      // se sta attaccando e l'attacco non è stato eseguito
      if (isAttacking && !attackExecuted) {
        // offset
        PVector new_position = position.copy();

        if (direction == DIRECTION_RIGHT)
          new_position.x += 1;
        else if (direction == DIRECTION_LEFT)
          new_position.x -= 1;

        weapon.updatePosition(new_position);
        weapon.display(layer);

        if (game.isBossLevel) {
          if (weapon.sprite_collision(game.boss)) {
            swordAttack.play();
            game.boss.takeDamage(weapon.getDamage());
            // l'attacco è stato eseguito non continuare ad attaccare
            // println("attacco eseguito...");
            attackExecuted = true;
          }
        } else {
          for (Enemy enemy : currentLevel.enemies) {
            if (weapon.sprite_collision(enemy)) {
              swordAttack.play();
              enemy.takeDamage(weapon.getDamage());
              // l'attacco è stato eseguito non continuare ad attaccare
              // println("attacco eseguito...");
              attackExecuted = true;
            }
          }
        }
      }
    } else {
      // println("non sta piu attaccando...");
      isAttacking = false;
      attackExecuted = false;
    }
  }

  void usePotion(PGraphics layer) {
    if (moveUSE && (!moveATCK && !moveINTR)) {
      if (!isUsingPotion) {
        isUsingPotion = true;

        // se il numero delle pozioni è maggiore di 0
        if (numberOfPotion > 0) {
          // se vita minore della vita massima
          if (playerHP < playerMaxHP) {
            takeHP(redPotion.getBonusHp());

            // dimunuisci numero di pozioni del giocatore
            numberOfPotion -= 1;
          } else {
            // stampa massaggio di salute al massimo
            PVector text_position = p1.getPosition();
            TextDisplay healthFull = new TextDisplay(text_position, "Salute al massimo", color(255));
            healthFull.display(layer);
          }
        } else {
          // stampa x per indicare che non hai piu pozioni
          float crossImageX = (getPosition().x * currentLevel.tileSize + (sprite.width / 2));
          float crossImageY = (getPosition().y * currentLevel.tileSize + (sprite.height / 2)) - 20; // Regola l'offset verticale a tuo piacimento
          layer.imageMode(CENTER);
          layer.image(cross_sprite, crossImageX, crossImageY);
        }
      }
    } else {
      // resetta la variabile
      isUsingPotion = false;
    }
  }

  @Override
    PVector getPosition() {
    return position;
  }
}
