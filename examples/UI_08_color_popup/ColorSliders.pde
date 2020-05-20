
import forU.I.*;

class ColorSliders extends Actor {

  Slider cr, cg, cb; // color sliders
  Switch follow;
  Button clip;

  // they look alike, so 
  Slider createColorSlider(String t) {
    Slider s=new Slider(t+" # ", "colChange", 0f)
      .range(0, 255, 1f);
     s.bind(this); // colChange is local,
     // not in the main applet
     return s;
  }

  color col= 0xffbbbbbb;


  ColorSliders(String name,color bc,float x,float y) {
    super((int)x,(int)y,600,400);//fullScreen(P3D)
    autoClose=true;
    createColorSliders();
    addColorSliders(name);
    set(bc);
  }

  void set(color bc) {
    col=bc;
    cr.value=red(bc);
    cg.value=green(bc);
    cb.value=blue(bc);
  }

  color get() {
    if (follow.state) colChange();
    return col;
  }

  void createColorSliders() {
    
    cr=createColorSlider("R");
    cg=createColorSlider("G");
    cb=createColorSlider("B");
    follow=new Switch("Follow" ,true);
    clip=new Button("clip","clip",this);
  }

  private void addColorSliders(String name) {
    this
      .label(name).br()
      .add(follow).add(clip)
      .add(cr)
      .add(cg)
      .add(cb)
      ;
  }
  
  import android.content.ClipData;
import android.content.ClipboardManager;
import android.content.ClipDescription;
import android.content.Context;
import android.app.Activity;
import android.os.Looper;


  
  void clip(){
    String str="0x"+hex(col)+
      " ; // color("+
      (int)cr.value+","+
      (int)cg.value+","+
      (int)cb.value+");";
    UI.toast(str);
    setClip(str);
  }
  
  

  void colChange() {
    col=color(cr.value, cg.value, cb.value);
  }
}
