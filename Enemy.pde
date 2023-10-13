public class Enemy extends Sprite{
  private int enemyHP;
  
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
  
  void displayEnemy(int tileSize){
    display(tileSize);
  }
}
