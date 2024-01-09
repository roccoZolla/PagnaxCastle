class Item {
  // classe che rappresenta gli oggetti del gioco
  // es. chiavi o altri oggetti
  PVector spritePosition;
  PImage sprite;

  // acratteristiche
  int id;
  String name;
  // String description;

  // constructors
  Item(String name) {
    this.name = name;
  }
  
  Item(int id, String name) {
    this.id = id;
    this.name = name;
  }
  
  void display(PGraphics layer) {
    // hitbox giocatore
    layer.noFill(); // Nessun riempimento
    layer.stroke(255); // Colore del bordo bianco
    
    float centerX = spritePosition.x * currentLevel.tileSize + sprite.width / 2;
    float centerY = spritePosition.y * currentLevel.tileSize + sprite.height / 2;
    
    layer.rectMode(CENTER); // Imposta il rectMode a center
    layer.rect(centerX, centerY, sprite.width, sprite.height);
    
    layer.stroke(60);
    layer.point(centerX, centerY);
    
    layer.imageMode(CENTER); // Imposta l'imageMode a center
    layer.image(sprite, centerX, centerY, sprite.width, sprite.height);
    
    // layer.image(sprite, spritePosition.x * currentLevel.tileSize, spritePosition.y * currentLevel.tileSize, sprite.width, sprite.height);
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
}
