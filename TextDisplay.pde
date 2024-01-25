class TextDisplay {
  PVector text_position;
  String text;
  color text_color;

  TextDisplay(PVector text_position, String text, color text_color) {
    this.text_position = text_position.copy();
    this.text = text;
    this.text_color = text_color;
  }

  void update(PVector text_position, String text, color text_color) {
    this.text_position = text_position.copy();
    this.text = text;
    this.text_color = text_color;
  }

  void display() {
    spritesLayer.textFont(myFont);
    spritesLayer.fill(text_color);
    spritesLayer.textSize(15);
    spritesLayer.text(text, text_position.x * currentLevel.tileSize, (text_position.y * currentLevel.tileSize) - 10);
  }
}
