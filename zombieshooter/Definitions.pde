int coins = 100;
int round = 0;

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

color grid[][];
int tileSize = 32;
int barricadeX = tileSize * 5;
int pathWidth = 8; // in tiles

int enemyCount = 0;
int maxEnemies = 0;
