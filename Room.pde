class Room {  
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
}
