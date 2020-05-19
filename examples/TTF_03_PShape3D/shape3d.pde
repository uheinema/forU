


/**
 *  ttf test shape3D
 * 
 */


import forU.Ttf.*;

String theFont = "Arkhip_font.ttf" ;


Ttf fontT;
PShapeCreator3D extruder;

PImage jupiter; // as texture

void setup() 
{
  fullScreen(P3D);
 // size(600,600,P3D);

  jupiter=loadImage( "jupiter.jpg");

  new Ttf(this); // so we can acces the assets

  fontT=Ttf.createFont("test", theFont);
  // makes it the default font, too;
}

void draw3D() {
  // lets get fancy
  pushMatrix();
  
  fill(255);
  noStroke();

  translate(width/2, height/2+200, -500);

  PShapeCreator3D extruder=
    new PShapeCreator3D (g, 500, 100); // size,depth
  PShape hello=extruder.text("Hello"
    //+"\n "+frameCount
    );
  hello.translate(-hello.getWidth()/2, 0, 0);
  PShape world=extruder.text("World");
  world.translate(-world.getWidth()/2, 0, 0);
  world.rotateY(PI);
  world.setTexture(jupiter);

  rotateX(0.3);
  rotateY(frameCount*0.07);

  hello.draw(g);
  world.draw(g);

  popMatrix();
}




void draw() {
  fill(123);

  lights();
  translate(0, 0, -1500);
  rect(-1500, -1500, width+3000, height+3000); // good...
  translate(0, 0, 1500);

  draw3D();
}



void mousePressed () {

  if (isLooping()) {  
    noLoop();
  } else
    loop();
}
