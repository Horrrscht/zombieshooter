class Zombie {
  private int radius;
  private int x, y;
  private boolean isSelected = false;

  public Zombie(int radius, int x, int y) {
    this.x = x;
    this.y = y;
    this.radius = radius;
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
    isSelected = true;
  }
  
  public void unSelect() {
    isSelected = false;
  }
  
  public boolean isSelected() {
    return isSelected;
  }
}
