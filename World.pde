// classe che si occupa della generazione del mondo
class World {
  ArrayList<Zone> zones = new ArrayList<>(); // lista delle aree che compongono il gioco
  Zone currentZone;

  World() {
    System.out.println("Creazione del mondo...");
    Zone cellar = new Zone(0, "Castle", 1, "data/zone_1/", 8);
    cellar.storyText = "Nel lontano Regno di Lontano la principessa Chela e' stata rapita dallo stregone Pagnax.\n" +
      "Sei stato mandato al castello pazzo dello stregone dove si dice che ogni piano cambi in continuazione.\n" +
      "Devi salvare la principessa e sconfiggere Pagnax, che la casualita' ti aiuti cavaliere.\n";

    cellar.setFinalArea(true);

    println("numero di livello: " + cellar.numLevels);
    println("size levels: " + cellar.levels.size());

    currentZone = cellar;
  }
}
