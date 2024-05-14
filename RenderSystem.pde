class RenderSystem {
  // layer
  PGraphics gameLayer;
  PGraphics spritesLayer;
  PGraphics maskLayer;

  // raggio maschera
  float maskRadius;

  int tileSize = 16;

  // triggers
  boolean isAttacking = false;

  boolean isCollidingWithChest = false;
  FBody collidingChest;

  boolean isCollidingWithItem = false;
  FBody collidingItem;

  // boolean maxHpTrigger;  // attiva la scritta "salute al massimo"

  RenderSystem() {
  }

  void setCollidingChest(FBody collidingChest) {
    this.collidingChest = collidingChest;
  }

  void setCollidingItem(FBody collidingItem) {
    this.collidingItem = collidingItem;
  }

  // inizializza i layer
  void init() {
    // inizializza i layer
    gameLayer = createGraphics(width, height);
    spritesLayer = createGraphics(width, height);
    maskLayer = createGraphics(width, height);

    // inizializza la camera
    camera = new Camera();

    maskRadius = 60;

    println("renderSystem inizializzato correttamente!");
  }

  // metodo display della classe game
  void update() {
    // aggiorna la camera
    camera.update();

    // disegna il game layer
    // mappa di gioco
    updateGameLayer();

    // disegna lo sprites layer
    // giocatore, nemici, casse
    updateSpritesLayer();

    // disegna il mask layer se non ci troviamo nel livello finale
    // maschera
    // if (!isBossLevel) drawMaskLayer();
    // updateMaskLayer();
  }

  void applyTorchEffect() {
    maskRadius += 30;  // valore provvisorio
  }

  private void updateGameLayer() {
    gameLayer.beginDraw();
    gameLayer.background(0);
    // Imposta la telecamera alla nuova posizione e applica il fattore di scala
    gameLayer.translate(-camera.x, -camera.y);
    gameLayer.scale(camera.zoom);
    gameLayer.imageMode(CENTER);  // imposto l'image mode a center

    // Disegna la mappa del livello corrente
    game.level.display(gameLayer); // renderizza il 4,6 % della mappa NON DEFINITIVO
    // displayLevel();

    gameLayer.endDraw();

    image(gameLayer, 0, 0);
  }

  private void updateSpritesLayer() {
    spritesLayer.beginDraw();
    spritesLayer.background(255, 0);
    // spritesLayer.background(255);
    spritesLayer.translate(-camera.x, -camera.y);
    spritesLayer.scale(camera.zoom);
    spritesLayer.imageMode(CENTER);
    
    // aggiungere logica per cui quando si è nel livello del boss
    // non vengono eseguite
    displayCharacter();

    //// se il giocatore sta attaccando mostra l'arma
    if (isAttacking) {
      displayWeaponPlayer();
    }

    if (!game.IsBossLevel()) {
      displayChests();
      displayCoins();
      displayDropItems();
    }

    //if (!game.isBossLevel) {
    //  displayEnemies();
    //  displayChests();
    //  displayCoins();
    //  displayDropItems();
    //} else {
    //  game.boss.display(spritesLayer);
    //}

    // debug
    // game.world.drawDebug(spritesLayer);
    // game.world.draw(spritesLayer);


    spritesLayer.endDraw();
    image(spritesLayer, 0, 0);
  }

  private void updateMaskLayer() {
    maskLayer.beginDraw();
    maskLayer.background(0, 255);
    maskLayer.blendMode(REPLACE);

    maskLayer.translate(-camera.x, -camera.y);
    maskLayer.scale(camera.zoom);

    float centerX = p1.getPosition().x;
    float centerY = p1.getPosition().y;

    maskLayer.fill(255, 0);
    maskLayer.ellipseMode(RADIUS);
    maskLayer.ellipse(centerX, centerY, maskRadius, maskRadius);

    maskLayer.endDraw();

    image(maskLayer, 0, 0);
  }

  // aggiorna i layer con le dimensioni aggiornate della finestra
  void updateWindowsScreen() {
    gameLayer = createGraphics(width, height);
    spritesLayer = createGraphics(width, height);
    maskLayer = createGraphics(width, height);
  }

  private void displayCharacter()
  {
    Iterator<Character> iterator = game.characters.iterator();

    while (iterator.hasNext()) {
      Character character = iterator.next();

      if (isInVisibleArea(character.getPosition()) /*&&
       !character.IsDead()*/) {
        character.display(spritesLayer);
      }
    }
  }

  private void displayWeaponPlayer()
  {
    PVector new_position = p1.getPosition().copy();

    new_position.x = (new_position.x - tileSize/2) / tileSize;
    new_position.y = (new_position.y - tileSize/2) / tileSize;

    switch(p1.getDirection())
    {
    case UP:
      new_position.y -= 1;
      break;

    case DOWN:
      new_position.y += 1;
      break;

    case RIGHT:
      new_position.x += 1;
      break;

    case LEFT:
      new_position.x -= 1;
      break;
    }

    p1.getWeapon().updatePosition(new_position);
    p1.getWeapon().display(spritesLayer);
  }

  // disegna solo cio che vede il giocatore
  // da spostare nel render system
  private void displayLevel() {
    //// Calcola i limiti dello schermo visibile in termini di celle di mappa
    //int startX = floor((camera.x / (Utils.TILE_SIZE * camera.zoom)));
    //int startY = floor((camera.y / (Utils.TILE_SIZE * camera.zoom)));
    //int endX = ceil((camera.x + width) / (Utils.TILE_SIZE * camera.zoom));
    //int endY = ceil((camera.y + height) / (Utils.TILE_SIZE * camera.zoom));

    //// Assicurati che i limiti siano all'interno dei limiti della mappa
    //startX = constrain(startX, 0, game.level.cols - 1);
    //startY = constrain(startY, 0, game.level.rows - 1);
    //endX = constrain(endX, 0, game.level.cols);
    //endY = constrain(endY, 0, game.level.rows);

    //for (int x = startX; x < endX; x++) {
    //  for (int y = startY; y < endY; y++) {
    //    int tileType = game.level.map[x][y];

    //    float centerX = x * Utils.TILE_SIZE + Utils.TILE_SIZE / 2;
    //    float centerY = y * Utils.TILE_SIZE + Utils.TILE_SIZE / 2;

    //    switch(tileType) {
    //    case Utils.BACKGROUND_TILE_TYPE:
    //      // sfondo
    //      break;

    //    case Utils.FLOOR_TILE_TYPE:
    //      // pavimento
    //      gameLayer.image(game.level.floorImage, centerX, centerY, Utils.TILE_SIZE, Utils.TILE_SIZE);
    //      break;

    //    case Utils.START_ROOM_TILE_TYPE:
    //      // Imposta l'immagine per la stanza iniziale (nero)
    //      gameLayer.image(game.level.floorImage, centerX, centerY, Utils.TILE_SIZE, Utils.TILE_SIZE);
    //      break;

    //    case Utils.STAIRS_TILE_TYPE:
    //      // scale per il piano successivo
    //      gameLayer.image(game.level.stairsNextFloorImage, centerX, centerY, Utils.TILE_SIZE, Utils.TILE_SIZE);
    //      break;

    //    case Utils.WALL_PERIMETER_TILE_TYPE:
    //      // muri perimetrali
    //      gameLayer.image(game.level.wallImageNorth, centerX, centerY, Utils.TILE_SIZE, Utils.TILE_SIZE);
    //      break;

    //    case Utils.HALLWAY_TILE_TYPE:
    //      // corridoio
    //      gameLayer.image(game.level.hallwayImage, centerX, centerY, Utils.TILE_SIZE, Utils.TILE_SIZE);
    //      break;

    //    case Utils.CHEST_TILE_TYPE:
    //      // ci sta tenerlo sono statiche le casse
    //      // tesori
    //      gameLayer.image(game.level.floorImage, centerX, centerY, Utils.TILE_SIZE, Utils.TILE_SIZE);
    //      break;

    //    case Utils.PEAKS_TILE_TYPE:
    //      // peaks trap
    //      gameLayer.image(game.level.peaksTrapImage, centerX, centerY, Utils.TILE_SIZE, Utils.TILE_SIZE);
    //      break;
    //    }
    //  }
    //}
  }

  // da spostare nel render system
  // da rivedere
  void displayChests() {
    for (Chest chest : game.level.treasures)
    {
      if (isInVisibleArea(chest.getPosition()))
      {
        // mostra le chest nell'area visibile
        chest.display(spritesLayer);

        if (isCollidingWithChest)
        {
          if (chest.getBox() == collidingChest)
          {
            // da sistemare ma ci sta
            if ((p1.numberOfSilverKeys > 0 || p1.numberOfGoldenKeys > 0) && !chest.isOpen())
            {
              chest.displayHitbox(spritesLayer);

              // disegna la lettera che indica il tasto per aprire la cassa
              float letterImageX = (chest.getPosition().x);
              float letterImageY = (chest.getPosition().y - 20); // Regola l'offset verticale a tuo piacimento
              spritesLayer.image(letter_k, letterImageX, letterImageY);
            } else
            {
              float crossImageX = (p1.getPosition().x);
              float crossImageY = (p1.getPosition().y - 20); // Regola l'offset verticale a tuo piacimento
              spritesLayer.image(cross_sprite, crossImageX, crossImageY);
            }
          }
        }
      }
    }
  }

  private void displayCoins() {
    for (Coin coin : game.level.coins)
    {
      if (isInVisibleArea(coin.getPosition())
        && !coin.IsCollected())
      {
        coin.display(spritesLayer);
      }
    }
  }

  private void displayDropItems() {
    for (Item dropItem : game.dropItems)
    {
      if (isInVisibleArea(dropItem.getPosition())
        && !dropItem.IsCollected())
      {
        // mostra le monete nell'area visibile
        dropItem.display(spritesLayer);

        if (dropItem.getBox() == collidingItem)
        {
          // se sta collidendo con l'oggetto
          if (isCollidingWithItem)
          {
            dropItem.displayHitbox(spritesLayer);

            // aggiungi disegno della lettera
            if (dropItem.IsCollectible())
            {
              // disegna la lettera ch eindica il tasto per interagire con l'item
              float letterImageX = (dropItem.getPosition().x);
              float letterImageY = (dropItem.getPosition().y - 20); // Regola l'offset verticale a tuo piacimento
              spritesLayer.image(letter_k, letterImageX, letterImageY);

              // aggiungi codice per l'arma
              if (dropItem.IsWeapon())
              {
                // se l'arma droppata è piu forte di quella del giocatore disegna l'up buff
                if (dropItem.getDamage() > p1.weapon.getDamage())
                {
                  float imageX = (dropItem.getPosition().x - 20);
                  float imageY = (dropItem.getPosition().y - 20); // Regola l'offset verticale a tuo piacimento
                  spritesLayer.image(up_buff, imageX, imageY);
                } else  // altrimenti disegna il down buff, l'arma droppata è piu debole di quella del giocatore
                {
                  float imageX = (dropItem.getPosition().x - 20);
                  float imageY = (dropItem.getPosition().y - 20); // Regola l'offset verticale a tuo piacimento
                  spritesLayer.image(down_buff, imageX, imageY);
                }
              }
            }
          }
        }
      }
    }
  }
}
