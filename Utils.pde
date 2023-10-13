// velocita sprite
float spriteSpeed = 0.1;

// gestione comandi
void handlePlayerMovement() {
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
    
    else if(key == 'z') {
      if(zoom <= 5.0) zoom += 1.0;
    }

    else if(key == 'f') {
      zoom -= 1.0;
      
      if(zoom < 1.0) zoom = 1.0;
    }

    // Verifica se la nuova posizione è valida
    int roundedX = round(newX);
    int roundedY = round(newY);

    // check delle collisioni
    if (roundedX >= 0 && roundedX < map.getCols() && roundedY >= 0 && roundedY < map.getRows() &&
        map.getMap()[roundedX][roundedY] != 0 && 
        map.getMap()[roundedX][roundedY] != 4 &&
        map.getMap()[roundedX][roundedY] != 6 &&
        map.getMap()[roundedX][roundedY] != 7) {
      p1.getPosition().x = newX;
      p1.getPosition().y = newY;
    }
  }
}

// disegna i bordi delle celle su cui si trova il mouse
void drawCellBorders(float x, float y) {
  float leftX = x * map.getTileSize();
  float topY = y * map.getTileSize();
  float rightX = leftX + map.getTileSize();
  float bottomY = topY + map.getTileSize();
  
  noFill();
  if (map.getMap()[(int) x][(int) y] == 0) {
    stroke(255, 0, 0); // Rosso
  } else {
    stroke(255); // Bianco
  }
  rect(leftX, topY, rightX - leftX, bottomY - topY);
}
