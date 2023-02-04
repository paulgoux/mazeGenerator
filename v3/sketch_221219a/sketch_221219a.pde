import java.util.Arrays;

Grid grid;
ArrayList<cell > gridB = new ArrayList<cell > ();
int gHeight = 50,gWidth = 50,tileWidth,tileHeight,sides = 6;
int total_players = 10;
float theta = 360,xoffset = 90,xpadding = 10,yoffset = 12;
Menu menu;
BMScontrols bms;
boolean nodes_array_Created,paths_explored,pathconnected;
void setup(){
  size(800,700,P2D);
  String []s1 = {"show Sliders","Show Walls","Show Paths", "Show Tiles","PathFinder DJX","Pathfinder DJXc","Pathfinder Comp"};
  //String []s2 = {"yoffset","ypadding","xOffset","xPadding"};
  bms = new BMScontrols(this,false);
  menu = new Menu(width-100,200,100,20,"tab",s1,bms);
  bms.add(menu);
  //grid = new Grid(0,0,399,399,10,10,4);
  theta = radians((360)/sides);
  
  grid = new Grid(0,0,width+70,height+220,40,40,sides);
  frameRate(60);
};

void draw(){
  background(255);
  grid.draw();
  fill(0);
  text(frameRate,30,30);
};
