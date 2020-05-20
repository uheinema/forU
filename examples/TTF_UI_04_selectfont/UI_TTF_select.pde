
/**
 *  ttf/ui test select
 * 
 */

import forU.Ttf.*;
import forU.I.*;

import java.util.Arrays;

// nb: subdirs...
String theFont ="fonts/Time_Roman.ttf";
//"fonts/damase_v.2.ttf";


Ttf.Glyph gl;
Ttf fontT, defF;

ListButton li; 

String path="fonts/"; 
String [] slist;
String filter=".ttf";

void setup() 
{
  fullScreen(P3D);
  textSize(32);
  new UI(this, 80);
  new Ttf(this); // so we can access the assets 
  defF=Ttf.createFont("test", theFont);
  fontT=defF;


  slist=listAssetsX(path, filter);
  Arrays.sort(slist); // much easier to do now
  // create ui elements only after UI is initialized!
  li=new ListButton(
    "Select font ...", // title
    "liSelect", // action
    slist, // content
    10); // number of lines
  li.collapse(true); // for now
  UI.add(li);
}

void liSelect (int row) {
  if (row>0) {
    theFont =slist[row-1];
    fontT=Ttf.createFont("test"+row, 
      path+ theFont);
  }
  li.collapse(true);
}


int glc, glnr;

void draw() {

  //background(70);
  fill(70);
  translate(0, 0, -1500);
  rect(-1500, -1500, width+3000, height+3000); // good...
  translate(0, 0, 1500);

  glc=fontT.size();
  glnr=(10+frameCount)%glc;

  noStroke();
  fill(255);
  Ttf.textSize(80);
  Ttf.textFont(defF);
  Ttf.text("Font "+theFont+"\nGlyph "+glnr+" of "+glc, 
    50, 200);
  Ttf.textFont(fontT);
  // 1ˢᵗ, 2ᶮᵈ, 3ʳᵈ, 4ᵗʰ.
  Ttf.text("The 1ˢᵗ quick grün Fox \njumps over the ½ lazy dog.", 
    50, 400);
    
  translate(100, height-450);
  stroke(0);
  fill(color(183, 200));
  strokeWeight(10);
  //glnr=fontT.getGlyphIndex(glnr);//0x10082);
  gl=fontT.getGlyph(glnr);
  scale(1000.0f/fontT.unitsPerEm);
  gl.draw();

  UI.draw();
}


void mousePressed() {
  // UI needs to know
  // with looping, 
  if (isLooping()) { 
    if (UI.mousePressed()) return ;
    noLoop();
  } else {
   // loop();
    if (UI.mousePressed()) {
     // redraw();
      //return ;
    }
    loop();
  }
  return;
}



