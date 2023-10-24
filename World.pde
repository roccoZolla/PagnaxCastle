// classe che si occupa della generazione del mondo
class World {
  private ArrayList<Macroarea> macroareas = new ArrayList<>(); // lista delle aree che compongono il gioco
  private Macroarea currentMacroarea;
  
  World() {
   System.out.println("Creazione del mondo...");
    Macroarea cellar = new Macroarea(0, "Cellar", 2, "data/zone_1/", 8);
    cellar.setStory("La principessa Chela è in pericolo. È stata rapita dallo stregone Pagnax.\n" +
    "Vai al castello del cattivone ma vieni subito scoperto e mandato nelle cantine del castello.\n" +
    "Devi risalire il castello fino alle sale reali per sconfiggere il cattivone di turno.\n");
    
    cellar.setFinalArea(true);
    
    //Macroarea piano_base = new Macroarea(1, "piano_base", 1, "data/zone_2/");
    //piano_base.setStory("Sei arrivato al piano base daje roma daje!\n");   
    
    //macroareas.add(cellar);
    //macroareas.add(piano_base);
    
    currentMacroarea = cellar;
    
    //Macroarea finalArea = new Macroarea(2, "Royal halls", 1, "data/zone_3/");
    //finalArea.setStory("Area finale yuppi yeah!");
    //finalArea.setFinalArea(true);
    //macroareas.add(finalArea);
  }
  
  Macroarea getCurrentMacroarea() {
    return currentMacroarea;
  }
  
  ArrayList<Macroarea> getMacroareas() {
    return macroareas;
  }

}
