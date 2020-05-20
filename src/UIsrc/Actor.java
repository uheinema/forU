
package forU.I;

import processing.core.PApplet;
import java.util.*;



public class Actor extends Button
  // implements Interact 
{

  // PGraphics dc;
  int ax=ts/2;
  int ay=ts/2;
  int aw=me.width-ts;
  int ah=me.height-ts;
  public boolean back=false;

  ArrayList<Button> buttons=new ArrayList<Button>();

  public Actor(int _x, int _y, int _width, int _height) {
    ax=_x;
    ay=_y;
    aw=_width;
    ah=_height;
    back=ax!=0;
  }


  // DOWN+LEFT == UP+RIGHT:
  // and BOTTOM+LEFT == TOP+RIGHT ...

  public float textHeight() {
    return ts;
  }

  public float height() {
    return ah;
  }

  public Actor align(int where)
  {
    // should use its container...ahbah
    //  PApplet.println("align: "+where);
    switch (where) {

    case TOP : 
      ay=ts/2; // 10n ...
      break;
    case BOTTOM: // 102
      ay=me.height-ah-70;
      break;
      // these are 
      // static final int RIGHT = KeyEvent.KEYCODE_DPAD_RIGHT;
      // now really...
    case RIGHT: 
      ax= me.width-aw; // some border reserve?
      break;
    case LEFT: 
      ax=ts/2;
      break;
    case CENTER: // horizontal, 3 ...
      ax= me.width/2-aw/2;
      break;
    case NORMAL:
      //  case BASELINE:
    case 0:
      // Vertical center .. BASELONE ==0 btw...
      // and this is a problem
      // as baseline+center== center
      ay= me.height/2-ah/2;
      break;

      /// no way combining these..
      //    case TOPRIGHT: // prima, == BOTTOM+LEFT
      //      align(TOP);
      //      align(RIGHT);
      //      break;
      //    case TOP+LEFT:
      //      align(TOP);
      //      align(LEFT);
      //      break;
      //    case TOP+CENTER:
      //      align(TOP);
      //      align(CENTER);
      //      break;
      //
      //    case BOTTOM+LEFT:
      //  
      //      align(BOTTOM);
      //      align(LEFT);
      //      break;
      //    case BOTTOM+CENTER:
      //    case DOWN+CENTER:
      //      align(BOTTOM);
      //      align(CENTER);
      //      break;
      //    case BOTTOM+RIGHT:
      //    case DOWN+RIGHT:
      //      align(BOTTOM);
      //      align(RIGHT);
      //      break;
    default:
      throw new IllegalArgumentException("Only simple align for align, please, what is "+where);
    }
    return this;
  }

  public Actor() {
    back=false;
  }

  public boolean autoClose=false;
  public boolean fixed=false;

  public boolean show() {
   // PApplet.println("actor acts");
    UI.push(this);
    return true;
  }
  public boolean act() { // catch backward comp
    show();
    return true;
  }

  void hide() {
    UI.pop(); // ourself away..
  }

  public Actor add(Button button) {
    // button.g=g;
    buttons.add(button);
    return this;
  }

  public Actor add(String name) { // label??
    return this.add(new Button(name, null));
  }

  public Actor add(String name, Boolean init) {
    return this.add(new Switch(name, init));
  }

  public Actor add(String text, String action) {
    return this.add(new Button(text, action));
  }
  public Actor add(String text, String action, int param) {
    return this.add(new Button(text, action, param));
  }

  public Actor add(String text, String action, Object param) {
    return this.add(new Button(text, action, param));
  }
  public Actor clear() {
    buttons.clear();
    return this;
  }

  int clamp(int x, int mi, int ma) {
    if (x<mi) return mi;
    if (x>ma) return ma;
    return x;
  }

  private boolean dragging=false;
  private int dsx, dsy;

  void handleDrag() {

    ax+=me.mouseX-dsx;
    dsx=me.mouseX;
    ay+=me.mouseY-dsy;
    dsy=me.mouseY;
    ax=clamp(ax, ts/2, me.width-(aw-ts));
    ay=clamp(ay, ts/2, me.height-(ah-ts));
  }

  @Override
    public boolean mouseInside()
  {
    return mouseInside4(ax, ay, aw, ah);
  }

  public void draw()
  {
    int x=ax;
    int y=ay;

    int lh= 0;


    if (dragging) {
      if (me.mousePressed )//&& mouseInside4(ax,ay,aw,ah))
        handleDrag();
      else {
        // if(!mousePressed)
        dragging=false;
      }
    }

    // begin2D(g); in actorstack now..
    if (back) {
      g.stroke(255);
      //g.noStroke();
      g.fill(10, 100, 130, 250); 
      Rect(ax-ts/2, ay-ts/2, aw+ts, ah+ts);  
      g.flush();
    }
    int n=buttons.size();
    int mx=0;
    // println(n);
    for (int i = 0; i < n; i++) {
      Button b = buttons.get(i);
      if (b.fx>0) {  // fixed placement

        b.draw();

        continue;
      }
      if (b.w+x-ax>aw) { // no room on line?
        x=ax;
        y+=lh+ts/2;
        ;
        lh=0;
      }

      b.setPos(x, y);
      b.draw(); 
      x+=b.eff_w();
      mx=PApplet.max(x, mx);
      lh=PApplet.max(lh, b.h);
    }
    y+=lh;
    // if(y-ay>ah) 
    if (!fixed) {
      ah=y-ay;
      // if(mx-ax>aw)
      aw=mx-ax;
    } else
      fixed=true;
    //end2D(g);
  }

  public Button last() { 
    return buttons.get(buttons.size()-1);
  }

  public boolean mousePressed() {
    int n=buttons.size();
    for (int i = 0; i < n; i++) {
      Button b = buttons.get(i);
      if (b.mouseInside())  
        return b.mousePressed();
    }
    if (mouseInside()) {
      // start dragging
      dragging=true;
      dsx=me.mouseX; 
      dsy=me.mouseY;
      return true;
      // fraglich fuer mainwindpe
      // sollte abet eh nicht so voll sein
    }
    return false;
  }
  
  public class Break extends Button {
    @Override
    public void draw()
    {
      // invisible
    }
    Break() {
      super("", "");
      w=1000;
    };
    public int eff_w() { 
      return 0;
    }
  }

  public Actor br() {
    this.add(new Break());
    return this;
  }
  
  public Actor nl() {
    this.add(new Nl());
    return this;
  }
  
  public Actor label(String t) {
    this.add(new Label(t));
    return this;
  }
  
  public class Nl extends Button {
    @Override
    public void draw()
    {
      // invisible
      // println("brk draw x="+x+" y="+y);
    }
    
    Nl() {
      super("","");
      w=1000;
    };
    
  
}

public class Label extends Button {
  
   @Override
   public void drawBack(){;};
    
    Label(String t) {
      super(t, "");
      textcol=0xff999999; // todo
    };
}


@Deprecated
  public Actor place(Button b, int x, int y)
  {
    this.add(b);
    b.fx=x;
    b.fy=y;
    b.x=x+ax;
    b.y=y+ay;
    return this;
  }
}
