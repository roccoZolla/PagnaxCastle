class Player {
  PVector spritePosition;
  float spriteSpeed = 0.5;
  Rectangle playerBox;
  PImage sprite;

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
    this.playerBox = new Rectangle(0, 0, 0, 0);
  }
  
  void setPlayerBox() {
    playerBox.x = spritePosition.x;
    playerBox.y = spritePosition.y;
    playerBox.width = sprite.width;
    playerBox.height = sprite.height;
  }

  public void collectCoin() {
    this.coins++;
  }

  //void move() {
  //  if (keyPressed) {
  //    float newX = p1.spritePosition.x;
  //    float newY = p1.spritePosition.y;

  //    if (moveUP) {
  //      newY -= spriteSpeed;
  //    }
  //    if (moveDOWN) {
  //      newY += spriteSpeed;
  //    }
  //    if (moveLEFT) {
  //      newX -= spriteSpeed;
  //    }
  //    if (moveRIGHT) {
  //      newX += spriteSpeed;
  //    }

  //    // Verifica se la nuova posizione è valida
  //    int roundedX = round(newX);
  //    int roundedY = round(newY);

  //    // check delle collisioni
  //    if (roundedX >= 0 && roundedX < currentLevel.cols && roundedY >= 0 && roundedY < currentLevel.rows &&
  //      currentLevel.map[roundedX][roundedY] != 0 && 
  //      currentLevel.map[roundedX][roundedY] != 4 &&
  //      currentLevel.map[roundedX][roundedY] != 6 &&
  //      currentLevel.map[roundedX][roundedY] != 7) {
  //      p1.spritePosition.x = newX;
  //      p1.spritePosition.y = newY;
  //    }
  //  }
  //}
  
  void move() {
    if (keyPressed) {    
      float newX = p1.spritePosition.x;
      float newY = p1.spritePosition.y;
      float spriteWidth = p1.sprite.width;  // Larghezza dello sprite
      float spriteHeight = p1.sprite.height;  // Altezza dello sprite
  
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
      int roundedX = round(newX);
      int roundedY = round(newY);
      
      println("roundedX: " + roundedX);
      println("roundedY: " + roundedY);
      
      // Calcola il rettangolo di collisione intorno allo sprite
      playerBox.x = roundedX;
      playerBox.y = roundedY;
      
      spritesLayer.noFill(); // Nessun riempimento
      spritesLayer.stroke(255); // Colore del bordo bianco
      spritesLayer.rect(roundedX, roundedY, spriteWidth, spriteHeight);
    
      if (isValidMove(playerBox, roundedX, roundedY)) {
        p1.spritePosition.x = newX;
        p1.spritePosition.y = newY;
      }
    }
  }


  // collision detection
  boolean isValidMove(Rectangle collisionRect, int roundedX, int roundedY) {
     int startX = floor((camera.x / (camera.zoom)));
     int startY = floor((camera.y / (camera.zoom)));
     int endX = ceil((camera.x + gameScene.width) / (camera.zoom));
     int endY = ceil((camera.y + gameScene.height) / (camera.zoom));
     
      spritesLayer.noFill(); // Nessun riempimento
      spritesLayer.stroke(255, 0 ,0); // Colore del bordo bianco
      spritesLayer.ellipse(startX, startY, 30, 30);
      
      spritesLayer.noFill(); // Nessun riempimento
      spritesLayer.stroke(255, 0 ,0); // Colore del bordo bianco
      spritesLayer.ellipse(endX, endY, 30, 30);
      
      println(collisionRect.intersectsTile(roundedX, roundedY));
      
     if (collisionRect.intersectsTile(roundedX, roundedY) &&
        (currentLevel.map[roundedX][roundedY] == 0 || 
        currentLevel.map[roundedX][roundedY] == 4 ||
        currentLevel.map[roundedX][roundedY] == 6 ||
        currentLevel.map[roundedX][roundedY] == 7)) {
        return false;
      }
  
    return true;
  }

  void display(PGraphics layer) {
    layer.noFill(); // Nessun riempimento
    layer.stroke(255); // Colore del bordo bianco
    layer.rect(spritePosition.x * currentLevel.tileSize, spritePosition.y * currentLevel.tileSize, sprite.width, sprite.height);
    layer.noFill();
    layer.stroke(255, 0, 0);
    layer.point(spritePosition.x * currentLevel.tileSize, spritePosition.y * currentLevel.tileSize);
    layer.image(sprite, spritePosition.x * currentLevel.tileSize, spritePosition.y * currentLevel.tileSize, sprite.width, sprite.height);
  }
}
