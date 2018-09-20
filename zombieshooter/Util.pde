

void prepareFight() {
  round += 1;
  maxEnemies = int(5 * (round * 1.1));
  enemyCount = maxEnemies;
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
      if (zombies.contains(defender.getTarget())) {
        coins += 10;
      }
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
    3); 
  defenders.add(out);
  usedDefenderPositions[defenderPosition] = out;
  return out;
}

void drawCoins(int amount) {
  fill(#F50A0A);
  text("Monies: " + amount, width - 100, 20);
}

void drawRound(int round) {
  fill(#F50A0A);
  text("Round: " + round, width - 200, 20);
}

void drawEnemyCount(int enemyCount) {
  fill(#F50A0A);
  text("Enemies: " + enemyCount, width - 300, 20);
}

int upgradeCost(Defender defender) {
  return int(pow(2, defender.getDamage()));
}

void drawUpgradeBox() {
  fill(255);
  rect(300, 300, 120, 100);
  fill(0);
  text("Upgrade for " + upgradeCost(selectedDefender), 320, 320);
}

void drawBuyTowerBox() {
  fill(255);
  rect(100, 0, 100, 100);
  fill(0);
  text("Buy new tower\nfor 100 coins", 110, 20);
}

void drawStartGameBox() {
  fill(100);
  rect(0, 0, 100, 100);
  fill(0);
  text("Start game", 10, 20);
}
