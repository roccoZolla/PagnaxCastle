class Zone {
  int zoneIndex;
  // definitivi
  String name;
  int numberLevels; // numero di livelli di cui è composta la zona
  boolean isFinalZone = false;  // di base è false

  // ogni stanza è caratterizzata da un certo numero di livelli, di nemici e di casse
  int numLevels;



  // assets della zona
  //PImage startFloorImage;
  //PImage floorImage; // Immagine per il pavimento
  //PImage wallImageNorth;
  //PImage hallwayImage;         // immagine per i corridoi
  //PImage peaksTrapImage;
  //PImage stairsNextFloorImage; // scale per accedere al livello successivo

    //ArrayList<Level> levels = new ArrayList<>();
    //Level currentLevel;

  //Zone(int zoneIndex, String zoneName, int numLevels, String filesPath, int numberOfRooms) {
  //  this.zoneIndex = zoneIndex;
  //  this.name = zoneName;
  //  this.numLevels = numLevels;
  //  this.dataPath = filesPath;
  //  this.isFinalZone = false;

  //  createLevel(numberOfRooms);

  //  currentLevel = levels.get(0);
  //}

  Zone()
  {
  }

  String getName() {
    return name;
  }

  int getNumberOfLevels() {
    return numberLevels;
  }

  void setName(String name) {
    this.name = name;
  }

  void setNumberLevels(int numberLevels)
  {
    this.numberLevels = numberLevels;
  }

  //void createLevel(int numberOfRooms) {
  //  for (int i = 0; i < numLevels; i++) {
  //    Level level = new Level("Livello " + (i + 1), i, numberOfRooms);    // da modificare assegnazione stringa con i+1
  //    // println("Level index: " + level.levelIndex);
  //    levels.add(level);
  //  }
  //}

  //Level createBossLevel() {
  //  // println("creazione del livello finale...");
  //  Level bossLevel = new Level("Livello finale", 0, 1);
  //  return bossLevel;
  //}

  void setFinalZone() {
    this.isFinalZone = true;
  }

  boolean IsFinal() {
    return isFinalZone;
  }
}
