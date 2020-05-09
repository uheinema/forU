
//Shape ttfExtrude(Ttf font,int glyph){


//  gl=fontT.getGlyph(glnr);
//     scale(0.7);
//     gl.draw();


PShape ttfExtrude(Ttf font, String t, float ts) {
  PShape3DCreator sh= new PShape3DCreator(this.g,ts/2);
  renderTtf(font, sh, t, ts);
  return sh.get();
}

void renderTtf(Ttf fonttT, ShapeCreator dude, String t, float ts) {
  if (fonttT==null) fonttT=Ttf.get();
  ShapeCreator r=fonttT.writeTo(dude);
  float ots=fonttT.textSize(ts);

  fonttT.text(t);

  fonttT.textSize(ots);
  fonttT.writeTo(r);
}

public class PShapeCreator implements ShapeCreator {    
  private PShape me;
  private PGraphics g;
  boolean inshape=false, incont=false;
  public PShapeCreator(PGraphics g) {
    this.g=g;
  }
  
  PShape get() {
    if (inshape) me.endShape(CLOSE);
    inshape=false;
    return me;
  }
  public void createShape() {
     me = g.createShape();
     inshape=false;
     incont=false;
    // me.endShape();
    //  beginShape();
  };
  
 // treat subsequent shapes as contours for now
 // nobody seems to care for winding order anyhow
  public  void beginShape() { 
    // logprintln("shapebegin");
    if (inshape)
      beginContour();
    else
      me.beginShape() ;
    inshape=true;
  };
  public void vertex(float x, float y) {
    me.vertex(x, y);
  };
  public void endShape(int mode) {
     if(incont) endContour();
  };
  public void quadraticVertex (float cx, float cy, 
    float x, float y) {
    me.quadraticVertex(cx, cy, x, y);
  };
  public void curveVertex(
    float x, float y) {
    me.curveVertex(x, y);
  };
  public void beginContour() {
    me.beginContour();
    incont=true;
  };
  public void endContour() {
    me.endContour();
    incont=false;
  };
}

public class PShape3DCreator implements ShapeCreator {    
  private PShape me;
  PShape top,bot,strip;
  private PGraphics g;
  float ex;
  boolean inshape=false, incont=false;
  boolean odd=true;
  
  public PShape3DCreator(PGraphics g,float ex) {
    this.g=g;
    this.ex=ex;
  }
  
  PShape get() {
    if (inshape) 
    {
     top.endShape(CLOSE);
     bot.endShape(CLOSE);
     strip.endShape(CLOSE);
    }
    me.addChild(top);
    me.addChild(bot);
    me.addChild(strip);
  //  me.endShape();
    inshape=false;
    return me;
  }
  public void createShape() {
     me = g. createShape(GROUP);
     top= g.createShape();
     bot= g.createShape();
     strip=g.createShape();
     inshape=false;
     incont=false;
    // me.endShape();
    //  beginShape();
  };
  
 // treat subsequent shapes as contours for now
 // nobody seems to care for winding order anyhow
  public  void beginShape() { 
    // logprintln("shapebegin");
    if (inshape)
      beginContour();
    else{
      bot.beginShape() ;
      top.beginShape();
      strip.beginShape (QUAD_STRIP);
    }
    inshape=true;
  };
  public void vertex(float x, float y) {
    top.vertex(x, y,ex);
    bot.vertex(x,y,0);
    strip.vertex(x, y,odd?ex:0);
    strip.vertex(x,y,odd?0:ex);
   // odd=!odd;
  };
  public void endShape(int mode) {
     if(incont) endContour();
  };
  public void quadraticVertex (float cx, float cy, 
    float x, float y) {
    top.quadraticVertex(cx, cy,ex,  x, y, ex);
    bot.quadraticVertex(cx, cy, 0 , x, y, 0);
    float e=odd?ex:0;
    strip.quadraticVertex(cx, cy,e,  x, y, e);
    e=odd?0:ex;
    strip.quadraticVertex(cx,cy,e,  x, y, e);
    //odd=!odd
  };
  
  public void curveVertex(
    float x, float y) {
    top.curveVertex(x, y,ex);
    bot.curveVertex(x, y,0);
  };
  public void beginContour() {
    bot.beginContour();
    top.beginContour();
    incont=true;
  };
  public void endContour() {
    bot.endContour();
    top.endContour();
    incont=false;
  };
}



