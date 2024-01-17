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
  
  // assets della zona
  PImage startFloorImage;
  PImage floorImage; // Immagine per il pavimento
  PImage wallImageNorth;
  PImage hallwayImage;         // immagine per i corridoi
  PImage peaksTrapImage;
  PImage stairsNextFloorImage; // scale per accedere al livello successivo

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
  
  void loadAssetsZone() {
    println("carico gli assets della zona...");
    floorImage = loadImage(filesPath + "floorTile.png");
    wallImageNorth = loadImage(filesPath + "northWallTop.png");
    hallwayImage = loadImage(filesPath + "hallwayTile.png");
    stairsNextFloorImage = loadImage(filesPath + "stairsNextFloor.png");
    peaksTrapImage = loadImage("data/trap/peaks.png");
    hallwayImage = loadImage(filesPath + "hallwayTile.png");
    stairsNextFloorImage = loadImage(filesPath + "stairsNextFloor.png");
  }
  
  void createLevel(String filesPath, int numberOfRooms) {
    for (int i = 0; i < numLevels; i++) {
      Level level = new Level("Livello " + (i+1), i, filesPath, numberOfRooms);
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
