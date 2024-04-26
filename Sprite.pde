class Sprite {
  PVector position;
  PImage sprite;

  Sprite(PVector position) {
    this.position = position;
  }

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

    // layer.imageMode(CENTER); // Imposta l'imageMode a center, viene impostata nel codice principale in game
    layer.image(sprite, centerX, centerY, sprite.width, sprite.height);
  }

  void displayHitbox(PGraphics layer) {
    float centerX = position.x * currentLevel.tileSize + sprite.width / 2;
    float centerY = position.y * currentLevel.tileSize + sprite.height / 2;

    layer.noFill(); // Nessun riempimento
    layer.stroke(255); // Colore del bordo bianco
    layer.rectMode(CENTER);
    layer.rect(centerX, centerY, sprite.width, sprite.height);

    layer.stroke(255, 0, 0);
    layer.point(centerX, centerY);
  }
}
