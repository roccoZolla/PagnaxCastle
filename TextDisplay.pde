// classe che gestisce il disegno dei testi a schermo
// fare in modo che si possa anche specificare il layer su cui scrivere il testo
class TextDisplay {
    PVector position;
    String text;
    color text_color;
    long displayStartTime;
    float displayDuration;

    TextDisplay(PVector position, String text, color text_color, float displayDuration) {
        this.position = position.copy();
        this.text = text;
        this.text_color = text_color;
        this.displayDuration = displayDuration;
        this.displayStartTime = System.currentTimeMillis();
    }

    void display() {
        long currentTime = System.currentTimeMillis();
        float elapsedTime = currentTime - displayStartTime;

        if (elapsedTime < displayDuration) {
            spritesLayer.textFont(myFont);
            spritesLayer.fill(text_color);
            spritesLayer.textSize(15);
            spritesLayer.text(text, position.x * currentLevel.tileSize, (position.y * currentLevel.tileSize) - 10);
        }
    }

    boolean isExpired() {
        return System.currentTimeMillis() - displayStartTime >= displayDuration;
    }
}
