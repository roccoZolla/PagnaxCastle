class Option {
  ArrayList<Button> buttons;
  PGraphics optionLayer;

  Option() {
    optionLayer = createGraphics(width, height);
    buttons = new ArrayList();

    buttons.add(new Button(width - 100, 120, 50, 50, "e+", ""));
    buttons.add(new Button(width - 250, 120, 50, 50, "e-", ""));
    buttons.add(new Button(width - 100, 200, 50, 50, "m+", ""));
    buttons.add(new Button(width - 250, 200, 50, 50, "m-", ""));
    buttons.add(new Button(width - 250, height - 150, 200, 80, "Back to menu", ""));
  }

  void display() {
    optionLayer.beginDraw();
    // cancella lo schermo
    optionLayer.background(0);

    // disegna la scritta opzioni
    optionLayer.textFont(myFont);
    optionLayer.fill(255);
    optionLayer.textSize(36);
    optionLayer.textAlign(CENTER, CENTER);
    optionLayer.text("OPTIONS", 100, 50);

    optionLayer.stroke(255);
    optionLayer.line(200, 50, width - 50, 50);

    // ----- AUDIO -----
    optionLayer.fill(255);
    optionLayer.textSize(30);
    optionLayer.textAlign(LEFT, CENTER);
    optionLayer.text("Audio: ", 100, 100);

    // ----- EFFETTI SONORI -----
    optionLayer.fill(255);
    optionLayer.textSize(30);
    optionLayer.textAlign(LEFT, CENTER);
    optionLayer.text("Effetti sonori: ", 200, 150);
    optionLayer.fill(255);
    optionLayer.textSize(30);
    optionLayer.textAlign(LEFT, CENTER);
    optionLayer.text(volumeEffectsLevel, width - 200, 150);

    // ----- MUSICA -----
    optionLayer.fill(255);
    optionLayer.textSize(30);
    optionLayer.textAlign(LEFT, CENTER);
    optionLayer.text("Musica: ", 200, 200);

    optionLayer.fill(255);
    optionLayer.textSize(30);
    optionLayer.textAlign(LEFT, CENTER);
    optionLayer.text(volumeMusicLevel, width - 200, 225);

    // scritta difficolta
    optionLayer.fill(255);
    optionLayer.textSize(30);
    optionLayer.textAlign(LEFT, CENTER);
    optionLayer.text("Difficolta: ", 100, 250);

    // scritta lingua
    optionLayer.fill(255);
    optionLayer.textSize(30);
    optionLayer.textAlign(LEFT, CENTER);
    optionLayer.text("Lingua: ", 100, 300);

    optionLayer.stroke(255);
    optionLayer.line(50, height - 100, width - 270, height - 100);

    for (Button button : buttons) {
      if (button.isClicked()) {
        switch(button.label) {
        case "e+":
          volumeEffectsLevel += 0.1;

          if (volumeEffectsLevel > 1.0) volumeEffectsLevel = 1.0;

          updateEffectsVolume(volumeEffectsLevel);
          break;

        case "e-":
          volumeEffectsLevel -= 0.1;

          if (volumeEffectsLevel < 0.0) volumeEffectsLevel = 0.0;

          updateEffectsVolume(volumeEffectsLevel);
          break;

        case "m+":
          volumeMusicLevel += 0.1;

          if (volumeMusicLevel > 1.0) volumeMusicLevel = 1.0;

          updateMusicVolume(volumeMusicLevel);
          break;

        case "m-":
          volumeMusicLevel -= 0.1;

          if (volumeMusicLevel < 0.0) volumeMusicLevel = 0.0;
          updateMusicVolume(volumeMusicLevel);
          break;

        case "Back to menu":
          if (previous_state == MENU_SCREEN) {
            // salva lo stato
            previous_state = screen_state;

            // torna al menu
            screen_state = MENU_SCREEN;
          } else if (previous_state == PAUSE_SCREEN) {
            // salva lo stato
            previous_state = screen_state;

            // torna alla schermata di pausa
            screen_state = PAUSE_SCREEN;
          }
          break;
        }
      }

      button.update();
      button.display(optionLayer);
    }

    optionLayer.endDraw();
    image(optionLayer, 0, 0);
  }
}
