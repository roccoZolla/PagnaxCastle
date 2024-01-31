class Weapon extends Item {
  // classe che estende item e rappresenta le armi di gioco
  int damage;

  Weapon(PVector position, PImage sprite, String name, int damage) {
    super(position, sprite, name);
    this.damage = damage;
  }

  int getDamage() {
    return damage;
  }
}
