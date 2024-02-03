// classe che si occupa della generazione del mondo
class World {
  ArrayList<Zone> zones = new ArrayList<>(); // lista delle aree che compongono il gioco
  Zone currentZone;

  World() {
    // System.out.println("Creazione del mondo...");
    // 5 livelli da massimo 8 stanze ciascuno
    Zone cellar = new Zone(0, "Castle", 5, "data/zone_1/", 8);
    cellar.storyText = "Nel lontano Regno di Lontano la principessa Chela e' stata rapita dallo stregone Pagnax.\n" +
      "Sei stato mandato al castello dello stregone pazzo dove si dice che ogni piano cambi in continuazione.\n" +
      "Devi salvare la principessa e sconfiggere Pagnax, che la casualita' ti aiuti Cavaliere.\n";

    cellar.setFinalArea(true);

    //println("numero di livello: " + cellar.numLevels);
    //println("size levels: " + cellar.levels.size());

    currentZone = cellar;
  }
}
