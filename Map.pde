class Map {
  // attributi
  private PImage floorImage; // Immagine per il pavimento
  private PImage wallImage;  // Immagine per le pareti
  private PImage roomOutlineImage; // immagine per i contorni delle stanze
  private PImage hallwayImage;      // immagine per i corridoi
  
  private PImage treasureImage;
  private int spawnLevel = 3; // Livello di spawn (puoi impostarlo come desideri)
  private ArrayList<PVector> treasures; // Memorizza le posizioni degli oggetti
  
  private PImage finalFloorImage;
  
  private int tileSize = 16;
  private int cols, rows;
  private int[][] map;
  private ArrayList<PVector> rooms; // Memorizza le posizioni delle stanze
  
  private int startRoomIndex;
  private int endRoomIndex;
  
  // metodi
   void setMap() {
    cols = width / tileSize;
    rows = height / tileSize;
    map = new int[cols][rows];
    rooms = new ArrayList<PVector>();
    
    // Carica l'immagine per il pavimento
    floorImage = loadImage("data/environment/tile_0042.png"); 
    // Carica l'immagine per le pareti
    wallImage = loadImage("data/environment/tile_0014.png");   
    // carica immagine per i contorni delle stanze 
    roomOutlineImage = loadImage("data/environment/tile_0005.png");
    hallwayImage = loadImage("data/environment/tile_0049.png");
    finalFloorImage = loadImage("data/environment/tile_0024.png");
    treasureImage = loadImage("data/object/tile_0089.png");
   
    // Genera stanze
    generateRooms();
    
    // Collega le stanze con corridoi
    connectRooms();
    
    // Imposta le stanze iniziale e finale
    map[int(rooms.get(startRoomIndex).x)][int(rooms.get(startRoomIndex).y)] = 2; // Stanza iniziale
    map[int(rooms.get(endRoomIndex).x)][int(rooms.get(endRoomIndex).y)] = 3; // Stanza finale
    
    // genera i loot
    generateTreasures();
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
    int roomWidth = int(random(5, 15));
    int roomHeight = int(random(5, 15));
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
    
  private void generateTreasures() {
    treasures = new ArrayList<PVector>();
  
    int maxTreasures = min(spawnLevel, rooms.size()); // Assicura che spawnLevel non superi il numero di stanze
  
    for (int i = 0; i < maxTreasures; i++) {
      int randomRoomIndex = int(random(rooms.size()));
      PVector roomPosition = rooms.get(randomRoomIndex);
  
      int x = (int) roomPosition.x;
      int y = (int) roomPosition.y;
      
      if(map[x][y] == 1 ) map[x][y] = 6;
  
      treasures.add(new PVector(x, y));
    }
  }


      
}
