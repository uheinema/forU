///
///

package forU.I;

///mport ketai.ui.KetaiKeyboard;

import forU.I.Keyboard;

import java.util.*;

import processing.core.PApplet; 

public class UI extends I
// extends ArrayList<Actor>
 // implements Interact
 {
   // 
   // could be abstract, but only contains statics,
   // so why not instantiate, and allow
   // new UI()
   // instead of 
   // UI.setup()
   //
   //
   public UI(PApplet a,int ts){
     super.setup(a,ts);
   }
   
   public UI(PApplet a){
     super.setup(a);
   }
  
   // for supersimple mode...
   public static Actor clear(){
     return tos().clear();   
   }
   
   public static Actor add(String a,String b){
    return tos().add(a,b);  
   }
   
   public static Actor add(Button b){
     return tos().add(b);
   }
   
  static final ArrayList<Actor> a=new ArrayList<Actor>();
  //static final long serialVersionUID= 110860+1;
  static public void draw(){
    int i;
    
    Hud.begin2D(g);
    // go down to the next full screen
    for(i=a.size()-1;i>0;i--){
       if(a.get(i).fullscreen()) break;
    }
    
    // from there draw painters algorithm
    for(i=0;i<a.size();i++)
      if(i>=0)
        a.get(i).draw();
     Hud.end2D(g);
  }
  
  //oolean fullscreen(){return false;}
  
  static public boolean mousePressed(){
    if(!active()) return false;
    for(int i=a.size()-1;i>=0;i--){
      Actor ac=a.get(i);
      if(ac.mousePressed())
        return true;
      if(!ac.mouseInside()&&ac.autoClose)
      {
         pop();
         return true;
      }
      // pass to the receiver below.
    }
    return false;
   }
   
  
  // convenience, so keyboard could be private
 public static void keyPressed(char key,int keyCode){
   Keyboard.keyPressed(key, keyCode);
 }
  
  static public Actor tos(){ 
    // with no actor just create one?
    if(a.size()==0) push(new Actor());
    return a.get(a.size()-1);
    }
  
  static boolean active(){ return a.size()>0;}
  
  static public Actor pop(){ 
    Actor ca=tos(); 
    a.remove(a.size()-1);
    // if we had, a key consumer, it is no longer
    // visible
    Keyboard.hide();
    return ca;
  }
  
  static public void push(Actor ac){ 
    a.add(ac);
    Keyboard.hide();
    // or focus the first keyconsumer?
  }
}

