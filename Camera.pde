class Camera {
  float x = 0;
  float y = 0;
  float zoom;    // zoom ideale 5, in realta la camera deve seguire il giocatore
  float easing;
  
  int cols;
  int rows;

  void update() {
    float targetCameraX = p1.box.getX() * zoom - width / 2;
    float targetCameraY =  p1.box.getY() * zoom - height / 2;

    // Limita la telecamera in modo che non esca dalla mappa
    targetCameraX = constrain(targetCameraX, 0, cols * Utils.TILE_SIZE * zoom - width);
    targetCameraY = constrain(targetCameraY, 0, rows * Utils.TILE_SIZE * zoom - height);

    // Interpolazione per rendere il movimento della camera più fluido
    x += (targetCameraX - x) * easing;
    y += (targetCameraY - y) * easing;
  }

  Camera() {
    this.cols = width / Utils.TILE_SIZE;
    this.rows = width / Utils.TILE_SIZE;
      
    this.zoom = 5.0;
    this.easing = 0.7;
  }
}
