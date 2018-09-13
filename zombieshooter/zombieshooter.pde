color grid[][] = new color[32][32];
int tileSize = 16;
int barricadeX = tileSize * 5;

ArrayList<Zombie> zombies = new ArrayList();
ArrayList<Defender> defenders = new ArrayList();

Zombie selectedZombie = null;
Defender selectedDefender = null;

void setup() {
  int w = grid.length * tileSize;
  int h = grid[0].length * tileSize;
  size(512, 512);
  background(0);
  for (int y = 14; y < 18; y++) {
    for (int x = 0; x < grid[y].length; x++) {
      grid[x][y] = color(255);
    }
  }
  for (int y = 0; y < grid[barricadeX / tileSize].length; y++) {
    grid[barricadeX / tileSize][y] = color(#9B6E37);
  }
  zombies.add(new Zombie(tileSize, 30*tileSize, 15*tileSize, 0));
  zombies.add(new Zombie(tileSize, 30*tileSize, 14*tileSize, 1));
  defenders.add(new Defender(tileSize, 3*tileSize, 13*tileSize, 2));
  defenders.add(new Defender(tileSize, 3*tileSize, 18*tileSize, 3));
  defenders.get(0).assignTarget(zombies.get(0));
}

void draw() {
  stroke(0);
  for (int x = 0; x < grid.length; x++) {
    for (int y = 0; y < grid[x].length; y++) {
      fill(grid[x][y]);
      stroke(0);
      rect(x*tileSize, y*tileSize, tileSize, tileSize);
    }
  }
  for (Zombie zombie : zombies) {
    if (zombie.getX() > barricadeX + tileSize) {
      zombie.move(-1, 0);
    }
    stroke(0);
    zombie.render();
  }
  for (Defender defender : defenders) {
    stroke(0);
    defender.render();
    defender.shootTarget();
  }
}

void mouseMoved() {
}

void mousePressed() {
  for (Zombie zombie : zombies) {
    if (dist(zombie.getX(), zombie.getY(), mouseX, mouseY) 
      <= zombie.getRadius()) {
      zombie.select();
      selectedZombie = zombie;
      if (selectedDefender != null) {
        selectedDefender.assignTarget(selectedZombie);
      }
    } else {
      selectedZombie = null;
      zombie.unSelect();
    }
  }
  for (Defender defender : defenders) {
    if (dist(defender.getX(), defender.getY(), mouseX, mouseY) 
      <= defender.getRadius()) {
      selectedDefender = defender;
      defender.select();
      for (Defender defenderInner : defenders) {
        if (defenderInner.id != defender.id) {
          defender.unSelect();
        }
      }
      break;
      /*
      This is so unbelievably fugly...
      But I don't want to use fancy Lambda-stuff outside of the Processing API.
      */
    }
  }
}
