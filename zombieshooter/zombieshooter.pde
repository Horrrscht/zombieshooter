color grid[][] = new color[32][32];
int tileSize = 16;
int barricadeX = tileSize * 5;

ArrayList<Zombie> zombies = new ArrayList();
ArrayList<Defender> defenders = new ArrayList();

PVector defenderPositions[] = {
  new PVector(3*tileSize, 13*tileSize),
  new PVector(3*tileSize, 19*tileSize)
};

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
  zombies.add(new Zombie(tileSize, 30*tileSize, 15*tileSize, 0, 1000));
  zombies.add(new Zombie(tileSize, 33*tileSize, 14*tileSize, 1, 500));
  defenders.add(new Defender(tileSize, (int)defenderPositions[0].x, (int)defenderPositions[0].y, 2, 1));
  defenders.add(new Defender(tileSize, (int)defenderPositions[1].x, (int)defenderPositions[1].y, 3, 1));
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
    if (defender.shootTarget() <= 0) {
      zombies.remove(defender.getTarget());
      defender.assignTarget(randomZombie(zombies));
    }
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

Zombie randomZombie(ArrayList<Zombie> zombies) {
  if (zombies.size() == 0) return null; 
  return zombies.get((int)(Math.random()*zombies.size()));
}
