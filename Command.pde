// tutorial screen
class CommandScreen {
  ArrayList<Button> buttons;
  int imageWidth;
  int imageHeight;
  
  HashMap<String, String> strings;

  String title = "";
  String playerMovement = "";
  String attack = "";
  String interact = "";
  String use = "";
  String back = "";

  CommandScreen() {
    // menu
    buttons = new ArrayList();

    buttons.add(new Button(width - 250, height - 150, 200, 80, "back", back, ""));

    imageWidth = 32;
    imageHeight = 32;
  }

  void display() {
    // salva lo stato precedente
    background(0);

    // scritta comandi
    textFont(myFont);
    fill(255);
    textSize(36);
    textAlign(CENTER, CENTER);
    text(title, 135, 50);

    // linea che parte dalla scritta comandi a chiudere la pagina
    stroke(255);
    line(textWidth(title) + 50, 50, width - 50, 50);

    // ----- MOVIMENTO -----
    fill(255);
    textSize(30);
    textAlign(LEFT, CENTER);
    text("--> " + playerMovement, 100, 100);

    image(letter_w, 150, 130, imageWidth, imageHeight);
    image(letter_a, 110, 170, imageWidth, imageHeight);
    image(letter_s, 150, 170, imageWidth, imageHeight);
    image(letter_d, 190, 170, imageWidth, imageHeight);

    // ----- ATTACCO -----
    fill(255);
    textSize(30);
    textAlign(LEFT, CENTER);
    text("--> " + attack, 100, 230);

    image(letter_j, 150, 270, imageWidth, imageHeight);

    // ----- INTERAZIONE -----
    fill(255);
    textSize(30);
    textAlign(LEFT, CENTER);
    text("--> " + interact, 100, 330);

    image(letter_k, 150, 370, imageWidth, imageHeight);

    // ----- UTILIZZA GLI OGGETTI -----
    fill(255);
    textSize(30);
    textAlign(LEFT, CENTER);
    text("--> " + use, 100, 430);

    image(letter_l, 150, 470, imageWidth, imageHeight);

    // linea che parte dal pulsante back a chiudere a la pagina
    stroke(255);
    line(50, height - 80, width - 270, height - 80);

    for (Button button : buttons) {
      if (button.isClicked()) {
        switch(button.name) {
        case "back":
          screen_state = ScreenState.OPTION_SCREEN;
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
    title = strings.get("title");
    playerMovement = strings.get("playerMovement");
    attack = strings.get("attack");
    interact = strings.get("interact");
    use = strings.get("use");
    back = strings.get("back");
    buttons.get(0).setLabel(back);
  }

  HashMap<String, String> getStringsForLanguage(Language language) {
    HashMap<String, String> languageStrings = new HashMap<String, String>();
    JSONObject bundle = null;
    if (language == Language.ITALIAN) {
      bundle = bundleITA.getJSONObject("menu").getJSONObject("commands");
    } else if (language == Language.ENGLISH) {
      bundle = bundleENG.getJSONObject("menu").getJSONObject("commands  ");
    }

    languageStrings.put("title", bundle.getString("title"));
    languageStrings.put("playerMovement", bundle.getString("playerMovement"));
    languageStrings.put("attack", bundle.getString("attack"));
    languageStrings.put("interact", bundle.getString("interact"));
    languageStrings.put("use", bundle.getString("use"));
    languageStrings.put("back", bundle.getString("back"));

    return languageStrings;
  }
}
