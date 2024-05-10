class CollisionSystem
{
  FWorld world;
  ArrayList<FBody> bodies;

  CollisionSystem() {
  }

  void init()
  {
    // world = currentLevel.level;
    // bodies = world.getBodies();
    println("collision system inizializzato correttamente!");
  }

  void update()
  {
  }
}


// trovare una soluzione piu elegante
// Questo metodo viene chiamato quando un contatto inizia
void contactStarted(FContact contact) {
  // Ottieni i corpi fisici coinvolti nel contatto
  FBody body1 = contact.getBody1();
  FBody body2 = contact.getBody2();

  // controlla se è un moneta
  String bodyName1 = body1.getName();
  String bodyName2 = body2.getName();

  println("body 1 : " + bodyName1);
  println("body 2 : " + bodyName2);

  // Controlla se uno dei corpi è un sensore (moneta, scale, trappole)
  if (body1.isSensor() || body2.isSensor())
  {
    // coin
    if (bodyName1.equals("Coin") && bodyName2.equals("Player")
      || bodyName2.equals("Coin") && bodyName1.equals("Player"))
    {
      if (bodyName1.equals("Coin"))
      {
        game.handleCoin(body1);
      } else
      {
        game.handleCoin(body2);
      }
    }

    // peaks
    // da sistemare 
    if (bodyName1.equals("Trap") && (bodyName2.equals("Player") || bodyName2.equals("Enemy"))
      || bodyName2.equals("Trap") && (bodyName1.equals("Player") || bodyName1.equals("Enemy")))
    {
      if (bodyName1.equals("Trap"))
      {
        game.handlePeaks(body1, body2);
      } else {
        game.handlePeaks(body2, body1);
      }
    }

    // stairs
    if (bodyName1.equals("Stairs") && bodyName2.equals("Player")
      || bodyName2.equals("Stairs") && bodyName1.equals("Player"))
    {
      if (bodyName1.equals("Stairs"))
      {
        // game.handleNextLevel();
      } else {
        // game.handleNextLevel();
      }
    }
  }

  // collisione con le chest
  if (bodyName1.equals("Chest") && bodyName2.equals("Player")
    || bodyName2.equals("Chest") && bodyName1.equals("Player"))
  {
    if (bodyName1.equals("Chest"))
    {
      game.handleChest(body1);
      render.isCollidingWithChest = true;
      render.isPossibleToOpenChest = true;
    } else {
      game.handleChest(body2);
      render.isCollidingWithChest = true;
      render.isPossibleToOpenChest = true;
    }
  }

  // collisione con i nemici
  // da migliorare
  if (bodyName1.equals("Enemy") && bodyName2.equals("Player")
    || bodyName2.equals("Enemy") && bodyName1.equals("Player"))
  {
    if (bodyName1.equals("Enemy"))
    {
      game.handleEnemyAttack(body1);
    } else {
      game.handleEnemyAttack(body2);
    }
  }
}

// Questo metodo viene chiamato quando un contatto persiste (continua)
void contactPersisted(FContact contact) {
  // Puoi gestire il contatto persistente qui, se necessario
}

// Questo metodo viene chiamato quando un contatto termina
void contactEnded(FContact contact) {
  // Puoi gestire il contatto terminato qui, se necessario
  // da sistemare ma ci sta
  render.isCollidingWithChest = false;
}
