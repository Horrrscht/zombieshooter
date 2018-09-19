
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

color grid[][];// = new color[32][32];
int tileSize = 32;
int barricadeX = tileSize * 5;
int pathWidth = 8; // in tiles

int enemyCount = 10;

void prepareFight(int enemies) {
  enemyCount = enemies;
  state = fighting;
}

void prepareBetweenRounds() {
 state = betweenRounds; 
}

void prepareUpgradeMenu(Defender selected) {
  selectedDefender = selected;
  state = upgradeMenu;
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
