class Camera {
  float x = 0;
  float y = 0;
  float zoom;    // zoom ideale 5, in realta la camera deve seguire il giocatore
  float easing;

  void update() {
    float targetCameraX = p1.getPosition().x * currentLevel.tileSize * zoom - width / 2;
    float targetCameraY = p1.getPosition().y * currentLevel.tileSize * zoom - height / 2;

    // Limita la telecamera in modo che non esca dalla mappa
    targetCameraX = constrain(targetCameraX, 0, currentLevel.cols * currentLevel.tileSize * zoom - width);
    targetCameraY = constrain(targetCameraY, 0, currentLevel.rows * currentLevel.tileSize * zoom - height);

    // Interpolazione per rendere il movimento della camera più fluido
    x += (targetCameraX - x) * easing;
    y += (targetCameraY - y) * easing;
  }

  Camera() {
    this.zoom = 5.0;
    this.easing = 0.7;
  }
}
