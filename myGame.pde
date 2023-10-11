Player p1;
Sprite player;

Map map;

// Variabili per la posizione della camera
float cameraX = 0;
float cameraY = 0;
float zoom = 1.0;    // dimensione ideale
float easing = 0.1;

void setup() {
  // dimensioni schermo
  size(1280, 720);
  
  map = new Map();
  map.setMap();
  
  player = new Sprite("warrior", "data/tile_0088.png");
  
  System.out.println(map.getStartRoom());
  System.out.println(map.getCols());
  System.out.println(map.getRows());
  System.out.println(map.getTileSize());
  System.out.println(player.spritePosition);
  
  p1 = new Player(50, player);
  
  p1.getSprite().setSpritePosition(map.getStartRoom());
  
  // enemy = new Sprite("enemy", "data/tile_0109.png", 3 * width / 4, height / 2);
}

void draw() {
  // Cancella lo schermo
  background(0); 
  
  float targetCameraX = p1.getSprite().spritePosition.x * map.getTileSize() * zoom - width / 2;
  float targetCameraY = p1.getSprite().spritePosition.y * map.getTileSize() * zoom - height / 2;
  
  // Limita la telecamera in modo che non esca dalla mappa
  targetCameraX = constrain(targetCameraX, 0, map.getCols() * map.getTileSize() * zoom - width);
  targetCameraY = constrain(targetCameraY, 0, map.getRows() * map.getTileSize() * zoom - height);
  
  // Interpolazione per rendere il movimento della camera più fluido
  cameraX += (targetCameraX - cameraX) * easing;
  cameraY += (targetCameraY - cameraY) * easing;
  
  // Imposta la telecamera alla nuova posizione e applica il fattore di scala
  translate(-cameraX, -cameraY);
  scale(zoom);
  
  // Gestione del movimento del giocatore
  handlePlayerMovement();
  
  // disegna la mappa
  map.showMap();
  
  // Disegna l'immagine associata all'oggetto Sprite sulla posizione (x, y) dell'oggetto
  player.display();
}
