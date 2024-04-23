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
  Item(PVector position, PImage sprite, String name) {
    super(position, sprite);
    this.name = name;
  }

  // costruttore degli oggetti curativi e delle armi
  Item(PVector position, PImage sprite, String name, boolean isHealer, int bonusHp, boolean isWeapon, int damage) {
    super(position, sprite);
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

  // metodo per il rilevamento delle collisioni ereditato da sprite
}
