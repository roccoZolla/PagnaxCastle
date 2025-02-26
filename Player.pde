// da mettere nelle utilities //<>// //<>// //<>//
enum Direction {
  LEFT,
    RIGHT,
    UP,
    DOWN
}

class Character extends Sprite
{
  int hp = 0;
  private boolean isDamageable = true;
  private boolean isDead = false;

  boolean IsDamageable() {
    return isDamageable;
  }
  void setDead() {
    this.isDead = true;
  }
  boolean IsDead() {
    return isDead;
  }

  void takeDamage(int damage)
  {
    hp -= damage;

    // aggiungere piccolo feedback visivo

    // hurt_sound.play();

    if (hp < 0)
    {
      hp = 0;
      isDead = true;
    }
  }
}

<<<<<<< HEAD
class Player extends Character
{
  // componente velocita  del player
  // non definitivo
  float speed = 120.0f;
=======
class Player extends Character 
{
  // componente velocita  del player
  // non definitivo
  float speed = 100.0f;
>>>>>>> fix

  PImage left_side;  // lato sinistro dello sprite del giocatore
  PImage right_side; // lato destro dello sprite del giocatore

  Direction direction;

  // movements
  boolean moveUP;
  boolean moveDOWN;
  boolean moveRIGHT;
  boolean moveLEFT;
<<<<<<< HEAD
=======

  Direction direction;
>>>>>>> fix

  boolean moveATCK;    // attacco j
  boolean moveINTR;    // interazione k
  boolean moveUSE;     // utilizza l

  boolean isMoving = false;
  boolean isUsingPotion = false;
  boolean isAttacking = false;
  boolean attackExecuted = false;
  boolean isInteracting = false;

  boolean displayAttack = false;

  // caratteristiche del player
  int playerMaxHP;
<<<<<<< HEAD
=======
  // int playerHP;
>>>>>>> fix
  int playerScore;
  int coins;      // numero di monete che ha il giocatore
  Item weapon;
  Item potion;
  Item golden_key;
  Item silver_key;
  int numberOfSilverKeys;
  int numberOfGoldenKeys;
  int numberOfPotion;

  Player(int playerHP, int maxHP) {
    super();

    // sprite
    right_side = loadImage("data/playerRIGHT.png");
    left_side = loadImage("data/playerLEFT.png");

    this.sprite = right_side;

<<<<<<< HEAD
    createBox();

    this.direction = Direction.RIGHT;
=======
    // box's settings
    box = new FBox(SPRITE_SIZE, SPRITE_SIZE);
    box.setName("Player");
    box.setFillColor(10);
    box.setRotatable(false);
    box.setFriction(0.5);
    box.setRestitution(0.2);

    this.direction = Direction.DESTRA;
>>>>>>> fix

    // charateristics
    this.playerScore = 0;
    this.hp = playerHP;
    this.playerMaxHP = maxHP;
    this.coins = 0;
    this.numberOfSilverKeys = 10;
    this.numberOfGoldenKeys = 10;
    this.numberOfPotion = 10;

    this.golden_key = new Item(null, "golden_key");
    this.silver_key = new Item(null, "silver_key");
<<<<<<< HEAD

    // sistemare generazione arma giocatore
    this.weapon = new Item(small_sword_sprite, "Piccola Spada", false, 0, true, 10);

    this.potion = new Item(null, "red_potion", true, 20, false, 0);
=======
    this.weapon = new Item(small_sword_sprite, "Piccola Spada", false, 0, true, 10);
    this.potion = new Item(null, "red_potion", true, 20, false, 0);
    // this.potion = new Healer(null, null, "red_potion", 20);
>>>>>>> fix

    // carica lo sprite dell'arma e del giocatore
    weapon.updateSprite(small_sword_sprite);

    // aggiorna lo posizione dell'arma
    weapon.updatePosition(getPosition());

    this.moveUP = false;
    this.moveDOWN = false;
    this.moveRIGHT = false;
    this.moveLEFT = false;
  }

<<<<<<< HEAD
  void createBox()
  {
    // box's settings
    box = new FBox(SPRITE_SIZE, SPRITE_SIZE);
    box.setName("Player");
    box.setFillColor(90);
    box.setRotatable(false);
    box.setFriction(1);   // quanto attrito fa
    box.setRestitution(0);  // quanto rimbalza
    // box.setDamping(0);      // ammortizza il movimento
  }

  // aggiorna il movimento del giocatore
  void update()
  {
    float dx = 0;
    float dy = 0;

    if (moveUP) {
      dy -= 1; // Spostamento verso l'alto
      direction = Direction.UP;
    }

    if (moveDOWN) {
      dy += 1; // Spostamento verso il basso
      direction = Direction.DOWN;
    }

    if (moveLEFT) {
      dx -= 1; // Spostamento verso sinistra
      sprite = left_side;
      direction = Direction.LEFT;
    }

    if (moveRIGHT) {
      dx += 1; // Spostamento verso destra
      sprite = right_side;
      direction = Direction.RIGHT;
    }

    // Normalizza il vettore di movimento
    PVector movement = new PVector(dx, dy);
    movement.normalize();

    // Applica la velocità costante
    movement.mult(speed);

    // Applica l'accelerazione
    box.setVelocity(movement.x, movement.y);
  }

  Direction getDirection() {
    return direction;
  }

  Item getWeapon() {
    return weapon;
  }

  void setWeapon(Item weapon) {
    this.weapon = weapon;
=======
  // aggiorna il movimento del giocatore
  void update()
  {
    if (moveUP)
    {
      box.addForce(0, -1 * speed);
    }

    if (moveDOWN)
    {
      box.addForce(0, 1 * speed);
    }

    if (moveLEFT)
    {
      box.addForce(-1 * speed, 0);
      sprite = left_side;
    }

    if (moveRIGHT)
    {
      box.addForce(1 * speed, 0);
      sprite = right_side;
    }
>>>>>>> fix
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
  void restoreHP(int HP) {
    drinkPotion.play();
<<<<<<< HEAD

    hp += HP;

=======
    hp += HP;

>>>>>>> fix
    if (hp > playerMaxHP) hp = playerMaxHP;
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
          //// da rivedere
          //if (checkCollision(weapon, game.boss))
          //{
          //  swordAttack.play();
          //  game.boss.takeDamage(weapon.getDamage());
          //  // l'attacco è stato eseguito non continuare ad attaccare
          //  // println("attacco eseguito...");
          //  attackExecuted = true;
          //}
        } else {
<<<<<<< HEAD
          //// for (Enemy enemy : currentLevel.enemies)
          //for (Enemy enemy : level.enemies)
          //{
          //  //if (checkCollision(weapon, enemy))
          //  //{
          //  //  swordAttack.play();
          //  //  // enemy.takeDamage(weapon.getDamage());
          //  //  // l'attacco è stato eseguito non continuare ad attaccare
          //  //  // println("attacco eseguito...");
          //  //  attackExecuted = true;
          //  //}
          //}
=======
          for (Enemy enemy : currentLevel.enemies)
          {
            //if (checkCollision(weapon, enemy))
            //{
            //  swordAttack.play();
            //  // enemy.takeDamage(weapon.getDamage());
            //  // l'attacco è stato eseguito non continuare ad attaccare
            //  // println("attacco eseguito...");
            //  attackExecuted = true;
            //}
          }
>>>>>>> fix
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

<<<<<<< HEAD
=======
  // da migliorare
  void displayWeapon(PGraphics layer) {
    if (displayAttack)
    {
      PVector new_position = getPosition().copy();

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

>>>>>>> fix
  void usePotion(PGraphics layer) {
    if (moveUSE && (!moveATCK && !moveINTR)) {
      if (!isUsingPotion) {
        isUsingPotion = true;

        // se il numero delle pozioni è maggiore di 0
        if (numberOfPotion > 0) {
          // se vita minore della vita massima
          if (hp < playerMaxHP) {
            restoreHP(potion.getBonusHp());

            // dimunuisci numero di pozioni del giocatore
            numberOfPotion -= 1;
          } else {
            // non deve stare qui
            // stampa massaggio di salute al massimo
          }
        } else {
          // non deve stare qui
          // stampa x per indicare che non hai piu pozioni
          //float crossImageX = (getPosition().x * currentLevel.tileSize + (sprite.width / 2));
          //float crossImageY = (getPosition().y * currentLevel.tileSize + (sprite.height / 2)) - 20;
          //layer.imageMode(CENTER);
          //layer.image(cross_sprite, crossImageX, crossImageY);
        }
      }
    } else {
      // resetta la variabile
      isUsingPotion = false;
    }
  }
}
