


/**
 *  ttf test
 * 
 */
import processing.sound.SoundFile;

import forU.Ttf.*;

import java.nio.charset.*;

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
  
PFont fontB;

Ttf.Glyph gl;
Ttf fontT;
 PShapeCreator3D extruder;

PImage img;

Scroller scroll;

void setup() 
{
  fullScreen(P3D);

  img=loadImage( "jupiter.jpg");
  logprintln("hi");
   Ttf.log=log;
   Ttf.logging=true;
  // check naive, needs overwrite FixApplet
  fontB=createFont( theFont, 100);
  textFont(fontB);
  textSize(100);
  new Ttf(this); // so we can acces the assets
  
  fontT=Ttf.createFont("test", theFont);
   // makes it the default font, too
 
  //Ttf.writeTo(this.g); // ttf no longer knows Pxxx
  Ttf.defaultDrawer(new ShapeDrawer(this.g));
  
  frameRate(11);
  // twice naive for preview
  utf(0x10001);
  println(Charset.defaultCharset().name());
  new SoundFile(this,"sound/relax.wav").play();
 segs();
  scroll= new Scroller(loadStrings("I/i.exist"),400);

  
  println("bot setup");
 }
 
 
 
 
int glc,glnr;

void draw2D() {
  pushMatrix();
  translate(100, height-450);
  stroke(0);
  fill(color(83,100));
  strokeWeight(14);
  glnr=fontT.glyphIndex(0x10082);
  gl=fontT.getGlyph(glnr);
  scale(0.6);
  gl.draw();
  
  popMatrix();
}

void drawText(){
  pushMatrix();
  translate(30, 150);
  //strokeWeight(1);
  //stroke(1);
  noStroke(); // processing always uses nostroke
  // ttf can stroke, see above
  fill(color(234, 223, 223));
  Ttf.textSize(90);
  textSize(90);
  
  String t=""+utf(0x10082)+theFont+"\nGlyph "+glnr+"/"+glc;
  fontT.text(t+" Ttf");
  text(t+" PFont", 0, 250);
  popMatrix();
}
  
void draw3D(String t){
  // lets get fancy
  pushMatrix();
  color c=color(255,255,255);
 fill(c);
 stroke(0);
 //strokeWeight(1);
   
  translate(width/2,height/2+200,-500);
 // rotateX(frameCount*0.07);
  PShapeCreator3D extruder=
    new PShapeCreator3D (g,500,100); // size,depth
  noStroke(); // try to deactivate..
  PShape s=extruder.text(t);
  
//  PShape s=getShape(null,t,1000);
  
  rotateX(0.3);
  rotateY(frameCount*0.07);
  
  translate(-s.getWidth()/2,0,0);//-500,0,0);
  scale(1);
  
  s.setTexture(img);
  s.draw(g);
  s=createShape(BOX,100,100,100);
  s.setTexture(img);
  shape(s);
  popMatrix();
 // noLoop();
}

PShape getShape(Ttf font, String t, float ts) {
  PShapeCreator sh= new PShapeCreator(g,ts);
  return sh.text(font,t);
}



void draw(){
  //  if(redraw) frameCounter++;
  // else return; 
  // this or noLoop() does background anyhow
  //background(123); //// BAD !!
  fill(123);
  scroll.draw();
  scroll.advance(10);
  lights();
  translate(0,0,-1500);
  rect(-1500, -1500, width+3000, height+3000); // good...
  translate(0,0,1500);
  
  glc=fontT.size();
  glnr=(10+frameCount)%glc;
  
  drawText();
  draw3D("@"+ utf(0x10A20));//082) );
  //\u1f4be
  //draw3D(""+second()+glnr);
  draw2D();
}


// see http://www.unicode.org/faq//utf_bom.html#utf16-3
String utf(int C){
  
  if(C<0x10000) return ""+C;
  final char HI_SURROGATE_START = 0xD800;
  
  char X = (char) (C & 0xffff); 
  int U = (C >> 16) & ((1 << 5) - 1);
  char W = (char)( U - 1); 
  final char HiSurrogate =
    (char)( HI_SURROGATE_START | (W << 6) | X >> 10);
  final char LO_SURROGATE_START = 0xDC00; 
  char LoSurrogate =(char)( (LO_SURROGATE_START | X &
      ((1 << 10) - 1)));
  println("cp"+hex(C)+": \\u"+hex(+HiSurrogate)+"\\u"+hex(LoSurrogate));
  return ""+HiSurrogate+LoSurrogate;
}


void mousePressed () {

  if (isLooping()) {  
    noLoop();
  } else
    loop();
}
