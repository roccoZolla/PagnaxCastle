class Player {
  PVector spritePosition;
  float spriteSpeed = 0.5;
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

  // caratteristiche del player
  int playerMaxHP;
  int playerHP;
  int playerScore;
  int coins;      // numero di monete che ha il giocatore
  Weapon weapon;
  Healer healer;
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
    
    //println("newX: " + newX);
    //println("newY: " + newY);
    
    //println("roundedX: " + roundedX);
    //println("roundedY: " + roundedY);
  
    if (isValidMove(roundedX, roundedY)) {
      spritePosition.x = newX;
      spritePosition.y = newY;
    }
  }
  
  // collisione tra arma e nemico
  boolean collidesWith(Enemy enemy) { //<>//
    // se l'arma collide con un nemico sottrai danno alla vita nemico
    
    float offset = 16;
    
    if (direction == DIRECTION_RIGHT) offset = 16;
    else if (direction == DIRECTION_LEFT) offset = -16;
    
    println("giocatore: " + spritePosition);
    println("arma: " + weapon.spritePosition);
    
    if((weapon.spritePosition.x * currentLevel.tileSize) + offset <= (enemy.spritePosition.x * currentLevel.tileSize) + enemy.sprite.width  &&
      ((weapon.spritePosition.x * currentLevel.tileSize) + weapon.sprite.width) + offset >= enemy.spritePosition.x * currentLevel.tileSize && 
      weapon.spritePosition.y * currentLevel.tileSize <= (enemy.spritePosition.y * currentLevel.tileSize) + enemy.sprite.height && 
      (weapon.spritePosition.y * currentLevel.tileSize) + weapon.sprite.height >= enemy.spritePosition.y * currentLevel.tileSize) {
        return true;
    }
      
    return false;
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
    // aggiorna posizione dell'arma
    weapon.spritePosition = spritePosition;
    
    // offset
    float offset = 16;
    
    if (direction == DIRECTION_RIGHT) 
      offset = 16;
    else if (direction == DIRECTION_LEFT) 
      offset = -16;
    
    // hitbox arma
    spritesLayer.noFill(); // Nessun riempimento
    spritesLayer.stroke(255, 146, 240); // Colore del bordo bianco
    spritesLayer.rect((weapon.spritePosition.x * currentLevel.tileSize) + offset, weapon.spritePosition.y * currentLevel.tileSize, weapon.sprite.width, weapon.sprite.height);
    
    // arma
    spritesLayer.image(weapon.sprite, (weapon.spritePosition.x * currentLevel.tileSize) + offset,  weapon.spritePosition.y * currentLevel.tileSize, weapon.sprite.width, weapon.sprite.height);
  }

  void display(PGraphics layer) {
    // hitbox giocatore
    layer.rectMode(CENTER);
    layer.noFill(); // Nessun riempimento
    layer.stroke(255); // Colore del bordo bianco
    layer.rect(spritePosition.x * currentLevel.tileSize, spritePosition.y * currentLevel.tileSize, sprite.width, sprite.height);
    
    layer.image(sprite, spritePosition.x * currentLevel.tileSize, spritePosition.y * currentLevel.tileSize, sprite.width, sprite.height);
  }
}
