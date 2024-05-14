class Coin extends Sprite {
  int value;
  boolean collected;    // indica se la monete è stata raccolta
  int scoreValue;

  Coin(PImage image, int value) {
    super();
<<<<<<< HEAD

    // sprite
    this.sprite = image;

=======
    
    // sprite
    this.sprite = image;
    
>>>>>>> fix
    // box settings
    box = new FBox(SPRITE_SIZE, SPRITE_SIZE);
    box.setName("Coin");
    box.setFillColor(10);
<<<<<<< HEAD
    box.setAllowSleeping(true);  // permette al motore fisico di "addormentare" l'oggetto -> risparmio di risorse
=======
>>>>>>> fix
    box.setRotatable(false);
    box.setFriction(0.5);
    box.setRestitution(0.2);
    box.setSensor(true);  // è un sensore
<<<<<<< HEAD

=======
    
>>>>>>> fix
    // charateristics
    this.value = value;
    this.collected = false;    // di base una moneta non è raccolta
    this.scoreValue = 10;
  }

  void collect() {
    this.collected = true;
  }

  boolean IsCollected() {
    return collected;
  }
}
