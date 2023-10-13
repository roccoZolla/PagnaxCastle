Player p1;
Map map;

PImage player;

// Variabili per la posizione della camera
float cameraX = 0;
float cameraY = 0;
float zoom = 1.0;    // dimensione ideale
float easing = 0.1;

int cellX;
int cellY;

void setup() {  
  // dimensioni schermo
  size(1280, 720);
  
  map = new Map();
  map.setMap();
  
  player = loadImage("data/tile_0088.png");
  
  System.out.println(map.getStartRoom());
  System.out.println(map.getCols());
  System.out.println(map.getRows());
  System.out.println(map.getTileSize());
  
  p1 = new Player(1, 50, player);
  
  p1.setPosition(map.getStartRoom());
  
  p1.setPosition(map.getStartRoom());
  
  System.out.println(p1.getPosition());
}

void draw() {
  background(0); // Cancella lo schermo

  float targetCameraX = p1.getPosition().x * map.getTileSize() * zoom - width / 2;
  float targetCameraY = p1.getPosition().y * map.getTileSize() * zoom - height / 2;

  // Limita la telecamera in modo che non esca dalla mappa
  targetCameraX = constrain(targetCameraX, 0, map.getCols() * map.getTileSize() * zoom - width);
  targetCameraY = constrain(targetCameraY, 0, map.getRows() * map.getTileSize() * zoom - height);

  // Interpolazione per rendere il movimento della camera più fluido
  cameraX += (targetCameraX - cameraX) * easing;
  cameraY += (targetCameraY - cameraY) * easing;

  // Imposta la telecamera alla nuova posizione e applica il fattore di scala
  translate(-cameraX, -cameraY);
  scale(zoom);
  
  // Disegna la mappa
  map.showMap();

  // Gestione del movimento del giocatore
  handlePlayerMovement();

  // mostra il player
  p1.displayPlayer(map.getTileSize());
  
  
  // da fixare
  // Rileva la posizione del mouse rispetto alle celle
  cellX = floor(mouseX / (map.getTileSize() * zoom));
  cellY = floor(mouseY / (map.getTileSize() * zoom));
  System.out.println("Mouse cell coordinates: (" + cellX + "," + cellY);
  
  // Verifica se il mouse è sopra una casella valida
  if (cellX >= 0 && cellX < map.getCols() && cellY >= 0 && cellY < map.getRows()) {
    // Disegna i bordi della casella in bianco
    drawCellBorders(cellX, cellY);
  }
  
  String  objectAtMouse = map.getObjectAtCell(cellX, cellY);
  if (objectAtMouse != null) {
    fill(255); // Colore del testo (bianco)
    textAlign(LEFT, TOP); // Allinea il testo a sinistra e in alto
    textSize(24); // Imposta la dimensione del testo
    text(objectAtMouse, 20, 20); // Disegna il testo a una posizione desiderata (es. 20, 20)
  }
  
  float fps = frameRate;
  System.out.println(fps);
}
