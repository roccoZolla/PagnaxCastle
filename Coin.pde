class Coin {
  PVector spritePosition;
  PImage sprite;
  
  int r, g, b;

  int value;
  boolean collected;    // indica se la monete è stata raccolta
  int scoreValue;

  Coin(int value) {
    this.value = value;
    this.collected = false;    // di base una moneta non è raccolta
    this.scoreValue = 10;
    
    r = 255;
    g = 255;
    b = 0;
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
  
  // verifica collsione
  // metodo differente dal quello di chest ed enemy
  void playerCollide(Player aPlayer) {
    if( aPlayer.spritePosition.x * currentLevel.tileSize < (spritePosition.x * currentLevel.tileSize) + sprite.width  &&
        (aPlayer.spritePosition.x * currentLevel.tileSize) + aPlayer.sprite.width > spritePosition.x * currentLevel.tileSize && 
        aPlayer.spritePosition.y * currentLevel.tileSize < (spritePosition.y * currentLevel.tileSize) + sprite.height && 
        (aPlayer.spritePosition.y * currentLevel.tileSize) + aPlayer.sprite.height > spritePosition.y * currentLevel.tileSize) {
        r = 0;
        b = 255;
        
        collect();  // raccogli la moneta
        p1.collectCoin();
        pickupCoin.play();
        p1.playerScore += scoreValue;
    }
  }
}
