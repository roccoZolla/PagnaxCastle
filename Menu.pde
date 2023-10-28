class Menu {
  ArrayList<Button> buttons;

  Menu() {
    // menu
    buttons = new ArrayList();
    
    buttons.add(new Button(width / 2 - 100, height / 2, 200, 80, "Start", ""));
    buttons.add(new Button(width / 2 - 100, height / 2 + 100, 200, 80, "Option", ""));
    buttons.add(new Button(width / 2 - 100, height / 2 + 200, 200, 80, "Exit", ""));
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
        switch(button.label) {
        case "Start":
          // salva lo stato
          previous_state = screen_state;

          // inizializza il mondo
          setupGame();

          // far partire di qua la creazione dei livelli
          screen_state = STORY_SCREEN;
          break;

        case "Option":
          // salva lo stato
          previous_state = screen_state;

          // cambia lo stato
          screen_state = OPTION_SCREEN;
          break;

        case "Exit":
          exit();
          break;
        }
      }
      
      button.update();
      button.display();
    }
  }
}
