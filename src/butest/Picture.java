
package forU.I;

import processing.core.*;

public class Picture extends Button { // static display
  PImage image;
  static PImage smile=null;
  public Picture set(PImage p)
  {
     this.image=p;
     if(p!=null){
     //  w=p.width;
     
     }
     else
       this.
       image=smile();
     aspect();
     return this;
  }
  
  public PImage smile(){
    if(smile==null){
      smile=me.requestImage("smile.png");
    }
    return smile;
  }
  
  public Picture(PImage img){
    set(img);
    // if(img==null){
      w=300;
      aspect();
   // }
  }
  
  public boolean mousePressed(){
    if(image==null) return false;
    
    int minw=PApplet.min(800,image.width);
    if(w!=300) 
      minw=300;
    w=minw;
    aspect();
    return true;
  }
  
  void aspect(){
    if(image==null||image.width<=0) return;
   setSize(w,w*image.height/image.width);        
  }
  
  public void draw(){
    g.fill(200);
    aspect();
    if(image!=null&&image.width>0)
      g.image(image,x,y,w,h);
    else
      g.image(smile(),x,y,w,h);
    // this is drawn as a textured rect!
  }
} // Picture
