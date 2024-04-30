class CreditScreen {
  ArrayList<Button> buttons;

  HashMap<String, String> strings;

  String credits = "";
  String studio_name = "";
  String code_link = "https://github.com/roccoZolla/PagnaxCastle";
  String description = "";
  String back = "";

  CreditScreen() {
    buttons = new ArrayList();

    buttons.add(new Button(width - 250, height - 120, 200, 80, "back", back, ""));
    buttons.add(new Button(100, 170, textWidth(code_link), 80, "code", code_link, ""));
  }

  void display() {
    // pulisci lo schermo
    background(0);

    // scritta crediti
    textFont(myFont);
    fill(255);
    textSize(36);
    textAlign(CENTER, CENTER);
    text(credits, width / 2, 50);

    // linea che parte dall'inizio della pagina e arriva al titolo
    stroke(255);
    line(50, 50, width / 2 - textWidth(credits), 50);

    // linea che parte dal titolo e arriva a fine pagina
    stroke(255);
    line(width / 2 + textWidth(credits), 50, width - 50, 50);

    // STUDIO
    textFont(myFont);
    fill(255);
    textSize(30);
    textAlign(CENTER, CENTER);
    text(studio_name, 200, 100);

    // linea che parte dal pulsante back a chiudere a la pagina
    stroke(255);
    line(50, height - 80, width - 270, height - 80);

    for (Button button : buttons) {
      if (button.isClicked()) {
        switch(button.name) {
        case "back":
          screen_state = ScreenState.OPTION_SCREEN;
          break;

        case "code":
          link(code_link);
          break;
        }
      }

      button.update();
      button.display();
    }
  }

  void updateScreen() {
    // aggiorna posizione bottoni
    buttons.get(0).updatePosition(width - 250, height - 120, 200, 80);
  }

  // metodo migliore rispetto al mio
  // piu rapido e modulare
  void updateLanguage(Language language) {
    strings = getStringsForLanguage(language);
    updateUI();
  }

  void updateUI() {
    credits = strings.get("credits");
    studio_name = strings.get("studioName");
    description = strings.get("description");
    back = strings.get("back");
    buttons.get(0).setLabel(back);
  }

  HashMap<String, String> getStringsForLanguage(Language language) {
    HashMap<String, String> languageStrings = new HashMap<String, String>();
    JSONObject bundle = null;
    
    switch(language) {
    case ITALIAN:
      bundle = bundleITA.getJSONObject("menu").getJSONObject("credits");
      break;

    case ENGLISH:
      bundle = bundleENG.getJSONObject("menu").getJSONObject("credits");
      break;

    case SPANISH:
      bundle = bundleESP.getJSONObject("menu").getJSONObject("credits");
      break;
    }

    languageStrings.put("credits", bundle.getString("credits"));
    languageStrings.put("studioName", bundle.getString("studioName"));
    languageStrings.put("description", bundle.getString("description"));
    languageStrings.put("back", bundle.getString("back"));

    return languageStrings;
  }
}
