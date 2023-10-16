public class Enemy extends Sprite {
  private int enemyHP;
  private String name;
  
  Enemy(int id, int enemyHP, String name, PImage enemy){
    this.id = id;
    this.enemyHP = enemyHP;
    this.name = name;
    this.img = enemy;
  }
  
  int getEnemyHP(){
    return enemyHP;
  }
  
  String getName() {
    return name;
  }
  
  void setEnemyHP(int enemyHP) {
    this.enemyHP = enemyHP;
  }
  
  void setName(String name) {
    this.name = name;
  }
  
  void displayEnemy(int tileSize){
    display(tileSize);
  }
}
