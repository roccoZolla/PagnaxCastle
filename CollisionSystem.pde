class CollisionSystem {
  Direction nonPuoiMuovertiPouInQuestaDirezione;

  CollisionSystem() {
  }

  void init() {
    println("collision system inizializzato correttamente!");
  }

  // check di tutte le entita di gioco e verifica la collisione con la mappa
  void update() {
    //int spriteWidth = p1.sprite.width;
    //int spriteHeight = p1.sprite.height;
    //int rows = currentLevel.cols;
    //int cols = currentLevel.rows;
    //int tileSize = currentLevel.tileSize;

    //float position_x = p1.position.x;
    //float position_y = p1.position.y;

    ////float centerX =  p1.position.x * tileSize + spriteWidth / 2;
    ////float centerY =  p1.position.y * tileSize + spriteHeight / 2;

    //// Calcola i limiti dello schermo visibile in termini di celle di mappa
    //int startX = floor((camera.x / (tileSize * camera.zoom)));
    //int startY = floor((camera.y / (tileSize * camera.zoom)));
    //int endX = ceil((camera.x + width) / (tileSize * camera.zoom));
    //int endY = ceil((camera.y + height) / (tileSize * camera.zoom));

    //// Assicurati che i limiti siano all'interno dei limiti della mappa
    //startX = constrain(startX, 0, cols - 1);
    //startY = constrain(startY, 0, rows - 1);
    //endX = constrain(endX, 0, cols);
    //endY = constrain(endY, 0, rows);

    //// devo sapere in che direzione non posso piu muovermi
    //for (int x = startX; x < endX; x++) {
    //  for (int y = startY; y < endY; y++) {

    //    if (isWall(x, y))
    //    {
    //      // lato destro giocatore - lato sinistro
    //      if ((position_x * tileSize + spriteWidth) >= ((x * tileSize)))
    //      {
    //        // println("collisione lato destro");
    //        p1.canMoveRIGHT = false;
    //      } else
    //      {
    //        p1.canMoveRIGHT = true;
    //      }

    //      // lato sinistro giocatore - lato destro
    //      if ((position_x * tileSize) <= (x  * tileSize + (spriteWidth)))
    //      {
    //        // println("collisione lato sinistro");
    //        p1.canMoveLEFT = false;
    //      } else
    //      {
    //        p1.canMoveLEFT = true;
    //      }

    //      // lato superiore giocatore - lato inferiore
    //      if ((position_y * tileSize) >= ((y * tileSize) + (spriteHeight)))
    //      {
    //        // println("collisione lato superiore");
    //        p1.canMoveUP = false;
    //      } else
    //      {
    //        p1.canMoveUP = true;
    //      }

    //      // lato inferiore giocatore - lato superiore
    //      if ((position_y  * tileSize + spriteHeight) <= ((y * tileSize)))
    //      {
    //        // println("collisione lato inferiore");
    //        p1.canMoveDOWN = false;
    //      } else
    //      {
    //        p1.canMoveDOWN = true;
    //      }



    //      //if (position_x * tileSize + (spriteWidth / 2) >= (x * tileSize) - (spriteWidth / 2) &&      // x1 + w1/2 > x2 - w2/2
    //      //  (position_x * tileSize) - (spriteWidth / 2) <= x * tileSize + (spriteWidth / 2) &&                               // x1 - w1/2 < x2 + w2/2
    //      //  position_y * tileSize + (spriteHeight / 2) >= (y * tileSize) - (spriteHeight / 2) &&                                      // y1 + h1/2 > y2 - h2/2
    //      //  (position_y * tileSize) - (spriteHeight / 2) <= y * tileSize + (spriteHeight / 2))
    //      //{
    //      //  nonPuoiMuovertiPouInQuestaDirezione = p1.direction;
    //      //  switch(nonPuoiMuovertiPouInQuestaDirezione)
    //      //  {
    //      //  case SOPRA:
    //      //    p1.canMoveUP = false;
    //      //    break;

    //      //  case GIU:
    //      //    p1.canMoveDOWN = false;
    //      //    break;

    //      //  case DESTRA:
    //      //    p1.canMoveRIGHT = false;
    //      //    break;

    //      //  case SINISTRA:
    //      //    p1.canMoveLEFT = false;
    //      //    break;
    //      //  }
    //      //}
    //    }



    //    //if (position_x * tileSize + (spriteWidth / 2) >= (x * tileSize) - (spriteWidth / 2) &&      // x1 + w1/2 > x2 - w2/2
    //    //  (position_x * tileSize) - (spriteWidth / 2) <= x * tileSize + (spriteWidth / 2) &&                               // x1 - w1/2 < x2 + w2/2
    //    //  position_y * tileSize + (spriteHeight / 2) >= (y * tileSize) - (spriteHeight / 2) &&                                      // y1 + h1/2 > y2 - h2/2
    //    //  (position_y * tileSize) - (spriteHeight / 2) <= y * tileSize + (spriteHeight / 2))
    //    //{


    //    //  switch(tileType)
    //    //  {
    //    //  case Utils.BACKGROUND_TILE_TYPE:
    //    //    println(nonPuoiMuovertiPouInQuestaDirezione);
    //    //    println(p1.direction);
    //    //    nonPuoiMuovertiPouInQuestaDirezione = p1.direction;

    //    //    if (p1.direction != nonPuoiMuovertiPouInQuestaDirezione)
    //    //    {
    //    //      break;
    //    //    }

    //    //    p1.velocity_x *= 0;
    //    //    p1.velocity_y *= 0;

    //    //    println("collisione sfondo");
    //    //    break;

    //    //  case Utils.WALL_PERIMETER_TILE_TYPE:
    //    //    nonPuoiMuovertiPouInQuestaDirezione = p1.direction;

    //    //    if (p1.direction == nonPuoiMuovertiPouInQuestaDirezione) {
    //    //      // Inverti la direzione di movimento
    //    //      p1.velocity_x *= -1;
    //    //      p1.velocity_y *= -1;
    //    //    }


    //    //    println("collisione muro");
    //    //    break;

    //    //  case Utils.CHEST_TILE_TYPE:
    //    //    nonPuoiMuovertiPouInQuestaDirezione = p1.direction;
    //    //    println(nonPuoiMuovertiPouInQuestaDirezione);
    //    //    println(p1.direction);

    //    //    if (p1.direction != nonPuoiMuovertiPouInQuestaDirezione)
    //    //    {
    //    //      break;
    //    //    }

    //    //    p1.velocity_x *= 0;
    //    //    p1.velocity_y *= 0;


    //    //    println("collisione chest");
    //    //    break;
    //    //  }
    //    //}
    //  }
    //}
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

  //private void check_collision_wall(Sprite a) {
  //  println("check collision wall");
  //  int spriteWidth = a.sprite.width;
  //  int spriteHeight = a.sprite.height;
  //  int rows = currentLevel.cols;
  //  int cols = currentLevel.rows;
  //  int tileSize = currentLevel.tileSize;

  //  // Calcola i limiti dello schermo visibile in termini di celle di mappa
  //  int startX = floor((camera.x / (tileSize * camera.zoom)));
  //  int startY = floor((camera.y / (tileSize * camera.zoom)));
  //  int endX = ceil((camera.x + width) / (tileSize * camera.zoom));
  //  int endY = ceil((camera.y + height) / (tileSize * camera.zoom));

  //  // Assicurati che i limiti siano all'interno dei limiti della mappa
  //  startX = constrain(startX, 0, cols - 1);
  //  startY = constrain(startY, 0, rows - 1);
  //  endX = constrain(endX, 0, cols);
  //  endY = constrain(endY, 0, rows);

  //  for (int x = startX; x < endX; x++) {
  //    for (int y = startY; y < endY; y++) {
  //      int tileType = currentLevel.map[x][y];

  //      println(tileType);

  //      if (p1.position.x * tileSize + (spriteWidth / 2) >= (x * currentLevel.tileSize) - (spriteWidth / 2) &&      // x1 + w1/2 > x2 - w2/2
  //        (p1.position.x * tileSize) - (spriteWidth / 2) <= x * currentLevel.tileSize + (spriteWidth / 2) &&                               // x1 - w1/2 < x2 + w2/2
  //        p1.position.y * tileSize + (spriteHeight / 2) >= (y * currentLevel.tileSize) - (spriteHeight / 2) &&                                      // y1 + h1/2 > y2 - h2/2
  //        (p1.position.y * tileSize) - (spriteHeight / 2) <= y * currentLevel.tileSize + (spriteHeight / 2))
  //      {
  //        println("collsione rilevata");
  //        switch(tileType)
  //        {
  //        case Utils.BACKGROUND_TILE_TYPE:
  //          p1.velocity_x *= 0.01;
  //          p1.velocity_y *= 0.01;
  //          // sfondo

  //          println("collisione sfondo");
  //          break;

  //        case Utils.WALL_PERIMETER_TILE_TYPE:
  //          p1.velocity_x *= 0.01;
  //          p1.velocity_y *= 0.01;

  //          println("collisione muro");
  //          break;

  //        case Utils.CHEST_TILE_TYPE:
  //          p1.velocity_x *= 0.01;
  //          p1.velocity_y *= 0.01;

  //          println("collisione chest");
  //          break;
  //        }

  //      }
  //    }
  //  }



  // se è un muro controlla la possibile collisione con lo sprite
  //if (isWall((int) aPosition.x, (int) aPosition.y))
  //{
  //  println("muro rilevato!");

  //  p1.velocity_x = 0;
  //  p1.velocity_y = 0;



  //  if (position.x * currentLevel.tileSize + (sprite.width / 2) >= (x * currentLevel.tileSize) - (sprite.width / 2) &&      // x1 + w1/2 > x2 - w2/2
  //    (position.x * currentLevel.tileSize) - (sprite.width / 2) <= x * currentLevel.tileSize + (sprite.width / 2) &&                               // x1 - w1/2 < x2 + w2/2
  //    position.y * currentLevel.tileSize + (sprite.height / 2) >= (y * currentLevel.tileSize) - (sprite.height / 2) &&                                      // y1 + h1/2 > y2 - h2/2
  //    (position.y * currentLevel.tileSize) - (sprite.height / 2) <= y * currentLevel.tileSize + (sprite.height / 2))
  //  {
  //    // println("collisione rilevata...");
  //  }
  //}
}

//private boolean checkCollision(Sprite a, Sprite b) {
//  // Verifica se i rettangoli si sovrappongono sugli assi X e Y
//  boolean collisionX = a.position.x + a.sprite.width >= b.position.x && b.position.x + b.sprite.width >= a.position.x;
//  boolean collisionY = a.position.y + a.sprite.height >= b.position.y && b.position.y + b.sprite.height >= a.position.y;

//  // Ritorna vero se c'è collisione sugli assi X e Y
//  return collisionX && collisionY;
//}

//class Box {
//  int x;
//  int y;
//  int boxWidth;
//  int boxHeight;
//}
