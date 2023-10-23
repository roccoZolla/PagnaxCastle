class Room {
  private int roomWidth;
  private int roomHeight;
  private PVector position;
  
  Room(int roomWidth, int roomHeight, PVector position) {
    this.roomWidth = roomWidth;
    this.roomHeight = roomHeight;
    this.position = position;
  }
  
  int getWidth(){
    return roomWidth;
  }  
  
  int getHeight(){
    return roomHeight;
  }  
  
  PVector getPosition(){
    return position;
  }  
}
