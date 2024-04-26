class Menu {
  ArrayList<Button> buttons;

  String gameTitle = "";
  String play = "";
  String option = "";
  String exit = "";
  String info_studio = "";

  Menu() {
    // menu
    buttons = new ArrayList();

    buttons.add(new Button(width / 2 - 100, height / 2, 200, 80, "start", play, ""));
    buttons.add(new Button(width / 2 - 100, height / 2 + 100, 200, 80, "option", option, ""));
    buttons.add(new Button(width / 2 - 100, height / 2 + 200, 200, 80, "exit", exit, ""));

    info_studio = "Studio Ocarina ©, 2024";
  }

  void display() {
    background(0); // Cancella lo schermo

    // draw title
    fill(255);
    textSize(80);
    textAlign(CENTER, CENTER);
    text(gameTitle, width / 2, height / 2 - 100);

    // draw
    fill(255);
    textSize(30);
    textAlign(LEFT, LEFT);
    text(info_studio, width - 340, height - 10);

    for (Button button : buttons) {
      if (button.isClicked()) {
        switch(button.name) {
        case "start":
          // salva lo stato
          previous_state = screen_state;

          // inizializza il gioco
          game.init();

          // inizializza il render system
          render.init();

          // inizializza il collision system
          collision.init();

          // inizializza il fisico system
          fisico.init();

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

  void updateLanguage(Language language) {
    if (language == Language.ITALIAN)
    {
      gameTitle = bundleITA.getJSONObject("menu").getJSONObject("main").getString("title");

      play = bundleITA.getJSONObject("menu").getJSONObject("main").getString("play");
      buttons.get(0).setLabel(play);

      option = bundleITA.getJSONObject("menu").getJSONObject("main").getString("options");
      buttons.get(1).setLabel(option);

      exit = bundleITA.getJSONObject("menu").getJSONObject("main").getString("quit");
      buttons.get(2).setLabel(exit);
    } else if (language == Language.ENGLISH)
    {
      gameTitle = bundleENG.getJSONObject("menu").getJSONObject("main").getString("title");

      play = bundleENG.getJSONObject("menu").getJSONObject("main").getString("play");
      buttons.get(0).setLabel(play);

      option = bundleENG.getJSONObject("menu").getJSONObject("main").getString("options");
      buttons.get(1).setLabel(option);

      exit = bundleENG.getJSONObject("menu").getJSONObject("main").getString("quit");
      buttons.get(2).setLabel(exit);
    }
  }
}
