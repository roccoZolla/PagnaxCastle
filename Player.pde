class Player extends Sprite implements Damageable { //<>//
  // PVector spritePosition;
  float spriteSpeed = 0.2;
  // PImage sprite;

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

  public void collectCoin() {
    this.coins++;
  }

  void updateScore(int score) {
    this.playerScore += score;
  }

  // override dei metodi dell'interfaccia
  @Override
    public void takeDamage(int damage) {
    playerHP -= damage;

    TextDisplay damageHitText = new TextDisplay(position, Integer.toString(damage), color(255, 0, 0));
    damageHitText.display();

    hurt_sound.play();

    if (playerHP < 0) {
      playerHP = 0;
    }
  }

  // movimento del giocatore
  void update() {
    float newX = position.x;
    float newY = position.y;

    int roundedX = 0, roundedY = 0;

    if (moveUP) {
      newY -= spriteSpeed;
    }
    if (moveDOWN) {
      newY += spriteSpeed;
    }
    if (moveLEFT) {
      p1.sprite = spriteLeft;
      newX -= spriteSpeed;
      direction = DIRECTION_LEFT;
    }
    if (moveRIGHT) {
      p1.sprite = spriteRight;
      newX += spriteSpeed;
      direction = DIRECTION_RIGHT;
    }

    // Verifica se la nuova posizione è valida
    roundedX = round(newX);
    roundedY = round(newY);

    if (isValidMove(roundedX, roundedY)) {
      damageTileHandler.handleDamageTiles(this, roundedX, roundedY);

      updatePosition(new PVector(newX, newY));
    }
  }

  // da fixare
  void attack() {
    if (moveATCK && !moveUSE && !moveINTR) {
      if (!isAttacking) {
        isAttacking = true;
        // offset
        PVector new_position = position.copy();

        if (direction == DIRECTION_RIGHT)
          new_position.x += 1;
        else if (direction == DIRECTION_LEFT)
          new_position.x -= 1;

        weapon.updatePosition(new_position);
        weapon.display(spritesLayer);

        if (game.isBossLevel) {
          println("attack in the boss level...");
          if (weapon.sprite_collision(game.boss)) {
            swordAttack.play();
            game.boss.takeDamage(weapon.getDamage());
            // l'attacco è stato eseguito non continuare ad attaccare
          }
        } else {
          for (Enemy enemy : currentLevel.enemies) {
            if (weapon.sprite_collision(enemy)) {
              swordAttack.play();
              enemy.takeDamage(weapon.getDamage());
            }
          }
        }
      }
    } else {
      isAttacking = false;
    }
  }

  void usePotion() {
    if (p1.moveUSE && (!p1.moveATCK && !p1.moveINTR)) {
      if (!isUsingPotion) {
        isUsingPotion = true;

        // se il numero delle pozioni è maggiore di 0
        if (p1.numberOfPotion > 0) {
          // se vita minore della vita massima
          if (p1.playerHP < p1.playerMaxHP) {
            drinkPotion.play();
            p1.playerHP += p1.redPotion.getBonusHp();

            if (p1.playerHP > p1.playerMaxHP) p1.playerHP = p1.playerMaxHP;

            // dimunuisci numero di pozioni del giocatore
            p1.numberOfPotion -= 1;
          } else {
            // stampa massaggio di salute al massimo
            PVector text_position = p1.getPosition();
            TextDisplay healthFull = new TextDisplay(text_position, "Salute al massimo", color(255));
            healthFull.display();
          }
        } else {
          // stampa x per indicare che non hai piu pozioni
          float crossImageX = (p1.getPosition().x * currentLevel.tileSize + (p1.sprite.width / 2));
          float crossImageY = (p1.getPosition().y * currentLevel.tileSize + (p1.sprite.height / 2)) - 20; // Regola l'offset verticale a tuo piacimento
          spritesLayer.imageMode(CENTER);
          spritesLayer.image(cross_sprite, crossImageX, crossImageY);
        }
      }
    } else {
      // resetta la variabile
      isUsingPotion = false;
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

    float tileRight = roundedX * currentLevel.tileSize + (currentLevel.tileSize / 2);
    float tileLeft = roundedX * currentLevel.tileSize - (currentLevel.tileSize / 2);
    float tileBottom = roundedY * currentLevel.tileSize + (currentLevel.tileSize / 2);
    float tileTop = roundedY * currentLevel.tileSize - (currentLevel.tileSize / 2);

    // Verifica delle collisioni
    boolean collisionX = playerRight >= tileLeft && playerLeft <= tileRight;
    boolean collisionY = playerBottom >= tileTop && playerTop <= tileBottom;

    return collisionX && collisionY;
  }

  @Override
    PVector getPosition() {
    return position;
  }

  // metodo che si occupa di disegnare l'arma del giocatore
  void displayWeapon() {
    // offset
    float offset = 16;

    if (direction == DIRECTION_RIGHT)
      offset = 16;
    else if (direction == DIRECTION_LEFT)
      offset = -16;

    float centerX = position.x * currentLevel.tileSize + sprite.width / 2;
    float centerY = position.y * currentLevel.tileSize + sprite.height / 2;

    // hitbox arma
    spritesLayer.rectMode(CENTER);
    spritesLayer.noFill(); // Nessun riempimento
    spritesLayer.stroke(255, 146, 240); // Colore del bordo bianco
    spritesLayer.rect(centerX + offset, centerY, weapon.sprite.width, weapon.sprite.height);

    // arma
    spritesLayer.imageMode(CENTER);
    spritesLayer.image(weapon.sprite, centerX + offset, centerY, weapon.sprite.width, weapon.sprite.height);
  }
}
