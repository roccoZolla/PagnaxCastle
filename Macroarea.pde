class Macroarea {
  private String storyText = "";
  
  private int areaIndex;
  private String areaName = "";
  private String filesPath = ""; // indica il percorso in cui sono presenti i file delle texture
  private boolean finalArea = false;
  
  // ogni stanza è caratterizzata da un certo numero di livelli, di nemici e di casse
  int numLevels;
  int chests;
  int enemies;
  
  private ArrayList<Level> levels = new ArrayList<>();
  private Level currentLevel;
  
  Macroarea(int areaIndex, String areaName, int numLevels, String dataPath) {
    this.areaIndex = areaIndex;
    this.areaName = areaName;
    this.numLevels = numLevels;
    this.filesPath = dataPath;
    
    // chiama metodo per la creazione dei livelli (usa numLevels)
    for(int i = 0; i < numLevels; i++){
      Level level = new Level("Livello " + i, i, dataPath);
      levels.add(level);
    }
    
    currentLevel = levels.get(0);
  }
  
  void initLevels() {
    System.out.println("creando i livelli..");
    for(int i = 0; i < levels.size(); i++) {
      levels.get(i).init();
    }
  }
  
  void setFinalArea(boolean finalArea) {
    this.finalArea = finalArea;
  }
  
  boolean isFinal() {
    return finalArea;
  }
  
  int getAreaIndex() {
    return areaIndex;
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
  
  String getStory() {
    return this.storyText;
  }
  
  void setStory(String storyText) {
    this.storyText = storyText;
  }
} 
