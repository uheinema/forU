/*

void scenetest(){
  
  Paths pa=new Paths();
  Paths pb=new Paths();

  //flush();
  fill(200, 200);
  
  
  
  //c = new DefaultClipper( Clipper.STRICTLY_SIMPLE );
  pa.add(100, 100);
  pa.add(500, 110);
  pa.add(760, 600).add(800, 1800);
  pa.add(200, 750);
  pa.add(100, 100);

  pb.add(50, 200).add(700, 230);
  pb.add(50, 500).add(50, 200);


  Paths inner = difference
  (pa, pb);
  inner=inflate(inner,25);
  
  stroke(color(234, 6, 6,50));
  strokeWeight(4);
  noFill();
  drawPoly(inner);//, CLOSE);
 
  Paths oldClip=reserve(inflate(inner,20));
  noFill();
   draw(theClip,CLOSE);
  //drawC(pa);
  //translate(100, 109);
  fill(color(4, 6, 234, 200));
  stroke(0);
  strokeWeight(3);
  // draw(solution);
  //PolyTree solution = new PolyTree();  
  //co.Clear();
  // co.addPaths(solution.getAllPaths(), 
  ClipperOffset co=new ClipperOffset();
  co.addPaths(pb, //inner,
    Clipper.JoinType.MITER, Clipper.EndType.CLOSED_POLYGON);

  noFill();
  for (int i=-10; i<300; i+=35) {
    Paths of=new Paths();
    co.execute(of, i);

    drawPoly(of);
   // reserve(inflate(of,17));
  }
  theClip=oldClip; // or tile..1
  limit(inflate(inner,-30));
  for(int i=0;i<100;i++)
  {
    randomline(i);
  }
  
}

void randomline(int i) {
  Paths pa=new Paths();
  
  {
    pa.add(noise(frameCount,i)*1000, noise(frameCount+1,i)*1000);
    pa.add(random(1000), random(1000));
  }
  drawLine(pa);
  reserve(inflateLine(pa));
}

enum EndType {
  CLOSED_POLYGON, CLOSED_LINE, OPEN_BUTT, OPEN_SQUARE, OPEN_ROUND
}

enum JoinType {
  SQUARE, ROUND, MITER
}
*/