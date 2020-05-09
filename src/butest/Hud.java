
package forU.I;

import processing.core.*;
import processing.opengl.*;

public class Hud {
  //nt ts=64;
  /////
  PShape hudrect(PGraphics g, PImage tex)
  {
    PShape s=g.createShape();
    s.setTextureMode(PConstants.NORMAL);

    s.beginShape(PConstants.QUAD);
    g.textureWrap(PConstants.REPEAT);//CLAMP no effect???
    s.width=g.width;
    s.height=g.height;
    // s.texture(tex);
    float w1=g.width;//w2=w1/2;
    float h1=g.height;//,h2=h1/2;
    int rep=1;
    s.normal(0, 0, 1);
    if (tex!=null)
      s.texture(tex);
    s.vertex(0, 0, 0, 0);
    s.vertex(w1, 0, rep, 0);
    s.vertex(w1, h1, rep, rep);
    s.vertex(0, h1, 0, rep);
    s.endShape();
    return s;
  }


  static boolean pushed_lights;

  static public void begin2D(PGraphics pg)
  {
    pg.pushStyle(); 
    pg.hint(PConstants.DISABLE_DEPTH_TEST); 
    pg.pushMatrix(); 
    pg.resetMatrix(); 
    PGraphicsOpenGL pgl = (PGraphicsOpenGL)pg; 
    pushed_lights = pgl.lights; 
    // pgl.lights = false;
    pg.lights(); // so this goes through light shaders
    // for procedural textures
    // will be sufficienly lit
    pgl.pushProjection(); 
    pgl.ortho(0, pg.width, -pg.height, 0, -Float.MAX_VALUE, +Float.MAX_VALUE);
  }

  static public void end2D(PGraphics pg)
  { 
    PGraphicsOpenGL pgl = (PGraphicsOpenGL)pg;
    pgl.popProjection();
    pgl.lights =  pushed_lights;
    pg.popMatrix();
    pg.hint(PConstants.ENABLE_DEPTH_TEST); 
    pg.popStyle();
  }
}
