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

  void collect() {
    this.collected = true;
  }

  boolean isCollected() {
    return collected;
  }
  
  void display() {
    // hitbox moneta
    spritesLayer.noFill(); // Nessun riempimento
    spritesLayer.stroke(23, 255, 23);
    
    float centerX = spritePosition.x * currentLevel.tileSize + sprite.width / 2;
    float centerY = spritePosition.y * currentLevel.tileSize + sprite.height / 2;
    
    spritesLayer.imageMode(CENTER); // Imposta l'imageMode a center
    spritesLayer.image(sprite, centerX, centerY, sprite.width, sprite.height);
  }
  
  // metodo per il rilevamento delle collisioni 
  boolean playerCollide(Player aPlayer) { 
    if(aPlayer.spritePosition.x * currentLevel.tileSize + (aPlayer.sprite.width / 2) > (spritePosition.x * currentLevel.tileSize) - (sprite.width / 2)  &&      // x1 + w1/2 > x2 - w2/2
        (aPlayer.spritePosition.x * currentLevel.tileSize) - (aPlayer.sprite.width / 2) < spritePosition.x * currentLevel.tileSize + (sprite.width / 2) &&                               // x1 - w1/2 < x2 + w2/2
        aPlayer.spritePosition.y * currentLevel.tileSize + (aPlayer.sprite.height / 2) > (spritePosition.y * currentLevel.tileSize) - (sprite.height / 2) &&                                      // y1 + h1/2 > y2 - h2/2
        (aPlayer.spritePosition.y * currentLevel.tileSize) - (aPlayer.sprite.height / 2) < spritePosition.y * currentLevel.tileSize + (sprite.height / 2)) {                              // y1 - h1/2 < y2 + h2/2
          return true;
    }
    
    return false;
  }
}
