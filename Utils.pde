// velocita sprite
float spriteSpeed = 2;

// gestione comandi
void handlePlayerMovement() {
  if (keyPressed) {
    int newY = (int) player.spritePosition.y;
    int newX = (int) player.spritePosition.x;
    
    if (keyCode == UP) {
      newY -= spriteSpeed;
    } else if (keyCode == DOWN) {
      newY += spriteSpeed;
    } else if (keyCode == LEFT) {
      newX -= spriteSpeed;
    } else if (keyCode == RIGHT) {
      newX += spriteSpeed;
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

// gestione collisioni
boolean checkCollision(int newX, int newY, Sprite sprite1, Sprite sprite2) {
  return !(newX + sprite1.img.width < sprite2.spritePosition.x ||
          newX > sprite2.spritePosition.x + sprite2.img.width ||
          newY + sprite1.img.height < sprite2.spritePosition.y ||
          newY > sprite2.spritePosition.y + sprite2.img.height);
}
