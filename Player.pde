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
    
    this.moveUP = false;
    this.moveDOWN = false;
    this.moveRIGHT = false;
    this.moveLEFT = false;
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
      p1.sprite = spriteLeft;
      newX -= spriteSpeed;
    }
    if (moveRIGHT) {
      p1.sprite = spriteRight;
      newX += spriteSpeed;
    }

    // Verifica se la nuova posizione è valida
    roundedX = round(newX);
    roundedY = round(newY);
    
    //println("newX: " + newX);
    //println("newY: " + newY);
    
    //println("roundedX: " + roundedX);
    //println("roundedY: " + roundedY);
  
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
    //  boolean weaponCollision(Enemy enemy) {
    //  float weaponPosition = 10;
    //  if (p1.moveRIGHT) weaponPosition = 10;
    //  else if (p1.moveLEFT) weaponPosition = -10;
      
    //  if((p1.spritePosition.x * currentLevel.tileSize) + weaponPosition <= (enemy.spritePosition.x * currentLevel.tileSize) + enemy.sprite.width  &&
    //      (p1.spritePosition.x * currentLevel.tileSize) + weaponPosition + p1.weapon.sprite.width >= enemy.spritePosition.x * currentLevel.tileSize && 
    //      p1.spritePosition.y * currentLevel.tileSize <= (enemy.spritePosition.y * currentLevel.tileSize) + enemy.sprite.height &&
    //      p1.spritePosition.y * currentLevel.tileSize + p1.weapon.sprite.height >= (enemy.spritePosition.y * currentLevel.tileSize)) {
    //      return true;
    //  }
      
    //  return false;
    //}
  }

  // collision detection
  boolean isValidMove(int roundedX, int roundedY) {
    // il player si trova all'interno della mappa di gioco
    if(isWithinMapBounds(roundedX, roundedY)) {
      // il player si scontra con un tile di collisione
      if(isCollisionTile(roundedX, roundedY)) {
        if(spritePosition.x * currentLevel.tileSize <= (roundedX * currentLevel.tileSize) + currentLevel.tileSize ||
           (spritePosition.x * currentLevel.tileSize) + sprite.width<= roundedX * currentLevel.tileSize ||
           spritePosition.y * currentLevel.tileSize >= (roundedY * currentLevel.tileSize) + currentLevel.tileSize ||
           (spritePosition.y * currentLevel.tileSize) + sprite.height >= roundedY * currentLevel.tileSize) {
           // ritorna falso se il player cerca di attraversa il tile 
           return false;
        }
      }
      // ritorna vero se il player si trova all'interno della mappa e non si sta scontrando con un tile di collisione
      return true;
    }
    
    // falso altrimenti
    return false;
  }
  
  // metodo che si occupa di disegnare l'arma del giocatore
  void drawPlayerWeapon() {
    float weaponPosition = 10;
    if (p1.moveRIGHT) weaponPosition = 10;
    else if (p1.moveLEFT) weaponPosition = -10;
  
    PImage weaponImage = p1.weapon.sprite;
    float imageX = (p1.spritePosition.x * currentLevel.tileSize) + weaponPosition;
    float imageY = p1.spritePosition.y * currentLevel.tileSize;
    float imageWidth = p1.weapon.sprite.width;
    float imageHeight = p1.weapon.sprite.height;
    
    spritesLayer.noFill(); // Nessun riempimento
    spritesLayer.stroke(255, 146, 240); // Colore del bordo bianco
    spritesLayer.rect(imageX, imageY, imageWidth, imageHeight);
    
    spritesLayer.image(weaponImage, imageX, imageY, imageWidth, imageHeight);
  }

  void display(PGraphics layer) {
    // hitbox giocatore
    layer.noFill(); // Nessun riempimento
    layer.stroke(255); // Colore del bordo bianco
    layer.rect(spritePosition.x * currentLevel.tileSize, spritePosition.y * currentLevel.tileSize, sprite.width, sprite.height);
    
    layer.image(sprite, spritePosition.x * currentLevel.tileSize, spritePosition.y * currentLevel.tileSize, sprite.width, sprite.height);
  }
}
