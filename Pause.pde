class Pause {
  ArrayList<Button> buttons;
  PGraphics pauseLayer;

  Pause() {
    pauseLayer = createGraphics(width, height);
    buttons = new ArrayList();

    buttons.add(new Button(width / 2 - 100, height / 2, 200, 80, "resume", "Resume", ""));
    buttons.add(new Button(width / 2 - 100, height / 2 + 100, 200, 80, "option", "Option", ""));
    buttons.add(new Button(width / 2 - 100, pauseLayer.height / 2 + 200, 200, 80, "back", "Back to menu", ""));
  }

  void display() {
    pauseLayer.beginDraw();
    // trovare modo per opacizzare lo sfondo
    pauseLayer.background(0);

    // disegna la scritta pausa
    pauseLayer.textFont(myFont);
    pauseLayer.fill(255);
    pauseLayer.textSize(36);
    pauseLayer.textAlign(CENTER, CENTER);
    pauseLayer.text("PAUSA", width / 2, height / 2 - 100);

    for (Button button : buttons) {
      if (button.isClicked()) {
        switch(button.name) {
        case "resume":
          // salva lo stato
          previous_state = screen_state;

          // cambia lo stato
          screen_state = ScreenState.GAME_SCREEN;

          dungeon_background.play();
          break;

        case "option":
          // salva lo stato
          previous_state = screen_state;

          // cambia lo stato
          screen_state = ScreenState.OPTION_SCREEN;
          break;

        case "back":
          // salva lo stato
          previous_state = screen_state;

          // torna al menu
          screen_state = ScreenState.MENU_SCREEN;
          
          // stoppa la traccia di sottofondo
          dungeon_background.stop();
          isDungeonBackgroundPlaying = false;
          break;
        }
      }

      button.update();
      button.display(pauseLayer);
    }

    pauseLayer.endDraw();
    image(pauseLayer, 0, 0);
  }
  
  void updateScreen() {
    pauseLayer = createGraphics(width, height);
    
    // aggiorna posizione bottone 
    buttons.get(0).updatePosition(width / 2 - 100, height / 2, 200, 80);  // resume
    buttons.get(1).updatePosition(width / 2 - 100, height / 2 + 100, 200, 80);  // option
    buttons.get(2).updatePosition(width / 2 - 100, pauseLayer.height / 2 + 200, 200, 80);  // back to the menu
  }
}
