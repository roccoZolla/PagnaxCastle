class Chest extends Item {
  Item item;                // oggetto contenuto nella cassa (stile zelda)
  boolean isOpen;            // true aperta - false chiusa
  Item openWith;              // oggetto che serve per aprire la chest
  boolean isRare;

  Chest(PImage sprite, String name) {
    super();

    // name
    this.name = name;

    // sprite
    this.sprite = sprite;

    // box settings
    box = new FBox(SPRITE_SIZE, SPRITE_SIZE);
    box.setFillColor(3);
    box.setStatic(true);
    box.setFriction(0.8);
    box.setRestitution(0.1);
    
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

    // probabilità che la cassa droppi qualcosa
    double dropHeartProbability = 0.3;    // 30
    double dropSwordProbability = 0.3;    // 30
    double dropGoldenKeyProbability = 0.3;  // 10
    double dropPotionProbability = 0.3;        // 30

    PVector dropPosition = calculateDropPosition();

    if (randomValue <= dropHeartProbability)
    {
      // drop del cuore
      // Healer dropHeart = new Healer(dropPosition, heart_sprite, "dropHeart", 10);
      Item dropHeart = new Item(heart_sprite, "dropHeart", true, 10, false, 0);
      dropHeart.updatePosition(dropPosition);
      currentLevel.dropItems.add(dropHeart);
    } else if (randomValue > dropHeartProbability && randomValue <= dropHeartProbability + dropSwordProbability)
    {
      // drop della spada
      // Weapon dropSword = new Weapon(dropPosition, sword_sprite, "Spada", 20); // Assumendo che una spada valga 20 danni
      Item dropSword = new Item(sword_sprite, "Spada", false, 0, true, 20);
      dropSword.updatePosition(dropPosition);
      currentLevel.dropItems.add(dropSword);
    } else if (randomValue > dropHeartProbability + dropSwordProbability && randomValue <= dropHeartProbability + dropSwordProbability + dropGoldenKeyProbability)
    {
      // drop della chiave d'oro
      Item dropGoldenKey = new Item(golden_key_sprite, "dropGoldenKey");
      dropGoldenKey.updatePosition(dropPosition);
      currentLevel.dropItems.add(dropGoldenKey);
    } else if (randomValue > dropHeartProbability + dropSwordProbability + dropGoldenKeyProbability &&
      randomValue <= dropHeartProbability + dropSwordProbability + dropGoldenKeyProbability + dropPotionProbability)
    {
      // drop della pozione
      // Healer dropPotion = new Healer(dropPosition, red_potion_sprite, "dropPotion", 20);
      Item dropPotion = new Item(red_potion_sprite, "dropPotion", true, 20, false, 0);
      dropPotion.updatePosition(dropPosition);
      currentLevel.dropItems.add(dropPotion);
    }
  }

  void dropItemSpecialChest() {
    // drop causale dell'item
    double randomValue = Math.random();

    // probabilità che la cassa speciale droppi qualcosa
    double dropTorchProbability = 0.3;    // 15 %
    double dropMapProbability = 0.3;     // 15 %
    double dropSuperSwordProbability = 0.4; // 30 %

    PVector dropPosition = calculateDropPosition();

    if (randomValue <= dropTorchProbability && !game.isTorchDropped)
    {
      // drop della torcia
      Item dropTorch = new Item(torch_sprite, "dropTorch");
      dropTorch.updatePosition(dropPosition);
      currentLevel.dropItems.add(dropTorch);
      game.isTorchDropped = true;
    } else if (randomValue > dropTorchProbability
      && randomValue <= dropTorchProbability + dropMapProbability
      && !game.isMapDropped)
    {
      // drop della mappa
      Item dropMap = new Item(dungeon_map_sprite, "dropMap");
      dropMap.updatePosition(dropPosition);
      currentLevel.dropItems.add(dropMap);
      game.isMapDropped = true;
    } else if (randomValue > dropTorchProbability + dropMapProbability
      && randomValue <= dropTorchProbability + dropMapProbability + dropSuperSwordProbability
      && !game.isMasterSwordDropped)
    {
      // drop della super spada
      Item dropMasterSword = new Item(master_sword_sprite, "Spada del Maestro", false, 0, true, 50);
      dropMasterSword.updatePosition(dropPosition);
      currentLevel.dropItems.add(dropMasterSword);
      game.isMasterSwordDropped = true;
    }
  }

  // metodo per calcolare la posizione dei drop
  PVector calculateDropPosition() {
    float dropRadius = 2;
    PVector dropPosition = getPosition().copy();

    for (int i = 0; i < 10; i++) {
      float xOffset = random(-dropRadius, dropRadius);
      float yOffset = random(-dropRadius, dropRadius);

      dropPosition.add(xOffset, yOffset);

      if (!isWall((int) dropPosition.x, (int) dropPosition.y)) {
        break;
      } else {
        dropPosition = getPosition().copy();
      }
    }

    return dropPosition;
  }
}
