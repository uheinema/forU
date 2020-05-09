

import PClipper.*;
import java.text.DecimalFormat;

  
class GcodeDrawer extends ShapeDrawer {
  PrintWriter out;
  String outname="none";
  int outlines = 0;
float delta=k1000*2;

  Plop plop=new Plop();

  @Override void close() {
    super.close();
    if (out==null) return;
    plop.flush(0);
    println("G0 F7000 Z"+(zup+10) );
    println("G1 F7000 X20 Y160");
    println("M300 S440 P500");
    println("M117 Done.");
    String plopstat=plop.stats();
    println(plopstat);
    PApplet.println(plopstat);
    out.close();
    out=null;
    toast("Saved to "+outname);
  }
  @Override
    void draw(Path pa, int mode) {
    super.draw(pa, mode);
    if (out==null) return;   
    plop.draw(pa,mode);
    ;
  }
  
  public void draw(Paths pa,int mode){
    for(Path p:pa) draw(p,mode);
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
    outname=name;
    if (out==null) return;
    println("; created by Zendo as "+name);
    for (String l : loadLocalStrings("pre.gcode")) {
      println(l);
    }
    penAdjust();  
    println("M117 plotting...");
  };

  void penAdjust() {
    for (int x=0; x<= 80; x+=10) {
      println("G1 Z"+zup+" X"+
        (xof+x)+" Y"+(yof-2) );
      println("G1 Z"+zdown);
      println("G1 X"+
        (xof+x+2));
      println("G1 Z"+zup);
    }
    println("G1 Z"+zup+5);
    println("G4 P500");
   // df2.applyLocalizedPattern("########0.00");
   // println("M226"); // pause on what???
  }

  // DecimalFormat df2 = new DecimalFormat(
   // "gg0.00" );
    
   String format(float f){return ""+( round (f*100))/100f;}
   
   //double dd = 100.2397; double dd2dec 
   // = new Double(df2.format(dd)).doubleValue(); 

  void println(String t) {

    if (out!=null) {
      outlines++;
      out.println(t);
     // out.flush();
    } else 
    PApplet.println(t);
  }

  float hispeed=6000;
  float drawspeed=4000;
  float zdown=4;
  float zlift=1;
  float zup=zdown+zlift;
  // 10 is zero to bed 0
  float xof=10+45, yof=10+30; 

  String xy(Point.LongPoint pt) {
    float x=xof+pt.y/(10.0*k1000);
    float y=yof+pt.x/(10.0*k1000);
    return " X"+format( x)+ " Y"+format(y);
  }

  class Plop {

    Path points ; // 
    Path lines ; // index into point
    //Path refcount;
    
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
    int unhop=0;


    String stats() {

      return "; Gcode written "+outlines+" lines, "+
        points.size()+
        " points, "+pointident+" dropped\n; "+
        " elements:"+addcnt+" ident "+lineident+" short:"+shortcnt+
        "\n; unhoo:"+unhop;
    }




    void draw(Path p,int mode) {
      int i=-1;
      long lastP=0;
      long thisP=0;
      long firstP=0;

   // println(";adding path "+p.size());
      for (Point.LongPoint po : p) {
        i++;
        if (i==0) {
         firstP=
          lastP=point(po.x, po.y);        
          continue;
        }
        thisP=point(po.x, po.y);
        if (lastP==thisP) {
          shortcnt++;
          continue;
        }
        // now push a line segment
        addLine(lastP,thisP);
        lastP=thisP;
      }
      if (firstP!=lastP&&mode==CLOSE) {
        addLine(lastP,firstP);
      }
      flush(lim);
    }



    int addLine(long a, long b) {
      int i=0;
      //PApplet.println("adding line "+x+" "+y);

      for (Point.LongPoint po : lines) {
        if ((po.x==a&&po.y==b)||
          (po.x==b&&po.y==a)
          ) {
          // PApplet.println("dup");
          lineident++;
          return i;
        }
        i++;
      }
      addcnt++;
    // println("; addline "+a+" "+b);
      lines.add(new Point.LongPoint(a, b));
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

    void linesremove(long i){
    //  println(";remove "+i+" of "+lines.size());
      lines.remove((int)i);
   //   println(";removed "+i+" now "+lines.size());
    }
    
    void flushline() {
      
      long neari=-1;
      float dist=k1000*k1000*1000;
      boolean swap=false;
int i;

      for ( i=0; i<lines.size(); i++) {
        Point.LongPoint po = lines.get(i) ;

        if (lastWritten==-1) {
          GChop(po.x);
          GCline(po.y);
          linesremove(0);
          
          return;
        }
        if (neari==-1) { // best initial guess
          neari=0;
          dist=disti(po.x, lastWritten);
          swap=false;
        }

        if (po.x==lastWritten) {
       //     println("; connect x "+po.x+" "+po.y);
          GCline(po.y);
          linesremove(i);
          // probably the next one just connects...alas
          return;
        }
        if (po.y==lastWritten) {
       //      println("; connect y "+po.x+" "+po.y);
          GCline(po.x);
          linesremove(i);
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
      }
   // println("; * through, "+i+ " found "+neari+", "+
   //   (swap?"":"no ")+"swap "+dist);
      // 
      
      Point.LongPoint po=lines.get((int)neari);
      GChop(!swap?po.x:po.y);
      GCline(!swap?po.y:po.x);
      linesremove(neari);
    }

    float disti(long a, long b) {
      Point.LongPoint pa, pb;
      pa=points.get((int)a);
      pb=points.get((int)b);
      //  PApplet.println("distance "+a+"?"+b);
      float fx, fy;
      fx=pa.x-pb.x;
      fy=pa.y-pb.y;

    // float r=abs( fx)+abs(fy);
      //   PApplet.println(" "+fx+"?"+fy+"= "+(r));
    //    ret
      float r=sqrt( fx*fx+fy*fy);
     return r;
    }

    void GChop(long there) {
      if(lastWritten!=-1){
        
        float dist=disti(lastWritten,there);
        if(dist<delta*4) {
          unhop++;
          println("; shorthop dist="+dist);
          // bit at least movebit..
          GCline(there);
          return;
        }
      }
      lastWritten=there;
      println("G0 F"+hispeed+" Z"+zup);
      println("G0"+ xy(points.get((int)there)));
      println("G0 F"+drawspeed+" Z"+zdown);
    }

    void GCline(long there) {
    //  println("; dist="+disti(lastWritten,there));
    
      lastWritten=there;
      println("G1"+
       //" F"+drawspeed+
      xy(points.get((int)there))
        );
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
