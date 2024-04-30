class CollisionSystem {
  CollisionSystem() {
  }

  void init() {
    println("collision system inizializzato correttamente!");
  }

  // check di tutte le entita di gioco e verifica la collisione con la mappa
  void update() {
  }

  boolean check_collision(Sprite a, Sprite b) {
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
}
