
package forU.I;

import processing.core.PVector;

// ******************* ACTOR *********
 public class DragBack extends Actor {
   Dragger d;
   public boolean locked=false;
   public DragBack(){
     super();
     autoClose=false;
     d=new Dragger(aw,ah);
     clear().add(d);
   }
   public PVector rot(){
     return Dragger.rot;
   }
   public float scale(){
     return Dragger.scale;
   }
   public boolean mousePressed(){
     if(!locked) d.mousePressed();
     return false;
   }
   
   // is this needed for updating dragger?
 //  public void draw{
     
  // }
   
 }
 

