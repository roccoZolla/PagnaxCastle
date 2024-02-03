class Chest extends Item {
  Item item;                // oggetto contenuto nella cassa (stile zelda)
  boolean isOpen;            // true aperta - false chiusa
  Item openWith;              // oggetto che serve per aprire la chest
  boolean isRare;

  Chest(PVector position, PImage sprite, String name) {
    super(position, sprite, name);
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

    if (randomValue <= dropHeartProbability) {
      println("cuore droppato");
      // drop del cuore
      Healer dropHeart = new Healer(dropPosition, heart_sprite, "dropHeart", 10);
      currentLevel.dropItems.add(dropHeart);
    } else if (randomValue > dropHeartProbability && randomValue <= dropHeartProbability + dropSwordProbability) {
      println("spada droppata");
      // drop della spada
      Weapon dropSword = new Weapon(dropPosition, sword_sprite, "Spada", 20); // Assumendo che una spada valga 20 danni
      currentLevel.dropItems.add(dropSword);
    } else if (randomValue > dropHeartProbability + dropSwordProbability && randomValue <= dropHeartProbability + dropSwordProbability + dropGoldenKeyProbability) {
      println("chiave oro droppata");
      // drop della chiave d'oro
      Item dropGoldenKey = new Item(dropPosition, golden_key.sprite, "dropGoldenKey");
      dropGoldenKey.isCollectible = true;
      currentLevel.dropItems.add(dropGoldenKey);
    } else if (randomValue > dropHeartProbability + dropSwordProbability + dropGoldenKeyProbability &&
      randomValue <= dropHeartProbability + dropSwordProbability + dropGoldenKeyProbability + dropPotionProbability) {
      println("pozione droppata");
      // drop della pozione
      Healer dropPotion = new Healer(dropPosition, redPotion.sprite, "dropPotion", 20);
      dropPotion.isCollectible = true;
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

    if (randomValue <= dropTorchProbability && !game.isTorchDropped) {
      println("torcia droppata");
      // drop della torcia
      Item dropTorch = new Item(dropPosition, torch_sprite, "dropTorch");
      dropTorch.isCollectible = true;
      currentLevel.dropItems.add(dropTorch);
      game.isTorchDropped = true;
    } else if (randomValue > dropTorchProbability
      && randomValue <= dropTorchProbability + dropMapProbability
      && !game.isMapDropped) {
      println("mappa droppata");
      // drop della mappa
      Item dropMap = new Item(dropPosition, dungeon_map_sprite, "dropMap");
      dropMap.isCollectible = true;
      currentLevel.dropItems.add(dropMap);
      game.isMapDropped = true;
    } else if (randomValue > dropTorchProbability + dropMapProbability
      && randomValue <= dropTorchProbability + dropMapProbability + dropSuperSwordProbability
      && !game.isMasterSwordDropped) {
      println("super spada droppata");
      // drop della super spada
      Weapon dropMasterSword = new Weapon(dropPosition, master_sword_sprite, "Spada del Maestro", 50); // Assumendo che una super spada valga 50 danni
      currentLevel.dropItems.add(dropMasterSword);
      game.isMasterSwordDropped = true;
    }
  }

  // metodo per calcolare la posizione dei drop
  PVector calculateDropPosition() {
    float dropRadius = 2;
    PVector dropPosition = position.copy();

    for (int i = 0; i < 10; i++) {
      float xOffset = random(-dropRadius, dropRadius);
      float yOffset = random(-dropRadius, dropRadius);

      dropPosition.add(xOffset, yOffset);

      if (!isWall((int) dropPosition.x, (int) dropPosition.y)) {
        break;
      } else {
        dropPosition = position.copy();
      }
    }

    return dropPosition;
  }
}
