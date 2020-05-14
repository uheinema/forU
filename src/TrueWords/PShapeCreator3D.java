/**
 * 
 * 
 * 
 */
package forU.Ttf;


import processing.core.*;
//PShape;
//mport processing.core.PGraphics;

// mport forU.Ttf.*;

public class PShapeCreator3D implements ShapeCreator, PConstants {    
  private
    PShape me;
  PShape top, bot, strip;
  boolean first=true;
  private PGraphics g;
  float ex, size;
  boolean inshape=false, incont=false;
  //boolean odd=false;
  float sx, sy;
  float lx, ly;


public PShape text( String t){
  return text(null,t);
}
  public PShape text(Ttf fonttT, String t) {
    clear();
    if (fonttT==null) fonttT=Ttf.get();
    ShapeCreator r=fonttT.writeTo(this);
    float ots=Ttf.textSize(size);
    fonttT.text(t);
    Ttf.textSize(ots);
    fonttT.writeTo(r);
    return get();
  }

  public PShapeCreator3D(PGraphics g, float s, float ex) {
    this.g=g;
    this.ex=ex;
    this.size=s;
    clear();
  }

  private void clear() {
    first=true;
    incont=false;
    inshape=false;
    top=null;
    bot=null;
    strip=null;
    me=null;
  }

  PShape get() {
    if (incont) {
      bot.endContour();
      top.endContour();
    }

    if (inshape) 
    {
      top.endShape();//CLOSE);
      bot.endShape();//CLOSE);
    }
    me.addChild(top);
    me.addChild(bot);
    endStrip(CLOSE);
    // endContour(); // closes

    me.setTextureMode(NORMAL);
    inshape=false;
    return me;
  }

  public void createShape() {
    me = g.createShape(GROUP);
    top= g.createShape();
    bot= g.createShape();

    inshape=false;
    incont=false;
  };

  // treat subsequent shapes as contours for now
  // nobody seems to care for winding order anyhow
  public  void beginShape() { 
    if (inshape)
      beginContour();
    else {
      bot.beginShape() ;
      top.beginShape();
      top.normal(0f, 0f, 1.0f);  
      bot.normal(0f, 0f, 1.0f); // why not -1?
    }
    inshape=true; // so furter beginShapes become beginContuors
  };

  public void vertex(float x, float y) {
    
    stripVertex(x, y,true);
  }




  private void stripbegin(float x, float y) {

    if (strip==null) {
      // is there s better way??
      boolean ls=g.stroke;
     // g.pushStyle();
      //if(stroke) g.noStroke();
      g.stroke=false;
      strip=g.createShape();
      g.stroke=ls;
     // g.popStyle();
      //strip.beginShape (QUAD_STRIP);
      // we mix curves and rect, and thus have
      // two normals at the same point
      strip.beginShape(QUADS);
      sx=x; // so we can close it
      sy=y;
      first=true;
    }
  }



  PVector calcNormal(
    PVector a, PVector b, PVector c)
    // //float ax, float ay, float az, 
    ///float bx, float by, float bz, 
    /// float cx, float cy, float cz)
  {
    b.sub(a);
    c.sub(a);
    return b.cross(c).normalize();
  }

  public void uvertex(PShape s, float x, float y, float z)
  {
    s.vertex(x, y, z, 
      Math.abs(x/size), Math.abs((y/size )));
  }

  private void stripVertex(float x, float y,
    boolean withCaps) {
    stripbegin(x, y);
    //println("sv::"+x+" "+y);
    // could determin normals from last vertex?
    // we seem to need at least a fake one
    if (!first) {// postponeed vertex, normals not kmown yet  

      PVector n= calcNormal(
        new PVector(lx, ly, 0), 
        new PVector(x, y, 0), 
        new PVector(x, y, ex));
      strip.normal(n.x, n.y, n.z);
      uvertex(strip, lx, ly, ex);
      uvertex(strip, lx, ly, 0);
      uvertex(strip, x, y, 0);
      uvertex(strip, x, y, ex);
      
    } else {
      
      first=false;
    }
    if(withCaps){    
    uvertex(top, x, y, ex);
    uvertex(bot, x, y, 0);
    }
    lx=x;
    ly=y;
  };

  public void endShape(int mode) {
    if (incont) endContour();
    // get should clean up if we had no contour
  };


  public void quadraticVertexTest (float cx, float cy, float x, float y) {
    //  vertex(x,y);
    top.quadraticVertex(cx, cy, ex, x, y, ex);
    bot.quadraticVertex(cx, cy, 0, x, y, 0);
    stripVertex(cx, cy,true);
    stripVertex(x, y,true);
  };


  // ttf dont has these, joy
  public void curveVertex(float x, float y) {
    top.curveVertex(x, y, ex);
    bot.curveVertex(x, y, 0);
    stripVertex(x, y,true);
  };

  public void beginContour() { 
    if (strip!=null) {
      endStrip(CLOSE);
    } 
    bot.beginContour();
    top.beginContour();
    incont=true;
  };

  public void endContour() {
    // if(!incont) return;
    if (strip!=null) {
      endStrip(CLOSE);
    } 
    bot.endContour();
    top.endContour(); 
    incont=false;
  }

  private void endStrip(int mode) {
    if (mode==CLOSE) 
      stripVertex(sx, sy,false);
    strip.endShape();
    me.addChild(strip);
    strip=null;
  };

public float deltaa = 30; // assume ttf coord,
    // typical 1000 or 2084 unitsPerEm
    // we are in the characters coord system?
    // also good for screen
  public void quadraticVertex(float cx, float cy, 
    float x, float y) {

    // guess step count...

    
    // steps should depend on target distance,
    // city block distance is good enough
    float d=Math.abs(x-lx)+Math.abs(y-ly);//last.dist(to); PVector
    int steps=6;
    steps=(int)Math.floor(d*deltaa);
    steps=PApplet.constrain(steps, 2, 8);
    //println("steps "+steps+" for "+d);
    doQuadSteps(steps, 
      lx, ly, 
      cx, cy, 
      x, y);
    stripVertex(x, y,true);
  }

  void doQuadSteps(int steps, 
    float p1x, float p1y, 
    float cx, float cy, 
    float p2x, float p2y) {

    float delta=1.0f/steps;
    float u=0;
    for (int ii=1; ii<steps; ii++) {
      u+=delta;
      float x=quadraticPoint(p1x, cx, p2x, u);
      float y=quadraticPoint(p1y, cy, p2y, u);
      stripVertex(x, y,true);
    }
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
