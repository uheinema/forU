
package forU.I;

  import processing.core.*;

public class Dragger extends Button{
  static public PVector rot=new PVector(0,0);
  static PVector vel=new PVector(0,0);
  static public float scale=1;
  
  public Dragger(){
    this("","");
  }
  public Dragger(String s,String a){
    super(s,a);
  }
  public Dragger(int _w, int _h){
    this();
    w=_w;
    h=_h; 
  }
  
  public boolean dragging;
  
  public void draw(){
    // just keep track of mouse/gesture movements
    if(!mouseInside()){
     dragging=false;
    }
    if(!dragging) return;
   // scale=Scale;// 
    rot.x -= vel.x;
    rot.y += vel.y;
  //if(!moveshape)rot.x=constrain(rot.x, -90, -1);
    vel.x *= 0.9; // damping
    vel.y *= 0.9;
  
    if (me.mousePressed) {
      vel.x += (me.mouseY - me.pmouseY) * 0.01;
      vel.y+= (me.mouseX - me.pmouseX) * 0.01;
   
    }
    else
      dragging=false;
  }
  
  public boolean mousePressed(){
    dragging=true;
    return true ;
  }
  
}
