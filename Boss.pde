// classe del boss
class Boss extends Character {
<<<<<<< HEAD
  // PVector spriteVelocity;      // velocita corrente del boss
  float speed = 100.0f;           // velocita desiderata a cui deve andare il boss
=======
  PVector spriteVelocity;      // velocita corrente del boss
  float spriteSpeed;           // velocita desiderata a cui deve andare il boss
>>>>>>> fix
  ArrayList<Projectile> projectiles;    // proiettili
  
  final float OFFSET = 1.5;

  // String name;
  int maxHP;
  final float damage_resistence = 0.7; // capacita del boss di resistere ai danni

<<<<<<< HEAD
  Boss(PImage sprite, int hp, int maxHP) {
=======
  Boss(PVector position, PImage sprite, float speed, String name, int HP, int maxHP) {
>>>>>>> fix
    // sprite
    this.sprite = sprite;
    
    // setting's box
<<<<<<< HEAD
    box = new FBox(SPRITE_SIZE * OFFSET, SPRITE_SIZE * OFFSET);
    box.setName("Boss");
    box.setFillColor(10);
    box.setRotatable(false);
    box.setFriction(0.5);
    box.setRestitution(0);
    
    // spriteVelocity = PVector.random2D();
    // projectiles = new ArrayList<Projectile>();
=======
    box = new FBox(SPRITE_SIZE * 1.5, SPRITE_SIZE * 1.5);
    box.setFillColor(10);
    box.setRotatable(false);
    box.setFriction(0.5);
    box.setRestitution(0.2);
    
    
    spriteVelocity = PVector.random2D();
    this.spriteSpeed = speed;
    projectiles = new ArrayList<Projectile>();
>>>>>>> fix

    this.hp = hp;
    this.maxHP = maxHP;
  }
  
  // da rivedere completamente 
  //void update(Player player) {
  //  // Calcola la direzione verso il giocatore
  //  PVector direction = PVector.sub(player.getPosition(), position);
  //  direction.normalize();

  //  // Muovi il boss nella direzione del giocatore
  //  spriteVelocity = direction.mult(spriteSpeed);

  //  // if (!collision.check_collision(this, p1)) position.add(spriteVelocity);

  //  // Lancio di proiettili nella direzione del giocatore
  //  if (frameCount % 120 == 0) {  // Lanciare un proiettile ogni secondo
  //    // costoso creare una nuova istanza di proiettile
  //    Projectile projectile = new Projectile(position.x, position.y, direction);
  //    projectiles.add(projectile);
  //  }

  //  // Muovi i proiettili
  //  Iterator<Projectile> iterator = projectiles.iterator();
  //  while (iterator.hasNext()) {
  //    Projectile projectile = iterator.next();
  //    projectile.update();

  //    // verifica se il proiettile ha colpito il player
  //    //if (collision.check_collision(projectile, p1) && !projectile.attack_executed) {
  //    //  p1.takeDamage(projectile.damage);
  //    //  projectile.attack_executed = true;
  //    //}

  //    // verifica se il proiettile colpisce il boss
  //    // se l'attacco non è stato eseguito e puo colpire il boss
  //    //if (collision.check_collision(projectile, this) && !projectile.attack_executed && projectile.canHitBoss) {
  //    //  takeDamage(projectile.damage);
  //    //  projectile.attack_executed = true;
  //    //  // println("boss colpito...");
  //    //}

  //    // verifica se il giocatore colpisce con l'arma un proiettile
  //    // il giocatore sta attaccando e l'attacco non è stato eseguito
  //    // e il proiettile puo essere colpito
  //    //if (p1.isAttacking && !p1.attackExecuted &&
  //    //  projectile.isHittable && collision.check_collision(projectile, p1.weapon)) {
  //    //  projectile.reverseDirection();
  //    //  projectile.canHitBoss = true;
  //    //  projectile.isHittable = false;
  //    //}

  //    // Rimuovi il proiettile se ha colpito il giocatore o il boss, o se è uscito dal campo di gioco
  //    if (projectile.attack_executed || !isWithinMapBounds((int)projectile.getPosition().x, (int)projectile.getPosition().y)) {
  //      iterator.remove();
  //    }
  //  }
  //}
  
  //void takeDamage(int damage) {
  //  int actual_damage = (int) (damage * (1 - damage_resistence));
  //  HP -= actual_damage;

  //  hurt_sound.play();

<<<<<<< HEAD
  //  //TextDisplay damageHitText = new TextDisplay(position, Integer.toString(actual_damage), color(255, 0, 0));
  //  //damageHitText.display(render.spritesLayer);
=======
    //TextDisplay damageHitText = new TextDisplay(position, Integer.toString(actual_damage), color(255, 0, 0));
    //damageHitText.display(render.spritesLayer);
>>>>>>> fix

  //  if (HP < 0) {
  //    HP = 0;
  //  }
  //  // println("vita boss: " + HP);
  //}

// da togliere
<<<<<<< HEAD
//  @Override
//    void display(PGraphics layer) {
//    // Disegna il boss
//    layer.noFill(); // Nessun riempimento
//    layer.stroke(255, 23, 23);

////    float centerX = box.getX() * currentLevel.tileSize + sprite.width / 2;
////    float centerY = box.getY() * currentLevel.tileSize + sprite.height / 2;

//    layer.imageMode(CENTER); // Imposta l'imageMode a center
//    layer.image(sprite, centerX, centerY, sprite.width, sprite.height);
=======
  @Override
    void display(PGraphics layer) {
    // Disegna il boss
    layer.noFill(); // Nessun riempimento
    layer.stroke(255, 23, 23);

    float centerX = box.getX() * currentLevel.tileSize + sprite.width / 2;
    float centerY = box.getY() * currentLevel.tileSize + sprite.height / 2;

    layer.imageMode(CENTER); // Imposta l'imageMode a center
    layer.image(sprite, centerX, centerY, sprite.width, sprite.height);
>>>>>>> fix

//    // Disegna i proiettili
//    for (Projectile projectile : projectiles) {
//      projectile.display(layer);
//      // projectile.displayHitbox(layer);
//    }
//  }
}

class Projectile extends Sprite {
  PVector velocity;
  int damage;    // danni provocati dal proiettile
  boolean attack_executed; // di base false
  boolean canHitBoss; // di base false, indica se il proiettile puo colpire il boss
  boolean isHittable; // puo essere colpito, di base true

  Projectile(float x, float y, PVector direction) {
    // sprite 
    this.sprite = orb_sprite;
    
    // settings box
    box = new FBox(SPRITE_SIZE * 1.5, SPRITE_SIZE * 1.5);
<<<<<<< HEAD
    box.setName("Projectile");
=======
>>>>>>> fix
    box.setFillColor(10);
    box.setRotatable(false);
    box.setFriction(0.5);
    box.setRestitution(0.2);
    
    velocity = PVector.mult(direction, 4.5);  // Velocità dei proiettili, 5 di base
    damage = 10;
    attack_executed = false;
    canHitBoss = false;
    isHittable = true;
  }

  void update() {
    // Muovi il proiettile
    // position.add(velocity);
  }

  void reverseDirection() {
    velocity.mult(-1);
  }
}
