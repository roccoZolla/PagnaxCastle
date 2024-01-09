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
    // layer.rectMode(CENTER);
    layer.image(sprite, spritePosition.x * currentLevel.tileSize, spritePosition.y * currentLevel.tileSize, sprite.width, sprite.height);
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
