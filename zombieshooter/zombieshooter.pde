color grid[][] = new color[32][32];
int tileSize = 16;
int barricadeX = tileSize * 5;
int pathWidth = 6; // in tiles

int enemyCount = 100;

ArrayList<Zombie> zombies = new ArrayList();
ArrayList<Defender> defenders = new ArrayList();

int barrierLP = Integer.MAX_VALUE;

PVector defenderPositions[] = {
  new PVector(3*tileSize, 13*tileSize), 
  new PVector(3*tileSize, 19*tileSize), 
  new PVector(3*tileSize, 10*tileSize), 
  new PVector(3*tileSize, 22*tileSize)
};

Zombie selectedZombie = null;
Defender selectedDefender = null;

int w = grid.length * tileSize;
int h = grid[0].length * tileSize;

void settings() {

  size(w, h);
}

void setup() {
  background(0);
  for (int y = (height/tileSize)/2 - pathWidth/2; y < (height/tileSize)/2 + pathWidth/2; y++) {
    for (int x = 0; x < grid[y].length; x++) {
      grid[x][y] = color(255);
    }
  }
  for (int y = 0; y < grid[barricadeX / tileSize].length; y++) {
    grid[barricadeX / tileSize][y] = color(#9B6E37);
  }
  defenders.add(new Defender(tileSize, 
    (int)defenderPositions[0].x, 
    (int)defenderPositions[0].y, 
    2, 
    1));
  defenders.add(new Defender(tileSize, 
    (int)defenderPositions[1].x, 
    (int)defenderPositions[1].y, 
    3, 
    1));
  defenders.add(new Defender(tileSize, 
    (int)defenderPositions[2].x, 
    (int)defenderPositions[2].y, 
    2, 
    1));
  defenders.add(new Defender(tileSize, 
    (int)defenderPositions[3].x, 
    (int)defenderPositions[3].y, 
    3, 
    1));
}

void draw() { 
  if (enemyCount > 0 && random(1) > 0.9 ) {
    enemyCount--;
    zombies.add(new Zombie(tileSize, 
      (int)(w + random(100)), 
      (14+(int)random(5))*tileSize, 
      0, 
      100 + (int)random(1000), 
      1));
  }
  stroke(0);
  for (int x = 0; x < grid.length; x++) {
    for (int y = 0; y < grid[x].length; y++) {
      fill(grid[x][y]);
      stroke(0);
      rect(x*tileSize, y*tileSize, tileSize, tileSize);
    }
  }
  fill(#FFFFFF);
  text(barrierLP, 20, 20);
  for (Zombie zombie : zombies) {
    if (zombie.getX() > barricadeX + tileSize) {
      zombie.move(-1, 0);
    } else {
      if ((barrierLP -= zombie.damage) <= 0) {
        barrierLP = 0;
        noLoop();
      }
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
