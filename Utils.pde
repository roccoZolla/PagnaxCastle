// velocita sprite
float spriteSpeed = 1.0;

// 
int letterIndex = 0; // Indice della lettera corrente
boolean isTyping = true; // Indica se il testo sta ancora venendo digitato
int typingSpeed = 1; // Velocità di scrittura 2 quella ideale

// gestione comandi
void handlePlayerMovement(Level currentLevel) {
  if (keyPressed) {
    float newX = p1.getPosition().x;
    float newY = p1.getPosition().y;

    if (key == 'w' || key == 'W') {
      newY -= spriteSpeed;
    } else if (key == 's' || key == 'S') {
      newY += spriteSpeed;
    } else if (key == 'a' || key == 'A') {
      newX -= spriteSpeed;
    } else if (key == 'd' || key == 'D') {
      newX += spriteSpeed;
    }

    // Verifica se la nuova posizione è valida
    int roundedX = round(newX);
    int roundedY = round(newY);

    // check delle collisioni
    if (roundedX >= 0 && roundedX < currentLevel.getCols() && roundedY >= 0 && roundedY < currentLevel.getRows() &&
        currentLevel.getMap()[roundedX][roundedY] != 0 && 
        currentLevel.getMap()[roundedX][roundedY] != 4 &&
        currentLevel.getMap()[roundedX][roundedY] != 6 &&
        currentLevel.getMap()[roundedX][roundedY] != 7) {
      p1.getPosition().x = newX;
      p1.getPosition().y = newY;
    }
  }
}

// disegna i bordi delle celle su cui si trova il mouse
void drawCellBorders(float x, float y, Level currentLevel) {
  float leftX = x * currentLevel.getTileSize();
  float topY = y * currentLevel.getTileSize();
  float rightX = leftX + currentLevel.getTileSize();
  float bottomY = topY + currentLevel.getTileSize();
  
  noFill();
  if (currentLevel.getMap()[(int) x][(int) y] == 0) {
    stroke(255, 0, 0); // Rosso
  } else {
    stroke(255); // Bianco
  }
  rect(leftX, topY, rightX - leftX, bottomY - topY);
}
