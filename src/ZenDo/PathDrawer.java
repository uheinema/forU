
package forU.ClipDraw;

//mport processing.core.PApplet;
 import de.lighti.clipper.Paths ;
 import de.lighti.clipper.Path ;
public interface PathDrawer{
  public void draw(Paths p, int mode) ;

  public void draw(Path pa, int mode) ;
  public void close();
  public final float k1000=100.0f ;// sic
}
