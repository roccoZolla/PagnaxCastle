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
  
  void setIsChestPresent(boolean isChestPresent) {
    this.isChestPresent = isChestPresent;
  }
}
