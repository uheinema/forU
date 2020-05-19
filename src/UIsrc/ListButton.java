
package forU.I;

import processing.core.*;
import processing.data.IntDict;

public class ListButton extends Button//Actor
  //extends IntDict ???
  //mplements Interact
{
  //    void setup(){
  //      bu.add("Hallo");
  //    }
  private IntDict di;
  public boolean extend=true;
  public int selline=0;

  public ListButton(String s, String a) {
    // title=s;
    super(s, a);
    h=ts*4+1;
    w=me.width-100;
    di=new IntDict();
  };

  public ListButton(String s,String a,String[] cont,int lines){
    this(s,a);
    setDict(cont);
    setLines(lines);
  }
  
  public ListButton(String s, String a, Object o) {
    // title=s;
    this(s, a);
    bind(o);
  };

  public ListButton(String s) {
    this(s, null);
  }

  public ListButton setSize(int wi, int he) {
    lines=PApplet.floor(he/ts);
    int hh=lines*ts;
    super.setSize(wi, hh);
    return this;
  }

  //    List setDict(IntDict _di,int lo){
  //      di=_di;
  //      lineofs=lo;
  //      // set this?
  //      selline=lineofs;//??
  //      return this;
  //    }

  public ListButton setDict(IntDict _di) {
    di=_di;
    // keep lineofs????
    lineofs=0;
    pixofs=0;
    selline=0;
    return this;
  }

   public ListButton setDict(String [] cont){
     di=new IntDict();
     int i=1;
     for(String s:cont){
      di.add(s,i++);
    }
    return setDict(di);
   }
   
  public IntDict getDict(){
    return di;
  }
   
  public ListButton setSelect(int i) {
    selline=i;
    if (selline<lineofs) {
      lineofs=0;
    }
    if (selline>lineofs+lines) {
      lineofs=selline;
    }
    return this;
  }

  public ListButton setSelect(String key) {
    int sl;
    if (key!=null&&di.hasKey(key)) {
      sl=di.index(key);
    } else
      sl=0;
    setSelect(sl);
    return this;
  }


  int get(int i) {
    return di.value(i);
  }

  int get(String s) {
    return di.get(s);
  }

  public ListButton setLines(int l) {
    lines=l;
    h=lines*ts;
    return this;
  }

  private 
  
  int lines=1;
  int dragStart,dragsx;
  int lineofs=0;
  int xoffs=0;
  
  @Override
  public void drawFront() {
    int line=-1;
    int cy=0;

    g.fill(0);
    g.textAlign(LEFT, TOP);
    g.textSize(ts);
    g.text(txt, x+20, y+cy);
    
    cy+=ts;
    g.pushStyle();
    g.pushMatrix();
    g.imageMode(CORNER);
    g.clip(x, y+cy, w, h-cy);
    //    println("list: "+lines);
    for (line=-1; line<lines+1; line++) {              
    //  g.fill(222);   
      String lt="";
      int ll=line+lineofs;
      if (ll<di.size()&&ll>=0) {
        lt=di.key(ll);
        if (ll==selline) {
          g.fill(0);
          g.rect(x, y+cy+pixofs-ts, w, ts);
          g.fill(200);
        } else
          g.fill(textcol);
        g.text(lt, x-xoffs+20, y+cy+pixofs-ts);
      }
      cy+=ts;
      if (cy-ts>h) break;
    }
    g.clip(0, 0, me.width, me.height);
    g.popStyle();
    g.popMatrix();
  }

  private int pixofs;

  public void drag() {
    if (!dragging) return; // never?
    int dragDist=me.mouseY-dragStart;
    int dragDistx=me.mouseX-dragsx;
    //dragStart=
    int dl=PApplet.round(dragDist/ts);
    if (dl!=0) {
      dragged=true;
    }
    xoffs=clamp(xoffs-dragDistx,0,10000);
    dragsx+=dragDistx;
    if (lineofs<=0&&dragDist>0) {
      dragDist=0; 
      dl=0;
    }
    if (lineofs+lines-1>=di.size()&&dragDist<0) {
      dl=0;
      dragDist=0;
    }
    lineofs-=dl;    
    dragStart+=ts*dl;

    // else  dragDist=0; // lock whole lines
    pixofs=dragDist%ts;     
    super.drag();//??
  }

  int clamp(int i, int mi, int ma) {
    if (i>ma)return ma;
    else if (i<mi)return mi;
    return i;
  }

  @Override
   public boolean mousePressed()
  {
    dragging=true; // wait until end of interaction
    dragStart=me.mouseY;
    dragsx=me
    .mouseX;
    dragged=false;
    //  pixofs=0;

    return true;
  }

  private boolean dragged=false;

  @Override
    void release() {
    super.release();
    // pixofs=0;
    //  println("rel ",lines);
    if (!dragged) {
      // only do this on clicks
      if (h<=ts) {
        h=lines*ts;
       // PApplet.println("extend");
      } else {
        int ly=me.mouseY-y-pixofs;
        ly/=ts;

        if (ly!=0) {     
          selline=ly+lineofs-1;
          act(ly+lineofs);
        } else {
          act(-1);
        if (extend)
            h=ts; // collapse
        }
      }
    }
    dragged=false;
  }
  
  public ListButton collapse(boolean small){
    if(small)
      h=ts;
    else
      h=lines*ts;
    return this;
  }
}
