class Weapon extends Item {
  // classe che estende item e rappresenta le armi di gioco
  int damage;
  
  Weapon(String name, int damage) {
    super(name);
    this.damage = damage;
  }
  
  int getDamage() {
    return damage;
  }
}
