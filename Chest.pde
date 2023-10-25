public class Chest extends Item{
    private ArrayList<Item> items;
    private boolean isOpen;            // true aperta - false chiusa
    private Item openWith;              // oggetto che serve per aprire la chest
    private boolean isRare;
    
    Chest(String dataPath) {
      items = new ArrayList(){};
      this.img = loadImage(dataPath);
    }
    
    public ArrayList<Item> getList() {
        return items;
    }
    
    public Item getOpenWith() {
        return openWith;
    }

    public void setChest(ArrayList<Item> items) {
        this.items = items;
    }
    
    public void setIsOpen(boolean isOpen) {
        this.isOpen = isOpen;
    }
    
    public void setOpenWith(Item key) {
        this.openWith = key;
    }

    public boolean isOpen() {
        return isOpen;
    }
    
    public boolean isRare() {
      return isRare;
    }
    
    public void setIsRare(boolean isRare) {
      this.isRare = isRare;
    }
}
