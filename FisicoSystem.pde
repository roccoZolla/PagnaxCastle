// classe che gestisce la fisica di gioco
class FisicoSystem {
  FisicoSystem() {
  }
  
  void init() {
    println("fisicoSystem inizializzato correttamente");
  }

  // da estendere anche ai nemici
  // da fixare
  void update() {
    p1.position.x += p1.velocity_x;
    p1.position.y += p1.velocity_y;
    
    p1.velocity_x = 0;
    p1.velocity_y = 0;
  }
}
