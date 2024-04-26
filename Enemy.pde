class Enemy extends Sprite implements Damageable {
  // componente velocita dei nemici
  float velocity_x = 0;
  float velocity_y = 0;
  
  float speed = 0.1f;
  
  float currentDirection = random(4);
  int framesInCurrentDirection = 0;
  int maxFramesInSameDirection = 30;

  ConcreteDamageHandler damageTileHandler;

  private final int attack_interval = 60; // Tempo di cooldown in millisecondi (3 secondi)
  private long attack_timer = attack_interval;
  boolean first_attack;    // di base è true

  int enemyHP;
  int damage;
  String name;
  int scoreValue;

  Enemy(PVector position, PImage sprite, int enemyHP, String name, int damage, ConcreteDamageHandler damageTileHandler) {
    super(position, sprite);
    this.enemyHP = enemyHP;
    this.name = name;
    this.damage = damage;
    this.scoreValue = 20;

    first_attack = true;

    this.damageTileHandler = damageTileHandler;
  }

  // gestisce il movimento del nemico
  // da migliorare
  void update() {
    // Ottieni la posizione del giocatore
    PVector playerPosition = p1.getPosition();

    // distanza tra il nemico e il giocatore
    float distance = dist(position.x, position.y, playerPosition.x, playerPosition.y);

    // distanza minima
    float threshold = 4;

    // Verifica se il giocatore è abbastanza vicino
    if (distance <= threshold) {
      // Calcola la direzione verso il giocatore
      PVector direction = PVector.sub(playerPosition, position);
      direction.normalize();

      // Calcola il movimento in base alla direzione
      float newX = position.x + direction.x * speed;
      float newY = position.y + direction.y * speed;

      if (isWithinMapBounds(round(newX), round(newY)) && !check_collision_wall(round(newX), round(newY)) && !collision.sprite_collision(this, p1)) {
        updatePosition(new PVector(newX, newY));
        damageTileHandler.handleDamageTiles(this, round(newX), round(newY));
      }
    } 
    
    else 
    {
      // metodo leggermente migliore rispetto al metodo parkinson
      float x = position.x;
      float y = position.y;

      // Incrementa il numero di frame nella direzione corrente
      framesInCurrentDirection++;

      // Cambia direzione se è il momento opportuno o se si incontra un ostacolo
      if (framesInCurrentDirection >= maxFramesInSameDirection || check_collision_wall(round(x), round(y))) {
        currentDirection = random(4);
        framesInCurrentDirection = 0;
      }

      // Sposta il nemico in base alla direzione corrente
      if (currentDirection < 1 && isWithinMapBounds(round(x + 1), round(y)) && !check_collision_wall(round(x + 1), round(y))) {  // x + 1
        x += 1 * speed;
      } else if (currentDirection < 2 && isWithinMapBounds(round(x - 1), round(y)) && !check_collision_wall(round(x - 1), round(y))) {   // x - 1
        x += -1 * speed;
      } else if (currentDirection < 3 && isWithinMapBounds(round(x), round(y + 1)) && !check_collision_wall(round(x), round(y + 1))) {    // y + 1
        y += 1 * speed;
      } else {      // y - 1
        if (isWithinMapBounds(round(x), round(y - 1)) && !check_collision_wall(round(x), round(y - 1))) {
          y += -1 * speed;
        }
      }

      updatePosition(new PVector(x, y));
      damageTileHandler.handleDamageTiles(this, round(x), round(y));
    }
  }

  boolean check_collision_wall(int x, int y) {
    // se è un muro controlla la possibile collisione con lo sprite
    if (isWall(x, y)) {
      // println("è un muro...");

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

  // attacca il giocatore
  void attack(Player player) {
    if (first_attack) {
      // Esegui l'attacco
      player.takeDamage(damage);

      // fare in modo che rimanga un po piu di tempo a schermo
      TextDisplay damageHitText = new TextDisplay(p1.getPosition(), Integer.toString(damage), color(255, 0, 0));
      damageHitText.display(render.spritesLayer);

      first_attack = false;
    } else {
      // parte l'attacco periodico
      attack_timer--;

      if (attack_timer <= 0) {
        // Esegui l'attacco periodico
        player.takeDamage(damage);

        // Reimposta il timer per il prossimo attacco
        attack_timer = attack_interval;
      }
    }
  }

  void death() {
    enemy_death_sound.play();
    dropItem();
  }

  private void dropItem() {
    // numero casuale
    double randomValue = Math.random();

    // dropRate degli oggetti droppati dai nemici
    double dropNothingProbability = 0.3;        // 30 %
    double dropSilverKeyProbability = 0.1;      // 10 %
    double dropHeartProbability = 0.3;          // 30 %
    double dropHalfHeartProbability = 0.3;      // 30 %

    PVector dropPosition = position.copy();

    if (randomValue <= dropNothingProbability) 
    {
      // Nessun drop
    } 
    
    else if (randomValue <= dropNothingProbability + dropSilverKeyProbability) 
    {
      // drop della chiave d'argento
      Item dropSilverKey = new Item(dropPosition, silver_key_sprite, "dropSilverKey");
      currentLevel.dropItems.add(dropSilverKey);
    } 
    
    else if (randomValue <= dropNothingProbability + dropSilverKeyProbability + dropHeartProbability) 
    {
      // drop del cuore intero
      // Healer dropHeart = new Healer(dropPosition, heart_sprite, "dropHeart", 10);
      Item dropHeart = new Item(dropPosition, heart_sprite, "dropHeart", true, 10, false, 0);
      currentLevel.dropItems.add(dropHeart);
    } 
    
    else if (randomValue <= dropNothingProbability + dropSilverKeyProbability + dropHeartProbability + dropHalfHeartProbability) 
    {
      // drop del mezzocuore
      // Healer dropHalfHeart = new Healer(dropPosition, half_heart_sprite, "dropHalfHeart", 5);
      Item dropHalfHeart = new Item(dropPosition, half_heart_sprite, "dropHalfHeart", true, 5, false, 0);
      currentLevel.dropItems.add(dropHalfHeart);
    }
  }


  // override dei metodi dell'interfaccia
  @Override
    public void takeDamage(int damage) {
    enemyHP -= damage;

    // testo danno subito dal nemico
    TextDisplay damageHitText = new TextDisplay(position, Integer.toString(damage), color(255, 0, 0));
    damageHitText.display(render.spritesLayer);

    if (enemyHP < 0) {
      enemyHP = 0;
    }
  }

  @Override
    PVector getPosition() {
    return position;
  }
}
