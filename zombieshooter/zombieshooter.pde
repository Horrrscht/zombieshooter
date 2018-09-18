color grid[][];// = new color[32][32];
int tileSize = 32;
int barricadeX = tileSize * 5;
int pathWidth = 8; // in tiles

int enemyCount = 10;

final int betweenRounds = 1;
final int fighting = 2;
final int menu = 3;
final int upgradeMenu = 4;
int state = betweenRounds; 

ArrayList<Zombie> zombies = new ArrayList();
ArrayList<Defender> defenders = new ArrayList();

int barrierLP = 9999999;

PVector defenderPositions[] = new PVector[6];

Defender usedDefenderPositions[] = new Defender[defenderPositions.length]; 

Zombie selectedZombie = null;
Defender selectedDefender = null;

/*
void settings() {
 //size(w, h);
 }
 */
void setup() {
  size(1024, 512);
  grid = new color[width/tileSize][height/tileSize];
  defenderPositions[0] = new PVector(3*tileSize, (grid[0].length/2+1)*tileSize);
  defenderPositions[1] = new PVector(3*tileSize, (grid[0].length/2-1)*tileSize);
  defenderPositions[2] = new PVector(3*tileSize, (grid[0].length/2+2)*tileSize);
  defenderPositions[3] = new PVector(3*tileSize, (grid[0].length/2-2)*tileSize);
  defenderPositions[4] = new PVector(3*tileSize, (grid[0].length/2+3)*tileSize);
  defenderPositions[5] = new PVector(3*tileSize, (grid[0].length/2-3)*tileSize);
  background(0);
  for (int x = 0; x < grid.length; x++) {
    for (int y = 0; y < grid[x].length; y++) {
      grid[x][y] = color(0);
    }
  }
  for (int y = (height/tileSize)/2 - pathWidth/2; y < (height/tileSize)/2 + pathWidth/2; y++) {
    for (int x = 0; x < grid.length; x++) {
      grid[x][y] = color(#FFFFFF);
    }
  }
  for (int y = 0; y < grid[barricadeX / tileSize].length; y++) {
    grid[barricadeX / tileSize][y] = color(#9B6E37);
  }
  spawnRandomDefender();
  //sprepareFight(10);
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
    break;
  case fighting:
    spawnZombie();
    drawGrid();
    moveZombies();
    renderDefenders();
    defenderAction();
    if (zombies.size() == 0 && enemyCount == 0) {
      //state = betweenRounds;
      prepareBetweenRounds();
    }
    break;
  case upgradeMenu:
    drawGrid();
    renderDefenders();
    fill(255);
    rect(300, 300, 100, 100);
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
      //state = fighting;
      prepareFight(10);
    } else if (mouseInRect(100, 0, 100, 100)) {
      spawnRandomDefender();
    } else {
      Defender newSelected = defenderSelection();
      if (newSelected != null) {
        prepareUpgradeMenu(newSelected);
      }
    }
    break;
  case fighting:
    defenderSelection();
    zombieSelection();
    break;
  case upgradeMenu:
    if (mouseInRect(300, 300, 100, 100)) {
      selectedDefender.upgradeDamage(10);
    } else {
      prepareBetweenRounds();
    }
    break;
  default:
    break;
  }
}

void keyPressed() {
  switch (state) {
  case betweenRounds:
    if (key == 'f') {
      //state = fighting;
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
      int((width + random(100))), 
      ((height/tileSize)/2 - pathWidth/2+int(random(pathWidth+1)))*tileSize, 
      0, 
      100 + int(random(1000)), 
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
  return null;
}

Defender defenderSelection() {
  Defender newSelected = getSelectedDefender();
  if (newSelected == null) {
    return null;
  }
  newSelected.select();
  for (Defender defender : defenders) {
    if (newSelected.id != defender.id) {
      defender.unSelect();
    }
  }   
  selectedDefender = newSelected;
  return newSelected;
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
  return zombies.get(int(random(zombies.size())));
}

boolean mouseInRect(int x, int y, int w, int h) {
  return (mouseX >= x && mouseX <= x+w && mouseY > y && mouseY <= y+h);
}
