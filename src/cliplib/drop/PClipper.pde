


import de.lighti.clipper.* ;


// clipper uses LongPoint internally (why???)
Paths theClip=new Paths();



Paths makeTile(float dist,
  float maxx){
  Paths pa=new Paths();
  ;
  maxx+=dist;
  maxx*=k1000;
  dist*=k1000;
  pa.add(dist, dist);
  pa.add(dist, maxx);
  pa.add(maxx, maxx);
  pa.add(maxx, dist);
 // theClip=
  return inflate(pa, dist);
 // return theClip;
}

Paths inflate(Paths pa, float dist) {
  Paths of=new Paths();

  ClipperOffset co=new ClipperOffset();
  co.addPaths(pa, Clipper.JoinType.ROUND, Clipper.EndType.CLOSED_POLYGON); 
  co.execute(of, dist);
  return of;
}

Paths inflateLine(Paths pa) {
  return inflateLine(pa,5);
 }
 
Paths inflateLine(Paths pa,float rim) {
  Paths of=new Paths();

  ClipperOffset co=new ClipperOffset();
  co.addPaths(pa, Clipper.JoinType.SQUARE, Clipper.EndType.OPEN_BUTT);//CLOSED_LINE); 
  co.execute(of, rim);
  return of;
}
Paths inflateClosed(Paths pa,float rim) {
  Paths of=new Paths();

  ClipperOffset co=new ClipperOffset();
  co.addPaths(pa, Clipper.JoinType.ROUND, Clipper.EndType.CLOSED_LINE); 
  co.execute(of, rim);
  return of;
}


Paths op(Paths a, Paths b, Clipper.ClipType op) {
  Paths p=new Paths();
   
  DefaultClipper c = new DefaultClipper( Clipper.STRICTLY_SIMPLE );

  c.addPaths(a, Clipper.PolyType.SUBJECT, true);
  c.addPaths(b, Clipper.PolyType.CLIP, true);

  c.execute(op, p);// pftSubj, pftClip ))
  return p;
}

Paths union(Paths a, Paths b)
{
  return op(a, b, Clipper.ClipType.UNION);
}

Paths difference(Paths a, Paths b)
{
  return op(a, b, Clipper.ClipType.DIFFERENCE);
}

Paths intersection(Paths a, Paths b)
{
  return op(a, b, Clipper.ClipType.INTERSECTION);
}

Paths reserve(Paths inner){
  Paths old=theClip;
  // at leat the top path should be closed
  //inner.get(0).close();
  theClip=difference(theClip, inner);
  return old;
  }
  
Paths limit(Paths inner){
  Paths old=theClip;
  //inner.get(0).close();
  theClip=intersection(inner,theClip);
  return old;
}



