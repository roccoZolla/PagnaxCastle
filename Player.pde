class Player {
  PVector spritePosition;
  float spriteSpeed = 1.0;
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
  }

  public void collectCoin() {
    this.coins++;
  }

  void move() {
    if (keyPressed) {
      float newX = p1.spritePosition.x;
      float newY = p1.spritePosition.y;

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

      // check delle collisioni
      if (roundedX >= 0 && roundedX < currentLevel.cols && roundedY >= 0 && roundedY < currentLevel.rows &&
        currentLevel.map[roundedX][roundedY] != 0 &&
        currentLevel.map[roundedX][roundedY] != 4 &&
        currentLevel.map[roundedX][roundedY] != 6 &&
        currentLevel.map[roundedX][roundedY] != 7) {
        p1.spritePosition.x = newX;
        p1.spritePosition.y = newY;
      }
    }
  }

  void display(PGraphics layer) {
    layer.image(sprite, spritePosition.x * currentLevel.tileSize, spritePosition.y * currentLevel.tileSize, sprite.width, sprite.height);
  }
}
