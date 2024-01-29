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

  void display(PGraphics layer) {
    layer.textFont(myFont);
    layer.fill(text_color);
    layer.textSize(15);
    layer.text(text, text_position.x * currentLevel.tileSize, (text_position.y * currentLevel.tileSize) - 10);
  }
}
