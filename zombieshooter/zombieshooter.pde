color grid[][] = new color[64][32];
int tileSize = 16;
int barricadeX = tileSize * 5;
int pathWidth = 8; // in tiles

int enemyCount = 10;

enum State {
  fighting, betweenRounds, menu;
};

State state = State.betweenRounds; 

ArrayList<Zombie> zombies = new ArrayList();
ArrayList<Defender> defenders = new ArrayList();

int barrierLP = Integer.MAX_VALUE;

PVector defenderPositions[] = {
  new PVector(3*tileSize, 10*tileSize), 
  new PVector(3*tileSize, 13*tileSize), 
  new PVector(3*tileSize, 19*tileSize), 
  new PVector(3*tileSize, 22*tileSize), 
  new PVector(3*tileSize, 15*tileSize), 
  new PVector(3*tileSize, 17*tileSize) 
};

Defender usedDefenderPositions[] = new Defender[defenderPositions.length]; 

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
  spawnRandomDefender();
  spawnRandomDefender();
  spawnRandomDefender();
  spawnRandomDefender();
  prepareFight(10);
}

void prepareFight(int enemies) {
  enemyCount = enemies;
}

Defender spawnRandomDefender() {
  for (int i = 0; i < usedDefenderPositions.length; i++) {
    if (usedDefenderPositions[i] == null) {
      return spawnDefender(i);
    }
  }
  return null;
}

Defender spawnDefender(int defenderPosition) {
  Defender out = new Defender(tileSize, 
    (int)defenderPositions[defenderPosition].x, 
    (int)defenderPositions[defenderPosition].y, 
    defenderPosition, 
    1); 
  defenders.add(out);
  usedDefenderPositions[defenderPosition] = out;
  return out;
}

void draw() {
  switch (state) {
  case betweenRounds:
    drawGrid();
    renderDefenders();
    fill(100);
    rect(0, 0, 100, 100);
    fill(255);
    rect(100, 0, 100, 100);
    text("Do something", 200, 200);
    break;
  case fighting:
    spawnZombie();
    drawGrid();
    moveZombies();
    renderDefenders();
    defenderAction();
    if (zombies.size() == 0 && enemyCount == 0) {
      state = State.betweenRounds;
    }
    break;
  default:
    break;
  }
}

void mouseMoved() {
}

void mousePressed() {
  switch (state) {
  case betweenRounds:
    if (mouseInRect(0, 0, 100, 100)) {
      state = State.fighting;
      prepareFight(10);
    }
    if (mouseInRect(100, 0, 100, 100)) {
      spawnRandomDefender();
    }
    break;
  case fighting:
  default:
    break;
  }
  zombieSelection();
  defenderSelection();
}

void keyPressed() {
  switch (state) {
  case betweenRounds:
    if (key == 'f') {
      state = State.fighting;
      prepareFight(10);
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

Defender getSelectedDefender() {
  for (Defender defender : defenders) {
    if (dist(defender.getX(), defender.getY(), mouseX, mouseY) 
      <= defender.getRadius()) {
      return defender;
    }
  }
  return selectedDefender;
}

void defenderSelection() {
  Defender newSelected = getSelectedDefender();
  if (newSelected == null) {
    return;
  }
  newSelected.select();
  for (Defender defender : defenders) {
    if (newSelected.id != defender.id) {
      defender.unSelect();
    }
  }   
  selectedDefender = newSelected;
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

boolean mouseInRect(int x, int y, int w, int h) {
  return (mouseX >= x && mouseX <= x+w && mouseY > y && mouseY <= y+h);
}
