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
    //// Itera attraverso tutti i corpi fisici
    //for (FBody body : bodies) {
    //  if(body.isSensor())
    //}
  }
}
