class Healer extends Item {
  // classe che rappresenta la classe degli oggetti curativi 
  int bonusHp;
  
  Healer(String name, int bonusHp) {
    super(name);
    this.bonusHp = bonusHp;
  }
  
  int getBonusHp() {
    return bonusHp;
  }
}
