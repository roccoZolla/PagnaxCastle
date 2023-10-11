public class Player {
  int playerHP;
  Sprite player;
  
  Player(int playerHP, Sprite player){
    this.playerHP = playerHP;
    this.player = player;
  }
  
  int getPlayerHP(){
    return playerHP;
  }
  
  void setPlayerHP(int playerHP) {
    this.playerHP = playerHP;
  }
  
  Sprite getSprite() {
    return player;
  }  
  
  void setSprite(Sprite player) {
    this.player = player;
  }
}
