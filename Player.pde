public class Player extends Sprite {
  private int playerMaxHP;
  private int playerHP;
  private Item weapon;
  private Item healer;
  private Item keys;
  private int numberOfKeys;
  // attributo per l'arma del giocatore

  Player(int id, int playerHP, int maxHP, String dataPath, int numberOfKeys) {
    this.id = id;
    this.playerHP = playerHP;
    this.playerMaxHP = maxHP;
    this.img = loadImage(dataPath);
    this.numberOfKeys = numberOfKeys;
  }

  int getMaxHP() {
    return playerHP;
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

  Item getKey() {
    return keys;
  }

  void setKeys(Item keys) {
    this.keys = keys;
  }

  Item getHealer() {
    return healer;
  }

  void setHealer(Item healer) {
    this.healer = healer;
  }

  public void setNumberOfKeys(int numberOfKeys) {
    this.numberOfKeys = numberOfKeys;
  }

  public int getNumberOfKeys() {
    return numberOfKeys;
  }

  void displayPlayer(int tileSize) {
    display(tileSize);
  }
}
