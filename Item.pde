class Item extends Sprite {
  // classe che rappresenta gli oggetti del gioco
  // cratteristiche
  // int id;
  String name;
  boolean isCollectible = true;    // per vedere se l'oggetto è collezionabile, si puo raccogliere, di base è sempre true

  boolean isHealer = false; // è un oggetto curativo
  boolean isWeapon = false; // è un'arma?

  int bonusHp = 0;  // effetto curativo dell'oggetto
  int damage = 0;  // danno dell'oggetto

  // String description;

  // constructors
  Item() {}
  
  Item(PImage sprite, String name) {
    super();
    
    // sprite
    this.sprite = sprite;
    
    // box settings
    box = new FBox(SPRITE_SIZE, SPRITE_SIZE);
    box.setStatic(true);
    box.setFriction(0.8);
    box.setRestitution(0.1);
    
    // charateristics
    this.name = name;
  }

  // costruttore degli oggetti curativi e delle armi
  Item(PImage sprite, String name, boolean isHealer, int bonusHp, boolean isWeapon, int damage) {
    super();
    
    // sprite
    this.sprite = sprite;
    
    // box settings
    box = new FBox(SPRITE_SIZE, SPRITE_SIZE);
    box.setStatic(true);
    box.setFriction(0.8);
    box.setRestitution(0.1);
    
    // charateristics
    this.name = name;
    
    this.isHealer = isHealer;
    this.isWeapon = isWeapon;
    this.bonusHp = bonusHp;
    this.damage = damage;
  }

  // methods
  String getName() {
    return name;
  }
  void setName(String name) {
    this.name = name;
  }
  
  int getBonusHp() {
    return bonusHp;
  }
  
  int getDamage() {
    return damage;
  }
  
  boolean isWeapon() {
    return isWeapon;
  }
  
  boolean isHealer() {
    return isHealer;
  }

  // metodo per il rilevamento delle collisioni ereditato da sprite
}
