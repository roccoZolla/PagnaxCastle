//// classe che gestisce il disegno dei testi a schermo
//// fare in modo che si possa anche specificare il layer su cui scrivere il testo
//class TextDisplay {
//  PVector position;
//  String text;
//  color text_color;
//  long displayStartTime;
//  float displayDuration;
//  boolean textDisplayed;
//  boolean timerStarted;
    
//  TextDisplay(PVector textPosition, String text, color text_color, float displayDuration) {
//    this.position = textPosition;
//    this.text = text;
//    this.text_color = text_color;
//    this.displayDuration = displayDuration;
//    this.displayStartTime = System.currentTimeMillis(); //
    
//    this.textDisplayed = false;
//    this.timerStarted = false;
//  }

//  void display() {
//    if (!timerStarted) {
//        // Avvia il timer solo se non è già stato avviato
//        displayStartTime = System.currentTimeMillis();
//        timerStarted = true;
//    }

//    long currentTime = System.currentTimeMillis();
//    float elapsedTime = currentTime - displayStartTime;
    
//    println("---- DISPLAY TIME: " + text + " -----");
//    println("currentTime: " + currentTime);
//    println("display start time: " + displayStartTime);
//    println("display duration: " + displayDuration);
//    println("elapsedTime: " + elapsedTime);

//    if (elapsedTime < displayDuration && !textDisplayed) {
//        spritesLayer.fill(text_color);
//        spritesLayer.textSize(15);
//        spritesLayer.text(text, position.x * currentLevel.tileSize, (position.y * currentLevel.tileSize) - 10);
//    } else if (!textDisplayed) {
//        // Il tempo è scaduto e il testo non è ancora stato mostrato
//        textDisplayed = true;
//        // Puoi eseguire azioni aggiuntive qui se necessario
//    }
//  }

//  boolean isExpired() {
//      return textDisplayed && (millis() - displayStartTime >= displayDuration);
//  }

//  // Aggiungi un metodo per ripristinare lo stato del testo
//  void reset() {
//      textDisplayed = false;
//      timerStarted = false;
//  }
  
//  boolean isDisplayed() {
//    return textDisplayed;  
//  }
//}

//class TextDisplay {
//    PVector position;
//    String text;
//    color text_color;
//    long displayStartTime;
//    float displayDuration;

//    TextDisplay(PVector position, String text, color text_color, float displayDuration) {
//        this.position = position.copy();
//        this.text = text;
//        this.text_color = text_color;
//        this.displayDuration = displayDuration;
//        this.displayStartTime = System.currentTimeMillis();
//    }

//    void display() {
//        long currentTime = System.currentTimeMillis();
//        float elapsedTime = currentTime - displayStartTime;

//        if (elapsedTime < displayDuration) {
//            spritesLayer.textFont(myFont);
//            spritesLayer.fill(text_color);
//            spritesLayer.textSize(15);
//            spritesLayer.text(text, position.x * currentLevel.tileSize, (position.y * currentLevel.tileSize) - 10);
//        }
//    }

//    boolean isExpired() {
//        return System.currentTimeMillis() - displayStartTime >= displayDuration;
//    }
//}

//class TextDisplay {
//  PVector text_position;
//  String text;
//  color text_color;
//  long displayStartTime;
//  float displayDuration;

//  TextDisplay(PVector text_position, String text, color text_color, float displayDuration) {
//    this.text_position = text_position.copy();
//    this.text = text;
//    this.text_color = text_color;
//    this.displayDuration = displayDuration;
//  }

//  void display() {
//    long currentTime = millis();
//    float elapsedTime = currentTime - displayStartTime;

//    if (elapsedTime < displayDuration) {
//      spritesLayer.fill(text_color);
//      spritesLayer.textSize(15);
//      spritesLayer.text(text, text_position.x * currentLevel.tileSize, (text_position.y * currentLevel.tileSize) - 10);
//    }
//  }

//  void startDisplay() {
//    displayStartTime = millis();
//  }

//  boolean isExpired() {
//    return millis() - displayStartTime >= displayDuration;
//  }
//}

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
    //long currentTime = millis();
    //float elapsedTime = currentTime - displayStartTime;
    
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
    println("---- TEMPO ----");
    println("start Time: " + displayStartTime);
    println("millis: " + millis());
    println("diff: " + (millis() - displayStartTime));
    return millis() - displayStartTime >= displayDuration;
  }
}
