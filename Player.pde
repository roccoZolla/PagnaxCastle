public class Player extends Sprite{
  private int playerHP;
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
  
  void displayPlayer(int tileSize){
    display(tileSize);
  }
}
