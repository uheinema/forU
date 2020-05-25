/*

  MENU
  
*/


import forU.I.*;


ColorPicker bgcolor;

MenuBar menu;
Switch showmenu;

void setup()
{
  fullScreen(P3D);
  textSize(32);

  new UI(this, 50);
  //Button.defaultBackcolor=color(233,44,55);
  bgcolor= new ColorPicker(color(230));
  showmenu = new Switch("Menu", "popup#1", true);
  menu=new MenuBar(" "+sketchName());
  menu.add("Hide menu", "popup#0")
    .add("Synth", "isizer")
    .add("BackColor", "pick")
    .add("Random color","randomColorPicker")
    .add("forU on GitHub","openu");
  // if actions may take longer, they
  // should/may not run on the frontend thread
  // so @ aka schedule is used to run them
  // at start of next draw.
  UI
    .nl() // room for the menu
    .label("UI test").br()
    .add("Backcolor", "pick")
    .add("Synth", "isizer")
    .add("Open forU","openu")
    .add(showmenu);
 
  menu.show(showmenu.state);
  
}

void openu(){
  UI.toast("open");
  link("https://github.com/uheinema/forU");
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

void isizer() {
  if (synth==null)
    synth=new Synth();
  synth.show();
}



void draw() {
  background(bgcolor.get());
  textSize(150);
  fill((color)frameCount|0xff000000);
  text("frame "+frameCount, 20, height/2);
  menu.setTitle(" "+sketchName()+"  -  frame "+frameCount); // not eorking..
}
  
// PApplet magic...

@Override void onBackPressed() {
  handledBackPressed=UI.handleBackPressed();
  // so popups get closed before we really leave.
}

String sketchName() {
  return this.getClass().getSimpleName();
}
