class Map {
  // attributi
  private PImage floorImage; // Immagine per il pavimento
  private PImage wallImage;  // Immagine per le pareti
  private PImage roomOutlineImage; // immagine per i contorni delle stanze
  private PImage hallwayImage;      // immagine per i corridoi
  
  private PImage treasureImage;
  private int spawnLevel = 3; // Livello di spawn (puoi impostarlo come desideri)
  private ArrayList<Chest> treasures; // Memorizza le posizioni degli oggetti
  
  private PImage finalFloorImage;
  
  private int tileSize = 16;
  private int cols, rows;
  private int[][] map;
  private ArrayList<PVector> rooms; // Memorizza le posizioni delle stanze
  
  private int numberOfEnemies = 20;  // livello di spawn dei nemici
  private ArrayList<Enemy> enemies; // Lista dei nemici
  
  private int startRoomIndex;
  private int endRoomIndex;
  
  // metodi
   void setMap() {
    cols = width / tileSize;
    rows = height / tileSize;
    map = new int[cols][rows];
    rooms = new ArrayList<PVector>();
    treasures = new ArrayList<Chest>(); // Inizializza l'arraylist qui
    
    floorImage = loadImage("data/environment/tile_0042.png"); 
    wallImage = loadImage("data/environment/tile_0014.png");   
    roomOutlineImage = loadImage("data/environment/tile_0005.png");
    hallwayImage = loadImage("data/environment/tile_0049.png");
    finalFloorImage = loadImage("data/environment/tile_0024.png");
    treasureImage = loadImage("data/object/tile_0089.png");
   
    // Genera stanze
    generateRooms();
    
    // Collega le stanze con corridoi
    connectRooms();
    
    // aggiungi i nemici
    generateEnemies();
    
    // Imposta le stanze iniziale e finale
    map[int(rooms.get(startRoomIndex).x)][int(rooms.get(startRoomIndex).y)] = 2; // Stanza iniziale
    map[int(rooms.get(endRoomIndex).x)][int(rooms.get(endRoomIndex).y)] = 3; // Stanza finale
    
    // genera i loot
    // generateTreasures();
    generateRandomChests();
  }
  
  void showMap() {
   for (int x = 0; x < cols; x++) {
      for (int y = 0; y < rows; y++) {
        int tileType = map[x][y];
        
        switch(tileType){
          case 0:
            // sfondo
            image(wallImage, x * tileSize, y * tileSize, tileSize, tileSize);
          break;        
          
          case 1:
            // pavimento
            image(floorImage, x * tileSize, y * tileSize, tileSize, tileSize);
          break;
          
          case 2:
            // Imposta l'immagine per la stanza iniziale (nero)
            fill(0); // nero
            noStroke();
            rect(x * tileSize, y * tileSize, tileSize, tileSize);
          break;  
          
          case 3:
            // pavimento stanza finale
            image(finalFloorImage, x * tileSize, y * tileSize, tileSize, tileSize);
          break;   
          
          case 4:
            // muri perimetrali
            image(roomOutlineImage, x * tileSize, y * tileSize, tileSize, tileSize);
          break;
          
          case 5:
          // corridoio
            image(hallwayImage, x * tileSize, y * tileSize, tileSize, tileSize);
          break;             
          
          case 6:
          // tesori
            image(treasureImage, x * tileSize, y * tileSize, tileSize, tileSize);
          break;
          
          case 7:
          // nemici
          for(Enemy enemy : enemies) {
            image(enemy.getSprite(), x * tileSize, y * tileSize, tileSize, tileSize);
          }
          break;
        }
      }
    }
  }

  
  PVector getStartRoom() {
    return rooms.get(startRoomIndex);
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
  
  ArrayList<Enemy> getEnemies() {
    return enemies;
  } 
  
  // metodi per la generazione delle stanze
  private void generateRooms() {
    for (int i = 0; i < 8; i++) {
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
    int roomWidth = int(random(5, 20));
    int roomHeight = int(random(5, 20));
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
    rooms.add(new PVector(roomX + roomWidth / 2, roomY + roomHeight / 2));
  }

  
  private boolean checkRoomOverlap(int x, int y, int width, int height) {
    for (int i = x - 1; i < x + width + 1; i++) {
      for (int j = y - 1; j < y + height + 1; j++) {
        // Verifica se il tile è già occupato (1 rappresenta il pavimento)
        if (map[i][j] == 1) {
          return true;
        }
      }
    }
    return false;
  }

  
  private void connectRooms() {
      for (int i = 0; i < rooms.size() - 1; i++) {
        PVector room1 = rooms.get(i);
        PVector room2 = rooms.get(i + 1);
        
        int x1 = int(room1.x);
        int y1 = int(room1.y);
        int x2 = int(room2.x);
        int y2 = int(room2.y);
        
        // Collega le stanze con un corridoio
        while (x1 != x2 || y1 != y2) {
          if(map[x1][y1] != 1) map[x1][y1] = 5; // Imposta il tile come spazio vuoto (corridoio)
          
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
      Chest chest = new Chest();
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
  
      for (int i = 0; i < numberOfEnemies; i++) {
          // Scegli una stanza casuale
          int roomIndex = int(random(rooms.size()));
          PVector roomPosition = rooms.get(roomIndex);
  
          // Genera una posizione casuale all'interno della stanza
          int x = (int) roomPosition.x;
          int y = (int) roomPosition.y;
          
          // Crea un nemico con valori casuali di HP e un'immagine casuale
          int enemyHP = 30;
          PImage enemyImage = loadImage("data/npc/tile_0109.png");
  
          Enemy enemy = new Enemy(i, enemyHP, "nemico", enemyImage);
          enemy.setPosition(new PVector(x, y));
          
          if(map[x][y] == 1) map[x][y] = 7;
  
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
}
