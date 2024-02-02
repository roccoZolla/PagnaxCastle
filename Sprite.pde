class Sprite {
  PVector position;
  PImage sprite;

  Sprite(PVector position, PImage sprite) {
    this.position = position;
    this.sprite = sprite;
  }

  PVector getPosition() {
    return position;
  }

  PImage getSprite() {
    return sprite;
  }

  void updatePosition(PVector position) {
    this.position = position;
  }

  void updateSprite(PImage sprite) {
    this.sprite = sprite;
  }

  // metodo che si occupa di mostrare lo sprite
  void display(PGraphics layer) {
    layer.noFill(); // Nessun riempimento
    layer.stroke(255); // Colore del bordo bianco

    float centerX = position.x * currentLevel.tileSize + sprite.width / 2;
    float centerY = position.y * currentLevel.tileSize + sprite.height / 2;

    // layer.imageMode(CENTER); // Imposta l'imageMode a center
    layer.image(sprite, centerX, centerY, sprite.width, sprite.height);
  }

  void displayHitbox(PGraphics layer) {
    layer.noFill(); // Nessun riempimento
    layer.stroke(255); // Colore del bordo bianco
    layer.rectMode(CENTER);
    layer.rect(position.x * currentLevel.tileSize + (sprite.width/2), position.y * currentLevel.tileSize + (sprite.height / 2), sprite.width, sprite.height);

    layer.stroke(255, 0, 0);
    layer.point(position.x * currentLevel.tileSize + (sprite.width / 2), position.y * currentLevel.tileSize + sprite.height / 2);
  }

  // metodo che si occupa delle collisioni tra sprite
  // da sistemare
  boolean sprite_collision(Sprite other) {
    PVector otherPosition = other.getPosition();
    PImage otherSprite = other.getSprite();

    if (position.x * currentLevel.tileSize + (sprite.width / 2) >= (otherPosition.x * currentLevel.tileSize) - (otherSprite.width / 2)  &&      // x1 + w1/2 > x2 - w2/2
      (position.x * currentLevel.tileSize) - (sprite.width / 2) <= otherPosition.x * currentLevel.tileSize + (otherSprite.width / 2) &&                               // x1 - w1/2 < x2 + w2/2
      position.y * currentLevel.tileSize + (sprite.height / 2) >= (otherPosition.y * currentLevel.tileSize) - (otherSprite.height / 2) &&                                      // y1 + h1/2 > y2 - h2/2
      (position.y * currentLevel.tileSize) - (sprite.height / 2) <= otherPosition.y * currentLevel.tileSize + (otherSprite.height / 2)) {                              // y1 - h1/2 < y2 + h2/2
      return true;
    }

    return false;
  }
}
