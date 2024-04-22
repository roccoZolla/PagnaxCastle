class Player extends Sprite implements Damageable { //<>//
  float spriteSpeed = 0.2;
  
  PImage left_side;  // lato sinistro dello sprite del giocatore
  PImage right_side; // lato destro dello sprite del giocatore

  // movements
  boolean moveUP;
  boolean moveDOWN;
  boolean moveRIGHT;
  boolean moveLEFT;

  int direction;

  final int DIRECTION_LEFT = 0;
  final int DIRECTION_RIGHT = 1;

  boolean moveATCK;    // attacco j
  boolean moveINTR;    // interazione k
  boolean moveUSE;     // utilizza l

  boolean isMoving = false;
  boolean isUsingPotion = false;
  boolean isAttacking = false;
  boolean attackExecuted = false;
  boolean isInteracting = false;

  ConcreteDamageHandler damageTileHandler;

  // caratteristiche del player
  int playerMaxHP;
  int playerHP;
  int playerScore;
  int coins;      // numero di monete che ha il giocatore
  Weapon weapon;
  Healer potion;  // pozione generale
  Item golden_key;
  Item silver_key;
  int numberOfSilverKeys;
  int numberOfGoldenKeys;
  int numberOfPotion;

  Player(PVector position, int playerHP, int maxHP, int numberOfSilverKeys, int numberOfGoldenKeys, int numberOfPotion, ConcreteDamageHandler damageTileHandler) {    
    super(position);

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
    this.weapon = new Weapon(null, null, "Piccola Spada", 10);
    this.potion = new Healer(null, null, "red_potion", 20);
    
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
    damageHitText.display(game.spritesLayer);

    hurt_sound.play();

    if (playerHP < 0) {
      playerHP = 0;
    }
  }

  // aggiorna movimento del giocatore
  void update() {
    float x = position.x;
    float y = position.y;

    // cella superiore al giocatore
    if (moveUP && isWithinMapBounds(round(x), round(y - 1)) && !check_collision_wall(round(x), round(y - 1))) {      // y - 1
      y += -1 * spriteSpeed;
    }

    // cella inferiore al giocatore
    if (moveDOWN && isWithinMapBounds(round(x), round(y + 1)) && !check_collision_wall(round(x), round(y + 1))) {    // y + 1
      y += 1 * spriteSpeed;
    }

    // cella a sinistra del giocatore
    if (moveLEFT && isWithinMapBounds(round(x - 1), round(y)) && !check_collision_wall(round(x - 1), round(y))) {   // x - 1
      x += -1 * spriteSpeed;
      direction = DIRECTION_LEFT;
      sprite = left_side;
    }

    // cella a destra del giocatore
    if (moveRIGHT && isWithinMapBounds(round(x + 1), round(y)) && !check_collision_wall(round(x + 1), round(y))) {  // x + 1
      x += 1 * spriteSpeed;
      direction = DIRECTION_RIGHT;
      sprite = right_side;
    }

    updatePosition(new PVector(x, y));
    damageTileHandler.handleDamageTiles(this, round(x), round(y));
  }

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
  void attack(PGraphics layer) {
    if (moveATCK && (!moveUSE && !moveINTR)) {
      // println("sta attaccando...");
      isAttacking = true;
      // se sta attaccando e l'attacco non è stato eseguito
      if (isAttacking && !attackExecuted) {
        // offset
        PVector new_position = position.copy();

        if (direction == DIRECTION_RIGHT)
          new_position.x += 1;
        else if (direction == DIRECTION_LEFT)
          new_position.x -= 1;
        
        // non deve stare qui
        weapon.updatePosition(new_position);
        weapon.display(layer);

        if (game.isBossLevel) {
          if (weapon.sprite_collision(game.boss)) {
            swordAttack.play();
            game.boss.takeDamage(weapon.getDamage());
            // l'attacco è stato eseguito non continuare ad attaccare
            // println("attacco eseguito...");
            attackExecuted = true;
          }
        } else {
          for (Enemy enemy : currentLevel.enemies) {
            if (weapon.sprite_collision(enemy)) {
              swordAttack.play();
              enemy.takeDamage(weapon.getDamage());
              // l'attacco è stato eseguito non continuare ad attaccare
              // println("attacco eseguito...");
              attackExecuted = true;
            }
          }
        }
      }
    } else {
      // println("non sta piu attaccando...");
      isAttacking = false;
      attackExecuted = false;
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
          float crossImageY = (getPosition().y * currentLevel.tileSize + (sprite.height / 2)) - 20; // Regola l'offset verticale a tuo piacimento
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
