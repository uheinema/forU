
 import ForTex.*;

 // assumes availability of GLSL ES 310
 // data/ must contain *.glsl and *.forSH

 ForTex forTex;
 PShader shader;
 PImage tex, // these will become our procedural textures
       back;
 
 int start;
       
void setup(){
  fullScreen(P3D); 
  // create the ForSH compiler
  forTex=new ForTex(this);
  // and some procedural textures.
  // see data/init.forSH 
  tex=forTex.createImage(
    "pos?  10 / "+ // Object coordinates, scaled down
   " 1 Z "+ // setting the Z coordinate to 1 
   " | 1 % "+ // take the length mod 1.0 makes concentric rings
   " 1 swap - "+ // revert for wood effect
 //  " 0.05 0.2 smoothstep "+ // maybe half-hard edge?
   
   " 1A * "
   ); // combined with the implicit
    // plain lighted object color
    
  // for the background, just use uv coordinates
  // and animate a given image

  String url="logo.png";
  //url = "https://processing.org/img/processing-web.png"; 
  //url= "https://www.spektrum.de/lexika/images/bio/f8f6158.jpg";;
  // Load image from a web server 
  back = loadImage(url); 
  forTex.applyTo(back,
   ": ts? millis? 10000 /  ; : cent? uv? 0.5 + ; "+
   "test2 // ts? dup * ts? 5 / + cent? * fbm uv? + cos1 3 * tex 1A*");
 // forTex.applyTo(back,
 //  "uv? dup millis? 10000 / "+
  // " dup sin * * fbm  + 1% tex 1A*");
  
  
  shader=forTex.createShader(); 
  g.shader(shader);
  // that's it..use like any other image (eg. as a texture)
  // for everything else, this shader is
  // like the default one
  start=millis();
  ForTex.set(back,ForTex.SCALE,10.0f); // note this overlayed
  ForText.set(back,ForTex.COLOR,color(200,40,40));
 
}


void draw(){
  
  shader.set("millis",(float)(millis()-start));
 
  lights();
  camera();
  

  fill(250,150,100); // parchment color
  g.image(back,0,0,width,height);
  
  fill(255);
  textAlign(LEFT,TOP);
  textSize(64);
  text(
  "\nfps:"+nf(frameRate,2,2),50,50);
  translate(width/2,3*height/5,width/2);  
  scene();
  g.flush();
  scenerot.x+=1;
  scenerot.y+=0.14;
}


PVector scenerot=new PVector(20,10);

void scene(){
 
  // manipulating world coordinates does not change texture
  // 
  scale(cos(millis()*0.001)*0.1+0.8);
  rotateX(radians(scenerot.x));//
  rotateY(radians(scenerot.y));  

  // 3D textured box
  pushMatrix();
   fill(255,200,120);
  // translate(1,200,0);
   PShape s=createShape(BOX,400,200,600);
   s.rotateX(0.051); s.rotateY(0.1);
   s.setTexture(tex);
   shape(s);
  popMatrix();
} 
