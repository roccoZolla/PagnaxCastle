public class Enemy extends Sprite{
  private int enemyHP;
  // attributo per l'arma
  // private Sprite enemy;
  
  Enemy(int id, int enemyHP, PImage enemy){
    this.id = id;
    this.enemyHP = enemyHP;
    this.img = enemy;
  }
  
  int getEnemyHP(){
    return enemyHP;
  }
  
  void setEnemyHP(int enemyHP) {
    this.enemyHP = enemyHP;
  }
  
  //Sprite getSprite() {
  //  return player;
  //}  
  
  void setSprite(PImage enemy) {
    this.img = enemy;
  }
  
  void displayEnemy(int tileSize){
    display(tileSize);
  }
}
