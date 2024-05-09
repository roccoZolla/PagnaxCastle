class RenderSystem {
  // layer
  PGraphics gameLayer;
  PGraphics spritesLayer;
  PGraphics maskLayer;

  // raggio maschera
  float maskRadius;

  // triggers
  boolean isCollidingWithChest = false;
  boolean isPossibleToOpenChest = false;        // trigger che attiva il disegno della k quando si puo aprire una chest

  boolean drawUpBuff;
  boolean drawDownBuff;
  boolean drawInteractableLetter;  // trigger che attiva il disegno della lettera di interazione
  boolean maxHpTrigger;  // attiva la scritta "salute al massimo"

  RenderSystem() {
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
    //updateMaskLayer();
  }

  private void updateGameLayer() {
    gameLayer.beginDraw();
    gameLayer.background(0);
    // Imposta la telecamera alla nuova posizione e applica il fattore di scala
    gameLayer.translate(-camera.x, -camera.y);
    gameLayer.scale(camera.zoom);
    gameLayer.imageMode(CENTER);  // imposto l'image mode a center

    // Disegna la mappa del livello corrente
    currentLevel.display(gameLayer); // renderizza il 4,6 % della mappa

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

    // metodo che gestisce le collisioni del player e di ogni altra entita
    // p1.display(spritesLayer);
    // p1.displayHitbox(spritesLayer);
    // p1.displayWeapon(spritesLayer);

    // aggiungere logica per cui quando si è nel livello del boss
    // non vengono eseguite
    displayCharacter();
    displayChests();
    displayCoins();
    displayDropItems();

    //if (!game.isBossLevel) {
    //  displayEnemies();
    //  displayChests();
    //  displayCoins();
    //  displayDropItems();
    //} else {
    //  game.boss.display(spritesLayer);
    //}

    // debug
    // currentLevel.level.drawDebug(spritesLayer);
    //currentLevel.level.draw(spritesLayer);


    spritesLayer.endDraw();
    image(spritesLayer, 0, 0);
  }

  private void updateMaskLayer() {
    maskLayer.beginDraw();
    maskLayer.background(0, 255);
    maskLayer.blendMode(REPLACE);

    maskLayer.translate(-camera.x, -camera.y);
    maskLayer.scale(camera.zoom);

    float centerX = p1.getPosition().x * currentLevel.tileSize + currentLevel.tileSize/ 2;
    float centerY = p1.getPosition().y * currentLevel.tileSize + currentLevel.tileSize/ 2;

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

      if (isInVisibleArea(character.getPosition()) &&
        !character.IsDead()) {
        character.display(spritesLayer);
      }
    }
  }


  // da spostare nel render system
  //private void displayEnemies()
  //{
  //  Iterator<Enemy> iterator = currentLevel.enemies.iterator();

  //  while (iterator.hasNext()) {
  //    Enemy enemy = iterator.next();

  //    if (isInVisibleArea(enemy.getPosition())) {
  //      if (enemy.hp > 0) {
  //        enemy.display(spritesLayer);
  //      }
  //    }
  //  }
  //}

  // da spostare nel render system
  // da rivedere
  void displayChests() {
    for (Chest chest : currentLevel.treasures) {
      if (isInVisibleArea(chest.getPosition()))
      {
        // mostra le chest nell'area visibile
        chest.display(spritesLayer);

        if (isCollidingWithChest && !chest.isOpen())
        {
          if (isPossibleToOpenChest)
          {
            // chest.displayHitbox(spritesLayer);
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

  private void displayCoins() {
    for (Coin coin : currentLevel.coins) {
      if (isInVisibleArea(coin.getPosition())) {
        // mostra le monete nell'area visibile
        if (!coin.isCollected()) {    // se la moneta non è stata raccolta disegnala
          coin.display(spritesLayer);
        }
      }
    }
  }

  private void displayDropItems() {
    Iterator<Item> iterator = currentLevel.dropItems.iterator();

    while (iterator.hasNext()) {
      Item item = iterator.next();

      // controlla che gli elementi droppati siano visibili
      if (isInVisibleArea(item.getPosition()))
      {
        item.display(spritesLayer);

        if (checkCollision(item, p1))
        {
          // item.displayHitbox(spritesLayer);

          if (drawInteractableLetter)
          {
            // disegna la lettera ch eindica il tasto per interagire con l'item
            float letterImageX = (item.getPosition().x * currentLevel.tileSize + (item.sprite.width / 2));
            float letterImageY = (item.getPosition().y * currentLevel.tileSize + (item.sprite.height / 2)) - 20; // Regola l'offset verticale a tuo piacimento
            spritesLayer.image(letter_k, letterImageX, letterImageY);
          }

          if (item.isWeapon) {
            if (drawUpBuff)
            {
              float imageX = (item.getPosition().x * currentLevel.tileSize + (item.sprite.width / 2) - 20);
              float imageY = (item.getPosition().y * currentLevel.tileSize + (item.sprite.height / 2)) - 20; // Regola l'offset verticale a tuo piacimento
              spritesLayer.image(up_buff, imageX, imageY);
            } else if (drawDownBuff)
            {
              float imageX = (item.getPosition().x * currentLevel.tileSize + (item.sprite.width / 2) - 20);
              float imageY = (item.getPosition().y * currentLevel.tileSize + (item.sprite.height / 2)) - 20; // Regola l'offset verticale a tuo piacimento
              spritesLayer.image(down_buff, imageX, imageY);
            }
          }
        }
      }
    }
  }
}
