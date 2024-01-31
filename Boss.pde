// classe del boss
class Boss extends Sprite {
  PVector spriteVelocity;      // velocita corrente del boss
  float spriteSpeed;           // velocita desiderata a cui deve andare il boss
  ArrayList<Projectile> projectiles;    // proiettili

  String name;
  int maxHP;
  int HP;
  final float damage_resistence = 0.5; // capacita del boss di resistere ai danni

  Boss(PVector position, PImage sprite, float speed, String name, int HP, int maxHP) {
    super(position, sprite);
    spriteVelocity = PVector.random2D();
    this.spriteSpeed = speed;
    projectiles = new ArrayList<Projectile>();

    this.name = name;
    this.HP = HP;
    this.maxHP = maxHP;
  }

  void update(Player player) {
    // Calcola la direzione verso il giocatore
    PVector direction = PVector.sub(player.getPosition(), position);
    direction.normalize();

    // Muovi il boss nella direzione del giocatore
    spriteVelocity = direction.mult(spriteSpeed);
    position.add(spriteVelocity);

    // Lancio di proiettili nella direzione del giocatore
    if (frameCount % 120 == 0) {  // Lanciare un proiettile ogni secondo
      // costoso creare una nuova istanza di proiettile
      Projectile projectile = new Projectile(position.x, position.y, direction);
      projectiles.add(projectile);
    }

    // Muovi i proiettili
    for (Projectile projectile : projectiles) {
      projectile.update();

      // verifica se il proiettile ha colpito il player
      if (projectile.sprite_collision(p1) && !projectile.attack_executed) {
        p1.takeDamage(projectile.damage);
        projectile.attack_executed = true;
      }

      // verifica se il proiettile colpisce il boss
      // se l'attacco non è stato eseguito e puo colpire il boss
      if (projectile.sprite_collision(this) && !projectile.attack_executed && projectile.canHitBoss) {
        takeDamage(projectile.damage);
        projectile.attack_executed = true;
        println("boss colpito...");
      }

      // verifica se il giocatore colpisce con l'arma un proiettile
      // il giocatore sta attaccando e l'attacco non è stato eseguito
      // e il proiettile puo essere colpito
      if (p1.isAttacking && !p1.attackExecuted && 
          projectile.isHittable && projectile.sprite_collision(p1.weapon)) {
        projectile.reverseDirection();
        projectile.canHitBoss = true;
        projectile.isHittable = false;
      }
    }
  }

  void takeDamage(int damage) {
    int actual_damage = (int) (damage * (1 - damage_resistence));
    HP -= actual_damage;

    hurt_sound.play();

    TextDisplay damageHitText = new TextDisplay(position, Integer.toString(actual_damage), color(255, 0, 0));
    damageHitText.display(game.spritesLayer);

    if (HP < 0) {
      HP = 0;
    }
    println("vita boss: " + HP);
  }

  @Override
    void display(PGraphics layer) {
    // Disegna il boss
    layer.noFill(); // Nessun riempimento
    layer.stroke(255, 23, 23);

    float centerX = position.x * currentLevel.tileSize + sprite.width / 2;
    float centerY = position.y * currentLevel.tileSize + sprite.height / 2;

    layer.imageMode(CENTER); // Imposta l'imageMode a center
    layer.image(sprite, centerX, centerY, sprite.width * 1.5, sprite.height * 1.5);

    // Disegna i proiettili
    for (Projectile projectile : projectiles) {
      projectile.display(layer);
      projectile.displayHitbox(layer);
    }
  }
}

class Projectile extends Sprite {
  PVector velocity;
  int damage;    // danni provocati dal proiettile
  boolean attack_executed; // di base false
  boolean canHitBoss; // di base false, indica se il proiettile puo colpire il boss
  boolean isHittable; // puo essere colpito, di base true

  Projectile(float x, float y, PVector direction) {
    super(new PVector(x, y), orb_sprite);
    velocity = PVector.mult(direction, 4.5);  // Velocità dei proiettili, 5 di base
    damage = 10;
    attack_executed = false;
    canHitBoss = false;
    isHittable = true;
  }

  void update() {
    // Muovi il proiettile
    position.add(velocity);
  }

  void reverseDirection() {
    velocity.mult(-1);
  }
}
