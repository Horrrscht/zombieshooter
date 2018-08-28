class Defender {
  private int x, y;
  private int radius;
  private boolean isSelected = false;
  private Zombie target;

  public Defender(int radius, int x, int y) {
    this.x = x;
    this.y = y;
    this.radius = radius;
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
    isSelected = true;
  }

  public void unSelect() {
    isSelected = false;
  }

  public boolean isSelected() {
    return isSelected;
  }

  public void assignTarget(Zombie target) {
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
