Player p1;
Sprite player;
Sprite enemy;

// Variabili per la posizione della camera
float cameraX = 0;
float cameraY = 0;

void setup() {
  // dimensioni schermo
  size(1280, 720);
  
  player = new Sprite("warrior", "data/tile_0088.png", width / 4, height / 2);
  p1 = new Player(50, player);
  
  enemy = new Sprite("enemy", "data/tile_0109.png", 3 * width / 4, height / 2);
}

void draw() {
  // Calcola la posizione della camera in modo che il giocatore sia al centro della finestra
  float targetCameraX = p1.getSprite().x - width / 2;
  float targetCameraY = p1.getSprite().y - height / 2;
  
  // Riduci gradualmente la posizione attuale della camera verso la posizione target
  float easing = 0.2; // Regola questo valore per cambiare la velocità dell'arrivo della camera
  cameraX += (targetCameraX - cameraX) * easing;
  cameraY += (targetCameraY - cameraY) * easing;
  
  // Cancella lo schermo
  background(255); 
  
  // Sposta tutto ciò che viene disegnato sulla tela in base alla posizione della camera
  translate(-cameraX, -cameraY);
  
  // Gestione del movimento del giocatore
  handlePlayerMovement();
  
  // Disegna l'immagine associata all'oggetto Sprite sulla posizione (x, y) dell'oggetto
  player.display();
  enemy.display();
}
