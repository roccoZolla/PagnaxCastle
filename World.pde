// classe che si occupa della generazione del mondo
class World {
  private ArrayList<Macroarea> macroareas = new ArrayList<>(); // lista delle aree che compongono il gioco
  private Macroarea currentMacroarea;
  
  World() {
   System.out.println("Creazione del mondo...");
    Macroarea cellar = new Macroarea(0, "Cellar", 1, "data/zone_1/");
    cellar.setStory("La principessa Chela è in pericolo. È stata rapita da un cattivone.\n" +
    "Vai al castello del cattivone ma vieni subito scoperto e mandato nelle cantine del castello.\n" +
    "Devi risalire il castello fino alle sale reali per sconfiggere il cattivone di turno.\n");
    macroareas.add(cellar);
    currentMacroarea = cellar;
    
    Macroarea piano_base = new Macroarea(1, "piano_base", 3, "data/zone_2/");
    macroareas.add(piano_base);    
    
    piano_base.setStory("Sei arrivato al piano base daje roma daje!\n");
    
    Macroarea finalArea = new Macroarea(1, "Royal halls", 1, "data/zone_3/");
    finalArea.setFinalArea(true);
    macroareas.add(finalArea);
  }
  
  Macroarea getCurrentMacroarea() {
    return currentMacroarea;
  }
  
  ArrayList<Macroarea> getMacroareas() {
    return macroareas;
  }

}
