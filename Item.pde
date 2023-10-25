public class Item {
  PVector spritePosition;
  PImage sprite;
  
  private int id;
  private String name;
  private boolean takeable = false;   // indica se un oggetto di puo raccogliere
  private boolean useable = false;    // indica se un oggetto si puo usare
  private boolean interactable = false;
  private boolean healerable = false;    // indica se l'oggetto restituisce la vita
  int bonusHP = 0;              // se è hearable assegna un valore
  private String description;

  // constructors
  Item(int id, String name) {
    this.id = id;
    this.name = name;
  }
  
  void display(PGraphics layer) {
    layer.image(sprite, spritePosition.x * currentLevel.tileSize, spritePosition.y * currentLevel.tileSize, sprite.width, sprite.height);
  }

  public Item() {
    this.id = 0;
    this.name = "";
    this.takeable = false;
    this.useable = false;
    this.description = "";
  }

  public Item(int id) {
    this.id = id;
  }

  public Item(String name) {
    this.name = name;
  }

  // methods
  public int getId() {
    return id;
  }

  public String getName() {
    return name;
  }

  public boolean isTakeable() {
    return takeable;
  }

  public boolean isUseable() {
    return useable;
  }
  
  public boolean isInteractable() {
    return interactable;
  }
  
  public boolean isHealerable() {
    return healerable;
  }
  
  public int getBonusHP() {
    return this.bonusHP;
  }

  public String getDescription() {
    return description;
  }

  public void setId(int id) {
    this.id = id;
  }

  public void setName(String name) {
    this.name = name;
  }

  public void setTakeable(boolean takeable) {
    this.takeable = takeable;
  }

  public void setUseable(boolean useable) {
    this.useable = useable;
  }

  public void setDescription(String description) {
    this.description = description;
  }
  
  public void setInteractable(boolean interactable) {
    this.interactable = interactable;
  }  
  
  public void setHealerable(boolean healerable) {
    this.healerable = healerable;
  }
  
  public void setBonusHP(int bonusHP) {
    this.bonusHP = bonusHP;
  }
}
