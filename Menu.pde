class Menu {
  ArrayList<Button> buttons;

  Menu() {
    // menu
    buttons = new ArrayList();

    buttons.add(new Button(width / 2 - 100, height / 2, 200, 80, "start", "Start", ""));
    buttons.add(new Button(width / 2 - 100, height / 2 + 100, 200, 80, "option", "Option", ""));
    buttons.add(new Button(width / 2 - 100, height / 2 + 200, 200, 80, "exit", "Exit", ""));
  }

  void display() {
    background(0); // Cancella lo schermo

    // draw title
    fill(255);
    textSize(80);
    textAlign(CENTER, CENTER);
    text(gameTitle, width / 2, height / 2 - 100);

    for (Button button : buttons) {
      if (button.isClicked()) {
        switch(button.name) {
        case "start":
          // salva lo stato
          previous_state = screen_state;

          // inizializza il mondo
          game.init();

          // far partire di qua la creazione dei livelli
          screen_state = ScreenState.STORY_SCREEN;
          break;

        case "option":
          // salva lo stato
          previous_state = screen_state;

          // cambia lo stato
          screen_state = ScreenState.OPTION_SCREEN;
          break;

        case "exit":
          exit();
          break;
        }
      }

      button.update();
      button.display();
    }
  }

  // metodo che viene chiamato ogni qual volta la finestra
  // subisce cambiamenti nelle dimensioni
  void updateScreen() {
    buttons.get(0).updatePosition(width / 2 - 100, height / 2, 200, 80);  // start
    buttons.get(1).updatePosition(width / 2 - 100, height / 2 + 100, 200, 80);  // option
    buttons.get(2).updatePosition(width / 2 - 100, height / 2 + 200, 200, 80);  // exit
  }
}
