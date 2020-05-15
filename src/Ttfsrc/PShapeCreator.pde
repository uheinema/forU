/***************************************************************************************
 * forU.Ttf
 * Copyright (c) 2019-2020 by the author
 * @author Ullrich Heinemann , https://github.com/uheinema
 *
 * All rights reserved. 
 * A simple, platform-agnostic library for handling TrueType fonts.
 * Released under the terms of the GPLv3, refer to: http://www.gnu.org/licenses/gpl.html
 ***************************************************************************************/
 
import forU.Ttf.*;


import processing.core.*;


public class PShapeCreator implements ShapeCreator {    
  private PShape me;
  private PGraphics g;
  float size;
  boolean inshape=false, incont=false;
  
  public PShapeCreator(PGraphics g,float s) {
    this.g=g;
    this.size=s;
  }
  
  
  PShape get() {
    if (incont) me.endContour();
    if (inshape) me.endShape(CLOSE);
    inshape=false;
    println("get");
    me.setTextureMode(NORMAL);
    return me;
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
  
  public void createShape() {
   // println("create");
     me = g.createShape();
     inshape=false;
     incont=false;
  };
  
 // treat subsequent shapes as contours for now
 // nobody seems to care for winding order anyhow
  public  void beginShape() { 
    println("beginShape");
    if (inshape)
      beginContour();
    else
      me.beginShape() ;
    inshape=true;
  };
  
  public void vertex(float x, float y) {
    println("vertex "+x+" "+y+
    " "+(x/size)+" "+(y/size)
    );
    me.normal(0f,0f,1f);
    // uv could be xy/size...
    me.vertex(x, y,0f);// uv will mot work with curves?
    
   // Math.abs(x/size),Math.abs(y/size ));
  };
  
  public void endShape(int mode) {
   // me.endShape(mode);
    println("endShape "+(mode==CLOSE?"CLOSE":"OPEN"));
    if(incont) endContour();
  };
  
  public void quadraticVertex (float cx, float cy, 
    float x, float y) {
      println("qurtex "+x+" "+y);
    me.quadraticVertex(cx, cy,0, x, y,0); 
  };
  
  public void curveVertex(
    float x, float y) {
    me.curveVertex(x, y);
  };
  
  public void beginContour() {
  // me.endShape();
    if(incont)endContour();
    println("begincont");
    me.beginContour();
    incont=true;
  };
  
  public void endContour() {
    println("endcont");
    me.endContour();
    incont=false;
  };
  
}
