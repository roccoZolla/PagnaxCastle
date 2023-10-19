public abstract class Sprite {
  private PVector spritePosition;
  int id;
  String dataPath;
  PImage img;

  // metodi 
  void display() {
    image(img, spritePosition.x, spritePosition.y);
  }
  
  void display(int tileSize) {
    image(img, spritePosition.x * tileSize, spritePosition.y * tileSize, img.width, img.height);
  }
  
  void display(PGraphics layer, int tileSize) {
    layer.image(img, spritePosition.x * tileSize, spritePosition.y * tileSize, img.width, img.height);
  }
  
  // imposta la posizione dello sprite nella mappa
  void setPosition(PVector spritePosition){
    this.spritePosition = spritePosition;
  }  
  
  // ottieni la posizione dello sprite mnella mappa
  PVector getPosition(){
    return spritePosition;
  }
  
  PImage getSprite(){
    return img;
  }
  
  void setSprite(PImage img) {
    this.img = img;
  }
}
