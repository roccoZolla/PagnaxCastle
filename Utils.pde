// velocita sprite
float spriteSpeed = 1.5;

// gestione comandi
void handlePlayerMovement() {
  if (keyPressed) {
    int newY = (int) p1.getPosition().y;
    int newX = (int) p1.getPosition().x;
    
    if (keyCode == UP) {
      movePlayer(0, -spriteSpeed);
    } else if (keyCode == DOWN) {
      movePlayer(0, spriteSpeed);
    } else if (keyCode == LEFT) {
      movePlayer(-spriteSpeed, 0);
    } else if (keyCode == RIGHT) {
      movePlayer(spriteSpeed, 0);
    }
    
    p1.getPosition().x = newX;
    p1.getPosition().y = newY;
    
  }
}

void movePlayer(float dx, float dy) {
  // Calcola le nuove coordinate del giocatore
  float newX = p1.getPosition().x + dx / (map.getTileSize() * zoom);
  float newY = p1.getPosition().y + dy / (map.getTileSize() * zoom);
  
  // Verifica se la nuova posizione è valida
  int roundedX = round(newX);
  int roundedY = round(newY);
  
  if (roundedX >= 0 && roundedX < map.getCols() && roundedY >= 0 && roundedY < map.getRows() && 
  map.getMap()[roundedX][roundedY] != 0) {
    p1.getPosition().x = newX;
    p1.getPosition().y = newY;
  }
}
