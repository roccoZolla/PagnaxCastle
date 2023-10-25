class Coin extends Sprite{
  private int value;
  private boolean collected;    // indica se la monete è stata raccolta
  private int scoreValue;
  
  Coin(int value, String dataPath){
    this.value = value;
    this.collected = false;    // di base una moneta non è raccolta
    this.img = loadImage(dataPath);
    this.scoreValue = 10;
  }
  
  void setValue(int value) {
    this.value = value;
  }
  
  int getValue(){
    return value;
  }
  
  void collect() {
    this.collected = true;
  }
  
  boolean isCollected() {
    return collected;
  }
  
  int getScoreValue() {
    return scoreValue;
  }
}
