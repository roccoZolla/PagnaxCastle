// classe che si occupa della generazione del mondo
class World {
  private ArrayList<Macroarea> macroareas = new ArrayList<>(); // lista delle aree che compongono il gioco
  private Macroarea currentMacroarea;
  
  World() {
   System.out.println("Creazione del mondo...");
    Macroarea cellar = new Macroarea("Cellar", 5);
    
    macroareas.add(cellar);
    currentMacroarea = cellar;
  }
  
  Macroarea getCurrentMacroarea() {
    return currentMacroarea;
  }

}
