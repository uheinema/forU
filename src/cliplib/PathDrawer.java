
package PClipper;

import processing.core.PApplet;

import de.lighti.clipper.Path ;
import de.lighti.clipper.Paths ;
 
public interface PathDrawer{
  public void draw(Paths p, int mode) ;

  public void draw(Path pa, int mode) ;
  public void close();
  public final float k1000=100.0f ;// sic
}


/*
public class dings {
  public dings(){ 
    PApplet.println("bums");
  };
}
*/