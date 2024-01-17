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
  
  void dropItemNormalChest() {
    double randomValue = Math.random();
    println("random value:" + randomValue);
    
    // probabilità che la cassa droppi qualcosa
    double dropHeartProbability = 0.4;    // 40
    double dropSwordProbability = 0.4;    // 40
    double dropGoldenKeyProbability = 0.2;  // 20
    
    PVector dropPosition = calculateDropPosition();
    
    if (randomValue <= dropHeartProbability) {
        println("cuore droppato");
        // drop del cuore 
        Healer dropHeart = new Healer("dropHeart", 10);
        dropHeart.sprite = heart_sprite;
        dropHeart.spritePosition = dropPosition;
        currentLevel.dropItems.add(dropHeart);
    } else if (randomValue > dropHeartProbability && randomValue <= dropHeartProbability + dropSwordProbability) {
        println("spada droppata");
        // drop della spada
        Weapon dropSword = new Weapon("dropSword", 20); // Assumendo che una spada valga 20 danni
        dropSword.sprite = sword.sprite;
        dropSword.spritePosition = dropPosition;
        currentLevel.dropItems.add(dropSword);
    } else if (randomValue > dropHeartProbability + dropSwordProbability && randomValue <= dropHeartProbability + dropSwordProbability + dropGoldenKeyProbability) {
        println("chiave oro droppata");
        // drop della chiave d'oro
        Item dropGoldenKey = new Item("dropGoldenKey");
        dropGoldenKey.sprite = golden_key.sprite;
        dropGoldenKey.spritePosition = dropPosition;
        dropGoldenKey.isCollectible = true;
        currentLevel.dropItems.add(dropGoldenKey);
    }
  }
  
  void dropItemSpecialChest() {
    // drop causale dell'item
    double randomValue = Math.random();
    println("random value:" + randomValue);
    
    // probabilità che la cassa speciale droppi qualcosa
    double dropTorchProbability = 0.15;    // 15 % 
    double dropMapProbability = 0.15;     // 15 %
    double dropSuperSwordProbability = 0.30; // 30 %
    double dropPotionProbability = 0.40;      // 40 %
    
    PVector dropPosition = calculateDropPosition();
    
    if (randomValue <= dropTorchProbability && !game.isTorchDropped) {
        println("torcia droppata");
        // drop della torcia
        Item dropTorch = new Item("dropTorch");
        dropTorch.sprite = torch_sprite;
        dropTorch.spritePosition = dropPosition;                    
        dropTorch.isCollectible = true;
        currentLevel.dropItems.add(dropTorch);
        game.isTorchDropped = true;
    } else if (randomValue > dropTorchProbability && randomValue <= dropTorchProbability + dropMapProbability && !game.isMapDropped) {
        println("mappa droppata");
        // drop della mappa
        Item dropMap = new Item("dropMap");
        dropMap.sprite = dungeon_map_sprite;
        dropMap.spritePosition = dropPosition;                    
        dropMap.isCollectible = true;
        currentLevel.dropItems.add(dropMap);
        game.isMapDropped = true;
    } else if (randomValue > dropTorchProbability + dropMapProbability && randomValue <= dropTorchProbability + dropMapProbability + dropSuperSwordProbability) {
        println("super spada droppata");
        // drop della super spada
        //Weapon dropSuperSword = new Weapon("dropSuperSword", 50); // Assumendo che una super spada valga 50 danni
        //// dropSuperSword.sprite = super_sword.sprite;
        //dropSuperSword.spritePosition = dropPosition;
        //currentLevel.dropItems.add(dropSuperSword);
    } else if (randomValue > dropTorchProbability + dropMapProbability + dropSuperSwordProbability &&
               randomValue <= dropTorchProbability + dropMapProbability + dropSuperSwordProbability + dropPotionProbability) {
        println("pozione droppata");
        // drop della pozione
        //Potion dropPotion = new Potion("dropPotion", 30); // Assumendo che una pozione aggiunga 30 punti vita
        //dropPotion.sprite = potion.sprite;
        //dropPotion.spritePosition = dropPosition;
        //currentLevel.dropItems.add(dropPotion);
    }
  }
  
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
