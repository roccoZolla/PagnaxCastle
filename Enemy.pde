class Enemy extends Character {
  // caratteristiche nemico
  int damage;
  String name;
  int scoreValue;

  // componenti fisiche
  float velocity_x = 0;
  float velocity_y = 0;
  float speed = 10f;

  // sara settabile per i vari tipi di nemici
  int SPRITE_SIZE = 16;
  final float INFLUENCE_RADIUS = 2.0;  // raggio di influenza dei nemici

  private final int attack_interval = 60; // Tempo di cooldown in millisecondi (3 secondi)
  private long attack_timer = attack_interval;
  boolean first_attack;    // di base è true

  // drop probabilities constant
  // non definitive
  final float DROP_NOTHING = 0.3;
  final float DROP_SILVER_KEY = 0.1;
  final float DROP_HEART = 0.3;
  final float DROP_HALF_HEART = 0.3;

  Enemy(PImage sprite, int enemyHP, String name) {
    super();

    // sprite
    this.sprite = sprite;

    // setting's box
    box = new FBox(SPRITE_SIZE, SPRITE_SIZE);
    box.setName("Enemy");
    box.setFillColor(40);
    box.setAllowSleeping(true);  // permette al motore fisico di "addormentare" l'oggetto -> risparmio di risorse
    box.setRotatable(false);
    box.setFriction(1);   // quanto attrito fa
    box.setRestitution(0);  // quanto rimbalza
    box.setDamping(0);      // ammortizza il movimento

    // characteristics
    this.hp = enemyHP;
    this.name = name;

    first_attack = true;
  }

  void setDamage(int damage) {
    this.damage = damage;
  }

  int getDamage() {
    return damage;
  }

  void setScoreValue(int scoreValue) {
    this.scoreValue = scoreValue;
  }

  int getScoreValue() {
    return scoreValue;
  }

  // gestisce il movimento del nemico
  // da migliorare
  void update()
  {
    followPattern();

    if (isPlayerInfluenced())
    {
      // moveToPlayer();
    }
  }

  private void followPattern()
  {
    // Calcola una direzione casuale
    float dx = random(-1, 1);
    float dy = random(-1, 1);

    // Normalizza la direzione
    PVector direction = new PVector(dx, dy);
    direction.normalize();

    // Moltiplica la direzione per una velocità costante
    //float speed = 1.0; // Velocità desiderata
    //direction.mult(speed);

    //// Applica il movimento al nemico
    //box.addForce(direction.x, direction.y);
    
    PVector movement = new PVector(dx, dy);
    movement.normalize();

    // Applica la velocità costante
    movement.mult(speed);

    // Applica l'accelerazione
    box.setVelocity(movement.x, movement.y);
  }

  private boolean isPlayerInfluenced()
  {
    // Calcola la distanza tra il nemico e il giocatore
    PVector enemyPos = getPosition().copy();
    enemyPos.x = ( enemyPos.x - (SPRITE_SIZE/2) ) / SPRITE_SIZE;
    enemyPos.y = ( enemyPos.y - (SPRITE_SIZE/2) ) / SPRITE_SIZE;

    PVector playerPos = p1.getPosition().copy();
    playerPos.x = ( playerPos.x - (SPRITE_SIZE/2) ) / SPRITE_SIZE;
    playerPos.y = ( playerPos.y - (SPRITE_SIZE/2) ) / SPRITE_SIZE;

    float distanceToPlayer = PVector.dist(enemyPos, playerPos);

    // Verifica se il giocatore è all'interno dell'area di influenza del nemico
    return (distanceToPlayer <= INFLUENCE_RADIUS);
  }

  private void moveToPlayer()
  {
    println("move to player");
    // Ottieni la posizione corrente del nemico
    PVector enemyPos = getPosition();

    // Ottieni la posizione corrente del giocatore
    PVector playerPos = p1.getPosition();

    // Calcola il vettore di direzione dal nemico al giocatore
    PVector directionToPlayer = PVector.sub(playerPos, enemyPos);
    directionToPlayer.normalize();

    // Moltiplica il vettore di direzione per la velocità desiderata
    directionToPlayer.mult(speed);

    // Imposta la velocità del nemico
    box.setVelocity(directionToPlayer.x, directionToPlayer.y);
  }


  // attacca il giocatore
  void attack(Player player) {
    if (first_attack) {
      // Esegui l'attacco
      // player.takeDamage(damage);

      // fare in modo che rimanga un po piu di tempo a schermo

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
      game.addDropItem(dropSilverKey);
    } else if (randomValue <= DROP_NOTHING + DROP_SILVER_KEY + DROP_HEART)
    {
      // drop del cuore intero
      Item dropHeart = new Item(heart_sprite, "dropHeart", true, 10, false, 0);
      dropHeart.updatePosition(dropPosition);
      game.addDropItem(dropHeart);
    } else if (randomValue <= DROP_NOTHING + DROP_SILVER_KEY + DROP_HEART + DROP_HALF_HEART)
    {
      // drop del mezzocuore
      Item dropHalfHeart = new Item(half_heart_sprite, "dropHalfHeart", true, 5, false, 0);
      dropHalfHeart.updatePosition(dropPosition);
      game.addDropItem(dropHalfHeart);
    }
  }
}
