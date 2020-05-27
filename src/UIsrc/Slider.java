
package forU.I;
// 
import processing.core.PApplet;

public class Slider 
  extends Button
  // implements interact
  implements ControlableFloat // todo : adapter
{
  // readonly 
  public float value;

  public boolean logarithmic = false;

  private int sw, orgw;
  private float low, high, step;
  private int selsteps;

  public Slider(String txt) {
    this(txt, 0.0f);
  }
  public Slider() {
    this(0.0f);
  }

  public Slider(float init) {
    this("", init);
  }

  public Slider(String txt, Float init) {
    this(txt, null, init);
  }

  public Slider(String txt, String action) {
    this(txt, action, 0.0f);
  }

  public Slider(String txt, String action, int init, int l, int h) {
    this(txt, action, init*1.0f);
    range(l, h, 1);
  }

  public Slider(String txt, String action, Float init) {
    super(txt, action);
    value=init;
    orgw=w;

    setWidth(800);//width-ts); 
    step=0.0f;
    low=0.0f;
    high=1.0f;
    selsteps=1000;
  }

  public void setWidth(int _w) {
    w=_w;
    sw=w-tw-ts-ts;
  }

  public Slider range(float low, float high) {
    return range(low, high, 0.0f);
  }

  public Slider range(float low, float high, float step) {
    this.low=low;
    this.high=high;
    this.step=step;
    if (value<low) value= low;
    if (value>high) value= high;
    // if few steps, selector...
    // reduce width
    selsteps=PApplet.round((high-low)/step);
    if (selsteps<=8) {
      // recalc width
      sw=selsteps*(ts+ts/2);
      w=orgw+sw+ts+ts/2;
    }
    return this;
  }

  private ControlableFloat cont;
  // private int conti;

  public Slider bindTo(ControlableFloat _cont) {
    cont=_cont;
    if (cont!=null)
      value=cont.get();
    return this;
  }


  public void set(float x) {
    value=x;
    if (cont!=null) {
      cont.set(x);
    }
  }

  public float get() {
    return value;
  }

  public String displayText() {
    return txt.replace("#", PApplet.nf(value, 0, 0));
  }

  public void release() {
    super.mousePressed(); // signal end of drag, 
    // and trigger super action    
    super.release(); // sets dragging=false;
  }

  public boolean mousePressed()
  {
    dragging=true; // wait until end of interaction
    return true;
  }

  public void draw() {
    int ts2=ts/2;

    super.draw();
    int sb=x+tw+ts+ts2;
    g.fill(sbackcol);
    if (selsteps<=8) {
      //int step=round((high-low)/step);
      for (int i=0; i<=selsteps; i++)
      {
        marker(ts/3, sb, y, low+i*step);
      }
    } else {
      if (dragging)
        g.fill(dragcol);
      g.rect(sb, y+ts2, sw, ts2);
    }

    g.fill(smarkcol);//200);
    marker(ts2, sb, y, value);
  }

  float log(float x) {
    return PApplet.log(x);
  }

  float lmap(float val, float low, float high, 
    float b, float e) {
    if (logarithmic) {
      val = log(val);
      low = log(low);
      high= log(high);
    }
    int sp=(int)PApplet.map(val, low, high, 0, sw);
    return sp;
  }

  float emap(float val, float h, 
    float b, float e) {
    if (logarithmic)
    {
      // val=exp(val);
      e=PApplet.log(e);
      b=PApplet.log(b);
    };
    float sp=PApplet.map(val, 0, h, b, e);

    if (logarithmic) {
      sp = PApplet.exp(sp);
      //low = exp(low); // clamp?
      //high= exp(high);
    }
    return sp;
  }


  void marker(int ks, int sb, int y, float val) {

    int sp=(int)lmap(val, low, high, 0, sw);
    g.rect(sb+sp-ks/2, y+h/2-ks/2, ks, ks);
  }

  public void drag() {
    // x to slider space....
    // println("slider "+x);
    int sb=x+tw+ts+ts/2;
    int rx=me.mouseX-sb;

    if (rx>=0&&rx<=sw) {

      set(emap(rx, sw, low, high));
      if (step!=0.0) {
        int n=PApplet.round((value-low)/step);
        set(low+ step*n);
      }
    }
  }
}
