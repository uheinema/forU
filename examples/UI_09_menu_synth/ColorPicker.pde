
import forU.I.*;

// the ORIGINAL! created long before forU

public class ColorPicker extends Actor {
  Slider sr, sg, sb, sa;
  Button cfield;
  private color c;

  public ColorPicker(color _c) {
    this(_c, 200, 500);
  }
  public ColorPicker() {
    this(color(12, 8, 60), 200, 500);
  }
  public ColorPicker(color _c, int x, int y) {
    super(x, y, 50, 55);
    autoClose=true;
    init();
    set(_c);
    // align(CENTER);
  }  

  public color get() {
    return c;
  };

  public void set(color _c) {
    c=_c;
    sr.value=red(c);
    sg.value=green(c);
    sb.value=blue(c);
    sa.value=alpha(c);
  }

  private void init() {
    // create ui elements

    sr=new Slider("r # ");
    sr.range(0.0, 255.0, 1.0);
    sg=new Slider("g # ");
    sg.range(0, 255, 1.0);
    sb=new Slider("b # ");
    sb.range(0, 255, 1.0);
    sa=new Slider("a # ");
    sa.range(0, 255, 1.0);

    add(sr).add(sg).add(sb);
    add("");
    cfield=last();
    cfield.setSize(200+ts, 200+ts);
  }

  public void draw() {
    // align(BOTTOM);
    c=color(sr.value, sg.value, sb.value, sa.value);   
    cfield.backcolor=c;
    super.draw();
  }
}
