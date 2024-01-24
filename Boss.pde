// classe del boss
class Boss {
  PImage sprite;
  PVector spritePosition;
  PVector spriteVelocity;      // velocita corrente del boss
  float spriteSpeed;           // velocita desiderata a cui deve andare il boss
  ArrayList<Projectile> projectiles;    // proiettili
  
  String name;
  int maxHP;
  int HP;
  
  Boss(float x, float y, float speed, String name, int HP, int maxHP) {
    spritePosition = new PVector(x, y);
    spriteVelocity = PVector.random2D();
    this.spriteSpeed = speed;
    projectiles = new ArrayList<Projectile>();
    
    this.name = name;
    this.HP = HP;
    this.maxHP = maxHP;
  }

  void update(Player player) {
    // Calcola la direzione verso il giocatore
    PVector direction = PVector.sub(player.spritePosition, spritePosition);
    direction.normalize();

    // Muovi il boss nella direzione del giocatore
    spriteVelocity = direction.mult(spriteSpeed);
    spritePosition.add(spriteVelocity);

    // Lancio di proiettili nella direzione del giocatore
    if (frameCount % 120 == 0) {  // Lanciare un proiettile ogni secondo
      Projectile projectile = new Projectile(spritePosition.x, spritePosition.y, direction);
      projectiles.add(projectile);
    }

    // Muovi i proiettili
    for (Projectile projectile : projectiles) {
      projectile.update();
    }
  }

  void display() {
    // Disegna il boss
    spritesLayer.noFill(); // Nessun riempimento
    spritesLayer.stroke(255, 23, 23);

    float centerX = spritePosition.x * currentLevel.tileSize + sprite.width / 2;
    float centerY = spritePosition.y * currentLevel.tileSize + sprite.height / 2;

    spritesLayer.imageMode(CENTER); // Imposta l'imageMode a center
    spritesLayer.image(sprite, centerX, centerY, sprite.width * 1.5, sprite.height * 1.5);

    // Disegna i proiettili
    for (Projectile projectile : projectiles) {
      projectile.display();
    }
  }
}

class Projectile {
  PVector position;
  PVector velocity;

  Projectile(float x, float y, PVector direction) {
    position = new PVector(x, y);
    velocity = PVector.mult(direction, 5.0);  // Velocità dei proiettili
  }

  void update() {
    // Muovi il proiettile
    position.add(velocity);
  }

  void display() {
    // Disegna il proiettile
    spritesLayer.fill(255, 22, 239);
    spritesLayer.ellipse(position.x * currentLevel.tileSize, position.y * currentLevel.tileSize, 10, 10);
  }
}
