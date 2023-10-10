Sprite player;
Sprite enemy;
float spriteSpeed = 2;

void setup() {
  // dimensioni schermo
  // size(400, 400);
  size(1280, 720);
  
  player = new Sprite("warrior", "data/tile_0088.png", width / 4, height / 2);
  enemy = new Sprite("enemy", "data/tile_0109.png", 3 * width / 4, height / 2);
}

void draw() {
  // Cancella lo schermo
  background(255); 
  
  // Gestione del movimento del giocatore
  handlePlayerMovement();
  
  // Disegna l'immagine associata all'oggetto Sprite sulla posizione (x, y) dell'oggetto
  player.display();
  enemy.display();
}
