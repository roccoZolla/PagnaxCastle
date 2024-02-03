class Item extends Sprite {
  // classe che rappresenta gli oggetti del gioco

  // cratteristiche
  // int id;
  String name;
  boolean isCollectible;
  // String description;

  // constructors
  Item(PVector position, PImage sprite, String name) {
    super(position, sprite);
    this.name = name;
  }

  // methods
  String getName() {
    return name;
  }
  void setName(String name) {
    this.name = name;
  }

  // metodo per il rilevamento delle collisioni ereditato da sprite
}
