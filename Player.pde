class Player {
  PVector spritePosition;
  float spriteSpeed = 0.5;
  PImage sprite;
  
  // movements
  boolean moveUP;
  boolean moveDOWN;
  boolean moveRIGHT;
  boolean moveLEFT;
  
  boolean moveATCK;    // attacco j
  boolean moveINTR;    // interazione k 
  boolean moveUSE;     // utilizza l

  // caratteristiche del player
  int playerMaxHP;
  int playerHP;
  int playerScore;
  int coins;      // numero di monete che ha il giocatore
  Item weapon;
  Item healer;
  Item golden_keys;
  Item silver_keys;
  int numberOfSilverKeys;
  int numberOfGoldenKeys;
  int numberOfPotion;

  Player(int playerHP, int maxHP, int numberOfSilverKeys, int numberOfGoldenKeys, int numberOfPotion) {
    this.playerScore = 0;
    this.playerHP = playerHP;
    this.playerMaxHP = maxHP;
    this.coins = 0;
    this.numberOfSilverKeys = numberOfSilverKeys;
    this.numberOfGoldenKeys = numberOfGoldenKeys;
    this.numberOfPotion = numberOfPotion;
  }

  public void collectCoin() {
    this.coins++;
  }
 
  void move() {
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
      newX -= spriteSpeed;
    }
    if (moveRIGHT) {
      newX += spriteSpeed;
    }

    // Verifica se la nuova posizione è valida
    roundedX = round(newX);
    roundedY = round(newY);
    
    println("newX: " + newX);
    println("newY: " + newY);
    
    println("roundedX: " + roundedX);
    println("roundedY: " + roundedY);
  
    if (isValidMove(roundedX, roundedY)) {
      spritePosition.x = newX;
      spritePosition.y = newY;
    }
  }
  
  // attacca il nemico
  // in base all'arma equipaggiata 
  // calcola il danno
  void attack() {
    // se l'arma collide con un nemico sottrai danno alla vita nemico
  }

  // collision detection
  boolean isValidMove(int roundedX, int roundedY) {
    if(isWithinMapBounds(roundedX, roundedY) && !isCollisionTile(roundedX, roundedY)) {
      return true;
    }
    
    return false;
  }

  void display(PGraphics layer) {
    // hitbox giocatore
    layer.noFill(); // Nessun riempimento
    layer.stroke(255); // Colore del bordo bianco
    layer.rect(spritePosition.x * currentLevel.tileSize, spritePosition.y * currentLevel.tileSize, sprite.width, sprite.height);
    
    layer.image(sprite, spritePosition.x * currentLevel.tileSize, spritePosition.y * currentLevel.tileSize, sprite.width, sprite.height);
  }
}
