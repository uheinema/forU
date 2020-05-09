
package forU.ClipDraw;

//import PClipper.*;
import de.lighti.clipper.*;


import processing.core.PConstants;
//
// for curve
//
import processing.core.PMatrix3D;
import processing.core.PVector;
import processing.core.PApplet;


public class ClipDrawer implements PConstants, PathDrawer

{
  
  

  boolean clipping=true;
  boolean inflating=true;
  float deltainf= 2 ;

  static 
    public
    Paths theClip;//=new Paths();
  public PathDrawer dr;

  public ClipDrawer (PathDrawer dr) {

    this.dr=dr;
    // theClip=makeTile();
  }


  static
    public Paths clip() {
    return theClip;
    /* Paths cr=new Paths();
     for (Path p : theClip)
     {
     cr.add(p);
     }
     return cr;//copy();*/
  }

  public void close() { 
    dr.close();
  };
  /*
  void draw(Paths p, int mode) {  
   for (Path so : p) {
   draw(so, mode);
   }
   }
   */
  public void drawLine(Paths p) {
    draw(p, OPEN);
  }

  public void drawPoly(Paths p) {
    draw(p, CLOSE);
  }

  public void draw(Paths p, int mode) { 
    drawC(p, theClip, mode);
  }

  public void draw(Path p, int mode) { 

    Paths pa=new Paths(1);
    pa.add(p);
    drawC(pa, theClip, mode);
  }

  private void drawC(Paths pa, Paths clip, int mode) {
    //if (pa.isEmpty()) return;
    if (clipping) {
      DefaultClipper c = new DefaultClipper(0
        //    Clipper.REVERSE_SOLUTION+
        //  +Clipper.STRICTLY_SIMPLE
        //  +Clipper.PRESERVE_COLINEAR
        );
      //final Paths solution=new Paths();
      PolyTree pt=new PolyTree();
      // if(mode!=CLOSE)
      if (inflating)
        pa=inflateLine(pa); // maybe poly ned differemt inflator?

      c.addPaths(pa, Clipper.PolyType.SUBJECT, true);
      c.addPaths(clip, Clipper.PolyType.CLIP, true);


      c.execute( 
        Clipper.ClipType.INTERSECTION, 
        pt);
      // pftSubj, pftClip )){

      // its all the same....
      for (PolyNode pn : pt.getAllPolys()) {
        drawP(pn);
      }
    } else
    {
      dr.draw(pa, mode);
    }
  }

  private void drawP(PolyNode pn) {
    // if (pn.isHole()) {
    //   noFill();
    // }

    if (pn.isOpen()) {
      //   println("open ", pn.getPolygon().size());
      dr.draw(pn.getPolygon(), OPEN); // a Path
    } else {
      //?  println("closed");
      dr.draw(pn.getPolygon(), CLOSE); // a Path
    }
    for (PolyNode pc : pn.getChilds()) {
      // println("child");
      drawP(pc);
    }
  }

  public Paths reserve(Paths inner) {
    Paths old=theClip;
    // at leat the top path should be closed
    close(inner, "res");
    theClip=difference(theClip, inner);
    return old;
  }

  public Paths limit(Paths inner) {
    Paths old=theClip;
    close(inner, "lim");
    theClip=intersection(inner, theClip);
    return old;
  }
  static
    private Paths op(Paths a, Paths b, Clipper.ClipType op) {
    Paths p=new Paths();

    DefaultClipper c = new DefaultClipper( Clipper.STRICTLY_SIMPLE );

    c.addPaths(a, Clipper.PolyType.SUBJECT, true);
    c.addPaths(b, Clipper.PolyType.CLIP, true);

    c.execute(op, p);// pftSubj, pftClip ))
    // 
    // println("empty reselt");
    return p;
  }
  static
    public Paths union(Paths a, Paths b)
  {
    return op(a, b, Clipper.ClipType.UNION);
  }
  static
    public Paths difference(Paths a, Paths b)
  {
    return op(a, b, Clipper.ClipType.DIFFERENCE);
  }
  static
    public Paths intersection(Paths a, Paths b)
  {
    return op(a, b, Clipper.ClipType.INTERSECTION);
  }

  static
    public Paths inflateRound(Paths pa, float dist) {
    Paths of=new Paths();

    ClipperOffset co=new ClipperOffset();//5, 2*k1000);
    open(pa, "iRound"); // looks like offset wants it
    co.addPaths(pa, Clipper.JoinType.ROUND, 
      Clipper.EndType.CLOSED_POLYGON); 
    co.execute(of, dist);
    // if the returned poly is NOT closed, 
    ///but to be treated like so..
    // and exists...
    close(of, "post round");

    return of;
  }

  static

    public Paths inflateMiter(Paths pa, float rim) {
    Paths of=new Paths();
    ClipperOffset co=new ClipperOffset(5, 2*k1000);
    open(pa, "miter");
    co.addPaths(pa, Clipper.JoinType.MITER, 
      Clipper.EndType.CLOSED_POLYGON); 
    co.execute(of, rim);
    close(of, "post miter");
    return of;
  }




  Paths inflateLine(Paths pa) {
    return inflateMiterLine(pa, deltainf);//k1000/10);
  }

  static
    public

    Paths inflateMiterLine(Paths pa, float rim) {
    Paths of=new Paths();

    ClipperOffset co=new ClipperOffset(2, k1000);
    co.addPaths(pa, Clipper.JoinType.MITER, 
      Clipper.EndType.OPEN_BUTT);//CLOSED_LINE); 
    co.execute(of, rim);
    close(of);
    return of;
  }
  static
    public
    Paths inflateRoundLine(Paths pa, float rim) {
    Paths of=new Paths();
    ClipperOffset co=new ClipperOffset(2, 2*k1000);
    co.addPaths(pa, Clipper.JoinType.ROUND, Clipper.EndType.OPEN_ROUND); 
    co.execute(of, rim);
    close(of);
    return of;
  }
  static
    public

    Paths inflateMiterString(Paths pa, float rim) {
    Paths of=new Paths();
    open(pa, "ms");
    ClipperOffset co=new ClipperOffset(2, k1000);
    co.addPaths(pa, Clipper.JoinType.MITER, 
      Clipper.EndType.CLOSED_LINE); 
    co.execute(of, rim);
    close(of);
    return of;
  }
  static
    public
    Paths inflateRoundString(Paths pa, float rim) {
    Paths of=new Paths();
    open(pa, "rs");
    ClipperOffset co=new ClipperOffset(2, 2*k1000);
    co.addPaths(pa, Clipper.JoinType.ROUND, Clipper.EndType.CLOSED_LINE); 
    co.execute(of, rim);
    close(of);
    return of;
  }


  static PVector get(Path pa, int i) {
    Point.LongPoint p=pa.get(i%pa.size());
    return new PVector(p.x, p.y);
  }

  public static boolean isClosed(Path p) {
    if (p.size()<3) return true;
    int s=p.size()-1;
    boolean b;
    //return ( p.get(0).x==p.get(s).x)&&
    // ( p.get(0).y==p.get(s).y);
    ;
    b=p.get(0).equals(p.get(s));
    dprintln("closed? "+b);
    return b;
  }
  static void dprintln(String s) {
    // PApplet.println(s);
  }

  public static void close(Path p, String s) {
    if (!isClosed(p)) {
      dprintln("closing path for "+s);

      p.add(p.get(0));
    }
  }
  public static void close(Paths pa) {
    close(pa, "unknown");
  }
  public static void close(Paths pa, String s) {
    // if(pa.size()>0)
    for (Path p : pa) {
      close(p, s);
    }
  }
  public static void open(Paths pa, String s) {
    for (Path p : pa) {
      open(p, s);
    }
  }

  public static void open(Path p, String s) {
    if (isClosed(p)) {
      dprintln("opening path for "+s);

      p.remove(p.size()-1);
    }
  }
  
  static void doCurveSteps(Path s,int steps,PVector c1,
         PVector p1,PVector p2, PVector c2){
     
      float delta=1.0f/steps;
      float u=0;
      for (int ii=1; ii<steps; ii++) {
        u+=delta;
        float x=curvePoint(c1.x, p1.x, p2.x, c2.x, u);
        float y=curvePoint(c1.y, p1.y, p2.y, c2.y, u);
        s.add(x, y);
      }
  }

  public static Path curve(Path p, float detail) {
    Path s=new Path();
    int i, pEnd;
    // todo: if closed, add cpts
    if (p.size()<3) return p;
    if (
      // true){
      isClosed(p)) {
      p.add(p.get(1));
      p.add(p.get(2));
      pEnd=1;
    } else {
      pEnd=p.size()-2;
    }
    if (p.size()<4) {
      return p;
    }
    ; 
    PVector p2=get(p, 2);
    for (i=1; i<p.size()-2; i++) {
      // first point is not set
      // guess length of segment
      PVector c1=get(p, i-1);
      PVector p1=get(p, i);  
      s.add(p1.x, p1.y);
      p2=get(p, i+1); 
      PVector c2=get(p, i+2);
      float guess=p1.dist(p2);
      float steps=guess/detail;
      steps=(float)(Math.ceil(steps));
      //  steps=3;
      //  if (steps<13) steps=13;
      //    if(steps>8) 
      //  steps=8;
      doCurveSteps(s,(int)steps,c1,p1,p2,c2);
      
    }
    p2=get(p, pEnd);
    s.add(p2.x, p2.y);
    // s.add(p.get(p.size()-3));
    return s;
  }

  public static
    Paths curve(Paths ps, float detail) {
    Paths s=new Paths();
    for (Path p : ps) {
      s.add(curve(p, detail));
    }
    return s;
  }
  
 
  // seperate here, so we can inflate it
  // path is in screen longints...
  // path=curve(path,20); // detail
  // stolem from processing.core.PGraphics, simplified, static
  private static PMatrix3D cb; // final,actually

  private static void
    curveInitCheck() {
    if (cb!=null) return;
    /*
   float s = curveTightness;
     curveBasisMatrix.set(
     (s-1)/2f, (s+3)/2f,  (-3-s)/2f, (1-s)/2f,
     (1-s),    (-5-s)/2f, (s+2),     (s-1)/2f,
     (s-1)/2f, 0,         (1-s)/2f,  0,
     0,        1,         0,         0);
     */    // s is 0, so..
    cb = new PMatrix3D(//);
      // cb.set(
      -0.5f, 1.5f, -1.5f, 0.5f, 
      1.0f, -2.5f, 2f, -0.5f, 
      -0.5f, 0f, 0.5f, 0, 
      0, 1, 0, 0);
  }
  //////////////////////////////////////////////////////////////

  // CATMULL-ROM CURVE


  /**
   * Get a location along a catmull-rom curve segment.
   *
   * @param t Value between zero and one for how far along the segment
   */
  static public float curvePoint(float a, float b, float c, float d, float t) {
    curveInitCheck();

    float tt = t * t;
    float ttt = t * tt;

    // not optimized (and probably need not be)
    return (a * (ttt*cb.m00 + tt*cb.m10 + t*cb.m20 + cb.m30) +
      b * (ttt*cb.m01 + tt*cb.m11 + t*cb.m21 + cb.m31) +
      c * (ttt*cb.m02 + tt*cb.m12 + t*cb.m22 + cb.m32) +
      d * (ttt*cb.m03 + tt*cb.m13 + t*cb.m23 + cb.m33));
  }

  public float quadraticPoint(float a, float b, float c, float t) {
    return bezierPoint(a, 
      a + ((b-a)*2/3.0f), 
      c + ((b-c)*2/3.0f), 
      c, 
      t);
  }
  
  public float bezierPoint(float a, float b, float c, float d, float t) {
    float t1 = t-1.0f;
    return t * ( 3*t1*(b*t1-c*t) + d*t*t ) - a*t1*t1*t1;
  }
}
