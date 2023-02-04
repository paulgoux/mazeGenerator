class Grid {
  int gHeight, gWidth, tileWidth, tileHeight, rows, cols, sides,pathsRemoved;
  float x, y;
  boolean isFound, searching, completed, prelimPathComplete,pathPrepped,pathRemoved;


  color col = color(255, 0, 0);
  ArrayList<cell > cells = new ArrayList<cell > ();
  ArrayList<cell> start = new ArrayList<cell>();
  ArrayList<Boolean> startComplete = new ArrayList<Boolean>();
  ArrayList<cell> startBackup = new ArrayList<cell>();
  ArrayList<cell> pathfinder = new ArrayList<cell>();
  ArrayList<cell> startPathbackup = new ArrayList<cell>();
  ArrayList<ArrayList<cell>> startStack = new ArrayList<ArrayList<cell>>();
  ArrayList<ArrayList<cell>> pathfinderStack = new ArrayList<ArrayList<cell>>();
  ArrayList<ArrayList<cell>> startHist = new ArrayList<ArrayList<cell>>();
  ArrayList<ArrayList<cell>> pathHist = new ArrayList<ArrayList<cell>>();
  HashMap<Integer, Integer> tilesConnected = new HashMap<Integer, Integer>();
  cell pathfind, target, pathBackup;

  Grid(float x, float y, int gWidth, int gHeight, int tileWidth, int tileHeight) {
    this.sides = 4;
    this.gWidth = gWidth;
    this.gHeight = gHeight;
    this.tileWidth = tileWidth;
    this.tileHeight = tileHeight;
    cols = round(gWidth / tileWidth);
    rows = round(gHeight / tileHeight);
    init();
    //loadStart();
  };

  Grid(float x, float y, int gWidth, int gHeight, int tileWidth, int tileHeight, int sides) {
    this.sides = sides;
    this.gWidth = gWidth;
    this.gHeight = gHeight;
    this.tileWidth = tileWidth;
    this.tileHeight = tileHeight;
    cols = gWidth / tileWidth+1;
    rows = gHeight / tileHeight+1;
    init(sides);
    loadRandom(10);
  };

  void init() {
    for (int i=0; i<rows; i++) {
      for (int j=0; j<cols; j++) {
        int pos = j+i*(cols);
        cell c = new cell(pos, j, i, tileWidth, tileHeight);
        //println("gridpos", pos);
        cells.add(c);
      }
    }
    for (int i=0; i<cells.size(); i++) {
      cell c = cells.get(i);
      c.init(this);
    }
  };

  void init(int k) {
    for (int i=0; i<rows; i++) {
      for (int j=0; j<cols; j++) {
        int pos = j+i*(cols);
        cell c = new cell(pos, j, i, tileWidth, tileHeight, k);
        //println("gridpos", pos, c);
        cells.add(c);
      }
    }
    for (int i=0; i<cells.size(); i++) {
      cell c = cells.get(i);
      c.init(this);
    }
  };

  public boolean contains(final int[] array, final int key) {     
    return ArrayUtils.contains(array, key);
  };

  void loadRandom(int n) {
    int [] nn = new int[n];
    int r = -1;
    for (int i=0; i<n; i++) {

      r = floor(random(0, cells.size()));
      boolean contains = contains(nn, r);
      while (contains) {
        r = floor(random(0, cells.size()));
        println("already loaded", r);
      }

      cell cc = cells.get(r);
      //cc.col = color(255,0,0);
      cc.toggle = true;
      cc.gid = i;
      start.add(cc);
      cc.startId = r;
      cc.node = true;
      startBackup.add(cc);
      startStack.add(new ArrayList<cell>());
      startHist.add(new ArrayList<cell>());
      startComplete.add(false);
      //stacks.get(i).add(cc);
      //hists.get(i).add(cc);
      cc.visiteds = true;
      //println("toggle", cc.xpos, cc.ypos, cc.id, i,start.size());
    }
  };

  void loadStart() {
    //top right
    cell c = cells.get(0);

    ////lst
    cell c1 = cells.get(cells.size()-1);
    //top middle
    cell c3 = cells.get(rows/2);
    //top right
    cell c4 = cells.get((rows-1));

    //left middle
    //println("pw",rows,"ph",rows,cells.size(),rows+rows*rows);
    cell c2 = cells.get(rows/2*rows);
    println("left middle", c2.id);
    ////right middle
    cell c5 = cells.get(rows-1+(rows/2)*rows);
    println("right middle", c5.id);
    ////bottom left
    cell c6 = cells.get((rows-1)*rows);
    //bottom middle
    cell c7 = cells.get(((rows-1)/2)+((rows-1))*rows);

    c.opposite = c1;
    c.pcol = color(random(255), random(255), random(255));
    c1.opposite = c;
    c1.pcol = color(random(255), random(255), random(255));
    c3.opposite = c7;
    c3.pcol = color(random(255), random(255), random(255));
    c7.opposite = c3;
    c7.pcol = color(random(255), random(255), random(255));
    c4.opposite = c6;
    c4.pcol = color(random(255), random(255), random(255));
    c2.opposite = c5;
    c2.pcol = color(random(255), random(255), random(255));
    c5.opposite = c2;
    c5.pcol = color(random(255), random(255), random(255));
    c6.opposite = c4;
    c6.pcol = color(random(255), random(255), random(255));

    start.add(c);
    start.add(c1);
    start.add(c2);
    start.add(c3);
    start.add(c4);
    start.add(c5);
    start.add(c6);
    start.add(c7);


    for (int i=0; i<start.size(); i++) {
      cell cc = start.get(i);
      cc.startId = i;
      cc.node = true;
      startBackup.add(cc);
      //stack.get(i).add(cc);
      //hist.get(i).add(cc);
      cc.visiteds = true;
      println("toggle", cc.xpos, cc.ypos, cc.id, i);
    }
    println("strt size:", start.size());
  };

  void draw() {
    cell c3 = null;
    //noFill();
    //rect(x,y,cols,rows);
    //println(cells.size());
    cell n = null;
    if (cells!=null&&cells.size()>0) {
      for (int i=0; i<cells.size(); i++) {
        cell c = cells.get(i);
        //c.draw();
        boolean c1 = c.draw();
        if (c1) n = c;
        //c.draw();
      }
      float kx = 0;
      if (mouseX>width/2)kx = -90;
      if (n!=null)n.info();
      
      //else println("no such method");
    }
    if (mouseX>width/2) {
      startMaze();
      joinPaths();
    }
  }; 

  void createMaze() {
  };

  void joinPaths() {
    ArrayList<cell> myfootprint = new ArrayList<cell>();
    ArrayList<ArrayList<Integer>> cellsHist = new ArrayList<ArrayList<Integer>>();
    HashMap<Integer, ArrayList<Integer[]>> gids = new HashMap<Integer, ArrayList<Integer[]>>();
    if (prelimPathComplete&&!pathPrepped){
      for (int i=0; i<startHist.size(); i++) {
        
        cellsHist.add(new ArrayList<Integer>());
        boolean pathConnected = false;
        int score = 0;
        start.get(i).score = score;
        for (int j=0; j<startHist.get(i).size(); j++) {
          cell c = startHist.get(i).get(j);
          ArrayList<cell> c2 = c.findNeighbourHist(gids,this);
          if (c2!=null) {
            for(int k = 0;k<c2.size();k++){
              cell c1 = c2.get(k);
              c1.visitedBy.put(c.gid,true);
              Integer[] n = new Integer[2];
              n[0] = c.id;
              n[1] = c1.id;
              if(gids.get(c1.gid)==null){
                gids.put(c1.gid,new ArrayList<Integer[]>());
                
              }
              cellsHist.get(i).add(c1.gid);
              gids.get(c1.gid).add(n);
              println("add gid",c.gid,c1.gid,n[0],n[1]);
            }
          }
        }
      }
      pathPrepped = true;
    }
      
      if(pathPrepped&&!pathRemoved){
      pathsRemoved++;
      
      for (int i=0; i<startHist.size(); i++) {
        cell c = startHist.get(i).get(0);
        c.toggle = false;
        //int r = floor(random(0,cellsHist.size()));
        //int r1 = floor(random(0,cellsHist.size()));
        //while (r1==r)r1 = floor(random(0,cellsHist.size()));
        
        //for (int j=0; j<cellsHist.get(i).size(); j++) {
          //cell c = startHist.get(i).get(j);
          
          //cell c1 = cells.get(cellsHist.get(i).get(r));
          //if(
          println("prepWalls",c.gid,i);
          println("prepWalls",c.gid,gids.get(c.gid).size());
          int r = floor(random(0,gids.get(c.gid).size()));
          
          cell c1 = null;
          cell c2 = null;
          while(tilesConnected.get(cells.get(gids.get(c.gid).get(r)[1]))!=null
          &&tilesConnected.get(cells.get(gids.get(c.gid).get(r)[0]))!=null){
            r = floor(random(0,gids.get(c.gid).size()));
          }
          
            c1 = cells.get(gids.get(c.gid).get(r)[1]);
            c2 = cells.get(gids.get(c.gid).get(r)[0]);
            
            println("removeWalls",c.gid,c1.id,c2.id,r);
            
            tilesConnected.put(c1.gid,c2.gid);
            tilesConnected.put(c2.gid,c1.gid);
            removeWalls(c1,c2);
          
          
        //}
      }
      //if(pathsRemoved==2)
      pathRemoved = true;
      println("joined Paths");
      nodePaths();
      }
      
      
    
  };
  
  void nodePaths(){
    for(int i=0;i<cells.size();i++){
      //if(
      
    }
  };

  void trimStartStack(ArrayList<cell> a) {

    for (int i=a.size()-1; i>-1; i--) {
      cell next = a.get(i).findNeighbour();
      if (next==null) {
        a.remove(i);
      } else break;
    }
  };

  void trimPathStack(ArrayList<cell> a, cell b) {

    for (int i=a.size()-1; i>-1; i--) {
      cell next = a.get(i).findNeighbour();
      if (next==null&&next!=b) {
        a.remove(i);
      } else break;
    }
  };

  void startMaze() {
    if (!prelimPathComplete)
      for ( int i=start.size()-1; i>-1; i--) {
        //for ( int i=0;i<1; i++) {
        start.get(i).visited = true;
        cell next = start.get(i).findNeighbour();

        if (next!=null) {
          removeWalls(start.get(i), next);
          //next.pcol2 = color(0, 0, 0, 150);
          next.col = start.get(i).col;
          next.visited = true;
          next.gid = start.get(i).gid;
          //next.depth = start.get(i).depth;
          //start.get(i).highlight();
          //start.get(i).visited3 = false;
          startStack.get(i).add(start.get(i));
          startHist.get(i).add(start.get(i));

          start.set(i, next);
          trimStartStack(startStack.get(i));
        } else if (startStack.get(i).size()>0) {

          start.set(i, startStack.get(i).remove(startStack.get(i).size()-1));
        } else startComplete.set(i, true);
      }

    int ppccount = 0;
    if (!prelimPathComplete)
      for ( int i=startComplete.size()-1; i>-1; i--) {
        boolean b = startComplete.get(i);
        if (b)ppccount++;
      }
    if (ppccount==startComplete.size())prelimPathComplete = true;
  };


  void djikstra() {
    if (pathfind.toggle&&target!=null&&pathfinder.get(0)!=null) {
      target.visited = true;
      target.pcol2 = color(255, 0, 0);
      target.fill2();

      for ( int i=pathfinder.size()-1; i>-1; i--) {
        startPathbackup.get(0).pcol2 = color(0);
        pathfinder.get(i).pcol2 = color(0, 0, 0, 150);
        stroke(0);
        //strokeWeight(1);
        //line(pathfinder.get(i).x,pathfinder.get(i).y,target.x,target.y);
        strokeWeight(0);
        if (pathfinder.get(i)!=null&&(pathfinder.get(i).y!=target.y||pathfinder.get(i).x!=target.x)&&!completed) {
          searching = true;
          cell next = pathfinder.get(i).find(target, false);
          pathfinder.get(i).visited2 = true;

          if (next!=null) {
            next.pcol2 = color(0, 0, 0, 150);
            next.depth = pathfinder.get(i).depth;
            //pathfinder.get(i).highlight();
            pathfinder.get(i).visited3 = false;
            pathfinderStack.get(i).add(pathfinder.get(i));
            pathHist.get(i).add(pathfinder.get(i));

            pathfinder.set(i, next);
          } else if (pathfinderStack.get(i).size()>0) {

            cell next1 = pathfinder.get(i).find(target, false);
            if (next1!=null) {

              if (!pathfinder.get(i).visited3) {
                pathfinder.get(i).pcol2 = color(0, 0, 0, 150);
              } else {
                pathfinder.get(i).pcol2 = pathfinder.get(i).pcol;
              }
            } else {
              pathfinder.get(i).visited3 = true;
              pathfinder.get(i).pcol2 = color(0, 0, 0, 0);
            }

            trimPathStack(pathfinderStack.get(i), target);
            pathfinder.set(i, pathfinderStack.get(i).remove(pathfinderStack.get(i).size()-1));
          }
        } else {
          fill(255);
          text("success", 10, 10);
          searching = false;
          pathfinder.get(i).completed = true;
          completed = true;
        }
        if (pathfinder.get(i).completed) {
        }
        if (completed&&!pathfinder.get(i).completed) {
        }
      }
    }
  };
  
  void removeWalls (cell a, cell b) {
    //a.neighbours.add(b);
    //println("rpos",a.id);
    if(b.rpos.get(a.id)!=null){
    if (b.rpos.get(a.id) == 0) {
      a.walls[0] = false;
      b.walls[3] = false;
      
    } else if (b.rpos.get(a.id) == 1) {
      a.walls[1] = false;
      b.walls[4] = false;
    } else if (b.rpos.get(a.id) == 2) {
      a.walls[2] = false;
      b.walls[5] = false;
    } else if (b.rpos.get(a.id) == 3) {
      a.walls[3] = false;
      b.walls[0] = false;
    } else if (b.rpos.get(a.id) == 4) {
      a.walls[4] = false;
      b.walls[1] = false;
    } else if (b.rpos.get(a.id) == 5) {
      a.walls[5] = false;
      b.walls[2] = false;
    }}
    
    else println("rpos null",a.id,b.id);
  };
};
