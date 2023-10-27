class Item {
  PVector spritePosition;
  PImage sprite;

  int id;
  String name;
  boolean takeable = false;   // indica se un oggetto di puo raccogliere
  boolean useable = false;    // indica se un oggetto si puo usare
  boolean interactable = false;
  boolean healerable = false;    // indica se l'oggetto restituisce la vita
  int bonusHP = 0;              // se è hearable assegna un valore
  String description;

  // constructors
  Item(int id, String name) {
    this.id = id;
    this.name = name;
  }

  void display(PGraphics layer) {
    layer.image(sprite, spritePosition.x * currentLevel.tileSize, spritePosition.y * currentLevel.tileSize, sprite.width, sprite.height);
  }

  Item() {
    this.id = 0;
    this.name = "";
    this.takeable = false;
    this.useable = false;
    this.description = "";
  }

  Item(int id) {
    this.id = id;
  }

  Item(String name) {
    this.name = name;
  }

  // methods
  int getId() {
    return id;
  }

  String getName() {
    return name;
  }

  boolean isTakeable() {
    return takeable;
  }

  boolean isUseable() {
    return useable;
  }

  boolean isInteractable() {
    return interactable;
  }

  boolean isHealerable() {
    return healerable;
  }

  int getBonusHP() {
    return this.bonusHP;
  }

  String getDescription() {
    return description;
  }

  void setId(int id) {
    this.id = id;
  }

  void setName(String name) {
    this.name = name;
  }

  void setTakeable(boolean takeable) {
    this.takeable = takeable;
  }

  void setUseable(boolean useable) {
    this.useable = useable;
  }

  void setDescription(String description) {
    this.description = description;
  }

  void setInteractable(boolean interactable) {
    this.interactable = interactable;
  }

  void setHealerable(boolean healerable) {
    this.healerable = healerable;
  }

  void setBonusHP(int bonusHP) {
    this.bonusHP = bonusHP;
  }
}
