class TextDisplay {
  PVector text_position;
  String text;
  color text_color;
  long displayStartTime;
  float displayDuration;
  boolean isDisplayed;

  TextDisplay(PVector text_position, String text, color text_color, float displayDuration) {
    this.text_position = text_position.copy();
    this.text = text;
    this.text_color = text_color;
    this.displayDuration = displayDuration;
    this.displayStartTime = 0;
    this.isDisplayed = false;
  }
  
  void update(PVector text_position, String text, color text_color, float displayDuration) {
    this.text_position = text_position.copy();
    this.text = text;
    this.text_color = text_color;
    this.displayDuration = displayDuration;
  }

  void display() {
    // long currentTime = millis();
    // float elapsedTime = currentTime - displayStartTime;
    
    if(!isDisplayed) {
      displayStartTime = millis();
      isDisplayed = true;
    }
    
    if (!isExpired() && isDisplayed) {
      spritesLayer.textFont(myFont);
      spritesLayer.fill(text_color);
      spritesLayer.textSize(15);
      spritesLayer.text(text, text_position.x * currentLevel.tileSize, (text_position.y * currentLevel.tileSize) - 10);
    } else if(isExpired() && isDisplayed) {
      isDisplayed = false;
    }
  }

  boolean isExpired() {
    //println("---- TEMPO ----");
    //println("start Time: " + displayStartTime);
    //println("millis: " + millis());
    //println("diff: " + (millis() - displayStartTime));
    return millis() - displayStartTime >= displayDuration;
  }
}
