class Player {
  PVector spritePosition;
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

  void display(PGraphics layer) {
    layer.image(sprite, spritePosition.x * currentLevel.tileSize, spritePosition.y * currentLevel.tileSize, sprite.width, sprite.height);
  }
}
