class Enemy extends Character {
  // caratteristiche nemico
  int damage;
  String name;
  int scoreValue;

  // componenti fisiche
  float velocity_x = 0;
  float velocity_y = 0;
  float speed = 0.1f;

  float currentDirection = random(4);
  int framesInCurrentDirection = 0;
  int maxFramesInSameDirection = 30;

  private final int attack_interval = 60; // Tempo di cooldown in millisecondi (3 secondi)
  private long attack_timer = attack_interval;
  boolean first_attack;    // di base è true
  
  // drop probabilities constant
  // non definitive
  final float DROP_NOTHING = 0.3;
  final float DROP_SILVER_KEY = 0.1;
  final float DROP_HEART = 0.3;
  final float DROP_HALF_HEART = 0.3;

  Enemy(PImage sprite, int enemyHP, String name, int damage) {
    super();

    // sprite
    this.sprite = sprite;

    // setting's box
    box = new FBox(SPRITE_SIZE, SPRITE_SIZE);
    box.setName("Enemy");
    box.setFillColor(40);
    box.setRotatable(false);
    box.setFriction(0.5);   // quanto attrito fa
    box.setRestitution(0);  // quanto rimbalza
    box.setDamping(1);      // ammortizza il movimento

    // characteristics
    this.hp = enemyHP;
    this.name = name;
    this.damage = damage;
    this.scoreValue = 20;

    first_attack = true;
  }

  int getDamage() {
    return damage;
  }

  // gestisce il movimento del nemico
  // da migliorare
  void update() {
    // Ottieni la posizione del giocatore
    //PVector playerPosition = p1.getPosition();
    //PVector position = getPosition();

    //// distanza tra il nemico e il giocatore
    //float distance = dist(position.x, position.y, playerPosition.x, playerPosition.y);

    //// distanza minima
    //float threshold = 4;

    //// Verifica se il giocatore è abbastanza vicino
    //if (distance <= threshold) {
    //  // Calcola la direzione verso il giocatore
    //  PVector direction = PVector.sub(p1.getPosition(), getPosition());
    //  direction.normalize();

    //  // Calcola il movimento in base alla direzione
    //  float newX = position.x + direction.x * speed;
    //  float newY = position.y + direction.y * speed;

    //  //if (isWithinMapBounds(round(newX), round(newY)) && !check_collision_wall(round(newX), round(newY)) && !collision.check_collision(this, p1)) {
    //  //  updatePosition(new PVector(newX, newY));
    //  //  damageTileHandler.handleDamageTiles(this, round(newX), round(newY));
    //  //}
    //}

    //else
    //{
    //  // metodo leggermente migliore rispetto al metodo parkinson
    //  float x = position.x;
    //  float y = position.y;

    //  // Incrementa il numero di frame nella direzione corrente
    //  framesInCurrentDirection++;

    //  // Cambia direzione se è il momento opportuno o se si incontra un ostacolo
    //  if (framesInCurrentDirection >= maxFramesInSameDirection || check_collision_wall(round(x), round(y))) {
    //    currentDirection = random(4);
    //    framesInCurrentDirection = 0;
    //  }

    //  // Sposta il nemico in base alla direzione corrente
    //  if (currentDirection < 1 && isWithinMapBounds(round(x + 1), round(y)) && !check_collision_wall(round(x + 1), round(y))) {  // x + 1
    //    x += 1 * speed;
    //  } else if (currentDirection < 2 && isWithinMapBounds(round(x - 1), round(y)) && !check_collision_wall(round(x - 1), round(y))) {   // x - 1
    //    x += -1 * speed;
    //  } else if (currentDirection < 3 && isWithinMapBounds(round(x), round(y + 1)) && !check_collision_wall(round(x), round(y + 1))) {    // y + 1
    //    y += 1 * speed;
    //  } else {      // y - 1
    //    if (isWithinMapBounds(round(x), round(y - 1)) && !check_collision_wall(round(x), round(y - 1))) {
    //      y += -1 * speed;
    //    }
    //  }

    //  updatePosition(new PVector(x, y));
    //  damageTileHandler.handleDamageTiles(this, round(x), round(y));
    //}
  }

  //boolean check_collision_wall(int x, int y) {
  //  // se è un muro controlla la possibile collisione con lo sprite
  //  if (isWall(x, y)) {
  //    // println("è un muro...");

  //    if (position.x * currentLevel.tileSize + (sprite.width / 2) >= (x * currentLevel.tileSize) - (sprite.width / 2)  &&      // x1 + w1/2 > x2 - w2/2
  //      (position.x * currentLevel.tileSize) - (sprite.width / 2) <= x * currentLevel.tileSize + (sprite.width / 2) &&                               // x1 - w1/2 < x2 + w2/2
  //      position.y * currentLevel.tileSize + (sprite.height / 2) >= (y * currentLevel.tileSize) - (sprite.height / 2) &&                                      // y1 + h1/2 > y2 - h2/2
  //      (position.y * currentLevel.tileSize) - (sprite.height / 2) <= y * currentLevel.tileSize + (sprite.height / 2)) {
  //      // println("collisione rilevata...");
  //      return true;
  //    }
  //  }

  //  return false;
  //}

  // attacca il giocatore
  void attack(Player player) {
    if (first_attack) {
      // Esegui l'attacco
      // player.takeDamage(damage);

      // fare in modo che rimanga un po piu di tempo a schermo
      TextDisplay damageHitText = new TextDisplay(p1.getPosition(), Integer.toString(damage), color(255, 0, 0));
      damageHitText.display(render.spritesLayer);

      first_attack = false;
    } else {
      // parte l'attacco periodico
      attack_timer--;

      if (attack_timer <= 0) {
        // Esegui l'attacco periodico
        // player.takeDamage(damage);

        // Reimposta il timer per il prossimo attacco
        attack_timer = attack_interval;
      }
    }
  }

  void death() {
    enemy_death_sound.play();
    dropItem();
    setDead();
  }


  private void dropItem() {
    // numero casuale
    double randomValue = Math.random();
    PVector dropPosition = getPosition().copy();

    dropPosition.x = ( dropPosition.x - (SPRITE_SIZE/2) ) / SPRITE_SIZE;
    dropPosition.y = ( dropPosition.y - (SPRITE_SIZE/2) ) / SPRITE_SIZE;

    if (randomValue <= DROP_NOTHING)
    {
      // Nessun drop
    } else if (randomValue <= DROP_NOTHING + DROP_SILVER_KEY)
    {
      // drop della chiave d'argento
      Item dropSilverKey = new Item(silver_key_sprite, "dropSilverKey");
      dropSilverKey.updatePosition(dropPosition);
      // currentLevel.dropItems.add(dropSilverKey);
    } else if (randomValue <= DROP_NOTHING + DROP_SILVER_KEY + DROP_HEART)
    {
      // drop del cuore intero
      // Healer dropHeart = new Healer(dropPosition, heart_sprite, "dropHeart", 10);
      Item dropHeart = new Item(heart_sprite, "dropHeart", true, 10, false, 0);
      dropHeart.updatePosition(dropPosition);
      // currentLevel.dropItems.add(dropHeart);
    } else if (randomValue <= DROP_NOTHING + DROP_SILVER_KEY + DROP_HEART + DROP_HALF_HEART)
    {
      // drop del mezzocuore
      // Healer dropHalfHeart = new Healer(dropPosition, half_heart_sprite, "dropHalfHeart", 5);
      Item dropHalfHeart = new Item(half_heart_sprite, "dropHalfHeart", true, 5, false, 0);
      dropHalfHeart.updatePosition(dropPosition);
      // currentLevel.dropItems.add(dropHalfHeart);
    }
  }
}
