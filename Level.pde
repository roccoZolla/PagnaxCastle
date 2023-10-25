class Level {
  private String levelName;
  private int levelIndex;
  private String dataPath;
  private boolean completed = false;  // un livello si definisce completo se sono state raccolte tutte le monete e aperte tutte le casse
  private int numberOfRooms;

  // rooms
  private int tileSize = 16;
  private int cols, rows;
  private int[][] map;
  // private ArrayList<PVector> roomS; // Memorizza le posizioni delle stanze
  private ArrayList<Room> rooms;

  // attributi
  private PImage startFloorImage;
  private PImage floorImage; // Immagine per il pavimento
  // private PImage wallImage;  // Immagine per sfondo
  // pareti delle stanze
  private PImage wallImageNorth;
  // private PImage wallImageNorthTop;
  //private PImage wallImageNorthBottom;
  //private PImage wallImageSouth;
  //private PImage wallImageEast;
  //private PImage wallImageWest;
  private PImage hallwayImage;         // immagine per i corridoi
  private PImage stairsNextFloorImage; // scale per accedere al livello successivo
  
  private ArrayList<Coin> coins;      // contiene le monete presenti nel livello

  // chest che puoi trovare nel livello
  private int spawnLevel = 5; // Livello di spawn
  private ArrayList<Chest> treasures; // Memorizza le posizioni degli oggetti

  // nemici che puoi trovare nel livello
  // private int numberOfEnemies = 5;  // livello di spawn dei nemici
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
    
    // genera le monete
    generateRandomCoins();
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
  
  ArrayList<Coin> getCoins() {
    return coins;
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

  // generatore di monete casuale
  private void generateRandomCoins() {
    coins = new ArrayList<>();
    boolean positionOccupied;
    int totalCoins = 20; // Modifica il numero di monete da generare come preferisci

    for (int i = 0; i < totalCoins; i++) {
      int x, y;

      do {
        // Scegli una posizione casuale sulla mappa
        x = (int) random(cols);
        y = (int) random(rows);

        // Verifica se la posizione è già occupata da un muro, una parete, una cassa o un'altra moneta
        positionOccupied = (map[x][y] == 0 || map[x][y] == 4 || map[x][y] == 5 || map[x][y] == 6 /*|| isCoinOccupied(x, y)*/);
      } while (positionOccupied);

      // Crea una moneta con un valore casuale (puoi personalizzare il valore come preferisci)
      int coinValue = (int) random(1, 10); // Esempio: valore casuale tra 1 e 10
      Coin coin = new Coin(coinValue, "data/coin.png");
      coin.setPosition(new PVector(x, y));

      // Aggiungi la moneta alla lista delle monete
      coins.add(coin);
    }
  }

  // da sistemare ma decente
  private void generateRandomChests() {
    treasures = new ArrayList<Chest>();
    boolean positionOccupied;
    Chest chest;
    float commonChestSpawnRate = 0.90; // Tasso di spawn per le casse comuni (70%)
    // float rareChestSpawnRate = 0.10;   // Tasso di spawn per le casse rare (30%)


    for (int i = 0; i < spawnLevel; i++) {
      int x, y;

      // Genera un numero casuale tra 0 e 1 per determinare il tipo di cassa
      float chestType = random(1);

      if (chestType < commonChestSpawnRate) {
        // Genera una cassa comune
        chest = new Chest("data/object/chest_close.png");
        chest.setId(i);
        chest.setName("Cassa Comune " + i);
        chest.setOpenWith(silver_key);              // Specifica l'oggetto chiave necessario
        chest.setIsRare(false);
        // Imposta altri attributi della cassa comune
      } else {
        // Genera una cassa rara
        chest = new Chest("data/object/special_chest_close.png");
        chest.setId(i);
        chest.setName("Cassa Rara " + i);
        chest.setOpenWith(golden_key);              // Specifica l'oggetto chiave necessario
        chest.setIsRare(true);
      }

      chest.setInteractable(true);
      chest.setIsOpen(false);               // Imposta la cassa come chiusa di base

      do {
        // Scegli una posizione casuale sulla mappa
        x = (int) random(cols);
        y = (int) random(rows);

        // Verifica se la posizione è già occupata da un muro, una parete o un'altra cassa
        positionOccupied = (map[x][y] == 0 || map[x][y] == 4 || map[x][y] == 5 || map[x][y] == 6);
      } while (positionOccupied);

      // Aggiungi la cassa alla lista delle casse
      chest.setPosition(new PVector(x, y));
      map[x][y] = 6; // Imposta il tipo di tile corrispondente a una cassa

      treasures.add(chest);
    }
    
    for(Chest chezz : treasures) {
      println("chest id: " + chezz.getId());
      println("chest Name: " + chezz.getName());
      println("chaive: " + chezz.getOpenWith().getName());
      println("rarita: " + chezz.isRare());
      println("interagibile: " + chezz.isInteractable());
      println("aperta: " + chezz.isOpen());
    }
  }

  // spawner aggiornato
  // genera nemici in ogni stanza in maniera casuale
  private void generateEnemies() {
    enemies = new ArrayList<Enemy>();
    boolean positionOccupied;

    for (Room room : rooms) {
      PVector roomPosition = room.getPosition();
      int roomWidth = room.getWidth();
      int roomHeight = room.getHeight();

      // Genera un numero casuale di nemici in ogni stanza
      // AGGIUNGI LOGICA DI DIFFICOLTA
      int numEnemiesInRoom = floor(random(1, 4)); // Puoi regolare i valori a tuo piacimento

      for (int i = 0; i < numEnemiesInRoom; i++) {
        int x, y;

        // spawn causale dei nemici all'interno della mappa
        do {
          x = int(random(roomPosition.x - roomWidth / 2, roomPosition.x + roomWidth / 2));
          y = int(random(roomPosition.y - roomHeight / 2, roomPosition.y + roomHeight / 2));

          // Verifica se la posizione è già occupata da un muro o un altro oggetto
          positionOccupied = map[x][y] == 0 || map[x][y] == 4 || map[x][y] == 5 || map[x][y] == 3 || map[x][y] == 2;
        } while (positionOccupied);

        // creazione dell'entita nemico
        int enemyHP = 30;
        Enemy enemy = new Enemy(i, enemyHP, "nemico", "data/npc/rat_enemy.png");
        enemy.setPosition(new PVector(x, y));

        // Aggiungi il nemico alla lista
        enemies.add(enemy);
      }
    }
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
          break;

        case 5:
          // corridoio
          gameScene.image(hallwayImage, x * tileSize, y * tileSize, tileSize, tileSize);
          break;

        case 6:
          // ci sta tenerlo sono statiche le casse
          // tesori
          gameScene.image(floorImage, x * tileSize, y * tileSize, tileSize, tileSize);
          break;
        }
      }
    }
  }
}
