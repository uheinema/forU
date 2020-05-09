
  //   import my.PCClipper.PathDrawer;
/*
interface PathDrawer {
  void draw(Paths p, int mode);

  void draw(Path pa, int mode) ;
  void close();
}
*/
/*
 
 
 
 ;
 G1 X94.038 Y108.374 F7800.000
 G1 E2.00000 F2400.00000
 G1 F1800.000
 G1 X94.799 Y107.853 E2.08379
 
 G0 F9000 X106.500 Y114.083
 G1 F1200 X106.500 Y105.915 E12.05893
 ;LAYER:-1
 ;RAFT
 G0 F9000 X106.566 Y106.000 Z0.570
 ;TYPE:SUPPORT
 G1 F1200 X115.804 Y115.239 E12.64557
 G0 F9000 X115.527 Y116.092
 G1 F1200 X106.307 Y106.872 E13.23104
 G0 F9000 X106.093 Y107.790
 G1 F1200 X115.249 Y116.946 E13.81244
 G0 F9000 X114.696 Y117.525
 G1 F1200 X105.945 Y108.773 E14.36816
 G0 F9000 X105.877 Y109.837
 G1 F1200 X113.564 Y117.523 E14.85625
 */

class GcodeDrawer extends ShapeDrawer {
  PrintWriter out;

  int outlines = 0;


  Plop plop=new Plop();

  @Override void close() {
    super.close();
    if (out==null) return;
    plop.flush(0);
    println("G0 F7000 Z"+(zup+10) );
    println("G0 F7000 X20 Y160");
    println("M300 S440 P500");
    println("M117 Done.");
    String plopstat=plop.stats();
    println(plopstat);
    PApplet.println(plopstat);
    out.close();
    out=null;
  }
  @Override
    void draw(Path pa, int mode) {
    super.draw(pa, mode);
    if (out==null) return;
    // println("; draw");
    plop.add(pa);//,mode);
    ;
  }
  
  public void drawRaw(Paths pa,int mode){
    for(Path p:pa) drawRaw(p,mode);
  }
  public void drawRaw(Path pa,int mode){
    super.draw(pa,mode);
  }
  
GcodeDrawer () {this(null);}
  GcodeDrawer (String name) {
    super();
    open(name);
  }
  
  public void open(String name){
    if (name!=null ) {
      out= createWriter(name); // throws s party?
    }
    if (out==null) return;
    println("; created by Zendo as "+name);
    for (String l : loadStrings("pre.gcode")) {
      println(l);
    }
    penAdjust();  
    println("M117 plotting...");
  };

  void penAdjust() {
    for (int x=0; x< 80; x+=10) {
      println("G1 Z"+zup+" X"+
        (xof+x)+" Y"+(yof-5) );
      println("G1 Z"+zdown);
      println("G1 X"+
        (xof+x+3));
      println("G1 Z"+zup);
    }
    println("G4 P1000");
    println("M226"); // pause on what???
  }

  void println(String t) {

    if (out!=null) {
      outlines++;
      out.println(t);
      out.flush();
    } else 
    PApplet.println(t);
  }

  float hispeed=9000;
  float drawspeed=9000;
  float zdown=4;
  float zup=5;
  float xof=60, yof=70;

  String xy(Point.LongPoint pt) {
    float x=xof+pt.y/(10.0*k1000);
    float y=yof+pt.x/(10.0*k1000);
    return " X"+x+ " Y"+y;
  }

  class Plop {

    Path points ; // 
    Path lines ; // index into point
    //Path refcount;
    float delta=k1000;
    long lastWritten=-1; // or so
    int lim=1;

    Plop() {
      this(10000);
    };
    Plop(int _lim) {
      points = new Path();
      lines = new Path();
      // lastWritten=point(0, 0);
      lim=_lim;
    }

    int dropcnt=0;
    int addcnt=0;
    int lineident=0;
    int pointident=0;
    int shortcnt=0;


    String stats() {

      return "; Gcode written "+outlines+" lines, "+
        points.size()+
        " points, "+pointident+" dropped\n; "+
        " elements:"+addcnt+" ident "+lineident+" short:"+shortcnt;
    }




    void add(Path p) {
      int i=-1;
      long lastP=0;
      long thisP=0;
      long firstP=0;

      // PApplet.println("adding path ");
      for (Point.LongPoint po : p) {
        i++;
        if (i==0) {
          firstP=lastP=point(po.x, po.y);        
          continue;
        }
        thisP=point(po.x, po.y);
        if (lastP==thisP) {
          shortcnt++;
          continue;
        }
        // now push a line segment
        addLine(lastP, thisP);
        lastP=thisP;
      }
      if (firstP==lastP) {
        // closed, eho cares
      }
      flush(lim);
    }



    int addLine(long x, long y) {
      int i=0;
      //PApplet.println("adding line "+x+" "+y);

      for (Point.LongPoint po : lines) {
        if ((po.x==x&&po.y==y)||
          (po.x==y&&po.y==x)
          ) {
          // PApplet.println("dup");
          lineident++;
          return i;
        }
        i++;
      }
      addcnt++;
      lines.add(x, y);
      return i;
    }


    long point(float x, float y) {
      int i=0;
      for (Point.LongPoint po : points) {
        if (abs(po.x-x)<delta&&abs(po.y-y)<delta) {
          // BOX MEtric is ok here
          //  int rc=options.get(i).x;
          // options.set(i,new Point.LongPoint(rc+1,0);
          pointident++;
          return i;
        }
        i++;
      }
      points.add(x, y);
      //  options.add(1, 0);
      return i;
    }

    void flush(int limit) {
      while (lines.size()>limit) {
        flushline();
      }
    }

    void flushline() {
      int i=0;
      long neari=-1;
      float dist=k1000*k1000*1000;
      boolean swap=false;


      for (i=0; i<lines.size(); i++) {
        Point.LongPoint po = lines.get(i) ;

        if (lastWritten==-1) {
          GChop(po.x);
          GCline(po.y);
          lines.remove(0);
          return;
        }
        if (neari==-1) {
          neari=0;
          dist=disti(po.x, lastWritten);
          swap=false;
        }

        if (po.x==lastWritten) {
          //   println("connect x "+po.x+" "+po.y);
          GCline(po.y);
          lines.remove(i);
          // probably the next one just connects...alas
          return;
        }
        if (po.y==lastWritten) {
          //    println("connect y");
          GCline(po.x);
          lines.remove(i);
          return;
        }

        float d=disti(po.x, lastWritten);
        if (d<dist) {
          //   PApplet.println("from "+neari+" for "+
          //    lastWritten+" to "+i+" d="+d);

          neari=i;
          dist=d;
          swap=false;
        }
        d=disti(po.y, lastWritten);
        if (d<dist) {

          //   PApplet.println("from "+neari+" for "+
          //     lastWritten+" to "+i+" d="+d);
          neari=i;
          dist=d;
          swap=true;
        }

        // println("now "+i+" of "+lines.size());
      }
      //println("***** through, "+i);
      // 
      Point.LongPoint po=lines.get((int)neari);
      // println("; ---------nratest "+i+" "+dist);
      GChop(!swap?po.x:po.y);
      GCline(!swap?po.y:po.x);
      lines.remove(neari);
    }

    float disti(long a, long b) {
      Point.LongPoint pa, pb;
      pa=points.get((int)a);
      pb=points.get((int)b);
      //  PApplet.println("distance "+a+"?"+b);
      float fx, fy;
      fx=pa.x-pb.x;
      fy=pa.y-pb.y;

      float r=abs( fx)+abs(fy);
      //   PApplet.println(" "+fx+"?"+fy+"= "+(r));
      //  return fx*fx+fy*fy;
      return r;
    }

    void GChop(long there) {
      lastWritten=there;
      println("G1 F"+hispeed+" Z"+zup);
      println("G1 F"+hispeed+xy(points.get((int)there)));
      println("G1 Z"+zdown);
    }

    void GCline(long there) {
      //println("G1 F"+hispeed+" Z"+zup);
      lastWritten=there;
      println("G1 F"+hispeed+xy(points.get((int)there))+
        "");//  " Z"+zdown);
    }
  }




  void naivedraw(Path pa, int mode) {
    int cnt=0;
    Point.LongPoint first=pa.get(0);

    println("G1 F"+hispeed+" Z"+zup);
    for (Point.LongPoint pt : pa) {

      String t="";
      if (cnt==0) {
        first=pt;
        t="G0 F"+hispeed;
      } else if (cnt==1)
        t="G1 F"+drawspeed;
      else
        t="G1";
      t+=xy(pt);

      println(t);
      if (cnt==0) println("G0 Z"+zdown);
      // E
      cnt++;
    }
    if (mode==CLOSE) {
      println("G1"+xy(first)+" ; close "+cnt);
    }
  }
}
