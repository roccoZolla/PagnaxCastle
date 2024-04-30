// da mettere nelle utilities
enum Direction {
  SINISTRA,
    DESTRA,
    SOPRA,
    GIU
}

class Player extends Sprite implements Damageable { //<>//
  // componente velocita  del player
  // non definitivo
  float velocity_x = 0;
  float velocity_y = 0;

  float speed = 0.2f;

  PImage left_side;  // lato sinistro dello sprite del giocatore
  PImage right_side; // lato destro dello sprite del giocatore

  // movements
  boolean moveUP;
  boolean moveDOWN;
  boolean moveRIGHT;
  boolean moveLEFT;
  
  boolean canMoveUP;
  boolean canMoveDOWN;
  boolean canMoveRIGHT;
  boolean canMoveLEFT;

  Direction direction;

  boolean moveATCK;    // attacco j
  boolean moveINTR;    // interazione k
  boolean moveUSE;     // utilizza l

  boolean isMoving = false;
  boolean isUsingPotion = false;
  boolean isAttacking = false;
  boolean attackExecuted = false;
  boolean isInteracting = false;

  boolean displayAttack = false;

  ConcreteDamageHandler damageTileHandler;

  // caratteristiche del player
  int playerMaxHP;
  int playerHP;
  int playerScore;
  int coins;      // numero di monete che ha il giocatore
  // Weapon weapon;
  Item weapon;
  Item potion;
  // Healer potion;  // pozione generale
  Item golden_key;
  Item silver_key;
  int numberOfSilverKeys;
  int numberOfGoldenKeys;
  int numberOfPotion;

  Player(PVector position, int playerHP, int maxHP, int numberOfSilverKeys, int numberOfGoldenKeys, int numberOfPotion, ConcreteDamageHandler damageTileHandler) {
    super(position);
    
    this.direction = Direction.DESTRA;

    this.playerScore = 0;
    this.playerHP = playerHP;
    this.playerMaxHP = maxHP;
    this.coins = 0;
    this.numberOfSilverKeys = numberOfSilverKeys;
    this.numberOfGoldenKeys = numberOfGoldenKeys;
    this.numberOfPotion = numberOfPotion;

    this.damageTileHandler = damageTileHandler;

    this.golden_key = new Item(null, null, "golden_key");
    this.silver_key = new Item(null, null, "silver_key");
    // this.weapon = new Weapon(null, null, "Piccola Spada", 10);
    this.weapon = new Item(null, small_sword_sprite, "Piccola Spada", false, 0, true, 10);
    this.potion = new Item(null, null, "red_potion", true, 20, false, 0);
    // this.potion = new Healer(null, null, "red_potion", 20);

    // carica lo sprite dell'arma e del giocatore
    weapon.updateSprite(small_sword_sprite);

    right_side = loadImage("data/playerRIGHT.png");
    left_side = loadImage("data/playerLEFT.png");

    this.sprite = right_side;

    // aggiorna lo posizione dell'arma
    weapon.updatePosition(position);

    this.moveUP = false;
    this.moveDOWN = false;
    this.moveRIGHT = false;
    this.moveLEFT = false;
    
    this.canMoveUP = true;
    this.canMoveRIGHT = true;
    this.canMoveDOWN = true;
    this.canMoveLEFT = true;
  }

  void collectCoin() {
    this.coins++;
  }

  void takeGoldenKey() {
    this.numberOfGoldenKeys++;
  }

  void takeSilverKey() {
    this.numberOfSilverKeys++;
  }

  void updateScore(int score) {
    this.playerScore += score;
  }

  // aggiorna la vita del giocatore e
  // riproduci suono
  void takeHP(int HP) {
    drinkPotion.play();
    playerHP += HP;

    if (playerHP > playerMaxHP) playerHP = playerMaxHP;
  }

  // override dei metodi dell'interfaccia
  @Override
    public void takeDamage(int damage) {
    playerHP -= damage;

    TextDisplay damageHitText = new TextDisplay(position, Integer.toString(damage), color(255, 0, 0));
    damageHitText.display(render.spritesLayer);

    hurt_sound.play();

    if (playerHP < 0) {
      playerHP = 0;
    }
  }

  // aggiorna movimento del giocatore
  // metodo piu veloce e meno costoso in termini di risorse
  void update() {
    if (moveUP && canMoveUP)
    {
      velocity_y += -1 * speed;
      direction = Direction.SOPRA;
    }

    if (moveDOWN && canMoveDOWN)
    {
      velocity_y += 1 * speed;
      direction = Direction.GIU;
    }

    if (moveLEFT && canMoveLEFT)
    {
      velocity_x += -1 * speed;
      direction = Direction.SINISTRA;
      sprite = left_side;
    }

    if (moveRIGHT && canMoveRIGHT)
    {
      velocity_x += 1 * speed;
      direction = Direction.DESTRA;
      sprite = right_side;
    }

    // da mettere da un'altra parte
    damageTileHandler.handleDamageTiles(this, round(position.x), round(position.y));
  }

  //void update() {
  //  float x = position.x;
  //  float y = position.y;

  //  // cella superiore al giocatore
  //  if (moveUP && isWithinMapBounds(round(x), round(y - 1)) && !check_collision_wall(round(x), round(y - 1))) {      // y - 1
  //    y += -1 * spriteSpeed;
  //  }

  //  // cella inferiore al giocatore
  //  if (moveDOWN && isWithinMapBounds(round(x), round(y + 1)) && !check_collision_wall(round(x), round(y + 1))) {    // y + 1
  //    y += 1 * spriteSpeed;
  //  }

  //  // cella a sinistra del giocatore
  //  if (moveLEFT && isWithinMapBounds(round(x - 1), round(y)) && !check_collision_wall(round(x - 1), round(y))) {   // x - 1
  //    x += -1 * spriteSpeed;
  //    direction = DIRECTION_LEFT;
  //    sprite = left_side;
  //  }

  //  // cella a destra del giocatore
  //  if (moveRIGHT && isWithinMapBounds(round(x + 1), round(y)) && !check_collision_wall(round(x + 1), round(y))) {  // x + 1
  //    x += 1 * spriteSpeed;
  //    direction = DIRECTION_RIGHT;
  //    sprite = right_side;
  //  }

  //  updatePosition(new PVector(x, y));
  //  damageTileHandler.handleDamageTiles(this, round(x), round(y));
  //}

  // controlla le celle circostanti e al giocatore e verifica che non siano muri
  boolean check_collision_wall(int x, int y) {
    // se è un muro controlla la possibile collisione con lo sprite
    if (isWall(x, y)) {
      //println("è un muro...");

      if (position.x * currentLevel.tileSize + (sprite.width / 2) >= (x * currentLevel.tileSize) - (sprite.width / 2)  &&      // x1 + w1/2 > x2 - w2/2
        (position.x * currentLevel.tileSize) - (sprite.width / 2) <= x * currentLevel.tileSize + (sprite.width / 2) &&                               // x1 - w1/2 < x2 + w2/2
        position.y * currentLevel.tileSize + (sprite.height / 2) >= (y * currentLevel.tileSize) - (sprite.height / 2) &&                                      // y1 + h1/2 > y2 - h2/2
        (position.y * currentLevel.tileSize) - (sprite.height / 2) <= y * currentLevel.tileSize + (sprite.height / 2)) {
        // println("collisione rilevata...");
        return true;
      }
    }

    return false;
  }

  // da fixare
  void attack()
  {
    if (moveATCK && (!moveUSE && !moveINTR))
    {
      // println("sta attaccando...");
      isAttacking = true;
      // se sta attaccando e l'attacco non è stato eseguito
      if (isAttacking && !attackExecuted)
      {
        displayAttack = true;

        if (game.isBossLevel)
        {
          // da rivedere
          if (collision.check_collision(weapon, game.boss))
          {
            swordAttack.play();
            game.boss.takeDamage(weapon.getDamage());
            // l'attacco è stato eseguito non continuare ad attaccare
            // println("attacco eseguito...");
            attackExecuted = true;
          }
        } else {
          for (Enemy enemy : currentLevel.enemies)
          {
            if (collision.check_collision(weapon, enemy))
            {
              swordAttack.play();
              enemy.takeDamage(weapon.getDamage());
              // l'attacco è stato eseguito non continuare ad attaccare
              // println("attacco eseguito...");
              attackExecuted = true;
            }
          }
        }
      }
    } else
    {
      // println("non sta piu attaccando...");
      isAttacking = false;
      attackExecuted = false;
      displayAttack = false;
    }
  }

  // da migliorare
  void displayWeapon(PGraphics layer) {
    if (displayAttack)
    {
      PVector new_position = position.copy();

      switch(direction)
      {
        case SOPRA:
        new_position.y -= 1;
        break;
        
        case GIU:
        new_position.y += 1;
        break;
        
        case DESTRA:
        new_position.x += 1;
        break;
        
        case SINISTRA:
         new_position.x -= 1;
        break;
      }

      weapon.updatePosition(new_position);
      weapon.display(layer);
    }
  }

  void usePotion(PGraphics layer) {
    if (moveUSE && (!moveATCK && !moveINTR)) {
      if (!isUsingPotion) {
        isUsingPotion = true;

        // se il numero delle pozioni è maggiore di 0
        if (numberOfPotion > 0) {
          // se vita minore della vita massima
          if (playerHP < playerMaxHP) {
            takeHP(potion.getBonusHp());

            // dimunuisci numero di pozioni del giocatore
            numberOfPotion -= 1;
          } else {
            // non deve stare qui
            // stampa massaggio di salute al massimo
            PVector text_position = p1.getPosition();
            TextDisplay healthFull = new TextDisplay(text_position, "Salute al massimo", color(255));
            healthFull.display(layer);
          }
        } else {
          // non deve stare qui
          // stampa x per indicare che non hai piu pozioni
          float crossImageX = (getPosition().x * currentLevel.tileSize + (sprite.width / 2));
          float crossImageY = (getPosition().y * currentLevel.tileSize + (sprite.height / 2)) - 20;
          layer.imageMode(CENTER);
          layer.image(cross_sprite, crossImageX, crossImageY);
        }
      }
    } else {
      // resetta la variabile
      isUsingPotion = false;
    }
  }

  @Override
    PVector getPosition() {
    return position;
  }
}
