package forU.I;

import processing.core.*;

// public
abstract class I {

  // everything in forU.I will be 
  // a subclass of this, and as such 
  // can reffer me and g.

  static public PApplet me;
  static public PGraphics g;
  static public int ts=64;
  
  public static int defaultBackcolor =0xffffffff;
  public static int defaultSmarkcol = 0xffffff00;
  public static int defaultTextcolor =0xff000000;

  public static void setup(PApplet _me, int _ts) {
    setup(_me);
    ts=_ts;
    //  g.textSize(ts); // ??? no side effects,vplease!
  }

  public static void setup(PApplet _me) {
    me=_me;
    g=me.g;
  }

  public static void println(String s) {
    PApplet.println(s);
  }
}
