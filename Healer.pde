class Healer extends Item {
  // classe che rappresenta la classe degli oggetti curativi 
  int bonusHp;
  
  Healer(PVector position, PImage sprite, String name, int bonusHp) {
    super(position, sprite, name);
    this.bonusHp = bonusHp;
  }
  
  int getBonusHp() {
    return bonusHp;
  }
}
