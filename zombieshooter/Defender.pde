class Defender {
  private int x, y;
  private int radius;
  private boolean isSelected = false;
  private Zombie target;
  public final int id;

  public Defender(int radius, int x, int y, int id) {
    this.x = x;
    this.y = y;
    this.radius = radius;
    this.id = id;
  }

  public void render() {
    fill(isSelected?255:123);
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
    println("Assigned zombie " + target.id + " to defender " + id);
    this.target = target;
  }

  public Zombie getTarget() {
    return target;
  }

  public void shootTarget() {
    if (target != null) {
      stroke(#FF0808);
      line(x, y, target.getX(), target.getY());
    }
  }
}
