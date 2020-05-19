


/**
 *  ttf test
 * 
 */

import forU.Ttf.*;

String theFont = 

  //"fonts/CODE2001.TTF"
  //"fonts/Courier.ttf" // not for PFont
  //"fonts/SansSerif.ttf"
  //"fonts/Time_Roman.ttf"
  //"fonts/font.ttf"
 // "stencil.ttf"
  "fonts/damase_v.2.ttf"
  //
   // "fonts/Arkhip_font.ttf"

  ;
  


Ttf fontT;
 PShapeCreator3D extruder;

PImage img;

Scroller scroll;

void setup() 
{
  fullScreen(P3D);

  img=loadImage( "jupiter.jpg");
  
  new Ttf(this); // so we can acces the assets
  
  fontT=Ttf.createFont("test", theFont);
  //frameRate(11);
  scroll= new Scroller(loadStrings("I/i.exist"),400);
 }


void draw(){
  fill(12);
  scroll.draw();
  scroll.advance(1);
  lights();
  translate(0,0,-1500);
  rect(-1500, -1500, width+3000, height+3000); // good...
  translate(0,0,1500);
}

void mousePressed () {
  if (isLooping()) {  
    noLoop();
  } else
    loop();
}
