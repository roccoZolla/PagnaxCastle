// Classe Rectangle per rappresentare un rettangolo
class Rectangle {
  float x, y, width, height;

  Rectangle(float x, float y, float width, float height) {
    this.x = x;
    this.y = y;
    this.width = width;
    this.height = height;
  }

  // collision detection
  boolean intersectsTile(int tileX, int tileY) {
    float tileWidth = 16.0;  // Larghezza di una cella nella mappa
    float tileHeight = 16.0;  // Altezza di una cella nella mappa

    float tileXPos = tileX * tileWidth;
    float tileYPos = tileY * tileHeight;
    
    spritesLayer.noFill(); // Nessun riempimento
    spritesLayer.stroke(255); // Colore del bordo bianco
    spritesLayer.rect(tileXPos, tileYPos, tileWidth, tileHeight);
    
    // AABB
    return x < tileXPos + tileWidth &&
           x + width > tileXPos &&
           y < tileYPos + tileHeight &&
           y + height > tileYPos;
  }
}
