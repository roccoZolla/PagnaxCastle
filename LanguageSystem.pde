// gestisce le lingue
class LanguageSystem {
  Language language;

  void init() {
    // lingua di defualt
    language = Language.ITALIAN;
    println("language system inizializzato correttamente");
  }

  void setLanguage(Language language)
  {
    this.language = language;
  }

  // da sistemare
  void update() {
    menu.updateLanguage(language);
    pauseMenu.updateLanguage(language);
    optionMenu.updateLanguage(language);
    commandScreen.updateLanguage(language);
    creditScreen.updateLanguage(language);
    ui.updateLanguage(language);
  }
}
