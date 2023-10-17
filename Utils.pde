// velocita sprite
float spriteSpeed = 1;

// 
int letterIndex = 0; // Indice della lettera corrente
boolean isTyping = true; // Indica se il testo sta ancora venendo digitato
int typingSpeed = 2; // Velocità di scrittura 

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

void drawStory(String storyText) {
  // cancella lo schermo
  background(0);
  
  System.out.println("istyping: " + isTyping);
  System.out.println("letter index: " + letterIndex);
  System.out.println(storyText.substring(0, letterIndex));
  
  // Mostra il testo narrativo con l'effetto macchina da scrivere
  fill(255);
  textAlign(CENTER, CENTER);
  textSize(24);
  text(storyText.substring(0, letterIndex), width / 2, height / 2);

  if (isTyping) {
    // Continua a scrivere il testo
    if (frameCount % typingSpeed == 0) {
      if (letterIndex < storyText.length()) {
        letterIndex++;
      } else {
        isTyping = false;
      }
    }
  } else {
    textSize(16);
    text("\nPremi un tasto per continuare", width / 2, height - 50);
  }
}

void keyPressed() {
  if (screen_state == STORY_SCREEN && !isTyping) {
    screen_state = GAME_SCREEN;
    
    // reimposta le variabili
    letterIndex = 0;
    isTyping = true;
  }
}
