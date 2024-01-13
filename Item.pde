class Item {
  // classe che rappresenta gli oggetti del gioco
  // es. chiavi o altri oggetti
  PVector spritePosition;
  PImage sprite;

  // acratteristiche
  int id;
  String name;
  boolean isCollectible;
  // String description;

  // constructors
  Item(String name) {
    this.name = name;
  }
  
  Item(int id, String name) {
    this.id = id;
    this.name = name;
  }
  
  void display() {
    // hitbox giocatore
    spritesLayer.noFill(); // Nessun riempimento
    spritesLayer.stroke(255); // Colore del bordo bianco
    
    float centerX = spritePosition.x * currentLevel.tileSize + sprite.width / 2;
    float centerY = spritePosition.y * currentLevel.tileSize + sprite.height / 2;
    
    // hitbox
    //layer.rectMode(CENTER); // Imposta il rectMode a center
    //layer.rect(centerX, centerY, sprite.width, sprite.height);
    
    //layer.stroke(60);
    //layer.point(centerX, centerY);
    
    spritesLayer.imageMode(CENTER); // Imposta l'imageMode a center
    spritesLayer.image(sprite, centerX, centerY, sprite.width, sprite.height);
    
    // layer.image(sprite, spritePosition.x * currentLevel.tileSize, spritePosition.y * currentLevel.tileSize, sprite.width, sprite.height);
  }
  
  void displayHitbox() {
    spritesLayer.noFill(); // Nessun riempimento
    spritesLayer.stroke(255); // Colore del bordo bianco
    spritesLayer.rectMode(CENTER);
    spritesLayer.rect(spritePosition.x * currentLevel.tileSize + (sprite.width/2), spritePosition.y * currentLevel.tileSize + (sprite.height / 2), sprite.width, sprite.height);
  }
  
  // methods
  int getId() {
    return id;
  }

  String getName() {
    return name;
  }

  void setId(int id) {
    this.id = id;
  }

  void setName(String name) {
    this.name = name;
  }
  
  // metodo per il rilevamento delle collisioni
  boolean playerCollide(Player aPlayer) { 
    if(aPlayer.spritePosition.x * currentLevel.tileSize + (aPlayer.sprite.width / 2) >= (spritePosition.x * currentLevel.tileSize) - (sprite.width / 2)  &&      // x1 + w1/2 > x2 - w2/2
        (aPlayer.spritePosition.x * currentLevel.tileSize) - (aPlayer.sprite.width / 2) <= spritePosition.x * currentLevel.tileSize + (sprite.width / 2) &&                               // x1 - w1/2 < x2 + w2/2
        aPlayer.spritePosition.y * currentLevel.tileSize + (aPlayer.sprite.height / 2) >= (spritePosition.y * currentLevel.tileSize) - (sprite.height / 2) &&                                      // y1 + h1/2 > y2 - h2/2
        (aPlayer.spritePosition.y * currentLevel.tileSize) - (aPlayer.sprite.height / 2) <= spritePosition.y * currentLevel.tileSize + (sprite.height / 2)) {                              // y1 - h1/2 < y2 + h2/2
          return true;
    }
    
    return false;
  }
}
