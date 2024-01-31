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
    damageHitText.display(game.spritesLayer);

    hurt_sound.play();

    if (playerHP < 0) {
      playerHP = 0;
    }
  }

  // movimento del giocatore
  //void update() {
  //  float newX = position.x;
  //  float newY = position.y;

  //  int roundedX = 0, roundedY = 0;

  //  if (moveUP) {
  //    newY += -1 * spriteSpeed;
  //  }
  //  if (moveDOWN) {
  //    newY += 1 * spriteSpeed;
  //  }
  //  if (moveLEFT) {
  //    p1.sprite = spriteLeft;
  //    newX += -1 * spriteSpeed;
  //    direction = DIRECTION_LEFT;
  //  }
  //  if (moveRIGHT) {
  //    p1.sprite = spriteRight;
  //    newX += 1 * spriteSpeed;
  //    direction = DIRECTION_RIGHT;
  //  }

  //  // Round the new position values
  //  roundedX = round(newX);
  //  roundedY = round(newY);

  //  if (isValidMove(roundedX, roundedY)) {
  //    damageTileHandler.handleDamageTiles(this, roundedX, roundedY);

  //    updatePosition(new PVector(newX, newY));
  //  }
  //}

  //void update() {
  //  float newX = position.x;
  //  float newY = position.y;

  //  if (moveUP && isValidMove(round(newX), round(newY - spriteSpeed))) {
  //    newY -= spriteSpeed;
  //  }
  //  if (moveDOWN && isValidMove(round(newX), round(newY + spriteSpeed))) {
  //    newY += spriteSpeed;
  //  }
  //  if (moveLEFT && isValidMove(round(newX - spriteSpeed), round(newY))) {
  //    p1.sprite = spriteLeft;
  //    newX -= spriteSpeed;
  //    direction = DIRECTION_LEFT;
  //  }
  //  if (moveRIGHT && isValidMove(round(newX + spriteSpeed), round(newY))) {
  //    p1.sprite = spriteRight;
  //    newX += spriteSpeed;
  //    direction = DIRECTION_RIGHT;
  //  }

  //  // Update the position only if the move is valid
  //  damageTileHandler.handleDamageTiles(this, round(newX), round(newY));
  //  updatePosition(new PVector(newX, newY));
  //}

  void update() {
    float newX = position.x;
    float newY = position.y;

    if (moveUP && isValidMove(round(newX), round(newY - spriteSpeed))) {
      newY -= spriteSpeed;
    }
    if (moveDOWN && isValidMove(round(newX), round(newY + spriteSpeed))) {
      newY += spriteSpeed;
    }

    // Aggiorna solo la posizione y se il movimento verticale è valido
    if (isValidMove(round(position.x), round(newY))) {
      position.y = newY;
    }

    if (moveLEFT && isValidMove(round(newX - spriteSpeed), round(newY))) {
      p1.sprite = spriteLeft;
      newX -= spriteSpeed;
      direction = DIRECTION_LEFT;
    }
    if (moveRIGHT && isValidMove(round(newX + spriteSpeed), round(newY))) {
      p1.sprite = spriteRight;
      newX += spriteSpeed;
      direction = DIRECTION_RIGHT;
    }

    // Aggiorna solo la posizione x se il movimento orizzontale è valido
    if (isValidMove(round(newX), round(position.y))) {
      position.x = newX;
    }
  }


  // da fixare
  void attack(PGraphics layer) {
    if (moveATCK && (!moveUSE && !moveINTR)) {
      println("sta attaccando...");
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
            println("attacco eseguito...");
            attackExecuted = true;
          }
        } else {
          for (Enemy enemy : currentLevel.enemies) {
            if (weapon.sprite_collision(enemy)) {
              swordAttack.play();
              enemy.takeDamage(weapon.getDamage());
              // l'attacco è stato eseguito non continuare ad attaccare
              println("attacco eseguito...");
              attackExecuted = true;
            }
          }
        }
      }
    } else {
      println("non sta piu attaccando...");
      isAttacking = false;
      attackExecuted = false;
    }
  }

  void usePotion(PGraphics layer) {
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
            healthFull.display(layer);
          }
        } else {
          // stampa x per indicare che non hai piu pozioni
          float crossImageX = (p1.getPosition().x * currentLevel.tileSize + (p1.sprite.width / 2));
          float crossImageY = (p1.getPosition().y * currentLevel.tileSize + (p1.sprite.height / 2)) - 20; // Regola l'offset verticale a tuo piacimento
          layer.imageMode(CENTER);
          layer.image(cross_sprite, crossImageX, crossImageY);
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

    //if (isCollisionTile(roundedX, roundedY) && isCollidingWithTile(roundedX, roundedY)) {
    //  return false;
    //}
    
    if(isCollidingWithTile(roundedX, roundedY)) {
      println("sta collidendo con un tile");
      return false;
    }

    return true;
  }

  //boolean isCollidingWithTile(int roundedX, int roundedY) {
  //  float playerRight = position.x * currentLevel.tileSize + (sprite.width / 2);
  //  float playerLeft = position.x * currentLevel.tileSize - (sprite.width / 2);
  //  float playerBottom = position.y * currentLevel.tileSize + (sprite.height / 2);
  //  float playerTop = position.y * currentLevel.tileSize - (sprite.height / 2);

  //  float tileRight = roundedX * currentLevel.tileSize + (currentLevel.tileSize / 2);
  //  float tileLeft = roundedX * currentLevel.tileSize - (currentLevel.tileSize / 2);
  //  float tileBottom = roundedY * currentLevel.tileSize + (currentLevel.tileSize / 2);
  //  float tileTop = roundedY * currentLevel.tileSize - (currentLevel.tileSize / 2);

  //  // Verifica delle collisioni
  //  boolean collisionX = playerRight >= tileLeft && playerLeft <= tileRight;
  //  boolean collisionY = playerBottom >= tileTop && playerTop <= tileBottom;

  //  return collisionX && collisionY;
  //}

boolean isCollidingWithTile(int roundedX, int roundedY) {
  float halfWidth = sprite.width / 2;
  float halfHeight = sprite.height / 2;

  // Calcola le coordinate dei quattro angoli del personaggio
  float playerLeft = roundedX * currentLevel.tileSize - halfWidth;
  float playerRight = roundedX * currentLevel.tileSize + halfWidth;
  float playerTop = roundedY * currentLevel.tileSize - halfHeight;
  float playerBottom = roundedY * currentLevel.tileSize + halfHeight;

  // Controlla le collisioni per ogni angolo
  boolean collisionTopLeft = isCollisionTile(round(playerLeft / currentLevel.tileSize), round(playerTop / currentLevel.tileSize));
  boolean collisionTopRight = isCollisionTile(round(playerRight / currentLevel.tileSize), round(playerTop / currentLevel.tileSize));
  boolean collisionBottomLeft = isCollisionTile(round(playerLeft / currentLevel.tileSize), round(playerBottom / currentLevel.tileSize));
  boolean collisionBottomRight = isCollisionTile(round(playerRight / currentLevel.tileSize), round(playerBottom / currentLevel.tileSize));

  return collisionTopLeft || collisionTopRight || collisionBottomLeft || collisionBottomRight;
}




  //boolean isValidMove(int roundedX, int roundedY) {
  //  if (!isWithinMapBounds(roundedX, roundedY)) {
  //    return false;
  //  }

  //  // Check for collisions at the four corners of the player sprite
  //  float halfWidth = sprite.width / 2;
  //  float halfHeight = sprite.height / 2;

  //  float playerLeft = position.x * currentLevel.tileSize - halfWidth;
  //  float playerRight = position.x * currentLevel.tileSize + halfWidth;
  //  float playerTop = position.y * currentLevel.tileSize - halfHeight;
  //  float playerBottom = position.y * currentLevel.tileSize + halfHeight;

  //  if (isCollidingWithTileAt(playerLeft, playerTop) ||
  //    isCollidingWithTileAt(playerRight, playerTop) ||
  //    isCollidingWithTileAt(playerLeft, playerBottom) ||
  //    isCollidingWithTileAt(playerRight, playerBottom)) {
  //    return false;
  //  }

  //  return true;
  //}

  //boolean isCollidingWithTileAt(float x, float y) {
  //  int tileX = round(x / currentLevel.tileSize);
  //  int tileY = round(y / currentLevel.tileSize);

  //  return isCollisionTile(tileX, tileY);
  //}


  @Override
    PVector getPosition() {
    return position;
  }
}
