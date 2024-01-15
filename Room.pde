class Room {  
  int roomWidth;  // larghezza stanza
  int roomHeight;  // altezza stanza
  PVector roomPosition;
  Boolean isChestPresent; // indica se è presente una chest all'interno della stanza
  
  Room(int roomWidth, int roomHeight, PVector roomPosition) {
    this.roomWidth = roomWidth;
    this.roomHeight = roomHeight;
    this.roomPosition = roomPosition;
    
    // di base non c'è nessuna chest
    this.isChestPresent = false;
  }
}
