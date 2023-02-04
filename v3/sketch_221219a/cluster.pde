//fill_neighbour_cluster(){
//    var neighbour = nthPass2();

//    if(neighbour){
//      for(int i=0;i<neighbour.length;i++){
//          cluster_neighbour[i] = neighbour[i];
//        }
//      for(int i=0;i<neighbour.length;i++){
//        var c = neighbour[i];
//        if(isNaN(c)){
//          if(c.id!=id){
//      var a = neighbour_cluster.includes(c.id,0);
//      var b = c.neighbour_cluster.includes(id,0);
//      var d = neighbour_cluster2.includes(c.id,0);
//      var e = c.neighbour_cluster2.includes(id,0);

//        if(!a){
//              neighbour_cluster.push(c.id);
//              neighbouringCluster(this);
//            }
//            if(!b){
//              c.neighbour_cluster.push(id);
//              neighbouringCluster(c);
//            }
//            if(!d){
//                  neighbour_cluster2.push(c.id);
//                }
//                if(!e){
//                  c.neighbour_cluster2.push(id);
//                }}}
//              else{
//                var a = neighbour_cluster2.includes(c,0);
//                var b = neighbour_cluster.includes(c,0);
//                  if(!a){
//                        neighbour_cluster2.push(c);
//                      }
//                      if(!b){
//                            neighbour_cluster.push(c);
//                          }
//                    }}}
//  };

//  neighbouringCluster(a){
//    for(int i=0;i<grid.length;i++){
//      if(grid.get(i).id==a.id){
//        grid.get(i).neighbour_cluster = a.neighbour_cluster;
//        grid.get(i).score2 = a.score2;
//      }
//    }
//  }
