class Map {
  // attributi
  PImage floorImage; // Immagine per il pavimento
  PImage wallImage;  // Immagine per le pareti
  
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
    floorImage = loadImage("data/tile_0042.png"); 
    // Carica l'immagine per le pareti
    wallImage = loadImage("data/tile_0014.png");   
    
    // Genera stanze
    generateRooms();
    
    // Collega le stanze con corridoi
    connectRooms();
    
    // Imposta le stanze iniziale e finale
    map[int(rooms.get(startRoomIndex).x)][int(rooms.get(startRoomIndex).y)] = 2; // Stanza iniziale
    map[int(rooms.get(endRoomIndex).x)][int(rooms.get(endRoomIndex).y)] = 3; // Stanza finale
  }
  
  void showMap() {
   for (int x = 0; x < cols; x++) {
      for (int y = 0; y < rows; y++) {
        int tileType = map[x][y];
        if (tileType == 0) {
          // Disegna l'immagine per le pareti
          image(wallImage, x * tileSize, y * tileSize, tileSize, tileSize);
        } 
        
        else if (tileType == 1) {
          // Disegna l'immagine per il pavimento nelle stanze
          image(floorImage, x * tileSize, y * tileSize, tileSize, tileSize);
        }
        
        else if (tileType == 2) {
          // Imposta l'immagine per la stanza iniziale (nero)
          fill(0); // nero
          noStroke();
          rect(x * tileSize, y * tileSize, tileSize, tileSize);
        } 
        
        
        else if (tileType == 3) {
          // Imposta l'immagine per la stanza finale (bianca)
          fill(255); // Bianco
          noStroke();
          rect(x * tileSize, y * tileSize, tileSize, tileSize);
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
    int roomWidth = int(random(3, 10));
    int roomHeight = int(random(3, 10));
    int roomX = int(random(1, cols - roomWidth - 1));
    int roomY = int(random(1, rows - roomHeight - 1));
    
    for (int x = roomX; x < roomX + roomWidth; x++) {
      for(int y = roomY; y < roomY + roomHeight; y++) {
        map[x][y] = 1;
      }
    }
    
    // Memorizza la posizione della stanza
    rooms.add(new PVector(roomX + roomWidth / 2, roomY + roomHeight / 2));
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
        map[x1][y1] = 1; // Imposta il tile come spazio vuoto (corridoio)
        int choice = int(random(2));
        if (choice == 0) {
          x1 += (x1 < x2) ? 1 : ((x1 > x2) ? -1 : 0);
        } else {
          y1 += (y1 < y2) ? 1 : ((y1 > y2) ? -1 : 0);
        }
      }
    }
  }
  
}
