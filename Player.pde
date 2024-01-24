class Player implements Damageable { //<>//
  PVector spritePosition;
  float spriteSpeed = 0.2;
  PImage sprite;

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

  Player(int playerHP, int maxHP, int numberOfSilverKeys, int numberOfGoldenKeys, int numberOfPotion, ConcreteDamageHandler damageTileHandler) {
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
    float newX = spritePosition.x;
    float newY = spritePosition.y;

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

      spritePosition.x = newX;
      spritePosition.y = newY;
    }
  }

  // collisione tra arma e nemico
  boolean collidesWith(Enemy enemy) {
    // se l'arma collide con un nemico sottrai danno alla vita nemico

    float offset = 16;

    if (direction == DIRECTION_RIGHT) offset = 16;
    else if (direction == DIRECTION_LEFT) offset = -16;

    //println("giocatore: " + spritePosition);
    //println("arma: " + weapon.spritePosition);

    // da sistemare
    if ((weapon.spritePosition.x * currentLevel.tileSize) + offset <= (enemy.spritePosition.x * currentLevel.tileSize) + enemy.sprite.width  &&
      ((weapon.spritePosition.x * currentLevel.tileSize) + weapon.sprite.width) + offset >= enemy.spritePosition.x * currentLevel.tileSize &&
      weapon.spritePosition.y * currentLevel.tileSize <= (enemy.spritePosition.y * currentLevel.tileSize) + enemy.sprite.height &&
      (weapon.spritePosition.y * currentLevel.tileSize) + weapon.sprite.height >= enemy.spritePosition.y * currentLevel.tileSize) {
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
    float playerRight = spritePosition.x * currentLevel.tileSize + (sprite.width / 2);
    float playerLeft = spritePosition.x * currentLevel.tileSize - (sprite.width / 2);
    float playerBottom = spritePosition.y * currentLevel.tileSize + (sprite.height / 2);
    float playerTop = spritePosition.y * currentLevel.tileSize - (sprite.height / 2);

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
    return spritePosition;
  }

  // metodo che si occupa di disegnare l'arma del giocatore
  void drawPlayerWeapon() {
    // aggiorna posizione dell'arma
    weapon.spritePosition = spritePosition;

    // offset
    float offset = 16;

    if (direction == DIRECTION_RIGHT)
      offset = 16;
    else if (direction == DIRECTION_LEFT)
      offset = -16;

    float centerX = spritePosition.x * currentLevel.tileSize + sprite.width / 2;
    float centerY = spritePosition.y * currentLevel.tileSize + sprite.height / 2;

    // hitbox arma
    spritesLayer.rectMode(CENTER);
    spritesLayer.noFill(); // Nessun riempimento
    spritesLayer.stroke(255, 146, 240); // Colore del bordo bianco
    spritesLayer.rect(centerX + offset, centerY, weapon.sprite.width, weapon.sprite.height);

    // arma
    spritesLayer.imageMode(CENTER);
    spritesLayer.image(weapon.sprite, centerX + offset, centerY, weapon.sprite.width, weapon.sprite.height);
  }

  void display() {
    // hitbox giocatore
    spritesLayer.noFill(); // Nessun riempimento
    spritesLayer.stroke(255); // Colore del bordo bianco

    float centerX = spritePosition.x * currentLevel.tileSize + sprite.width / 2;
    float centerY = spritePosition.y * currentLevel.tileSize + sprite.height / 2;

    // hitbox
    //layer.rectMode(CENTER); // Imposta il rectMode a center
    //layer.rect(centerX, centerY, sprite.width, sprite.height);

    //layer.stroke(160);
    //layer.strokeWeight(10);
    //layer.point(centerX, centerY);

    spritesLayer.imageMode(CENTER); // Imposta l'imageMode a center
    spritesLayer.image(sprite, centerX, centerY, sprite.width, sprite.height);
  }
}
