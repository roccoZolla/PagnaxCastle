// Interfaccia per gli oggetti che possono subire danni
interface Damageable {
  void takeDamage(int damage);
  PVector getPosition();
}

abstract class DamageHandler {
  private static final long ATTACK_COOLDOWN = 2000;
  private long lastAttackTime = 0;
  private boolean firstTimeDamageTile = true;

  abstract boolean isDamageTile(int roundedX, int roundedY);

  abstract void playHurtSound();

  void handleDamageTiles(Damageable damageable, int x, int y) {
    long currentTime = System.currentTimeMillis();

    if (isDamageTile(x, y)) {
      if (currentTime - lastAttackTime >= ATTACK_COOLDOWN || firstTimeDamageTile) {
        performPeriodicAttack(damageable, currentTime);
      }
    } else {
      resetAttackTimer(currentTime);
      firstTimeDamageTile = true;
    }
  }

  private void performPeriodicAttack(Damageable damageable, long currentTime) {
    damageable.takeDamage(currentLevel.DAMAGE_PEAKS);
    TextDisplay damageHitText = new TextDisplay(damageable.getPosition(), Integer.toString(currentLevel.DAMAGE_PEAKS), color(255, 0, 0));
    damageHitText.display(game.spritesLayer);
    playHurtSound();

    //println("---- DANNO DA DAMAGE TILE ----");
    //println("posizione: " + damageable.getPosition());

    // da rivedere
    game.spritesLayer.rectMode(CENTER);
    game.spritesLayer.fill(255, 0, 0); // nero
    game.spritesLayer.stroke(255);
    game.spritesLayer.rect(damageable.getPosition().x * currentLevel.tileSize + currentLevel.tileSize / 2, damageable.getPosition().y * currentLevel.tileSize + currentLevel.tileSize / 2, currentLevel.tileSize, currentLevel.tileSize);

    lastAttackTime = currentTime;
    firstTimeDamageTile = false;
  }

  private void resetAttackTimer(long currentTime) {
    lastAttackTime = currentTime;
  }
}

class ConcreteDamageHandler extends DamageHandler {
  // Implementa i metodi astratti della classe base DamageHandler

  @Override
    boolean isDamageTile(int x, int y) {
    if (currentLevel.map[x][y] == 7) return true;

    return false;
  }

  @Override
    void playHurtSound() {
    hurt_sound.play();
  }
}
