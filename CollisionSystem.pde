class CollisionSystem {
  CollisionSystem() {
  }

  void init() {
    println("collision system inizializzato correttamente!");
  }

  // check di tutte le entita di gioco e verifica la collisione con la mappa
  void update() {
    check_collision_wall(p1);
  }

  boolean sprite_collision(Sprite a, Sprite b) {
    PVector aPosition = a.getPosition();
    PImage aSprite = a.getSprite();

    PVector bPosition = b.getPosition();
    PImage bSprite = b.getSprite();

    if (aPosition.x * currentLevel.tileSize + (aSprite.width / 2) >= (bPosition.x * currentLevel.tileSize) - (bSprite.width / 2)  &&      // x1 + w1/2 > x2 - w2/2
      (aPosition.x * currentLevel.tileSize) - (aSprite.width / 2) <= bPosition.x * currentLevel.tileSize + (bSprite.width / 2) &&                               // x1 - w1/2 < x2 + w2/2
      aPosition.y * currentLevel.tileSize + (aSprite.height / 2) >= (bPosition.y * currentLevel.tileSize) - (bSprite.height / 2) &&                                      // y1 + h1/2 > y2 - h2/2
      (aPosition.y * currentLevel.tileSize) - (aSprite.height / 2) <= bPosition.y * currentLevel.tileSize + (bSprite.height / 2)) {                              // y1 - h1/2 < y2 + h2/2
      return true;
    }

    return false;
  }

  private void check_collision_wall(Sprite a) {
    PVector aPosition = a.getPosition();
    // se è un muro controlla la possibile collisione con lo sprite
    if (isWall((int) aPosition.x, (int) aPosition.y)) 
    {
      //println("è un muro...");

      //if (position.x * currentLevel.tileSize + (sprite.width / 2) >= (x * currentLevel.tileSize) - (sprite.width / 2)  &&      // x1 + w1/2 > x2 - w2/2
      //  (position.x * currentLevel.tileSize) - (sprite.width / 2) <= x * currentLevel.tileSize + (sprite.width / 2) &&                               // x1 - w1/2 < x2 + w2/2
      //  position.y * currentLevel.tileSize + (sprite.height / 2) >= (y * currentLevel.tileSize) - (sprite.height / 2) &&                                      // y1 + h1/2 > y2 - h2/2
      //  (position.y * currentLevel.tileSize) - (sprite.height / 2) <= y * currentLevel.tileSize + (sprite.height / 2)) {
      //  // println("collisione rilevata...");
      //  return true;
      //}
      a.position.x += 0;
      a.position.y += 0;
    }
  }

  //private boolean checkCollision(Sprite a, Sprite b) {
  //  // Verifica se i rettangoli si sovrappongono sugli assi X e Y
  //  boolean collisionX = a.position.x + a.sprite.width >= b.position.x && b.position.x + b.sprite.width >= a.position.x;
  //  boolean collisionY = a.position.y + a.sprite.height >= b.position.y && b.position.y + b.sprite.height >= a.position.y;

  //  // Ritorna vero se c'è collisione sugli assi X e Y
  //  return collisionX && collisionY;
  //}
}

//class Box {
//  int x;
//  int y;
//  int boxWidth;
//  int boxHeight;
//}
