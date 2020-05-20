
/**
 *  ttf test 2
 * 
*/

import forU.Ttf.*;

String theFont = "damase_v.2.ttf";
  
Ttf.Glyph gl;
Ttf fontT;
 
void setup() 
{
  fullScreen(P3D);
  new Ttf(this); // so we can acces the assets
  fontT=Ttf.createFont("test", theFont);  
  //frameRate(6);
 }
 
int glc,glnr;

void draw() {
  //background(70); // noo good with noLoop()
  fill(70);
  translate(0,0,-1500);
  rect(-1500, -1500, width+3000, height+3000); // good...
  translate(0,0,1500);
  glc=fontT.size();
  glnr=(10+frameCount)%glc;
  Ttf.textSize(80);
  noStroke();
  fill(255);
  Ttf.text("Font "+theFont+"\nGlyph "+glnr+" of "+glc,
    50,100);   
  translate(100, height-450);
  stroke(0);
  fill(color(183,200));
  strokeWeight(14);
  //glnr=fontT.getGlyphIndex(glnr);//0x10082);
  gl=fontT.getGlyph(glnr);
  scale(1f*width/fontT.unitsPerEm);
  gl.draw();
}




  



void mousePressed () {

  if (isLooping()) {  
    noLoop();
  } else
    loop();
}
