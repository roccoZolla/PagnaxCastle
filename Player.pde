public class Player extends Sprite{
  private int playerHP;
  private Item weapon;
  private Item keys;
  private int numberOfKeys;
  // attributo per l'arma del giocatore
  
  Player(int id, int playerHP, String dataPath, int numberOfKeys){
    this.id = id;
    this.playerHP = playerHP;
    this.img = loadImage(dataPath);
    this.numberOfKeys = numberOfKeys;
  }
  
  int getPlayerHP(){
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
  
  Item getKey(){
    return keys;
  }
  
  void setKeys(Item keys) {
    this.keys = keys;
  }
  
  public void setNumberOfKeys(int numberOfKeys) {
    this.numberOfKeys = numberOfKeys;
  }
  
  public int getNumberOfKeys() {
    return numberOfKeys;
  }
  
  void displayPlayer(int tileSize){
    display(tileSize);
  }  
}
