class Chest extends Item {
  Item item;                // oggetto contenuto nella cassa (stile zelda)
  boolean isOpen;            // true aperta - false chiusa
  Item openWith;              // oggetto che serve per aprire la chest
  boolean isRare;

  Chest(String name) {
    super(name);
    item = null;
    isOpen = false;    // la cassa di base è chiusa
    openWith = null;   // non si puo aprire con nessun oggetto
    isRare = false;    // non è rara
  }

  Item getItem() {
    return item;
  }

  Item getOpenWith() {
    return openWith;
  }

  void setItem(Item item) {
    this.item = item;
  }

  void setIsOpen(boolean isOpen) {
    this.isOpen = isOpen;
  }

  void setOpenWith(Item key) {
    this.openWith = key;
  }

  boolean isOpen() {
    return isOpen;
  }

  boolean isRare() {
    return isRare;
  }

  void setIsRare(boolean isRare) {
    this.isRare = isRare;
  }
  
  // il metodo display lo eredita da item
  
  // metodo per collisioni ereditato da item
  
  // metodo per calcolare la posizione dei drop 
  PVector calculateDropPosition() {
    float dropRadius = 2;
    PVector dropPosition = spritePosition.copy();
  
    for (int i = 0; i < 10; i++) {
      float xOffset = random(-dropRadius, dropRadius);
      float yOffset = random(-dropRadius, dropRadius);
  
      dropPosition.add(xOffset, yOffset);
  
      if (!isCollisionTile((int) dropPosition.x, (int) dropPosition.y)) {
        break;
      } else {
        dropPosition = spritePosition.copy();
      }
    }
  
    return dropPosition;
  }
}
