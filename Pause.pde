class Pause {
  ArrayList<Button> buttons;
  PGraphics pauseLayer;

  HashMap<String, String> strings;

  String title = "";
  String resume = "";
  String options = "";
  String back = "";

  Pause() {
    pauseLayer = createGraphics(width, height);
    buttons = new ArrayList();

    buttons.add(new Button(width / 2 - 100, height / 2, 200, 80, "resume", resume, ""));
    buttons.add(new Button(width / 2 - 100, height / 2 + 100, 200, 80, "option", options, ""));
    buttons.add(new Button(width / 2 - 100, pauseLayer.height / 2 + 200, 200, 80, "back", back, ""));
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
    pauseLayer.text(title, width / 2, height / 2 - 100);

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

  // da mettere nel language system
  // metodo migliore rispetto al mio
  // piu rapido e modulare
  void updateLanguage(Language language) {
    strings = getStringsForLanguage(language);
    updateUI();
  }

  void updateUI() {
    title = strings.get("pause");
    resume = strings.get("resume");
    buttons.get(0).setLabel(resume);
    options = strings.get("options");
    buttons.get(1).setLabel(options);
    back = strings.get("backtomenu");
    buttons.get(2).setLabel(back);
  }

  HashMap<String, String> getStringsForLanguage(Language language) {
    HashMap<String, String> languageStrings = new HashMap<String, String>();
    JSONObject bundle = null;

    switch(language) {
    case ITALIAN:
      bundle = bundleITA.getJSONObject("menu").getJSONObject("pause");
      break;

    case ENGLISH:
      bundle = bundleENG.getJSONObject("menu").getJSONObject("pause");
      break;

    case SPANISH:
      bundle = bundleESP.getJSONObject("menu").getJSONObject("pause");
      break;
    }

    languageStrings.put("pause", bundle.getString("pause"));
    languageStrings.put("resume", bundle.getString("resume"));
    languageStrings.put("options", bundle.getString("option"));
    languageStrings.put("backtomenu", bundle.getString("backtomenu"));

    return languageStrings;
  }
}
