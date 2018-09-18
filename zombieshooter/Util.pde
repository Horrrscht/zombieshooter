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
