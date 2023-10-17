class Button {
  PVector pos = new PVector(0, 0);
  float w;    // width
  float h;    // height
  String label;
  color buttonColor;
  boolean hover = false;
  boolean pressed = false;

  Button(int x, int y, float w, float h, String label) {
    // Calcola la posizione x e y per centrare il bottone
    pos.x = x;
    pos.y = y;
    this.w = w;
    this.h = h;
    this.label = label;
    buttonColor = color(0, 0, 255); // Colore predefinito del pulsante
  }

  void display() {
    // Verifica se il mouse è sopra il pulsante
    hover = isMouseOver();

    // Imposta il colore del pulsante in base allo stato (normale, hover, premuto)
    if (pressed) {
      // Colore quando premuto
      fill(255, 0 , 0); 
    } else if (hover) {
      // Colore quando il mouse è sopra
      fill(0, 255, 0); 
    } else {
      fill(buttonColor);
    }

    rect(pos.x, pos.y, w, h);

    // draw label
    fill(255);
    textSize(20);
    textAlign(CENTER, CENTER);
    text(label, pos.x + w / 2, pos.y + h / 2);
  }

  boolean isMouseOver() {
    return mouseX >= pos.x && mouseX <= pos.x + w && mouseY >= pos.y && mouseY <= pos.y + h;
  }

  boolean isPressed() {
    if (hover && mousePressed && mouseButton == LEFT) {
      pressed = true;
      return true;
    } else {
      pressed = false;
      return false;
    }
  }

  void reset() {
    pressed = false;
  }
}
