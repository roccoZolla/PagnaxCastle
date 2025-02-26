class Item extends Sprite {
  // classe che rappresenta gli oggetti del gioco
  // cratteristiche
  // int id;
  private String name;
  private boolean isCollectible = true;    // per vedere se l'oggetto è collezionabile, si puo raccogliere, di base è sempre true
  private boolean isCollected = false;

  private boolean isHealer = false; // è un oggetto curativo
  private boolean isWeapon = false; // è un'arma?

  private int bonusHp = 0;  // effetto curativo dell'oggetto
  private int damage = 0;  // danno dell'oggetto

  // String description;

  // constructors
  Item() {
  }

  Item(PImage sprite, String name) {
    super();

    // sprite
    this.sprite = sprite;

    // box settings
    box = new FBox(SPRITE_SIZE, SPRITE_SIZE);
    box.setName("Item");
    box.setFillColor(10);
    box.setAllowSleeping(true);  // permette al motore fisico di "addormentare" l'oggetto -> risparmio di risorse
    box.setRotatable(false);
    box.setFriction(0.5);
    box.setRestitution(0.2);
    box.setSensor(true);  // è un sensore

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
    box.setName("Item");
    box.setFillColor(10);
    box.setAllowSleeping(true);  // permette al motore fisico di "addormentare" l'oggetto -> risparmio di risorse
    box.setRotatable(false);
    box.setSensor(true);  // è un sensore

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

  boolean IsWeapon() {
    return isWeapon;
  }

  void setWeapon(boolean isWeapon) {
    this.isWeapon = isWeapon;

    //box.setName("Weapon");
    //box.setFriction(0.5);
    //box.setRestitution(0.2);
    //box.setSensor(false);  // non è un sensore
  }

  boolean IsHealer() {
    return isHealer;
  }

  void setCollected() {
    this.isCollected = true;
  }

  boolean IsCollected() {
    return isCollected;
  }

  boolean IsCollectible() {
    return isCollectible;
  }

  // metodo per il rilevamento delle collisioni ereditato da sprite
}
