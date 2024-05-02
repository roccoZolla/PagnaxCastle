class Level {
  String levelName;
  int levelIndex;
  String dataPath;
  boolean completed = false;  // un livello si definisce completo se sono state raccolte tutte le monete e aperte tutte le casse
  int numberOfRooms;
  boolean isFinalLevel;      // indica se è il livello finale, composto da una singola stanza, di base false

  Sprite stairsNextFloor;

  FWorld level;

  // rooms
  int tileSize = 16;
  int cols, rows;
  int[][] map;
  ArrayList<Room> rooms;

  int startRoomIndex;
  int endRoomIndex;

  // probabilita di spawn delle trappole all'interno del livello
  final double TRAP_SPAWN_PROBABILITY = 0.03;

  // danno delle trappole
  final int DAMAGE_PEAKS = 5;

  // vita dei nemici
  final int ENEMY_HP = 30;

  // attributi
  PImage startFloorImage;
  PImage floorImage; // Immagine per il pavimento
  // private PImage wallImage;  // Immagine per sfondo
  // pareti delle stanze
  PImage wallImageNorth;
  // private PImage wallImageNorthTop;
  // private PImage wallImageNorthBottom;
  // private PImage wallImageSouth;
  // private PImage wallImageEast;
  // private PImage wallImageWest;
  PImage hallwayImage;         // immagine per i corridoi
  PImage peaksTrapImage;
  PImage stairsNextFloorImage; // scale per accedere al livello successivo

  ArrayList<Coin> coins;      // contiene le monete presenti nel livello

  // chest che puoi trovare nel livello
  ArrayList<Chest> treasures; // Memorizza le posizioni degli oggetti

  // nemici che puoi trovare nel livello
  ArrayList<Enemy> enemies; // Lista dei nemici

  ArrayList<Item> dropItems; // lista degli oggetti caduti a terra

  Level(String levelName, int levelIndex, String dataPath, int numberOfRooms) {
    this.levelName = levelName;
    this.completed = false;
    this.levelIndex = levelIndex;
    this.dataPath = dataPath;
    this.numberOfRooms = numberOfRooms;

    this.isFinalLevel = false;

    // creazione del mondo fisico per il livello
    level = new FWorld();
    level.setGrabbable(false);
    level.setGravity(0, 0);
    level.setEdges();
  }

  // da sistemare poco efficiente
  void loadAssetsLevel() {
    // println("carico gli assets del livello...");
    floorImage = currentZone.floorImage;
    wallImageNorth = currentZone.wallImageNorth;
    hallwayImage = currentZone.hallwayImage;
    stairsNextFloorImage = currentZone.stairsNextFloorImage;
    peaksTrapImage = currentZone.peaksTrapImage;
    hallwayImage = currentZone.hallwayImage;
    stairsNextFloorImage = currentZone.stairsNextFloorImage;
  }

  void init() {
    // inizializzo il livello
    // println("inizializzo il livello...");

    // logica per la creazione del livello (mappa del livello)
    cols = width / tileSize;
    rows = height / tileSize;

    map = new int[cols][rows];
    rooms = new ArrayList<Room>();

    // Genera le stanze all'interno delle foglie dell'albero BSP
    generateRooms();

    // Collega le stanze con corridoi
    connectRooms();

    stairsNextFloor = new Sprite(stairsNextFloorImage);

    // da rimuovere
    map[int(rooms.get(startRoomIndex).roomPosition.x)][int(rooms.get(startRoomIndex).roomPosition.y)] = Utils.START_ROOM_TILE_TYPE; // Stanza iniziale
    map[int(rooms.get(endRoomIndex).roomPosition.x)][int(rooms.get(endRoomIndex).roomPosition.y)] = Utils.STAIRS_TILE_TYPE; // Stanza finale

    // inizializza l'array dei drop items
    // inizialmente è vuoto
    dropItems = new ArrayList<>();

    // genera le chest
    generateRandomChests();

    // aggiungi i nemici
    // da chiamare quando il giocatore entra nella stanza
    generateEnemies();

    // genera le monete
    generateRandomCoins();
  }

  void initBossLevel() {
    // println("inizializzo il livello finale...");

    // logica per la creazione del livello (mappa del livello)
    cols = width / tileSize;
    rows = height / tileSize;

    println("cols: " + cols);
    println("rows: " + rows);

    map = new int[cols][rows];
    rooms = new ArrayList<Room>();

    // Genera stanze
    generateBossRoom();

    // da rimuovere
    map[int(rooms.get(startRoomIndex).roomPosition.x)][int(rooms.get(startRoomIndex).roomPosition.y)] = Utils.START_ROOM_TILE_TYPE; // Stanza iniziale

    //println("----- BOSS ROOM -----");
    //println("start room index: " + startRoomIndex);
    //println("end room index: " + endRoomIndex);
    //println("start position END LEVEL: " + getStartPosition());
    //println("end position END LEVEL: " + getEndRoomPosition());
    // genera il boss
  }

  PVector getStartPosition() {
    Room startRoom = rooms.get(startRoomIndex);
    int randomX, randomY;
    boolean positionOccupied;

    do {
      randomX = (int) (startRoom.roomPosition.x + random(-2, 2));
      randomY = (int) (startRoom.roomPosition.y + random(-2, 2));

      // Verifica se la posizione è già occupata da un muro, una parete o un'altra entità
      positionOccupied = (map[randomX][randomY] != Utils.FLOOR_TILE_TYPE);
    } while (positionOccupied);

    PVector randomPosition = new PVector(randomX, randomY);
    println("start position: " + randomPosition);
    return randomPosition;
  }

  PVector getEndRoomPosition() {
    return rooms.get(endRoomIndex).roomPosition;
  }

  // genera la stanza del boss finale
  private void generateBossRoom() {
    int roomWidth = int(random(20, 35));
    int roomHeight = int(random(20, 35));

    int roomX = int(random(1, cols - roomWidth - 1));
    int roomY = int(random(1, rows - roomHeight - 1));

    PVector roomPosition = new PVector(roomX + roomWidth / 2, roomY + roomHeight / 2);
    Room room = new Room(roomWidth, roomHeight, roomPosition);
    rooms.add(room);

    // Estrai i muri dell'immagine dei muri delle stanze
    for (int x = roomX; x < roomX + roomWidth; x++) {
      for (int y = roomY; y < roomY + roomHeight; y++) {
        if (x == roomX || x == roomX + roomWidth - 1 || y == roomY || y == roomY + roomHeight - 1) {
          map[x][y] = Utils.WALL_PERIMETER_TILE_TYPE;
        } else {
          map[x][y] = Utils.FLOOR_TILE_TYPE;
          // spawn delle trappole all'interno delle stanze
          // da generare solo per la modalita difficile
          if (random(1) <= TRAP_SPAWN_PROBABILITY) {
            map[x][y] = Utils.PEAKS_TILE_TYPE;
          }
        }
      }
    }
  }

  // metodi per la generazione delle stanze
  private void generateRooms() {
    // println("genero lo stanze...");
    for (int i = 0; i < numberOfRooms; i++) {
      generateRandomRoom();
    }

    // stanza iniziale e finale scelte casualmente
    startRoomIndex = int(random(rooms.size()));

    do {
      // println("assegnazione posizione finale...");
      endRoomIndex = int(random(rooms.size()));
    } while (endRoomIndex == startRoomIndex && !isFinalLevel);

    rooms.get(startRoomIndex).startRoom = true;
    rooms.get(endRoomIndex).endRoom = true;
  }

  private void generateRandomRoom() {
    int roomWidth = int(random(8, 20));
    int roomHeight = int(random(8, 20));
    int maxAttempts = 100;

    for (int attempt = 0; attempt < maxAttempts; attempt++) {
      int roomX = int(random(1, cols - roomWidth - 1));
      int roomY = int(random(1, rows - roomHeight - 1));

      // Verifica l'overlapping solo con le stanze già generate
      if (!checkRoomOverlap(roomX, roomY, roomWidth, roomHeight)) {
        // Crea e aggiungi la nuova stanza alla lista delle stanze
        PVector roomPosition = new PVector(roomX + roomWidth / 2, roomY + roomHeight / 2);
        Room room = new Room(roomWidth, roomHeight, roomPosition);
        rooms.add(room);

        // Estrai i muri dell'immagine dei muri delle stanze
        for (int x = roomX; x < roomX + roomWidth; x++) {
          for (int y = roomY; y < roomY + roomHeight; y++) {
            if (x == roomX || x == roomX + roomWidth - 1 || y == roomY || y == roomY + roomHeight - 1) {
              map[x][y] = Utils.WALL_PERIMETER_TILE_TYPE;

              // creazione del muro
              FBox wall = new FBox(tileSize, tileSize);
              wall.setPosition(x * tileSize + tileSize / 2, y * tileSize + tileSize / 2);
              wall.setStatic(true); // Rendi il corpo fisico statico
              wall.setFriction(0.8);
              wall.setRestitution(0.1);
              level.add(wall);
              // aggiungere entita wall fbox per ogni parete
            } else {
              map[x][y] = Utils.FLOOR_TILE_TYPE;
              // spawn delle trappole all'interno delle stanze
              if (random(1) <= TRAP_SPAWN_PROBABILITY) {
                map[x][y] = Utils.PEAKS_TILE_TYPE;
                FBox peaks = new FBox(tileSize, tileSize);
                peaks.setPosition(x * tileSize + tileSize / 2, y * tileSize + tileSize / 2);
                peaks.setStatic(true); // Rendi il corpo fisico statico
                peaks.setSensor(true);
                level.add(peaks);
              }
            }
          }
        }

        // Esci dal ciclo una volta generata e posizionata con successo la stanza
        break;
      }
    }
  }

  private boolean checkRoomOverlap(int x, int y, int roomWidth, int roomHeight) {
    // println("room overlap...");
    for (Room room : rooms) {
      // Verifica se la stanza attuale si sovrappone con la nuova stanza
      if (room.overlaps(x, y, roomWidth, roomHeight)) {
        return true;
      }
    }
    return false;
  }

  private void connectRooms() {
    // println("collego le stanze...");
    for (int i = 0; i < rooms.size() - 1; i++) {
      PVector room1 = rooms.get(i).roomPosition.copy();
      PVector room2 = rooms.get(i + 1).roomPosition.copy();

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
    // println("genero le monete...");
    coins = new ArrayList<>();
    boolean positionOccupied;
    int totalCoins = 20; // Modifica il numero di monete da generare come preferisci

    for (int i = 0; i < totalCoins; i++) {
      int x, y;

      do {
        // Scegli una posizione casuale sulla mappa
        x = (int) random(cols);
        y = (int) random(rows);

        // Verifica se la posizione non è pavimento
        positionOccupied = (map[x][y] != Utils.FLOOR_TILE_TYPE);
      } while (positionOccupied);

      // Crea una moneta con un valore casuale (puoi personalizzare il valore come preferisci)
      int coinValue = (int) random(1, 10); // Esempio: valore casuale tra 1 e 10
      Coin coin = new Coin(coin_sprite, coinValue);
      coin.updatePosition(x, y);
      coins.add(coin);

      // aggiungi box coin al mondo fisico
      level.add(coin.box);
    }
  }

  // da sistemare ma decente
  private void generateRandomChests() {
    // println("genero le chest...");
    int spawnLevel = 3; // Livello di spawn delle chest, tre chest per livello
    treasures = new ArrayList<Chest>();
    boolean positionOccupied;
    Chest chest;
    Room room;
    // la somma dei due tassi deve essere 1
    float commonChestSpawnRate = 0.7; // tasso di spawn per le casse comuni 70%
    float spawnRadius = 2;    // raggio di spawn della chest rispetto al centro della stanza

    for (int i = 0; i < spawnLevel; i++) {
      // se tutte le stanze sono occupate non creare la chest
      if (areAllRoomsOccupied()) {
        // println("tutte le stanze sono occupate!");
        break;
      }

      // stanza selezionata casualmente
      // e verifica se nella stanza sono gia presenti casse
      do {
        room = rooms.get((int) random(rooms.size()));
        // println("check chest in the room...");
      } while (room.isChestPresent());

      room.setIsChestPresent(true);

      // offset rispetto al centro della stanza
      // potrebbe generare un offset uguale a 0 e quindi la posizione coinciderebbe
      // con coordinate del punto centrale della stanza
      float offsetX = random(-spawnRadius, spawnRadius);
      float offsetY = random(-spawnRadius, spawnRadius);

      int x, y;
      int attempt = 0;
      int maxAttempts = 100;

      do {
        // posizione casuale intorno al centro della stanza selezionata casualmente
        x = (int) (room.roomPosition.x + offsetX) + 1;
        y = (int) (room.roomPosition.y + offsetY) + 1;

        // Verifica se la posizione non è il pavimento
        positionOccupied = (map[x][y] != Utils.FLOOR_TILE_TYPE);
        //println("check position for the chest...");
        //println(positionOccupied);

        attempt++;

        if (attempt >= maxAttempts) {
          break;
        }
      } while (positionOccupied);

      // Genera un numero casuale tra 0 e 1 per determinare il tipo di cassa
      float chestType = random(1);

      // di base le casse sono chiuse e non sono rare
      // isOpen è impostato su false nel costruttore
      // isRare è impostato su false nel costruttore
      if (chestType < commonChestSpawnRate) {
        // Genera una cassa comune
        chest = new Chest(chest_close_sprite, "Cassa comune" + i);
        chest.updatePosition(x, y);
        // chest.setId(i);
        chest.setOpenWith(silver_key);              // Specifica l'oggetto chiave necessario
      } else {
        // Genera una cassa rara
        // verifica che non siano stati gia droppati i drop della cassa rara
        if (!game.isTorchDropped || !game.isMapDropped || !game.isMasterSwordDropped) {
          chest = new Chest(special_chest_close_sprite, "Cassa rara" + i);
          chest.updatePosition(x, y);
          // chest.setId(i);
          chest.setOpenWith(golden_key);              // Specifica l'oggetto chiave necessario
          chest.setIsRare(true);
        } else { // altrimenti genera una cassa normale
          chest = new Chest(chest_close_sprite, "Cassa comune" + i);
          chest.updatePosition(x, y);
          // chest.setId(i);
          chest.setOpenWith(silver_key);
        }
      }

      // Aggiungi la cassa alla lista delle casse
      map[x][y] = Utils.CHEST_TILE_TYPE; // Imposta il tipo di tile corrispondente a una cassa

      treasures.add(chest);

      // aggiungi chest al mondo fisico
      level.add(chest.box);
    }
  }

  private boolean areAllRoomsOccupied() {
    for (Room room : rooms) {
      if (!room.isChestPresent()) {
        return false;
      }
    }

    return true;
  }

  // spawner aggiornato
  // genera nemici in ogni stanza in maniera casuale
  private void generateEnemies() {
    // println("genero i nemici...");
    enemies = new ArrayList<Enemy>();
    boolean positionOccupied;

    for (Room room : rooms) {
      PVector roomPosition = room.roomPosition.copy();
      int roomWidth = room.roomWidth;
      int roomHeight = room.roomHeight;

      // Genera un numero casuale di nemici in ogni stanza
      // AGGIUNGI LOGICA DI DIFFICOLTA
      int numEnemiesInRoom = floor(random(3, 5));

      for (int i = 0; i < numEnemiesInRoom; i++) {
        int x, y;

        // spawn causale dei nemici all'interno della mappa
        do {
          x = int(random(roomPosition.x - roomWidth / 2, roomPosition.x + roomWidth / 2));
          y = int(random(roomPosition.y - roomHeight / 2, roomPosition.y + roomHeight / 2));

          // Verifica se la posizione non è il pavimento
          positionOccupied = (map[x][y] != Utils.FLOOR_TILE_TYPE);
        } while (positionOccupied);

        ConcreteDamageHandler damageTileHandler = new ConcreteDamageHandler();

        // creazione dell'entita nemico
        Enemy enemy = new Enemy(rat_enemy_sprite, ENEMY_HP, "rat", 5, damageTileHandler);
        enemy.updatePosition(x, y);

        // Aggiungi il nemico alla lista
        enemies.add(enemy);

        // aggiungi nemici al mondo fisico
        level.add(enemy.box);
      }
    }
  }

  // disegna solo cio che vede il giocatore
  // da spostare nel render system
  void display(PGraphics layer) {
    // Calcola i limiti dello schermo visibile in termini di celle di mappa
    int startX = floor((camera.x / (tileSize * camera.zoom)));
    int startY = floor((camera.y / (tileSize * camera.zoom)));
    int endX = ceil((camera.x + width) / (tileSize * camera.zoom));
    int endY = ceil((camera.y + height) / (tileSize * camera.zoom));

    // Assicurati che i limiti siano all'interno dei limiti della mappa
    startX = constrain(startX, 0, cols - 1);
    startY = constrain(startY, 0, rows - 1);
    endX = constrain(endX, 0, cols);
    endY = constrain(endY, 0, rows);

    for (int x = startX; x < endX; x++) {
      for (int y = startY; y < endY; y++) {
        int tileType = map[x][y];

        float centerX = x * tileSize + tileSize / 2;
        float centerY = y * tileSize + tileSize / 2;


        switch(tileType) {
        case Utils.BACKGROUND_TILE_TYPE:
          // sfondo
          break;

        case Utils.FLOOR_TILE_TYPE:
          // pavimento
          layer.image(floorImage, centerX, centerY, tileSize, tileSize);
          break;

        case Utils.START_ROOM_TILE_TYPE:
          // Imposta l'immagine per la stanza iniziale (nero)
          layer.image(floorImage, centerX, centerY, tileSize, tileSize);
          break;

        case Utils.STAIRS_TILE_TYPE:
          // scale per il piano successivo
          layer.image(stairsNextFloorImage, centerX, centerY, tileSize, tileSize);
          break;

        case Utils.WALL_PERIMETER_TILE_TYPE:
          // muri perimetrali
          layer.image(wallImageNorth, centerX, centerY, tileSize, tileSize);
          break;

        case Utils.HALLWAY_TILE_TYPE:
          // corridoio
          layer.image(hallwayImage, centerX, centerY, tileSize, tileSize);
          break;

        case Utils.CHEST_TILE_TYPE:
          // ci sta tenerlo sono statiche le casse
          // tesori
          layer.image(floorImage, centerX, centerY, tileSize, tileSize);
          break;

        case Utils.PEAKS_TILE_TYPE:
          // peaks trap
          layer.image(peaksTrapImage, centerX, centerY, tileSize, tileSize);
          break;
        }
      }
    }
  }

  private class Room {
    int roomWidth;  // larghezza stanza
    int roomHeight;  // altezza stanza
    PVector roomPosition;

    Boolean startRoom; // indica se è la stanza di spawn
    Boolean endRoom;  // indica se è la stanza delle scale
    Boolean isChestPresent; // indica se è presente una chest all'interno della stanza

    Room(int roomWidth, int roomHeight, PVector roomPosition) {
      this.roomWidth = roomWidth;
      this.roomHeight = roomHeight;
      this.roomPosition = roomPosition;

      this.startRoom = false;
      this.endRoom = false;
      // di base non c'è nessuna chest
      this.isChestPresent = false;
    }

    // verifica dell'overlap con un'altra stanza
    boolean overlaps(int otherX, int otherY, int otherWidth, int otherHeight) {
      // Calcola la posizione del centro della stanza passata come argomento
      int otherCenterX = otherX + otherWidth / 2;
      int otherCenterY = otherY + otherHeight / 2;

      // Calcola la posizione del centro della stanza corrente
      int thisCenterX = (int) roomPosition.x;
      int thisCenterY = (int) roomPosition.y;

      // Calcola le coordinate dei bordi della stanza corrente
      int thisLeft = thisCenterX - roomWidth / 2;
      int thisRight = thisCenterX + roomWidth / 2;
      int thisTop = thisCenterY - roomHeight / 2;
      int thisBottom = thisCenterY + roomHeight / 2;

      // Calcola le coordinate dei bordi della stanza passata come argomento
      int otherLeft = otherCenterX - otherWidth / 2;
      int otherRight = otherCenterX + otherWidth / 2;
      int otherTop = otherCenterY - otherHeight / 2;
      int otherBottom = otherCenterY + otherHeight / 2;

      // Verifica l'overlapping lungo l'asse x e l'asse y
      boolean horizontalOverlap = thisLeft <= otherRight && thisRight >= otherLeft;
      boolean verticalOverlap = thisTop <= otherBottom && thisBottom >= otherTop;

      return horizontalOverlap && verticalOverlap;
    }

    boolean isChestPresent() {
      return isChestPresent;
    }

    boolean isStartRoom() {
      return startRoom;
    }
    boolean isEndRoom() {
      return endRoom;
    }

    void setIsChestPresent(boolean isChestPresent) {
      this.isChestPresent = isChestPresent;
    }
  }
}

boolean checkCollision(Sprite spriteA, Sprite spriteB) {
  PVector positionA = spriteA.getPosition();
  PVector positionB = spriteB.getPosition();

  // Calcola le dimensioni degli sprite
  int widthA = spriteA.getSprite().width;
  int heightA = spriteA.getSprite().height;
  int widthB = spriteB.getSprite().width;
  int heightB = spriteB.getSprite().height;

  // Calcola i limiti degli sprite
  float leftA = positionA.x * currentLevel.tileSize - (widthA / 2);
  float rightA = positionA.x * currentLevel.tileSize + (widthA / 2);
  float topA = positionA.y * currentLevel.tileSize - (heightA / 2);
  float bottomA = positionA.y * currentLevel.tileSize + (heightA / 2);

  float leftB = positionB.x * currentLevel.tileSize - (widthB / 2);
  float rightB = positionB.x * currentLevel.tileSize + (widthB / 2);
  float topB = positionB.y * currentLevel.tileSize - (heightB / 2);
  float bottomB = positionB.y * currentLevel.tileSize + (heightB / 2);

  // Controlla la collisione tra gli sprite
  if (rightA >= leftB && leftA <= rightB && bottomA >= topB && topA <= bottomB) {
    return true;
  }

  return false;
}
