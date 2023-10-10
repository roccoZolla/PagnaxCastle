// gestione comandi
void handlePlayerMovement() {
  if (keyPressed) {
    int newY = player.y;
    int newX = player.x;
    
    if (keyCode == UP) {
      newY -= spriteSpeed;
    } else if (keyCode == DOWN) {
      newY += spriteSpeed;
    } else if (keyCode == LEFT) {
      newX -= spriteSpeed;
    } else if (keyCode == RIGHT) {
      newX += spriteSpeed;
    }
    
    // Verifica le collisioni prima di spostare il giocatore
    if (!checkCollision(newX, newY, player, enemy)) {
      player.x = newX;
      player.y = newY;
    }
  }
}

// gestione collisioni
boolean checkCollision(int newX, int newY, Sprite sprite1, Sprite sprite2) {
  return !(newX + sprite1.img.width < sprite2.x || newX > sprite2.x + sprite2.img.width || newY + sprite1.img.height < sprite2.y || newY > sprite2.y + sprite2.img.height);
}
