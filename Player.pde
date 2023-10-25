public class Player extends Sprite {
  private int playerMaxHP;
  private int playerHP;
  private int playerScore;
  private int coins;      // numero di monete che ha il giocatore
  private Item weapon;
  private Item healer;
  private Item golden_keys;
  private Item silver_keys;
  private int numberOfSilverKeys;
  private int numberOfGoldenKeys;
  private int numberOfPotion;

  Player(int id, int playerHP, int maxHP, String dataPath, int numberOfSilverKeys, int numberOfGoldenKeys, int numberOfPotion) {
    this.playerScore = 0;
    this.id = id;
    this.playerHP = playerHP;
    this.playerMaxHP = maxHP;
    this.img = loadImage(dataPath);
    this.coins = 0;
    this.numberOfSilverKeys = numberOfSilverKeys;
    this.numberOfGoldenKeys = numberOfGoldenKeys;
    this.numberOfPotion = numberOfPotion;
  }
  
  int getScore() {
    return playerScore;
  }
  
  void setScore(int playerScore) {
    this.playerScore = playerScore;
  }

  int getMaxHP() {
    return playerMaxHP;
  }

  void setMaxHP(int maxHP) {
    this.playerMaxHP = maxHP;
  }

  int getPlayerHP() {
    return playerHP;
  }

  void setPlayerHP(int playerHP) {
    this.playerHP = playerHP;
  }

  Item getPlayerWeapon() {
    return weapon;
  }

  void setPlayerWeapon(Item weapon) {
    this.weapon = weapon;
  }

  Item getGoldenKey() {
    return golden_keys;
  }

  void setGoldenKeys(Item golden_keys) {
    this.golden_keys = golden_keys;
  }  
  
  Item getSilverKey() {
    return silver_keys;
  }

  void setSilverKey(Item silver_keys) {
    this.silver_keys = silver_keys;
  }

  Item getHealer() {
    return healer;
  }

  void setHealer(Item healer) {
    this.healer = healer;
  }

  public void setNumberOfGoldenKeys(int numberOfGoldenKeys) {
    this.numberOfGoldenKeys = numberOfGoldenKeys;
  }

  public int getNumberOfGoldenKeys() {
    return numberOfGoldenKeys;
  }    
  
  public void setNumberOfSilverKeys(int numberOfSilverKeys) {
    this.numberOfSilverKeys = numberOfSilverKeys;
  }

  public int getNumberOfSilverKeys() {
    return numberOfSilverKeys;
  }  
  
  public void setNumberOfPotion(int numberOfPotion) {
    this.numberOfPotion = numberOfPotion;
  }

  public int getNumberOfPotion() {
    return numberOfPotion;
  }
  
  public void collectCoin() {
    this.coins++;
  }
  
  public int getCoins() {
    return coins;
  }

  void displayPlayer(int tileSize) {
    display(tileSize);
  }
}
