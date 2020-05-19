


/**
 *  ttf test
 * 
 */


import forU.Ttf.*;


String theFont = "stencil.ttf";
 
Ttf fontT;

void setup() 
{
  fullScreen(P3D);
  new Ttf(this); // so we can acces the assets
  fontT=Ttf.createFont("test", theFont);
   // makes it the default font, too
 }

void draw(){
  background(123); //// BAD !!
  stroke(0);
  strokeWeight(6);
  fill(255);
  Ttf.textSize(300);
  Ttf.text("Hello\nTTF!\n"+theFont,
    50,height/3);
}
