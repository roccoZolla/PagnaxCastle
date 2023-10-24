public class Chest extends Item{
    private ArrayList<Item> chest = new ArrayList<>();
    private boolean isOpen;            // true aperta - false chiusa
    private Item openWith;              // oggetto che serve per aprire la chest
    
    Chest(String dataPath) {
      this.img = loadImage(dataPath);
    }

    public ArrayList<Item> getList() {
        return chest;
    }
    
    public Item getOpenWith() {
        return openWith;
    }

    public void setChest(ArrayList<Item> chest) {
        this.chest = chest;
    }
    
    public void setIsOpen(boolean isOpen) {
        this.isOpen = isOpen;
    }
    
    public void setOpenWith(Item key) {
        this.openWith = key;
    }

    public boolean getIsOpen() {
        return isOpen;
    }
}
