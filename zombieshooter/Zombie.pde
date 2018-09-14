class Zombie {
  private int radius;
  private int x, y;
  private boolean isSelected = false;
  public final int id;
  private int health;
  public final int maxHealth;
  final color selectedColor = #F02C2C;
  final color unSelectedColor = #6319E5; 
  final color healthColor = #08FF16;

  public Zombie(int radius, int x, int y, int id, int health) {
    this.x = x;
    this.y = y;
    this.radius = radius;
    this.id = id;
    this.health = health;
    maxHealth = health;
  }

  public void move(int xDistance, int yDistance) {
    x += xDistance;
    y += yDistance;
  }

  public void render() {
    fill(isSelected?selectedColor:unSelectedColor);
    ellipse(x, y, radius, radius);
    fill(healthColor);
    if (health > 0) {
      rect(x - radius/2, y - 20, (health/ (float) maxHealth)  * radius, 5);
    }
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

  public int receiveDamage(int damage) {
    if ((health -= damage) <= 0) {
      health = 0;
    }
    return health;
  }
}
