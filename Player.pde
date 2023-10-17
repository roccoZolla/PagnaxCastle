public class Player extends Sprite{
  private int playerHP;
  private Item weapon;
  // attributo per l'arma del giocatore
  
  Player(int id, int playerHP, String dataPath){
    this.id = id;
    this.playerHP = playerHP;
    this.img = loadImage(dataPath);
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
  
  void displayPlayer(int tileSize){
    display(tileSize);
  }
}
