public class Sprite {
  PVector spritePosition;
  final String id;
  final PImage img;
  
  Sprite(String id, String imagePath) {
    this.id=id;
    img=loadImage(imagePath);
  }
  
  Sprite(String id, String imagePath, PVector spritePosition) {
    this.id=id;
    img = loadImage(imagePath);
    this.spritePosition = spritePosition;
  }
  
  // metodi 
  public void incX() {
    spritePosition.x++;
  }
  
  public void decX() {
    spritePosition.x--;
  }
  
  public void incY() {
    spritePosition.y++;
  }
  
  public void decY() {
    spritePosition.y--;
  }
  
  public void setX(int x) {
    this.spritePosition.x=x;
  }
  
  public void setY(int y) {
    this.spritePosition.y=y;
  }
  
  public void incX(int x) {
    this.spritePosition.x+=x;
  }
  
  public void incY(int y) {
    this.spritePosition.y+=y;
  }
  
  void display() {
    image(img, spritePosition.x, spritePosition.y);
  }
  
  void display(int tileSize) {
    image(img, spritePosition.x * tileSize, spritePosition.y * tileSize, img.width, img.height);
  }
  
  void setSpritePosition(PVector spritePosition){
    this.spritePosition = spritePosition;
  }  
  
  PVector getSpritePosition(){
    return spritePosition;
  }
}
