
public class Item extends Sprite{
    private int id;
    private String name;
    private boolean takeable = false;   // indica se un oggetto di puo raccogliere
    private boolean useable = false;    // indica se un oggetto si puo usare
    private String description;
    
    // constructors
    public Item() {
        this.id = 0;
        this.name = "";
        this.takeable = false;
        this.useable = false;
        this.description = "";
    }
    
    public Item(int id){
        this.id = id;
    }
    
    public Item(int id, String name){
        this.id = id;
        this.name = name;
    }    
    
    public Item(String name){
        this.name = name;
    }
    
    
    
    // methods
    public int getId() {
        return id;
    }

    public String getName() {
        return name;
    }

    public boolean isTakeable() {
        return takeable;
    }

    public boolean isUseable() {
        return useable;
    }

    public String getDescription() {
        return description;
    }

    public void setId(int id) {
        this.id = id;
    }

    public void setName(String name) {
        this.name = name;
    }

    public void setTakeable(boolean takeable) {
        this.takeable = takeable;
    }

    public void setUseable(boolean useable) {
        this.useable = useable;
    }

    public void setDescription(String description) {
        this.description = description;
    }
}
