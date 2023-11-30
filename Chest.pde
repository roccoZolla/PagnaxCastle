class Chest extends Item {
  ArrayList<Item> items;
  boolean isOpen;            // true aperta - false chiusa
  Item openWith;              // oggetto che serve per aprire la chest
  boolean isRare;

  Chest() {
    items = new ArrayList() {
    };
  }

  ArrayList<Item> getList() {
    return items;
  }

  Item getOpenWith() {
    return openWith;
  }

  void setChest(ArrayList<Item> items) {
    this.items = items;
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
  
  // verifica collisione
  boolean playerCollide(Player aPlayer) {
    if( aPlayer.spritePosition.x * currentLevel.tileSize <= (spritePosition.x * currentLevel.tileSize) + sprite.width  &&
        (aPlayer.spritePosition.x * currentLevel.tileSize) + aPlayer.sprite.width >= spritePosition.x * currentLevel.tileSize && 
        aPlayer.spritePosition.y * currentLevel.tileSize <= (spritePosition.y * currentLevel.tileSize) + sprite.height && 
        (aPlayer.spritePosition.y * currentLevel.tileSize) + aPlayer.sprite.height >= spritePosition.y * currentLevel.tileSize) {
          return true;
    }
    
    return false;
  }
}
