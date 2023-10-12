public class Player extends Sprite{
  private int playerHP;
  // attributo per l'arma del giocatore
  
  
  Player(int id, int playerHP, PImage player){
    this.id = id;
    this.playerHP = playerHP;
    this.img = player;
  }
  
  int getPlayerHP(){
    return playerHP;
  }
  
  void setPlayerHP(int playerHP) {
    this.playerHP = playerHP;
  }
  
  //Sprite getSprite() {
  //  return player;
  //}  
  
  void setSprite(PImage player) {
    this.img = player;
  }
  
  void displayPlayer(int tileSize){
    display(tileSize);
  }
}
