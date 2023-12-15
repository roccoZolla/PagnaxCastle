// option screen
class Option {
  ArrayList<Button> buttons;
  PGraphics optionLayer;

  Option() {
    optionLayer = createGraphics(width, height);
    buttons = new ArrayList();

    buttons.add(new Button(width - 100, 150, 50, 50, "e+", ""));    // selettore effetti sonori
    buttons.add(new Button(width - 250, 150, 50, 50, "e-", ""));
    buttons.add(new Button(width - 100, 210, 50, 50, "m+", ""));   // selettore volume musica
    buttons.add(new Button(width - 250, 210, 50, 50, "m-", ""));
    buttons.add(new Button(width - 100, 280, 50, 50, ">", ""));    // selettore difficolta
    buttons.add(new Button(width - 250, 280, 50, 50, "<", ""));
    buttons.add(new Button(width - 100, 350, 50, 50, ">", ""));    // selettore lingua
    buttons.add(new Button(width - 250, 350, 50, 50, "<", ""));
    buttons.add(new Button(100, 420, 200, 80, "Comandi", ""));
    buttons.add(new Button(width - 250, height - 150, 200, 80, "Back", ""));
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
    optionLayer.text("Effetti sonori: ", 200, 160);
    
    optionLayer.fill(255);
    optionLayer.textSize(30);
    optionLayer.textAlign(LEFT, CENTER);
    optionLayer.text(volumeEffectsLevel, width - 200, 175);
    
    optionLayer.stroke(255);
    optionLayer.line(200, 160, width - 100, 160);
    
    optionLayer.stroke(255);
    optionLayer.line(200, 150, width - 200, 150);    
    
    optionLayer.stroke(255);
    optionLayer.line(200, 220, width - 250, 220);

    // ----- MUSICA -----
    optionLayer.fill(255);
    optionLayer.textSize(30);
    optionLayer.textAlign(LEFT, CENTER);
    optionLayer.text("Musica: ", 200, 220);

    optionLayer.fill(255);
    optionLayer.textSize(30);
    optionLayer.textAlign(LEFT, CENTER);
    optionLayer.text(volumeMusicLevel, width - 200, 235);
    
    optionLayer.stroke(255);
    optionLayer.line(200, 210, width - 200, 210);
    
    optionLayer.stroke(255);
    optionLayer.line(200, 210, width - 100, 210);    
    
    optionLayer.stroke(255);
    optionLayer.line(200, 220, width - 100, 220);

    // scritta difficolta
    optionLayer.fill(255);
    optionLayer.textSize(30);
    optionLayer.textAlign(LEFT, CENTER);
    optionLayer.text("Difficolta: ", 100, 290);
    
    optionLayer.stroke(255);
    optionLayer.line(100, 280, width - 250, 280);
    
    optionLayer.stroke(255);
    optionLayer.line(100, 330, width - 100, 330);

    // scritta lingua
    optionLayer.fill(255);
    optionLayer.textSize(30);
    optionLayer.textAlign(LEFT, CENTER);
    optionLayer.text("Lingua: ", 100, 360);
    
    optionLayer.stroke(255);
    optionLayer.line(100, 350, width - 100, 350);
    
    optionLayer.stroke(255);
    optionLayer.line(100, 400, width - 100, 400);

    // linea che parte dal pulsante back a chiudere a la pagina
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
          
        case "Comandi":
          // previous_state = screen_state;
          screen_state = TUTORIAL_SCREEN;
          break;

        case "Back":
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

  void updateEffectsVolume(float volumeEffectsLevel) {
    pickupCoin.amp(volumeEffectsLevel);
    normalChestOpen.amp(volumeEffectsLevel);
    specialChestOpen.amp(volumeEffectsLevel);
    drinkPotion.amp(volumeEffectsLevel);
  }

  void updateMusicVolume(float volumeMusicLevel) {
    soundtrack.amp(volumeMusicLevel);
  }
}
