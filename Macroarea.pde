class Macroarea {
  String storyText;

  int areaIndex;
  String areaName;
  String filesPath; // indica il percorso in cui sono presenti i file delle texture
  boolean finalArea;

  // ogni stanza è caratterizzata da un certo numero di livelli, di nemici e di casse
  int numLevels;
  int chests;
  int enemies;

  ArrayList<Level> levels = new ArrayList<>();
  Level currentLevel;

  Macroarea(int areaIndex, String areaName, int numLevels, String filesPath, int numberOfRooms) {
    this.storyText = "";

    this.areaIndex = areaIndex;
    this.areaName = areaName;
    this.numLevels = numLevels;
    this.filesPath = filesPath;
    this.finalArea = false;

    for (int i = 0; i < numLevels; i++) {
      Level level = new Level("Livello " + i, i, filesPath, numberOfRooms);
      levels.add(level);
    }
    
    currentLevel = levels.get(0);
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
