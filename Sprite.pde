class Sprite { //<>// //<>//
  final static int SPRITE_SIZE = 16;
  FBox box;
  PImage sprite;

  // constructors
  Sprite() {
  }

  Sprite(PImage sprite)
  {
    this.sprite = sprite;
  }

  Sprite(PImage sprite, FBox box)
  {
    this.sprite = sprite;
    this.box = box;
  }

  // getters
  PVector getPosition() {
    return new PVector(box.getX(), box.getY());
  }

  int getWidth() {
    return sprite.width;
  }

  int getHeight() {
    return sprite.height;
  }

  PImage getSprite() {
    return sprite;
  }

  FBox getBox() {
    return box;
  }

  // setters
  void updatePosition(PVector position) {
    println("sprite->updatePosition: aggiorno la posizione...");
    println("posizione di input: " + position);
    println("posizione di output teorica: " + position.x * SPRITE_SIZE + SPRITE_SIZE / 2 + ", " +  position.y * SPRITE_SIZE + SPRITE_SIZE / 2);
    box.setPosition(position.x * SPRITE_SIZE + SPRITE_SIZE / 2, position.y * SPRITE_SIZE + SPRITE_SIZE / 2);
  }

  void updatePosition(float x, float y) {
    box.setPosition(x * SPRITE_SIZE + SPRITE_SIZE / 2, y * SPRITE_SIZE + SPRITE_SIZE / 2);
  }

  void updateSprite(PImage sprite) {
    this.sprite = sprite;
  }

  // other methods
  // metodo che si occupa di mostrare lo sprite
  void display(PGraphics layer) {
    layer.noFill(); // Nessun riempimento
    // layer.stroke(255); // Colore del bordo bianco
    layer.image(sprite, box.getX(), box.getY(), SPRITE_SIZE, SPRITE_SIZE);
  }

  void displayHitbox(PGraphics layer) {
    layer.noFill(); // Nessun riempimento
    layer.stroke(255); // Colore del bordo rosso per l'hitbox
    layer.rect(box.getX() - SPRITE_SIZE / 2, box.getY() - SPRITE_SIZE / 2, SPRITE_SIZE, SPRITE_SIZE);
  }
}
