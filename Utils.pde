// velocita sprite
float spriteSpeed = 1.5;

// gestione comandi
void handlePlayerMovement() {
  if (keyPressed) {
    int newY = (int) player.spritePosition.y;
    int newX = (int) player.spritePosition.x;
    
    if (keyCode == UP) {
      movePlayer(0, -spriteSpeed);
    } else if (keyCode == DOWN) {
      movePlayer(0, spriteSpeed);
    } else if (keyCode == LEFT) {
      movePlayer(-spriteSpeed, 0);
    } else if (keyCode == RIGHT) {
      movePlayer(spriteSpeed, 0);
    }
    
    player.spritePosition.x = newX;
    player.spritePosition.y = newY;
    
    // Verifica le collisioni prima di spostare il giocatore
    //if (!checkCollision(newX, newY, player, enemy)) {
    //  player.spritePosition.x = newX;
    //  player.spritePosition.y = newY;
    //}
  }
}

void movePlayer(float dx, float dy) {
  // Calcola le nuove coordinate del giocatore
  float newX = player.spritePosition.x + dx / (map.getTileSize() * zoom);
  float newY = player.spritePosition.y + dy / (map.getTileSize() * zoom);
  
  // Verifica se la nuova posizione è valida
  int roundedX = round(newX);
  int roundedY = round(newY);
  
  if (roundedX >= 0 && roundedX < map.getCols() && roundedY >= 0 && roundedY < map.getRows() && map.getMap()[roundedX][roundedY] != 0) {
    player.spritePosition.x = newX;
    player.spritePosition.y = newY;
  }
}
