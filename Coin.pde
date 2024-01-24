class Coin extends Sprite{
  int value;
  boolean collected;    // indica se la monete è stata raccolta
  int scoreValue;

  Coin(PVector position, PImage image, int value) {
    super(position, image);
    this.value = value;
    this.collected = false;    // di base una moneta non è raccolta
    this.scoreValue = 10;
  }

  void collect() {
    this.collected = true;
  }

  boolean isCollected() {
    return collected;
  }
}
