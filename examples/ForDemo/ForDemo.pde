
 import ForTex.*;

   

 ForTex forTex;
 PShader shader;

 PImage tex, // these will become our procedural textures
       back,psyback,proimg;
       
 PShape head;
 
 int start;
       
void setup(){
  fullScreen(OPENGL);
  // create the ForSH compiler
  forTex=new ForTex(this);
  // and some textures described in ForSH
  tex=forTex.createImage(
    "pos? 0.1 * "+ // Object coordinates, scaled down
    " dup 5 * fbm + "+ // add some smooth randomness
    " 10 Z "+ // setting the Z coordinate to 1...
    " | 1 % "+ // ...and taking the length mod 1.0...
    " 1A* "); // ...creates nice concentric rings,
    // which are combined with the implicit
    // plain lighted object color
    
  // for the background, just use uv coordinates
  // and animate this (todo:move to init.forSH..))
   //forTex.compile(
   // "##uniform float millis;\n"+
   //":millis? \"millis -1 1 ; ");
  
  /* wild random psychedelic */
  psyback=forTex.createImage(
     "uv? 8 *  "+ // : cos1 PI / cos 1 + 2 / ;
     " millis? 0.00010 * + fbm "+
     " dup x "+
     " 1% blue * "+
     " swap y 4 * cos1 green * "+
     " + 1A");
  
  head=loadShape("Female.obj");
  // dumpShape(head,0);
  //println("head: "+head.width); is 0...
  head.translate(1,1,-2);
  head.rotateZ(-PI/2);
  head.rotateX(PI/2);
  head.scale(width/2.0);
 // head.setSpecular(0xffffffff);
 // head.setShininess(50);
  head.setTexture(forTex.createImage(
    "pos? 50 / fbm 5 * 1 %  * 1A"));
  //head.setTexture(tex);
  

  String url;
  //url = "https://processing.org/img/processing-web.png"; 
  url= "https://www.spektrum.de/lexika/images/bio/f8f6158.jpg";;
  // Load image from a web server 
  back = loadImage(url); 
  forTex.applyTo(back,
   "uv? dup millis? 10000 / "+
   " dup sin * * fbm  + 1% tex 1A*");
  
  
  shader=forTex.createShader(); 
  g.shader(shader);
  // that's it..use like any other image (eg. as a texture)
  // for everything else, this shader is
  // like the default one
  start=millis();
}

void dumpShape(PShape s,int d){
  
  for(int i=0;i<s.getChildCount();i++){
    dumpShape(s.getChild(i),d+1);
  }
  for(int i=0;i<s.getVertexCount();i++){
    println(""+d+": "+s.getVertexX(i));
  }
  
  
}



void draw(){
  
  shader.set("millis",(float)(millis()-start));
  mouseRotate();
 
  lights();
  camera();
  
  if(false)
    background(color(11,8,66));
  else{
    fill(250,150,100); // parchment
    g.image(back,0,0,width,height);
  }
 
  
  fill(255);
  textAlign(LEFT,TOP);
  textSize(64);
  text("Drag to rotate "+((rotateshape?"Texture":"Object")+
  "\nTap to switch fps:"+frameRate),50,50);
  translate(width/2,height/2,width/2);  
   

  scene();

}

PVector shaperot=new PVector(1,2);
PVector scenerot=new PVector(20,10);

void scene(){
 
  pointLight(200,200,200,
    width,-height,width*2);
  ambientLight(50,50,50);
    
  // manipulating world coordinates does not change texture
  scale(cos(millis()*0.001)*0.1+0.8);
  rotateX(radians(scenerot.x));//
  rotateY(radians(scenerot.y));  

  // 3D textured box
  pushMatrix();
  fill(255,200,100);
  translate(1,200,0);
  PShape s//=portal;
  =createShape(BOX,600,100,800);
  s.setTexture(tex);
  
  // the texture coordinates are in object space
  // by manipulating the shape, the position and orientation
  // can be changed
  // think of cutting a piece of wood out of a trunk
  PMatrix3D ss=new PMatrix3D();
  ss.rotateX(radians(shaperot.x));
  ss.rotateY(radians(shaperot.y));
  
  shapeShift(s,ss);
  popMatrix();
  fill(222);
  shape(head);
} 

// just like shape(s), but the internal object coordinates
// are modified by ss without changing physical
// position
void shapeShift(PShape s, PMatrix3D ss){
  pushMatrix();
  s.applyMatrix(ss);
  // unfortunately, this has also changed the 
  // world coordinates...so undo that
  ss.invert();
  applyMatrix(ss);
  shape(s);
  // and undo the shape manipulation...
  s.applyMatrix(ss);
  // and world transform 
  popMatrix();
  // inefficient, but what can you do?
  
}


boolean rotateshape=false;

float velocityX = 0;
float velocityY = 0;
int pressed=0;

 void mouseRotate(){

  PVector rot;
  
  if(rotateshape) 
    rot=shaperot ; 
  else 
    rot=scenerot;
  rot.x -= velocityX;
  rot.y += velocityY;
 
  velocityX *= 0.9;
  velocityY *= 0.9;
  
  if (mousePressed) {
    velocityX += (mouseY - pmouseY) * 0.01;
    velocityY += (mouseX - pmouseX) * 0.01;
    if(pressed==0){
      pressed=millis();
    }
  }
  else
    pressed=0;
}

void mouseReleased()
{
    if(millis()<pressed+500)
    {
      rotateshape=!rotateshape;     
      pressed=0;
    }
 }   
 
 