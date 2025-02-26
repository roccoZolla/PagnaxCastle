class Button {
  // posizione e dimensione del pulsante
  PVector pos;
  float w;    // width
  float h;    // height

  // variabili di stato del pulsante
  boolean hover;
  boolean pressed;
  boolean enabled;  // di base un bottone è disattivato
  boolean clicked;  // pulsante premuto e rilasciato

  // estetica del bottone
  String name;   // nome del bottone
  String label;  // etichetta
  color buttonColor;
  PImage buttonImage;

  Button(int x, int y, float w, float h, String name, String label, String dataPath) {
    // Calcola la posizione x e y per centrare il bottone
    pos = new PVector(0, 0);
    pos.x = x;
    pos.y = y;

    this.w = w;
    this.h = h;

    this.name = name;
    this.label = label;

    this.hover = false;
    this.pressed = false;
    this.enabled = false;
    this.clicked = false;

    buttonColor = color(0, 0, 255); // Colore predefinito del pulsante (provvisorio)
    if (!dataPath.isEmpty()) buttonImage = loadImage(dataPath);
  }

  void update() {
    if (mousePressed == true && mouseButton == LEFT && pressed == false) {
      pressed = true;
      if (isMouseOver()) {
        clicked = true;
        click.play();
      }
    } else {
      clicked = false;
    }

    if (mousePressed != true) {
      pressed = false;
    }
  }

  // vero se il bottone è stato cliccato (pressed and released)
  boolean isClicked() {
    return clicked;
  }

  // nel caso in cui dovessero cambiare le dimensioni della finestra
  // aggiorna la posizione del bottone
  void updatePosition(int x, int y, float w, float h) {
    pos = new PVector(0, 0);
    pos.x = x;
    pos.y = y;

    this.w = w;
    this.h = h;
  }

  void display() {
    hover = isMouseOver();

    // Imposta il colore del pulsante in base allo stato (normale, hover, premuto)
    if (clicked) {
      // Colore quando premuto
      fill(255, 0, 0);
    } else if (hover) {
      // Colore quando il mouse è sopra
      fill(0, 255, 0);
    } else {
      // colore standard del bottone quando non succede nulla
      fill(buttonColor);
    }

    rect(pos.x, pos.y, w, h);

    // Disegna l'immagine al centro del pulsante
    // da sistemare
    if (buttonImage != null) {
      float imgX = pos.x + (w - buttonImage.width) / 2;  // Calcola la posizione X dell'immagine al centro
      float imgY = pos.y + (h - buttonImage.height) / 2; // Calcola la posizione Y dell'immagine al centro
      image(buttonImage, imgX, imgY, buttonImage.width, buttonImage.height);
    }

    // draw label
    if (!label.isEmpty()) {
      fill(255);
      textSize(20);
      textAlign(CENTER, CENTER);
      text(label, pos.x + w / 2, pos.y + h / 2);
    }
  }

  void display(PGraphics layer) {
    // Verifica se il mouse è sopra il pulsante
    hover = isMouseOver();

    // Imposta il colore del pulsante in base allo stato (normale, hover, premuto)
    if (clicked) {
      // Colore quando premuto
      fill(255, 0, 0);
    } else if (hover) {
      // Colore quando il mouse è sopra
      layer.fill(0, 255, 0);
    } else {
      layer.fill(buttonColor);
    }

    layer.rect(pos.x, pos.y, w, h);

    // Disegna l'immagine al centro del pulsante
    // da sistemare
    if (buttonImage != null) {
      float imgX = pos.x + (w - buttonImage.width) / 2;  // Calcola la posizione X dell'immagine al centro
      float imgY = pos.y + (h - buttonImage.height) / 2; // Calcola la posizione Y dell'immagine al centro
      layer.image(buttonImage, imgX, imgY, buttonImage.width, buttonImage.height);
    }

    // draw label
    if (!label.isEmpty()) {
      layer.fill(255);
      layer.textSize(20);
      layer.textAlign(CENTER, CENTER);
      layer.text(label, pos.x + w / 2, pos.y + h / 2);
    }
  }

  boolean isMouseOver() {
    return mouseX >= pos.x && mouseX <= pos.x + w && mouseY >= pos.y && mouseY <= pos.y + h;
  }
  
  void setLabel(String label) {
    this.label = label;
  }
}
