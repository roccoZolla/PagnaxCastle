class Player {
  PVector spritePosition;
  float spriteSpeed = 0.5;
  PImage sprite;
  
  // movements
  boolean moveUP;
  boolean moveDOWN;
  boolean moveRIGHT;
  boolean moveLEFT;
  
  boolean moveATCK;    // attacco
  boolean moveINTR;    // interazione
  boolean moveUSE;     // utilizza

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
    float spriteWidth = sprite.width;  // Larghezza dello sprite
    float spriteHeight = sprite.height;  // Altezza dello sprite
    
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


  // collision detection
  boolean isValidMove(int roundedX, int roundedY) {
    println("chiamata a valid move");
    println("isWithinMapBounds: " + isWithinMapBounds(roundedX, roundedY));
    // println("collisionRect: " + collisionRect.intersectsTile(roundedX, roundedY));
    println("isCollisionTile: " + isCollisionTile(roundedX, roundedY));
    
    if(isWithinMapBounds(roundedX, roundedY) && !isCollisionTile(roundedX, roundedY)) {
      return true;
    }
    
    return false;
    
    //// il giocatore si trova entro i confini della mappa
    //if(isWithinMapBounds(roundedX, roundedY)) {
    //  // se il giocatore collide con un tile
    //  if(collisionRect.intersectsTile(roundedX, roundedY)) {
    //    // se il tile non è di collisione 
    //    if(isCollisionTile(roundedX, roundedY)) {
    //      // la mossa non è valida
    //      flag = false;
    //    }
    //  }
    //}
    
    //return flag;
  }

  void display(PGraphics layer) {
    // hitbox giocatore
    layer.noFill(); // Nessun riempimento
    layer.stroke(255); // Colore del bordo bianco
    layer.rect(spritePosition.x * currentLevel.tileSize, spritePosition.y * currentLevel.tileSize, sprite.width, sprite.height);
    
    layer.image(sprite, spritePosition.x * currentLevel.tileSize, spritePosition.y * currentLevel.tileSize, sprite.width, sprite.height);
  }
}
