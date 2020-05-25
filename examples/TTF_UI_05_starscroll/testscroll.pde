


/**
 *  ttf test - starwars scroller variations
 *  also shows radiobutton/ integer Slider
 */

import forU.Ttf.*;
import forU.I.*;

String theFont[] = {
  "AbrazoScriptSSiNormal.ttf",
  "big-space.regular.otf",
  "slogan.ttf"
  //"lithograph.ttf", // caps
  //"Courier.ttf", // not for PFont
  //"fonts/SansSerif.ttf"
  //"fonts/Time_Roman.ttf"
  //"BEK.ttf",
  //"stencil.ttf"
  //"Ziggurat-HTF-Black-Italic.ttf"
  
  }
  ;


Switch nati, outline, x3D;
Slider radio;

// develpmemt artifact
Slider param;


Ttf fontT;
PFont font,fontP;

PImage stars,moon;
PShape starsphere,moonsphere; 

Scroller3D scroll;

void setup() 
{
  fullScreen(P3D);
  //noSmooth();
  textSize(64);
  new Ttf(this); // so we can acces the assets


  fontT=Ttf.createFont("test", theFont[1]);
  
  font=createFont(theFont[0], 50);
  fontP=createFont(theFont[1], 50);
  textFont(font);

  new UI(this,77);
  Button.defaultTextcolor=#765148;
  nati=new Switch("PFont", "xn#1", false);
  outline=new Switch("Outline", "xn#2", false);
  x3D=new Switch("3D", "xn#3", true);
  radio=new Slider("Radio ", "xn#0", 3f);
  radio.range(1, 3, 1); // three steps to heaven, will
  // appesr as selector
  param=new Slider("P #    ","",0.43f);
  param.range(0.0,0.5,0).logarithmic=false;;
  param.setSize(width-80,0);
  UI
    .add(nati)
    .add(outline)
    .add(x3D)
    .add(radio);
 
  // would be hidden in a final app,
  // once the right value is found
   
  UI.add(new Actor().add(param));
  
  stars=loadImage("randomsky.jpg");// "ldem_3_8bit.jpg" );
  moon=loadImage("DS_BODY.JPG"
   //"ldem_3_8bit.jpg"
   //"earth.jpg" 
   );//"jupiter.jpg");
  //frameRate(11);
  scroll= new Scroller3D(loadStrings("intro.txt"), 400);
  noStroke();
  fill(255);
  scroll.createShapes();
  
  sphereDetail(32);
  fill(color(223,200,200));
  moonsphere= createShape( SPHERE ,g.width);
  moonsphere.setTexture(moon); 
  deathmat();
  
  sphereDetail(6);
  fill(color(203,203,234));
  starsphere= createShape( SPHERE ,g.width*2.6);
  starsphere.setTexture(stars);
  
}

// tie them into a radiogroup
void xn(int which) {
  if (which==0) which=round(radio.value);
  nati.state=which==1;
  outline.state=which==2;
  x3D.state=which==3;
  // or use a small slider
  radio.value=which;
}


 color co(float r,float g, float b){
   return color(r*255,g*255,b*255);
 }
 
void Ka(float r,float g, float b){
  moonsphere. setAmbient (co(r,g,b));
}
void Kd(float r,float g, float b){
  moonsphere. setFill(co(r,g,b));
}
void Ks(float r,float g, float b){
  moonsphere. setSpecular(co(r,g,b));
}

void deathmat(){
Ka( 0.584314 ,0.584314 ,0.584314);
Kd (0.584314 ,0.584314 ,0.584314);
Ks (0.898039, 0.898039 ,0.898039);
//moonsphere. setShininess(param.value);
}

/*
setEmissive
setFill
setSpecular
setShininess
*/

void draw() {
  // to be explsined in example 23...
  ((Actor)UI.tos().last()).align(BOTTOM);
  background(0);
  pushMatrix();
  lights();
  lightFalloff (1,0.00010,0);
  pointLight (200,200,100,
   0,5000,3000);
  popMatrix();
  
  camera();

  fill(0);
  
  tint(100);
  moonsphere.rotateY(0.0005);
  moonsphere.rotateX(0.003);
  starsphere.rotateX(0.0005);
  
  //scale(bsrad. value);
  starsphere.draw(g);
  moonsphere.draw(g);
  
  if (outline.state) {
    stroke(255);
    noFill();
  } else {
    noStroke();
    fill(255);
  }
  textFont(fontP);
  scroll.draw(height/2);
  scroll.advance(1);
  textFont(font);
}

