class Level {
  private String levelName;
  private int levelIndex;
  private String dataPath;
  private boolean completed = false;
  private int numberOfRooms;

  // rooms
  private int tileSize = 16;
  private int cols, rows;
  private int[][] map;
  private ArrayList<PVector> roomS; // Memorizza le posizioni delle stanze
  private ArrayList<Room> rooms;

  // attributi
  private PImage startFloorImage;
  private PImage floorImage; // Immagine per il pavimento
  // private PImage wallImage;  // Immagine per sfondo
  // pareti delle stanze
  private PImage wallImageNorth;
  private PImage wallImageNorthTop;
  private PImage wallImageNorthBottom;
  private PImage wallImageSouth;
  private PImage wallImageEast;
  private PImage wallImageWest;
  private PImage hallwayImage;         // immagine per i corridoi
  private PImage stairsNextFloorImage; // scale per accedere al livello successivo

  // chest che puoi trovare nel livello
  private int spawnLevel = 3; // Livello di spawn
  private ArrayList<Chest> treasures; // Memorizza le posizioni degli oggetti

  // nemici che puoi trovare nel livello
  private int numberOfEnemies = 5;  // livello di spawn dei nemici
  private ArrayList<Enemy> enemies; // Lista dei nemici

  PVector finalRoomPosition;
  PVector nextLevelStartRoomPosition;

  private int startRoomIndex;
  private int endRoomIndex;

  Level(String levelName, int levelIndex, String dataPath, int numberOfRooms) {
    this.levelName = levelName;
    this.completed = false;
    this.levelIndex = levelIndex;
    this.dataPath = dataPath;
    this.numberOfRooms = numberOfRooms;
    //finalRoomPosition = new PVector(int(random(width)), int(random(height)));
    //nextLevelStartRoomPosition = new PVector(int(random(width)), int(random(height)));
  }

  void init() {
    // inizializzo il livello
    System.out.println("inizializzo il livello");
    // logica per la creazione del livello (mappa del livello)
    cols = width / tileSize;
    rows = height / tileSize;

    map = new int[cols][rows];
    rooms = new ArrayList<Room>();
    treasures = new ArrayList<Chest>(); // Inizializza l'arraylist qui

    startFloorImage = loadImage(dataPath + "startTile.png");
    floorImage = loadImage(dataPath + "floorTile.png");
    // wallImage = loadImage(dataPath + "wallTile.png");

    wallImageNorth = loadImage(dataPath + "northWallTop.png");
    //wallImageNorthTop = loadImage(dataPath + "northWallTop.png");
    //wallImageNorthBottom = loadImage(dataPath + "northWallBottom.png");

    //wallImageSouth = loadImage(dataPath + "southWall.png");
    //wallImageEast = loadImage(dataPath + "eastWall.png");
    //wallImageWest = loadImage(dataPath + "westWall.png");

    hallwayImage = loadImage(dataPath + "hallwayTile.png");
    stairsNextFloorImage = loadImage(dataPath + "stairsNextFloor.png");

    // Genera stanze
    generateRooms();

    // Collega le stanze con corridoi
    connectRooms();

    // da rimuovere
    map[int(rooms.get(startRoomIndex).getPosition().x)][int(rooms.get(startRoomIndex).getPosition().y)] = 2; // Stanza iniziale
    map[int(rooms.get(endRoomIndex).getPosition().x)][int(rooms.get(endRoomIndex).getPosition().y)] = 3; // Stanza finale

    // aggiungi i nemici
    // da chiamare quando il giocatore entra nella stanza
    generateEnemies();

    // genera i loot
    generateRandomChests();
  }

  int getTileSize() {
    return tileSize;
  }

  int getCols() {
    return cols;
  }

  int getRows() {
    return rows;
  }

  int[][] getMap() {
    return map;
  }

  PVector getNextLevelStartRoomPosition() {
    return nextLevelStartRoomPosition;
  }

  int getLevelIndex() {
    return levelIndex;
  }

  String getName() {
    return levelName;
  }

  PVector getStartRoom() {
    return rooms.get(startRoomIndex).getPosition();
  }

  PVector getEndRoomPosition() {
    return rooms.get(endRoomIndex).getPosition();
  }

  ArrayList<Enemy> getEnemies() {
    return enemies;
  }

  ArrayList<Chest> getChests() {
    return treasures;
  }

  // metodi per la generazione delle stanze
  private void generateRooms() {
    for (int i = 0; i < numberOfRooms; i++) {
      generateRandomRoom();
    }

    // Scegli la stanza iniziale e finale
    startRoomIndex = int(random(rooms.size()));
    endRoomIndex = int(random(rooms.size()));

    while (endRoomIndex == startRoomIndex) {
      endRoomIndex = int(random(rooms.size()));
    }
  }

  private void generateRandomRoom() {
    int roomWidth = int(random(8, 20));
    int roomHeight = int(random(8, 20));
    int roomX, roomY;

    boolean roomOverlap;
    do {
      roomX = int(random(1, cols - roomWidth - 1));
      roomY = int(random(1, rows - roomHeight - 1));
      roomOverlap = checkRoomOverlap(roomX, roomY, roomWidth, roomHeight);
    } while (roomOverlap);

    // Estrai i muri dell'immagine dei muri delle stanze
    for (int x = roomX; x < roomX + roomWidth; x++) {
      for (int y = roomY; y < roomY + roomHeight; y++) {
        if (x == roomX || x == roomX + roomWidth - 1 || y == roomY || y == roomY + roomHeight - 1) {
          // Questi sono i bordi della stanza, quindi imposta il tile come tileType 3
          map[x][y] = 4; // Imposta il tile come muro del perimetro
        } else {
          map[x][y] = 1; // Imposta il tile come pavimento
        }
      }
    }

    // Memorizza la posizione della stanza
    rooms.add(new Room(roomWidth, roomHeight, new PVector(roomX + roomWidth / 2, roomY + roomHeight / 2)));
  }

  private boolean checkRoomOverlap(int x, int y, int width, int height) {
    for (int i = x - 1; i < x + width + 1; i++) {
      for (int j = y - 1; j < y + height + 1; j++) {
        // Verifica se il tile è già occupato (1 rappresenta il pavimento)
        if (map[i][j] == 1 || map[i][j] == 4) {
          return true;
        }
      }
    }
    return false;
  }

  private void connectRooms() {
    for (int i = 0; i < rooms.size() - 1; i++) {
      PVector room1 = rooms.get(i).getPosition();
      PVector room2 = rooms.get(i + 1).getPosition();

      int x1 = int(room1.x);
      int y1 = int(room1.y);
      int x2 = int(room2.x);
      int y2 = int(room2.y);

      // Collega le stanze con un corridoio
      while (x1 != x2 || y1 != y2) {
        if (map[x1][y1] != 1) map[x1][y1] = 5; // Imposta il tile come spazio vuoto (corridoio)

        int choice = int(random(2));
        if (choice == 0) {
          x1 += (x1 < x2) ? 1 : ((x1 > x2) ? -1 : 0);
        } else {
          y1 += (y1 < y2) ? 1 : ((y1 > y2) ? -1 : 0);
        }
      }
    }
  }


  private void generateRandomChests() {
    for (int i = 0; i < spawnLevel; i++) {
      int x, y;
      boolean positionOccupied;

      do {
        // Scegli una posizione casuale sulla mappa
        x = int(random(cols));
        y = int(random(rows));

        // Verifica se la posizione è già occupata da un muro o parete
        positionOccupied = map[x][y] == 0 || map[x][y] == 4 || map[x][y] == 5;
      } while (positionOccupied);

      // Crea una nuova cassa e imposta le sue proprietà
      Chest chest = new Chest("data/object/tile_0089.png");
      chest.setName("cassa di merda");
      chest.setIsOpen(random(1) < 0.5); // Casualemente aperta o chiusa
      chest.setOpenWith(new Item("key")); // Imposta un oggetto necessario per aprirla

      // Aggiungi la cassa alla lista delle casse
      // E imposta la posizione sulla mappa
      chest.setPosition(new PVector(x, y));
      map[(int) chest.getPosition().x][(int) chest.getPosition().y] = 6;
      treasures.add(chest);
    }
  }


  // spawner basilare di nemici
  private void generateEnemies() {
    enemies = new ArrayList<Enemy>();
    boolean positionOccupied;

    int x = 0, y = 0;

    for (int i = 0; i < numberOfEnemies; i++) {
      // Scegli una stanza casuale
      int roomIndex = int(random(rooms.size()));
      PVector roomPosition = rooms.get(roomIndex).getPosition();

      do {
        // Scegli una posizione casuale sulla mappa
        x = int(random(roomPosition.x));
        y = int(random(roomPosition.y));

        // Verifica se la posizione è già occupata da un muro o parete
        positionOccupied = map[x][y] == 0 || map[x][y] == 4 || map[x][y] == 5 || map[x][y] == 3 || map[x][y] == 2;
      } while (positionOccupied);

      // Crea un nemico con valori casuali di HP e un'immagine casuale
      int enemyHP = 30;

      Enemy enemy = new Enemy(i, enemyHP, "nemico", "data/npc/tile_0109.png");
      enemy.setPosition(new PVector(x, y));

      if (map[x][y] == 1) map[x][y] = 7;

      // Aggiungi il nemico alla lista
      enemies.add(enemy);
    }
  }

  public String getObjectAtCell(int x, int y) {
    int tileType = map[x][y];
    if (tileType == 6) {
      for (Chest treasure : treasures) {
        if (treasure.getPosition().x == x && treasure.getPosition().y == y) {
          return treasure.getName();
        }
      }
    } else if (tileType == 7) {
      // La cella contiene un nemico, restituisci l'oggetto Nemico
      for (Enemy enemy : enemies) {
        if (enemy.getPosition().x == x && enemy.getPosition().y == y) {
          return enemy.getName();
        }
      }
    }
    return null; // Non c'è nessun oggetto nella cella
  }

  // disegna solo cio che vede il giocatore
  void display() {

    // Calcola i limiti dello schermo visibile in termini di celle di mappa
    int startX = floor((cameraX / (tileSize * zoom)));
    int startY = floor((cameraY / (tileSize * zoom)));
    int endX = ceil((cameraX + gameScene.width) / (tileSize * zoom));
    int endY = ceil((cameraY + gameScene.height) / (tileSize * zoom));

    // Assicurati che i limiti siano all'interno dei limiti della mappa
    startX = constrain(startX, 0, cols - 1);
    startY = constrain(startY, 0, rows - 1);
    endX = constrain(endX, 0, cols);
    endY = constrain(endY, 0, rows);

    println("cols: " + cols + ", rows: " + rows);
    println("start X: " + startX + "start Y" + startY);
    println("end X: " + endX + "end Y" + endY);



    for (int x = startX; x < endX; x++) {
      for (int y = startY; y < endY; y++) {
        int tileType = map[x][y];

        switch(tileType) {
        case 0:
          // sfondo
          // image(wallImage, x * tileSize, y * tileSize, tileSize, tileSize);
          gameScene.fill(0); // nero
          gameScene.noStroke();
          gameScene.rect(x * tileSize, y * tileSize, tileSize, tileSize);
          break;

        case 1:
          // pavimento
          gameScene.image(floorImage, x * tileSize, y * tileSize, tileSize, tileSize);
          break;

        case 2:
          // Imposta l'immagine per la stanza iniziale (nero)
          gameScene.image(startFloorImage, x * tileSize, y * tileSize, tileSize, tileSize);
          break;

        case 3:
          // scale per il piano successivo
          gameScene.image(stairsNextFloorImage, x * tileSize, y * tileSize, tileSize, tileSize);
          break;

        case 4:
          // muri perimetrali
          gameScene.image(wallImageNorth, x * tileSize, y * tileSize, tileSize, tileSize);
          //if (needsNorthWall(x, y)) {
          //  image(wallImageNorthTop, x * tileSize, (y - 1) * tileSize, tileSize, tileSize);
          //  image(wallImageNorthBottom, x * tileSize, y * tileSize, tileSize, tileSize);
          //}
          //if (needsSouthWall(x, y)) {
          //  image(wallImageSouth, x * tileSize, y * tileSize, tileSize, tileSize);
          //}
          //if (needsEastWall(x, y)) {
          //  image(wallImageEast, x * tileSize, y * tileSize, tileSize, tileSize);
          //}
          //if (needsWestWall(x, y)) {
          //  image(wallImageWest, x * tileSize, y * tileSize, tileSize, tileSize);
          //}
          break;

        case 5:
          // corridoio
          gameScene.image(hallwayImage, x * tileSize, y * tileSize, tileSize, tileSize);
          break;

        case 6:
          // tesori
          //for (Chest chest : treasures) {
          //  gameScene.image(chest.getSprite(), x * tileSize, y * tileSize, tileSize, tileSize);
          //}
          gameScene.image(floorImage, x * tileSize, y * tileSize, tileSize, tileSize);
          break;

        case 7:
          // nemici
          // è inutile disegnare tutti i nemici presenti
          gameScene.image(floorImage, x * tileSize, y * tileSize, tileSize, tileSize);
          break;
        }
      }
    }

    //for (Room room : rooms) {
    //  int roomX = floor(room.getPosition().x);
    //  int roomY = floor(room.getPosition().y);

    //  // Calcola le coordinate del rettangolo intorno alla stanza
    //  int rectX = roomX * tileSize;
    //  int rectY = roomY * tileSize;
    //  int rectWidth = room.getWidth() * (int) zoom;
    //  int rectHeight = room.getHeight() * (int)zoom;

    //  // Disegna il rettangolo bianco intorno alla stanza
    //  gameScene.noFill(); // Bianco
    //  gameScene.stroke(255);
    //  gameScene.rect(rectX, rectY, rectWidth, rectHeight);
    //}
  }

  //boolean needsNorthWall(int x, int y) {
  //  // Controlla se una parete nord è necessaria in questa posizione
  //  if (y > 0 && map[x][y + 1] == 1) {
  //    return true; // Una parete nord è necessaria
  //  }
  //  return false; // Nessuna parete nord è necessaria
  //}

  //boolean needsSouthWall(int x, int y) {
  //  // Controlla se una parete sud è necessaria in questa posizione
  //  if (y < rows - 1 && map[x][y - 1] == 1) {
  //    return true; // Una parete sud è necessaria
  //  }
  //  return false; // Nessuna parete sud è necessaria
  //}

  //boolean needsEastWall(int x, int y) {
  //  // Controlla se una parete est è necessaria in questa posizione
  //  if (x < cols - 1 && map[x + 1][y] == 1) {
  //    return true; // Una parete est è necessaria
  //  }
  //  return false; // Nessuna parete est è necessaria
  //}

  //boolean needsWestWall(int x, int y) {
  //  // Controlla se una parete ovest è necessaria in questa posizione
  //  if (x > 0 && map[x - 1][y] == 1) {
  //    return true; // Una parete ovest è necessaria
  //  }
  //  return false; // Nessuna parete ovest è necessaria
  //}
}
