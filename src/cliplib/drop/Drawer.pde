
class Drawer

{
  PathDrawer dr;
  Drawer (PathDrawer dr) {
    this.dr=dr;
  }

  void drawLine(Paths p) {
    if (debug) {
      pushStyle();
      stroke(color(4, 134, 4));
      // strokeWeight(2);
      dr.draw(p, OPEN);
      popStyle();
    }
    drawClipped(p, theClip, OPEN);
    //println("open"+OPEN);
  }

  void drawPoly(Paths p) {
    drawC(p, CLOSE);
  }

  void drawC(Paths p, int mode) {
    if (debug) {
      pushStyle();
      stroke(color(155, 155, 44));
      //strokeWeight(2);
      dr.draw(p, mode);
      popStyle();
    }
    drawClipped(p, theClip, mode);
  }
  boolean debug=false;


  void drawClipped(Paths pa, Paths clip, int mode) {
    DefaultClipper c = new DefaultClipper(
      // Clipper.REVERSE_SOLUTION
      // Clipper.STRICTLY_SIMPLE
      // +Clipper.PRESERVE_COLINEAR
      );
    //final Paths solution=new Paths();
    PolyTree pt=new PolyTree();
   //if(mode==OPEN)
       pa=inflateLine(pa); // maybe poly ned differemt inflator?

    c.addPaths(pa, Clipper.PolyType.SUBJECT, true);
    c.addPaths(clip, Clipper.PolyType.CLIP, true);


    c.execute( 
      Clipper.ClipType.INTERSECTION, 
      pt);
    // pftSubj, pftClip )){

    // its the same....
    for (PolyNode pn : pt.getAllPolys()) {
      draw(pn);
    }
    /*
    pushMatrix();
    pushStyle();
   
    translate(0, 1000);
    stroke(0);//color(45, 45, 34));
   fill(color(8, 8, 200));
    // draw(Paths.openPathsFromPolyTree(pt), OPEN);
    PolyNode pn=pt.getFirst();
    for (; null!=pn; pn=pn.getNext()) {

      draw(pn);
    };
    popMatrix();
    popStyle();
    */
  }

  void draw(PolyNode pn) {
    if (pn.isHole()) {
      noFill();
    }
    if (pn.isOpen()) {
      //   println("open ", pn.getPolygon().size());
      dr.draw(pn.getPolygon(), OPEN); // a Path
    } else {
      //?  println("closed");
      dr.draw(pn.getPolygon(), CLOSE); // a Path
    }
    for (PolyNode pc : pn.getChilds()) {
      // println("child");
      draw(pc);
    }
  }
}
