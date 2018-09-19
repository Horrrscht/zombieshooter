int coins = 100;
int round = 0;

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
  drawCoins(coins);
  drawRound(round);
  drawEnemyCount(maxEnemies);
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
      if (coins >= 100 && defenders.size() < defenderPositions.length) {
        coins -= 100;
        spawnRandomDefender();
      }
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
      if (coins >= 50) {
        coins -= 50;
        selectedDefender.upgradeDamage(2);
      }
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
