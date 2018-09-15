color grid[][] = new color[64][32];
int tileSize = 16;
int barricadeX = tileSize * 5;
int pathWidth = 8; // in tiles

int enemyCount = 100;

enum State {
  fighting, betweenRounds, menu;
};

State state = State.betweenRounds; 

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
    for (int x = 0; x < grid.length; x++) {
      grid[x][y] = color(255);
    }
  }
  for (int y = 0; y < grid[barricadeX / tileSize].length; y++) {
    grid[barricadeX / tileSize][y] = color(#9B6E37);
  }
  spawnDefender(0);
  spawnDefender(1);
  spawnDefender(2);
  spawnDefender(3);
}

Defender spawnDefender(int defenderPosition) {
  Defender out = new Defender(tileSize, 
    (int)defenderPositions[defenderPosition].x, 
    (int)defenderPositions[defenderPosition].y, 
    defenderPosition, 
    1); 
  defenders.add(out);
  return out;
}

void draw() {
  switch (state) {
  case betweenRounds:
    drawGrid();
    renderDefenders();
    text("Do something", 100, 100);
    break;
  case fighting:
    spawnZombie();
    drawGrid();
    moveZombies();
    renderDefenders();
    defenderAction();
    break;

  default:
    break;
  }
}

void mouseMoved() {
}

void mousePressed() {
  zombieSelection();
  defenderSelection();
}

void keyPressed() {
  switch (state) {
  case betweenRounds:
    if (key == 'f') {
      state = State.fighting;
    }
    break;
  case fighting:
  default:
    break;
  }
}

void renderDefenders() {
  for (Defender defender : defenders) {
    stroke(0);
    defender.render();
  }
}

void defenderAction() {
  for (Defender defender : defenders) {
    if (defender.shootTarget() <= 0) {
      zombies.remove(defender.getTarget());
      defender.assignTarget(randomZombie(zombies));
    }
  }
}

void moveZombies() {
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
}

void drawGrid() {
  stroke(0);
  for (int x = 0; x < grid.length; x++) {
    for (int y = 0; y < grid[x].length; y++) {
      fill(grid[x][y]);
      stroke(0);
      rect(x*tileSize, y*tileSize, tileSize, tileSize);
    }
  }
}

void spawnZombie() {
  if (enemyCount > 0 && random(1) > 0.9 ) {
    enemyCount--;
    zombies.add(new Zombie(tileSize, 
      (int)(w + random(100)), 
      ((height/tileSize)/2 - pathWidth/2+(int)random(pathWidth+1))*tileSize, 
      0, 
      100 + (int)random(1000), 
      1));
  }
}


void defenderSelection() {
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

void zombieSelection() {
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
}

Zombie randomZombie(ArrayList<Zombie> zombies) {
  if (zombies.size() == 0) return null; 
  return zombies.get((int)(Math.random()*zombies.size()));
}
