class pathfinder{
  int xpos,ypos;
  float x,y;
  boolean isAlive,h;
  cell c,target;
  color col = color(random(0,255),random(0,255),random(0,255));
  
  ArrayList<cell > hist = new ArrayList<cell > ();
  ArrayList<cell > stack = new ArrayList<cell > ();
  ArrayList<cell > histB = new ArrayList<cell > ();
  ArrayList<cell > stackB = new ArrayList<cell > ();
  ArrayList<cell > body = new ArrayList<cell > ();
  pathfinder(int x, int y){
    
  };
  
  void slide(){
    
  };
  
  void draw(){
    for(int i=0;i<body.size();i++){
      cell c = body.get(i);
      c.hover();
    }
  };
  
  void move(){
    if(keyPressed&&key==LEFT){
      //c.getNext();
    }
    if(keyPressed&&key==RIGHT){
      
    }
    if(keyPressed&&key==DOWN){
      
    }
    if(keyPressed&&key==UP){
      
    }
  };
  
  
};
