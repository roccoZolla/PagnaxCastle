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
      displayWeapon();
     
      for (Enemy enemy : currentLevel.enemies) {
        if (collidesWith(enemy.spritePosition)) {
          swordAttack.play();
          enemy.enemyHP -= weapon.getDamage();

          // l'attacco è stato eseguito non continuare ad attaccare
          // attackExecuted = true;

          // testo danno subito dal nemico
          TextDisplay damageHitText = new TextDisplay(enemy.spritePosition, Integer.toString(p1.weapon.damage), color(255, 0, 0), 2000);
          damageHitText.display();
        }
      }
    }
  }

  // collisione tra arma e nemico
  boolean collidesWith(PVector position) {
    // se l'arma collide con un nemico sottrai danno alla vita nemico

    float offset = 16;

    if (direction == DIRECTION_RIGHT) offset = 16;
    else if (direction == DIRECTION_LEFT) offset = -16;

    //println("giocatore: " + spritePosition);
    //println("arma: " + weapon.spritePosition);

    // da sistemare
    if ((weapon.spritePosition.x * currentLevel.tileSize) + offset <= (position.x * currentLevel.tileSize) + sprite.width  &&
      ((weapon.spritePosition.x * currentLevel.tileSize) + weapon.sprite.width) + offset >= position.x * currentLevel.tileSize &&
      weapon.spritePosition.y * currentLevel.tileSize <= (position.y * currentLevel.tileSize) + sprite.height &&
      (weapon.spritePosition.y * currentLevel.tileSize) + weapon.sprite.height >= position.y * currentLevel.tileSize) {
      return true;
    }

    return false;
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

  // override dei metodi dell'interfaccia
  @Override
    public void receiveDamage(int damage) {
    playerHP -= damage;
    if (playerHP < 0) {
      playerHP = 0;
    }
  }

  @Override
    PVector getPosition() {
    return position;
  }

  // metodo che si occupa di disegnare l'arma del giocatore
  void displayWeapon() {
    // aggiorna posizione dell'arma
    weapon.spritePosition = position;

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
