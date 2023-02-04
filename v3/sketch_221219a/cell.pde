class cell {
  int xpos, ypos, id, startId, sides, gid, total, depth,visitedCount,score;
  float x, y, w, h, length;
  boolean isOccupied, connected, completed, mdown, offset;
  color col = color(255, 255, 255), pcol = col, pcol2, col2;
  boolean toggle, mouseDown, visited, visited2, visited3, visiteds, node,pathComplete,totalCounted,path;
  cell opposite, target, origin;
  HashMap<Integer, Boolean> visitedBy = new HashMap<Integer, Boolean>();
  HashMap<cell, Boolean> terminatedBy = new HashMap<cell, Boolean>();
  ArrayList<Integer[]> pthInfo = new ArrayList<Integer[]>();
  ArrayList<Integer[]> nodeInfo = new ArrayList<Integer[]>();
  //HashMap<cell,Integer> parents = new HashMap<cell,Integer>();
  HashMap<Integer, Integer> parents = new HashMap<Integer, Integer>();
  HashMap<Integer, Integer> rpos = new HashMap<Integer, Integer>();
  //ArrayList<cell> children = new ArrayList<cell>();
  ArrayList<cell> neighbours = new ArrayList<cell>();
  ArrayList<cell> neighbourCells = new ArrayList<cell>();
  ArrayList<cell> nodeNeighbours = new ArrayList<cell>();
  cell[] pathNeighbours;
  cell[] neighbourWalls;
  //HashMap<cell,Integer> neighboursMp = new HashMap<cell,Integer>();
  HashMap<Integer, Integer> neighboursMp = new HashMap<Integer, Integer>();
  //HashMap<cell,Integer> children = new HashMap<cell,Integer>();
  HashMap<Integer, Integer> children = new HashMap<Integer, Integer>();
  ArrayList<cell> connectedNodes = new ArrayList<cell>();
  ArrayList<cell> imprinted_by = new ArrayList<cell>();
  ArrayList<cell> myfootprint = new ArrayList<cell>();
  HashMap<Integer, cell> best_paths = new HashMap<Integer, cell>();
  HashMap<Integer, cell> temp_paths = new HashMap<Integer, cell>();
  HashMap<Integer, cell> path_ref = new HashMap<Integer, cell>();
  cell btmL, btmR, topL, left, right, top, topR;
  float pos;
  boolean []walls, wallsBackup, walls2;
  ArrayList<PVector []> edge = new ArrayList<PVector []>();
  ArrayList<Integer[]>node_info;
  PVector []vertex;
  cell(int x, int y) {
  };

  cell(int ii, int i, int j, float tileWidth, float tileHeight) {
    this.sides = 4;
    id = ii;
    xpos = i;
    ypos = j;
    w = tileWidth;
    h = tileHeight;
    pos = pow(-1, ypos);
    //init();
  };

  cell(int ii, int i, int j, float tileWidth, float tileHeight, int sides) {
    this.sides = sides;
    id = ii;
    xpos = i;
    ypos = j;
    w = tileWidth;
    h = tileHeight;
    pos = pow(-1, ypos);
    //init();
  };

  void init(Grid g) {
    boolean k = xpos<g.cols-1&&ypos<g.rows-1&&xpos>-1&&ypos>-1&&(xpos+ypos*g.cols)<g.cells.size()-1;
    //println("poscheck ",xpos+ypos*g.cols,xpos,ypos);
    //check neighbour cells with y offset
    fillNeighbours(g);
    //if (index(xpos-1, ypos+1, g)>-1&&k)btmL = g.cells.get(index(xpos-1, ypos+1, g));
    //if (index(xpos, ypos+1, g)>-1&&k)btmR = g.cells.get(index(xpos, ypos+1, g));
    //if (index(xpos-1, ypos-1, g)>-1&&k)topL = g.cells.get(index(xpos-1, ypos-1, g));
    //if (index(xpos+1, ypos-1, g)>-1&&k)topR = g.cells.get(index(xpos+1, ypos-1, g));
    //if (index(xpos-1, ypos, g)>-1&&k)left = g.cells.get(index(xpos-1, ypos, g));
    //if (index(xpos+1, ypos, g)>-1&&k)right = g.cells.get(index(xpos+1, ypos, g));
    //xoffset = map(mouseX,0,width,0,20);
    //yoffset = map(mouseY,0,height,0,200);
    if (sides>2)
      if (pos==1) {
        x = xoffset+(xpos-0.5) *(g.tileWidth-w*sin(theta)/sides)-(0);
      } else {
        x = xoffset+(xpos) *(g.tileWidth-w*sin(theta)/sides)-(g.tileWidth-w*sin(theta)/sides)-(0);
        offset = true;
      } 
    //else x = (xpos) *g.tileWidth;

    y = yoffset+(ypos)*(h*sin(theta)-h*sin(theta)/sides);
    walls = new boolean [sides];
    walls2 = new boolean [sides];
    wallsBackup = new boolean [sides];
    node_info = new ArrayList<Integer[]>();
    vertex = new PVector [sides];
    neighbourWalls = new cell[sides];

    for (int i=0; i<sides; i++) {
      float thetab =  theta * i;
      float thetac =  theta * i+theta;

      walls[i] = true;
      walls2[i] = true;
      wallsBackup[i] = true;
      node_info.add(new Integer[3]);
      edge.add(new PVector[2]);
      //println("edge init", x, y);
      edge.get(i)[0] = new PVector(x+w/2*sin(thetab), y+h/2*cos(thetab));
      edge.get(i)[1] = new PVector(x+w/2*sin(thetac), y+h/2*cos(thetac));
      vertex[i]= new PVector(x+w/2*sin(thetac), y+(h/2)*cos(thetac));
      length = dist(x+w/2*sin(thetab), y+h/2*cos(thetab), x+w/2*sin(thetac), y+h/2*cos(thetac));
    }
    col = color(random(255), random(255), random(255));
    pcol = col;
    col2 = color(col, 100);
  };

  boolean hover() {

    int c1 = 0;
    strokeWeight(0.5);
    stroke(0);
    boolean k1 = (dist(mouseX, mouseY, x, y)<w||dist(mouseX, mouseY, x, y)<h);
    if (k1)
      for (int k=0; k<sides; k++) {

        PVector a = edge.get(k)[0];
        PVector b = edge.get(k)[1];

        if (k1) {
          float t1 = abs(atan2(mouseY - a.y, mouseX - a.x)+PI);
          float t2 = abs(atan2(mouseY - b.y, mouseX - b.x)+PI);

          if (abs(t2-t1)>=PI) {
            c1++;
          }
        }
      }
    return k1&&c1==1;
  }

  boolean draw() {
    //text(c1+","+id,mouseX,mouseY);
    boolean k1 = hover();
    noStroke();
    beginShape();

    if (k1&&mousePressed&&!mdown) {
      toggle= !toggle;
      mdown = true;
    }
    if (!mousePressed) mdown = false;
    fill(col);
    for (int k=0; k<sides; k++) {
      PVector a = edge.get(k)[0];
      PVector b = edge.get(k)[1];

      if (toggle)fill(255, 0, 0);
      if (k1)fill(0, 0, 255, 100);
      vertex(a.x, a.y);
      vertex(b.x, b.y);
    }

    endShape();
    stroke(0);
    strokeWeight(0.5);
    for (int k=0; k<sides; k++) {
      PVector a = edge.get(k)[0];
      PVector b = edge.get(k)[1];

      if (walls[k])line(a.x, a.y, b.x, b.y);
      else{
        cell c = neighbours.get(k);
        //if(c!=null)line(x,y,c.x,c.x);
      }
    }
    stroke(0);
      strokeWeight(1);
    for (int i=0; i<walls.length; i++) {
      cell c = null;
      if(i<neighbours.size())c = neighbours.get(i);

      
      int k = sides-1-(i);
      if(k<0)k = sides-1+k;
      int j = k-2;
      if(j<0)j=sides+j;
      if (c!=null) {
        //if (!visited)
          if (!walls[j]) {
            line(x, y, c.x, c.y);
            }
          }
    }
    return k1;
  };
  
  
  
  void checkNodePath(){
  }

  void info() {
    int rx = width -100;
    int ry = height - 200;
    int rw = 100;
    int rh = 200;
    int rs = 20;


    //if(hover()!=nu){
    fill(0, 100, 100, 200);
    rect(rx, ry, rw, rh);
    fill(0);
    text("xpos; "+xpos, rx+10, ry+rs); 
    text("ypos; "+ypos, rx+10, ry+rs*2); 
    text("xpos; "+xpos, rx+10, ry+rs); 
    text("xpos; "+xpos, rx+10, ry+rs); 
    text("xpos; "+xpos, rx+10, ry+rs); 
    text(" "+xpos+" , "+ypos, x, y); 
    text(id+","+neighbourCells.size(), x, y +rs); 
    stroke(0);
    strokeWeight(2);
    
  };

  void connect(ArrayList<cell> a) {

    if (total !=2&&menu.getButton(2).toggle) {
      strokeWeight(tileWidth/6+gWidth/tileWidth);
      stroke(0, 0, 0);
      point(x, y);
    }
    for (int i=0; i<a.size(); i++) {
      stroke(0);
      strokeWeight(2);
      if (paths_explored) {
        //neighbours[i] = a.get(i);
      }
      if (pathconnected==true&&menu.getButton(5).toggle) {
        stroke(255);
      }
      if (menu.getButton(2).toggle) {
        line(x, y, a.get(i).x, a.get(i).y);
      }
    }
    if (paths_explored) {
      connected = true;
    }
  };

  cell getNPathTile(pathfinder s) {
    ArrayList<cell > temp = new ArrayList<cell > ();
    for (int i=0; i< 2; i++) {
      for (int j=0; j< 2; j++) {
        if (i>=0&&i<gHeight&&j>=0&&j<gWidth) {
          cell c = grid.cells.get(i+j*gWidth);
          if (!c.isOccupied)temp.add(c);
        }
      }
    }
    if (temp.size()>0) {
      return nearest(temp, s.target);
    } else return null;
  };

  cell findNext() {
    ArrayList<cell > temp = new ArrayList<cell > ();
    for (int i=-1; i< 2; i++) {
      for (int j=-1; j< 2; j++) {
        //println("getcell",index(xpos+i,ypos+j,grid));
        int pos = index(xpos+i, ypos+j, grid);
        //if (offset&&(i>0&&i<2||i<0&&i>-2))pos = index(xpos+floor(i/2), ypos+j, grid);
        int xx = abs(xpos-(xpos+i));
        int yy = abs(ypos-(ypos+j));
        if (pos>-1) {
          //println("getcell",xpos+i,xpos,ypos+j,ypos,xx,yy,grid.cols);
          cell c = grid.cells.get(pos);
          if (!c.visited)temp.add(c);
        }
      }
    }
    if (temp.size()>0) {
      return temp.get(floor(random(temp.size())));
    } else return null;
  };

  cell nearest(ArrayList<cell> temp, cell t) {
    cell next = null;
    if (temp.size()>1) {
      cell d = temp.get(0);
      //println("tempsize",temp.size());

      ArrayList<cell> temp2 = new ArrayList<cell>();
      for (int i=1; i<temp.size(); i++) {
        cell d2 = temp.get(i);
        int d2x = abs(t.xpos-d.xpos);
        int d2y = abs(t.ypos-d.ypos);

        float k2x = d2x*d2x;
        float k2y = d2y*d2y;

        int dx = abs(t.xpos-d2.xpos);
        int dy = abs(t.ypos-d2.ypos);
        float kx = dx*dx;
        float ky = dy*dy;

        if (sqrt(k2x+k2y)>sqrt(kx+ky)) {

          d = d2;
        }
      }
      return next;
    } else return temp.get(0);
  };

  // this is a comment

  void pathfinder() {
  }

  void getNext(pathfinder s, cell t) {
  };
  
  void getScore(){
    if(pathComplete&&!totalCounted){
      for(int i=0;i<walls.length;i++){
        if(!walls[i])total++;
      }
    }
    totalCounted = true;
    if(total==2)path = true;
    else node = true;
  };
  
  ArrayList<cell> findNeighbourHist(HashMap<Integer, ArrayList<Integer[]>> gids,Grid g) {
    ArrayList<cell> temp = new ArrayList<cell>();
    
    for (int i=0; i<neighbourCells.size(); i++) {
      cell c = neighbourCells.get(i);

      if (c!=null&&c.gid!=gid&&
      g.cells.get(c.id).
      visitedBy
      .get(gid)==null)temp.add(c);
    }
    
    int n = temp.size();
    for (int i=0; i<temp.size(); i++) {
      cell c = temp.get(i);
      //c.visitedBy.put(gid,true);
    }
    if (temp.size()>0)
    return temp;
    else return null;
  };
  
  cell unlock2NeighbourHist(HashMap<Integer, ArrayList<Integer[]>> gids) {
    ArrayList<cell> temp = new ArrayList<cell>();
    
    for (int i=0; i<neighbourCells.size(); i++) {
      cell c = neighbourCells.get(i);

      if (c!=null&&c.gid!=gid&&gids.get(c.gid)==null)temp.add(c);
    }
    
    int n = temp.size();

    if (temp.size()>0)return temp.get(floor(random(0, n)));
    else return null;
  };

  cell findNeighbour() {
    ArrayList<cell> temp = new ArrayList<cell>();

    for (int i=0; i<neighbourCells.size(); i++) {
      cell c = neighbourCells.get(i);

      if (c!=null&&!c.visited)temp.add(c);
    }
    int n = temp.size();

    if (temp.size()>0)return temp.get(floor(random(0, n)));
    else return null;
  };

  void fillNeighbours(Grid grid) {
    int k = round(pow(-1, ypos));
    //println("pow", k, ypos);
    int x = xpos;
    int y = ypos;
    if (k==1)
      if (index(x, y+1, grid)>-1)btmL = grid.cells.get(index(x, y+1, grid));
    if (k==-1)
      if (index(x-1, y+1, grid)>-1)btmL = grid.cells.get(index(x-1, y+1, grid));

    if (k==1)
      if (index(x+1, y+1, grid)>-1)btmR = grid.cells.get(index(x+1, y+1, grid));

    if (k==-1)if (index(x, y+1, grid)>-1)btmR = grid.cells.get(index(x, y+1, grid));

    if (k==1)
      if (index(x, y-1, grid)>-1)topL = grid.cells.get(index(x, y-1, grid));
    if (k==-1) if (index(x-1, y-1, grid)>-1)topL = grid.cells.get(index(x-1, y-1, grid));

    if (k==1)
      if (index(x+1, y-1, grid)>-1)topR = grid.cells.get(index(x+1, y-1, grid));
    if (k==-1) 
      if (index(x, y-1, grid)>-1)topR = grid.cells.get(index(x, y-1, grid));

    if (k==1)
      if (index(x-1, y, grid)>-1)left = grid.cells.get(index(x-1, y, grid));
    if (k==-1)
      if (index(x-1, y, grid)>-1)left = grid.cells.get(index(x-1, y, grid));

    if (k==1)
      if (index(x+1, y, grid)>-1)right = grid.cells.get(index(x+1, y, grid));
    if (k==-1)
      if (index(x+1, y, grid)>-1)right = grid.cells.get(index(x+1, y, grid));

    if (topL!=null) {
      topL.rpos.put(this.id, 3);
      rpos.put(id,0);
      neighbours.add(topL);
    }else neighbours.add(null);
    if (topR!=null) {
      topR.rpos.put(this.id, 2);
      rpos.put(id,5);
      neighbours.add(topR);
    }else neighbours.add(null);
    if (right!=null) {
      right.rpos.put(this.id, 1);
      rpos.put(id,4);
      neighbours.add(right);
    }else neighbours.add(null);
    if (btmR!=null) {
      btmR.rpos.put(this.id, 0);
      rpos.put(id,3);
      neighbours.add(btmR);
    }else neighbours.add(null);
    if (btmL!=null) {
      btmL.rpos.put(this.id, 5);
      rpos.put(id,2);
      neighbours.add(btmL);
    }else neighbours.add(null);
    if (left!=null) {
      left.rpos.put(this.id, 4);
      rpos.put(id,1);
      neighbours.add(left);
    }else neighbours.add(null);
    //println("neighbours size",neighbours.size());
    for (int i=0; i<neighbours.size(); i++) {
      if (neighbours.get(i)!=null)neighbourCells.add(neighbours.get(i));
    }
  };
  boolean pos() {
    return mouseX>xpos*w&&mouseX<xpos*w+w
      &&mouseY>ypos*h&&mouseY<ypos*h+h;
  };

  boolean toggle() {
    if (pos()&&mousePressed&&!mouseDown&&mouseButton==LEFT) {
      toggle =!toggle;
      visiteds=!visiteds;
      mouseDown = true;
      //println("toggle",id);
    }
    if (!mousePressed)mouseDown = false;
    //if(visiteds)println("toggle",xpos,ypos,id);
    return toggle;
  };

  int index (int i, int j, Grid g) {
    if (i<0||i>g.cols-1||j<0||j>g.rows-1) {
      return -1;
    } else {
      return i+j*(g.cols);
    }
  };


  

  void removeWalls ( cell b) {
    //if(!b.visited)
    if (b.rpos.get(id) == 0) {
      walls[0] = false;
      b.walls[3] = false;
    } else if (b.rpos.get(id) == 1) {
      walls[1] = false;
      b.walls[4] = false;
    } else if (b.rpos.get(id) == 2) {
      walls[2] = false;
      b.walls[5] = false;
    } else if (b.rpos.get(id) == 3) {
      walls[3] = false;
      b.walls[0] = false;
    } else if (b.rpos.get(id) == 4) {
      walls[4] = false;
      b.walls[1] = false;
    } else if (b.rpos.get(id) == 5) {
      walls[5] = false;
      b.walls[2] = false;
    }
  };

  void fill2() {
  };

  cell find(cell c, boolean k) {
    return c;
  };

  void setCol(color c) {
    col = c;
    pcol = c;
  };
};
