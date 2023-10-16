class Macroarea {
  private String areaName = "";
  private String filesPath = ""; // indica il percorso in cui sono presenti i file delle texture
  
  // ogni stanza è caratterizzata da un certo numero di livelli, di nemici e di casse
  int numLevels;
  int chests;
  int enemies;
  
  private ArrayList<Level> levels = new ArrayList<>();
  private Level currentLevel;
  
  Macroarea(String areaName, int numLevels) {
    this.areaName = areaName;
    this.numLevels = numLevels;
    
    // chiama metodo per la creazione dei livelli (usa numLevels)
    for(int i = 0; i < numLevels; i++){
      System.out.println("creazione dei livelli");
      Level level = new Level("Livello " + i, i);
      
      level.init();
      
      levels.add(level);
    }
    
    currentLevel = levels.get(0);
  }
  
  String getName() {
    return areaName;
  }
  
  Level getCurrentLevel() {
    return currentLevel;
  }
  
  ArrayList<Level> getLevels() {
    return levels;
  }
  
  int getNumbLevels() {
    return numLevels;
  }
} 
