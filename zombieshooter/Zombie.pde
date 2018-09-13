class Zombie {
  private int radius;
  private int x, y;
  private boolean isSelected = false;
  public final int id;
  private int health;

  public Zombie(int radius, int x, int y, int id, int health) {
    this.x = x;
    this.y = y;
    this.radius = radius;
    this.id = id;
    this.health = health;
  }

  public void move(int xDistance, int yDistance) {
    x += xDistance;
    y += yDistance;
  }

  public void render() {
    fill(isSelected?321:123);
    ellipse(x, y, radius, radius);
  }

  public int getX() {
    return x;
  }

  public int getY() {
    return y;
  }

  public int getRadius() {
    return radius;
  }

  public void select() {
    println("Zombie " + id + " selected");
    isSelected = true;
  }

  public void unSelect() {
    println("Zombie " + id + " unselected");
    isSelected = false;
  }

  public boolean isSelected() {
    return isSelected;
  }

  public int health() {
    return health;
  }

  
}
