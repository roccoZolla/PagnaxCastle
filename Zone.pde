class Zone {
  String storyText;

  int zoneIndex;
  String zoneName;
  String filesPath; // indica il percorso in cui sono presenti i file delle texture
  boolean finalArea;

  // ogni stanza è caratterizzata da un certo numero di livelli, di nemici e di casse
  int numLevels;
  int chests;
  int enemies;

  ArrayList<Level> levels = new ArrayList<>();
  Level currentLevel;

  Zone(int zoneIndex, String zoneName, int numLevels, String filesPath, int numberOfRooms) {
    this.storyText = "";

    this.zoneIndex = zoneIndex;
    this.zoneName = zoneName;
    this.numLevels = numLevels;
    this.filesPath = filesPath;
    this.finalArea = false;

    createLevel(filesPath, numberOfRooms);
    
    currentLevel = levels.get(0);
  }
  
  void createLevel(String filesPath, int numberOfRooms) {
    for (int i = 0; i < numLevels; i++) {
      Level level = new Level("Livello " + i, i, filesPath, numberOfRooms);
      levels.add(level);
    }
  }

  void setFinalArea(boolean finalArea) {
    this.finalArea = finalArea;
  }

  boolean isFinal() {
    return finalArea;
  }
}
