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

  // aggiorna movimento del giocatore
  void update() {
    // Ottengo il centro dello sprite
    float x = position.x;
    float y = position.y;

    println("player position: " + x + ", " + y);

    if (moveUP && !check_collision_wall(round(x),round(y - 1))) {
      y += -1 * spriteSpeed;
      println("new y value: " + y);
    } 
    
    if (moveDOWN && !check_collision_wall(round(x), round(y + 1))) {
      y += 1 * spriteSpeed;
      println("new y value: " + y);
    }
    
    if (moveLEFT && !check_collision_wall(round(x - 1), round(y))) {
      x += -1 * spriteSpeed;
      println("new x value: " + x);
    }
    
    if (moveRIGHT && !check_collision_wall(round(x + 1), round(y))) {
      x += 1 * spriteSpeed;
      println("new x value: " + x);
    }


    updatePosition(new PVector(x, y));
  }

  boolean check_collision_wall(int x, int y) {
    // se è un muro controlla la possibile collisione con lo sprite
    println("position: " + x + ", " + y);
    if (isWall(x, y)) {
      println("è un muro...");
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



  //  void update() {
  //    float x = position.x;
  //    float y = position.y;

  //    println("posizione player nella mappa: " + (int)x + ", " + (int) y);

  //    game.spritesLayer.noFill(); // Nessun riempimento
  //    game.spritesLayer.stroke(255, 30, 100); // Colore del bordo bianco
  //    game.spritesLayer.rectMode(CENTER);
  //    game.spritesLayer.rect(x * currentLevel.tileSize + sprite.width / 2, (y + 1) * currentLevel.tileSize + sprite.height / 2, sprite.width, sprite.height);

  //    game.spritesLayer.noFill(); // Nessun riempimento
  //    game.spritesLayer.stroke(255, 30, 100); // Colore del bordo bianco
  //    game.spritesLayer.rectMode(CENTER);
  //    game.spritesLayer.rect(x * currentLevel.tileSize + sprite.width / 2, (y-1) * currentLevel.tileSize + sprite.height / 2, sprite.width, sprite.height);

  //    game.spritesLayer.noFill(); // Nessun riempimento
  //    game.spritesLayer.stroke(255, 30, 100); // Colore del bordo bianco
  //    game.spritesLayer.rectMode(CENTER);
  //    game.spritesLayer.rect(x + 1 * currentLevel.tileSize + sprite.width / 2, y * currentLevel.tileSize + sprite.height / 2, sprite.width, sprite.height);

  //    game.spritesLayer.noFill(); // Nessun riempimento
  //    game.spritesLayer.stroke(255, 30, 100); // Colore del bordo bianco
  //    game.spritesLayer.rectMode(CENTER);
  //    game.spritesLayer.rect(x - 1  * currentLevel.tileSize + sprite.width / 2, y  * currentLevel.tileSize + sprite.height / 2, sprite.width, sprite.height);

  ////

  //    game.spritesLayer.noFill(); // Nessun riempimento
  //    game.spritesLayer.stroke(255, 30, 100); // Colore del bordo bianco
  //    game.spritesLayer.rectMode(CENTER);
  //    game.spritesLayer.rect(x + sprite.width / 2, y + sprite.height / 2 + sprite.height, sprite.width, sprite.height);

  //    game.spritesLayer.noFill(); // Nessun riempimento
  //    game.spritesLayer.stroke(255, 30, 100); // Colore del bordo bianco
  //    game.spritesLayer.rectMode(CENTER);
  //    game.spritesLayer.rect(x + sprite.width / 2, y + sprite.height / 2 - sprite.height, sprite.width, sprite.height);

  //    game.spritesLayer.noFill(); // Nessun riempimento
  //    game.spritesLayer.stroke(255, 30, 100); // Colore del bordo bianco
  //    game.spritesLayer.rectMode(CENTER);
  //    game.spritesLayer.rect(x + sprite.width / 2 + sprite.width, y + sprite.height / 2, sprite.width, sprite.height);

  //    game.spritesLayer.noFill(); // Nessun riempimento
  //    game.spritesLayer.stroke(255, 30, 100); // Colore del bordo bianco
  //    game.spritesLayer.rectMode(CENTER);
  //    game.spritesLayer.rect(x + sprite.width / 2 - sprite.width, y  + sprite.height / 2, sprite.width, sprite.height);

  //    game.spritesLayer.stroke(255); // Colore del bordo bianco
  //    game.spritesLayer.point(x, y); // Colore del bordo bianco

  //    game.spritesLayer.stroke(255); // Colore del bordo bianco
  //    game.spritesLayer.point(x + sprite.width / 2, y + sprite.height / 2); // Colore del bordo bianco



  //    if (moveUP && isValidMove(round(x + sprite.width / 2), round(y + sprite.height / 2 + sprite.height))) {
  //      y -= spriteSpeed;
  //    }

  //    if (moveDOWN && isValidMove(round(x + sprite.width / 2), round((y + 1) + sprite.height / 2))) {
  //      y += spriteSpeed;
  //    }
  //    if (moveLEFT && isValidMove(round((x - 1) + sprite.width / 2), round(y + sprite.height / 2))) {
  //      sprite = spriteLeft;
  //      x -= spriteSpeed;
  //      direction = DIRECTION_LEFT;
  //    }
  //    if (moveRIGHT && isValidMove(round((x + 1) + sprite.width / 2), round(y + sprite.height / 2))) {
  //      sprite = spriteRight;
  //      x += spriteSpeed;
  //      direction = DIRECTION_RIGHT;
  //    }

  //    // Update the position only if the move is valid
  //    damageTileHandler.handleDamageTiles(this, round(x), round(y));
  //    updatePosition(new PVector(x, y));
  //  }

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

  // collision detection
  boolean isValidMove(int roundedX, int roundedY) {
    game.spritesLayer.noFill(); // Nessun riempimento
    game.spritesLayer.stroke(0, 0, 255); // Colore del bordo bianco
    game.spritesLayer.rectMode(CENTER);
    game.spritesLayer.rect(roundedX * currentLevel.tileSize, roundedY * currentLevel.tileSize, sprite.width, sprite.height);

    // esce fuori dalla mappa
    if (!isWithinMapBounds(roundedX, roundedY)) {
      return false;
    }

    //if (isCollisionTile(roundedX, roundedY) && isCollidingWithTile(roundedX, roundedY)) {
    //  return false;
    //}

    // sta collidendo con un muro
    if (isWall(roundedX, roundedY)) {
      println("è un muro....");
      return false;
    }

    //if (isCollidingWithTile(roundedX, roundedY)) {
    //  println("sta collidendo con un tile");
    //  return false;
    //}

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

  //boolean isCollidingWithTile(int roundedX, int roundedY) {
  //  float halfWidth = sprite.width / 2;
  //  float halfHeight = sprite.height / 2;

  //  // Calcola le coordinate dei quattro angoli del personaggio
  //  float playerLeft = roundedX * currentLevel.tileSize - halfWidth;
  //  float playerRight = roundedX * currentLevel.tileSize + halfWidth;
  //  float playerTop = roundedY * currentLevel.tileSize - halfHeight;
  //  float playerBottom = roundedY * currentLevel.tileSize + halfHeight;

  //  // Controlla le collisioni per ogni angolo
  //  boolean collisionTopLeft = isCollisionTile(round(playerLeft / currentLevel.tileSize), round(playerTop / currentLevel.tileSize));
  //  boolean collisionTopRight = isCollisionTile(round(playerRight / currentLevel.tileSize), round(playerTop / currentLevel.tileSize));
  //  boolean collisionBottomLeft = isCollisionTile(round(playerLeft / currentLevel.tileSize), round(playerBottom / currentLevel.tileSize));
  //  boolean collisionBottomRight = isCollisionTile(round(playerRight / currentLevel.tileSize), round(playerBottom / currentLevel.tileSize));

  //  return collisionTopLeft || collisionTopRight || collisionBottomLeft || collisionBottomRight;
  //}




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
