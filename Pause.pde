class Pause {
  ArrayList<Button> buttons;
  PGraphics pauseLayer;

  Pause() {
    pauseLayer = createGraphics(width, height);
    buttons = new ArrayList();

    buttons.add(new Button(width / 2 - 100, height / 2, 200, 80, "Resume", ""));
    buttons.add(new Button(width / 2 - 100, height / 2 + 100, 200, 80, "Option", ""));
    buttons.add(new Button(width / 2 - 100, pauseLayer.height / 2 + 200, 200, 80, "Back to menu", ""));
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
        switch(button.label) {
        case "Resume":
          // salva lo stato
          previous_state = screen_state;

          // cambia lo stato
          screen_state = GAME_SCREEN;

          soundtrack.play();
          break;

        case "Option":
          // salva lo stato
          previous_state = screen_state;

          // cambia lo stato
          screen_state = OPTION_SCREEN;
          break;

        case "Back to menu":
          // salva lo stato
          previous_state = screen_state;

          // torna al menu
          screen_state = MENU_SCREEN;
          
          // stoppa la traccia di sottofondo
          soundtrack.stop();
          break;
        }
      }

      button.update();
      button.display(pauseLayer);
    }

    pauseLayer.endDraw();
    image(pauseLayer, 0, 0);
  }
}
