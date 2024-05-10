class Story
{
  private String storyText = "";
  private String pressButtonToContinue = "";
  private String victory = "";
  private String defeat = "";

  boolean isStoryScreen = true;
  boolean isVictoryScreen = false;
  boolean isLoseScreen = false;

  private JSONObject bundle = null;
  private HashMap<String, String> strings;

  Story() {
  }

  void setStoryScreen()
  {
    this.isStoryScreen = true;
    this.isVictoryScreen = false;
    this.isLoseScreen = false;
  }

  void setVictoryScreen()
  {
    this.isStoryScreen = false;
    this.isVictoryScreen = true;
    this.isLoseScreen = false;
  }

  void setLoseScreen() {
    this.isStoryScreen = false;
    this.isVictoryScreen = false;
    this.isLoseScreen = true;
  }

  void display()
  {
    if (isStoryScreen)
    {
      // salva lo stato precedente
      previous_state = screen_state;

      // Estrai il testo della storia corrispondente all'indice di zona
      storyText = bundle.getString("zone_" + currentZone.zoneIndex);

      writer(storyText);
      image(p1.right_side, width / 2, height / 2 - 130, 64, 64);
    } else if (isVictoryScreen)
    {
      writer(victory + "Score: " + p1.playerScore);

      image(p1.left_side, width / 2 + 50, height / 2 - 120, 64, 64);
      image(chela_sprite, width / 2 - 50, height / 2 - 120, 64, 64);
    } else if (isLoseScreen)
    {
      writer(defeat + "Score: " + p1.playerScore);

      image(boss_sprite, width / 2, height / 2 - 120, 64, 64);
    }
  }

  private void writer(String txt) {
    // cancella lo schermo
    background(0);

    // Mostra il testo narrativo con l'effetto macchina da scrivere
    fill(255);
    textAlign(CENTER, CENTER);
    textSize(24);
    text(txt.substring(0, letterIndex), width / 2, height / 2);

    if (isTyping)
    {
      // Continua a scrivere il testo
      if (frameCount % Utils.typingSpeed == 0)
      {
        if (letterIndex < txt.length()) {
          letterIndex++;
        } else
        {
          isTyping = false;
        }
      }
    } else
    {
      textSize(16);
      text(pressButtonToContinue, width / 2, height - 50);
    }
  }

  void updateLanguage(Language language) {
    strings = getStringsForLanguage(language);
    updateUI();
  }

  private void updateUI()
  {
    pressButtonToContinue = strings.get("pressButton");
    victory = bundle.getString("victory");
    defeat = bundle.getString("defeat");
  }

  private HashMap<String, String> getStringsForLanguage(Language language) {
    HashMap<String, String> languageStrings = new HashMap<String, String>();

    switch(language) {
    case ITALIAN:
      bundle = bundleITA.getJSONObject("game").getJSONObject("story");
      break;

    case ENGLISH:
      bundle = bundleENG.getJSONObject("game").getJSONObject("story");
      break;

    case SPANISH:
      bundle = bundleESP.getJSONObject("game").getJSONObject("story");
      break;
    }

    languageStrings.put("pressButton", bundle.getString("pressButton"));
    languageStrings.put("victory", bundle.getString("victory"));
    languageStrings.put("defeat", bundle.getString("defeat"));

    return languageStrings;
  }
}
