///
///

package forU.I;

///mport ketai.ui.KetaiKeyboard;

import forU.I.Keyboard;

import java.util.*;

import processing.core.PApplet; 
// for convenience
import android.widget.Toast;
//mport android.app.Activity;
import processing.event.MouseEvent;

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
  public UI(PApplet a, int ts) {
    super.setup(a, ts);
    me.registerMethod("draw", this);
    me.registerMethod("mouseEvent", this);
  }

  public UI(PApplet a) {
    super.setup(a);
    me.registerMethod("draw", this);
    me.registerMethod("mouseEvent", this);
  }

  public static void println(String s) {
    PApplet.println(s);
  }
  // Processing is calling this last, so
  // the main applett mousePressed has already happened
  // no, thid is only true for keys
  // or so one mightbthink....
  // 
  public void mouseEvent(MouseEvent event) {
   
    switch (event.getAction()) {

    case MouseEvent.PRESS: 
      // these events happen on a thread which may not
      // have eg. network allowance..   
      if (!ignorePressed)       
        mousePressed(); 
      ignorePressed=false;

      // how can we remove this event?
      break;
    }
  }

  // for supersimple mode...
  // UI vs. Actor is like
  // PApplet vs. g
  // Pass through a few naive calls

  public static Actor clear() {
    return tos().clear();
  }

  public static Actor nl() {
    return tos().nl();
  }

  public static Actor label(String t) {
    return tos().label(t);
  }

  public static Actor add(Button b) {
    return tos().add(b);
  }

  public static Actor add(String t, String a) {
    return tos().add(t, a);
  }

  public static Actor align(int how) {
    return tos().align(how);
  }

  // hide/show???
  static boolean visible=true;
  public static void hide() {
    visible=false;
  }

  public static void show() {
    visible=true;
  }
  
  // isLooping() is broken so:
  // suoerflous, as long as redraw acts up
  static boolean looping=true;
  public static void loop() {
    looping=true;
    me.loop();
  }
  
  public static void noLoop() {
    looping=false;
    me.noLoop();
  }
  
  static public boolean isLooping(){
    return looping;
  }
  
  
  static final ArrayList<Actor> a=new ArrayList<Actor>();

  //static final long serialVersionUID= 110860+1;
  static public void draw() {
    int i;
    react();// or do this on post() or(pre)??
    if (!visible) return;
    Hud.begin2D(g);
    // go down to the next full screen
    for (i=a.size()-1; i>0; i--) {
      if (a.get(i).fullscreen()) break;
    }

    // from there draw painters algorithm
    for (; i<a.size(); i++)
      if (i>=0)
        a.get(i).draw();
    Hud.end2D(g);
  }

  public static void schedule(Button bu) {
    reactor=bu;
  }

  static private Button reactor;

  static void react()
  {
    if (reactor!=null) {  
      reactor.act(reactor.action.substring(1));
      reactor=null;
    }
  }  

  static public boolean ignorePressed=false;

  static public boolean mousePressed() {
    // called by
    // Api: so the listener must ignore
    // the next (i.e this) press following
    ignorePressed=true;
    // when called by the listener, it should reset this
    // 
    if (!active()) return false;
    for (int i=a.size()-1; i>=0; i--) {
      Actor ac=a.get(i);
      if (ac.mousePressed())
        return true;
      if (!ac.mouseInside()&&ac.autoClose)
      {
        pop();
        return true;
      }
      // pass to the receiver below.
    }
    return false;
  }


  // convenience, so keyboard could be private
  public static void keyPressed(char key, int keyCode) {
    Keyboard.keyPressed(key, keyCode);
  }

  static public Actor tos() { 
    // with no actor just create one?
    if (a.size()==0) push(new Actor());
    return a.get(a.size()-1);
  }

  static boolean active() { 
    return visible
    &&a.size()>0&&
    !tos().fullscreen();
  }

  static public boolean handleBackPressed() {
    if (active()) pop();
    return active();
    // todo: handle dragback etc.
  }


  static public Actor pop() { 
    Actor ca=tos(); 
    a.remove(a.size()-1);
    // if we had, a key consumer, it is no longer
    // visible
    Keyboard.hide();
    return ca;
  }

  static public void push(Actor ac) { 
    if (a.contains(ac)) {
      // pull to top??
      int i = a.indexOf(ac);
      a.remove(i);
    }
    a.add(ac);
    Keyboard.hide();
    // or focus the first keyconsumer?
  }



  static class Toaster implements Runnable {
    String t;
    int l;
    PApplet me;
    Toaster(PApplet _me, String _t, int _l) {
      me= _me;
      t=_t;
      l=_l;
    }
    public void run() {
      Toast.makeText(me.getActivity(), 
        t, l).show();
    }
  }

  public static void toast(String msg) {
    me.getActivity().runOnUiThread(new Toaster(me, msg, 1));
  }
  public static void flash(String msg) {
    me.getActivity().runOnUiThread(new Toaster(me, msg, 0));
  }
}
