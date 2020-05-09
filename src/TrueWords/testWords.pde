


/**
 *  ttf test
 * 
 */
import processing.sound.SoundFile;

import forU.Ttf.*;

String fontdir="";
;
String theFont = 

  "Time_Roman.ttf"
  //"SansSerif.ttf"
 // "JakobsHandwriting.ttf"
  // "Arkhip_font.ttf"

  ;
PFont fontB;
Ttf.Glyph gl;
Ttf fontT;




void setup() 
{
  fullScreen(P3D);

  
  //copyAssets("pre.gcode"); // copy known&existing file from data, works in preview
  // as preview can't handle asset subdirs by default
 
 //sex();// trigger explicit permission
   
 // copyAssets(""); // fine, but copys spyware junk
  // try it or
 // 
  // for(String s:listAssets("")){ println("asset: "+s); };
   // you will be surprised
   
  fontdir="fonts/";
  if (isReallyPreview())
  {
    fontdir=solo("fonts/");
    // in local storage already, use them
    // memmapped
    // 
    //sketchPath("")+"/"+"fonts" +"/";
  
  } else {
    // can i memmap assets?
    // copuing to local instead of sd would do
    // or have sex...
    copyAssets(solo(),"fonts", CHECK); 
    // all from data/fonts, will not work for preview..
    // ..but has already happened.
    fontdir=solo("fonts/");
  }
  // check naive, needs overwrite
  fontB=createFont(
     "fonts/"+theFont,  100);
  textFont(fontB);
  textSize(100);
  
   //Ttf.log=log;
  fontT= Ttf.loadFont(theFont, fontdir+theFont);
  Ttf.me=this.g;

  
  frameRate(10);
  // twice naive
  //new SoundFile(this,"sound/relax.wav").play();
  println("bot setup");
  //draw();
  //noLoop();
 }
 
 


void draw() {

  //  if(redraw) frameCounter++;
  // else return; 
  // this or noLoop() does background anyhow
  background(123); //// BAD !!
  fill(123);
  lights();
  //rect(0, 0, width, height); // good...

  int glc=fontT.size();
  int glnr=(1+frameCount)%glc;

  pushMatrix();
  translate(50, height-450);
  stroke(0);
  fill(83);
  strokeWeight(14);
  gl=fontT.getGlyph(glnr);
  scale(0.7);
  gl.draw();
  popMatrix();

  pushMatrix();
  translate(30, 150);
  //strokeWeight(1);
  //stroke(1);
  noStroke(); // processing always uses nostroke
  // ttf can stroke, see above
  fill(color(234, 123, 123));
  fontT.textSize(90);
  // textFont(fontB);
  textSize(90);
  String t="Öåαω "+theFont+"\nGlyph "+glnr+"/"+glc;
  fontT.text(t+" Ttf");
  text(t+" PFont", 0, 250);
  popMatrix();
  
  // lets get fancy
 fill(255);
 stroke(0);
 strokeWeight(1);
  translate(width/2,height/2);
 // rotateX(frameCount*0.07);
  PShape s=ttfExtrude(null,"Ã",600);
  rotateY(frameCount*0.07);
  
  s.draw(g);
  //noLoop();
}



void mousePressed () {

  if (isLooping()) {  
    noLoop();
  } else
    loop();
}

