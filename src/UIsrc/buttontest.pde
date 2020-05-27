

import forU.I.*;
import java.net.*;


Text tf=new Text("Enter \ue037");
///I wtf=new UI(this,56);

ColorPicker bgcolor;
PShader POISSON;

String
  q="printer/tool";

void connect() {
  octo.connect();
}

void octo() {
  octo.get(q);
}

Octo octo=new Octo();

MenuBar menu;
Switch showmenu;

void setup()
{
  //println("top setup");
  fullScreen(P3D);
  textSize(32);
  
  POISSON=loadShader("poissonFrag310.glsl", "FilterVert310.glsl" );

  new UI(this, 64);
  //Button.defaultBackcolor=color(233,44,55);
  bgcolor= new ColorPicker(color(230));
  showmenu = new Switch("Menu", "popup#1", true);
showR();
  // tf=new Text("Enter");
  //Actor a= UI.tos();// new Actor();
  menu=new MenuBar(" "+sketchName());
  menu.add("Hide menu", "popup#0")
    .add("Synth", "test")
    .add("octo", "octo")
    .add("connect", "connect")
    .add(showmenu)
    .add("background", "pick")
    .add("random","randomColorPicker");
  // if actions may take longer, they
  // should/may not run on the frontend thread
  // so @ aka schedule is used to run them
  // at start of next draw. poisson is a add on...
  UI.label("UI test").br()
     .add("choose", "showFileChooser")
   // .add("simple", "simple").br()
    .add("octo", "@octo")
    .add("connect", "@connect")
    .add("color", "pick")
    .add("synth", "test")
    .add("openUrl","openu")
    .add(showmenu)
    //  .add(bgcolor)
    .add(tf);
  addli(UI.tos());
  // new DragBack().show();
  menu.show(showmenu.state);
  UI.tos().ay+=3*UI.ts/2;
}

void openu(){
  UI.toast("open");
  link("https://github.com/dashboard");
}

void popup(int id) {
  if (id==0) showmenu.state=false;
  menu.show(showmenu.state);
  // menu.show(!menu.visible());
}

void pick() {
  bgcolor.show();
}

void randomColorPicker(){
  new ColorPicker(color(
    random(255),random(255),random(255)))
    .show();
}



Synth synth;

void test() {
  if (synth==null)
    synth=new Synth();
  synth.show();
}

void draw() {
  background(bgcolor.get());
  //+frameCount); // also nice
  textSize(150);
  fill((color)frameCount|0xff000000);
  text("frame "+frameCount+"\nEdit: "+
    tf.get(), 
    20, height/2);
  // a.align(CENTER);
  menu.setTitle(" "+sketchName()+"  -  frame "+frameCount); // not eorking..
}


/*
void mousePressed() {
 // if (UI.handledfPressed) return ;
 
  return;
}
*/

/*
  public void surfaceKeyDown(int code, android.view.KeyEvent event) {
    nativeKeyEvent(event);
   UI.flash("key "+hex(event.getUnicodeChar() ));
  }
*/

void keyPressed(KeyEvent ke) {
  UI.keyPressed(key, keyCode);
}

@Override void onBackPressed() {
 // UI.flash("ttfn");
  // UI.keyPressed((char)CODED, 4);
 //handledBackPressed=false;
  handledBackPressed=UI.handleBackPressed();
  // true;//false;
  // default false terminates
  // true continues!
}

