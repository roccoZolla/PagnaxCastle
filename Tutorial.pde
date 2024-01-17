// tutorial screen
class Tutorial {
  ArrayList<Button> buttons;

  Tutorial() {
    // menu
    buttons = new ArrayList();
    
    buttons.add(new Button(width - 250, height - 150, 200, 80, "back", "Back", ""));
  }
  
    void display() {
      // salva lo stato precedente
      background(0);
      
      // scritta tutorial
      textFont(myFont);
      fill(255);
      textSize(36);
      textAlign(CENTER, CENTER);
      text("COMANDI", 100, 50);
      
      stroke(255);
      line(200, 50, width - 50, 50);
        
      // ----- MOVIMENTO -----
      fill(255);
      textSize(30);
      textAlign(LEFT, CENTER);
      text("- Movimento giocatore", 100, 100);
      
      image(letter_w, 150, 150);
      image(letter_a, 130, 170);
      image(letter_s, 150, 170);
      image(letter_d, 170, 170);
      
      // ----- ATTACCO -----
      fill(255);
      textSize(30);
      textAlign(LEFT, CENTER);
      text("- Attacca i nemici", 100, 230);
      
      image(letter_j, 150, 270);
    
      // ----- INTERAZIONE -----
      fill(255);
      textSize(30);
      textAlign(LEFT, CENTER);
      text("- Interagisci con gli oggetti", 100, 330);
      
      image(letter_k, 150, 370);
      
      // ----- UTILIZZA GLI OGGETTI -----
      fill(255);
      textSize(30);
      textAlign(LEFT, CENTER);
      text("- Utilizza gli oggetti", 100, 430);
      
      image(letter_l, 150, 470);
      
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
}
