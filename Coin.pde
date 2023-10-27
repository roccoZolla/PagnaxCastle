class Coin {
  PVector spritePosition;
  PImage sprite;

  int value;
  boolean collected;    // indica se la monete è stata raccolta
  int scoreValue;

  Coin(int value) {
    this.value = value;
    this.collected = false;    // di base una moneta non è raccolta
    this.scoreValue = 10;
  }

  void setValue(int value) {
    this.value = value;
  }

  int getValue() {
    return value;
  }

  void collect() {
    this.collected = true;
  }

  boolean isCollected() {
    return collected;
  }

  void display(PGraphics layer) {
    layer.image(sprite, spritePosition.x * currentLevel.tileSize, spritePosition.y * currentLevel.tileSize, sprite.width, sprite.height);
  }
}
