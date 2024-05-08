class CollisionSystem
{
  FWorld world;
  ArrayList<FBody> bodies;

  CollisionSystem() {
  }

  void init()
  {
    world = currentLevel.level;
    bodies = world.getBodies();
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

  // Controlla se uno dei corpi è un sensore (moneta, scale, trappole)
  if (body1.isSensor() || body2.isSensor())
  {
    println("body 1 : " + bodyName1);
    println("body 2 : " + bodyName2);

    // coin
    if (bodyName1.equals("Coin") && bodyName2.equals("Player")
      || bodyName2.equals("Coin") && bodyName1.equals("Player"))
    {
      if (bodyName1.equals("Coin")) {
        // currentLevel.level.remove(body1);
        game.handleCoin(body1);
      } else {
        // currentLevel.level.remove(body2);
        game.handleCoin(body2);
      }
    }

    // peaks
    if (bodyName1.equals("Peaks") && (bodyName2.equals("Player") || bodyName2.equals("Enemy"))
      || bodyName2.equals("Peaks") && (bodyName1.equals("Player") || bodyName1.equals("Enemy")))
    {
      if (bodyName1.equals("Peaks")) {
        // game.handlePeaks(body1);
      } else {
        // game.handlePeaks(body2);
      }
    }

    // stairs
    if (bodyName1.equals("Stairs") && bodyName2.equals("Player")
      || bodyName2.equals("Stairs") && bodyName1.equals("Player"))
    {
      if (bodyName1.equals("Stairs")) {
        game.handleNextLevel();
      } else {
        game.handleNextLevel();
      }
    }
  }

  // collisione con le chest
  if (bodyName1.equals("Chest") && bodyName2.equals("Player")
    || bodyName2.equals("Chest") && bodyName1.equals("Player"))
  {
    if (bodyName1.equals("Chest")) {
      game.handleChest(body1);
      render.isCollidingWithChest = true;
      render.canOpenChest = true;
    } else {
      game.handleChest(body2);
      render.isCollidingWithChest = true;
      render.canOpenChest = true;
    }
  } 
  
  // collisione con i nemici
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
