class Defender {
  private int x, y;
  private int radius;
  private boolean isSelected = false;
  private Zombie target;
  public final int id;
  private int damage;
  final color selectedColor = #F02C2C;
  final color unSelectedColor = #6319E5; 

  public Defender(int radius, int x, int y, int id, int damage) {
    this.x = x;
    this.y = y;
    this.radius = radius;
    this.id = id;
    this.damage = damage;
  }

  public void render() {
    fill(isSelected?selectedColor:unSelectedColor);
    ellipse(x, y, radius, radius);
    fill(0);
    text(damage, x-radius/2, y);
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
    println("Defender " + id + " selected");
    isSelected = true;
  }

  public void unSelect() {
    println("Defender " + id + " unselected");
    isSelected = false;
  }

  public boolean isSelected() {
    return isSelected;
  }

  public void assignTarget(Zombie target) {
    //println("Assigned zombie " + target.id + " to defender " + id);
    this.target = target;
  }

  public Zombie getTarget() {
    return target;
  }

  public int shootTarget() {
    if (target != null) {
      stroke(#FF0808);
      line(x, y, target.getX(), target.getY());
      return target.receiveDamage(damage);
    }
    return -1;
  }

  public int upgradeDamage(int amount) {
    damage += amount;
    return damage;
  }

  public int getDamage() {
    return damage;
  }
}
