
package forU.I;


import processing.core.PApplet;
import processing.core.*;

import java.lang.reflect.*;
import java.util.List;

import android.content.Context;

public class Button extends Action//
  implements Interact, PConstants
{

  final int framed =1;

  public int backcolor= defaultBackcolor;
  public int smarkcol=defaultSmarkcol;
  public int textcolor = defaultTextcolor;

  public int sbackcol= 0xff505059;
  public int boncol= 0xff990099;
  public int boffcol=0xff000000;
  public int dragcol=0xff695858;
  
  public int w, h, tw;
  
  public int fx, fy; // fixed position
  public int x, y;

  boolean small;
  public boolean state;  // lifted from switch

  boolean dragging;
  PImage tex;

  public boolean unitsquare=false;

  public boolean mouseInside(int tx, int ty, int w, int h) {
    int mx=me.mouseX;
    int my=me.mouseY;
    return (mx>tx&&mx<tx+w&&my>ty&&my<ty+h);
  }

  public boolean mouseInside() {
    return mouseInside(x, y, eff_w(), h);
  }
  
  public Button setPos(int _x, int _y) {
    x=_x; 
    y=_y;
    return this;
  }
  

  public Button() {
    this("", null);
  }

  public Button(String text, String action, int param) {
    super(text, action, param);
    tw=ts; //??? was -ts
    // tw=ts;
    if (text!=null&&g!=null) {
      g.textSize(ts);
      tw=(int)g.textWidth(txt);
    }
    w=tw+ts;
    // small=false;
    h=ts+ts/2;
    dragging=false;
    fx=fy=-1;// free floating

    // println("w="+w);
  }

  public Button(String text, String action) {
    this(text, action, 0);
  }
  
  public Button(String text) {
    this(text, null, 0);
  }
  
  public Button (String _name, String _a, Object _owner) {
    this(_name, _a);
    bind(_owner);
  }

  //  public Button setSmall(boolean to) {
  //    if (small==to) return this;
  //    small=to;
  //    if (small) w-=ts; 
  //    else w+=ts;
  //    return this;
  //  };

  public Button setTexture(PImage _tex) {
    tex=_tex;
    backcolor=0xffffffff;
    return this;
  }

  public Button setMaterial(PImage _tex) {
    tex=_tex;
    backcolor=0xffffffff;
    unitsquare=true;
    return this;
  }

  public Button setSize(int _w, int _h) {
    if (_w>0) w=_w;
    if (_h>0) h=_h;
    return this;
  }

  public boolean fullscreen() {
    return false;
  }// Interact must implement..no longer

  public void drag() {
  };
  // override in subclasses who need it

  public int eff_w() {
    return w+ts/2;
  }

  void release() {
    dragging=false;
    if (mouseInside()) act();
  }


  public void draw() {
    drawBack();
    drawFront();
  }

  public void drawBack() {

    // println("draw(x,y)");
    if (dragging) {
      if (me.mousePressed)
        drag();  
      else {
        release();
        dragging=false; // bsts
      }
    }

    g.pushStyle();
    if (dragging) 
      g.fill((backcolor|0xff70ff70)&0xfff0fff0);

    else
      g.fill(backcolor);



    // the outline gets drawn at an offset....shaders?
    //  
    if (framed!=0&&mouseInside()&&dragging) {

      g.strokeWeight(3);
      g.stroke(0xff701111);
    } else
      g.noStroke();

    g.rectMode(CORNER); 
    g.rect(x, y, w, h);
    //Rect(tex, x, y, w, h, unitsquare);
    g.popStyle();
  }

  public void  drawFront() {
    int ts2=ts/2;
    if (//tw>0&&
      txt!=null) {
      prepTextStyle();   
      g.text(displayText(), x+ts/2, y+h/2-ts2/6);
    }
  }

  public void prepTextStyle() {
    g.textSize(ts);
    g.fill(textcolor);//,200);
    g.textAlign(LEFT, CENTER);
  }

  public String displayText() {
    return (txt==null)?"":txt;
  }

  public boolean mousePressed() {
    dragging=true;
    return true;
    //return act();
  }

  public void Rect(
    PImage tex, 
    float x, float y, float w, float h, 
    boolean unitsquare) {

    if (tex!=null)
    {
      PShape r;
      g.pushMatrix();
      if (unitsquare)
      {

        r=g.createShape(RECT, 0, 0, 2, 2);
        // why animate z?
        r.translate(-1f, -1f, 100);// me.frameCount*0.02f);
        // g.scale(w,h);
        g.translate(x+w/2, y+h/2);

        g.scale(w/2, h/2, 1);
      } else
        r=g.createShape(RECT, x, y, w, h);

      if (tex!=null) r.setTexture(tex);
      //translate(0,0,-1);
      r.draw(g);

      g.popMatrix();
    } else
      g.rect(x, y, w, h);
  }

  public void Rect(float x, float y, float w, float h) {
    Rect(x, y, w, h, true);
  }

  public void Rect(float x, float y, float w, float h, boolean b) {
    Rect(null, x, y, w, h, b);
  }
} // class button
