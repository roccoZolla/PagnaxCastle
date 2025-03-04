class Chest extends Item {
  Item item;                // oggetto contenuto nella cassa (stile zelda)
  boolean isOpen;            // true aperta - false chiusa
  Item openWith;              // oggetto che serve per aprire la chest
  boolean isRare;
  
  // drop probabilities
  // non definitive
  final float DROP_HEART = 0.3;
  final float DROP_SWORD = 0.3;
  final float DROP_GOLDEN_KEY = 0.3;  // 0.1
  final float DROP_POTION = 0.3;
  
<<<<<<< HEAD
  final float DROP_TORCH = 0.0;
  final float DROP_MAP = 0.9;
  final float DROP_MASTER_SWORD = 0.0;
  

  Chest(PImage sprite) {
    super();
    
=======
  final float DROP_TORCH = 0.3;
  final float DROP_MAP = 0.3;
  final float DROP_MASTER_SWORD = 0.4;
  

  Chest(PImage sprite, String name) {
    super();

    // name
    this.name = name;

>>>>>>> fix
    // sprite
    this.sprite = sprite;

    // box settings
    box = new FBox(SPRITE_SIZE, SPRITE_SIZE);
    box.setName("Chest");
<<<<<<< HEAD
    box.setAllowSleeping(true);  // permette al motore fisico di "addormentare" l'oggetto -> risparmio di risorse
    box.setRotatable(false);
    box.setFillColor(3);
    box.setStaticBody(true);
    box.setFriction(1);
    box.setRestitution(0);
=======
    box.setFillColor(3);
    box.setStaticBody(true);
    box.setFriction(0.8);
    box.setRestitution(0.1);
>>>>>>> fix
    
    // charateristics
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

  void dropItemNormalChest() {
    double randomValue = Math.random();
    PVector dropPosition = calculateDropPosition();

    if (randomValue <= DROP_HEART)
    {
      // drop del cuore
<<<<<<< HEAD
      Item dropHeart = new Item(heart_sprite, "dropHeart", true, 10, false, 0);
      dropHeart.updatePosition(dropPosition);
      game.addDropItem(dropHeart);
    } else if (randomValue > DROP_HEART && randomValue <= DROP_HEART + DROP_SWORD)
    {
      // drop della spada
      Item dropSword = new Item(sword_sprite, "Spada", false, 0, true, 20);
      dropSword.updatePosition(dropPosition);
      game.addDropItem(dropSword);
=======
      // Healer dropHeart = new Healer(dropPosition, heart_sprite, "dropHeart", 10);
      Item dropHeart = new Item(heart_sprite, "dropHeart", true, 10, false, 0);
      dropHeart.updatePosition(dropPosition);
      currentLevel.dropItems.add(dropHeart);
    } else if (randomValue > DROP_HEART && randomValue <= DROP_HEART + DROP_SWORD)
    {
      // drop della spada
      // Weapon dropSword = new Weapon(dropPosition, sword_sprite, "Spada", 20); // Assumendo che una spada valga 20 danni
      Item dropSword = new Item(sword_sprite, "Spada", false, 0, true, 20);
      dropSword.updatePosition(dropPosition);
      currentLevel.dropItems.add(dropSword);
>>>>>>> fix
    } else if (randomValue > DROP_HEART + DROP_SWORD && randomValue <= DROP_HEART + DROP_SWORD + DROP_GOLDEN_KEY)
    {
      // drop della chiave d'oro
      Item dropGoldenKey = new Item(golden_key_sprite, "dropGoldenKey");
      dropGoldenKey.updatePosition(dropPosition);
<<<<<<< HEAD
      game.addDropItem(dropGoldenKey);
=======
      currentLevel.dropItems.add(dropGoldenKey);
>>>>>>> fix
    } else if (randomValue > DROP_HEART + DROP_SWORD + DROP_GOLDEN_KEY &&
      randomValue <= DROP_HEART + DROP_SWORD + DROP_GOLDEN_KEY + DROP_POTION)
    {
      // drop della pozione
<<<<<<< HEAD
      Item dropPotion = new Item(red_potion_sprite, "dropPotion", true, 20, false, 0);
      dropPotion.updatePosition(dropPosition);
      game.addDropItem(dropPotion);
=======
      // Healer dropPotion = new Healer(dropPosition, red_potion_sprite, "dropPotion", 20);
      Item dropPotion = new Item(red_potion_sprite, "dropPotion", true, 20, false, 0);
      dropPotion.updatePosition(dropPosition);
      currentLevel.dropItems.add(dropPotion);
>>>>>>> fix
    }
  }

  void dropItemSpecialChest() {
    // drop causale dell'item
    double randomValue = Math.random();
    PVector dropPosition = calculateDropPosition();

    if (randomValue <= DROP_TORCH && !game.isTorchDropped)
    {
      // drop della torcia
      Item dropTorch = new Item(torch_sprite, "dropTorch");
      dropTorch.updatePosition(dropPosition);
<<<<<<< HEAD
      game.addDropItem(dropTorch);
=======
      currentLevel.dropItems.add(dropTorch);
>>>>>>> fix
      game.isTorchDropped = true;
    } else if (randomValue > DROP_TORCH
      && randomValue <= DROP_TORCH + DROP_MAP
      && !game.isMapDropped)
    {
      // drop della mappa
      Item dropMap = new Item(dungeon_map_sprite, "dropMap");
      dropMap.updatePosition(dropPosition);
<<<<<<< HEAD
      game.addDropItem(dropMap);
=======
      currentLevel.dropItems.add(dropMap);
>>>>>>> fix
      game.isMapDropped = true;
    } else if (randomValue > DROP_TORCH + DROP_MAP
      && randomValue <= DROP_TORCH + DROP_MAP + DROP_MASTER_SWORD
      && !game.isMasterSwordDropped)
    {
      // drop della super spada
      Item dropMasterSword = new Item(master_sword_sprite, "Spada del Maestro", false, 0, true, 50);
      dropMasterSword.updatePosition(dropPosition);
<<<<<<< HEAD
      game.addDropItem(dropMasterSword);
=======
      currentLevel.dropItems.add(dropMasterSword);
>>>>>>> fix
      game.isMasterSwordDropped = true;
    }
  }

  // metodo per calcolare la posizione dei drop
<<<<<<< HEAD
  // da rivedere
=======
>>>>>>> fix
  private PVector calculateDropPosition() {
    float dropRadius = 2;
    PVector dropPosition = getPosition().copy();
    
    dropPosition.x = ( dropPosition.x - (SPRITE_SIZE/2) ) / SPRITE_SIZE;
    dropPosition.y = ( dropPosition.y - (SPRITE_SIZE/2) ) / SPRITE_SIZE;
    
    for (int i = 0; i < 10; i++) {
      float xOffset = random(-dropRadius, dropRadius);
      float yOffset = random(-dropRadius, dropRadius);

      dropPosition.add(xOffset, yOffset);
      
<<<<<<< HEAD
      //if (!isWall((int) dropPosition.x, (int) dropPosition.y)) {
      //  break;
      //} else {
      //  dropPosition = getPosition().copy();
      //}
=======
      if (!isWall((int) dropPosition.x, (int) dropPosition.y)) {
        break;
      } else {
        dropPosition = getPosition().copy();
      }
>>>>>>> fix
    }
    
    return dropPosition;
  }
}
